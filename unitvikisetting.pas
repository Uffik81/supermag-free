unit unitvikisetting;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TFormvikisetting }

  TFormvikisetting = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Formvikisetting: TFormvikisetting;

implementation
uses unitstart, inifiles;

{$R *.lfm}

{ TFormvikisetting }

procedure TFormvikisetting.FormShow(Sender: TObject);
begin
  Edit1.Text:=copy(formstart.flVIKIPort,4,4);
  Edit2.Text:=inttostr(formstart.flVIKIBaud);
end;

procedure TFormvikisetting.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFormvikisetting.BitBtn1Click(Sender: TObject);
var
  Fini: TIniFile;
  i: integer;
  sFile: string;
begin
  sFile := formstart.PathFile();
  FIni := TIniFile.Create(sFile + formstart.flFileConfig);
  Fini.Writestring('GLOBAL','vikiport','COM'+Edit1.Text);
  Fini.Writeinteger('GLOBAL','vikibaud',strtoint(Edit2.Text));
  FIni.destroy;
  formstart.flVIKIPort:= 'COM'+Edit1.Text;
  formstart.flVIKIBaud:= strtoint(Edit2.Text);
  close;
end;

procedure TFormvikisetting.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

end.

