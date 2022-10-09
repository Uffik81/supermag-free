unit unittransfercash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Grids, Buttons, StdCtrls;

type

  { TFormTransferCash }

  TFormTransferCash = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    wbNumDoc:string;
    wbDateDoc:string;
    wbDocid:string;
  end;

var
  FormTransferCash: TFormTransferCash;

implementation

{$R *.lfm}
uses unitstart, unittransfertoshop,mysql50;

{ TFormTransferCash }

procedure TFormTransferCash.FormShow(Sender: TObject);
var
  Query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin

 Query:='SELECT `alcitem`,'+
 '(SELECT `name` FROM `spproduct` WHERE `alccode`=`doc221`.`alcitem` LIMIT 1) AS `name`,'+
 '(SELECT `barcodes` FROM `sprgoods` WHERE (`extcode`=`doc221`.`alcitem`) AND (`barcodes`<>"") LIMIT 1) AS `barcode`,'+
 '`Price`,'+
 '(SELECT `currentprice` FROM `sprgoods` WHERE `extcode`=`doc221`.`alcitem`  LIMIT 1) AS `rozprice`,'+
 '(SELECT `formb` FROM `docformab` WHERE (`docformab`.`numposition`=`doc221`.`numposit`)AND(`docformab`.`docid`="'+wbDocid+'") LIMIT 1) AS  `formB`,'+
 '`factcount`,'+
 '(SELECT `plu` FROM `sprgoods` WHERE (`extcode`=`doc221`.`alcitem`) LIMIT 1) AS `plu1`  FROM `doc221` WHERE (datedoc="'+wbdatedoc+'")AND(numdoc="'+wbnumdoc+'")AND(docid="'+wbDocid+'")';
 formstart.recbuf:=formStart.DB_query(query);
 formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 StringGrid1.RowCount:=1;
 while formstart.rowbuf<>nil do begin
   StringGrid1.RowCount:=StringGrid1.RowCount+1;
   if formstart.rowbuf[1]='' then begin
       xrecbuf:=formstart.DB_query('SELECT `alcitem`,`tovar` FROM `doc221` WHERE (datedoc="'+wbdatedoc+'")AND(numdoc="'+wbnumdoc+'")AND(docid="'+wbDocid+'") AND `alcitem`="'+formstart.rowbuf[0]+'";');
       xrowbuf:=formstart.DB_Next(xrecbuf);
       if xrowbuf<>nil then
         StringGrid1.Cells[2,StringGrid1.RowCount-1]:=xrowbuf[1];
     end else
      StringGrid1.Cells[2,StringGrid1.RowCount-1]:=formstart.rowbuf[1];

   StringGrid1.Cells[1,StringGrid1.RowCount-1]:=formstart.rowbuf[0];
   StringGrid1.Cells[3,StringGrid1.RowCount-1]:=formstart.rowbuf[2];
   StringGrid1.Cells[4,StringGrid1.RowCount-1]:=formstart.rowbuf[3];
   StringGrid1.Cells[5,StringGrid1.RowCount-1]:=formstart.rowbuf[4];
   StringGrid1.Cells[6,StringGrid1.RowCount-1]:=formstart.rowbuf[5];
   StringGrid1.Cells[7,StringGrid1.RowCount-1]:=formstart.rowbuf[6];
   StringGrid1.Cells[8,StringGrid1.RowCount-1]:=formstart.rowbuf[7];
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 end;
 edNumDoc.text := wbNumDoc;
 dpDateDoc.Date:=formStart.Str1ToDate(wbDateDoc);
end;
{
<?xml version="1.0" encoding="utf-8"?>
<ns:Documents Version="1.0"
 xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:c="http://fsrar.ru/WEGAIS/Common"
 xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"
 xmlns:tts="http://fsrar.ru/WEGAIS/TransferToShop"
>
 <ns:Owner>
 <ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
 </ns:Owner>
 <ns:Document>
 <ns:TransferToShop> (1.21.1)
<tts:Identity>1/1</tts:Identity>
<tts:Header>
<tts:TransferNumber>1/1</tts:TransferNumber>
<tts:TransferDate>2016-04-08</tts:TransferDate>
</tts:Header>
<tts:Content>
<tts:Position>
<tts:Identity>1</tts:Identity>
<tts:ProductCode>0035543000001238259</tts:ProductCode>
<tts:Quantity>11</tts:Quantity>
<tts:InformF2>
<pref:F2RegId>TEST-FB-000000012124173</pref:F2RegId>
</tts:InformF2>
</tts:Position>
</tts:Content>
 </ns:TransferToShop>
 </ns:Document>
 </ns:Documents>


}

