unit unitOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, ColorBox, mysql50;

type

  { TFormOptions }

  TFormOptions = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Button1: TButton;
    cbAddReportFileZ: TCheckBox;
    cbDisableutm: TCheckBox;
    cbExtExch: TCheckBox;
    cbLoadFoneGoods: TCheckBox;
    cbRefresh: TCheckBox;
    CheckBox1: TCheckBox;
    cbLoadTTN: TCheckBox;
    cbLoadForm1: TCheckBox;
    cbLoadRest: TCheckBox;
    cbLoadRestShop: TCheckBox;
    cbUpdateRest: TCheckBox;
    cbHideLog: TCheckBox;
    cbAlcDateControl: TCheckBox;
    cbEnableAuth: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    cbExchMod: TCheckBox;
    CheckGroup1: TCheckGroup;
    cbNowDocum: TColorBox;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    edDirRetailOpt: TEdit;
    edEmail: TEdit;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    edHostExchMod: TEdit;
    ed_home: TEdit;
    ed_street: TEdit;
    ed_city: TEdit;
    ed_region: TEdit;
    ed_zip: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    edTable1Qual: TEdit;
    Edit5: TEdit;
    edTable2Qual: TEdit;
    edTable3Qual: TEdit;
    edtelephone: TEdit;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    gbExchMod: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    leFSRAR: TLabeledEdit;
    ScrollBox1: TScrollBox;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText19: TStaticText;
    StaticText2: TStaticText;
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    StaticText22: TStaticText;
    StaticText23: TStaticText;
    StaticText24: TStaticText;
    StaticText25: TStaticText;
    StaticText3: TStaticText;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PageControl1: TPageControl;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ToolBar1: TToolBar;
    unLockScreen: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbDisableutmChange(Sender: TObject);
    procedure cbExchModChange(Sender: TObject);
    procedure cbExchModChangeBounds(Sender: TObject);
    procedure cbLoadForm1Change(Sender: TObject);
    procedure cbRefreshChange(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

{$R *.lfm}
uses unitStart, INIFiles, unitSetPasswordAdmin,unitloginAdmin,unitaddoptions;
{ TFormOptions }

procedure TFormOptions.BitBtn1Click(Sender: TObject);
begin
 // formStart.DB_query('');
 // formStart.CreateBD();
  hide;
  formloginAdmin.flFullMode:=false;
  if formloginAdmin.ShowModal=1377 then
     formaddoptions.ShowModal;
  show;
  formloginAdmin.flFullMode:=true;
end;

procedure TFormOptions.BitBtn2Click(Sender: TObject);
var
  Fini:TIniFile;
  i:integer;
begin
  FIni:=TIniFile.Create('egaismon.ini');
//  Fini.
  Fini.WriteString('GLOBAL','pathDir',Edit1.Text);
  Fini.WriteString('GLOBAL','mysqlurl',edit2.text);
  Fini.WriteString('GLOBAL','mysqluser',edit3.text);
  Fini.WriteString('GLOBAL','mysqlpassword',edit4.text);
  Fini.WriteString('GLOBAL','utmip',edit5.text);
  Fini.WriteString('GLOBAL','utmport',edit10.text);
  Fini.WriteString('GLOBAL','firmname',edit9.Text);
  Fini.WriteString('GLOBAL','firmShortname',edit13.Text);
  Fini.WriteString('GLOBAL','inn',edit6.Text);
  Fini.WriteString('GLOBAL','kpp',edit7.Text);
  Fini.WriteString('GLOBAL','address',edit8.Text);
  Fini.WriteString('GLOBAL','prefixClient',edit12.Text);
  Fini.WriteString('GLOBAL','prefixdb',edit11.Text);
  Fini.WriteBool('GLOBAL','LowConnect',CheckBox1.Checked);
  Fini.WriteBool('GLOBAL','autoload',cbRefresh.Checked);
  Fini.WriteBool('GLOBAL','hidelog',cbHideLog.Checked);
  Fini.WriteString('GLOBAL','rmkfolderload',edit15.Text);
  Fini.WriteString('GLOBAL','rmkfileload',edit16.Text);
  Fini.WriteString('GLOBAL','rmkflagload',edit17.Text);
  Fini.WriteString('GLOBAL','rmkfilereport',edit18.Text);
  Fini.WriteString('GLOBAL','countslip',edit20.Text);
  Fini.WriteString('GLOBAL','refresh',edit14.Text);
  Fini.WriteBool('GLOBAL','rmkoffline',CheckBox4.Checked);
  if formstart.GetConstant('typelicense') = '999' then
     Fini.WriteBool('GLOBAL','disableutm',True)
  else
     Fini.WriteBool('GLOBAL','disableutm',not cbdisableutm.Checked);
  //Fini.WriteString('GLOBAL','pathDirRetail',edDirRetailOpt.Text);
  FormStart.SetConstant('email',edemail.Text);
  FormStart.SetConstant('telephone',edtelephone.Text);
  FormStart.SetConstant('PathSalesOpt',db_replaceStr(edDirRetailOpt.Text));
  if cbLoadTTN.Checked then
      FormStart.SetConstant('UpdProductTTN','1')
    else
      FormStart.SetConstant('UpdProductTTN','0');
  if cbLoadForm1.Checked then
      FormStart.SetConstant('UpdProductForm1','1')
    else
      FormStart.SetConstant('UpdProductForm1','0');
  if cbLoadrest.Checked then
      FormStart.SetConstant('UpdProductRest','1')
    else
      FormStart.SetConstant('UpdProductRest','0');
  if cbLoadRestShop.Checked then
      FormStart.SetConstant('UpdProductRestShop','1')
    else
      FormStart.SetConstant('UpdProductRestShop','0');

  if cbUpdateRest.Checked then
      FormStart.SetConstant('AutoUpdateRest'+formstart.prefixClient,'1')
    else
      FormStart.SetConstant('AutoUpdateRest','0');
  if cbAlcDateControl.Checked then
      FormStart.SetConstant('AlcDateControl','1')
    else
      FormStart.SetConstant('AlcDateControl','0');
  if cbAddReportFileZ.Checked then
      FormStart.SetConstant('AddReportFileZ','1')
    else
      FormStart.SetConstant('AddReportFileZ','0');
  FormStart.SetConstant('unlockpassword',unLockScreen.Text);
  if cbLoadFoneGoods.Checked then
      FormStart.SetConstant('LoadFoneGoods','1')
    else
      FormStart.SetConstant('LoadFoneGoods','0');
  if cbExtExch.Checked then
      FormStart.SetConstant('extexchenge','1')
    else
      FormStart.SetConstant('extexchenge','0');
  if cbenableauth.Checked then
      FormStart.SetConstant('enableauth','1')
    else
      FormStart.SetConstant('enableauth','0');

  if checkbox3.Checked then
      FormStart.SetConstant('enablemultitable','1')
    else
      FormStart.SetConstant('enablemultitable','0');
  if cbExchMod.Checked then
   FormStart.SetConstant('LoadExchMode','1')
  else
    FormStart.SetConstant('LoadExchMode','0');
  FormStart.SetConstant('ClientRegId',lefsrar.Text);

  FormStart.SetConstant('quantityhall1',edTable1Qual.Text);
  FormStart.SetConstant('quantityhall2',edTable2Qual.Text);
  FormStart.SetConstant('quantityhall3',edTable3Qual.Text);
  FormStart.SetConstBool('enableresto',checkbox2.Checked);
  FormStart.SetConstBool('autoactwritebeer',CheckBox5.Checked);
  formStart.SetConstant('TimeUpdateRest',FormatDateTime('HH:MM:SS',dateTimePicker1.Time));
  formStart.SetConstant('TimeUpdateShop',FormatDateTime('HH:MM:SS',dateTimePicker2.Time));
  FormStart.SetConstBool('AutoCreateDocTrans',checkbox6.Checked);
  FormStart.SetConstant('HostExchMode',edHostExchMod.Text);
  FormStart.SetConstant('address_zip',ed_zip.Text);
  FormStart.SetConstant('address_region',ed_region.Text);
  FormStart.SetConstant('address_region',ed_region.Text);
  FormStart.SetConstant('address_city',ed_city.Text);
  FormStart.SetConstant('address_street',ed_street.Text);
  FormStart.SetConstant('address_home',ed_home.Text);
//  for i:=1 to 89 do
//    Fini.WriteString('KEYBOARD','cmd'+intToStr(i),FormKeyCMD.ArKeyCMD[i]);
  Fini.Destroy;
  Showmessage('Для вступления в силу изменения,'+#13#10+'требуется перезапустить программу!');
  // Обновляем таблицы если включен УТМ
  if cbDisableutm.Checked then
   begin
    formstart.DB_checkCol('spralccodeforbarcode','ProductVCode','int(3)','');  // ИМНС
    formstart.DB_checkCol('spralccodeforbarcode','alccode','varchar(32)','');  // Алкогольный товар
    formstart.DB_checkCol('spralccodeforbarcode','barcode','varchar(32)','');  // Штрих код
   end;

end;

procedure TFormOptions.BitBtn3Click(Sender: TObject);
var
  query:string;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  FormStart.SetConstant('flagUpdate','0');
  xrecbuf:=formstart.DB_query('select (SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `ProductVCode`,`eanbc`,`alccode` from `doccash`;');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    if (xrowbuf[0]<>nil)and(xrowbuf[0]<>'') then begin
      formstart.SetAlcToBarCode(xrowbuf[2],xrowbuf[1]);
    end;
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
end;

procedure TFormOptions.BitBtn4Click(Sender: TObject);
begin
  formstart.Setwaybillv2();
end;

procedure TFormOptions.BitBtn5Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then begin
    edit15.Text:=ansitoutf8(SelectDirectoryDialog1.FileName);
  end;
end;

procedure TFormOptions.BitBtn6Click(Sender: TObject);
begin
  FormStart.DB_query('DELETE FROM `egaisfiles`;');
end;

procedure TFormOptions.Button1Click(Sender: TObject);
begin
  FormSetPasswordAdmin.ShowModal;
end;

procedure TFormOptions.cbDisableutmChange(Sender: TObject);
begin
  GroupBox7.Enabled:= cbDisableUTM.Checked;
  GroupBox4.Enabled:=cbDisableUTM.Checked;
  GroupBox8.Enabled:=cbDisableUTM.Checked;
  CheckGroup1.Enabled:=cbDisableUTM.Checked;
  if cbDisableUTM.Checked then begin

  end;
end;

procedure TFormOptions.cbExchModChange(Sender: TObject);
begin
  gbExchMod.Enabled :=cbExchMod.Checked;
end;

procedure TFormOptions.cbExchModChangeBounds(Sender: TObject);
begin

end;

procedure TFormOptions.cbLoadForm1Change(Sender: TObject);
begin

end;

procedure TFormOptions.cbRefreshChange(Sender: TObject);
begin

end;

procedure TFormOptions.Edit14Change(Sender: TObject);
begin

end;

procedure TFormOptions.FormShow(Sender: TObject);
begin
  Edit1.Text := formStart.pathDir;
  edit2.Text:= formStart.mysqlurl;
  edit3.Text:= formstart.mysqluser;
  edit4.Text:= formstart.mysqlpassword;
  edit5.Text:= formstart.utmip;
  edit9.Text:= formstart.FirmFullName;
  edit6.Text:= formstart.FirmINN;
  edit7.Text:= formstart.FirmKPP;
  edit8.Text:= formstart.FirmAddress;
  edit11.Text:= formstart.prefixdb;
  edit12.Text:= formstart.prefixClient;
  edit13.Text:= formstart.FirmShortName;
  edit14.Text:= inttostr(formstart.deltaautoload);
  edit15.text:=formstart.flRMKFolderLoad;
  edit16.Text:=formstart.flRMKFileLoad;
  edit17.Text:=formstart.flRMKFlagLoad;
  edit18.Text:=formstart.flRMKFileReport;
  edit20.text:=inttostr(formstart.flCountSlip);
  CheckBox1.Checked := formstart.flLowConnect;
  cbRefresh.Checked := formstart.autoload;
  checkbox4.Checked:= formStart.flRmkOffline;
  if formstart.GetConstant('typelicense') = '999' then
    cbDisableUtm.Enabled:= False;
  cbDisableUtm.Checked:=not formstart.fldisableutm;
  edemail.Text:=formstart.getconstant('email');
  edDirRetailOpt.Text:=formstart.GetConstant('PathSalesOpt');
  cbLoadForm1.Checked :=false;
  cbUpdateRest.Checked :=DB_Boolean( FormStart.GetConstant('AutoUpdateRest'+formstart.prefixClient));
  if FormStart.GetConstant('UpdProductForm1') = '1' then
     cbLoadForm1.Checked :=true;
  cbLoadTTN.Checked :=false;
  if FormStart.GetConstant('UpdProductTTN') = '1' then
     cbLoadTTN.Checked :=true;
  cbLoadRest.Checked :=false;
  if FormStart.GetConstant('UpdProductRest') = '1' then
     cbLoadRest.Checked :=true;
  cbLoadRestShop.Checked :=false;
  if FormStart.GetConstant('UpdProductRestShop') = '1' then
     cbLoadRestShop.Checked :=true;
  cbAlcDateControl.Checked:=false;
  if FormStart.GetConstant('AlcDateControl') = '1' then
    cbAlcDateControl.Checked:=true;
  cbAddReportFileZ.Checked:=false;
  if FormStart.GetConstant('AddReportFileZ') = '1' then
    cbAddReportFileZ.Checked:=true;
  cbLoadFoneGoods.Checked:=false;
  if FormStart.GetConstant('LoadFoneGoods') = '1' then
    cbLoadFoneGoods.Checked:=true;
  cbExchMod.Checked:=db_boolean(FormStart.GetConstant('LoadExchMode'));
  cbenableauth.Checked:=db_boolean(FormStart.GetConstant('enableauth'));
  cbExtExch.Checked:=db_boolean(FormStart.GetConstant('extexchenge'));
  checkbox3.Checked:=db_boolean(FormStart.GetConstant('enablemultitable'));
  checkbox2.Checked:=db_boolean(FormStart.GetConstant('enableresto'));
  edTable1Qual.Text := FormStart.GetConstant('quantityhall1');
  edTable2Qual.Text := FormStart.GetConstant('quantityhall2');
  edTable3Qual.Text := FormStart.GetConstant('quantityhall3');
  CheckBox5.Checked:=db_boolean(FormStart.GetConstant('autoactwritebeer'));
  cbHideLog.Checked:=formStart.flHideLog;
  unLockScreen.text:= FormStart.GetConstant('unlockpassword');
  cbDisableutmChange(sender);
  checkbox6.Checked :=db_boolean(FormStart.GetConstant('AutoCreateDocTrans'));
  edHostExchMod.Text:=FormStart.GetConstant('HostExchMode');
  ed_zip.Text       :=FormStart.GetConstant('address_zip');
  ed_region.Text    :=FormStart.GetConstant('address_region');
  ed_region.Text    :=FormStart.GetConstant('address_region');
  ed_city.Text      :=FormStart.GetConstant('address_city');
  ed_street.Text    := FormStart.GetConstant('address_street');
  ed_home.Text      := FormStart.GetConstant('address_home');
  lefsrar.Text      := FormStart.GetConstant('ClientRegId');
end;

end.

