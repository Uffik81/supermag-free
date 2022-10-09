unit unitInsertINN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type

  { TFormInsertINN }

  TFormInsertINN = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormInsertINN: TFormInsertINN;

implementation

{$R *.lfm}

{ TFormInsertINN }

procedure TFormInsertINN.BitBtn1Click(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormInsertINN.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFormInsertINN.Edit1Enter(Sender: TObject);
begin
  //BitBtn1Click(nil);
end;

procedure TFormInsertINN.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

end.

