unit unitOstatok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Buttons, StdCtrls, Menus, Grids,mysql50;

type

  { TFormOstatok }

  TFormOstatok = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    miAlcItem: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    stTTN: TStaticText;
    StaticText4: TStaticText;
    ToggleBox1: TToggleBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure miAlcItemClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    RowSelected:Integer;
    procedure Refresh;
  end;

var
  FormOstatok: TFormOstatok;

implementation

{$R *.lfm}
uses UnitStart, uniteditforma, unittransfertoshop, unitalcitem;
{ TFormOstatok }

procedure TFormOstatok.FormShow(Sender: TObject);
var
  i:integer;
  status1:String;
  query:string;
begin
  Caption:='Текущие остатки в ЕГАИС. Остатки были получены:'+formStart.GetConstant('finupdaterest') ;
  RowSelected:=-1;
  i:=1;
  StringGrid1.clear;
  StringGrid1.RowCount:=5;
  if not formStart.ConnectDB() then
    exit;
  Query:='SELECT AlcName,InformARegId,InformBRegId,Quantity,AlcCode,dateTTN,numTTN,(SELECT `crdate` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `crdate`,(SELECT `numfix` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `numfix` FROM `regrestsproduct` ';
  if ToggleBox1.Checked then Query:=Query+' WHERE `AlcCode` LIKE "%'+Edit1.text+'%" OR `AlcName` LIKE "%'+Edit1.text+'%"';
  Query:=Query+' ORDER BY `AlcCode` ASC;' ;
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  if formStart.rowbuf=Nil then begin
    formStart.disconnectDB();
    exit;
  end;
//  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
     with StringGrid1.rows[i] do begin
       Add('');
       Add(formStart.rowbuf[4]);
       Add(formStart.rowbuf[0]);         //3
       Add(formStart.rowbuf[1]);
       Add(formStart.rowbuf[2]);
       Add(formStart.rowbuf[3]);
       Add(formStart.rowbuf[5]);
       Add(formStart.rowbuf[4]);
       Add(formStart.rowbuf[6]);
       Add(formStart.rowbuf[7]);
       Add(formStart.rowbuf[8]);
     end;
      i:=i+1;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end  ;
  formStart.disconnectDB();
end;

procedure TFormOstatok.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 { if RowSelected>0 then begin
    StaticText1.Caption:=ListView1.Selected.SubItems.Strings[0];
    Edit2.text:=ListView1.Selected.Caption;
    stTTN.Caption:=ListView1.Selected.SubItems.Strings[6]+' от '+ListView1.Selected.SubItems.Strings[3];
  end;   }
end;

procedure TFormOstatok.MenuItem1Click(Sender: TObject);
begin
  // === Вызов Справки А  ====
  if RowSelected>=0 then begin
    formeditforma.fAlcCode   :=StringGrid1.Rows[RowSelected].Strings[1];
    formeditforma.fName      :=StringGrid1.Rows[RowSelected].Strings[2];
    formeditforma.fEGAISFormA:=StringGrid1.Rows[RowSelected].Strings[3];
    formeditforma.ShowModal;
  end;
end;

{
<?xml version="1.0" encoding="UTF-8"?>
<ns:Documents Version="1.0"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
 xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB">
<ns:Owner>
<ns:FSRAR_ID>00040218</ns:FSRAR_ID> (1.13.1)
</ns:Owner>
<ns:Document>
<ns:QueryFormA>
<qf:FormRegId>000000000000036</qf:FormRegId>
</ns:QueryFormA>
</ns:Document>
</ns:Documents>
}
procedure TFormOstatok.MenuItem2Click(Sender: TObject);
var
    sLine:TStringList;
begin
  // ===== Запрос справки А ==

  if RowSelected>=0 then begin
    sLine:=TStringList.Create();
    sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
    sLine.Add('<ns:Documents Version="1.0"');
    sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
    sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
    sLine.Add('<ns:Owner>');
    sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
    sLine.Add('</ns:Owner>');
    sLine.Add('<ns:Document>');
    sLine.Add('<ns:QueryFormA>');
    sLine.Add('<qf:FormRegId>'+StringGrid1.Rows[RowSelected].Strings[3]+'</qf:FormRegId>');
    sLine.Add('</ns:QueryFormA> ');
    sLine.Add('</ns:Document>');
    sLine.Add('</ns:Documents>');
    formStart.SaveToServerPOST('opt/in/QueryFormA',SLine.text);
    sLine.Free;
    showMessage('Запрос отправлен!');
  end;
end;

procedure TFormOstatok.MenuItem3Click(Sender: TObject);
var
    sLine:TStringList;
begin
  // ===== Запрос справки B ==
  if RowSelected>=0 then begin
    sLine:=TStringList.Create();
    sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
    sLine.Add('<ns:Documents Version="1.0"');
    sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
    sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
    sLine.Add('<ns:Owner>');
    sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
    sLine.Add('</ns:Owner>');
    sLine.Add('<ns:Document>');
    sLine.Add('<ns:QueryFormB>');
    sLine.Add('<qf:FormRegId>'+StringGrid1.Rows[RowSelected].Strings[4]+'</qf:FormRegId>');
    sLine.Add('</ns:QueryFormB> ');
    sLine.Add('</ns:Document>');
    sLine.Add('</ns:Documents>');
    formStart.SaveToServerPOST('opt/in/QueryFormB',SLine.text);
    sLine.Free;
    showMessage('Запрос отправлен!');
  end;

end;

procedure TFormOstatok.MenuItem4Click(Sender: TObject);
begin
  if RowSelected>=0 then begin
    FormStart.SendQueryHistoryFormB(StringGrid1.Rows[RowSelected].Strings[4]);

  end;
end;

procedure TFormOstatok.miAlcItemClick(Sender: TObject);
begin
  if RowSelected>=0 then begin
  FormAclItem.flAlcCode :=StringGrid1.Rows[RowSelected].Strings[1] ;
  FormAclItem.ShowModal;

  end;
end;

procedure TFormOstatok.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
    if (aRow>=0) then begin
      RowSelected:=aRow;
    End;

end;

procedure TFormOstatok.ToggleBox1Change(Sender: TObject);
begin

end;

procedure TFormOstatok.ToggleBox1Click(Sender: TObject);
begin
  FormShow(nil);
end;

procedure TFormOstatok.Refresh;
begin
  FormShow(nil);
end;

procedure TFormOstatok.BitBtn1Click(Sender: TObject);
begin
  FormStart.readOstatok();
end;

procedure TFormOstatok.BitBtn2Click(Sender: TObject);
var
    i:integer;
begin
  // =====
  formtransfertoshop.StringGrid1.Clean;
  formtransfertoshop.StringGrid1.RowCount:=stringgrid1.RowCount;
  for i:=1 to stringgrid1.RowCount-1 do begin
    formtransfertoshop.StringGrid1.Cells[1,i]:=StringGrid1.Cells[2,i];
    formtransfertoshop.StringGrid1.Cells[2,i]:=StringGrid1.Cells[1,i];
    formtransfertoshop.StringGrid1.Cells[3,i]:=StringGrid1.Cells[4,i];
    formtransfertoshop.StringGrid1.Cells[4,i]:=StringGrid1.Cells[5,i];
    formtransfertoshop.StringGrid1.Cells[5,i]:=StringGrid1.Cells[9,i];
  end;
  formtransfertoshop.flEditing:=true;
  formtransfertoshop.CreateDocument;

end;

end.

