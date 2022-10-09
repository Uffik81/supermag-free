unit unitCheckedMark;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, ComCtrls, StdCtrls, Buttons;

type

  { TFormCheckedMark }

  TFormCheckedMark = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormCheckedMark: TFormCheckedMark;

implementation

{$R *.lfm}
uses unitstart;
{ TFormCheckedMark }

procedure TFormCheckedMark.BitBtn1Click(Sender: TObject);
var
  query:string;
  alccode1:string;
  ap1,as1:string;
  i:integer;
begin
  StringGrid1.clear;
  if edit1.text='' then
    exit;
  formstart.DecodeEGAISPlomb(edit1.Text,alccode1,ap1,as1) ;
  query:='SELECT `name` FROM `spproduct` WHERE `alccode`="'+alccode1+'" LIMIT 1;' ;
  formStart.recbuf := formStart.DB_query(Query);
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  if formStart.rowbuf<> nil then begin
    StaticText2.Caption:=formStart.rowbuf[0];
  end;
  query:='SELECT `docid`,`numdoc`,`datedoc`,`numposit`,SUM(`factCount`),`price`,(SELECT `crdate` FROM `spformfix` WHERE `spformfix`.`forma`=`doc221`.`forma` AND `spformfix`.`alcitem`=`doc221`.`alcitem` LIMIT 1) AS `crdate`,`forma`  FROM `doc221` WHERE `alcitem`="'+alccode1+'" GROUP BY `forma`, `docid`;' ;
  formStart.recbuf := formStart.DB_query(Query);
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  StringGrid1.RowCount:=1;
  i:=0;
  while formStart.rowbuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=StringGrid1.RowCount+1;
  //    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.cells[1,i]:=formStart.rowbuf[0];
    StringGrid1.cells[2,i]:=formStart.rowbuf[1];
    StringGrid1.cells[3,i]:=formStart.rowbuf[2];
    StringGrid1.cells[4,i]:=formStart.rowbuf[3];
    StringGrid1.cells[5,i]:=formStart.rowbuf[4];
    StringGrid1.cells[6,i]:=formStart.rowbuf[5];
    StringGrid1.cells[7,i]:=formStart.rowbuf[6];
    StringGrid1.cells[8,i]:=formStart.rowbuf[7];
    if formStart.rowbuf[6] = '' then
      formStart.QueryFormA( formStart.rowbuf[7]);
    formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  end;
  query:='SELECT "",`numttn`,`datettn`,"",SUM(`Quantity`),"",(SELECT `crdate` FROM `spformfix` WHERE `spformfix`.`forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `crdate`,`InformARegId`  FROM `regrestsproduct` WHERE `alccode`="'+alccode1+'" GROUP BY `alccode`,`InformARegId`;' ;
  formStart.recbuf := formStart.DB_query(Query);
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  while formStart.rowbuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=StringGrid1.RowCount+1;
  //    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.cells[1,i]:=formStart.rowbuf[0];
    StringGrid1.cells[2,i]:=formStart.rowbuf[1];
    StringGrid1.cells[3,i]:=formStart.rowbuf[2];
    StringGrid1.cells[4,i]:=formStart.rowbuf[3];
    StringGrid1.cells[5,i]:=formStart.rowbuf[4];
    StringGrid1.cells[6,i]:=formStart.rowbuf[5];
    StringGrid1.cells[7,i]:=formStart.rowbuf[6];
    if formStart.rowbuf[6] = '' then
      formStart.QueryFormA( formStart.rowbuf[7]);
    StringGrid1.cells[8,i]:=formStart.rowbuf[7];
    formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  end;
end;

procedure TFormCheckedMark.BitBtn2Click(Sender: TObject);
begin

end;

procedure TFormCheckedMark.Edit1Change(Sender: TObject);
begin

end;

procedure TFormCheckedMark.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then BitBtn1Click(nil);
end;

end.

