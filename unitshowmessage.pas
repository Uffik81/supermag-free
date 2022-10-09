unit unitshowmessage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Buttons, StdCtrls;

type

  { TFormShowMessage }

  TFormShowMessage = class(TForm)
    bbCancel: TBitBtn;
    bbOk: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    ToolBar1: TToolBar;
    procedure bbCancelClick(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flShowStat:boolean;
    procedure Show(aStr:String);
    function  ShowYesNo(aStr:string):boolean;
  end;

var
  FormShowMessage: TFormShowMessage;

implementation
uses
  unitStart
  ,unitShowStatus
  ;
{$R *.lfm}

{ TFormShowMessage }

procedure TFormShowMessage.bbOkClick(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormShowMessage.bbCancelClick(Sender: TObject);
begin
   modalresult:=0;
   close;
end;

procedure TFormShowMessage.Show(aStr: String);
begin
  formstart.sslog.Add(FormatDateTime('DD-MM-YY hh:mm',now())+':'+aStr);
  formstart.sslog.SaveToFile('messages.log');
  flShowStat:= FormShowStatus.Visible;
  if flShowStat then
         FormShowStatus.hide;
  bbCancel.Visible:=false;
  StaticText1.Caption:=aStr;
  showmodal;
  if flShowStat then
         FormShowStatus.show;
end;

function TFormShowMessage.ShowYesNo(aStr: string): boolean;
begin
  formstart.sslog.Add(FormatDateTime('DD-MM-YY hh:mm',now())+':'+aStr);
  formstart.sslog.SaveToFile('messages.log');
  flShowStat:= FormShowStatus.Visible;
  if flShowStat then
         FormShowStatus.hide;
  bbCancel.Visible:=true;
  StaticText1.Caption:=aStr;
  if showmodal = 1377 then
      result:=true
    else
      result:=false;
  if flShowStat then
         FormShowStatus.show;
end;

end.

