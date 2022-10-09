unit unitcashreport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, Menus, Buttons;

type

  { TFormCashReport }

  TFormCashReport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miDelete: TMenuItem;
    miReturnEgais: TMenuItem;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miReturnEgaisClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    startDate:TdateTime;
    endDate:TdateTime;
    flRowSelect:integer;
    procedure RefreshTrans();
  end;

var
  FormCashReport: TFormCashReport;

implementation

{$R *.lfm}
uses
  DOM,
  XMLRead,
  typinfo,
  unitstart,
  unitfilter,
  unitpdf417,
  unitsalesbeer;
{ TFormCashReport }

function getshiftcash():string;
var                // вычисляем смену количество дней прошедших от 2016-01-01
 year,month,day:word;
begin
 year:=0;
 month:=0;
 day:=0;
 DecodeDate(now(),year,month,day);
 year:=year-2016;
 result:=inttostr( year*12*32+month*32+day);
end;

procedure TFormCashReport.RefreshTrans();
var
  linend:integer;
  query:string;
begin

  Stringgrid1.RowCount:=1;
  query:='SELECT `numdoc`,`datedoc`,`urlegais`,`datetrans`,`typetrans`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `name`,`eanbc`,(SELECT `alcVolume` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `alcvolume`,(SELECT `productVCode` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `productVCode`,`quantity`,`price` FROM `doccash` WHERE `datedoc`="'
  +FormatDateTime('YYYY-MM-DD',startDate)+'";'; // AND (`typetrans`="11" OR `typetrans`="13") GROUP BY `urlegais`;' ;
  formStart.recbuf:=formStart.DB_query(  query ,'doccash' );
  formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
  while formStart.rowbuf<>nil do begin
    linend:= Stringgrid1.RowCount;
    Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
    Stringgrid1.Cells[1,linend]:=formStart.rowbuf[0];
    Stringgrid1.Cells[2,linend]:=formStart.rowbuf[1];
    Stringgrid1.Cells[3,linend]:=formStart.rowbuf[3];
    Stringgrid1.Cells[4,linend]:=formStart.rowbuf[4];
    Stringgrid1.Cells[5,linend]:=formStart.rowbuf[5];
    Stringgrid1.Cells[6,linend]:=formStart.rowbuf[6];
    Stringgrid1.Cells[7,linend]:=formStart.rowbuf[2];
    Stringgrid1.Cells[8,linend]:=format('%0.2f',[formstart.StrToFloat(formStart.rowbuf[10])]);
    Stringgrid1.Cells[9,linend]:=formStart.rowbuf[9];
    Stringgrid1.Cells[10,linend]:=formStart.rowbuf[8];
    Stringgrid1.Cells[11,linend]:=formStart.rowbuf[7];

    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
  end;

end;

procedure TFormCashReport.FormShow(Sender: TObject);
begin
  startDate:=now();
  endDate:=now();
  RefreshTrans();
end;

procedure TFormCashReport.MenuItem2Click(Sender: TObject);
 // ==== Данная операция опасна!!!
var
  strNumCheck:string;
  lists:TStringList;
  b,p,
  sAlcCode:String;
  aStr:String;
  S : TStringStream;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  url,sign,strerror:string;
  res:integer;
  query:string;
begin
  // ===== Опасная операция =======
  if flRowSelect<=0 then
    exit;
  if StringGrid1.Cells[6,flRowSelect]='' then begin
    sAlcCode:='';
    FormStart.DecodeEGAISPlomb(trim(StringGrid1.Cells[7,flRowSelect]),sAlcCode,b,p);
      query:='SELECT `barcodes` FROM `sprgoods` WHERE `extcode`="'+sAlcCode+'"; ';
      formStart.recbuf:=formstart.DB_query(query);
      formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
      if formStart.rowbuf <>nil then begin
        StringGrid1.Cells[6,flRowSelect]:=formStart.rowbuf[0];
      end else
       begin
         ShowMessage('Нет штрихкода для данного товара. Исправьте в справочнике товара, а после попробуйте еще раз.');
         exit;
       end;
    end;
  res:=MessageDlg('Уверены что требуется отправить в ЕГАИС?',mtWarning,[ mbYes, mbNo],0);
  if res <> 6 then
    exit;
  lists:=TStringList.create();
  FormSalesBeer.flNumcheck:=strtoint(formStart.GetConstant('LastNumCheck'))+2;
  strNumCheck:=inttostr(FormSalesBeer.flNumcheck);
  sAlcCode:='';
  lists.Clear;
  lists.Add('<?xml version="1.0" encoding="UTF-8"?>');
  lists.Add('<Cheque');
  lists.Add('inn="'+formStart.FirmINN+'"');
  lists.Add('datetime="'+FormatDateTime('DDMMYYhhmm',now())+'"');
  lists.Add('kpp="'+formStart.firmKPP+'"');
  lists.Add('kassa="'+formStart.prefixClient+'"');
  lists.Add('address="'+formStart.FirmAddress+'"');
  lists.Add('name="'+formStart.FirmFullName+'"');
  lists.Add('number="'+strNumCheck+'"');
  lists.Add('shift="'+getshiftcash()+'"');
  lists.Add('>');

     if thisBeer(StringGrid1.Cells[10,flRowSelect]) then begin
           // ==== это пиво
        //<nopdf code="258" bname="Клинское светлое"  volume="0.1" alc="0.1" price="0.50" ean="46054060129760" count="2" />
