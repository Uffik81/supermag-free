unit unitNews;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PReport, SynMemo, SynMacroRecorder, IpHtml,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons;
//, RichBox;

type

  { TFormNews }

  TFormNews = class(TForm)
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    IpHtmlPanel1: TIpHtmlPanel;
    //lzRichEdit1: TlzRichEdit;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormNews: TFormNews;

implementation
uses unitstart;
{$R *.lfm}

{ TFormNews }

procedure TFormNews.FormShow(Sender: TObject);
begin
  //lzrichEdit1.LoadFromFile('news.rtf');
  //IpHtmlPanel1.OpenURL('./license.html');
end;

procedure TFormNews.BitBtn1Click(Sender: TObject);
begin
  if checkbox1.Checked then begin
    formstart.SetConstant('shownews','0');
  end;
  modalresult:=1377;
end;

procedure TFormNews.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if checkbox1.Checked then begin
    formstart.SetConstant('shownews','0');
  end;
  closeaction:=caHide;
end;

end.

