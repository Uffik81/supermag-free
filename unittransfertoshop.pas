unit unittransfertoshop;

{$mode objfpc}{$H+}
{тип документа: "ActTransferOnShop"
Премещение в торговый зал}
interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ComCtrls, Grids, StdCtrls, Buttons;

type

  { TFormTransferToShop }

  TFormTransferToShop = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
    _uuid:string;
    procedure CreateUUID();
  public
    { public declarations }
    flowNumDoc,
    flOwDateDoc:String;
    flEditing:boolean;
    procedure CreateDocument;
  end;

var
  FormTransferToShop: TFormTransferToShop;

implementation
uses unitstart, mysql50, unitspproducer;

{$R *.lfm}
{
<?xml version="1.0" encoding="utf-8"?>
<ns:Documents Version="1.0"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:c="http://fsrar.ru/WEGAIS/Common"
xmlns:pref="http://f
srar.ru/WEGAIS/ProductRef_v2"
xmlns:tts="http://fsrar.ru/WEGAIS/TransferToShop"
>
<ns:Owner>
<ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:TransferToShop>
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


{ TFormTransferToShop }

procedure TFormTransferToShop.BitBtn1Click(Sender: TObject);
var
  sLine:TStringList;
  query:string;
  i:integer;
  url:string;
  uid:string;
begin
  if flEditing then
    BitBtn2Click(nil);
  sLine:=TStringList.Create();
  uid:=formstart.NewGUID();
  sLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  sLine.Add('<ns:Documents Version="1.0"');
  sLine.Add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  sLine.Add('xmlns:xs="http://www.w3.org/2001/XMLSchema"');
  sLine.Add('xmlns:c="http://fsrar.ru/WEGAIS/Common"');
  sLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"');
  sLine.Add('xmlns:tts="http://fsrar.ru/WEGAIS/TransferToShop"');
  sLine.Add('>');
  sLine.Add('<ns:Owner>');
  sLine.Add('<ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  sLine.Add('</ns:Owner>');
  sLine.Add('<ns:Document>');
  sLine.Add('<ns:TransferToShop>');
  sLine.Add('<tts:Identity>'+uid+'</tts:Identity>');
  sLine.Add('<tts:Header>');
  sLine.Add('<tts:TransferNumber>'+edNumDoc.Text+'</tts:TransferNumber>');
  sLine.Add('<tts:TransferDate>'+FormatDateTime('YYYY-MM-DD',dpDateDoc.date)+'</tts:TransferDate>');
  sLine.Add('</tts:Header>');
  sLine.Add('<tts:Content>');
  for i:=1 to StringGrid1.RowCount-1 do begin
    sLine.Add('<tts:Position>');
    sLine.Add('<tts:Identity>'+inttostr(i)+'</tts:Identity>');
    sLine.Add('<tts:ProductCode>'+StringGrid1.Cells[2,i]+'</tts:ProductCode>');
    sLine.Add('<tts:Quantity>'+StringGrid1.Cells[4,i]+'</tts:Quantity>');
    sLine.Add('<tts:InformF2>');
     sLine.Add('<pref:F2RegId>'+StringGrid1.Cells[3,i]+'</pref:F2RegId>');
    sLine.Add('</tts:InformF2>');
    sLine.Add('</tts:Position>');
  end;
  sLine.Add('</tts:Content>');
  sLine.Add('</ns:TransferToShop>');
  sLine.Add('</ns:Document>');
  sLine.Add('</ns:Documents>');
  SLine.Text:=formStart.SaveToServerPOST('opt/in/TransferToShop',sLine.Text);

  url:=formStart.getXMLtoURL(sline.Text);
  if url<>'' then begin
    query:='UPDATE `docjurnale` SET `status`="+++", `uid`="'+url+'", `docid`="'+uid+'" WHERE  `numdoc`="'+edNumDoc.text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',dpDateDoc.date)+'" AND `type`="ActTransferOnShop";';
    formstart.DB_query(query);
    end;
  sLine.Free;
end;

procedure TFormTransferToShop.BitBtn2Click(Sender: TObject);
var

  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  numdoc,datedoc:string;
begin
  datedoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.date) ;
  numdoc:=edNumDoc.text;
  if numdoc='' then begin
         showmessage('Укажите номер документа');
         exit;
       end;
  flEditing:=false;
  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
    xrecbuf:=formstart.DB_query('SELECT `count` FROM `doc27` WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `form2`="'+StringGrid1.Cells[3,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin   // `count`="'+StringGrid1.Cells[3,i]+'",
      flEditing:=true;
      formstart.DB_query('UPDATE `doc27` SET `count`="'+StringGrid1.Cells[4,i]+'" WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `form2`="'+StringGrid1.Cells[3,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc27` (`numdoc`,`datedoc`,`alccode`,`count`,`crdate`,`form2`)'+
        ' VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[2,i]+'","'+StringGrid1.Cells[4,i]+'","'+StringGrid1.Cells[5,i]+'","'+StringGrid1.Cells[3,i]+'");');
    end;
  end;
  if flEditing then begin
    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActTransferOnShop";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then formstart.DB_query('UPDATE `docjurnale` SET `status`="---"  WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActTransferOnShop";')
    else formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActTransferOnShop","---");');
  end else formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`,`docid`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActTransferOnShop","---","");');

  xrecbuf:=formstart.DB_query('SELECT `ownernumdoc` FROM `docx27` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
     flEditing:=true;
     formstart.DB_query('UPDATE `docx27` SET `ownernumdoc`="'+flowNumDoc+'",`ownerdatedoc`="'+flowNumDoc+'" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  end else formstart.DB_query('INSERT INTO `docx27` (`numdoc`,`datedoc`,`ownernumdoc`,`ownerdatedoc`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+flowNumDoc+'","'+flowDateDoc+'");');

end;

procedure TFormTransferToShop.BitBtn3Click(Sender: TObject);
begin
  StringGrid1.DeleteRow(StringGrid1.Row);
end;

procedure TFormTransferToShop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=46)AND(StringGrid1.Row>0) then begin
     StringGrid1.DeleteRow(StringGrid1.Row);
  end;

end;

procedure TFormTransferToShop.CreateUUID();
begin
    self._uuid:= 'doc27:'+formstart.NewGUID();
end;

procedure TFormTransferToShop.CreateDocument;
begin
  formstart.DB_checkCol('doc27','uuid','varchar(100)',''); // универсальный идентификатор элемента
  formstart.DB_checkCol('docx27','uuid','varchar(100)',''); // универсальный идентификатор элемента
  dpDateDoc.Date:=now();
  self.showmodal;
end;

end.

