unit unitAddOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ComCtrls, mysql50;

type

  { TFormAddOptions }

  TFormAddOptions = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    cbEnableKKM: TCheckBox;
    cbTypeKKM: TComboBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    cbAutoEAN13: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    edPrefixCard: TEdit;
    edPrefixVesi: TEdit;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormAddOptions: TFormAddOptions;

implementation

{$R *.lfm}
uses unitStart, unitSupportUTM, unitsalesbeerts, inifiles;
{ TFormAddOptions }

procedure TFormAddOptions.BitBtn1Click(Sender: TObject);
var
  Fini:TIniFile;
  indKKM:integer;
begin
  if checkbox1.Checked then
      formStart.SetConstant('AdminUpdate','1')
    else
      formStart.SetConstant('AdminUpdate','0');
  if checkbox2.Checked then
      formStart.SetConstant('DocStatusEdit','1')
    else
      formStart.SetConstant('DocStatusEdit','0');
  if checkbox5.Checked then
      formStart.SetConstant('StornoEdit','1')
    else
      formStart.SetConstant('StornoEdit','0');

  if cbAutoEAN13.Checked then
      formStart.SetConstant('AddBarCodeEAN13','1')
    else
      formStart.SetConstant('AddBarCodeEAN13','0');

  formStart.SetConstant('prefixvesi',edPrefixVesi.text);
  formStart.SetConstant('prefixcard',edPrefixcard.text);
  indKKM:=cbTypeKKM.Items.IndexOf(cbTypeKKM.Caption);
  formStart.SetConstant('TypeKKM',inttostr(indKKM));
  //FIni:=TIniFile.Create('egaismon.ini');
  //Fini.WriteBool('GLOBAL','KKMEnabled',cbEnableKKM.Checked);
  //Fini.WriteBool('GLOBAL','rmkoffline',CheckBox4.Checked);
  //Fini.WriteBool('GLOBAL','kkmsberbank',CheckBox3.Checked);

  //Fini.Destroy;
  showmessage('Настройки сохранены.');
end;

procedure TFormAddOptions.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormAddOptions.BitBtn3Click(Sender: TObject);
begin
  formSupportUTM.ShowModal;
end;

procedure TFormAddOptions.BitBtn4Click(Sender: TObject);
var
  Query:string;
  ean13:string;
