unit unitpdf417;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormgetpdf417 }

  TFormgetpdf417 = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    function getAlcCode():String;
    function GetProducer():String;
  end;

var
  Formgetpdf417: TFormgetpdf417;

implementation

uses unitstart;
{$R *.lfm}

{ TFormgetpdf417 }

function TFormgetpdf417.getAlcCode():String;
var
  mark,ser:string;
begin
  result:='';
  edit1.Text:='';
  if showmodal=1377 then
    begin
      if length(edit1.text) >13 then
        formstart.DecodeEGAISPlomb(edit1.text,result,mark,ser)
      else
        result:=edit1.text;
    end;
end;

function TFormgetpdf417.GetProducer():String;
begin
   result:='';
  edit1.Text:='';
  if showmodal=1377 then
        result:=edit1.text;

end;

procedure TFormgetpdf417.BitBtn1Click(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormgetpdf417.Edit1Enter(Sender: TObject);
begin

end;

procedure TFormgetpdf417.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    modalresult:=1377;
  end;
  if ord(key)>32  then key:=#0;
end;

procedure TFormgetpdf417.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key<96) and (key>32) then  begin
  edit1.text:=edit1.Text+char(lo(key));
  key:=0;
  end;
end;

end.