//        FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'11','0','-1',trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[6,flRowSelect]),sAlcCode,'');
        lists.Add('<nopdf code="'+StringGrid1.Cells[10,flRowSelect]+'" bname="'+trim(StringGrid1.Cells[1,flRowSelect])+'" volume="'+trim(StringGrid1.Cells[9,flRowSelect])+'" alc="'+trim(StringGrid1.Cells[11,flRowSelect])+'" price="'+trim(StringGrid1.Cells[3,flRowSelect])+'" ean="'+trim(StringGrid1.Cells[6,flRowSelect])+'" count="1" />');
        end
      else begin
       FormStart.DecodeEGAISPlomb(trim(StringGrid1.Cells[7,flRowSelect]),sAlcCode,b,p);
//       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'11','0','-1',trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[6,flRowSelect]),sAlcCode,trim(StringGrid1.Cells[7,flRowSelect]));
       lists.Add('<Bottle barcode="'+trim(StringGrid1.Cells[7,flRowSelect])+'" ean="'+trim(StringGrid1.Cells[6,flRowSelect])+'" price="'+trim(StringGrid1.Cells[8,flRowSelect])+'" volume="'+trim(StringGrid1.Cells[11,flRowSelect])+'"  />');
      end;
  lists.Add('</Cheque>');
  aStr:= formStart.SaveToServerPOST('xml',lists.Text) ;  // отправляем в егаис и ждем ответа
  url:='';
  sign:='';
  strerror:='';
   if length(aStr)<>0 then // == получен ответ от егаис =====
   begin
     S:= TStringStream.Create(aStr);
     Try
       S.Position:=0;
     // Обрабатываем полученный файл
       XML:=Nil;
       ReadXMLFile(XML,S); // XML документ целиком
     Finally
       S.Free;
     end;
     Child :=XML.DocumentElement.FirstChild;
     while Assigned(Child) do begin

       if Child.NodeName = 'url' then begin
          url:=Child.FirstChild.NodeValue;
       end;
       if Child.NodeName = 'sign' then begin
          sign:=Child.FirstChild.NodeValue;
       end;
        if Child.NodeName = 'error' then begin
          strerror:=Child.FirstChild.NodeValue;
       end;
       Child:=Child.NextSibling;
     end;
   end;
   // ====== тестовое сообщение ========
  // если в ответе нет ссылки то url будет пуст
   if url<>'' then  begin  // пришел URL обрабатывае как положено
       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'40','0','1',StringGrid1.Cells[8,flRowSelect],StringGrid1.Cells[8,flRowSelect],'',sign,url);
       formStart.SetConstant('LastNumCheck',strNumCheck);
          showmessage('ЕГАИС вернул ссылку:'+url);

    end else begin  // == иначе фиксируем ошибку в журнале
        // ====== не удаляем товар пока не будет ясно что с ним!!! =====
      showmessage(aStr);
       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'240','0','1','0','0','',sign,aStr);
       formStart.SetConstant('LastNumCheck',strNumCheck);
       ShowMessage('Ошибка при передаче данных в ЕГАИС! Отложите товар до разбирательств!');
   end;
  inc(FormSalesBeer.flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис

  lists.free;
end;

procedure TFormCashReport.miDeleteClick(Sender: TObject);
var
  res:integer;
   query:string;
begin
  // ===== Удаляем выбранную позицию из журнала продаж
  if flRowSelect<=0 then
    exit;
  res:=MessageDlg('Уверены что требуется удалить?',mtWarning,[ mbYes, mbNo],0);
  if res = 6 then begin
    query:='DELETE FROM `doccash` WHERE `numdoc`="'+StringGrid1.Cells[1,flRowSelect]+'" AND `datedoc`="'+StringGrid1.Cells[2,flRowSelect]+'" AND `urlegais`="'+StringGrid1.Cells[7,flRowSelect]+'" LIMIT 1 ;';
    FORMStart.DB_query(Query);
  end;

end;

procedure TFormCashReport.miReturnEgaisClick(Sender: TObject);
var
  strNumCheck:string;
  lists:TStringList;
  b,p,
  sAlcCode:String;
  aStr:String;
  S : TStringStream;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  url,sign,strerror:string;
  res:integer;
  query:string;
begin
  if flRowSelect<=0 then
    exit;
  if StringGrid1.Cells[6,flRowSelect]='' then begin
    sAlcCode:='';
    FormStart.DecodeEGAISPlomb(trim(StringGrid1.Cells[7,flRowSelect]),sAlcCode,b,p);
      query:='SELECT `barcodes` FROM `sprgoods` WHERE `extcode`="'+sAlcCode+'"; ';
      formStart.recbuf:=formstart.DB_query(query);
      formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
      if formStart.rowbuf <>nil then begin
        StringGrid1.Cells[6,flRowSelect]:=formStart.rowbuf[0];
      end else
       begin
         ShowMessage('Нет штрихкода для данного товара. Исправьте в справочнике товара, а после попробуйте еще раз.');
         exit;
       end;
    end;
  res:=MessageDlg('Уверены что требуется удалить?',mtWarning,[ mbYes, mbNo],0);
  if res <> 6 then
    exit;
  lists:=TStringList.create();
  FormSalesBeer.flNumcheck:=strtoint(formStart.GetConstant('LastNumCheck'))+2;
  strNumCheck:=inttostr(FormSalesBeer.flNumcheck);
  sAlcCode:='';
  lists.Clear;
  lists.Add('<?xml version="1.0" encoding="UTF-8"?>');
  lists.Add('<Cheque');
  lists.Add('inn="'+formStart.FirmINN+'"');
  lists.Add('datetime="'+FormatDateTime('DDMMYYhhmm',now())+'"');
  lists.Add('kpp="'+formStart.firmKPP+'"');
  lists.Add('kassa="'+formStart.prefixClient+'"');
  lists.Add('address="'+formStart.FirmAddress+'"');
  lists.Add('name="'+formStart.FirmFullName+'"');
  lists.Add('number="'+strNumCheck+'"');
  lists.Add('shift="'+getshiftcash()+'"');
  lists.Add('>');

     if thisBeer(StringGrid1.Cells[10,flRowSelect]) then begin
           // ==== это пиво
        //<nopdf code="258" bname="Клинское светлое"  volume="0.1" alc="0.1" price="0.50" ean="46054060129760" count="2" />
        FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'11','0','-1',trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[6,flRowSelect]),sAlcCode,'');
        lists.Add('<nopdf code="'+StringGrid1.Cells[10,flRowSelect]+'" bname="'+trim(StringGrid1.Cells[1,flRowSelect])+'" volume="'+trim(StringGrid1.Cells[9,flRowSelect])+'" alc="'+trim(StringGrid1.Cells[11,flRowSelect])+'" price="-'+trim(StringGrid1.Cells[3,flRowSelect])+'" ean="'+trim(StringGrid1.Cells[6,flRowSelect])+'" count="1" />');
        end
      else begin
       FormStart.DecodeEGAISPlomb(trim(StringGrid1.Cells[7,flRowSelect]),sAlcCode,b,p);
       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'11','0','-1',trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[8,flRowSelect]),trim(StringGrid1.Cells[6,flRowSelect]),sAlcCode,trim(StringGrid1.Cells[7,flRowSelect]));
       lists.Add('<Bottle barcode="'+trim(StringGrid1.Cells[7,flRowSelect])+'" ean="'+trim(StringGrid1.Cells[6,flRowSelect])+'" price="-'+trim(StringGrid1.Cells[8,flRowSelect])+'" volume="'+trim(StringGrid1.Cells[11,flRowSelect])+'"  />');
      end;
  lists.Add('</Cheque>');
  aStr:= formStart.SaveToServerPOST('xml',lists.Text) ;  // отправляем в егаис и ждем ответа
  url:='';
  sign:='';
  strerror:='';
   if length(aStr)<>0 then // == получен ответ от егаис =====
   begin
     S:= TStringStream.Create(aStr);
     Try
       S.Position:=0;
     // Обрабатываем полученный файл
       XML:=Nil;
       ReadXMLFile(XML,S); // XML документ целиком
     Finally
       S.Free;
     end;
     Child :=XML.DocumentElement.FirstChild;
     while Assigned(Child) do begin

       if Child.NodeName = 'url' then begin
          url:=Child.FirstChild.NodeValue;
       end;
       if Child.NodeName = 'sign' then begin
          sign:=Child.FirstChild.NodeValue;
       end;
        if Child.NodeName = 'error' then begin
          strerror:=Child.FirstChild.NodeValue;
       end;
       Child:=Child.NextSibling;
     end;
   end;



   // ====== тестовое сообщение ========
  // если в ответе нет ссылки то url будет пуст
   if url<>'' then  begin  // пришел URL обрабатывае как положено
       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'40','0','1',StringGrid1.Cells[8,flRowSelect],StringGrid1.Cells[8,flRowSelect],'',sign,url);
       formStart.SetConstant('LastNumCheck',strNumCheck);
          showmessage('ЕГАИС вернул ссылку:'+url);

    end else begin  // == иначе фиксируем ошибку в журнале
        // ====== не удаляем товар пока не будет ясно что с ним!!! =====
       FormSalesBeer.addtrans(formStart.prefixClient,strNumCheck,'240','0','1','0','0','',sign,aStr);
       formStart.SetConstant('LastNumCheck',strNumCheck);
       ShowMessage('Ошибка при передаче данных в ЕГАИС! Отложите товар до разбирательств!');
   end;
  inc(FormSalesBeer.flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис

  lists.free;
  //FormSalesBeer.addtrans();
end;

procedure TFormCashReport.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin
  if StringGrid1.Cells[4,aRow]='240' then begin

  if not (gdFixed in aState) then // si no es el tituloŽ
  if not (gdSelected in aState) then
    begin
    (Sender as TStringGrid).Canvas.Brush.Color:=Colores[aRow mod 4];
    end
  else
    begin
    (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 4];
    (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
    //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
    end;

  //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
  (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);
  end;
//  if StringGrid1.Cells[4,aRow]='40' then begin

//  if not (gdFixed in aState) then // si no es el tituloŽ
//  if not (gdSelected in aState) then
//    begin
//    (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[aRow mod 4];
//    end
////  else
//    begin
//    (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 4];
//    (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
    //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
//    end;

  //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
//  (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);
//  end;
end;

procedure TFormCashReport.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  flRowSelect:= aRow;
end;

procedure TFormCashReport.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormCashReport.FormCreate(Sender: TObject);
begin
  startDate:=now();
  endDate:=now();
end;

procedure TFormCashReport.BitBtn1Click(Sender: TObject);
begin
  if FormFilter.ShowModal = 1377 then begin
    startDate:= FormFilter.StartDate;
    endDate  := FormFilter.EndDate;
    Caption:='Управление журналом продаж в розницу с '+FormatDateTime('DD-MM-YYYY',StartDate)+' по '+FormatDateTime('DD-MM-YYYY',endDate)+'';
    RefreshTrans();
  end;
end;

procedure TFormCashReport.BitBtn2Click(Sender: TObject);
var
  sPDF417:string;
  focusrow:integer;
begin
  // ==== Запрашиваем марку и отображаем продажи ====
  StringGrid1.SetFocus;
  sPDF417:=Formgetpdf417.GetProducer();

  if length(sPDF417)>13 then
  begin
    formStart.recbuf:=formstart.DB_query('SELECT `datedoc` FROM `doccash` WHERE UPPER(`urlegais`)=UPPER("'+sPDF417+'") ORDER BY `datetrans` DESC;');
    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
    if formStart.rowbuf <>nil then begin
      StartDate:=formStart.Str1ToDate(formStart.rowbuf[0]);
      enddate:=startdate;
    end;
    RefreshTrans();
    focusrow:=0;
    while (stringgrid1.Cells[7,focusrow] <>sPDF417 )AND( (stringgrid1.RowCount-1)>focusrow ) do begin
      focusrow:=focusrow+1;
    end;
    if stringgrid1.Cells[7,focusrow] = sPDF417 then
       stringgrid1.Row:=focusrow;
    stringgrid1.Col:=7;

  end;
end;

end.

