unit unitLoginAdmin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ExtCtrls;

type

  { TFormLoginAdmin }

  TFormLoginAdmin = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flFullMode:boolean;
  end;

var
  FormLoginAdmin: TFormLoginAdmin;

implementation

{$R *.lfm}
uses unitStart, mysql50;
{ TFormLoginAdmin }

procedure TFormLoginAdmin.BitBtn1Click(Sender: TObject);
var
  ps1:String;
begin

  ps1:=formStart.GetConstant('AdminPassword');
  if trim(ps1) = edit1.text then
    ModalResult:=1377
    else
      showMessage('Не верный пароль!');

end;

procedure TFormLoginAdmin.BitBtn10Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'9';
end;

procedure TFormLoginAdmin.BitBtn11Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'0';
end;

procedure TFormLoginAdmin.BitBtn12Click(Sender: TObject);
begin
  edit1.text:=copy(edit1.text,1,length(edit1.text)-1);
end;

procedure TFormLoginAdmin.BitBtn13Click(Sender: TObject);
begin
  ModalResult:=0;
end;

procedure TFormLoginAdmin.BitBtn14Click(Sender: TObject);
begin
  edit1.text:='';
end;

procedure TFormLoginAdmin.BitBtn2Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'1';
end;

procedure TFormLoginAdmin.BitBtn3Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'2';
end;

procedure TFormLoginAdmin.BitBtn4Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'3';
end;

procedure TFormLoginAdmin.BitBtn5Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'4';
end;

procedure TFormLoginAdmin.BitBtn6Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'5';
end;

procedure TFormLoginAdmin.BitBtn7Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'6';
end;

procedure TFormLoginAdmin.BitBtn8Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'7';
end;

procedure TFormLoginAdmin.BitBtn9Click(Sender: TObject);
begin
  edit1.text:=edit1.text+'8';
end;

procedure TFormLoginAdmin.Edit1Change(Sender: TObject);
begin

end;

procedure TFormLoginAdmin.Edit1Enter(Sender: TObject);
begin
   // BitBtn1Click(nil);
end;

procedure TFormLoginAdmin.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
      BitBtn1Click(nil);
end;

procedure TFormLoginAdmin.FormShow(Sender: TObject);
begin
  if flFullMode then begin
    height:=panel1.Height+1+panel2.Height;
    panel2.Visible:=true;
  end else begin
     height:=panel1.Height+1;
    panel2.Visible:=false;
  end;

  edit1.Text:='';
  edit1.SetFocus;
end;

procedure TFormLoginAdmin.Panel2Click(Sender: TObject);
begin

end;

end.

