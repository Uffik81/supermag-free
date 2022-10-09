unit unitRepOborot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, mysql50;

type

  { TFormRepOborot }

  TFormRepOborot = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1ChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    SelAlcCode:String;
    lsFormA:TStringList;
    lsFormB:TStringList;
  end;

var
  FormRepOborot: TFormRepOborot;

implementation
{$R *.lfm}

uses
  unitStart,
  unitreport,
  unitViewReport,
  unitspProduct;

{ TFormRepOborot }

procedure TFormRepOborot.BitBtn1Click(Sender: TObject);
var
  i:integer;
  ii:integer;
  iii:integer;
  query:string;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
  flend:boolean;
begin
  formStart.SendQueryHistoryFormB(combobox2.Caption);
end;

procedure TFormRepOborot.BitBtn2Click(Sender: TObject);
var
  i:integer;
  ii:integer;
  iii:integer;
  query:string;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
  flend:boolean;
begin
  if formspproduct.ShowModal=1377 then
   // if formspproduct.flSelected then
    begin
       SelAlcCode:=formspproduct.sAlcCode;
       Edit1.Text:=formspproduct.sAlcName;
       lsFormA.Clear;
       lsFormB.Clear;
       combobox1.Items.Clear;
       combobox1.Text:='';
       combobox2.Items.Clear;
       combobox2.Text:='';
       recbuf:=FormStart.DB_query('SELECT `forma`,`crdate` FROM `spformfix` WHERE `alccode`="'+SelAlcCode+'";');
       rowbuf:=FormStart.DB_Next(recbuf);
       while rowbuf<>nil do begin
         lsFormA.Add(rowbuf[1]);
         combobox1.Items.Add(rowbuf[0]);
       end;
    end;
end;

procedure TFormRepOborot.ComboBox1Change(Sender: TObject);
var
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
begin
  StaticText2.Caption:=lsFormA.Strings[ComboBox1.ItemIndex];
  combobox2.Items.Clear;
  combobox2.Text:='';
  recbuf:=FormStart.DB_query('SELECT `forma`,`crdate` FROM `docformab` WHERE `alcitem`="'+SelAlcCode+'" AND `forma`="'+ComboBox1.Caption+'";');
  rowbuf:=FormStart.DB_Next(recbuf);
  while rowbuf<>nil do begin
    lsFormB.Add(rowbuf[1]);
    combobox2.Items.Add(rowbuf[0]);
  end;
end;

procedure TFormRepOborot.ComboBox1ChangeBounds(Sender: TObject);
begin

end;

procedure TFormRepOborot.FormCreate(Sender: TObject);
begin
  lsFormA:=TStringList.Create;
  lsFormB:=TStringList.Create;
end;


end.

