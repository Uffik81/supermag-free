unit unithonestsign;
// ==== Честный знак ====
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, mysql50;

type

  { TFormHonestSign }

  TFormHonestSign = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  FormHonestSign: TFormHonestSign;

implementation
uses unitstart;
{$R *.lfm}

{ TFormHonestSign }

procedure TFormHonestSign.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

end.

