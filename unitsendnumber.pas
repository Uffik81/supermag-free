unit unitsendnumber;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons;

type

  { TFormSendNumber }

  TFormSendNumber = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSendNumber: TFormSendNumber;

implementation

{$R *.lfm}

{ TFormSendNumber }

procedure TFormSendNumber.BitBtn1Click(Sender: TObject);
begin

end;

procedure TFormSendNumber.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFormSendNumber.Edit1Change(Sender: TObject);
begin

end;

procedure TFormSendNumber.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then begin
      key:=#0;
      modalresult:=mrOk;

  end;
end;

procedure TFormSendNumber.FormShow(Sender: TObject);
begin
  edit1.SelectAll;
end;

end.

