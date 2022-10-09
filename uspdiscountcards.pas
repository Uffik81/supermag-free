unit uspdiscountcards;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, Buttons;

type

  { TFormSpDiscountCards }

  TFormSpDiscountCards = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormSpDiscountCards: TFormSpDiscountCards;

implementation

{$R *.lfm}
uses unitstart, mysql50;
{ TFormSpDiscountCards }

procedure TFormSpDiscountCards.BitBtn1Click(Sender: TObject);
var

  i:integer;
begin
    formstart.DB_query('DELETE FROM `discountcards` ;');
    for i:=1 to StringGrid1.RowCount-1 do
        formstart.DB_query('INSERT INTO  `discountcards` (`card`,`discount`,`name`,`contacts`,`crdate`) VALUES (' +
        ''''+ StringGrid1.Cells[1,i]+''','+
        ''''+ StringGrid1.Cells[2,i]+''','+
        ''''+ StringGrid1.Cells[3,i]+''','+
        ''''+ StringGrid1.Cells[4,i]+''','+
        'NOW()'+
        ')  ;');
end;

procedure TFormSpDiscountCards.BitBtn2Click(Sender: TObject);
begin
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
end;

procedure TFormSpDiscountCards.FormShow(Sender: TObject);
var
    xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  Query:string='';
  i:integer;
begin
  xRecBuf:=formstart.DB_query('SELECT `card`,`discount`,`name`,`contacts`,`crdate` FROM `discountcards` ;','discountcards');
  xRowBuf:=formstart.DB_Next(xrecbuf);
  Stringgrid1.Clear;
  StringGrid1.RowCount:=1;
  while xRowBuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=i+1;
    StringGrid1.Cells[1,i]:=xrowbuf[0];
    StringGrid1.Cells[2,i]:=xrowbuf[1];
    StringGrid1.Cells[3,i]:=xrowbuf[2];
    StringGrid1.Cells[4,i]:=xrowbuf[3];
    xRowBuf:=formstart.DB_Next(xrecbuf);
  end;
end;

end.