procedure TFormTransferCash.BitBtn1Click(Sender: TObject);
var
  ii:integer;
  query:string;
  flSKU:integer;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  for ii:=1 to StringGrid1.RowCount-1 do begin
    if StringGrid1.Cells[8,ii]<>'' then
      query:='SELECT `plu` FROM `sprgoods` WHERE `extcode`="'+StringGrid1.Cells[1,ii]+'" AND `barcodes`="'+StringGrid1.Cells[3,ii]+'" ;'
     else
       query:='SELECT `plu` FROM `sprgoods` WHERE `barcodes`="'+StringGrid1.Cells[3,ii]+'" ;';

    xrecbuf:=formStart.DB_query(query);
    xrowbuf:=formstart.DB_Next(xrecbuf);
    if xrowbuf<> nil then begin
        if StringGrid1.Cells[8,ii]<>'' then
         formStart.DB_query('UPDATE `sprgoods` SET `currentprice`="'+StringGrid1.Cells[5,ii]+'" WHERE `extcode`="'+StringGrid1.Cells[1,ii]+'" AND `barcodes`="'+StringGrid1.Cells[3,ii]+'" ;')
         else
          begin
            xrecbuf:= formstart.DB_query('SELECT `plu`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+StringGrid1.Cells[3,ii]+'" ;');
            xrowbuf:=formstart.DB_Next(xrecbuf);
            if xrowbuf <> nil then begin
              flSKU:=strtoint(xrowbuf[0]);
              if (xrowbuf[0] = xrowbuf[1])or(xrowbuf[1]='') then
                formStart.DB_query('UPDATE `sprgoods` SET `currentprice`="'+StringGrid1.Cells[5,ii]+'",  `extcode`="'+StringGrid1.Cells[1,ii]+'" WHERE `barcodes`="'+StringGrid1.Cells[3,ii]+'" ;')

               else
                formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+StringGrid1.Cells[8,ii]+''','''+StringGrid1.Cells[3,ii]+''','''+StringGrid1.Cells[1,ii]+
              ''',''+'',''+'','''+StringGrid1.Cells[2,ii]+''','''+StringGrid1.Cells[2,ii]+''','''+trim(StringGrid1.Cells[5,ii])+''');');
            end;
          end;
        end
      else begin
          if StringGrid1.Cells[8,ii]='' then
              begin
                  if  formStart.GetConstant('NumberSKU')='' then
                      flSKU:=1
                      else begin
                        flSKU:=strtoint(formStart.GetConstant('NumberSKU'))+1 ; // === Номер последнего товара

                  end;
                 StringGrid1.Cells[8,ii]:=inttostr(flSKU);
                 formStart.SetConstant('NumberSKU',inttostr(flSKU));

              end;
        formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+StringGrid1.Cells[8,ii]+''','''+StringGrid1.Cells[3,ii]+''','''+StringGrid1.Cells[1,ii]+
          ''',''+'',''+'','''+StringGrid1.Cells[2,ii]+''','''+StringGrid1.Cells[2,ii]+''','''+trim(StringGrid1.Cells[5,ii])+''');');

      end;

  end;

end;

procedure TFormTransferCash.BitBtn2Click(Sender: TObject);
var
    i:integer;
begin
  // =====
  formtransfertoshop.StringGrid1.Clean;
  formtransfertoshop.StringGrid1.RowCount:=stringgrid1.RowCount;
  for i:=1 to stringgrid1.RowCount-1 do begin
    formtransfertoshop.StringGrid1.Cells[1,i]:=StringGrid1.Cells[2,i];
    formtransfertoshop.StringGrid1.Cells[2,i]:=StringGrid1.Cells[1,i];
    formtransfertoshop.StringGrid1.Cells[4,i]:=StringGrid1.Cells[7,i];
    formtransfertoshop.StringGrid1.Cells[3,i]:=StringGrid1.Cells[6,i];
  end;
  formtransfertoshop.flowNumDoc:=wbNumDoc;
  formtransfertoshop.flowDateDoc:=wbDateDoc;
  formtransfertoshop.showmodal;

end;


end.

