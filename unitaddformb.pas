unit unitaddFormB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,mysql50;

type

  { TFormAddFormB }

  TFormAddFormB = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    stAlcCode: TStaticText;
    StaticText4: TStaticText;
    StCrDate: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1ChangeBounds(Sender: TObject);
    procedure ComboBox1GetItems(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    sItem:TStringList;
    sFormA:TStringList;
    sCount:TStringList;
    sCrDate:TStringList;
  public
    { public declarations }
    selFormB:String;
    selTovar:String;
    selCount:String;
    selFormA:String;
    selAlcCode:String;
  end;

var
  FormAddFormB: TFormAddFormB;

implementation

{$R *.lfm}
uses unitStart;
{ TFormAddFormB }

procedure TFormAddFormB.FormShow(Sender: TObject);
var
  i:integer;
  status1:String;
  sLine:TStringList;
  Query:String;
begin
  i:=1;

  ComboBox1.Items.Clear;
  sItem.Clear;
  sFormA.Clear;
  sCount.Clear;
  sCrDate.Clear;
  formStart.ConnectDB();
  if selAlcCode<>'' then begin
    Query:='SELECT `AlcName`,`AlcCode` FROM `regrestsproduct` WHERE `alcCode`="'+selAlcCode+'" GROUP BY `alcCode`;';
    ComboBox1.ItemIndex:=0;
  end
  else
    Query:='SELECT `AlcName`,`AlcCode` FROM `regrestsproduct`;';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  if formStart.recbuf=Nil then
    exit;
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin
     ComboBox1.Items.Add(formStart.rowbuf[0]);
     sItem.Add(formStart.rowbuf[1]);
     ComboBox1.Caption:= formStart.rowbuf[0];

     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end;
  Edit1.Text:=selCount;
  stAlcCode.Caption:=selAlcCode;
//  formStart.disconnectDB();
end;

procedure TFormAddFormB.ComboBox1Change(Sender: TObject);
var
  i:integer;
    status1:String;
  sLine:TStringList;
  sID:String;
  Query:String;
begin
  sID:=sItem.Strings[ComboBox1.ItemIndex];
  ComboBox2.Items.Clear;
  sFormA.Clear;
  sCount.Clear;
  sCrDate.Clear;
  formStart.ConnectDB();
  Query:='SELECT `InformBRegId`,`InformARegId`,`Quantity`,`crdate` FROM `regrestsproduct`,`spformfix` WHERE `regrestsproduct`.`AlcCode`='''+sID+''' AND `spformfix`.`forma`=`regrestsproduct`.`InformARegId` GROUP BY `regrestsproduct`.`InformBRegId`;';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  if formStart.recbuf=Nil then
    exit;
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   while formStart.rowbuf<>nil do
   begin
     ComboBox2.Items.Add(formStart.rowbuf[0]);
     sFormA.Add(formStart.rowbuf[1]);
     sCount.Add(formStart.rowbuf[2]);
     sCrDate.add(formStart.rowbuf[3]);
     ComboBox2.Caption:= formStart.rowbuf[0];
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end;
   ComboBox2.ItemIndex:=0;
//  formStart.disconnectDB();
end;

procedure TFormAddFormB.BitBtn1Click(Sender: TObject);
begin

  selFormB:=ComboBox2.Caption;
  selTovar:=ComboBox1.Caption;
  selCount:=Edit1.Text;

  modalresult:=1377;
end;

procedure TFormAddFormB.ComboBox1ChangeBounds(Sender: TObject);
begin

end;

procedure TFormAddFormB.ComboBox1GetItems(Sender: TObject);
begin

end;

procedure TFormAddFormB.ComboBox1Select(Sender: TObject);
begin

end;

procedure TFormAddFormB.ComboBox2Change(Sender: TObject);
begin

  StaticText1.Caption:=sFormA.Strings[ComboBox2.ItemIndex];
  StaticText2.Caption:=sCount.Strings[ComboBox2.ItemIndex];
  stcrdate.Caption:=sCrDate.Strings[ComboBox2.ItemIndex];
  SelFormA:= StaticText1.Caption;
end;

procedure TFormAddFormB.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  formStart.disconnectDB();
end;

procedure TFormAddFormB.FormCreate(Sender: TObject);
begin
  sItem:=TStringList.Create;
  sFormA:=TStringList.Create;
  sCount:=TStringList.Create;
  scrdate:=TStringList.Create;
end;

procedure TFormAddFormB.FormDestroy(Sender: TObject);
begin
  sItem.free;
  sFormA.free;
  sCount.free;
  scrdate.free;
end;

end.

