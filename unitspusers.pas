unit unitspusers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, StdCtrls, ExtCtrls;

type
  TPolices = record
    userId:string;
    name,fullname:string;
    FreePrice,
    findvisual,
    storno,
    cancelcheck,
    returncheck,
    reportx,
    reportkkm,
    editsoft,
    edithw,
    editgoods,
    editusers,
    exittoos,enterukm,
    EnterCash,deferredcheck,
    discount:boolean;
  end;

  { TFormSpUsers }

  TFormSpUsers = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    CheckGroup3: TCheckGroup;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox10Change(Sender: TObject);
    procedure CheckBox11Change(Sender: TObject);
    procedure CheckBox12Change(Sender: TObject);
    procedure CheckBox13Change(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox15Change(Sender: TObject);
    procedure CheckBox16Change(Sender: TObject);
    procedure CheckBox1EditingDone(Sender: TObject);
    procedure CheckBox3EditingDone(Sender: TObject);
    procedure CheckBox4EditingDone(Sender: TObject);
    procedure CheckBox5EditingDone(Sender: TObject);
    procedure CheckBox6EditingDone(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1ChangeBounds(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { private declarations }
    FPolice:TPolices;
  public
    { public declarations }
    // =======
    flNew:boolean;
    // ======
    lstUser:TStringList;
    flUserId:string;
    Function SelectUser(aID:string):boolean;
    procedure refreshUser;
    procedure initTable;
    function GetPolice(aID:String):TPolices;
    procedure SetPolice(aID:string;aPolice:TPolices);
  end;

var
  FormSpUsers: TFormSpUsers;

implementation
uses unitstart, mysql50;
{$R *.lfm}

{ TFormSpUsers }
FUNCTION pclBoolean(aStr:string):boolean;
begin
  result:=true;
  if (aStr = '-')or(aStr='0') then
    result:=false;
end;


procedure TFormSpUsers.FormShow(Sender: TObject);
begin
  listbox1.Items.Clear;
  lstUser.Clear;
  formstart.recbuf:=formstart.DB_query('SELECT `name`,`userid` from `sprusers` ;');
  formstart.rowbuf:=formstart.db_next(formstart.recbuf);
  while formstart.rowbuf<>nil do begin
   listbox1.Items.Add(formstart.rowbuf[0]);
   lstUser.Add(formstart.rowbuf[1]);
   formstart.rowbuf:=formstart.db_next(formstart.recbuf);
  end;
end;

procedure TFormSpUsers.ListBox1ChangeBounds(Sender: TObject);
begin

end;

procedure TFormSpUsers.ListBox1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to listbox1.Count-1 do
   if listbox1.Selected[i] then
   begin
     flUserId:= lstUser.Strings[i];
     refreshUser;
     flNew:=false;
   end;

end;

function TFormSpUsers.SelectUser(aID: string): boolean;
begin
  FPolice:=GetPolice(aID);
end;

procedure TFormSpUsers.refreshUser;
begin
  Edit4.Text:=flUserId;
  formstart.recbuf:=formstart.DB_query('select `name`,`fullname`,`barcodes`,`pincode`,`password`,`freeprice`,`interface`,`groupid` from `sprusers` where `userid`="'+flUserId+'";');
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  if formstart.rowbuf<>nil then begin
    edit1.Text:=formstart.rowbuf[0];
    edit2.Text:=formstart.rowbuf[3];
    edit3.Text:=formstart.rowbuf[2];
    combobox1.Caption:='';
    if formstart.rowbuf[7]='A' then
      combobox1.Caption:=combobox1.Items.Strings[0];
    if formstart.rowbuf[7]='O' then
     combobox1.Caption:=combobox1.Items.Strings[1];
    if formstart.rowbuf[7]='K' then
     combobox1.Caption:=combobox1.Items.Strings[2];
    combobox2.Caption:='';
    if formstart.rowbuf[6]='M' then
      combobox2.Caption:=combobox2.Items.Strings[0];
    if formstart.rowbuf[6]='E' then
     combobox2.Caption:=combobox2.Items.Strings[1];
    if formstart.rowbuf[6]='K' then
     combobox2.Caption:=combobox2.Items.Strings[1];
    SelectUser(flUserId);
    CheckBox1.Checked:=FPolice.exittoos;
    CheckBox4.Checked:=FPolice.enterukm;
    CheckBox5.Checked:=FPolice.EnterCash;
    CheckBox3.Checked:=FPolice.FreePrice;
    CheckBox6.Checked:=FPolice.findvisual;
    CheckBox7.Checked:=FPolice.deferredcheck;
    CheckBox8.Checked:=FPolice.storno;
    CheckBox9.Checked:=FPolice.cancelcheck;
    CheckBox10.Checked:=FPolice.returncheck;
    CheckBox11.Checked:=FPolice.reportx;
    CheckBox12.Checked:=FPolice.reportkkm;
    CheckBox13.Checked:=FPolice.editsoft;
    CheckBox14.Checked:=FPolice.edithw;
    CheckBox15.Checked:=FPolice.editgoods;
    CheckBox16.Checked:=FPolice.editusers;
    CheckBox17.Checked:=FPolice.discount;
  end;
end;

procedure TFormSpUsers.initTable;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  res:TPolices;//=(freeprice:false);
begin
  // ===== Справочник Пользователей ========
  FormStart.DB_checkCol('sprusers','userid','int(12)',''); // текущий код пользователя
  FormStart.DB_checkCol('sprusers','name','varchar(64)','');  // Имя в системе для печати
  FormStart.DB_checkCol('sprusers','fullname','varchar(254)',''); // Имя на экране
  FormStart.DB_checkCol('sprusers','weightgood','varchar(1)',''); // может делить товар
  FormStart.DB_checkCol('sprusers','alcgoods','varchar(1)','');  // Алкогольный товар - для чеков егаис
  FormStart.DB_checkCol('sprusers','barcodes','varchar(13)','');
  FormStart.DB_checkCol('sprusers','pincode','varchar(4)','');
  FormStart.DB_checkCol('sprusers','password','varchar(32)','');
  FormStart.DB_checkCol('sprusers','interface','varchar(1)','');
  FormStart.DB_checkCol('sprusers','article','varchar(48)','');
  FormStart.DB_checkCol('sprusers','groupid','varchar(1)','');
  // ==== kassa ======
  FormStart.DB_checkCol('sprusers','freeprice','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','findvisual','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','storno','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','cancelcheck','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','returncheck','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','reportx','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','reportkkm','varchar(1)',''); // <<< Флаг для свободной цены
  FormStart.DB_checkCol('sprusers','deferredcheck','varchar(1)','');
  FormStart.DB_checkCol('sprusers','discount','varchar(1)','');
  // ====== upravlenie =====
  FormStart.DB_checkCol('sprusers','editsoft','varchar(1)','');
  FormStart.DB_checkCol('sprusers','edithw','varchar(1)','');
  FormStart.DB_checkCol('sprusers','editgoods','varchar(1)','');
  FormStart.DB_checkCol('sprusers','editusers','varchar(1)','');
  // ==== доступ ===========
  FormStart.DB_checkCol('sprusers','exittoos','varchar(1)','');
  FormStart.DB_checkCol('sprusers','enterukm','varchar(1)','');
  FormStart.DB_checkCol('sprusers','entercash','varchar(1)','');

  Application.ProcessMessages;
  Query:='SELECT `userid` FROM `sprusers` WHERE `editusers` = "1" OR `editusers` = "+" OR `name`="Admin" ;';
  xrecbuf:=formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
   Query:='UPDATE `sprusers` SET'+
    ' `freeprice`="1",'+
    ' `findvisual`="1",'+
    ' `storno`="1",'+
    ' `cancelcheck`="1",'+
    ' `returncheck`="1",'+
    ' `reportx`="1",'+
    ' `reportkkm`="1",'+
    ' `editsoft`="1",'+
    ' `edithw`="1",'+
    ' `editgoods`="1",'+
    ' `editusers`="1",'+
    ' `exittoos`="1",'+
    ' `enterukm`="1",'+
    ' `entercash`="1",'+
    ' `deferredcheck`="1", '+
    ' `discount`="1" '+
    'WHERE `userid`="'+xrowbuf[0]+'" or `name`="Admin";'
  else begin
      query:= 'INSERT INTO `sprusers` ( `name`,`fullname`,`barcodes`,`pincode`,`password`,`freeprice`,`findvisual`,`storno`,`cancelcheck`,`returncheck`,`reportx`,`reportkkm`,`editsoft`,`edithw`,`editgoods`,`editusers`'+
  ',`exittoos`,`enterukm`,`entercash`,`deferredcheck`,`discount`,`interface`,`groupid`,`userid`,`weightgood`,`alcgoods`,`article`) '
      +'VALUES ("admin","admin","","0000","","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","O","","30","1","1","1");';
  end;
  formstart.DB_query(Query);

end;

function TFormSpUsers.GetPolice(aID: String): TPolices;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  res:TPolices;//=(freeprice:false);
begin
  Query:='SELECT `freeprice`,`findvisual`,`storno`,`cancelcheck`,`returncheck`,`reportx`,`reportkkm`,`editsoft`,`edithw`,`editgoods`,`editusers`'+
  ',`exittoos`,`enterukm`,`entercash`,`deferredcheck`,`discount`,`name`,`fullname` FROM `sprusers` WHERE `userid`="'+aID+'";';
  xrecbuf:=formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
     begin
       res.freeprice    :=pclBoolean(xrowbuf[0]);
       res.findvisual   :=pclBoolean(xrowbuf[1]);
       res.storno       :=pclBoolean(xrowbuf[2]);
       res.cancelcheck  :=pclBoolean(xrowbuf[3]);
       res.returncheck  :=pclBoolean(xrowbuf[4]);
       res.reportx      :=pclBoolean(xrowbuf[5]);
       res.reportkkm    :=pclBoolean(xrowbuf[6]);
       res.editsoft     :=pclBoolean(xrowbuf[7]);
       res.edithw       :=pclBoolean(xrowbuf[8]);
       res.editgoods    :=pclBoolean(xrowbuf[9]);
       res.editusers    :=pclBoolean(xrowbuf[10]);
       res.exittoos     :=pclBoolean(xrowbuf[11]);
       res.enterukm     :=pclBoolean(xrowbuf[12]);
       res.EnterCash    :=pclBoolean(xrowbuf[13]);
       res.deferredcheck:=pclBoolean(xrowbuf[14]);
       res.discount     :=pclBoolean(xrowbuf[15]);
       res.name         :=xrowbuf[16];
       res.fullname     :=xrowbuf[17];
       result:=res;
     end ;
  // else
  //   result:=false;
  //mysql_free_result(xrecbuf);
end;

procedure TFormSpUsers.SetPolice(aID: string; aPolice: TPolices);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  res:TPolices;//=(freeprice:false);
begin
  Query:='SELECT `freeprice`,`findvisual`,`storno`,`cancelcheck`,`returncheck`,`reportx`,`reportkkm`,`editsoft`,`edithw`,`editgoods`,`editusers`'+
  ',`exittoos`,`enterukm`,`entercash`,`deferredcheck` FROM `sprusers` WHERE `userid`="'+aID+'";';
  xrecbuf:=formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
   begin
    Query:='UPDATE `sprusers` SET'+
     ' `freeprice`="'+BoolToStr(aPolice.FreePrice,'1','0')+'",'+
     ' `findvisual`="'+BoolToStr(aPolice.findvisual,'1','0')+'",'+
     ' `storno`="'+BoolToStr(aPolice.storno,'1','0')+'",'+
     ' `cancelcheck`="'+BoolToStr(aPolice.cancelcheck,'1','0')+'",'+
     ' `returncheck`="'+BoolToStr(aPolice.returncheck,'1','0')+'",'+
     ' `reportx`="'+BoolToStr(aPolice.reportx,'1','0')+'",'+
     ' `reportkkm`="'+BoolToStr(aPolice.reportkkm,'1','0')+'",'+
     ' `editsoft`="'+BoolToStr(aPolice.editsoft,'1','0')+'",'+
     ' `edithw`="'+BoolToStr(aPolice.edithw,'1','0')+'",'+
     ' `editgoods`="'+BoolToStr(aPolice.editgoods,'1','0')+'",'+
     ' `editusers`="'+BoolToStr(aPolice.editusers,'1','0')+'",'+
     ' `exittoos`="'+BoolToStr(aPolice.exittoos,'1','0')+'",'+
     ' `enterukm`="'+BoolToStr(aPolice.enterukm,'1','0')+'",'+
     ' `entercash`="'+BoolToStr(aPolice.entercash,'1','0')+'",'+
     ' `deferredcheck`="'+BoolToStr(aPolice.deferredcheck,'1','0')+'", '+
     ' `discount`="'+BoolToStr(aPolice.discount,'1','0')+'" '+
     'WHERE `userid`="'+aID+'";';
    formstart.DB_query(Query);
   end;

end;

procedure TFormSpUsers.BitBtn1Click(Sender: TObject);
begin

end;

procedure TFormSpUsers.BitBtn2Click(Sender: TObject);
var
  i,
  i2,
  i1:integer;
  s2,s3,
  s1:string;
begin
  if flNew then begin
   i:=1;
   flUserId := lstUser.Strings[listbox1.Count-1];
   flUserId := inttostr(strtoint(flUserId)+1);

   listbox1.Items.Add(Edit1.text);
   lstUser.Add(flUserId);
   if checkbox3.Checked then
     s1:='1'
   else
     s1:='';
   i1:=combobox1.Items.IndexOf(combobox1.Caption);
   i2:=combobox2.Items.IndexOf(combobox2.Caption);
   s2:='A';
   s3:='M';
   if i1=1 then s2:='O';
   if i1=2 then s2:='K';
   if i2=1 then s3:='K';
   formstart.DB_query(
     'INSERT INTO `sprusers` ( `name`,`fullname`,`barcodes`,`pincode`,`password`,`freeprice`,`interface`,`groupid`,`userid`) VALUES ('''+edit1.text+''','''+edit1.text+''','''+edit3.text+''','''+edit2.text+''','''+edit3.text+''','''+s1+''','''+S3+''','''+S2+''','''+flUserId+''');');

   SetPolice(flUserId,FPolice);
   end else begin

  i1:=combobox1.Items.IndexOf(combobox1.Caption);
  i2:=combobox2.Items.IndexOf(combobox2.Caption);
  s2:='A';
  s3:='M';
  if i1=1 then s2:='O';
  if i1=2 then s2:='K';
  if i2=1 then s3:='K';
  formstart.DB_query(
    'UPDATE `sprusers` SET `name`='''+edit1.text+''',`fullname`='''+edit1.text+''',`barcodes`='''+edit3.text+''',`pincode`='''+edit2.text+''',`password`='''+edit3.text+''',`interface`='''+S3+''',`groupid`='''+S2+'''  where `userid`='''+flUserId+''';');
  SetPolice(flUserId,FPolice);
  end;
   flNew:=false;
   refreshUser();
end;

procedure TFormSpUsers.BitBtn3Click(Sender: TObject);
var
  i1,i2,i3,
  i:integer;
  s1,s2,s3:string;
begin
  flNew:=true;
  Edit1.Text:='';
  Edit2.text:='';
  Edit3.text:='';
  Edit4.text:='';
  ComboBox1.Caption:='';
  ComboBox2.Caption:='';
    CheckBox1.Checked:= true;
    FPolice.exittoos:=true;
    CheckBox4.Checked:= true;
    FPolice.enterukm:=true;
    CheckBox5.Checked:= true;
    FPolice.EnterCash:=true;
    CheckBox3.Checked:= true;
    FPolice.FreePrice:=true;
    CheckBox6.Checked:= true;
    FPolice.findvisual:=true;
    CheckBox7.Checked:=  true;
    FPolice.deferredcheck:=true;
    CheckBox8.Checked:= true;
    FPolice.storno:=true;
    CheckBox9.Checked:= true;
    FPolice.cancelcheck:=true;
    CheckBox10.Checked:= true;
    FPolice.cancelcheck:=true;
    CheckBox11.Checked:= true;
    FPolice.reportx:=true;
    CheckBox12.Checked:= true;
    FPolice.reportkkm:=true;
    CheckBox13.Checked:= true;
    FPolice.editsoft:=true;
    CheckBox14.Checked:= true;
    FPolice.edithw:=true;
    CheckBox15.Checked:= true;
    FPolice.editgoods:=true;
    CheckBox16.Checked:=true;
    FPolice.editusers:=true;

  i:=1;
  flUserId := lstUser.Strings[listbox1.Count-1];
  flUserId := inttostr(strtoint(flUserId)+1);
  Edit4.Text:=flUserID;
{  listbox1.Items.Add(Edit1.text);
  lstUser.Add(flUserId);     }
  if checkbox3.Checked then
    s1:='1'
  else
    s1:='';
  i1:=combobox1.Items.IndexOf(combobox1.Caption);
  i2:=combobox2.Items.IndexOf(combobox2.Caption);
  s2:='A';
  s3:='M';
  if i1=1 then s2:='O';
  if i1=2 then s2:='K';
  if i2=1 then s3:='K';
  {
  formstart.DB_query(
    'INSERT INTO `sprusers` ( `name`,`fullname`,`barcodes`,`pincode`,`password`,`freeprice`,`interface`,`groupid`,`userid`) VALUES '+
    '('''+edit1.text+''','''+edit1.text+''','''+edit3.text+''','''+edit2.text+''','''+edit3.text+''','''+s1+''','''+S3+''','''+S2+''','''+flUserId+''');');

  SetPolice(flUserId,FPolice);   }
end;

procedure TFormSpUsers.CheckBox10Change(Sender: TObject);
begin
  FPolice.returncheck:=CheckBox10.Checked;
end;

procedure TFormSpUsers.CheckBox11Change(Sender: TObject);
begin
  FPolice.reportx:=CheckBox11.Checked;
end;

procedure TFormSpUsers.CheckBox12Change(Sender: TObject);
begin
  FPolice.reportkkm:=CheckBox12.Checked;
end;

procedure TFormSpUsers.CheckBox13Change(Sender: TObject);
begin
  FPolice.editsoft:=CheckBox13.Checked;
end;

procedure TFormSpUsers.CheckBox14Change(Sender: TObject);
begin
  FPolice.edithw:=CheckBox14.Checked;
end;

procedure TFormSpUsers.CheckBox15Change(Sender: TObject);
begin
  FPolice.editgoods:=CheckBox15.Checked;
end;

procedure TFormSpUsers.CheckBox16Change(Sender: TObject);
begin
  FPolice.editusers:=CheckBox16.Checked;
end;

procedure TFormSpUsers.CheckBox1EditingDone(Sender: TObject);
begin
  FPolice.exittoos:=CheckBox1.Checked;
end;

procedure TFormSpUsers.CheckBox3EditingDone(Sender: TObject);
begin
  FPolice.freeprice:=CheckBox3.Checked;
end;

procedure TFormSpUsers.CheckBox4EditingDone(Sender: TObject);
begin
  FPolice.enterukm:=CheckBox4.Checked;
end;

procedure TFormSpUsers.CheckBox5EditingDone(Sender: TObject);
begin
  FPolice.entercash:=CheckBox5.Checked;
end;

procedure TFormSpUsers.CheckBox6EditingDone(Sender: TObject);
begin
  FPolice.findvisual:=CheckBox6.Checked;
end;

procedure TFormSpUsers.CheckBox7Change(Sender: TObject);
begin
  FPolice.deferredcheck:=CheckBox7.Checked;
end;

procedure TFormSpUsers.CheckBox8Change(Sender: TObject);
begin
  FPolice.storno:=CheckBox8.Checked;
end;

procedure TFormSpUsers.CheckBox9Change(Sender: TObject);
begin
  FPolice.cancelcheck:=CheckBox9.Checked;
end;

procedure TFormSpUsers.FormCreate(Sender: TObject);
begin
  lstUser:=TStringList.create();
end;

end.