begin
  formstart.recbuf:=formStart.DB_query('SELECT `alccode`,`eanbc`,(SELECT `name` FROM `spproduct` WHERE `alccode` = `doccash`.`AlcCode`) as `name`,`price` FROM `doccash` WHERE `eanbc`<>"";');
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  while formstart.rowbuf<>nil do
    begin
      formstart.SetEAN13rib(formstart.rowbuf[0],formstart.rowbuf[2],formstart.rowbuf[1]);
      formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
      if formstart.DB_next(formStart.DB_query('SELECT `barcodes` FROM `sprgoods` WHERE `extcode`="'+formstart.rowbuf[0]+'" ;'))<>nil then
          formstart.DB_query('UPDATE `sprgoods` SET `barcodes`="'+formstart.rowbuf[1]+'",`currentprice`="'+formstart.rowbuf[3]+'" WHERE ``="'+formstart.rowbuf[0]+'" AND `barcodes`=""')
          else begin
           Query:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+trim(formstart.rowbuf[1])+''','''+formstart.rowbuf[0]+''',''+'',''+'','''+trim(formstart.rowbuf[2])+''','''+trim(formstart.rowbuf[2])+''','''+formstart.rowbuf[3]+''');';
           formStart.DB_query(Query);
          end;
          //formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
    end;
  if formstart.flOptMode  then
      begin  // Обрабатываем данные если это оптовая база
       formstart.recbuf:=formStart.DB_query('SELECT `alcitem`,`listean13`,(SELECT `name` FROM `spproduct` WHERE `alccode` = `doc211`.`Alcitem`) as `name`,`price` FROM `doc211` WHERE `listean13`<>"";');
       formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
       while formstart.rowbuf<>nil do
         begin
           formstart.SetEAN13rib(formstart.rowbuf[0],formstart.rowbuf[2],copy(formstart.rowbuf[1],2,13));
           formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
           if formstart.DB_next(formStart.DB_query('SELECT `barcodes` FROM `sprgoods` WHERE `extcode`="'+formstart.rowbuf[0]+'" ;'))<>nil then
               formstart.DB_query('UPDATE `sprgoods` SET `barcodes`="'+copy(formstart.rowbuf[1],2,13)+'",`currentprice`="'+formstart.rowbuf[3]+'" WHERE ``="'+formstart.rowbuf[0]+'" AND `barcodes`=""')
               else begin
                Query:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+trim(copy(formstart.rowbuf[1],2,13))+''','''+formstart.rowbuf[0]+''',''+'',''+'','''+trim(formstart.rowbuf[2])+''','''+trim(formstart.rowbuf[2])+''','''+formstart.rowbuf[3]+''');';
                formStart.DB_query(Query);
               end;
           //formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
         end;

      end;

  formstart.recbuf:=formStart.DB_query('SELECT `alccode`,`alcname`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`regrestsproduct`.`alccode`) as `ean13` FROM `regrestsproduct` WHERE `ean13`="";');
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  while formstart.rowbuf<>nil do
    begin
      ean13:=formstart.GetEAN13rib(formstart.rowbuf[0]);
      if formstart.DB_next(formStart.DB_query('SELECT `barcodes` FROM `sprgoods` WHERE `extcode`="'+formstart.rowbuf[0]+'" ;'))<>nil then
          formstart.DB_query('UPDATE `sprgoods` SET `barcodes`="'+ean13+'" WHERE ``="'+formstart.rowbuf[0]+'" AND `barcodes`=""')
          else begin
           Query:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`)VALUE ('''+trim(ean13)+''','''+formstart.rowbuf[0]+''',''+'',''+'','''+trim(formstart.rowbuf[1])+''','''+trim(formstart.rowbuf[1])+''');';
           formStart.DB_query(Query);
          end;


      formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
    end;
end;

procedure TFormAddOptions.BitBtn5Click(Sender: TObject);
begin
  formsalesbeerts.InitDevice;
  formsalesbeerTS.ShowKKMOption();
end;

procedure TFormAddOptions.BitBtn6Click(Sender: TObject);
begin
  formsalesbeerts.InitDevice;
  FormSalesBeerTS.printURL('http://egais.retailika.ru/','TEST1234567890TEST1234567890TEST1234567890TEST1234567890TEST1234567890');
end;

procedure TFormAddOptions.Button1Click(Sender: TObject);
var
  tmprrn,tmpauth:string;
begin
  tmprrn:=Edit2.text;
  tmpauth:='';
  if formsalesbeerTS.CancelSalesCardSB(0,strtofloat(edit1.text),tmprrn,tmpauth)<>-1 then
      showmessage('Операция проведена успешно:'+tmprrn+''+tmpauth)
end;

procedure TFormAddOptions.CheckBox3Change(Sender: TObject);
begin

end;

procedure TFormAddOptions.FormShow(Sender: TObject);
begin
  cbTypeKKM.Caption:=cbTypeKKM.Items.Strings[formSalesBeerTS.flTypeKKM];
 checkbox1.Checked:= formStart.flUpdateAdmin ;
 checkbox2.Checked:= formStart.flDocStatusEdit;
 cbEnableKKM.Checked:=formStart.flKKMEnabled;
 checkbox3.Checked:= formStart.flKKMSberbank;
 checkbox4.Checked:= formStart.flRmkOffline;
 edPrefixVesi.text:=formStart.GetConstant('prefixvesi');
 edPrefixcard.text:=formStart.GetConstant('prefixcard');
 if formStart.GetConstant('AddBarCodeEAN13') = '1' then  cbAutoEAN13.checked:=true else
   cbAutoEAN13.checked:=False;
end;

end.

