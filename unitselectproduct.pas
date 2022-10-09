unit unitselectproduct;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, Buttons, StdCtrls;

type

  { TFormSelectProduct }

  TFormSelectProduct = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid1Resize(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
  public
    { public declarations }
    selAlcCode:String;
  end;

var
  FormSelectProduct: TFormSelectProduct;

implementation

{$R *.lfm}
uses unitstart;

{ TFormSelectProduct }

procedure TFormSelectProduct.BitBtn2Click(Sender: TObject);
var
  query:string;
  ind:integer;
begin
  if Edit1.text = '' then
   query:='SELECT `AlcCode`,`name`, (SELECT `currentprice` FROM `sprgoods` WHERE `extcode`=`spproduct`.`alccode`) AS `price` FROM `spproduct` WHERE UPPER(`name`) LIKE  UPPER(''%%'');'
   else
  query:='SELECT `AlcCode`,`name`, (SELECT `currentprice` FROM `sprgoods` WHERE `extcode`=`spproduct`.`alccode`) AS `price` FROM `spproduct` WHERE UPPER(`name`) LIKE  UPPER(''%'+Edit1.text+'%'');';
  formstart.recbuf:=formstart.DB_query(query);
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  stringgrid1.RowCount:=2;
  while formstart.rowbuf<>nil do begin
    stringgrid1.rows[stringgrid1.RowCount-1].Clear;
    stringgrid1.Cells[1,stringgrid1.RowCount-1]:= formstart.rowbuf[0];
    stringgrid1.Cells[2,stringgrid1.RowCount-1]:= formstart.rowbuf[1];
    stringgrid1.Cells[3,stringgrid1.RowCount-1]:= formstart.rowbuf[2];
    formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    stringgrid1.RowCount:=stringgrid1.RowCount+1;
  end;
  stringgrid1.SetFocus;
end;

procedure TFormSelectProduct.BitBtn1Click(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormSelectProduct.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    BitBtn2Click(nil);
    key:=#0;
  end;
end;

procedure TFormSelectProduct.FormShow(Sender: TObject);
begin
  edit1.SetFocus;
  edit1.SelectAll;
end;

procedure TFormSelectProduct.StringGrid1KeyPress(Sender: TObject; var Key: char
  );
begin
  if key=#13 then begin
    modalresult:=1377;
    key:=#0;
  end;
end;

procedure TFormSelectProduct.StringGrid1Resize(Sender: TObject);
var
   namesize:integer;
   i:integer;
begin
  namesize:=StringGrid1.Width;
  for i:=0 to Stringgrid1.Columns.Count-1 do
   if i<>1 then
    namesize:=namesize - StringGrid1.Columns.Items[i].Width;
  namesize:=namesize-3;
  StringGrid1.Columns.Items[1].Width:=namesize;

end;

procedure TFormSelectProduct.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
  selAlcCode:=StringGrid1.Cells[1,aRow];
end;


end.

