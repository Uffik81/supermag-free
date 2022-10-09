unit unitactwriteoffshop;

{$mode objfpc}{$H+}
{ Документ списание с торгового зала - ActWriteOffShop}
interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, Grids, StdCtrls, ComCtrls;

type

  { TFormActWriteOffShop }

  TFormActWriteOffShop = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    ComboBox1: TComboBox;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    mmComment: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StringGrid2: TStringGrid;
    stSumma: TStaticText;
    stEgaisURL: TStaticText;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure edNumDocChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmCommentChange(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid2SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    flEditing:boolean;
    flNew:boolean;
    flReadOnly:boolean;
    NumDoc:string;
    DateDoc:String;
    flSelRow:integer;
    flSelRowFix:integer;
  end;

var
  FormActWriteOffShop: TFormActWriteOffShop;

implementation

{$R *.lfm}
uses lazutf8, unitstart,mysql50,lconvencoding,typinfo,LCLIntf, LCLProc, unitshoprest, unitsendnumber,
  unitlogging, unitpdf417;


{ TFormActWriteOffShop }

procedure TFormActWriteOffShop.BitBtn1Click(Sender: TObject);
var
  SLine:TStringList;
  aClientRegId:string;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
  i:integer;
  strGUID:string;
  str,url:string;
  idProductVCode,
  idAlcCode:String;
  ind:integer;
  flrussia:boolean;
  i1:integer;
  st1:boolean;
begin
  datedoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.date) ;
  numdoc:=edNumDoc.text;
  strGUID:=formstart.NewGUID();
  sLine:= TStringList.Create;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="2.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2"');
  SLine.add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"');
  SLine.add('xmlns:awr="http://fsrar.ru/WEGAIS/ActWriteOffShop_v2"');
  SLine.add('xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+formstart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:ActWriteOffShop_v2>');
  SLine.add('<awr:Identity>'+strGUID+'</awr:Identity>');
  SLine.add('<awr:Header>');
  SLine.add('<awr:ActDate>'+datedoc+'</awr:ActDate>');
  SLine.add('<awr:ActNumber>'+numdoc+'</awr:ActNumber>');
  SLine.add('<awr:TypeWriteOff>'+ComboBox1.Text+'</awr:TypeWriteOff>');
  SLine.add('<awr:Note>'+mmComment.text+'</awr:Note>');
  SLine.add('</awr:Header>');
  SLine.add('<awr:Content>');
  // ==== Описание позиции =====
  idAlcCode:='';
  ind:=1;
  query:='SELECT `alccode`,`count` FROM `doc28` WHERE `numdoc`="'+numdoc+'" AND `datedoc`="'+datedoc+'";';
  recbuf:=formstart.DB_Query(Query);
  rowBuf:=formstart.DB_Next(recbuf);
  while rowbuf<>nil do begin
      idAlcCode:=rowbuf[0];
      SLine.add('<awr:Position>');
      SLine.add('<awr:Identity>'+inttostr(ind)+'</awr:Identity>');
      Query:= 'SELECT `name`,`capacity`,`clientregid`,`productvcode`,`unpacked`  FROM `spproduct` WHERE `alccode`="'+idAlcCode+'" LIMIT 1;';
      xrecbuf:=formstart.DB_Query(query);
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf<> nil then begin
        aClientRegId:= xrowbuf[2];
        idProductVCode:=xrowbuf[3];
        SLine.add('<awr:Product>');
        if xrowBuf[4] <>'+' then
           SLine.add('<pref:UnitType>Packed</pref:UnitType>')
        else
           SLine.add('<pref:UnitType>Unpacked</pref:UnitType>');
        SLine.add('<pref:Type>АП</pref:Type>');
        SLine.add('<pref:FullName>'+ReplaceStr(xrowbuf[0])+'</pref:FullName>');
        SLine.add('<pref:ShortName>'+utf8copy(ReplaceStr(xrowbuf[0]),1,64)+'</pref:ShortName>');
        SLine.add('<pref:AlcCode>'+idAlcCode+'</pref:AlcCode>');
        if  xrowBuf[4] <>'+' then
         SLine.add('<pref:Capacity>'+xrowBuf[1]+'</pref:Capacity>');
         // === получим данные о производителе ===
          SLine.add('<pref:Producer>');
        Query:= 'SELECT `inn`,`kpp`,`FullName`,`description`,`Country`,`region`  FROM `spproducer` WHERE `ClientRegId`="'+aClientRegId+'" LIMIT 1;';
        xrecbuf:=formstart.DB_Query(query);
        xrowbuf:=formstart.DB_Next(xrecbuf);
        if xrowbuf<> nil then begin
          if (xrowbuf[4]='') or (xrowbuf[4]='643') then flrussia:=true else flrussia:=false;


          if flrussia then SLine.add('<oref:UL>') else SLine.add('<oref:FO>');
          SLine.add('<oref:ClientRegId>'+aClientRegId+'</oref:ClientRegId>');
          SLine.add('<oref:FullName>'+replacestr(xrowbuf[2])+'</oref:FullName>');
          SLine.add('<oref:ShortName>'+UTF8Copy(replacestr(xrowbuf[2]),1,64)+'</oref:ShortName>');
          if xrowbuf[0]<>'' then begin
            SLine.add('<oref:INN>'+xrowbuf[0]+'</oref:INN>');
            if xrowbuf[1]<>'' then
              SLine.add('<oref:KPP>'+xrowbuf[1]+'</oref:KPP>');
          end;
          SLine.add('<oref:address>');
          if (xrowbuf[4]='')or(xrowbuf[4]='643') then begin
              SLine.add('<oref:Country>643</oref:Country>') ;
              if  xrowbuf[5]<>'' then
               SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>')
               else
                SLine.add('<oref:RegionCode>'+copy(xrowbuf[0],1,2)+'</oref:RegionCode>')
              end
            else begin
              SLine.add('<oref:Country>'+xrowbuf[4]+'</oref:Country>');
              if xrowbuf[5]<>'' then SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>') ;
            end;

          SLine.add('<oref:description>'+replaceStr(xrowbuf[3])+'</oref:description>');
          SLine.add('</oref:address>');
          if flrussia then SLine.add('</oref:UL>') else SLine.add('</oref:FO>');

        end;
      SLine.add('</pref:Producer>');
      SLine.add('<pref:ProductVCode>'+idProductVCode+'</pref:ProductVCode>');
      SLine.add('</awr:Product>');
    end;
      SLine.add('<awr:Quantity>'+rowbuf[1]+'</awr:Quantity>');
      if stringgrid2.RowCount>1 then begin
      st1:=false;
        for i1:=1 to stringgrid2.RowCount-1 do
          if  stringgrid2.Cells[1,i1] = idAlcCode then  begin
             if not st1 then begin
              SLine.add('<awr:MarkCodeInfo>');
              st1:=true;
              end;
              SLine.add('<MarkCode>'+stringgrid2.Cells[3,i1]+'</MarkCode>');

            end;
        if st1 then
          SLine.add('</awr:MarkCodeInfo>');
       end;
