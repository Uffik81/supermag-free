unit unitcomment;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons;

type

  { TFormComment }

  TFormComment = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormComment: TFormComment;

implementation

{$R *.lfm}

{ TFormComment }

procedure TFormComment.BitBtn1Click(Sender: TObject);
begin
  Modalresult:=1377;
end;

procedure TFormComment.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;
end;

end.

