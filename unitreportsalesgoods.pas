unit unitReportSalesGoods;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, ComCtrls, Buttons, StdCtrls,mysql50;

type

  { TFormReportSalesGoods }

  TFormReportSalesGoods = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    cbRMKId: TComboBox;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1Next(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    startDate:TdateTime;
    //EndDate: TdateTime;
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
    ind:integer;
    endDate:TdateTime;
    vBankSumm:string;
    vSummall:String;
    vt50:string;
    vt51:string;
    vNalich:string;
    procedure SetListRMK();
  end;

var
  FormReportSalesGoods: TFormReportSalesGoods;

implementation
uses unitstart,unitfilter;
{$R *.lfm}

{ TFormReportSalesGoods }

procedure TFormReportSalesGoods.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
    if rowbuf = nil then
       eof:=true
       else eof:=false;
end;

procedure TFormReportSalesGoods.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  ParValue:='';
  if ParName='num' then begin
     ParValue:=inttostr(ind);
  end;
  if ParName='name' then
      ParValue:=rowbuf[1];
  if ParName='plu' then
      ParValue:=rowbuf[0];
 if ParName='price' then
      ParValue:=rowbuf[2];
 if ParName='count' then
      ParValue:=rowbuf[4];
  if ParName='summ' then
      ParValue:=rowbuf[3];
  if ParName='datedoc' then
      ParValue:=statictext1.Caption;
{  if linenum < formbuytth.ListView1.Items.Count then begin
    if ParName='name' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[0];
    if ParName='count123' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[1];
    if ParName='forma' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[6];
    if ParName='formb' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[9];
    if ParName='cena' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[3];
    if ParName='summ1' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[4];
    if ParName='nowformb' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[7];
    if ParName='manufactur' then
       begin
         ParValue:=trim(formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[10]);
         formstart.rowbuf:=formstart.db_next(formstart.db_query('select `fullname`,`inn`,`kpp` from `spproducer` where `clientregid`="'+ParValue+'";'));

         if formstart.rowbuf<>nil then
            ParValue:=formstart.rowbuf[0]+' ('+formstart.rowbuf[1]+'/'+formstart.rowbuf[2]+') ['+ParValue+']';
       end;
  end;         }
  if ParName='itogosumm' then
       ParValue:=vSummAll;
  if ParName='banksumm' then
       ParValue:=vBankSumm;
  if ParName='cashnal' then
       ParValue:=vNalich;
  if ParName='cashincome' then
       ParValue:=vt50;
  if ParName='cashoutcome' then
       ParValue:=vt51;
  if ParName='firmname' then
       ParValue:=formstart.FirmFullName;
  if ParName='innkpp' then
       ParValue:=formstart.FirmINN+'/'+formStart.firmkpp;
    if ParName='address' then
       ParValue:=formstart.FirmAddress;
end;

procedure TFormReportSalesGoods.FormShow(Sender: TObject);
begin
  FrReport1.Clear;
  FrReport1.LoadFromFile('report\oborotday.lrf');
  StartDate:=now();
  endDate:=now();
  self.SetListRMK();
  statictext1.Caption:='Период '+FormatDateTime('DD-MM-YYYY',StartDate)+' - '+FormatDateTime('DD-MM-YYYY',EndDate);
  ind:=0;
end;

procedure TFormReportSalesGoods.BitBtn1Click(Sender: TObject);
var
  Query:String;

begin
  vSummAll:='0.00';
  vBankSumm:='0.00';
  vt50:='0.00';
  vt51:='0.00';
  query:='SELECT `typetrans`,SUM(`quantity`*`price`) AS `allsumm` FROM `doccash` WHERE `datedoc`>="'
  +FormatDateTime('YYYY-MM-DD',startDate)+'"AND `datedoc`<="'
  +FormatDateTime('YYYY-MM-DD',EndDate)+'" AND (`typetrans`="11" OR `typetrans`="13" OR `typetrans`="140" OR `typetrans`="50" OR `typetrans`="51") GROUP BY `typetrans`;' ;
  recbuf:=formStart.DB_query(  query  );
  rowbuf:=formStart.DB_Next(recbuf);
  while rowbuf<>nil do begin
    if rowbuf[0]='11' then
       vSummAll:= rowbuf[1];
    if rowbuf[0]='140' then
       vBankSumm:= rowbuf[1];
    if rowbuf[0]='50' then
       vt50:= rowbuf[1];
    if rowbuf[0]='51' then
       vt51:= rowbuf[1];
    rowbuf:=formStart.DB_Next(recbuf);
  end;
  vNalich:=floattostr(strtofloat(vSummAll)+strtofloat(vt50)-strtofloat(vt51)-strtofloat(vBankSumm));
  query:='SELECT `plu`,`name`,`price`,SUM(`quantity`*`price`) AS `allsumm`, SUM(`quantity`) AS `summ` FROM `doccash` WHERE `datedoc`>="'
  +FormatDateTime('YYYY-MM-DD',startDate)+'" AND `datedoc`<="'
  +FormatDateTime('YYYY-MM-DD',EndDate)+'" AND (`typetrans`="11" OR `typetrans`="13") GROUP BY `name`,`price`;' ;
  recbuf:=formStart.DB_query(  query  );
  rowbuf:=formStart.DB_Next(recbuf);
  ind:=0;
  frReport1.ShowReport;
end;

procedure TFormReportSalesGoods.BitBtn2Click(Sender: TObject);
begin
    if FormFilter.ShowModal = 1377 then begin
      startDate:= FormFilter.StartDate;
      endDate  := FormFilter.EndDate;
      statictext1.Caption:='Период '+FormatDateTime('DD-MM-YYYY',StartDate)+' - '+FormatDateTime('DD-MM-YYYY',EndDate);
    end;
end;

procedure TFormReportSalesGoods.BitBtn3Click(Sender: TObject);
var
  RStr:TStringList;
begin
 if formStart.flRMKOffline then begin
    // flRMKFileLoad:string;
   if FormStart.flRMKFolderLoad[length(FormStart.flRMKFolderLoad)] <>'\' then
     FormStart.flRMKFolderLoad:=FormStart.flRMKFolderLoad+'\';
   if FileExists(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport)) then
         DeleteFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
   rStr:=TStringList.Create;
   rStr.text:=formStart.SaveShtrihMFile(startDate,enddate,cbRMKId.text);
   rStr.SaveToFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
   rStr.free;
   showmessage('Отчет выгружен.');
 end;

end;

procedure TFormReportSalesGoods.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormReportSalesGoods.FormCreate(Sender: TObject);
begin

end;

procedure TFormReportSalesGoods.frUserDataset1Next(Sender: TObject);
begin
  rowbuf:=formStart.DB_Next(recbuf);
  ind:=ind+1;
end;

procedure TFormReportSalesGoods.SetListRMK();
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
begin

  cbRMKId.Items.Clear;
  query:='SELECT `numkass` FROM `sprkass` ;';
  xrecbuf := formstart.DB_query(Query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while not (xrowbuf = nil) do begin
    cbRMKId.Text:=xrowbuf[0];
    cbRMKId.items.Add(cbRMKId.Text);
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;

end;

end.

