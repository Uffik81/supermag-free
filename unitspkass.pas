unit unitspkass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, Buttons, ComCtrls, StdCtrls;

type

  { TFormSpKass }

  TFormSpKass = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    cmd_gs1test: TBitBtn;
    Button1: TButton;
    cbAutoEAN13: TCheckBox;
    cbEnableKKM: TCheckBox;
    cbTypeKKM: TComboBox;
    cbDep: TCheckBox;
    cbPrecheck: TCheckBox;
    CheckBox1: TCheckBox;
    cbMasterKass: TCheckBox;
    cbNotCutCheck: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    cbHWTypeModel: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    gs1test: TLabeledEdit;
    leHWBaud: TComboBox;
    EdTaxType: TEdit;
    edPrefixCard: TEdit;
    edPrefixVesi: TEdit;
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    leHostkkt: TLabeledEdit;
    lehostportkkt: TLabeledEdit;
    leHWPort: TLabeledEdit;
    leDepSB: TLabeledEdit;
    leDep: TLabeledEdit;
    leSNO: TLabeledEdit;
    leNDS: TLabeledEdit;
    lbRNM: TLabeledEdit;
    lbHWCash: TLabeledEdit;
    lbFN: TLabeledEdit;
    lbNumKass: TLabeledEdit;
    lbNameCash: TLabeledEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Splitter1: TSplitter;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbNotCutCheckChange(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure cmd_gs1testClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leHWBaudChange(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    flHWKass:string;
    idRowSelect:integer;
    lstKassa:TStringList;
    lstScale:TStringList;
    procedure initTable;
  end;

var
  FormSpKass: TFormSpKass;

implementation

uses unitstart, mysql50,IniFiles, unitsalesbeerts,unitvikisetting, lazutf8;
{$R *.lfm}

{ TFormSpKass }

procedure TFormSpKass.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);


begin

end;

procedure TFormSpKass.initTable;
begin

end;

procedure TFormSpKass.BitBtn1Click(Sender: TObject);
var
  i:integer;
  query:string;
  Fini:TIniFile;
  indKKM:integer;
  sFile:string;
begin

  sFile := formstart.PathFile();
  formStart.SetConstant('prefixvesi',edPrefixVesi.text);
  formStart.SetConstant('prefixcard',edPrefixcard.text);
  formStart.SetConstant('taxtype',EdTaxType.text);

  indKKM:=cbTypeKKM.Items.IndexOf(cbTypeKKM.Caption);
  formStart.SetConstant('TypeKKM',inttostr(indKKM));
  FIni := TIniFile.Create(sFile + formstart.flFileConfig);
  Fini.WriteBool('GLOBAL','KKMEnabled',cbEnableKKM.Checked);
  Fini.WriteBool('GLOBAL','rmkoffline',CheckBox5.Checked);
  Fini.WriteBool('GLOBAL','kkmsberbank',CheckBox3.Checked);
  Fini.Destroy;
end;

procedure TFormSpKass.BitBtn2Click(Sender: TObject);
var
  indKKM:integer;
begin
  indKKM:=cbTypeKKM.Items.IndexOf(cbTypeKKM.Caption);
  case indKKM of
 0:  begin
    formsalesbeerts.InitDevice;
  //  formsalesbeerts.InitSection;
    formsalesbeerts.set_not_print();
    formsalesbeerTS.ShowKKMOption();

  end;
  1:  begin
    formsalesbeerts.InitDevice;
    formsalesbeerTS.ShowKKMOption();

  end;
  2:   begin
    formvikisetting.ShowModal;
    formsalesbeerts.InitDevice;

  end;
  3:  begin
    formsalesbeerts.InitDevice;
    formsalesbeerTS.ShowKKMOption();

  end;
  4:   begin
    formvikisetting.ShowModal;
    formsalesbeerts.InitDevice;

  end;
  else
    formvikisetting.ShowModal;
    formsalesbeerts.InitDevice;
  end;

end;

procedure TFormSpKass.BitBtn3Click(Sender: TObject);
begin
  lbHWCash.Text:='';
  lbRNM.Text:='0';
  lbFN.Text:='0';
  leDepSB.Text:='0';
  leSNO.Text:='0';
  lbNameCash.Text:='';
end;

procedure TFormSpKass.BitBtn4Click(Sender: TObject);
var
  Query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  BaudId:string;
begin
  baudid:= inttostr(leHWBaud.Items.IndexOf(leHWBaud.Text));

  xrecbuf:=formstart.DB_query('SELECT `numkass` FROM `sprkass` WHERE `numhw`="'+lbHWCash.Text+'";');
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
      Query:='UPDATE `sprkass` SET '+
      '`numkass`='''+lbNumKass.Text+
            //''','''+lbHWCash.Text+
            ''',`nalogrn`='''+lbRNM.Text+
            ''',`fnnumber`='''+lbFN.Text+
            ''',`taxtype`='''+leSNO.Text+
            ''',`namekass`='''+lbNameCash.Text+
            ''',`devicehwbaud`='''+baudid+
            ''',`devicehwport`='''+leHWPort.Text+
            ''',`numsection`='''+leDep.Text+
            ''',`deviceipport`='''+lehostportkkt.Text+
            ''',`deviceiphost`='''+lehostkkt.Text+
            ''',`alckass`='''+db_BoolToStr(CheckBox1.Checked)+
            ''',`master`='''+db_BoolToStr(cbMasterKass.Checked)+
      ''' WHERE `numhw`='''+lbHWCash.Text+''';';
      formstart.DB_query(Query);

    end else begin
      query:='INSERT INTO `sprkass` (`numkass`,`numhw`,`nalogrn`,`fnnumber`,`banking`,`taxtype`,'+
      '`namekass`,`devicehwbaud`,`devicehwport`,`numsection`,`deviceipport`,`deviceiphost`,`alckass`,`master`,`kassirname`)'+
      ' VALUES ('''+lbNumKass.Text+
      ''','''+lbHWCash.Text+
      ''','''+lbRNM.Text+
      ''','''+lbFN.Text+
      ''','''+leDepSB.Text+
      ''','''+leSNO.Text+
      ''','''+lbNameCash.Text+
      ''','''+baudid+
      ''','''+leHWPort.Text+
      ''','''+leDep.Text+
      ''','''+lehostportkkt.Text+
      ''','''+lehostkkt.Text+
      ''','''+db_BoolToStr(CheckBox1.Checked)+
      ''','''+db_BoolToStr(cbMasterKass.Checked)+
      ''','''');';
      formstart.DB_query(Query);
    end;


 FormShow(nil);
end;

procedure TFormSpKass.BitBtn5Click(Sender: TObject);
var
  Query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  xrecbuf:=formstart.DB_query('SELECT `numkass` FROM `sprkass` WHERE `numhw`="'+lbHWCash.Text+'";');
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    formstart.DB_query('DELETE FROM `sprkass` WHERE `numhw`="'+lbHWCash.Text+'";');
  end;

end;

procedure TFormSpKass.BitBtn7Click(Sender: TObject);
var
  Query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  // CheckBox4.Checked; -- вес получаем на кассу
  query:='SELECT * FROM `sprscale` WHERE `namescale`="'+ LabeledEdit1.Text+'"';
  xrecbuf:=formstart.DB_query(query);
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf=nil then begin
     query:='INSERT INTO `sprscale` (`namescale`,`localconnect`,`cashconnect`,`cash_id`,`countgoods`,`deviceiphost`,`devicehwport`) VALUES ('+
     '"'+LabeledEdit1.Text+'","'+db_boolToStr(Checkbox2.Checked)+'","'+db_boolToStr(Checkbox4.Checked)+'","'+Combobox4.Text+
     '","'+LabeledEdit5.Text+'","'+LabeledEdit2.Text+'","'+LabeledEdit4.Text+'")';
     formstart.DB_query(query);
  end else begin
     formstart.DB_query('UPDATE `sprscale` SET `localconnect`,`cashconnect`,`cash_id`,`countgoods`,`deviceiphost`,`devicehwport` WHERE `namescale`="'+LabeledEdit1.Text+'"');

  end;
end;

procedure TFormSpKass.BitBtn8Click(Sender: TObject);
begin
  if FormSalesBeerts.InitScale then
   begin

   end else begin
      Showmessage('Ошибка при загрузки драйвера весов!');
   end;
end;

procedure TFormSpKass.Button1Click(Sender: TObject);
begin
  showmessage(FormSalesBeerTS.get_gtin(5,'011500015807102221VFVD1KXEH40H791EE0692TgCr+T/nLRMUHK9G/KSNotpzVMbqSO/kAOgABkIyRow='))
end;

procedure TFormSpKass.cbNotCutCheckChange(Sender: TObject);
begin
  if cbNotCutCheck.Checked then
    formStart.SetConstant('DisabledCut','+')
  else
    formStart.SetConstant('DisabledCut','-');
end;

procedure TFormSpKass.CheckBox4Change(Sender: TObject);
begin
  ComboBox4.Enabled:= CheckBox4.Checked;
end;

procedure TFormSpKass.cmd_gs1testClick(Sender: TObject);
begin
  FormSalesBeerTS.InitDevice();
  if FormSalesBeerTS.test_gs1datamatrix(gs1test.text) then
     formstart.fshowmessage('Тест Ок!');
end;

procedure TFormSpKass.FormCreate(Sender: TObject);
begin
  lstKassa:=TStringList.Create;
  lstScale:=TStringList.Create;
end;

procedure TFormSpKass.FormDestroy(Sender: TObject);
begin
  lstKassa.Destroy;
end;

procedure TFormSpKass.FormShow(Sender: TObject);
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
 FormStart.DB_checkCol('sprkass','numkass','int(12)','');
 FormStart.DB_checkCol('sprkass','namekass','varchar(32)','');
 FormStart.DB_checkCol('sprkass','lastupdate','TIMESTAMP','');
 FormStart.DB_checkCol('sprkass','alckass','varchar(1)','');
 FormStart.DB_checkCol('sprkass','banking','varchar(1)',''); // Подключен банк
 FormStart.DB_checkCol('sprkass','kassirname','varchar(64)','');
 FormStart.DB_checkCol('sprkass','numhw','varchar(22)','');  // === заводской номер ====
 FormStart.DB_checkCol('sprkass','FNNumber','varchar(22)','');  // === заводской номер ФН ====
 FormStart.DB_checkCol('sprkass','multisection','varchar(1)','');  // === несколько секций ====
 FormStart.DB_checkCol('sprkass','master','varchar(1)','');  // === основная касса ====
 FormStart.DB_checkCol('sprkass','nalogrn','varchar(20)','');  // === РегНомер в Налоговой ====
 FormStart.DB_checkCol('sprkass','fnnumber','varchar(20)','');  // === основная касса ====
 FormStart.DB_checkCol('sprkass','taxtype','varchar(2)','');  // === основная касса ====     1 = Указать налоги
 FormStart.DB_checkCol('sprkass','devtype','int(4)','');  // === основная касса ====     1 = Указать налоги
 FormStart.DB_checkCol('sprkass','modelkkt','varchar(7)','');  // === Модель аппарата ====
 FormStart.DB_checkCol('sprkass','numsection','varchar(1)','');  // === Номер секций ====
 FormStart.DB_checkCol('sprkass','deviceipport','int(5)','');  // === Модель аппарата ====
 FormStart.DB_checkCol('sprkass','deviceiphost','varchar(64)','');  // === Номер секций ====
 FormStart.DB_checkCol('sprkass','devicehwbaud','int(5)','');  // === Номер секций ====
 FormStart.DB_checkCol('sprkass','devicehwport','varchar(64)','');  // === Номер секций ====

 FormStart.DB_checkCol('sprscale','id','int(12)','');
 FormStart.DB_checkCol('sprscale','namescale','varchar(32)','');
 FormStart.DB_checkCol('sprscale','lastupdate','TIMESTAMP','');
 FormStart.DB_checkCol('sprscale','localconnect','varchar(1)','');
 FormStart.DB_checkCol('sprscale','cashconnect','varchar(1)','');
 FormStart.DB_checkCol('sprscale','cash_id','int(12)','');
 FormStart.DB_checkCol('sprscale','devtype','int(4)','');  // === Тип весов
 FormStart.DB_checkCol('sprscale','modelscale','varchar(7)','');  // === Модель весов
 FormStart.DB_checkCol('sprscale','countgoods','varchar(10)','');  // === Количество товара выгружаемые в весы
 FormStart.DB_checkCol('sprscale','deviceipport','int(5)','');  // === Модель аппарата ====
 FormStart.DB_checkCol('sprscale','deviceiphost','varchar(64)','');  // === Номер секций ====
 FormStart.DB_checkCol('sprscale','devicehwbaud','int(5)','');  // === Номер секций ====
 FormStart.DB_checkCol('sprscale','devicehwport','varchar(64)','');  // === Номер секций ====

  PageControl1Change(nil);
  listbox1.Items.Clear;
  lstKassa.Clear;
  lstScale.Clear();
  xrecbuf:= formstart.DB_query('SELECT `numkass`,`numhw` FROM `sprkass`;');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    listbox1.Items.Add(xrowbuf[0]);
    lstKassa.Add(xrowbuf[1]);
    xrowbuf:=formstart.db_next(xrecbuf);
  end;
  xrecbuf:= formstart.DB_query('SELECT `namescale`,`id` FROM `sprscale`;');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    listbox2.Items.Add(xrowbuf[0]);
    lstScale.Add(xrowbuf[1]);
    xrowbuf:=formstart.db_next(xrecbuf);
  end;

 if FormStart.GetConstant('TypeKKM')='' then
  cbTypeKKM.Caption:=cbTypeKKM.Items.Strings[0] else
  cbTypeKKM.Caption:=cbTypeKKM.Items.Strings[strtoint(FormStart.GetConstant('TypeKKM'))];
 cbEnableKKM.Checked:=formStart.flKKMEnabled;
 checkbox3.Checked:= formStart.flKKMSberbank;
 edPrefixVesi.text:=formStart.GetConstant('prefixvesi');
 edPrefixcard.text:=formStart.GetConstant('prefixcard');
 checkbox5.Checked:= formStart.flRmkOffline;
 cbNotCutCheck.Checked:=db_boolean(formstart.getConstant('DisabledCut'));
 if formStart.GetConstant('AddBarCodeEAN13') = '1' then  cbAutoEAN13.checked:=true else
   cbAutoEAN13.checked:=False;
 {
 var
  Fini:TIniFile;
 }
end;

procedure TFormSpKass.leHWBaudChange(Sender: TObject);
begin

end;

procedure TFormSpKass.ListBox1Click(Sender: TObject);
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
 for i:=0 to listbox1.Count-1 do
  if listbox1.Selected[i] then
  begin
    flHWKass:= lstKassa.Strings[i];

  end;
 xrecbuf:=formstart.DB_query('SELECT `numkass`,`numhw`,`fnnumber`,`nalogrn`,`taxtype`,`namekass`,`devicehwbaud`,`devicehwport`,'+
 '`numsection`,`banking`,`deviceipport`,`deviceiphost`,`alckass`,`master` FROM `sprkass` WHERE `numhw`="'+flHWKass+'";');
 xrowbuf:= formstart.DB_Next(xrecbuf);
 if xrowbuf<>nil then begin
   lbNumKass.Text:=xrowbuf[0];
   lbHWCash.Text:=xrowbuf[1];
   lbFN.Text:=xrowbuf[2];
   lbRNM.Text:=xrowbuf[3];
   leSNO.text:=xrowbuf[4];
   lbNameCash.Text:=xrowbuf[5];
   if xrowbuf[6]<>'' then
    leHWBaud.text:=leHWBaud.Items.Strings[strtoint( xrowbuf[6])]
    else
    leHWBaud.text:='115200';
   leHWPort.text:=xrowbuf[7];
   leDEp.text:=xrowbuf[8];
   leDepSB.Text:=xrowbuf[9];
   lehostportkkt.Text:=xrowbuf[10];
   lehostkkt.Text:=xrowbuf[11];
   CheckBox1.Checked:=db_boolean(xrowbuf[12]);
   cbMasterKass.Checked:=db_boolean(xrowbuf[13]);
 end;
end;

procedure TFormSpKass.PageControl1Change(Sender: TObject);
begin

end;

end.

