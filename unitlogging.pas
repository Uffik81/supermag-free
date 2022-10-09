unit unitlogging;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls;

type

  { TFormLogging }

  TFormLogging = class(TForm)
    sgLogging: TStringGrid;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flShowing:boolean;
    procedure AddMessage(aStr:String;aStatus:string='');
  end;

var
  FormLogging: TFormLogging;

implementation

{$R *.lfm}
uses unitstart, unitsalesbeer;
{ TFormLogging }

procedure TFormLogging.Timer1Timer(Sender: TObject);
begin
  if formstart.flHideLog then
    if self.Visible then
      self.Visible:=false;
end;

procedure TFormLogging.FormCreate(Sender: TObject);
begin
  flShowing:=true;
end;

procedure TFormLogging.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;
end;

procedure TFormLogging.FormResize(Sender: TObject);
var
  ind:integer;
  ttop,lleft:integer;
begin
  lleft:=screen.Width-width;
  ttop:=screen.Height-Height;
  self.Left:=lleft;
  self.Top:=ttop;
end;

procedure TFormLogging.AddMessage(aStr:String;aStatus:string='');
var
  ind:integer;
  ttop,lleft:integer;
begin
  formstart.trayicon1.BalloonHint:=aStr;
  formstart.trayicon1.ShowBalloonHint;
  ind:=sgLogging.RowCount;
  sgLogging.rowCount:=ind+1;
  sgLogging.rows[ind].Add(aStatus);
  sgLogging.rows[ind].Add(aStr);
  //self.MoveToDefaultPosition;
  //trayicon1.ShowBalloonHint;
  sgLogging.Row:=ind;
{  exit;
  show;
  lleft:=screen.Width-self.width;
  ttop:=screen.Height-self.Height;
  self.Left:=round(lleft);
  self.Top:=round(ttop-35);

  if not formsalesbeer.Visible then begin

    self.Resizing(wsNormal);
    Screen.MoveFormToZFront(self);
    repaint;
    show;
  end;
  timer1.Enabled:=true;   }
end;

end.

