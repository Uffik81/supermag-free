unit unitloginuserv3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TFormLoginUserV3 }

  TFormLoginUserV3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormLoginUserV3: TFormLoginUserV3;

implementation
uses unitstart, mysql50;
{$R *.lfm}

{ TFormLoginUserV3 }

procedure TFormLoginUserV3.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  Combobox1.Clear;
  xrecbuf:=formstart.db_query('SELECT `name` FROM `sprusers`');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
    begin
      Combobox1.Items.Add(xrowbuf[0]);
      xrowbuf:=formstart.DB_Next(xrecbuf);
    end;
end;

procedure TFormLoginUserV3.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=0;
  Close;
end;

procedure TFormLoginUserV3.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    BitBtn1Click(sender);
  end;
end;

procedure TFormLoginUserV3.BitBtn1Click(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin

  xrecbuf:=formstart.db_query('SELECT `userid` FROM `sprusers` WHERE (`password`="'+Edit1.text+'" or `barcodes`="'+Edit1.text+'") AND UPPER(`name`)=UPPER("'+ComboBox1.Caption+'");');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then   begin
    formstart.flCurUserId:=xrowbuf[0];
    ModalResult:=1377;
  end;
end;

end.

