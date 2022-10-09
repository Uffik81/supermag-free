unit unitunlockscreen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TFormUnlockScreen }

  TFormUnlockScreen = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormUnlockScreen: TFormUnlockScreen;

implementation
uses unitstart;
{$R *.lfm}

{ TFormUnlockScreen }

procedure TFormUnlockScreen.BitBtn1Click(Sender: TObject);
var
  ch1:string;
begin
  ch1:=formStart.GetConstant('unlockpassword');
  if edit1.text =ch1 then begin
    modalresult:=1377;
    close;
  end;

end;

procedure TFormUnlockScreen.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 CloseAction:=caHide;
end;

procedure TFormUnlockScreen.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
  begin
    key:=#0;
    BitBtn1Click(nil);
  end;
end;

procedure TFormUnlockScreen.FormShow(Sender: TObject);
begin
  edit1.Text:='';
  edit1.SetFocus;

end;

end.

