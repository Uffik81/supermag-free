unit unitViewOborot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, Buttons;

type

  { TFormViewOborot }

  TFormViewOborot = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    selWBRegId:String;
  end;

var
  FormViewOborot: TFormViewOborot;

implementation

{$R *.lfm}
uses unitstart;
{ TFormViewOborot }

procedure TFormViewOborot.FormShow(Sender: TObject);
var
  i:integer;
  summ:real;
begin
  i:=1;
  StringGrid1.Clear;
  formStart.recbuf:=formStart.DB_query(
  'SELECT `wbregid`,`posit`,`datefix`,`numttn`,`comment`,`quantity` FROM `regFormB` WHERE `wbregid`="'+selWBRegId+'" OR `uid`="'+selWBRegId+'";');
  formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  StringGrid1.RowCount:=5;
  summ:=0;
  while formStart.rowbuf<>nil do begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
    StringGrid1.Rows[i].Add('');
//    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[1]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[2]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[3]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[4]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[5]);
    summ:=summ+StrToFloat(formStart.rowbuf[5]);
    StringGrid1.Rows[i].Add(FloatTostr(summ));
    i:=i+1;
    formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  end;
end;

end.