// ================
{
<awr:MarkCodeInfo>             <awr:MarkCode>09001785400000118984312PX905150010000012515518222446177313434237912077</ awr:MarkCode>           </awr:MarkCodeInfo>
}
// ================
      SLine.add('</awr:Position>');
      rowbuf:=formstart.DB_Next(recbuf);
      ind:=ind+1;
end;
// ==== Описание позиции ===========
SLine.add('</awr:Content>');
SLine.add('</ns:ActWriteOffShop_v2>');
SLine.add('</ns:Document>');
SLine.add('</ns:Documents>');

  str:=formStart.savetoserverpost('opt/in/ActWriteOffShop_v2',Sline.text) ;
  url:=formStart.getXMLtoURL(str);
  showmessage(str);
  SLine.text:=str;
  if SLine.Count < 1 then begin
    SLine.SaveToFile(formStart.pathfile()+'\ActWriteOffShopv2.txt');
     exit;
  end;
  if url='' then begin
  Query:='UPDATE `docjurnale`   SET uid="'+strGUID+'", status="0--", docid="'+strGUID+'", ClientAccept="" '+
               'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND `type`="ActWriteOffShop";';
               // добавлен сброс подтверждения клиента для ОПТА
     formStart.DB_query(Query);
     Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''','''','''','''',''Rejected'','''+''',''ActWriteOffShop'',''ActWriteOffShop'',''ActWriteOffShop'','''+numdoc+''','''+datedoc+''');';
     formStart.DB_query(Query);


   end else begin
     Query:='UPDATE `docjurnale`   SET uid="'+url+'", docid="'+strGUID+'", ClientAccept="" '+
           'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND `type`="ActWriteOffShop";';
     formStart.DB_query(Query);
     Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+url+'","'+NumDoc+'","'+datedoc+'");';
     formStart.DB_query(Query);
   end;

  SLine.Free


end;

procedure TFormActWriteOffShop.BitBtn2Click(Sender: TObject);

var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  datedoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.date) ;
  numdoc:=edNumDoc.text;
  if numdoc='' then begin
         showmessage('Укажите номер документа');
         exit;
       end;

  formstart.DB_query('DELETE FROM `doc28` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');

  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
    xrecbuf:=formstart.DB_query('SELECT `count` FROM `doc28` WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      flEditing:=true;
      formstart.DB_query('UPDATE `doc28` SET `count`="'+StringGrid1.Cells[3,i]+'",`price`="'+StringGrid1.Cells[4,i]+'" WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc28` (`numdoc`,`datedoc`,`alccode`,`count`,`price`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[2,i]+'","'+StringGrid1.Cells[3,i]+'","'+StringGrid1.Cells[4,i]+'");');
    end;
  end;

    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+trim(NumDoc)+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then
        formstart.DB_query('UPDATE `docjurnale` SET `status`="---" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";')
      else
        formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActWriteOffShop","---");');

  xrecbuf:=formstart.DB_query('SELECT `typedoc` FROM `docx28` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
     flEditing:=true;
     formstart.DB_query('UPDATE `docx28` SET `notedoc`="'+mmComment.text+'", `typedoc`="'+ComboBox1.Text+'" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
   end else begin
     formstart.DB_query('INSERT INTO `docx28` (`numdoc`,`datedoc`,`notedoc`, `typedoc`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+mmComment.text+'","'+ComboBox1.Text+'");');
   end;
  if stringgrid2.RowCount>1 then begin
    // =========================
    formstart.DB_query('DELETE FROM `doc28fix` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    for i:=1 to Stringgrid2.RowCount-1 do begin
      xrecbuf:=formstart.DB_query('SELECT COUNT(*) AS `count` FROM `doc28fix` WHERE `fixmark`="'+StringGrid2.Cells[3,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if xrowbuf<>nil then begin
        flEditing:=true;
//        formstart.DB_query('UPDATE `doc28fix` SET `fixmark`="'+StringGrid1.Cells[3,i]+'",`price`="'+StringGrid1.Cells[4,i]+'" WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
      end else begin
        formstart.DB_query('INSERT INTO `doc28fix` (`numdoc`,`datedoc`,`alccode`,`fixmark`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid2.Cells[1,i]+'","'+StringGrid2.Cells[3,i]+'");');
      end;
    end;
  end;

end;

procedure TFormActWriteOffShop.BitBtn3Click(Sender: TObject);
var
  i:integer;
begin
  FormShopRest.flSelectMode:=true;
  if FormShopRest.ShowModal =1377 then begin
    FormSendNumber.edit1.text:='1';
    if  formsendnumber.ShowModal=mrOk then begin;
      i:=StringGrid1.RowCount;
      StringGrid1.RowCount:=i+1;
      StringGrid1.Cells[2,i]:=FormShopRest.flAlcCode;
      StringGrid1.Cells[1,i]:=FormShopRest.StringGrid1.Cells[1,FormShopRest.StringGrid1.row];
      StringGrid1.Cells[4,i]:=FormShopRest.StringGrid1.Cells[3,FormShopRest.StringGrid1.row];
      StringGrid1.Cells[3,i]:=FormSendNumber.edit1.text;

    end;
  end;
  FormShopRest.flSelectMode:=false;
end;

procedure TFormActWriteOffShop.BitBtn4Click(Sender: TObject);
begin
  if flSelRow>0 then begin
    StringGrid1.DeleteRow(flselrow);
    flselrow:=0;
  end;
end;

procedure TFormActWriteOffShop.BitBtn5Click(Sender: TObject);
{var
  str,url:string;
  SLine:TStringList;  }
begin
  showmessage('Отмена списания из торгового зала не возможно!');
 { sLine:= TStringList.Create;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/RequestRepealAWO"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+formstart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:RequestRepealAWO>');
  SLine.add('<qp:ClientId>'+formstart.EgaisKod+'</qp:ClientId>');
  SLine.add('<qp:RequestNumber>'+numdoc+'</qp:RequestNumber>');
  SLine.add('<qp:RequestDate>'+FormatDateTime('YYYY-MM-DD',now())+'T00:00:00</qp:RequestDate>');
  SLine.add('<qp:AWORegId>'+stegaisurl.caption+'</qp:AWORegId>');
  SLine.add('</ns:RequestRepealAWO>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str:=formStart.savetoserverpost('opt/in/RequestRepealAWO',Sline.text) ;
  url:=formStart.getXMLtoURL(str);
  if url<>'' then
   formstart.DB_query('UPDATE SET `uid`="'+url+'" FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";');
  //showmessage(str);
  Sline.free;      }
end;

procedure TFormActWriteOffShop.BitBtn6Click(Sender: TObject);
var
  y, ind1,
  i:integer;
  str:string;
  name1:string;
  price:string;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
    SLine:TStringList;
    plu,barcode,count1:string;
    count2:integer;
    count3:integer;
    Count3str:string;
    alccode1:string;
begin
  if opendialog1.Execute  then begin
    sLine:=TStringList.Create;
    sLine.Clear;
    sline.LoadFromFile(opendialog1.FileName);
    ind1:=1;
    plu:='';
    for i:=0 to sline.Count-1 do begin
      str:=sLine.Strings[i];
      y:=pos(';',str);
      plu:=trim(ansitoutf8(copy(str,1,y-1)));
      str:=copy(str,y+1,length(str));
      y:=pos(';',str);
      barcode:=copy(str,1,y-1);
      str:=copy(str,y+1,length(str));
      y:=pos(';',str);
      name1:=copy(str,1,y-1);
      count1:=copy(str,y+1,length(str));

        if  (pos(',',count1)<>0 )or (pos('.',count1)<>0 ) then
          begin
  //          count1:='0';
  //          count2:=0;
            y:=pos(',',count1);
            if y=0 then
               y:=pos('.',count1);
            count1:=copy(count1,1,y-1);
            count2:=strtoint(count1)+1;
            count1:=inttostr(count2);
            formlogging.AddMessage('Дробный товар:'+sLine.Strings[i])

          end
        else begin
         if count1<>'' then
          count2:=strtoint(count1)
          else begin
            count2:=0;
            count1:='0';
            end;

      end;

      query:='SELECT `extcode`,`currentprice`,'+
        '(SELECT `Quantity` FROM `regrestsshop` WHERE `regrestsshop`.`alccode`=`sprgoods`.`extcode` LIMIT 1 ) AS `ost`,'+
     //    ' `name` '+
        '(SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode`=`sprgoods`.`extcode` limit 1 ) AS `name`'+
        ' FROM `sprgoods` WHERE `plu`='+plu+' AND `extcode`<>"";';
      xrecbuf:=formstart.DB_query(query);
      xrowbuf:=formstart.DB_Next(xrecbuf);
      //count2:=0;
      if xrowbuf = nil then
        formlogging.AddMessage('Не найден товар:'+sLine.Strings[i])
        else begin
          //count2:=strtoint(xrowbuf[2]);
          while (xrowbuf<> nil)and(count2>0) do begin
            if xrowbuf[0]<>'' then begin
            Stringgrid1.RowCount:=ind1+1;
            Stringgrid1.Cells[2,ind1]:=xrowbuf[0];
            Stringgrid1.Cells[4,ind1]:= xrowbuf[1];
            Count3str:= xrowbuf[2];
            if Count3str='' then
              count3:=0
            else
             count3:=strtoint(Count3str);
            Stringgrid1.Cells[1,ind1]:= xrowbuf[3];
            if count3> count2 then
              begin
                Stringgrid1.Cells[3,ind1]:=inttostr(count2);
                count2:=0;
              end
            else
            begin
              Stringgrid1.Cells[3,ind1]:=inttostr(count3);
              count2:=count2-count3;
            end;
            ind1:=ind1+1;
            end;
            xrowbuf:=formstart.DB_Next(xrecbuf);
          end;

      end;


    end;
    sline.free;
  end;
  FormPaint(nil);
end;
{ # Добавляем акцизку ######

}
procedure TFormActWriteOffShop.BitBtn7Click(Sender: TObject);
var
    addAlcCode:string;
    AddPDF417:string;
    i,
    ii:integer;
    res1:boolean;
    cnt1:integer;
    query:string;
    xrowbuf : MYSQL_ROW;
    xrecbuf : PMYSQL_RES;
    name1:string;
    vcode:string;
begin
  addAlcCode:='';
  AddPDF417:='';
  addAlcCode:=formGetPDF417.getAlcCode() ;
  AddPDF417:= formGetPDF417.Edit1.Text;
  if (addAlcCode<>'')and(AddPDF417<>'') then begin
   {сначало ищем повторы}
    res1:=false;
    for i:=1 to StringGrid2.RowCount-1 do
      if  StringGrid2.Cells[3,i] = AddPDF417 then
        res1:=true;

    if res1 then begin
      showmessage('Эта акцизка уже добавлена');
      exit;
    end;
    if formstart.ControleFixMarkSale(AddPDF417) then begin
       showmessage('Данная марка уже учавствовала в обороте!');
       exit;
       end;
    query:= 'SELECT `name`,`productvcode` FROM `spproduct` WHERE `alccode`='''+addAlcCode+'''; ';
    xrecbuf:=formstart.db_query(query);
    xrowbuf:=formstart.db_next(xrecbuf);
    name1:='';
    if xrowbuf<>nil then begin
       name1:=xrowbuf[0];
       vcode:= xrowbuf[1];
      end;
    i:=StringGrid2.RowCount;
    StringGrid2.RowCount:=i+1;
    StringGrid2.Cells[1,i]:=addAlcCode;
    StringGrid2.Cells[2,i]:=name1;
    StringGrid2.Cells[3,i]:=AddPDF417;
    StringGrid2.Cells[4,i]:=vcode;
    res1:=true;
    for i:=1 to StringGrid1.RowCount-1  do begin
      if addAlcCode = StringGrid1.Cells[2,i] then
        begin
          res1:=false;
          if StringGrid1.Cells[5,i] = '' then
             StringGrid1.Cells[5,i] := '0';
          cnt1:=strtoint(StringGrid1.Cells[5,i])+1;

          StringGrid1.Cells[5,i]:=inttostr(cnt1);
        end ;
    end;
    if res1 then
       begin
         showmessage('Этой позиции нет, добавим! ');
         ii:=StringGrid1.RowCount;
         StringGrid1.RowCount:=ii+1;
         StringGrid1.Cells[1,ii]:=name1;
         StringGrid1.Cells[2,ii]:=addAlcCode;
         StringGrid1.Cells[3,ii]:='1';
         StringGrid1.Cells[6,ii]:=vcode;
         StringGrid1.Cells[5,ii]:='1';
       end;
  end;
end;

procedure TFormActWriteOffShop.BitBtn8Click(Sender: TObject);
begin
  if flSelRowFix>0 then begin
    StringGrid2.DeleteRow(flselrowFix);
    flselrowFix:=0;
  end;
end;

procedure TFormActWriteOffShop.BitBtn9Click(Sender: TObject);
var
    addAlcCode:string;
    AddPDF417:string;
    i,
    ii:integer;
    res1:boolean;
    cnt1:integer;
    query:string;
    xrowbuf : MYSQL_ROW;
    xrecbuf : PMYSQL_RES;
    name1:string;
    vcode:string;
     SLine:TStringList;
begin

  addAlcCode:='';
  AddPDF417:='';
  addAlcCode:=formGetPDF417.getAlcCode() ;
  AddPDF417:= formGetPDF417.Edit1.Text;
  if (addAlcCode<>'')and(AddPDF417<>'') then begin
   {сначало ищем повторы}
    res1:=false;
    for i:=1 to StringGrid2.RowCount-1 do
      if  StringGrid2.Cells[3,i] = AddPDF417 then
        res1:=true;

    if res1 then begin
      showmessage('Эта акцизка уже добавлена');
      exit;
    end;
    if formstart.ControleFixMarkSale(AddPDF417) then begin
       showmessage('Данная марка уже учавствовала в обороте!');
       exit;
       end;
    query:= 'SELECT `name`,`productvcode` FROM `spproduct` WHERE `alccode`='''+addAlcCode+'''; ';
    xrecbuf:=formstart.db_query(query);
    xrowbuf:=formstart.db_next(xrecbuf);
    name1:='';
    if xrowbuf<>nil then begin
       name1:=xrowbuf[0];
       vcode:= xrowbuf[1];
      end;
    i:=StringGrid2.RowCount;
    StringGrid2.RowCount:=i+1;
    StringGrid2.Cells[1,i]:=addAlcCode;
    StringGrid2.Cells[2,i]:=name1;
    StringGrid2.Cells[3,i]:=AddPDF417;
    StringGrid2.Cells[4,i]:=vcode;
    res1:=true;
    for i:=1 to StringGrid1.RowCount-1  do begin
      if addAlcCode = StringGrid1.Cells[2,i] then
        begin
          res1:=false;
          if StringGrid1.Cells[5,i] = '' then
             StringGrid1.Cells[5,i] := '0';
          cnt1:=strtoint(StringGrid1.Cells[5,i])+1;

          StringGrid1.Cells[5,i]:=inttostr(cnt1);
        end ;
    end;
    if res1 then
       begin
         showmessage('Этой позиции нет, добавим! ');
         ii:=StringGrid1.RowCount;
         StringGrid1.RowCount:=ii+1;
         StringGrid1.Cells[1,ii]:=name1;
         StringGrid1.Cells[2,ii]:=addAlcCode;
         StringGrid1.Cells[3,ii]:='1';
         StringGrid1.Cells[6,ii]:=vcode;
         StringGrid1.Cells[5,ii]:='1';
       end;
  end;

end;

procedure TFormActWriteOffShop.ComboBox1Change(Sender: TObject);
begin

end;

procedure TFormActWriteOffShop.edNumDocChange(Sender: TObject);
begin

end;

procedure TFormActWriteOffShop.FormPaint(Sender: TObject);
var
    i:integer;
    summ:integer;
begin
  summ:=0;

  for i:=1 to stringgrid1.RowCount-1 do begin
    if stringgrid1.cells[3,i]<>'' then
     summ:=summ+strtoint(stringgrid1.cells[3,i])
  end;
  stSumma.Caption:='Итого:'+inttostr(summ);
end;

procedure TFormActWriteOffShop.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  strid:string;
begin
  bitbtn1.Enabled:=true;
  bitbtn5.Enabled:=true;
  flselrow:=0;
  flSelRowFix:=0;
  if flNew = true then begin
  StringGrid2.Clear;
  StringGrid2.RowCount:=1;
  StringGrid1.Clear;
  StringGrid1.RowCount:=1;
  bitbtn5.Enabled:=false;
  end;
  if ( NumDoc<>'' )and( DateDoc<>'' ) then begin    //,(SELECT `InformARegId` FROM `regrestsproduct` WHERE `alccode`=`doc25`.`alccode` AND `crdate`=`doc25`.`crdate` LIMIT 1) AS `forma`

    StringGrid1.Clear;
    StringGrid1.RowCount:=1;
    Query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`doc28`.`alccode` LIMIT 1) AS `name`,`alccode`,`count`,`price`,(SELECT `productvcode` FROM `spproduct` WHERE `alccode`=`doc28`.`alccode` LIMIT 1) AS `productvcode` FROM `doc28` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
    xrecbuf:=FormStart.DB_Query(Query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
      i:=1;
      StringGrid1.Clear;
      StringGrid1.RowCount:=2;
      while xrowbuf<>nil do begin
        StringGrid1.RowCount:=i+1;
        StringGrid1.Cells[0,i]:=inttostr(i);
        StringGrid1.Cells[1,i]:=xrowbuf[0];
        StringGrid1.Cells[2,i]:=xrowbuf[1];
        StringGrid1.Cells[3,i]:=xrowbuf[2];
        StringGrid1.Cells[4,i]:=xrowbuf[3];
        StringGrid1.Cells[5,i]:='';
        StringGrid1.Cells[6,i]:=xrowbuf[4];
        i:=i+1;
        Stringgrid1.Row:=i;
        flNew:=false;
        xrowbuf:= formStart.DB_Next(xrecbuf);
      end;
      edNumDoc.Text:=NumDoc;
      dpDateDoc.date:=formstart.Str1ToDate(DateDoc);
      Query:='SELECT `notedoc`,`typedoc` FROM `docx28` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
      xrecbuf:=FormStart.DB_Query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if xrowbuf<>nil then begin
          mmComment.text:=xrowbuf[0];
          Combobox1.Text:=xrowbuf[1];
        end;
      Query:='SELECT `wbregid`,`uid`, `status` FROM `docjurnale` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";';
      xrecbuf:=FormStart.DB_Query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if xrowbuf<>nil then begin
          stegaisurl.caption:=xrowbuf[0];
          strid:=             xrowbuf[1];
          //Combobox1.Text:=xrowbuf[1];

          if (xrowbuf[2]='+++')or(xrowbuf[2]='+1+') then
                   begin
                      Query:='SELECT `RegID` FROM `ticket` WHERE `uid`="'+strid+'" AND `type`="ActWriteOffShop_v2";';
                      xrecbuf:=FormStart.DB_Query(Query);
                      xrowbuf:=formStart.DB_Next(xrecbuf);
                       if xrowbuf<>nil then begin
                           stegaisurl.caption:=xrowbuf[0];
                           bitbtn1.Enabled:=false;
                       end;
                   end ;

        end;
      Query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`doc28fix`.`alccode` LIMIT 1) AS `name`,`alccode`,`fixmark`,(SELECT `productvcode` FROM `spproduct` WHERE `alccode`=`doc28fix`.`alccode` LIMIT 1) AS `productvcode` FROM `doc28fix` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
      xrecbuf:=FormStart.DB_Query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
        i:=1;
        StringGrid2.Clear;
        StringGrid2.RowCount:=2;
        while xrowbuf<>nil do begin
          StringGrid2.RowCount:=i+1;
          StringGrid2.Cells[0,i]:=inttostr(i);
          StringGrid2.Cells[1,i]:=xrowbuf[1];
          StringGrid2.Cells[2,i]:=xrowbuf[0];
          StringGrid2.Cells[3,i]:=xrowbuf[2];
          StringGrid2.Cells[4,i]:=xrowbuf[3];
          i:=i+1;
          Stringgrid2.Row:=i;
          flNew:=false;
          xrowbuf:= formStart.DB_Next(xrecbuf);
        end;
     flNew:=false;
  end else
  begin
    dpDateDoc.Date:=now();
    edNumDoc.Text:='';
    flNew:=true;

  end;

  //edNumDoc.ReadOnly:=not flNew;
  //dpDateDoc.ReadOnly:=not flNew;

end;

procedure TFormActWriteOffShop.mmCommentChange(Sender: TObject);
begin

end;

procedure TFormActWriteOffShop.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  flSelRow:=aRow;
end;

procedure TFormActWriteOffShop.StringGrid2SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  flSelRowFix:=aRow;
end;

end.

