unit unitsetalcdate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormSetAlcDate }

  TFormSetAlcDate = class(TForm)
    BitBtn1: TBitBtn;
    cbDate: TComboBox;
    Edit1: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText5: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbDateChangeBounds(Sender: TObject);
    procedure cbDateEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    tbForm1:TStringList;
    flDate:String;
    flForm1:String;
    flAlcCode:String;
  end;

var
  FormSetAlcDate: TFormSetAlcDate;

implementation

{$R *.lfm}

{ TFormSetAlcDate }
uses unitstart, mysql50;

procedure TFormSetAlcDate.FormCreate(Sender: TObject);
begin
  tbForm1:=TStringList.Create;
  tbForm1.Clear;
end;

procedure TFormSetAlcDate.cbDateEditingDone(Sender: TObject);
begin
  fldate:=cbDate.caption;
end;

procedure TFormSetAlcDate.BitBtn1Click(Sender: TObject);
begin
  if cbDate.caption='' then begin
    showmessage('Заполните дату розлива!');
    exit;
  end;

  fldate:=cbDate.caption;
  if fldate<>'' then
    try
      flForm1:=tbform1.Strings[cbDate.Items.IndexOf(cbDate.Caption)];
    except
      flForm1:='';
    end;
  modalresult:=1377;
end;

procedure TFormSetAlcDate.cbDateChangeBounds(Sender: TObject);
begin
//  statictext3.Caption:=tbform1.Strings[cbDate.Items.IndexOf(cbDate.Caption)];
  if cbDate.Caption<>'' then
  flForm1:=tbform1.Strings[cbDate.Items.IndexOf(cbDate.Caption)];
end;

procedure TFormSetAlcDate.FormDestroy(Sender: TObject);
begin
  tbForm1.Destroy;
end;

procedure TFormSetAlcDate.FormShow(Sender: TObject);
var
  con1:integer;
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  query:string;
begin
  query:= 'SELECT `spformfix`.`crdate`,`regrestsproduct`.`InformARegId` FROM `regrestsproduct`,`spformfix`  WHERE `regrestsproduct`.`alccode`="'+flAlcCode+'" AND `spformfix`.`forma` = `regrestsproduct`.`InformARegId`; ';
  xrecbuf:=FormStart.DB_Query(query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  cbDate.Items.Clear;
  tbform1.Clear;
  while xrowbuf<>nil do begin
    cbDate.Items.Add(xrowbuf[0]);
    tbForm1.Add(xrowbuf[1]);
    xrowbuf:=formStart.DB_Next(xrecbuf);
  end;

end;

end.

