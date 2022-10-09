unit unitSetPasswordAdmin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MaskEdit, Buttons, ExtCtrls, mysql50;

type

  { TFormSetPasswordAdmin }

  TFormSetPasswordAdmin = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSetPasswordAdmin: TFormSetPasswordAdmin;

implementation

{$R *.lfm}
uses unitStart;
{ TFormSetPasswordAdmin }

procedure TFormSetPasswordAdmin.BitBtn2Click(Sender: TObject);
var
  ps1:string;
begin
  ps1:=formStart.GetConstant('AdminPassword');
  if trim(ps1)=trim(edit3.Text) then begin
    if edit1.Text = edit2.Text then begin
        formStart.SetConstant('AdminPassword',edit2.Text);
      end else
       showmessage('Не совпадает пароль!');
  end
  else
    showmessage('Не верно указан пароль!');
end;

procedure TFormSetPasswordAdmin.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

