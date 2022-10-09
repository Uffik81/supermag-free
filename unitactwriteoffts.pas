unit unitactwriteoffts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, Buttons;

type

  { TFormActWriteOffTS }

  TFormActWriteOffTS = class(TForm)
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    Panel1: TPanel;
    pnlSprGoods: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    CurLine,
    flSelRow:integer;
    { public declarations }
    function addPLUcode(aBC,aCount:string):boolean;
  end;

var
  FormActWriteOffTS: TFormActWriteOffTS;

implementation
uses lazutf8, unitstart,mysql50,unitsalesbeerts,unitvisualselectgoods,lconvencoding,lclproc;
{$R *.lfm}

{ TFormActWriteOffTS }
var
  VisualSelectGoods:TFormVisualSelectGoods;

procedure TFormActWriteOffTS.FormShow(Sender: TObject);
begin
  VisualSelectGoods.Parent:=pnlSprGoods AS TWinControl;
  VisualSelectGoods.Top:=0;
  VisualSelectGoods.Left:=0;
  VisualSelectGoods.BorderStyle:=bsNone;
  VisualSelectGoods.Align:=alClient;
  VisualSelectGoods.Visible:=true;
end;

function TFormActWriteOffTS.addPLUcode(aBC, aCount: string): boolean;
var
  Query:string;
  PrdVCode:integer;
  vPDF417,vAlcCode,aPart,aSerial:string;
  strPrice:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  fplu:string;
  ii:integer;
  aBC1:string;
  rSumm1:real;
  rPrice1:real;
  rQual:real;
  rSumm2:real;
  rDisc1:real;
begin
 DefaultFormatSettings.DecimalSeparator:='.';
 aBC1:=aBC;
 try
    aBC1:=inttostr(Strtoint(aBC1));
 except
    aBC1:=aBC;
 end;

  strprice:='0.00';
  PrdVCode:=0;
  vPDF417:='';
  result:=false;
  flAlcGoods:=false;
  { formstart.AutoUpdateGoods}
  Query:='SELECT `barcodes`,`currentprice` FROM `sprgoods` WHERE `plu`="'+aBC1+'" AND `alcgoods`="+" AND (`weightgood`<>"1" AND `weightgood`<>"+");';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    flAlcGoods:=true;
    fplu:=xrowbuf[0];
    strprice:=xrowbuf[1];
    showmessage('Алкогольный товар продовать по коду нельзя!');
    result:=false;
    exit;
  end;
   Query:='SELECT `extcode`,`currentprice`,`name`,'+
          ''''','+
          ''''','
          +''''',`sprgoods`.`name`,`sprgoods`.`barcodes`,COUNT(*) AS `countline`, `freeprice`,`section`,(SELECT `unpacked` FROM `spproduct` WHERE `spproduct`.`alccode`=`extcode`) AS `unpack`  FROM `sprgoods` WHERE `plu`='''+aBC1+''' AND `alcgoods`<>''+''  GROUP BY `barcodes`;';
   xrecbuf:= formStart.DB_query(Query);
   xrowbuf:=formStart.DB_Next(xrecbuf);
   if  xrowbuf<>nil then
     begin
        strprice := format('%8.2f',[formstart.StrToFloat(xrowbuf[1])]);
        // === Рассчитываем цену с округлением ===
        rPrice1:= StrToFloat(strprice);


        CurLine:=CurLine+1;
        StringGrid1.RowCount:=CurLine+1;
        Stringgrid1.Rows[curLine].Clear;
        Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
        Stringgrid1.Rows[curLine].Add(aBC1);
        Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
        Stringgrid1.Rows[curLine].Add(format('%0.2f',[rPrice1]));
        Stringgrid1.Rows[curLine].Add(format('%3.3f',[rQual]));
        Stringgrid1.Rows[curLine].Add(format('%8.2f',[rSumm2]));
        Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
        Stringgrid1.Rows[curLine].Add('');
        Stringgrid1.Rows[curLine].Add(vPDF417);
        Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
        Stringgrid1.Rows[curLine].Add('0');
        Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
        Stringgrid1.Rows[curLine].Add(xrowbuf[0]);
        Stringgrid1.Cells[15,curLine]:= xrowbuf[10];
        Stringgrid1.Cells[13,curLine]:= floattostr(rDisc1);
        result:=true;
     end else begin

        showMessage('Не найден товар с кодом товара:'+aBC1);
        result:=false;
     //showmessage('надо сопоставить товар!');
    end;

 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;

end;

procedure TFormActWriteOffTS.FormCreate(Sender: TObject);
begin
   VisualSelectGoods:=TFormVisualSelectGoods.Create(self);
   VisualSelectGoods.flActWriteOff:=true;
end;

procedure TFormActWriteOffTS.bbOkClick(Sender: TObject);
var
  numdoc,datedoc:string;
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
  fffpack:string;

begin

  datedoc:=FormatDateTime('YYYY-MM-DD',now()) ;
  numdoc:=inttostr(formsalesbeerts.flNumCheck);
  // =========== Сохраним списание =====

    // ==== сохранить в БД документ ====
    for i:=1 to Stringgrid1.RowCount-1 do begin
      if StringGrid1.Cells[10,i]<>'' then begin

        xrecbuf:=formstart.DB_query('SELECT `count`,(SELECT `unpacked` FROM `spproduct` WHERE `spproduct`.`alccode`=`doc28`.`alccode`) AS `unpack` FROM `doc28` WHERE `alccode`="'+StringGrid1.Cells[12,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
        xrowbuf:=formStart.DB_Next(xrecbuf);
        if xrowbuf<>nil then begin
          formstart.DB_query('UPDATE `doc28` SET `count`="'+StringGrid1.Cells[9,i]+'",`price`="'+StringGrid1.Cells[3,i]+'" WHERE `alccode`="'+StringGrid1.Cells[12,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
        end else begin
          if StringGrid1.Cells[16,i]<>'' then
             fffpack:='1'
            else

          formstart.DB_query('INSERT INTO `doc28` (`numdoc`,`datedoc`,`alccode`,`count`,`price`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[12,i]+'","'+StringGrid1.Cells[9,i]+'","'+StringGrid1.Cells[3,i]+'");');
        end;

      end;
    end;

    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then
           formstart.DB_query('UPDATE SET `status`="---" FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";')
          else
           formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActWriteOffShop","---");');
    xrecbuf:=formstart.DB_query('SELECT `typedoc` FROM `docx28` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
       formstart.DB_query('UPDATE `docx28` SET `notedoc`="Розничная реализация продукции, не подлежащая фиксации в ЕГАИС", `typedoc`="Реализация" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
     end else begin
       formstart.DB_query('INSERT INTO `docx28` (`numdoc`,`datedoc`,`notedoc`, `typedoc`) VALUES ("'+NumDoc+'","'+DateDoc+'","Розничная реализация продукции, не подлежащая фиксации в ЕГАИС","Реализация");');
     end;


// ======
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
  SLine.add('<awr:TypeWriteOff>Реализация</awr:TypeWriteOff>');
  SLine.add('<awr:Note>Розничная реализация продукции, не подлежащая фиксации в ЕГАИС</awr:Note>');
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
        SLine.add('<pref:UnitType>Packed</pref:UnitType>');
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

procedure TFormActWriteOffTS.FormDestroy(Sender: TObject);
begin
  VisualSelectGoods.Destroy;
end;

end.

