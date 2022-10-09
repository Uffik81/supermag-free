unit unitJurnaleAlcForms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids,
  Buttons, Menus, mysql50;

type

  { TFormJurnaleAlcForms }

  TFormJurnaleAlcForms = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn7: TBitBtn;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    pmCreateDocs: TPopupMenu;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure BitBtn11Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  FormJurnaleAlcForms: TFormJurnaleAlcForms;

implementation

{$R *.lfm}
uses
  unitstart,
  unitexportdecalc,
  unitjurnale;

{ TFormJurnaleAlcForms }

procedure TFormJurnaleAlcForms.BitBtn11Click(Sender: TObject);
var
  r:TPoint;
begin
  r:=BitBtn11.ClientOrigin;
  pmCreateDocs.PopUp(r.x,r.y+BitBtn11.Height);
end;

procedure TFormJurnaleAlcForms.MenuItem1Click(Sender: TObject);
begin

end;

procedure TFormJurnaleAlcForms.MenuItem2Click(Sender: TObject);
begin
  formexportdecalc.show;
end;

end.

