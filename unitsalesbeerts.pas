{
 Разработчик мсходного кода:Уфандеев Е.В.
 е-майл:uffik@mail.ru       closecheck

}
unit unitSalesBeerts;

{$mode objfpc}{$H+}
{
 QR code = t=20180702T183900&s=507.00&fn=9285000100069873&i=1383&fp=3471910423&n=1

 округление

 0.002*5.55=(0.0111)

}
interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Grids, Buttons, StdCtrls, Menus, ComCtrls, ExtDlgs;

type

  TRecSummCheck = record
    AllSumm:real;
    DepBank:integer;
    depCash:string;
    Active:boolean;
    inputsummNal:real;
    inputsummBank:real;
    egaisurl:string;
    egaissign:string;
    // === значения оплаты банком
    CodeRRN:string;
    CodeAuth:string;
    alckass:boolean;
  end;

  { TFormSalesBeerTS }

  TFormSalesBeerTS = class(TForm)
    bbBlockScreen: TBitBtn;
    bbDeferredCheck: TBitBtn;
    bbExit: TBitBtn;
    bbExit1: TBitBtn;
    bbNextService: TBitBtn;
    bbRetDeferredCheck: TBitBtn;
    bbRetDeferredCheck1: TBitBtn;
    bbDeferredCheck1: TBitBtn;
    bbRetDeferredCheck2: TBitBtn;
    bbRetDeferredCheck3: TBitBtn;
    bbViplata: TBitBtn;
    bbVisualFindGoods: TBitBtn;
    bbVnesti: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    cldDialog: TCalendarDialog;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miXReport: TMenuItem;
    miZReport: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Function1Panel: TPanel;
    ServicePanel: TPanel;
    TimerHW: TTimer;
    ToolBarTopPanel: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pnlFastGoods: TPanel;
    pnlRetDeferredCheck: TPanel;
    pnlService: TPanel;
    pnlService1: TPanel;
    pnlSetDeferredCheck: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnlSprGoods: TPanel;
    PopupMenu1: TPopupMenu;
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
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    StaticText22: TStaticText;
    StaticText23: TStaticText;
    StaticText24: TStaticText;
    StaticText25: TStaticText;
    StaticText26: TStaticText;
    StaticText27: TStaticText;
    StaticText28: TStaticText;
    StaticText29: TStaticText;
    StaticText3: TStaticText;
    StaticText30: TStaticText;
    StaticText31: TStaticText;
    StaticText32: TStaticText;
    StaticText33: TStaticText;
    StaticText34: TStaticText;
    StaticText35: TStaticText;
    StaticText36: TStaticText;
    StaticText37: TStaticText;
    StaticText38: TStaticText;
    StaticText39: TStaticText;
    StaticText4: TStaticText;
    StaticText40: TStaticText;
    stDiscount: TStaticText;
    stCaption: TStaticText;
    StaticText5: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    stLoadGoods: TStaticText;
    stOnline: TStaticText;
    stOnline1: TStaticText;
    stSumma: TStaticText;
    stTypeDoc: TStaticText;
    stNumCheck: TStaticText;
    stBarcode: TStaticText;
    stPDF417: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    stNumber: TStaticText;
    StringGrid1: TStringGrid;
    stUTMStatus: TStaticText;
    procedure bbBlockScreenClick(Sender: TObject);
    procedure bbDeferredCheckClick(Sender: TObject);
    procedure bbExitClick(Sender: TObject);
    procedure bbNextServiceClick(Sender: TObject);
    procedure bbViplataClick(Sender: TObject);
    procedure bbVnestiClick(Sender: TObject);
    procedure bbRetDeferredCheckClick(Sender: TObject);
    procedure bbDeferredCheck1Click(Sender: TObject);
    procedure bbRetDeferredCheck1Click(Sender: TObject);
    procedure bbRetDeferredCheck2Click(Sender: TObject);
    procedure bbRetDeferredCheck3Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure bbVisualFindGoodsClick(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1Next(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure miXReportClick(Sender: TObject);
    procedure miZReportClick(Sender: TObject);
    procedure Panel10Click(Sender: TObject);
    procedure Panel10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel11Click(Sender: TObject);
    procedure Panel11MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel12Click(Sender: TObject);
    procedure Panel12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel13Click(Sender: TObject);
    procedure Panel13MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel18Click(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel6Click(Sender: TObject);
    procedure Panel6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7Click(Sender: TObject);
    procedure Panel7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel8Click(Sender: TObject);
    procedure Panel8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel9Click(Sender: TObject);
    procedure Panel9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlRetDeferredCheckResize(Sender: TObject);
    procedure pnlService1Click(Sender: TObject);
    procedure pnlServiceClick(Sender: TObject);
    procedure StaticText4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1Resize(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure TimerHWTimer(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
    procedure MyExceptHandler(Sender: TObject; E: Exception);
  private
    { private declarations }
    FlgLoadLibFR:boolean;
    FlgLoadLibSB:boolean;
    SizeStrFr:Integer;

    fl_slip_check:TStringList;
  public
    flgResto:boolean;
    flPrefixCheck:String;
    flMultiTable:boolean;
    { public declarations }
    flCurUserName:string;
    flWriteOff:boolean;
    flNumber:string;
    // флаг продажи - истина, ложь - возврат
    flCheckSales:boolean;
    flSession:integer;
    flNumcheck:integer;
    flAllSumma:real;
    flAllSummDiscount:real;
    flInpSumm:real; // Введеная сумма
    curLine:integer;
    Itogsumm:real;
    flSelRow:integer;
    flOpenDoc:boolean;
    flTypeKKM:integer; // 0,1 - ШтрихМ , 2 - Атол ....
    indCheck:integer;
    flPrefixVes:string;
    flPrefixCard:String;
    flIdCard:string;
    flProcentCard:string;
    flProcentSkid:real;
    flRNKKT:string;
    flFNNumber:string;
    flMFKKT:string;
    flPayBank:boolean;
    flTaxType:String;
    flCurrentTable:string;
    flMultiSection:boolean;
    flGroupIdCigar:string;
    flSBDep:integer; // Подразделение Банка
    ArrDeferredCheck:array[0..100,0..18,0..3] of string;
    flSelectDeferredCheck:integer;
    ArrCountDeferredCheck:array[0..3] of integer;
    pnlSelectTable:TPanel;
    flg_view_only:Boolean;
    bgImg1:TPicture;
    ArrFastGood:array[0..15] of string;
    {Section devices}
    SummCheck: TRecSummCheck;
    SummAlcCheck: TRecSummCheck;
    flAddBeerToCheck:boolean;
    {ККТ для егаис}
    fldepEGAIS:integer;
    FlgLoadLibLP:boolean;
    FlgLoadLibLPMini:boolean;
    flg_dto_10:boolean;
    function addBarcode(aBC:String):boolean;

    function addPLUcode(aBC,aCount:string):boolean;
    function getvolumebc(abc:string):string;
    function addPositionEGAIS(idDep:integer; aBank:boolean):boolean;
    function addtrans(aKassaHW,
                      aNumCheck,
                      aTrans,
                      aPLU,
                      aCount,
                      aPrice,
                      aSumm,
                      aBarCode,
                      alccode,
                      aPDF417:String;
                      aName:string = '';
                      aRegFR:boolean=true;
                      aSection:string='';
                      aBanking:Boolean=false;
                      aIdTable:String='0'):boolean;
    function controlpdf417(aPDF417:string):boolean;
    function printcheck():boolean;
    {Функция закрытия чека.
    Возвращает истину при удачном завершении}
    function closecheck():boolean;
    function printURL(aURL,aSIGN:string):boolean;
    function FRPrintQRCode(aURL:String):boolean;
    {Операция ККМ - Закрытие чека}
    function OrderSale(aOperBank:boolean):integer;
    function OrderReturn(aOperBank:boolean):integer;
    Procedure ShowKKMOption();
    Procedure PrintZReport();
    Procedure PrintXReport();
    Procedure PrintBankReport();
    Procedure PrintInkass();
    Procedure PrintDepReport();
    function GetStatusFR(Messages:boolean):Integer;
    function GetNumberCheck():Integer;
    Function PrintLineGood(aname:String;count:String;dblStr:boolean = false):integer;
    Function PrintLineString(const aStr:String;dblStr:boolean = false):integer;
    FUNCTION StrCenter(const aStr:String):String;
    Function PrintLineStringAnsi(const aStr:ansiString;dblStr:boolean = false):integer;
    Function PrintLineStringWide(const aStr:WideString;dblStr:boolean = false):integer;
    procedure NewCheck();
    procedure clearcheck();
    procedure PrintAlcReport(aDate:String);
    procedure GetReport();
    function GetAllSumm():real;
    // === СБЕРБАНК =====
    // --- Сбербанк - обработки
    {:Печать слип чека}
    function PrintSlipSB(aDep:integer;aCountSlip:integer=1):integer;
    function CloseDaySB():integer;
    function SalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    function SalesCardSBv2(aDepart:integer):integer;
    function CancelSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    function ReturnSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    procedure CashIncome();
    procedure CashOutcome();
    function summTitle(aSumm:real):string;
    function InitDevice():boolean;
    procedure FRPrintHeader();
    procedure FRPrintFooter();
    procedure FRBeep;
    procedure PrintReklamCheck;
    {:Печает ШК номер и дату документа}
    procedure PrintNumCheck();
    procedure repaintTypeDoc;
    Procedure FRCutCheck();
    {:Присваивает Имя кассира для текущего сеанса}
    procedure SetOperName();
    function InitSection():boolean;
    function GetSummDep():real;
    procedure ActiveDep();
    procedure ClearSummDep;
    function isDeleteDep(aDep:integer):boolean;
    procedure OpenDrawerAll;
    // add 24/07/2018
    {Обновляет все надписи при измении }
    procedure refreshStaticText;
    {Проверяет заполнена секция, по необходимости заполняет "0"}
    function GetSectionForGood(aStr:string):String;
    function InitScale:boolean;
    Procedure ScaleUploadGoods(idDevice:String);
    function GetScaleCurrentCash():string;
    function InitSBClient():boolean;
    {Обновляет надпись пита чека}
    procedure SetTypeDocCapture(AddUserName:boolean=FALSE);
    procedure SetCurrentKassirName();
    function RoundRub(aFloat:real;asss:integer):real;
    procedure InitTableShems();
    {Отключить печать чера
    @NotPrint - Не обязательный параметр}
    procedure set_not_print(NotPrint:boolean = True);
    procedure set_Customer_Email(phone_email:String);
    function get_gtin(type_mark:word; serial_gtin:string;break_ch:string=''):string;
    function test_gs1datamatrix(str1:string):boolean;
    procedure trans_check(bankOnly:boolean);
  end;

var
  FormSalesBeerTS: TFormSalesBeerTS;



//function thisBeer(fIMNS:string):boolean;
//function getshiftcash():string;

implementation
uses
  lazutf8,
  mysql50,
  DOM, XMLRead, typinfo,
  qrcode,
  comobj,  variants,
  LCLIntf,
  math,
 // base64,
  lconvencoding,
  INIFiles,
  lclproc
  //,ssockets
  ,fphttpclient // Стандартная библиотека для http
  ,unitsetpdf417
  ,unitstart
  , unitloginadmin
  , unitinputprice
  ,unitaddbarcode,
  unitinputsumm ,
  unitinputsummv2
  ,unitSelectProd,
  unitShowStatus,
  unitunlockscreen,
  unitcomment
  ,unituserloginv2
  ,Unitdevices,
  unitvisualfindgoods,
  unitvisualselectgoods,
  unitvisualselecttable,
  unitinputquantity,
  unitactwriteoffts,
  unitspusers,
  unitactwritebeer,
  unitvikidevice,
  unitshowmessage,
  unitlogging,
  udiscountcard,
  unitcigar,
  univiewcheck;
{$R *.lfm}


{ TFormSalesBeerTS }
CONST
  cnIDSection = 15;
var
  // === Объект ФР ====
  OleFR:Olevariant;
  OleFRAlc:Olevariant;
  OleSBR:Olevariant;
  OleLP:Olevariant;
  OleLPMini:Olevariant;



{  перенесли в unitdevices
function thisBeer(fIMNS:string):boolean;
begin
 result:=false;
 if fIMNS ='500' then result:=true;
 if fIMNS ='520' then result:=true;
 if fIMNS ='261' then result:=true;
 if fIMNS ='263' then result:=true;
 if fIMNS ='262' then result:=true;
end;
}
function  StrToWide(const aStr: ansiString):widestring;
var
  i:byte;
  str1:WideString;
  str2:string;
begin
  str1:=aStr;
  result:= str1;
end;

function replaceStrSerial(const aStr:string):string;
var
  i:integer;
  begin
    result:='';
    for i:=1 to length(aStr) do
     if not (aStr[i] in ['(',')']) then
       result:=result+aStr[i];


  end;

{функция формирует код для тега 1162
ссылки:
       https://xn--80ajghhoc2aj1c8b.xn--p1ai/upload/iblock/09e/09e9978505dad5ba4a8f814420ab20b7.pdf
пример GTIN: 011500015807102221VFVD1KXEH40H791EE0692TgCr+T/nLRMUHK9G/KSNotpzVMbqSO/kAOgABkIyRow=
AI = 01, 21, 91, 92
формат значения цифры первый последнее значение
Код DataMAtrix 444D
Штрих-М
НомерТэга_hex = ПолучитьБайтыВОбратномПорядке(DecToHex(НомерТэга_инт, 4));
ДлинаТэга_hex = ПолучитьБайтыВОбратномПорядке(DecToHex(Окр(СтрДлина(ЗначениеТэга_hex)/2), 4));
ФР.TLVDataHex = НомерТэга_hex + ДлинаТэга_hex + ЗначениеТэга_hex;
ФР.FNSendTLVOperation();
АТОЛ
driver.StreamFormat = 5;
driver.BeginItem();
driver.AttrNumber = 1162;
driver.AttrValue = "00 05 00 00 02 C0 BE D3 72 51 4D 54 46 34 53";
driver.WriteAttribute();

}

function GD1DataMatrix(str_1:string):WideString;
var
  s1 : string;
  s2:ansistring;
begin
  s1 := copy(str_1,1,2)  ;
  if s1 = '01' then begin
   s1:= '(01)'+Copy(str_1,3,14)+'('+Copy(str_1,17,2)+')'+Copy(str_1,19,6);//+chr(29)+'('+Copy(str_1,25,2)+')'+copy(str_1,27,UTF8length(str_1)-26);
   end else
   s1 := '(01)'+Copy(str_1,1,14)+'(21)'+Copy(str_1,15,7); //+chr(29)+
  s2:=utf8toansi(s1);
  result:=StrToWide(str_1);
end;

function TFormSalesBeerTS.get_gtin( type_mark:word; serial_gtin:string;break_ch:string='' ):string;
var
  tmpS:string;
  s1, s2:string;
  gtin:int64;
  i,ii:integer;
  mass:array[0..25] of byte; // массив байт
begin

  {2b  6b   7b + 11b}
  {приобразуем GTIN в int64 и отсекаем последние 2 байта}
  s1:='';
  s2:='';
  i:=1;
  tmpS:=replaceStrSerial( serial_gtin);
  while i<length(tmpS)-1 do
    case (tmpS[i]+tmpS[i+1]) of
      '01': begin // read gtin len 14
        i:=i+2;
        s1:='';
          for ii:= i to i+13 do
            s1 := s1 + tmpS[ii];
          i:=i+14;
       end;
       '21':begin // len 20
          i:=i+2;
          s2:='';
          for ii:= i to i+12 do
            s2 := s2 +inttohex(ord(tmpS[ii]),2);
          break;
       end;
       '91':;
    else
      i:=i+1;
    end;


  gtin:= strtoint64(S1);
  s1:= inttohex(gtin, 6);
  if (length(s1) mod 2 ) = 1 then
      s1:='0'+s1;

  result:='444D'+s1+s2;

end;

function TFormSalesBeerTS.test_gs1datamatrix(str1: string): boolean;
var
   strw:widestring;
   res:integer;
begin
   OleFR.Password:=30;
   strw := GD1DataMatrix(str1);
                OleFR.BarCode := strw;
                OleFR.ItemStatus := 1;
                OleFR.CheckItemMode := 0;
                OleFR.FNCheckItemBarcode();
                res:=OleFR.ResultCode;
                if res <> 0 then begin
                  formstart.fshowmessage('Error '+inttostr(res)+' FNCheckItemBarcode:'+OleFR.ResultCodeDescription+' BC:'+strw);
                  result:=false;
                end else result:=true;

end;

procedure TFormSalesBeerTS.clearcheck();
var
  em_summ:float;
  ii:integer;
begin
  flg_view_only := False;
  flPayBank:=false;
  flWriteOff:=false;
  flNumber:='';
  curLine:=0;
  flCheckSales:=true;
  self.flAllSumma:=0;
  flAllSummDiscount:=0;
  Itogsumm:=0;
  flselrow:=0;
  flOpenDoc:=false;
  flPrefixVes:=formStart.GetConstant('prefixvesi');
  flPrefixcard:=formStart.GetConstant('prefixcard');
  flIdCard:='';
  flProcentCard:='0';
  flProcentSkid:=0;
  ClearSummDep();
  for ii:= 1 to StringGrid1.RowCount-1 do
    StringGrid1.Rows[ii].Clear;
  StringGrid1.RowCount:=curLine+1;
  stSumma.Caption:=format('СУММА: %8.2f',[self.flallsumma]);
  flCurUserName:=formspusers.GetPolice(formstart.flCurUserId).fullname;
  SetTypeDocCapture(TRUE);
  if flMultiTable then begin
    if flCurrentTable<>'' then
      stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
  end;

  stNumCheck.Caption:='Номер чека:'+#13#10+inttostr(flNumCheck);
  StringGrid1Selection(nil,0,0);
  case flTYpeKKM of
    0: begin
      OleFR.Password:=30;
      OleFR.GetECRStatus();
      ii:=OleFR.ECRMode;
      if ii = 8 then begin // 74 - Чек открыт
        em_summ := OleFR.Summ1;
        em_summ := em_summ + OleFR.Summ2;
        if em_summ > 0 then OleFR.CloseCheck() else OleFR.CancelCheck();
      End;
      formstart.sslog.Add(FormatDateTime('DD-MM-YY hh:mm',now())+': Очиска чека OleFR.ECRMode = '+inttostr(ii));
      formstart.sslog.SaveToFile('messages.log');
    end;
    2: VIKICloseDocument;

  end;
  SummCheck.egaisurl := '';
  SummCheck.egaissign := '';
end;

procedure TFormSalesBeerTS.PrintAlcReport(aDate:String);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  allsumm:real;
  AllCount:real;
  allFloatSumm:real;
  allFloatRet:real;
  flPrintFull:Boolean;
begin
  flPrintFull := formStart.GetConstBool('printfullreport');
 xrecbuf:=formStart.DB_query('SELECT `name`, SUM(`quantity`) AS `scount`,SUM(`summ`) as `flsumm` FROM `doccash` WHERE `datedoc`="'+aDate+'" AND `typetrans`="11" GROUP BY `plu`,`summ`;');
 xrowbuf:=formstart.DB_Next(xrecbuf);
 i:=1;
 allsumm:=0;
 PrintLineStringAnsi(utf8toansi('Отчет о продажах за '+aDate));
 //PrintLineGood('Наименование','шт.');
 allFloatSumm:=0;
 while xrowbuf<>nil do begin
   if flPrintFull then
     PrintLineGood(inttostr(i)+' '+xrowbuf[0],xrowbuf[1]+'='+format('%0.2f',[formstart.StrToFloat(xrowbuf[2])]));

   allsumm:=allsumm+strtofloat(trim(xrowbuf[1]));
   allFloatSumm:=allFloatSumm+strtofloat(xrowbuf[2]);
   i:=i+1;
   xrowbuf:=formstart.DB_Next(xrecbuf);
 end;
 PrintLineStringAnsi(utf8toansi(copy('=========================================================================================',1,SizeStrFr)));
 PrintLineGood('Итого продано:',format('%0.2f',[allsumm]));
 PrintLineGood('Итого продано(руб):',format('%0.2f',[allFloatSumm]));
 PrintLineStringAnsi(utf8toansi('Отчет о возвратах за '+aDate));
 xrecbuf:=formStart.DB_query('SELECT  `name`, SUM(`quantity`) AS `scount`,SUM(`summ`) as `flsumm`  FROM `doccash` WHERE `datedoc`="'+aDate+'" AND `typetrans`="13" GROUP BY `plu`,`summ`;');
 xrowbuf:=formstart.DB_Next(xrecbuf);
 i:=1;
 AllCount:=allsumm;
 allsumm:=0;
 allFloatRet:=0;
 PrintLineGood('Наименование','шт.');
 while xrowbuf<>nil do begin
   PrintLineGood(inttostr(i)+' '+xrowbuf[0],xrowbuf[1]+'='+format('%0.2f',[formstart.StrToFloat(xrowbuf[2])]));
   allsumm:=allsumm+strtofloat(trim(xrowbuf[1]));
   allFloatSumm:=allFloatSumm+strtofloat(xrowbuf[2]);
   i:=i+1;
   xrowbuf:=formstart.DB_Next(xrecbuf);
 end ;
 AllCount:=AllCount-allsumm;
 PrintLineGood('Возвратов (шт):',format('%0.2f',[allsumm]));
 PrintLineGood('Возвратов (руб):',format('%0.2f',[allFloatRet]));
 PrintLineGood('Итого (шт):',format('%0.2f',[AllCount]));
 PrintLineGood('Итого (руб):',format('%0.2f',[allFloatSumm-allFloatRet]));
 FRPrintHeader;
 if flTypeKKM=2 then
    VIKICloseDocument;
end;

procedure TFormSalesBeerTS.NewCheck();
begin
 flNumber:='';
 clearcheck();
 GetStatusFR(true);
 SetCurrentKassirName();
 showmodal;

end;

function TFormSalesBeerTS.printcheck():boolean;
var
  ii:integer;
begin
 result:=false;
 try
  for ii:=1 to stringgrid1.RowCount-1 do  begin
    PrintLineGood(StringGrid1.Cells[2,ii],'');
    case flTYpeKKM of
       2:begin
            PrintLineGood(' 01',StringGrid1.Cells[4,ii]+' ='+trim(StringGrid1.Cells[3,ii]));
            PrintLineGood(' 01','='+trim(StringGrid1.Cells[5,ii]));
          if (StringGrid1.Cells[17,ii] <> '' )  then
             begin
               if round(strtofloat(StringGrid1.Cells[17,ii]))<>0 then
                  PrintLineGood('СКИДКА '+StringGrid1.Cells[17,ii]+'% :', trim(StringGrid1.Cells[13,ii]));
             end;
       end;
      1: begin
        PrintLineGood(' 01',StringGrid1.Cells[4,ii]+' ='+trim(StringGrid1.Cells[3,ii]));
      end
      else
         PrintLineGood('',StringGrid1.Cells[4,ii]+' X '+trim(StringGrid1.Cells[3,ii]));
         PrintLineGood('1','='+trim(StringGrid1.Cells[5,ii]));
    end;
  end;
  result:=true;
 except
  result:=false;
 end;
end;

function TFormSalesBeerTS.closecheck():boolean;
var
  codeok:integer;
begin
 result:=false;
 try
  if flCheckSales then
    codeok := self.OrderSale(SummCheck.inputsummBank<>0)
  else
    codeok :=  self.OrderReturn(flPayBank);
  result:=true;
 except
  on E : Exception do begin
   formstart.MyExceptHandler(self,E);
   result:=false;

  end else
    result:=false;
 end;
 StringGrid1.SetFocus;
end;

procedure TFormSalesBeerTS.set_not_print(NotPrint:boolean = True);
var
  i:integer;
begin

   if FlgLoadLibFR then begin
     case flTypeKKM of
       0:begin
         OleFR.Password := 30;
         OleFR.TableNumber := 17;
         OleFR.RowNumber := 1;
         OleFR.FieldNumber := 7;
         if NotPrint then OleFR.ValueOfFieldInteger := 1 else OleFR.ValueOfFieldInteger := 0;
         OleFR.WriteTable();
         i := OleFR.ResultCode;
         if not ( i = 0 ) then
            formstart.fshowmessage('RC:'+inttoStr(i));
       end;
     //else
     //   formstart.fshowmessage(inttoStr( flTypeKKM));
     end;

   end;
end;

procedure TFormSalesBeerTS.set_Customer_Email(phone_email:String);
var
  ws:wideString;
  i:integer;
begin

   if FlgLoadLibFR then begin
     case flTypeKKM of
       0:begin
         ws:=phone_email;
         OleFR.Password := 30;
         OleFR.CustomerEmail := ws;
         OleFR.FNSendCustomerEmail();
         i := OleFR.ResultCode;
         //formstart.fshowmessage('RC:'+inttoStr(i));
       end;
     //else
     //   formstart.fshowmessage(inttoStr( flTypeKKM));
     end;

   end;
end;



function TFormSalesBeerTS.printURL(aURL,aSIGN:string):boolean;
var
  str1:string;
  strwd1:WideString;
  res:integer;
  i:integer;
begin
  result:=false;
  try
    if FlgLoadLibFR then begin
      case flTypeKKM of
        0:begin
                str1:=StringToHex(aURL);
  	        for i:=1 to (Length(str1) div 128)+1 do begin
  		    OleFR.Password:=30;
          	    OleFR.BlockType := 0;
         	    OleFR.BlockNumber := i-1;
                    strwd1:=Copy(str1,1+(i-1)*128,125);
         	    OleFR.BlockDataHex := strwd1;
         	    OleFR.LoadBlockData();
  	        end;
  	        OleFR.BarcodeType:=3;		//тип ШК - QR
  	        OleFR.BarcodeDataLength:=length(aURL);
  	        OleFR.BarcodeStartBlockNumber:=0;
  	        OleFR.BarcodeParameter1:=0; //версия ШК 0-авто
  	        OleFR.BarcodeParameter2:=0; //маска ШК 0-авто
  	        OleFR.BarcodeParameter3:=3; //размер точки в ШК 3..8
  	        OleFR.BarcodeParameter4:=0;
  	        OleFR.BarcodeParameter5:=2; //уровень коррекции ошибок 0..3
  	        OleFR.BarcodeAlignment:=0;  //выравнивание посередине
  	        OleFR.Password:=30;
  	        OleFR.Print2DBarcode();
  	        OleFR.WaitForPrinting();
                printURL:=true;
        end;
        1:begin // == Atol10 ===
          if flg_dto_10 then begin
            OleFR.setParam(OleFR.LIBFPTR_PARAM_BARCODE, aURL);
            OleFR.setParam(OleFR.LIBFPTR_PARAM_BARCODE_TYPE, OleFR.LIBFPTR_BT_QR);
            if OleFR.printBarcode()<0 then
             showMessage('"' + IntToStr(OleFR.errorCode) + ' [' + OleFR.errorDescription + ']"')
            else
              result:=True;
          end else begin
             OleFR.password:=30;
             strwd1:=aURL;
            // OleFR.PixelLineLength :=300;
             OleFR.PrintPurpose :=1;
             OleFR.LeftMargin :=10;
             OleFR.BarcodeType :=84;
             OleFR.Alignment :=1;
             OleFR.Barcode := strwd1;
             OleFr.Height :=1200;
             OleFR.BarcodeControlCode :=0;
             OleFR.PrintBarcodeText :=0;
             OleFR.Scale  :=400;
             OleFR.AutoSize :=0;
             res:=OleFR.PrintBarcode();
             if res<>0 then begin
               showmessage('Atol error='+inttostr(res));
               printURL:=false;
               FRBeep;
             end else
               printURL:=true;
          end ;
          end;
        2:begin
               VIKIPrintBarCode(aURL);
             end;
        4:begin
               FRPrintQRCode(aURL);
             end
        else
               OleFR.password:=30;
               strwd1:=aURL;
               OleFR.BarCode := strwd1;
               OleFR.BarWidth :=2;
               OleFR.LineNumber:=150;
               OleFR.BarcodeAlignment:=0;
               OleFR.BarcodeType:=3;
               OleFR.PrintBarcodeGraph();
               OleFR.BarcodeOptions := $011;
               OleFR.PrintBarcode();
               printURL:=true;

        end;
          end;
          str1:=asign;
          while length(str1)>32 do begin
            PrintLineString(copy(str1,1,32));
            str1 :=copy(str1,33,length(asign)-32);
          end;
          if length(str1)>1 then
             PrintLineString(str1);

          str1:=aurl;
          while length(str1)>32 do begin
            PrintLineString(copy(str1,1,32));
            str1 :=copy(str1,33,length(str1)-32);
          end;
          if length(str1)>1 then
             PrintLineString(str1);
        result:= true;
    except
     result:= false;
    end;


end;

function TFormSalesBeerTS.FRPrintQRCode(aURL: String): boolean;
var
  str1:string;
  strwd1:WideString;
  res:integer;
  i:integer;
begin
 result:=false;
  try
  if FlgLoadLibFR then
   begin
     case flTypeKKM of
       0:begin
         str1:=StringToHex(aURL);
  	for i:=1 to (Length(str1) div 128)+1 do begin
  		OleFR.Password:=30;
          	OleFR.BlockType := 0;
         	OleFR.BlockNumber := i-1;
                 strwd1:=Copy(str1,1+(i-1)*128,125);
         	OleFR.BlockDataHex := strwd1;
         	OleFR.LoadBlockData();
  	end;
  	OleFR.BarcodeType:=3;		//тип ШК - QR
  	OleFR.BarcodeDataLength:=length(aURL);
  	OleFR.BarcodeStartBlockNumber:=0;
  	OleFR.BarcodeParameter1:=0; //версия ШК 0-авто
  	OleFR.BarcodeParameter2:=0; //маска ШК 0-авто
  	OleFR.BarcodeParameter3:=3; //размер точки в ШК 3..8
  	OleFR.BarcodeParameter4:=0;
  	OleFR.BarcodeParameter5:=2; //уровень коррекции ошибок 0..3
  	OleFR.BarcodeAlignment:=0;  //выравнивание посередине
  	OleFR.Password:=30;
  	OleFR.Print2DBarcode();
  	OleFR.WaitForPrinting();

       end;
       1:begin  // ==== ATOL10 ====
           if flg_dto_10 then begin
            OleFR.setParam(OleFR.LIBFPTR_PARAM_BARCODE, aURL);
            OleFR.setParam(OleFR.LIBFPTR_PARAM_BARCODE_TYPE, OleFR.LIBFPTR_BT_QR);
            if OleFR.printBarcode()<0 then
             showMessage('"' + IntToStr(OleFR.errorCode) + ' [' + OleFR.errorDescription + ']"')
            else
              result:=True;
          end else begin
           OleFR.password:=30;
           strwd1:=aURL;
          // OleFR.PixelLineLength :=300;
           OleFR.PrintPurpose :=1;
           OleFR.LeftMargin :=10;
           OleFR.BarcodeType :=84;
           OleFR.Alignment :=1;
           OleFR.Barcode := strwd1;
           OleFr.Height :=1200;
           OleFR.BarcodeControlCode :=0;
           OleFR.PrintBarcodeText :=0;
           OleFR.Scale  :=400;
           OleFR.AutoSize :=0;
           res:=OleFR.PrintBarcode();
           if res<>0 then begin
             showmessage('Atol error='+inttostr(res));
             FRBeep;
           end
         end;
       end;
       2:begin
         VIKIPrintBarCode(aURL);
       end ;
       3:begin
         OleFR.password:=30;
         strwd1:=aURL;
        // OleFR.PixelLineLength :=300;

         OleFR.Barcode := strwd1;
         OleFR.BarcodeType := 1;
         res:=OleFR.PrintBarcode();
         if res<>0 then begin
           showmessage('Atol error='+inttostr(res));
           FRBeep;
         end
       end;
       4: begin
          OleFR.PrintBarCode(4,strwd1,2);
          res:=OleFR.ResultCode;
        end
       else
         OleFR.password:=30;
         strwd1:=aURL;
         OleFR.BarCode := strwd1;
         OleFR.BarWidth :=2;
         OleFR.LineNumber:=150;
         OleFR.BarcodeAlignment:=0;
         OleFR.BarcodeType:=3;
         OleFR.PrintBarcodeGraph();
         OleFR.BarcodeOptions := $011;
         OleFR.PrintBarcode();
       end;
    end;
    except
     on E : Exception do begin
        formstart.MyExceptHandler(self,E);
        result:=false;
     End;

    end;
end;

function TFormSalesBeerTS.addPLUcode(aBC,aCount:string):boolean;
var
  Query:string;
  PrdVCode:integer;
  vPDF417,vAlcCode,aPart,aSerial:string;
  strPrice:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  fplu:string;
  ii:integer;
  aBC1:string;
  rSumm1:real;
  rPrice1:real;
  rQual:real;
  rSumm2:real;
  rDisc1:real;

begin
 DefaultFormatSettings.DecimalSeparator:='.';
 aBC1:=Trim(aBC);
 self.flOpenDoc:=true;

{ try
    aBC1:=inttostr(Strtoint(aBC1));
 except
    aBC1:=aBC;
 end;   }

  strprice:='0.00';
  PrdVCode:=0;
  vPDF417:='';
  result:=false;
  flAlcGoods:=false;
  { formstart.AutoUpdateGoods}
  Query:='SELECT `barcodes`,`currentprice` FROM `sprgoods` WHERE `plu`="'+aBC1+'" AND `alcgoods`="+" AND (`weightgood`<>"1" AND `weightgood`<>"+");';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    flAlcGoods:=true;
    fplu:=trim(xrowbuf[0]);
    strprice:=trim(xrowbuf[1]);
    FRBeep;
    formShowMessage.Show('Алкогольный товар продовать по коду нельзя!');
    //FRBeep;
    result:=false;
    exit;
  end;
   Query:='SELECT `extcode`,`currentprice`,`name`,'+
          ''''','+
          ''''','
          +''''',`sprgoods`.`name`,`sprgoods`.`barcodes`,COUNT(*) AS `countline`, `freeprice`,`section`,(SELECT `unpacked` FROM `spproduct` WHERE `spproduct`.`alccode`=`extcode`) AS `unpack`, `groupid`  FROM `sprgoods` WHERE `plu`='''+aBC1+''' AND `alcgoods`<>''+''  GROUP BY `barcodes`;';
   xrecbuf:= formStart.DB_query(Query);
   xrowbuf:=formStart.DB_Next(xrecbuf);
   if  xrowbuf<>nil then
     begin
        strprice := format('%8.2f',[formstart.StrToFloat(xrowbuf[1])]);
         if xrowbuf[9]='+' then begin
            forminputprice.flPrice:=strprice;
            forminputprice.flName:=xrowbuf[6];
            forminputprice.flAlcCode:=xrowbuf[7];
            forminputprice.flAlcVolume:='-';
            forminputprice.flbarCode:='';
            forminputprice.flPLU:=aBC1;
            forminputprice.flCapacity:='-';

            forminputprice.flReturn:=not flCheckSales;
            if  not forminputprice.getPrice() then begin
               exit;
            end;
            strprice:=forminputprice.flPrice;
          end;
        // === Рассчитываем цену с округлением ===

        rPrice1:= StrToFloat(trim(strprice));
        rQual:= strtoFloat(aCount)*0.001;
        rSumm1:= rPrice1*rQual;  // === Сумма без скидок
        rSumm2:=Round(rSumm1*100)/100;  // == Округление в большую сторону
        rDisc1:=0;


        CurLine:=CurLine+1;
        StringGrid1.RowCount:=CurLine+1;
        Stringgrid1.Rows[curLine].Clear;
        Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
        Stringgrid1.Rows[curLine].Add(aBC1);
        Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
        Stringgrid1.Rows[curLine].Add(trim(format('%0.2f',[rPrice1])));
        Stringgrid1.Rows[curLine].Add(trim(format('%3.3f',[rQual])));
        Stringgrid1.Rows[curLine].Add(trim(format('%8.2f',[rSumm2])));
        Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
        Stringgrid1.Rows[curLine].Add('');
        Stringgrid1.Rows[curLine].Add(vPDF417);
        Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
        Stringgrid1.Rows[curLine].Add('0');
        Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
        Stringgrid1.Rows[curLine].Add(xrowbuf[0]);
        Stringgrid1.Rows[curLine].Add('0');
        StringGrid1.Cells[17,curLine]:=flProcentCard;
        Stringgrid1.Cells[13,curLine]:='0';
        Stringgrid1.Cells[15,curLine]:= GetSectionForGood(xrowbuf[10]);
        Stringgrid1.Cells[13,curLine]:= floattostr(rDisc1);
        result:=true;
     end else begin
        FRBeep;
        FormShowMessage.Show('Не найден товар с кодом:'+aBC1);
        result:=false;
     //showmessage('надо сопоставить товар!');
    end;

 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
 // >>>>>>>>>> Пересчет итогов <<<<<<<<<<<<<<<
 for ii:=1 to curline do
    stringgrid1.Cells[0,ii]:=inttostr(ii);
 // ========== пересчитываем сумму =======================
 if flselrow>0 then begin
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
 end;
 // ====
 self.flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    self.flAllSumma:=self.flAllSumma+ RoundRub(formstart.StrToFloat(trim(StringGrid1.Cells[5,ii])),100) ;
 end;
 // ====
 stSumma.Caption:=format('СУММА: %8.2f',[self.flallsumma]);
 flallsumma:=strToFloat(trim(format('%8.2f',[self.flallsumma])));
 SetTypeDocCapture(TRUE);
end;

function TFormSalesBeerTS.addBarcode(aBC:String):boolean;
var
  flExtCode:String;
  Query:string;
  PrdVCode:integer;
  vPDF417,vAlcCode,aPart,aSerial:string;
  strPrice:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  fplu:string;
  rSection:string;
begin
  self.flOpenDoc:=true;
  DefaultFormatSettings.DecimalSeparator:='.';
  strprice:='0.00';
  PrdVCode:=0;
  vPDF417:='';
  result:=false;
  // ==== получим по ШК статус алкоголь =====
  flAlcGoods:=false;
  { formstart.AutoUpdateGoods}
  Query:='SELECT `plu`,`currentprice`,`section`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+aBC+'" AND `alcgoods`="+" LIMIT 1;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    flAlcGoods:=true;
    fplu:=xrowbuf[0];
    strprice:=xrowbuf[1];
    flExtCode:= xrowbuf[3]
 {   if length(flExtCode )<15  then
      formStart.DB_query('UPDATE  `plu`,`currentprice`,`section`,`extcode` FROM  WHERE `barcodes`="'+aBC+'" AND `alcgoods`="+" AND `extcode`="'=flExtCode+'" LIMIT 1;');    }
  end;
  // ========================================

  Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
         '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
         '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
         +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`, `freeprice`,`section`,`groupid`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `extcode`<>'''' GROUP BY `barcodes`;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
   begin

     fplu:=xrowbuf[7];
     if xrowbuf[4]<>'' then begin
      PrdVCode:=StrToInt(xrowbuf[4]) ;


     if not thisBeer(xrowbuf[4]) then
      begin
        formsetpdf417.flName:=xrowbuf[2];
        if length(xrowbuf[0])>15 then
        formsetpdf417.flAlcCode:=trim(xrowbuf[0])
        else
         formsetpdf417.flAlcCode:='';
        formsetpdf417.flAlcVolume:=xrowbuf[3];
        formsetpdf417.flbarCode:=aBC;
        formsetpdf417.flCapacity:=xrowbuf[5];
        formsetpdf417.flReturn:=not flCheckSales;
        if formsetpdf417.getpdf417() then
         begin

             vPDF417:=formsetpdf417.flPDF417;
             if controlpdf417(vPDF417) then begin
               FRBeep;
               formShowMessage.Show('Данная марка уже добавлена в ЧЕК!');
               exit;
             end;
             formStart.DecodeEGAISPlomb(vPDF417,vAlcCode,aPart,aSerial);
             if vAlcCode='' then begin
               FRBeep;
               formShowMessage.Show('Нет данных по данному алкоголю, пожалуйста исправте в справочнике товара!');
               exit;
             end;
             if vAlcCode<> trim(xrowbuf[0]) then
              begin
               if (formstart.flRMKOffline) then begin

                 query:='INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`) VALUES ('
                 +''''+fplu+''','''+xrowbuf[6]+''','''+xrowbuf[2]+''','''+xrowbuf[1]+''',''+'','''+fplu+''','''+trim(aBC)+''','''','''+vAlcCode+''',''+'');';
                 formstart.DB_query(Query);
               end else begin
                FRBeep;
                 formShowMessage.Show('Данный товар не соответствует акцизной марке, проверьте данные в справочнике товара!');
               // formStart.DB_query('UPDATE `sprgoods` SET `extcode`="'+vAlcCode+'",`updating`="+",`alcgoods`="+" WHERE `barcodes`="'+aBC+'";');
                 exit;

               end;
              end;
              forminputprice.flPrice:=xrowbuf[1];
              forminputprice.flName:=xrowbuf[2];
              forminputprice.flAlcCode:=trim(xrowbuf[0]);
              forminputprice.flAlcVolume:=xrowbuf[3];
              forminputprice.flbarCode:=aBC;
              forminputprice.flplu:='';
              forminputprice.flCapacity:=xrowbuf[5];
              forminputprice.flReturn:=not flCheckSales;
              if (not formstart.flRMKOffline) then begin
                if flCheckSales then begin
                  if  not forminputprice.getPrice() then
                   exit;
                end;
              end;
             strprice:=forminputprice.flPrice;
           end
          else
           exit;
        end
       else
        begin
          // ==== это пиво
          if xrowbuf[8]<>'1' then
            begin
              FormSelectProd.sBarCode:= aBC;
              if FormSelectProd.ShowModal <> 1377 then
                 exit;
              vAlcCode:=FormSelectProd.sAlcCode
            end else
              vAlcCode:= trim(xrowbuf[0]);
          forminputprice.flPrice:=xrowbuf[1];
          forminputprice.flName:=xrowbuf[2];
          forminputprice.flAlcCode:=trim(xrowbuf[0]);
          forminputprice.flAlcVolume:=xrowbuf[3];
          forminputprice.flbarCode:=aBC;
          forminputprice.flplu:='';
          forminputprice.flCapacity:=xrowbuf[5];
          forminputprice.flReturn:=not flCheckSales;
          if (not formstart.flRMKOffline) then begin
            if  not forminputprice.getPrice() then
             exit;
          end;
          strprice:=forminputprice.flPrice;
        end;
         strprice := format('%8.2f',[formstart.StrToFloat(strprice)]);
         CurLine:=CurLine+1;
         StringGrid1.RowCount:=CurLine+1;
         Stringgrid1.Rows[curLine].Clear;
         Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
         Stringgrid1.Rows[curLine].Add(fplu);
         Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add('1');
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add(aBC);
         Stringgrid1.Rows[curLine].Add('');
         Stringgrid1.Rows[curLine].Add(vPDF417);
         Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[4]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
         Stringgrid1.Rows[curLine].Add(vAlcCode);
         Stringgrid1.Rows[curLine].Add('0');
         Stringgrid1.Cells[13,curLine]:='0';
         StringGrid1.Cells[17,curLine]:=flProcentCard;
         Stringgrid1.Cells[15,curLine]:= GetSectionForGood(xrowbuf[10]);
      end else begin
         if (flAlcGoods)and(not formstart.fldisableutm) then begin
             FRBeep;
             formShowMessage.Show('Товар указан как "Алкоголь", но нет всех данный. Надо обновить остатки из ЕГАИС.');
           end;
         strprice := trim(format('%8.2f',[formstart.StrToFloat(xrowbuf[1])]));
         // >>> Обработаем ввод цены для обычного товара <<<
         if xrowbuf[9]='+' then begin
              forminputprice.flPrice:=strprice;
              forminputprice.flName:=xrowbuf[6];
              forminputprice.flAlcCode:=xrowbuf[7];
              forminputprice.flAlcVolume:='-';
              forminputprice.flbarCode:=aBC;
              forminputprice.flplu:='';
              forminputprice.flCapacity:='-';
              forminputprice.flReturn:=not flCheckSales;
              if (not formstart.flRMKOffline) then begin
                if  not forminputprice.getPrice() then
                 exit;
              end;
              strprice:=forminputprice.flPrice;
            end;
         CurLine:=CurLine+1;
         StringGrid1.RowCount:=CurLine+1;
         Stringgrid1.Rows[curLine].Clear;
         Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
         Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add('1');
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add(aBC);
         Stringgrid1.Rows[curLine].Add('');
         Stringgrid1.Rows[curLine].Add(vPDF417);
         Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
         Stringgrid1.Rows[curLine].Add('0');
         Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
         Stringgrid1.Rows[curLine].Add(vAlcCode);
         Stringgrid1.Rows[curLine].Add('0');
         Stringgrid1.Cells[13,curLine]:='0';
         StringGrid1.Cells[17,curLine]:=flProcentCard;
         Stringgrid1.Cells[15,curLine]:= GetSectionForGood(xrowbuf[10]);
      end;
     result:=true;
   end
  else begin  // ==== Не найден товар  ========  или не алкогольный товар =====
    if formStart.flRMKOffline then begin  // === в ккм оффлайне сопоставим только алк товар
      if flAlcGoods then begin
        if formaddbarcode.AddBarCode(abc) then
          result:=addBarcode(aBC)
        else   result:=false;
        exit;
        end else begin
          Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
                  '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
                  '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
                  +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`,`freeprice`,`section`, `groupid`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `alcgoods`<>''+'' GROUP BY `barcodes`;';
           xrecbuf:= formStart.DB_query(Query);
           xrowbuf:=formStart.DB_Next(xrecbuf);
           if  xrowbuf<>nil then   // === Ищем не алкогольный товар
                 begin
                    strprice := trim(format('%.2f',[formstart.StrToFloat(xrowbuf[1])]));
                   if xrowbuf[9]='+' then begin
                        forminputprice.flPrice:=strprice;
                        forminputprice.flName:=xrowbuf[6];
                        forminputprice.flAlcCode:=xrowbuf[7];
                        forminputprice.flAlcVolume:='-';
                        forminputprice.flbarCode:=aBC;
                        forminputprice.flplu:='';
                        forminputprice.flCapacity:='-';
                        forminputprice.flReturn:=not flCheckSales;
                        if  not forminputprice.getPrice() then begin
                           exit;
                        end;
                        strprice:=forminputprice.flPrice;
                      end;
                    CurLine:=CurLine+1;
                    StringGrid1.RowCount:=CurLine+1;
                    Stringgrid1.Rows[curLine].Clear;
                    Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
                    Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
                    Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
                    Stringgrid1.Rows[curLine].Add(strprice);
                    Stringgrid1.Rows[curLine].Add('1');
                    Stringgrid1.Rows[curLine].Add(strprice);
                    Stringgrid1.Rows[curLine].Add(aBC);
                    Stringgrid1.Rows[curLine].Add('');
                    Stringgrid1.Rows[curLine].Add(vPDF417);
                    Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
                    Stringgrid1.Rows[curLine].Add('0');
                    Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
                    Stringgrid1.Rows[curLine].Add('');
                    Stringgrid1.Rows[curLine].Add('0');
                    Stringgrid1.Cells[13,curLine]:='0';
                    StringGrid1.Cells[17,curLine]:=flProcentCard;
                    Stringgrid1.Cells[15,curLine]:= GetSectionForGood(xrowbuf[10]);
                 end else  begin
                    result:=false;
                    FRBeep;
                    FormShowMessage.Show('Не найден товар со штрихкодом: '+aBC);
                    result:=false;
                    exit;
             //showmessage('надо сопоставить товар!');
                end;
      end;
    end else  /// ==== в обычной кассе это может как алк так обычный
    begin
      Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
             '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
             '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
             +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`,`freeprice`,`sprgoods`.`section`,`groupid`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `alcgoods`<>''+'' GROUP BY `barcodes`;';
      xrecbuf:= formStart.DB_query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if  xrowbuf<>nil then   // === Ищем не алкогольный товар
            begin
               strprice := trim(format('%.2f',[formstart.StrToFloat(xrowbuf[1])]));
              if xrowbuf[9]='+' then begin
                   forminputprice.flPrice:=strprice;
                   forminputprice.flName:=xrowbuf[6];
                   forminputprice.flAlcCode:=xrowbuf[7];
                   forminputprice.flAlcVolume:='-';
                   forminputprice.flbarCode:=aBC;
                   forminputprice.flplu:='';
                   forminputprice.flCapacity:='-';
                   forminputprice.flReturn:=not flCheckSales;
                   if  not forminputprice.getPrice() then begin
                      exit;
                   end;
                   strprice:=forminputprice.flPrice;
                 end;
               CurLine:=CurLine+1;
               StringGrid1.RowCount:=CurLine+1;
               Stringgrid1.Rows[curLine].Clear;
               Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
               Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
               Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
               Stringgrid1.Rows[curLine].Add(strprice);
               Stringgrid1.Rows[curLine].Add('1');
               Stringgrid1.Rows[curLine].Add(strprice);
               Stringgrid1.Rows[curLine].Add(aBC);
               Stringgrid1.Rows[curLine].Add('');
               Stringgrid1.Rows[curLine].Add(vPDF417);
               Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
               Stringgrid1.Rows[curLine].Add('0');
               Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
               Stringgrid1.Rows[curLine].Add('');
               Stringgrid1.Rows[curLine].Add('0');
               Stringgrid1.Cells[15,curLine]:= GetSectionForGood(xrowbuf[10]);
               StringGrid1.Cells[17,curLine]:=flProcentCard;
               StringGrid1.Cells[13,curLine]:='0';
            end else begin  // === не нашли значит сопоставляем с алкоголем ===
              if formaddbarcode.AddBarCode(abc) then
                result:=addBarcode(aBC)
              else begin
               result:=false;
               FRBeep;
               FormShowMessage.Show('Не найден товар со штрихкодом: '+aBC);
               result:=false;
               exit;
              end;
        //showmessage('надо сопоставить товар!');
           end;


    end;

  end;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
end;


{  перенесли в unitdevices
function getshiftcash():string;
var                // вычисляем смену количество дней прошедших от 2016-01-01
 year,month,day:word;
begin
 year:=0;
 month:=0;
 day:=0;
 DecodeDate(now(),year,month,day);
 year:=year-2016;
 result:=inttostr( year*12*32+month*32+day);
end;                       }


{
  // Изменения от 24.07.2018 Уфандеев Евгений Владимирович
  Требования: секции должны быть заполнены не ниже 0
  Алгоритм:
  перед входом проверяем условия: ККМ - на связи, УТМ - на связи
  1. Выбираем тип оплаты банк или наличными
  2. При банковской оплате проводим через банк
  3. Если Ошибка банка возвращаемся к пп 1.
  4. Если ошибка при печате отменяем банк и возвращаемся к пп 1
  5. проводим через ЕГАИС - ошибка? отменяем банк и возвращаемся на пп 1
  6. Проводим через ККМ - Ошибка? просим устранить или отменяем банк, возвращаем из ЕГАИС и возвращаемся на пп 1

}
function TFormSalesBeerTS.addPositionEGAIS(idDep:integer; aBank:boolean):boolean;
const
  xbit:array[0..7] of byte=(1,2,4,8,16,32,64,128);
var
  //bm:TBitmap;

  xx,yy:integer;
  buf:string;
  //qrpm: TDelphiZXingQRCode;
  bt:byte;
  i:integer;
  ii:integer;
  url:string;
  aStr,
  str1:string;
  strbc:string;
  strpdf417:string;
  strprice:string;
  //lists:TstringList;
  flcloseCH:boolean;
  strvolume:string;
  strnumber:string;
  flalccheck:boolean;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  sign:String;
  part,ser:string;
  alccode:String;
  ikkmnum:integer;
  strkkm:string;
  flclear:boolean;
  flcount,strenable:string;
  flreturn:boolean;
  strNumCheck:string;
  strerror:string;
  lists:TStringList;
  EGAISEnabled:boolean;
  fltranst:string;
  //flAddBeerToCheck:boolean;
  NumDep:integer;
begin
 result:=true;
 flAddBeerToCheck:= not db_boolean(FormStart.GetConstant('autoactwritebeer'));
 strNumCheck:=inttostr(flNumCheck);
 DefaultFormatSettings.DecimalSeparator:='.';


  // === Модификация по кассам =====
  EGAISEnabled:=false;


  // ====
  FormShowStatus.Panel1.Caption:='Передаем в ЕГАИС!';
  FormShowStatus.Show;
  Application.ProcessMessages;
  // ====
  lists:=TStringList.create();
  strNumCheck:=inttostr(flNumCheck);
  DefaultFormatSettings.DecimalSeparator:='.';
  // ===================

  EGAISEnabled:=false;
  if flCheckSales then begin
    flcount:='';
    fltranst:='11';
    end
  else begin
    flcount:='-';
    fltranst:='13';
    end;
       // в в буфере есть позиции которые надо закрыть
   if (StringGrid1.RowCount>1) then begin
        strNumCheck:=inttostr(flNumCheck);
        lists.Clear;
        lists.Add('<?xml version="1.0" encoding="UTF-8"?>');
        lists.Add('<Cheque');
        lists.Add('inn="'+formStart.FirmINN+'"');
        lists.Add('datetime="'+FormatDateTime('DDMMYYhhmm',now())+'"');
        lists.Add('kpp="'+formStart.firmKPP+'"');
        lists.Add('kassa="'+formStart.prefixClient+'"');
        lists.Add('address="'+replaceStr(formStart.FirmAddress,false)+'"');
        lists.Add('name="'+replaceStr(formStart.FirmFullName,false)+'"');
        lists.Add('number="'+strNumCheck+'"');
        lists.Add('shift="'+getshiftcash()+'"');
        lists.Add('>');
        for ii:=1 to StringGrid1.RowCount-1 do
          if ((trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0'))and(not formStart.fldisableutm) then begin
           //EGAISEnabled:=true;

           if thisBeer(StringGrid1.Cells[10,ii]) then begin
                 // ==== это пиво
              if flAddBeerToCheck then begin
               EGAISEnabled:=true;
               lists.Add('<nopdf code="'+StringGrid1.Cells[10,ii]+'" bname="'+trim(ReplaceStr(StringGrid1.Cells[2,ii],false))+'" volume="'+trim(StringGrid1.Cells[9,ii])+'" alc="'+trim(StringGrid1.Cells[11,ii])+'" price="'+flcount+trim(StringGrid1.Cells[3,ii])+'" ean="'+trim(StringGrid1.Cells[6,ii])+'" count="'+trim(StringGrid1.Cells[4,ii])+'" />')

                end;

             end
            else begin
             EGAISEnabled:=true;
             lists.Add('<Bottle barcode="'+trim(StringGrid1.Cells[8,ii])+'" ean="'+trim(StringGrid1.Cells[6,ii])+'" price="'+flcount+trim(StringGrid1.Cells[3,ii])+'" volume="'+trim(StringGrid1.Cells[9,ii])+'"  />');
            end;
           end ;
        lists.Add('</Cheque>');
        if formStart.flDemoMode  then begin
          url:='http://egais.retailika.ru/';
          sign:='HTTP://EGAIS.RETAILIKA.RU/0123456789EGAISRETAILIKARU0123456789EGAISRETAILIKARU'+
                '0123456789EGAISRETAILIKARU0123456789EGAISRETAILIKARU0123456789';

         end else
         begin
            url:='';
            sign:='';
            strerror:='';
            if EGAISEnabled then begin
              aStr:= formStart.SaveToServerPOST('xml',lists.Text) ;  // отправляем в егаис и ждем ответа
              // Проверяем тип ответа правильный ответ должен содержать url все остальное ошибка
              //lists.add(aStr);
              url:='';
              sign:='';
              strerror:='';
              if length(aStr)<>0 then // == получен ответ от егаис =====
              begin
                S:= TStringStream.Create(aStr);
                Try
                  S.Position:=0;
                // Обрабатываем полученный файл
                  XML:=Nil;
                  ReadXMLFile(XML,S); // XML документ целиком
                Finally
                  S.Free;
                end;
                Child :=XML.DocumentElement.FirstChild;
                while Assigned(Child) do begin

                  if Child.NodeName = 'url' then begin
                     url:=Child.FirstChild.NodeValue;
                  end;
                  if Child.NodeName = 'sign' then begin
                     sign:=Child.FirstChild.NodeValue;
                  end;
                   if Child.NodeName = 'error' then begin
                     strerror:=Child.FirstChild.NodeValue;
                  end;
                  Child:=Child.NextSibling;
                end;
              end;

            end ;
         end;

        SummCheck.egaissign:=sign;
        SummCheck.egaisurl:=url;
        // ====== тестовое сообщение ========
        // если в ответе нет ссылки то url будет пуст
        if url<>'' then  begin  // пришел URL обрабатывае как положено
            addtrans(formStart.prefixClient,strNumCheck,'240','0','1',floattostr(self.flallsumma),floattostr(self.flallsumma),'',sign,url);
            FormStart.DB_query('UPDATE `doccash` SET `noclosecheck`="-" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

            formStart.SetConstant('LastNumCheck',strNumCheck);
            if not printURL(url,sign) then begin
               FRBeep;
               formShowMessage.Show('Товар зафиксироват в системе ЕГАИС! Но невозможно распечатать ссылку!');
               lists.free;
               lists:=nil;
               FormShowStatus.Hide;
              end;

         end else begin  // == иначе фиксируем ошибку в журнале
           result:=false;
           if (EGAISEnabled)and(not formstart.fldisableutm) then begin
            FormStart.DB_query('UPDATE `doccash` SET `noclosecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

             // ====== не удаляем товар пока не будет ясно что с ним!!! =====
            addtrans(formStart.prefixClient,strnumber,'240','0','1','0','0','',sign,aStr);
            formStart.SetConstant('LastNumCheck',strNumCheck);
            FRBeep;
            FormShowMessage.Show('Ошибка при передаче данных в ЕГАИС! Отложите товар до разбирательств!');
           end;

        end;
    end;

   if not (lists = nil) then
      lists.free;


end;

function TFormSalesBeerTS.addtrans(
                  aKassaHW,
                  aNumCheck,
                  aTrans,
                  aPLU,
                  aCount,
                  aPrice,
                  aSumm,
                  aBarCode,
                  alccode,
                  aPDF417:String;
                  aName:string = '';
                  aRegFR:boolean=true;
                  aSection:string='';
                  aBanking:Boolean=false;
                  aIdTable:String='0'):boolean;
var
  Query:String;
 sRegFR:string;
 sBanking:string;
begin
  sRegFR:='';
  sBanking:='-';
  if aBanking then
     sBanking:='+';
  if aRegFR then
    sRegFR:='+';
  if aKassaHW='' then
   aKassaHW:='1';
  query:='INSERT INTO `doccash` (`numtrans`,`datetrans`,`numcheck`,`kassir`,`typetrans`,`plu`,`price`,`quantity`,`summ`,`urlegais`,`alccode`,`numdoc`,`datedoc`,`eanbc`,`name`,`regfr`,`numsection`,`numkass`,`namesection`,`numhw`,`fullname`,`banking`,`idtable`,`closecheck`,`storepoint`,`regegais`,`noclosecheck`)'+
         ' VALUES (1,now(),'+aNumCheck+','+aKassaHW+','+aTrans+','+aPLU+','+aPrice+','+aCount+','+aSumm+','''+aPDF417+''','''+alccode+''','''+inttostr(flNumCheck)+''','''+FormatDateTime('YYYY-MM-DD',now())+''','''+aBarCode+''','''+ansitoutf8(replaceStr(utf8toansi(aName)))+''','''+sRegFR+''','''+aSection+''','''+formStart.prefixClient+''','''','+aKassaHW+','''+ansitoutf8(replaceStr(utf8toansi(aName)))+''','''+sBanking+''','''+aIdTable+''','''','''','''','''') ;';
  formStart.DB_Query(Query);
  result:=true;
end;

function TFormSalesBeerTS.getvolumebc(abc:string):string;

begin
  result:='';

  FormStart.rowbuf:=  FormStart.DB_Next(FormStart.DB_Query('SELECT `AlcVolume` FROM `spproduct` WHERE `AlcCode`="'+abc+'" ;')) ;
  if FormStart.rowbuf<>nil then
    result:=FormStart.rowbuf[0]
   else begin
    FRBeep;
    FormShowMessage.Show('Нет данных о товаре, пожалуйста получите сведения из системы ЕГАИС!');
   end;
end;

function TFormSalesBeerTS.controlpdf417(aPDF417:string):boolean;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  result:=false;
  for ares:=1 to StringGrid1.RowCount-1 do
     if trim(StringGrid1.Cells[8,ares])=aPDF417 then
     begin
       result:=true;
       exit;
     end;

end;

procedure TFormSalesBeerTS.BitBtn2Click(Sender: TObject);
begin
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\tovcheck.lrf');
 indCheck:=1;
 frReport1.ShowReport;

end;

{Кнопка "Оплата/Возврат"}
// === оплата/возврат  чека
procedure TFormSalesBeerTS.BitBtn1Click(Sender: TObject);
begin
    trans_check(false);
end;

procedure TFormSalesBeerTS.trans_check(bankOnly:boolean);
var
  timerStop:boolean;
  //depEGAIS:integer; // === номер секции по которому печатается qr-код егаис
  aBank:boolean;
  strNumCheck:string;
  str1:string;
  ii:integer;
  i:integer;
  flcount:string;
  fltranst:string;
  resTransEGAIS:boolean;
  aTransEGAIS:boolean; // = флаг определяет что будет или была транзакция по егаис
  aNoError:boolean;
  __trans : boolean ; // Флаг удачного проведения оплаты
begin
  if flg_view_only then Begin
     ShowMessage('В данном режиме продажа запрещена!');
     exit;
  end;

  flAddBeerToCheck:= not db_boolean(FormStart.GetConstant('autoactwritebeer'));
  SummCheck.egaisurl := '';
  SummCheck.egaissign := '';
  timerStop:=formstart.Timer1.Enabled;
  formstart.Timer1.Enabled:=false;
  strNumCheck:=inttostr(flNumCheck);
  // ==== Предварительно очищаем чеки =====
  FormStart.DB_query('DELETE FROM `doccash`  WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');
  // ==== Проверяем доступ к УТМ ======
  aTransEGAIS:=false;
  if not formstart.fldisableutm then begin
    // == есть ли товар для егаис?
     for ii:=1 to StringGrid1.RowCount-1 do begin
       if ((trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0')) then begin
         if thisBeer(StringGrid1.Cells[10,ii]) then begin
            if flAddBeerToCheck then begin  // штучное пиво проводим через чек?
              aTransEGAIS:=true;
            end;
         end else
           aTransEGAIS:=true;
       end;
     end;
     if aTransEGAIS then begin  // в случае проведения товара через егаис - проверим связь с УТМ!
      str1:=formStart.SaveToServerGET('','');
      if str1='' then
        begin
          FRBeep;
          FormShowMessage.Show('Нет связи с УТМ!');
          exit;
        end;
      end;
     end;
  SummCheck.AllSumm:=GetSummDep();

  // ===== фиксируем в БД
  if flCheckSales then begin
    flcount:='';
    fltranst:='11';
    end
  else begin
    flcount:='-';
    fltranst:='13';
    end;
  for ii:=1 to StringGrid1.RowCount-1 do
     begin
       if ((trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0'))and(not formStart.fldisableutm) then begin
        if thisBeer(StringGrid1.Cells[10,ii]) then begin
           addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),'',trim(StringGrid1.Cells[2,ii]),true,trim(StringGrid1.Cells[15,ii]));

         end  else begin
          addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+'1',trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),trim(StringGrid1.Cells[8,ii]),trim(StringGrid1.Cells[2,ii]),true,trim(StringGrid1.Cells[15,ii]));
         end;
        end else
          addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[1,ii]),'',trim(StringGrid1.Cells[2,ii]),true,trim(StringGrid1.Cells[15,ii]));

     end;
  {Отсюда запускаем методы ввода типов оплат и корректность проводки }
  aNoError:=true;
  repeat
    formInputSumm.flCheckSales:=flCheckSales;
    // ======= Запрашиваем ввод вида оплаты =============
    flInpSumm:= self.flAllSumma;
    if bankonly then
        __trans := FormInputSumm.TransBank(flInpSumm)
    else
        __trans := FormInputSumm.InputSumm(flInpSumm);
    if __trans then begin  // надо перепроверить flInpSumm
      // ======= проводим в ЕГАИС =========================
      resTransEGAIS:=false;

      if aTransEGAIS then begin
        resTransEGAIS:=addPositionEGAIS(fldepEGAIS,aBank);
        if resTransEGAIS then
          aNoError:=true;
      end;
      if FormInputSumm.fl_not_print then
        self.set_not_print(true);
      // ======= проводим через ККМ =======================
      if (resTransEGAIS)and(aNoError) then  begin  // пришел URL обрабатывае как положено
          FormStart.DB_query('UPDATE `doccash` SET `noclosecheck`="-" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');
            if not self.closecheck() then begin
               FRBeep;
               aNoError:=false;
               FormStart.DB_query('UPDATE `doccash` SET `closecheck`="-" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'" AND `numsection`="'+inttostr(ii)+'";');

            end else
                FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'" `numsection`="'+inttostr(ii)+'";');

          formStart.SetConstant('LastNumCheck',strNumCheck);

      end else begin  // == иначе фиксируем ошибку в журнале

         if (resTransEGAIS) then begin
          FormStart.DB_query('UPDATE `doccash` SET `noclosecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

           // ====== не удаляем товар пока не будет ясно что с ним!!! =====
          addtrans(formStart.prefixClient,strNumCheck,'240','0','1','0','0','',SummCheck.egaissign,SummCheck.egaisurl);
          formStart.SetConstant('LastNumCheck',strNumCheck);
          FRBeep;
          FormShowMessage.Show('Ошибка при передаче данных в ЕГАИС! Отложите товар до разбирательств!');
         end else
          begin  // ==== Это обычный товар =====
            if (SummCheck.AllSumm<>0 ) then begin
             if self.closecheck() then
              addtrans(formStart.prefixClient,strNumCheck,'40','0','1',floattostr(self.flallsumma),floattostr(self.flallsumma),'',SummCheck.egaissign,SummCheck.egaisurl,'',true,inttostr(ii));
              FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'" AND `numsection`="'+inttostr(ii)+'";');
             end else
              FormStart.DB_query('UPDATE `doccash` SET `closecheck`="-" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'" AND `numsection`="'+inttostr(ii)+'";');
           formStart.SetConstant('LastNumCheck',strNumCheck);

          end;
      end;
    // ==================================================

    End else
      begin
         FormShowStatus.Hide;
         formstart.Timer1.Enabled:=timerstop;
         exit;
      end;
  until aNoError;
  // ======= Закрываем чек в БД =======================
  formStart.SetConstant('LastNumCheck',strNumCheck);
  inc(flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис
  clearcheck();
  //clearcheck();
  flInpSumm:=0;
  FormShowStatus.Hide;
  formstart.Timer1.Enabled:=timerstop;
end;

procedure TFormSalesBeerTS.BitBtn20Click(Sender: TObject);
begin
  GetReport();
end;

procedure TFormSalesBeerTS.bbBlockScreenClick(Sender: TObject);
var
  res:string;
begin
 formuserloginv2.flCurPass:='';
 formuserloginv2.flCurCard:='';
 formuserloginv2.flTypeInterface:='';
 formuserloginv2.staticText1.Caption:='';
 formuserloginv2.bitbtn13.Enabled:=false;
 res:=formuserloginv2.AuthUser();  ;
 if res<>'' then
   formstart.flCurUserId:=res;
 formuserloginv2.bitbtn13.Enabled:=true;
 flCurUserName:=formspusers.GetPolice(formstart.flCurUserId).fullname;
 application.ProcessMessages;
end;

procedure TFormSalesBeerTS.bbDeferredCheckClick(Sender: TObject);
var
  ii,
  i:integer;
  ind1:integer;
begin
  ind1:=0;
  while (ind1<3) and (arrCountDeferredCheck[ind1]<>0) do
    ind1:=ind1+1;
  if ind1>=3 then
   begin
     FRBeep;
     ShowMessage('Нельзя больше откладывать чеки.');
     exit;
   end;
  for i:=1 to stringgrid1.RowCount - 1 do begin
    for ii:=1 to 17 do begin
      arrDeferredCheck[arrCountDeferredCheck[ind1],ii,ind1]:= Stringgrid1.Cells[ii,i];
    end;
    arrCountDeferredCheck[ind1]:=arrCountDeferredCheck[ind1]+1;
  end;
  if ind1 = 0 then begin
   bbRetDeferredCheck1.visible:=true;
   bbRetDeferredCheck1.Caption:='Чек ('+format('%8.2f',[self.flallsumma])+')';
  end;
  if ind1 = 1 then
   begin
      bbRetDeferredCheck2.visible:=true;
      bbRetDeferredCheck2.Caption:='Чек ('+format('%8.2f',[self.flallsumma])+')';
     end;
  if ind1 = 2 then
   begin
      bbRetDeferredCheck3.visible:=true;
      bbRetDeferredCheck3.Caption:='Чек ('+format('%8.2f',[self.flallsumma])+')';
     end;

  ClearCheck();
 // pnlSetDeferredCheck.Visible:=true;
end;

procedure TFormSalesBeerTS.bbExitClick(Sender: TObject);
begin
  if formspusers.GetPolice(formstart.flCurUserId).cancelcheck then  begin
   if FormShowMessage.ShowYesNo('Будет отменен чек, продолжить?') and flOpenDoc  then
    close()
   else
    close();
  end
  else begin
    if flOpenDoc then
        FormShowMessage.Show('Открыт чек, у вас нет прав на отмену чека.')
      else
       begin
        if FormShowMessage.ShowYesNo('Выйти из регистрации?') then
           close();
       end;
  end;

end;

procedure TFormSalesBeerTS.bbNextServiceClick(Sender: TObject);
begin
  //if pnlFastGoods.Visible then begin
    pnlService.Visible:=false;
    pnlService1.Visible:=true;
    bitbtn3.Caption:='';
    pnlSprGoods.Visible:=false;
  //end else begin
  //  pnlFastGoods.Visible:=true;
  //  pnlService.Visible:=false;
  //  bitbtn3.Caption:='Сервис [F1]';
  //end;
end;

procedure TFormSalesBeerTS.bbViplataClick(Sender: TObject);
begin
  CashOutcome();
end;

procedure TFormSalesBeerTS.bbVnestiClick(Sender: TObject);
begin
  CashIncome();
end;

procedure TFormSalesBeerTS.bbRetDeferredCheckClick(Sender: TObject);
begin
 if formspusers.GetPolice(formstart.flCurUserId).deferredcheck then
    pnlretDeferredCheck.Visible:=not pnlretDeferredCheck.Visible
    else begin
      FRBeep;
     FormShowMessage.Show('Недостаточно прав!');
   end;
end;

procedure TFormSalesBeerTS.bbDeferredCheck1Click(Sender: TObject);
var
  ii,
  i:integer;
begin
  ArrCountDeferredCheck[0]:=0;
  for i:=1 to stringgrid1.RowCount - 1 do begin
    for ii:=1 to 17 do begin
      arrDeferredCheck[ArrCountDeferredCheck[0],ii,0]:= Stringgrid1.Cells[ii,i];
    end;
    ArrCountDeferredCheck[0]:=ArrCountDeferredCheck[0]+1;
  end;
  ClearCheck();

  pnlretDeferredCheck.Visible:=false;
  pnlSetDeferredCheck.Visible:=false;
end;

procedure TFormSalesBeerTS.bbRetDeferredCheck1Click(Sender: TObject);
var
  i,ii:integer;
begin
 Stringgrid1.RowCount:=ArrCountDeferredCheck[0]+1;
 for i:=0 to ArrCountDeferredCheck[0]-1 do
   begin
     for ii:=1 to 17 do begin
        Stringgrid1.Cells[ii,i+1]:=arrDeferredCheck[i,ii,0];
     end;
   end;
 ArrCountDeferredCheck[0]:=0;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
 pnlretDeferredCheck.Visible:=false;
 pnlSetDeferredCheck.Visible:=false;
 bbRetDeferredCheck1.visible:=false;
 // >>>>>>>>>> Пересчет итогов <<<<<<<<<<<<<<<
 for ii:=1 to curline do
    stringgrid1.Cells[0,ii]:=inttostr(ii);
 // ========== пересчитываем сумму =======================
 if flselrow>0 then begin
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
 end;
 self.flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    self.flAllSumma:=self.flAllSumma+ RoundRub(StrToFloat(trim(StringGrid1.Cells[5,ii])),100) ;
 end;
 CurLine:= flSelRow;

 stSumma.Caption:=format('СУММА: %8.2f',[self.flallsumma]);

 GetAllSumm;
 SetTypeDocCapture(TRUE);
 if flMultiTable then begin
    if flCurrentTable<>'' then
        stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
 end;
end;

procedure TFormSalesBeerTS.bbRetDeferredCheck2Click(Sender: TObject);
var
  i,ii:integer;
begin
 Stringgrid1.RowCount:=ArrCountDeferredCheck[1]+1;
 for i:=0 to ArrCountDeferredCheck[1]-1 do
   begin
     for ii:=1 to 13 do begin
        Stringgrid1.Cells[ii,i+1]:=arrDeferredCheck[i,ii,1];
     end;
   end;
 ArrCountDeferredCheck[1]:=0;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
 pnlretDeferredCheck.Visible:=false;
 pnlSetDeferredCheck.Visible:=false;
 bbRetDeferredCheck2.visible:=false;
 // >>>>>>>>>> Пересчет итогов <<<<<<<<<<<<<<<
 for ii:=1 to curline do
    stringgrid1.Cells[0,ii]:=inttostr(ii);
 // ========== пересчитываем сумму =======================
 if flselrow>0 then begin
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
 end;
 self.flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    self.flAllSumma:=self.flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
 end;
 CurLine:= flSelRow;
 stSumma.Caption:=format('СУММА: %8.2f',[self.flallsumma]);
 GetAllSumm;
 SetTypeDocCapture(TRUE);
 if flMultiTable then begin
    if flCurrentTable<>'' then
        stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
 end;
end;

procedure TFormSalesBeerTS.bbRetDeferredCheck3Click(Sender: TObject);
var
  i,ii:integer;
begin
 Stringgrid1.RowCount:=ArrCountDeferredCheck[2]+1;
 for i:=0 to ArrCountDeferredCheck[2]-1 do
   begin
     for ii:=1 to 13 do begin
        Stringgrid1.Cells[ii,i+1]:=arrDeferredCheck[i,ii,2];
     end;
   end;
 ArrCountDeferredCheck[2]:=0;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
 pnlretDeferredCheck.Visible:=false;
 pnlSetDeferredCheck.Visible:=false;
 bbRetDeferredCheck3.visible:=false;
 // >>>>>>>>>> Пересчет итогов <<<<<<<<<<<<<<<
 for ii:=1 to curline do
    stringgrid1.Cells[0,ii]:=inttostr(ii);
 // ========== пересчитываем сумму =======================
 if flselrow>0 then begin
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
 end;
 flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
 end;
 CurLine:= flSelRow;
 stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
 GetAllSumm;
 SetTypeDocCapture();

 if flMultiTable then begin
   if flCurrentTable<>'' then
     stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
 end;
end;

procedure TFormSalesBeerTS.BitBtn10Click(Sender: TObject);

  const
    xbit:array[0..7] of byte=(1,2,4,8,16,32,64,128);
  var
    //bm:TBitmap;

    xx,yy:integer;
    buf:string;
    //qrpm: TDelphiZXingQRCode;
    bt:byte;
    i:integer;
    ii:integer;
    url:string;
    aStr,
    str1:string;
    strbc:string;
    strpdf417:string;
    strprice:string;
    //lists:TstringList;
    flcloseCH:boolean;
    strvolume:string;
    strnumber:string;
    flalccheck:boolean;
    XML: TXMLDocument;
    Child2, Child1, Child: TDOMNode;
    S : TStringStream;
    sign:String;
    part,ser:string;
    alccode:String;
    ikkmnum:integer;
    strkkm:string;
    flclear:boolean;
    flcount,strenable:string;
    flreturn:boolean;
    strNumCheck:string;
    strerror:string;
    lists:TStringList;
    EGAISEnabled:boolean;
    fltranst:string;
    addr1:string;
    aDelt:string;
    stat1:integer;
  begin
   if DB_Boolean(formstart.GetConstant('precheckclose')) then
    begin
       stat1:= GetStatusFR(false);
     {   if not((stat1=0)or(stat1=55)) then begin
          exit;
        end;       }
        flAllSumma:=flAllSumma-flAllSummDiscount ;
        flInpSumm:=flAllSumma;
        if flgResto then begin
         formInputSummv2.flCheckSales:=flCheckSales;
         if not formInputSummv2.InputSumm(flInpSumm) then
           exit;
        end else begin
        formInputSumm.flCheckSales:=flCheckSales;
        if not formInputSumm.InputSumm(flInpSumm) then
          exit;
        end;

        // ====
        FormShowStatus.Panel1.Caption:='Идет печать документа!';
        FormShowStatus.Show;
        Application.ProcessMessages;
        // ====
        lists:=TStringList.create();
        strNumCheck:=inttostr(flNumCheck);
        DefaultFormatSettings.DecimalSeparator:='.';
        // ===================
        // ===================
        EGAISEnabled:=false;
        if flCheckSales then begin
          flcount:='';
          fltranst:='11';
          end
        else begin
          flcount:='-';
          fltranst:='13';
          end;
             // в в буфере есть позиции которые надо закрыть
         if (StringGrid1.RowCount>1) then begin
           if DB_Boolean(formstart.GetConstant('precheckclose')) then begin
            strNumCheck:=inttostr(flNumCheck);
           if flTYpeKKM=1 then begin

                  PrintLineGood('                КАССОВЫЙ ЧЕК','');
                  PrintLineGood('ПРИХОД','');

           end else
           begin
              if SizeStrFr = 48 then  begin
                  PrintLineGood('РН ККТ:'+flRNKKT,FormatDateTime('DD.MM.YYYY hh:nn',now()));
                  PrintLineGood('ЗН ККТ:'+flMFKKT,'СМЕНА:'+GetShiftCash()+' ЧЕК:'+strNumCheck);
                  PrintLineGood('КАССОВЫЙ ЧЕК/ПРИХОД','');
                  PrintLineGood('ИНН:'+formstart.FirmINN,'ФН:'+flFNNumber);
                  PrintLineGood('СИСТ.АДМИН.','#0004');
                  PrintLineGood('Сайт ФНС:','www.nalog.ru');
              end else begin
                  PrintLineGood('ЗН ККТ:'+flMFKKT,'#0004');
                  PrintLineGood('ИНН:'+formstart.FirmINN,FormatDateTime('DD.MM.YYYY hh:nn',now()));
                  PrintLineGood('СИСТ.АДМИН.','');
                  PrintLineGood('КАССОВЫЙ ЧЕК/ПРИХОД','');
                  PrintLineString('РН ККТ:'+flRNKKT);
                  PrintLineString('ФН:'+flFNNumber);
                  PrintLineGood('Сайт ФНС:','www.nalog.ru');
                  PrintLineGood('СМЕНА:'+GetShiftCash()+' ЧЕК:'+strNumCheck,'');
               end;
             end;
               end;

            if not printcheck() then
                 begin
                 FRBeep;
                      FormShowMessage.Show('Ошибка печати чека!');
                      lists.free;
                      FormShowStatus.Hide;
                      exit;
                 end;
            if DB_Boolean(formstart.GetConstant('precheckclose')) then
             begin
              lists.Clear;
              for ii:=1 to StringGrid1.RowCount-1 do
                if (trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0') then begin
                 EGAISEnabled:=true;
                 if thisBeer(StringGrid1.Cells[10,ii]) then begin
                    addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),'',trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));
                   end
                  else begin
                   addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+'1',trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),trim(StringGrid1.Cells[8,ii]),trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));
                  end;
                 end else
                   addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),format('%0.2f',[StrToFloat(trim(StringGrid1.Cells[5,ii]))-strtofloat(Stringgrid1.Cells[13,ii])]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[1,ii]),'',trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));

               if flTYpeKKM=1 then begin
                  PrintLineGood(''#9'И'#9'Т'#9'О'#9'Г','='+format('%0.2f',[flallsumma]),false);
                  PrintLineGood('ОПЛАТА','');
                  PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                  PrintLineGood('ВСЕГО ОПЛАЧЕНО','');
                  PrintLineGood('НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                  PrintLineGood('ЭЛЕКТРОННЫМИ','=0.00');
                  PrintLineGood('СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));
                 { for i:=0 to Memo1.Lines.Count-1 do
                        PrintLineString(Memo1.Lines.Strings[i]); }
                  PrintLineGood('СНО:','УСН доход');
                  PrintLineGood('Сумма с НДС 0%:',format('%0.2f',[flallsumma]));
                  PrintLineGood('САЙТ ФНС:','www.nalog.ru');
                  PrintLineGood('Пользователь:'+formstart.FirmShortName,'');
                  //addr1:=Utf8toAnsi(formstart.FirmAddress);

                  PrintLineGood('Адрес:'+formstart.FirmAddress,'');
                  //PrintLineGood(''+formstart.FirmAddress,'');
                  PrintLineGood('Кассир:СИС.АДМИНИСТРАТОР','');
                  PrintLineGood('ИНН:',formstart.FirmINN);
                  PrintLineGood('+ЗН ККТ',flMFKKT+'+');
                  PrintLineGood('СМЕНА №',GetShiftCash());
                  PrintLineGood('ЧЕК №',strNumCheck);
                  PrintLineGood(' ',' ');
                  PrintLineGood('+','+');
                  PrintLineGood(' '+FormatDateTime('DD.MM.YYYY hh:nn',now()),'');
                  PrintLineGood(' ИТОГ','='+format('%0.2f ',[flallsumma]));
                  PrintLineGood(' РН ККТ:',flRNKKT+' ');
                  PrintLineGood(' ФН №',flFNNumber+' ');
                  PrintLineGood(' ФД №',strNumCheck+' ');
                  PrintLineGood(' ФПД',formStart.FirmINN+' ');
                  PrintLineGood('+','+');
                  PrintLineGood(' ',' ');
                  FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                  PrintLineGood(' ',' ');
                  end else
                  begin //  ==== Штриховский чек
                    if SizeStrFr = 48 then  begin // === размер ленты
                     PrintLineGood('ИТОГ','='+format('%0.2f',[flallsumma]),true);

                    if flTaxType='1' then begin
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                      PrintLineGood('ПОЛУЧЕНО:','');
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                      if flInpSumm>flallsumma then
                        PrintLineGood(' СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));

                      PrintLineGood('Г:СУММА БЕЗ НДС:',format('%0.2f',[flallsumma]));
                      PrintLineGood('СНО: ОСН','ФД:'+strNumCheck+' ФП:'+formStart.FirmINN);
                     end else BEGIN
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                    // PrintLineGood('ПОЛУЧЕНО:','');
                    if flInpSumm>flallsumma then
                       PrintLineGood(' СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));
                       PrintLineGood('СНО: УСН доход','ФД:'+strNumCheck+' ФП:'+formStart.FirmINN);
                     END;
                     FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                     PrintLineGood(' ',' ');
                     end
                     else begin
                    PrintLineGood('ИТОГ','='+format('%0.2f',[flallsumma]),true);
                    PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                    PrintLineGood('ПОЛУЧЕНО:','');
                    PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                    if flInpSumm>flallsumma then
                        PrintLineGood(' СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));
                    PrintLineGood('Г:СУММА БЕЗ НДС:',format('%0.2f',[flallsumma]));
                    PrintLineGood('СНО:','УСН доход');
                    PrintLineGood('ФД:'+strNumCheck,' ФП:'+formStart.FirmINN);
                    FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                    PrintLineGood(' ',' ');
                {    PrintLineGood(' ',' ');
                    PrintLineGood(' ',' ');
                    PrintLineGood(' ',' ');
                    PrintLineGood(' ',' ');  }
                    end;
                  end;
                  addtrans(formStart.prefixClient,strNumCheck,'40','0','1',floattostr(flallsumma),floattostr(flallsumma),'','','');
                  addtrans(formStart.prefixClient,inttostr(flNumCheck),'55','0','1',floattostr(flallsumma),floattostr(flInpSumm),'','','');
                  formStart.SetConstant('LastNumCheck',strNumCheck);
                  aDelt:= format('%0.2f',[flInpSumm-flallsumma+flAllSummDiscount]);
         // коментарий ===
         inc(flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис

         FRPrintHeader;
         ClearCheck();

         stNumber.Caption:='СДАЧА:'+aDelt;
        end;
     //      end;
      end;
      FormShowStatus.Hide;
      lists.free;
      BitBtn4Click(nil);
   if flTYpeKKM=2 then
    VIKICloseDocument;
             FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

  end else begin
    if printcheck() then ;
     //       FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');
    FRPrintHeader;
  end;
end;

procedure TFormSalesBeerTS.BitBtn11Click(Sender: TObject);
begin
  if formspusers.GetPolice(formstart.flCurUserId).reportkkm then
  PrintAlcReport(FormatDateTime('YYYY-MM-DD',now()));
end;

procedure TFormSalesBeerTS.BitBtn12Click(Sender: TObject);
begin
 if cldDialog.Execute then
   PrintAlcReport(FormatDateTime('YYYY-MM-DD',cldDialog.Date));
end;

{Кнопка "Открыть смену"}
procedure TFormSalesBeerTS.BitBtn13Click(Sender: TObject);
var
  nFD,SignFP,nShift,SlipNumber,nDoc: Integer;
begin
 if (FlgLoadLibFR) then
  begin                     //12345678901234567890123456789012345678901234567890
    try
     case fltypeKKM of
       0:  begin
         OleFR.Password:=30;
         OleFR.OpenSession();
       end;
       1:if flg_dto_10 then begin // ==== ATOL10 =====
        SetCurrentKassirName();
        OleFR.openShift;
        OleFR.checkDocumentClosed;
       end;
       2:VIKIOpenDay;
       4:OleFR.OpenShift(30,'30',1,'','','','',nFD,SignFP,nShift) ;
     end;

    finally
    end;

  end;
end;

procedure TFormSalesBeerTS.bbVisualFindGoodsClick(Sender: TObject);
var
  aPLU:string;
begin
  aPLU:=FormVisualFindGoods.getplu();
  if aPLU<>'' then
    AddPLUCode(aPLU,'1000');
end;

procedure TFormSalesBeerTS.BitBtn14Click(Sender: TObject);

const
    xbit:array[0..7] of byte=(1,2,4,8,16,32,64,128);
var
    //bm:TBitmap;

    xx,yy:integer;
    buf:string;
    //qrpm: TDelphiZXingQRCode;
    bt:byte;
    i:integer;
    ii:integer;
    url:string;
    aStr,
    str1:string;
    strbc:string;
    strpdf417:string;
    strprice:string;
    //lists:TstringList;
    flcloseCH:boolean;
    strvolume:string;
    strnumber:string;
    flalccheck:boolean;
    XML: TXMLDocument;
    Child2, Child1, Child: TDOMNode;
    S : TStringStream;
    sign:String;
    part,ser:string;
    alccode:String;
    ikkmnum:integer;
    strkkm:string;
    flclear:boolean;
    flcount,strenable:string;
    flreturn:boolean;
    strNumCheck:string;
    strerror:string;
    lists:TStringList;
    EGAISEnabled:boolean;
    fltranst:string;
    addr1:string;
    aDelt:string;
    stat1:integer;
begin
  if flg_view_only then Begin
     ShowMessage('В данном режиме продажа запрещена!');
     exit;
  end;
   if DB_Boolean(formstart.GetConstant('precheckclose')) then
    begin
       stat1:= GetStatusFR(false);
     {   if not((stat1=0)or(stat1=55)) then begin
          exit;
        end;       }
        flInpSumm:=flAllSumma-flAllSummDiscount;
        formInputSumm.flCheckSales:=flCheckSales;
        if not formInputSumm.InputSumm(flInpSumm) then
          exit;


        // ====
        FormShowStatus.Panel1.Caption:='Идет печать документа!';
        FormShowStatus.Show;
        Application.ProcessMessages;
        // ====
        lists:=TStringList.create();
        strNumCheck:=inttostr(flNumCheck);
        DefaultFormatSettings.DecimalSeparator:='.';
        // ===================
        // ===================
        EGAISEnabled:=false;
        if flCheckSales then begin
          flcount:='';
          fltranst:='11';
          end
        else begin
          flcount:='-';
          fltranst:='13';
          end;

             // в в буфере есть позиции которые надо закрыть
         if (StringGrid1.RowCount>1) then begin
           if DB_Boolean(formstart.GetConstant('precheckclose')) then begin
            strNumCheck:=inttostr(flNumCheck);
           if flTYpeKKM=1 then begin

                  PrintLineGood('                КАССОВЫЙ ЧЕК','');
                  PrintLineGood('ПРИХОД','');

           end else
           begin
              if SizeStrFr = 48 then  begin
                  PrintLineGood('РН ККТ:'+flRNKKT,FormatDateTime('DD.MM.YYYY hh:nn',now()));
                  PrintLineGood('ЗН ККТ:'+flMFKKT,'СМЕНА:'+GetShiftCash()+' ЧЕК:'+strNumCheck);
                  PrintLineGood('КАССОВЫЙ ЧЕК/ПРИХОД','');
                  PrintLineGood('ИНН:'+formstart.FirmINN,'ФН:'+flFNNumber);
                  PrintLineGood('СИСТ.АДМИН.','#0004');
                  PrintLineGood('Сайт ФНС:','www.nalog.ru');
              end else begin
                  PrintLineGood('ЗН ККТ:'+flMFKKT,'#0004');
                  PrintLineGood('ИНН:'+formstart.FirmINN,FormatDateTime('DD.MM.YYYY hh:nn',now()));
                  PrintLineGood('СИСТ.АДМИН.','');
                  PrintLineGood('КАССОВЫЙ ЧЕК/ПРИХОД','');
                  PrintLineString('РН ККТ:'+flRNKKT);
                  PrintLineString('ФН:'+flFNNumber);
                  PrintLineGood('Сайт ФНС:','www.nalog.ru');
                  PrintLineGood('СМЕНА:'+GetShiftCash()+' ЧЕК:'+strNumCheck,'');
               end;
             end;
               end;

            if not printcheck() then
                 begin
                 FRBeep;
                      FormShowMessage.Show('Ошибка печати чека!');
                      lists.free;
                      FormShowStatus.Hide;
                      exit;
                 end;
            if DB_Boolean(formstart.GetConstant('precheckclose')) then
             begin
              lists.Clear;
              for ii:=1 to StringGrid1.RowCount-1 do
                if (trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0') then begin
                 EGAISEnabled:=true;
                 if thisBeer(StringGrid1.Cells[10,ii]) then begin
                    addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[5,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),'',trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));
                   end
                  else begin
                   addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+'1',trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),trim(StringGrid1.Cells[8,ii]),trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));
                  end;
                 end else
                   addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[5,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[1,ii]),'',trim(StringGrid1.Cells[2,ii]),false,trim(StringGrid1.Cells[15,ii]));

               if flTYpeKKM=1 then begin
                  PrintLineGood(''#9'И'#9'Т'#9'О'#9'Г','='+format('%0.2f',[flallsumma]),false);
                  PrintLineGood('ОПЛАТА','');
                  PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                  PrintLineGood('ВСЕГО ОПЛАЧЕНО','');
                  PrintLineGood('НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                  PrintLineGood('ЭЛЕКТРОННЫМИ','=0.00');
                  PrintLineGood('СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));
                 { for i:=0 to Memo1.Lines.Count-1 do
                        PrintLineString(Memo1.Lines.Strings[i]); }
                  PrintLineGood('СНО:','УСН доход');
                  PrintLineGood('Сумма с НДС 0%:',format('%0.2f',[flallsumma]));
                  PrintLineGood('САЙТ ФНС:','www.nalog.ru');
                  PrintLineGood('Пользователь:'+formstart.FirmShortName,'');
                  //addr1:=Utf8toAnsi(formstart.FirmAddress);

                  PrintLineGood('Адрес:'+formstart.FirmAddress,'');
                  //PrintLineGood(''+formstart.FirmAddress,'');
                  PrintLineGood('Кассир:СИС.АДМИНИСТРАТОР','');
                  PrintLineGood('ИНН:',formstart.FirmINN);
                  PrintLineGood('+ЗН ККТ',flMFKKT+'+');
                  PrintLineGood('СМЕНА №',GetShiftCash());
                  PrintLineGood('ЧЕК №',strNumCheck);
                  PrintLineGood(' ',' ');
                  PrintLineGood('+','+');
                  PrintLineGood(' '+FormatDateTime('DD.MM.YYYY hh:nn',now()),'');
                  PrintLineGood(' ИТОГ','='+format('%0.2f ',[flallsumma]));
                  PrintLineGood(' РН ККТ:',flRNKKT+' ');
                  PrintLineGood(' ФН №',flFNNumber+' ');
                  PrintLineGood(' ФД №',strNumCheck+' ');
                  PrintLineGood(' ФПД',formStart.FirmINN+' ');
                  PrintLineGood('+','+');
                  PrintLineGood(' ',' ');
                  FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                  PrintLineGood(' ',' ');
                  end else
                  begin //  ==== Штриховский чек
                    if SizeStrFr = 48 then  begin // === размер ленты
                     PrintLineGood('ИТОГ','='+format('%0.2f',[flallsumma]),true);

                    if flTaxType='1' then begin
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                      PrintLineGood('ПОЛУЧЕНО:','');
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                      if flInpSumm>flallsumma then
                        PrintLineGood(' СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));

                      PrintLineGood('Г:СУММА БЕЗ НДС:',format('%0.2f',[flallsumma]));
                      PrintLineGood('СНО: ОСН','ФД:'+strNumCheck+' ФП:'+formStart.FirmINN);
                     end else BEGIN
                      PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                    // PrintLineGood('ПОЛУЧЕНО:','');
                    if flInpSumm>flallsumma then
                       PrintLineGood(' СДАЧА','='+format('%0.2f',[flInpSumm-flallsumma]));
                       PrintLineGood('СНО: УСН доход','ФД:'+strNumCheck+' ФП:'+formStart.FirmINN);
                     END;
                     FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                     PrintLineGood(' ',' ');
                     end
                     else begin
                    PrintLineGood('ИТОГ','='+format('%0.2f',[flallsumma]),true);
                    PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flallsumma]));
                    PrintLineGood('ПОЛУЧЕНО:','');
                    PrintLineGood(' НАЛИЧНЫМИ','='+format('%0.2f',[flInpSumm]));
                    PrintLineGood('Г:СУММА БЕЗ НДС:',format('%0.2f',[flallsumma]));
                    PrintLineGood('СНО:','УСН доход');
                    PrintLineGood('ФД:'+strNumCheck,' ФП:'+formStart.FirmINN);
                    FRPrintQRCode('http://egais.retailika.ru/'#13't='+FormatDateTime('YYYYMMDD',now())+'T'+FormatDateTime('hhnn',now())+'&s='+format('%0.2f ',[flallsumma])+'&fn='+flFNNumber+'&i='+strNumCheck+'&fp='+formStart.FirmINN+'&n=1');
                    PrintLineGood(' ',' ');
                    end;
                  end;
                  addtrans(formStart.prefixClient,strNumCheck,'40','0','1',floattostr(flallsumma),floattostr(flallsumma),'','','');
                  formStart.SetConstant('LastNumCheck',strNumCheck);
                  aDelt:= format('%0.2f',[flInpSumm-flallsumma+flAllSummDiscount]);

         inc(flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис

         FRPrintHeader;
         ClearCheck();

         stNumber.Caption:='СДАЧА:'+aDelt;
        end;
     //      end;
      end;
      FormShowStatus.Hide;
      lists.free;
      FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

   {   if flTYpeKKM=0 then
        OleFR.ClearSlipDocumentBuffer();   }
  end else begin
    if printcheck() then
    //        FormStart.DB_query('UPDATE `doccash` SET `closecheck`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+strNumCheck+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');
     ;
    FRPrintHeader;
  end;

end;

procedure TFormSalesBeerTS.BitBtn15Click(Sender: TObject);
begin
 if flMultiTable then begin
     formvisualselecttable.flSelectTableid:=flCurrentTable;
     formvisualselecttable.AddTable;

     pnlSelectTable.Visible:=true;
   end
 else
   pnlSelectTable.Visible:=false;
 Application.ProcessMessages;
end;

procedure TFormSalesBeerTS.BitBtn16Click(Sender: TObject);
var
  i:integer;
begin
  flProcentCard:=formdiscountcard.SendDiscountCard();
  if (flProcentCard<>'')AND(flProcentCard<>'0') then  begin
     flIdCard:= formdiscountcard.Edit1.Text;
     flProcentSkid:=strtofloat(flProcentCard);
     if Stringgrid1.RowCount>0 then begin
        for i:=1 to Stringgrid1.RowCount-1 do
            Stringgrid1.cells[17,i] :=flProcentCard;
        refreshStaticText;
        self.flallsumma:=GetAllSumm();
        stSumma.Caption:=trim(format('СУММА: %8.2f',[self.flallsumma]));
     end;
  end;
end;

{Кнопка: "Отчет без гашения"}
procedure TFormSalesBeerTS.BitBtn17Click(Sender: TObject);
begin

  if formspusers.GetPolice(formstart.flCurUserId).reportx then begin
    addtrans(formStart.prefixClient,inttostr(flNumCheck),'60','0','1','0','0','','','');
    formInputSumm.fl_not_print :=false;
     self.PrintZReport();
  end;
end;

procedure TFormSalesBeerTS.BitBtn18Click(Sender: TObject);
begin
  if db_boolean(FormStart.GetConstant('autoactwritebeer')) then
      formActWriteBeer.showmodal;
  if formspusers.GetPolice(formstart.flCurUserId).reportx then begin
    addtrans(formStart.prefixClient,inttostr(flNumCheck),'61','0','1','0','0','','','');
    formInputSumm.fl_not_print :=false;
    PrintXReport();
    GetReport();
    GetStatusFR(true);
  end;
end;

{Кнопка: "Отчет по банку"}
procedure TFormSalesBeerTS.BitBtn19Click(Sender: TObject);
begin
  self.CloseDaySB();
end;

procedure TFormSalesBeerTS.BitBtn3Click(Sender: TObject);
var
  r:Tpoint;
begin
 if flgResto then begin
   if (pnlSprGoods.visible) then begin
     pnlSprGoods.Visible:=false;
     pnlService.Visible:=true;
     pnlService1.Visible:=false;
   end else begin
     pnlSprGoods.Visible:=true;
     pnlService.Visible:=false;
     pnlService1.Visible:=false;
   end;
  end else begin
  if (pnlFastGoods.Visible) then begin
    pnlFastGoods.Visible:=false;
    pnlService.Visible:=true;
    pnlService1.Visible:=false;
  end else begin
    pnlFastGoods.Visible:=true;
    pnlService.Visible:=false;
    pnlService1.Visible:=false;

  end;
  end;
  //r:=BitBtn3.ClientOrigin;
  //  r.Top:=;
  //PopupMenu1.PopUp(r.x,r.y+BitBtn3.Height+1);
  //  if formloginadmin.showmodal=1377 then
  //     self.PrintZReport();
end;
{

}
procedure TFormSalesBeerTS.BitBtn4Click(Sender: TObject);
var
  i:integer;
begin
//  if formloginadmin.showmodal=1377 then
//    self.PrintXReport();
 addtrans(formStart.prefixClient,inttostr(flNumCheck),'155','0','1','0','0','','','');
 case flTypeKKM of
  2: VIKIOpenDrawer() ;
  0: OleFR.OpenDrawer();   // Для драйвера Штрих-М
  4: OleFR.OpenCashDrawer(200);
  end;
end;

procedure TFormSalesBeerTS.BitBtn5Click(Sender: TObject);
begin
  flg_view_only := False;
  if formspusers.GetPolice(formstart.flCurUserId).cancelcheck then
    clearcheck()
  else
  if formloginadmin.showmodal=1377 then
    clearcheck();
end;

procedure TFormSalesBeerTS.BitBtn6Click(Sender: TObject);
begin
 if formspusers.GetPolice(formstart.flCurUserId).returncheck then
  begin
    if flOpenDoc then
      begin
       FRBeep;
        ShowMessage('Документ уже открыть, сменить тип документа невозможно!');
        exit;
      end;
     flCheckSales:=false;
     stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
     SetTypeDocCapture(TRUE);
  end
 else begin
 if formloginadmin.showmodal=1377 then begin
   if flOpenDoc then
     begin
      FRBeep;
       ShowMessage('Документ уже открыть, сменить тип документа невозможно!');
       exit;
     end;
    flCheckSales:=false;
    stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
    SetTypeDocCapture(TRUE);
 end;
 end;
end;

procedure TFormSalesBeerTS.BitBtn7Click(Sender: TObject);
var
  ii:integer;
  r1:real;
  r2:real;
  str_error:string = '';
begin
  if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
    if isDeleteDep(strtoint(StringGrid1.Cells[15,flSelRow])) then  begin
    r1:=formstart.StrToFloat(trim(StringGrid1.Cells[4,flSelRow]));
    if r1<=1 then begin
      if formspusers.GetPolice(formstart.flCurUserId).storno then
       begin
        formstart.send_tbot_message(
            FormatDateTime('DD.MM.YYYY hh:nn',now())
            +' Сторно: '+stringgrid1.Cells[1,flSelRow]
            +' '+stringgrid1.Cells[2,flSelRow]
            +' '+stringgrid1.Cells[4,flSelRow],str_error);
        curLine:= curLine-1;
        stringgrid1.DeleteRow(flSelRow);

      if (flSelRow>= stringgrid1.RowCount)  then  begin
         flSelRow:= stringgrid1.RowCount -1;
         curLine:=flSelRow;

       end;

       end else begin
        FRBeep;
        formShowMessage.Show('Недостаточно прав для СТОРНО!');
       end;
     end else begin
       r1:=r1-1;
       r2:=self.RoundRub(r1*formstart.StrToFloat(trim(StringGrid1.Cells[3,flSelRow])),100);
       StringGrid1.Cells[4,flSelRow]:=format('%3.3f',[r1]);
       StringGrid1.Cells[5,flSelRow]:=format('%8.2f',[r2]);
     end;
     end else begin
        FRBeep;
        formShowMessage.Show('Данная позиция уже оплачено!');
       end;

    end;
  for ii:=1 to curline do
     stringgrid1.Cells[0,ii]:=inttostr(ii);
  // ========== пересчитываем сумму =======================
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  end;
  self.flAllSumma:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
     self.flAllSumma:=self.flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
  end;
  stSumma.Caption:=format('СУММА: %8.2f',[self.flallsumma]);
  GetAllSumm;
  SetTypeDocCapture(TRUE); // Обновление надписи типа чека
  if flMultiTable then begin
    if flCurrentTable<>'' then
      stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
  end;
end;

{Изменение количества товара}
procedure TFormSalesBeerTS.BitBtn8Click(Sender: TObject);
var
  ii:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  strprice:String;
  rPrice1,rQual,rSumm1,rSumm2,rDisc1:real;
  Count1:real;
begin
  if flSelRow<=0 then
   exit;
  // === изменим кол-во товара без акцизы
  if flNumber = '' then begin
   // Предположим что надо указать вес из весов
   xrecbuf:=formstart.db_query('SELECT * FROM `sprgoods` WHERE `weightgood`=''+'' AND `plu`='''+StringGrid1.Cells[1,flSelRow]+''';');
   xrowbuf:=formstart.DB_Next(xrecbuf);
   if xrowbuf <> nil then
     begin
       flNumber:=GetScaleCurrentCash();
     end;
  end;
 if flgResto then begin
      Count1:=formstart.StrToFloat(trim(StringGrid1.Cells[4,flSelRow]));

      xrecbuf:=formstart.db_query('SELECT `weightgood` FROM `sprgoods` WHERE `weightgood`=''+'' AND `plu`='''+StringGrid1.Cells[1,flSelRow]+''';');
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf = nil then
         formInputQuantity.flVesi:=false
        else begin
         if db_boolean(xrowbuf[0]) then
           formInputQuantity.flVesi:=true
         else
          formInputQuantity.flVesi:=false;
      end;

    if not formInputQuantity.InputSumm(Count1,formInputQuantity.flVesi) then
      exit;
    flNumber:=  formInputQuantity.edSumm.Text;
  end else begin
     if flNumber = '' then begin
         FRBeep;
         formShowMessage.Show('Введите количество!');
         exit;
      end;

     ii:=pos('.',flNumber);
     if ii<>0 then  begin
          xrecbuf:=formstart.db_query('SELECT * FROM `sprgoods` WHERE `weightgood`=''+'' AND `plu`='''+StringGrid1.Cells[1,flSelRow]+''';');
          xrowbuf:=formstart.DB_Next(xrecbuf);
          if xrowbuf = nil then
            begin
               FRBeep;
              formShowMessage.Show('Этот товар дробить нельзя!');
              flNumber:='';
              stNumber.Caption:='0';
              exit;
            end;
     end;
 end;

 if ((StringGrid1.Cells[8,flSelRow] ='') AND (StringGrid1.Cells[10,flSelRow]='0')) then  begin

   end else begin
     if thisBeer(StringGrid1.Cells[10,flSelRow]) then
       else begin
        FRBeep;
         formShowMessage.Show('Изменить количество можно только для пива и пивных напитков!');
         flNumber:='';
         exit;

       end;
   end;

 if flselrow>0 then begin

  // === Рассчитываем цену с округлением ===
  rPrice1:= formstart.StrToFloat(trim(StringGrid1.Cells[3,flSelRow]));
  rQual:= formstart.StrToFloat(trim(flNumber));
  //rSumm1:= rPrice1*rQual;  // === Сумма без скидок
  rSumm2:=roundRub(rPrice1*rQual,100);
  rDisc1:=0;

  StringGrid1.Cells[3,flSelRow]:=format('%0.2f',[rPrice1]);
  StringGrid1.Cells[4,flSelRow]:=format('%3.3f',[rQual]);
  StringGrid1.Cells[5,flSelRow] := format('%8.2f',[rSumm2]);
  Stringgrid1.Cells[13,flSelRow]:= '0';
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
 end;
 self.flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    self.flAllSumma:=flAllSumma+ formstart.StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
 end;
 stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
 GetAllSumm;

 SetTypeDocCapture(TRUE);
 flNumber:='';
end;

procedure TFormSalesBeerTS.BitBtn9Click(Sender: TObject);
//  if formloginadmin.showmodal=1377 then begin
//    addtrans(formStart.prefixClient,inttostr(flNumCheck),'61','0','1','0','0','','','');
//     self.PrintZReport();
//  end;
var
  ii:integer;
  r1:real;
  r2:real;
begin

  if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
   r1:=formstart.StrToFloat(trim(StringGrid1.Cells[4,flSelRow]));
   r1:=r1+1;
   r2:=RoundRub(r1*formstart.StrToFloat(trim(StringGrid1.Cells[3,flSelRow])),100);
   StringGrid1.Cells[4,flSelRow]:=FORMAT('%3.3f',[(r1)]);
   StringGrid1.Cells[5,flSelRow]:=FORMAT('%8.2f',[(r2)]);
  end;
  for ii:=1 to curline do
     stringgrid1.Cells[0,ii]:=inttostr(ii);
  // ========== пересчитываем сумму =======================
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
   //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end;
  flAllSumma:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
     flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
  end;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  GetAllSumm;
  SetTypeDocCapture(TRUE);
end;

procedure TFormSalesBeerTS.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if flOpenDoc then begin
   if flTypeKKM=1 then begin
      if flg_dto_10 then
         OleFR.cancelReceipt()
      else
         OleFR.CancelCheck () ;
    end;
   if flTypeKKM=2 then
    VIKICloseDocument;
   if flTypeKKM=4 then

    end;
  CloseAction:=caHide;
end;

procedure TFormSalesBeerTS.FormCreate(Sender: TObject);
var
  {str1:string;   }
  i:integer;
begin
 fl_slip_check:= TStringList.Create;
 fl_slip_check.Clear;
 FlgLoadLibLP:=false;
 FlgLoadLibLPMini:=false;
 flGroupIdCigar :='-1';
 flSBDep:=0;
 flAllSummDiscount:=0;
 for i:=0 to 3 do
   ArrCountDeferredCheck[i]:=0;
 BGimg1:=TPicture.Create;
 if fileexists('bg_cash.jpg') then
   BGimg1.LoadFromFile('bg_cash.jpg');
end;

procedure TFormSalesBeerTS.FormDestroy(Sender: TObject);
begin
    BgImg1.Free;
end;
{ Обрабатываем события с клавиатуры }
procedure TFormSalesBeerTS.FormKeyPress(Sender: TObject; var Key: char);
//011500015807102221VFVD1KXEH40H791EE0692TgCr+T/nLRMUHK9G/KSNotpzVMbqSO/kAOgABkIyRow=
function get_gtin_sn(astr:string; var gtin,sn:string):boolean;
var
    s1:string;
    i:integer;
begin
    result:= True;
    s1:=copy(astr,1,2);
    if s1 = '01' then begin
        gtin := copy(astr,3,14);
        sn := copy(astr,19,6);
        result:= True;
    end
    else begin
         gtin := copy(astr,1,14);
         sn := copy(astr,15,7);
         result:= True;
    end;


end;
var
  ii:integer;
  bres:boolean;
  aVes:boolean;
  tmpBC:string;
  gtin_str:string;
  sn_str:string;
  lenCB:integer;
begin
  if key in ['!'..'z'] then begin
    if key=',' then
     key:='.';
    flNumber:=flNumber+key;
    key:=#0  ;
  end;
  if key = #8 then begin
    if length(flNumber)>1 then
       flNumber:=copy(flNumber,1,length(flnumber)-1)
     else
       flNumber:='';
  end;
 { if (key='-') and (flSelRow <> 0) then begin
   if isDeleteDep(strtoint(StringGrid1.Cells[15,flSelRow])) then  begin
   if formspusers.GetPolice(formstart.flCurUserId).storno then
   begin
     if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
       curLine:= curLine-1;
       stringgrid1.DeleteRow(flSelRow);
       end;

     if (flSelRow>= stringgrid1.RowCount)  then  begin
      flSelRow:= stringgrid1.RowCount -1;
      curLine:=flSelRow;

      end;
     for ii:=1 to curline do
        stringgrid1.Cells[0,ii]:=inttostr(ii);
     key:=#0;
   end else begin

    key:=#0;
    FRBeep;
    formShowMessage.Show('недостаточно прав!');
   end;
   end else begin
       key:=#0;
       FRBeep;
       formShowMessage.Show('Данная позиция уже оплачена!');
      end;
  end;    }

  if key = #13 then
  begin
    lenCB := Length(flNumber);
    key:=#0;
    if ( lenCB in [13,12,8] )and( pos('.',flNumber) = 0 ) then
    begin
      bres:=false;
      // ====считаем что это штрихкод =====
      if ( lenCB = 12 )and( formStart.GetConstant('AddBarCodeEAN13') = '1' ) then begin
          flNumber:='0'+flNumber;
        end;
      if (Length(flNumber)=13) then begin
        if ((flNumber[1]+flNumber[2]) = flPrefixVes)AND(flPrefixVes<>'') then  // ==== это весовой товар ===
        begin
          bres:= addPLUcode(flNumber[3]+flNumber[4]+flNumber[5]+flNumber[6]+flNumber[7],flNumber[8]+flNumber[9]+flNumber[10]+flNumber[11]+flNumber[12]);

        end;
        if ((flNumber[1]+flNumber[2]) = flPrefixCard)and(flPrefixCard<>'') then  // ==== это дисконтная карта ===
        begin
          bres:=true;
          flIdCard:= flNumber[6]+flNumber[7]+flNumber[8]+flNumber[9]+flNumber[10]+flNumber[11]+flNumber[12];
          flProcentCard:=flNumber[4]+flNumber[5];
          flProcentSkid:=strtofloat(flProcentCard);
          if Stringgrid1.Row>0 then
           begin
             Stringgrid1.cells[17,flSelRow] :=flProcentCard;

           end;
          GetAllSumm;
        end;
        key:=#0;
      end;
      if not bres then
        bres:=addBarcode(flNumber);
      flNumber:='';
      stSumma.Caption:='0';
      key:=#0;
    end else begin
        tmpBC:=flNumber;
        bres:=false;
        if lenCB> 13 then begin
            gtin_str:='';
            sn_str:='';
            if get_gtin_sn(flNumber,gtin_str,sn_str) then begin
               if copy(gtin_str,1,6) = '000000' then
                   tmpBC:=copy(gtin_str,7,8)
                else
                   tmpBC:= copy(gtin_str,2,13);
                bres:=addBarcode(tmpBC);  //flSelRow
                StringGrid1.Cells[19,flSelRow] := flNumber;
                flNumber:= tmpBC;
            end;
            //bres:=addBarcode(tmpBC);
        end ;

      if not bres then begin
          FRBeep;
          formShowMessage.Show('Не верный штрихкод:'+flNumber);
      end;
      flNumber:='';
      stSumma.Caption:='0';
      key:=#0;
    end;
  end;


  if flNumber<>'' then stNumber.Caption:=flNumber
                  else stNumber.Caption:='0';

  // ========== пересчитываем сумму =======================
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  // stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end;
  flAllSumma:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
     flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
  end;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  SetTypeDocCapture();
  StringGrid1.SetFocus;
end;

procedure TFormSalesBeerTS.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
     ii:integer;
     str_error:string = '';
begin
    if formInputSumm.fl_active_basket Then
        Exit;
  if Shift = [ssCtrl]  then begin
   case char(lo(key)) of
     '1': begin
        if ArrFastGood[1]<>'' then
          addPLUcode(ArrFastGood[1],'1000');
        key:=0;
        exit;
     end;
     '2': begin
        if ArrFastGood[2]<>'' then
          addPLUcode(ArrFastGood[2],'1000');
        key:=0;
        exit;
     end;
     '3': begin
        if ArrFastGood[3]<>'' then
          addPLUcode(ArrFastGood[3],'1000');
        key:=0;
        exit;
     end;
     '4': begin
        if ArrFastGood[4]<>'' then
          addPLUcode(ArrFastGood[4],'1000');
        key:=0;
        exit;
     end;
     '5': begin
        if ArrFastGood[5]<>'' then
          addPLUcode(ArrFastGood[5],'1000');
        key:=0;
        exit;
     end;
     '6': begin
        if ArrFastGood[6]<>'' then
          addPLUcode(ArrFastGood[6],'1000');
        key:=0;
        exit;
     end;
     '7': begin
        if ArrFastGood[7]<>'' then
          addPLUcode(ArrFastGood[7],'1000');
        key:=0;
        exit;
     end;
     '8': begin
        if ArrFastGood[8]<>'' then
          addPLUcode(ArrFastGood[9],'1000');
        key:=0;
        exit;
     end;
     '9': begin
        if ArrFastGood[9]<>'' then
          addPLUcode(ArrFastGood[9],'1000');
        key:=0;
        exit;
     end;
     {'c','C': begin
       if flSelRow <> 0 then
         FormCigar.edCodeItem.Text:= StringGrid1.Cells[19,flSelRow]
       else
         FormCigar.edCodeItem.Text:='';
         key:=#0;
        if FormCigar.ShowModal = 1137 then
           StringGrid1.Cells[19,flSelRow] := FormCigar.edCodeItem.Text;
     End; }

   end;
    if (key=90 ) then begin // CTRL-Z
    ShowKKMOption ;
    //showmessage('F1')
    key:=0;
    exit;
    end;
   if (key=107) OR (key=187) then begin // ctrl+'pad+'
      flNumber:=StringReplace( flNumber,',','.',[rfReplaceAll]);
      BitBtn1Click(nil);
      key:=0;
      exit;
   end;
   // trans_check
   if (key=66)  then begin // ctrl+'b'
      flNumber:=StringReplace( flNumber,',','.',[rfReplaceAll]);
      trans_check(true);
      key:=0;
      exit;
   end;

   if (key=86 ) then begin  // ctrl+V
      if flOpenDoc and (not flg_view_only) then begin
         FRBeep;
          formstart.fShowMessage('Документ уже открыть, сменить тип документа невозможно!');
        end
       else begin
         if flg_view_only then begin
          ClearCheck();
          flg_view_only := False;
         end
         else
             flg_view_only:=True ;
         SetTypeDocCapture();
       end;

      key:=0;
      exit;
   end;
     if ( lo(key) in [ 109, 189 ] ) and (flSelRow <> 0) then begin
        if formspusers.GetPolice(formstart.flCurUserId).storno then begin
            formstart.send_tbot_message(
                FormatDateTime('DD.MM.YYYY hh:nn',now())
                +' Сторно: '+stringgrid1.Cells[1,flSelRow]
                +' '+stringgrid1.Cells[2,flSelRow]
                +' '+stringgrid1.Cells[4,flSelRow],str_error);
          if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
              curLine:= curLine-1;
              stringgrid1.DeleteRow(flSelRow);
          end;
          if (flSelRow>= stringgrid1.RowCount)  then  begin
              flSelRow:= stringgrid1.RowCount -1;
              curLine:=flSelRow;
          end;
          for ii:=1 to curline do
             stringgrid1.Cells[0,ii]:=inttostr(ii);
          key:=0;
        end else begin
          key:=0;
          FRBeep;
          formShowMessage.Show('недостаточно прав!');
        end;
        exit;
       end
     else formstart.fshowmessage('Не известная комбинация клавиш:'+inttostr(Key)+' lo:'+inttostr( lo(key) ) );
  end ;


 if  (key=117 )and(shift = []) then begin
    flNumber:=StringReplace( flNumber,',','.',[rfReplaceAll]);
    BitBtn2Click(nil);
    key:=0;
    exit;
  end;
 if  (key=116 )and(shift = []) then begin
    flNumber:=StringReplace( flNumber,',','.',[rfReplaceAll]);
    BitBtn8Click(nil);
    flNumber:='';
    stNumber.Caption:='0';
    key:=0;
    exit;
  end;
{ if  (key=115 )and(shift = []) then begin
    BitBtn9Click(nil);
    key:=0;
    exit;
  end; }
 if  (key=115 )and(shift = []) then begin
    if flNumber<>'' then
      addPLUcode(flNumber,'1000')
    else begin
      FRBeep;
      formShowMessage.Show('Укажите ПЛУ!');
    end;
    flNumber:='';
    stNumber.Caption:='0';
    key:=0;
    exit;
  end;
 if  (key=113 )and(shift = [ssAlt]) then begin
    BitBtn6Click(nil);  // Возврат товара
    key:=0;
    exit;
  end;
 if (key=112 )and(shift = []) then begin
    flNumber:=StringReplace( flNumber,',','.',[rfReplaceAll]);
    BitBtn3Click(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
 if (key=119 )and(shift = []) then begin  // open Draw
    BitBtn4Click(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
  if (key=120 )and(shift = []) then begin {Внесение [F9]}
    if formspusers.GetPolice(formstart.flCurUserId).storno then bbVnestiClick(nil)
    else  begin FRBeep; formShowMessage.Show('Недостаточно прав!') ; end;
    //showmessage('F1')
    key:=0;
    exit;
    end;
  if (key=121 )and(shift = []) then begin {Выплата [F10]}
    if formspusers.GetPolice(formstart.flCurUserId).storno then bbViplataClick(nil)
    else  begin FRBeep; formShowMessage.Show('Недостаточно прав!'); end;
    //showmessage('F1')
    key:=0;
    exit;
    end;
 if (key=122 )and(shift = []) then begin
    if formspusers.GetPolice(formstart.flCurUserId).cancelcheck then
       clearcheck()
      else  begin
       FRBeep;
       formShowMessage.Show('Недостаточно прав!') ;
      end;
    key:=0;
    exit;
  end;

 if (key=123 )and(shift = []) then begin
    bbblockscreenclick(nil);
    key:=0;
    exit;
    end;

 if ( (hi(key) = 0) and (char(lo(key)) in ['!'..'z']) ) and ( shift = [] ) then
     exit;
 //showmessage('key='+inttostr(key));
 Shift:=[];
 key:=0;
 StringGrid1.SetFocus;
end;

procedure TFormSalesBeerTS.FormPaint(Sender: TObject);

begin

end;

procedure TFormSalesBeerTS.FormResize(Sender: TObject);
begin
  FormSalesBeerTS.WindowState:=wsMaximized;

end;
{Автоформирование вида формы

}
procedure TFormSalesBeerTS.FormShow(Sender: TObject);
var
  str1:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  query:string;
begin
 self.InitTableShems();
 //formstart.DB_checkCol('doccash','closecheck','char(1)',''); // === "1" or "+"  - закрыть чек  - завершена полностью операция по чеку
 panel18.Visible:=false;

 FormVisualSelectTable.flSelectTableid:='';
 if  db_boolean(formStart.GetConstant('frmchkdisablecode')) then
     StringGrid1.Columns.Items[0].Visible:=false
   else
     StringGrid1.Columns.Items[0].Visible:=true;
 BitBtn10.Visible:=DB_Boolean(formStart.getConstant('enableprecheck'));
 BitBtn14.Visible:=DB_Boolean(formStart.getConstant('enableprecheck'));
 if DB_Boolean(formstart.GetConstant('precheckclose')) then
   begin
     bitbtn14.Visible:=false;
   end else begin
     bitbtn10.Visible:=false;
   end;
 if formstart.flBBQMode then begin
    panel18.Visible:=not formstart.fldisableutm;
    bbVisualFindGoods.Visible:=false;
    StringGrid1.Columns.Items[0].Visible:=false;
    StringGrid1.Columns.Items[2].Visible:=false;
    StringGrid1.Columns.Items[12].Visible:=false;
    //pnlSprGoods.Width:=(Width div 3)*2;
    Panel14.Align:=alLeft;
    Panel14.Width:=424;
    Panel17.Align:=alClient;
    Panel17.Width:=screen.Width-425;
    pnlSprGoods.Width:=screen.Width-425;
    pnlSprGoods.Height:=Screen.Height-ToolBarTopPanel.Height-Panel1.Height-5-64;
    pnlSprGoods.Align:=alClient;
    pnlSprGoods.visible:=true;
  //  FormVisualSelectGoods.parent:=
    FormVisualSelectGoods.Parent:=pnlSprGoods AS TWinControl;
    FormVisualSelectGoods.Top:=0;
    FormVisualSelectGoods.Left:=0;
    FormVisualSelectGoods.BorderStyle:=bsNone;
    FormVisualSelectGoods.Align:=alClient;
    formVisualSelectGoods.flActWriteOff:=false;
    flgResto:=true;
    panel2.Height:=170;
    pnlFastGoods.Visible:=false;
    panel3.Visible:=false;
    stNumber.Visible:=true;//
    stSumma.Align:=alTop;
    stSumma.height:=63;
    stSumma.font.Size:=32;
    FormVisualSelectGoods.Visible:=true;
    flMultiTable:=formstart.flMultiTable;
    if flMultiTable then begin
      bitbtn15.Visible:=true;
      bbDeferredCheck.Visible:=false;
      bbRetDeferredCheck.Visible:=false;
      pnlSelectTable:= Tpanel.Create(nil);
      pnlSelectTable.Align:=alNoNe;
      pnlSelectTable.Width:=510;
      pnlSelectTable.Height:=300;
      pnlSelectTable.Parent:=self AS TWinControl;
      pnlSelectTable.Top:=89;
      pnlSelectTable.Left:=10;
      pnlSelectTable.Visible:=false;
      pnlSelectTable.Color:=clBlack;
      FormVisualSelectTable.Parent:=pnlSelectTable AS TWinControl;
      FormVisualSelectTable.Align:=alClient;
      FormVisualSelectTable.BorderStyle:=bsNone;
      FormVisualSelectTable.Visible:=true;
      pnlSelectTable.Visible:=false;
      end;
  end else begin
    Panel17.Width:=176;
   //bbVisualFindGoods.
    bbVisualFindGoods.Visible:=db_boolean(formstart.GetConstant('visiblevisualfind'));
  end;
  flCurUserName:=formspusers.GetPolice(formstart.flCurUserId).fullname;
  str1:=formStart.GetConstant('LastNumCheck');
   if str1='' then
    str1:='0';
  flNumCheck:=strtoint(str1)+1;



  // ====== отобразить визпоиск ======
  //flgResto:=db_boolean( formStart.getConstant('enableresto'));
  pnlSprGoods.Width:=176*4;
  pnlsprGoods.Visible:=flgResto;

  // === fast goods ====
  xrecbuf:= formstart.DB_query('SELECT `numkass`,`numhw`,`alckass`,`nalogrn`,`fnnumber`,`banking`,`kassirname`,`taxtype` FROM `sprkass` WHERE `numkass`='''+formstart.prefixClient+''';');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    //stringgrid1.Cells[1,i]:=xrowbuf[0];
    flMFKKT:=xrowbuf[1];
    ///stringgrid1.Cells[3,i]:=xrowbuf[2];
    flRNKKT:=xrowbuf[3];
    flFNNumber:=xrowbuf[4];
    if xrowbuf[5]<>'' then
      flSBDep:=Strtoint(xrowbuf[5]);
   // stringgrid1.Cells[6,i]:=xrowbuf[5];
   // stringgrid1.Cells[7,i]:=xrowbuf[6];
   flTaxType:= xrowbuf[7];
  end;

  // === Инфо кассы
  { formstart.AutoUpdateGoods}
  Query:='SELECT `id`,`plu`,`name`,`price` FROM `sprfastgood`;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
//     if xrowbuf[0]='1' then begin
//       ArrFastGood[1]:=xrowbuf[1];
//       StaticText3.Caption:='Код '+xrowbuf[1];
//       StaticText4.Caption:=xrowbuf[2];
//       StaticText5.Caption:=xrowbuf[3]+' руб';
//     end;
     if xrowbuf[0]='1' then begin
       ArrFastGood[1]:=xrowbuf[1];
       StaticText3.Caption:='Код '+xrowbuf[1];
       StaticText4.Caption:=xrowbuf[2];
       StaticText5.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='2' then begin
       ArrFastGood[2]:=xrowbuf[1];
       StaticText9.Caption:='Код '+xrowbuf[1];
       StaticText10.Caption:=xrowbuf[2];
       StaticText11.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='3' then begin
       ArrFastGood[3]:=xrowbuf[1];
       StaticText13.Caption:='Код '+xrowbuf[1];
       StaticText14.Caption:=xrowbuf[2];
       StaticText15.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='4' then begin
       ArrFastGood[4]:=xrowbuf[1];
       StaticText17.Caption:='Код '+xrowbuf[1];
       StaticText18.Caption:=xrowbuf[2];
       StaticText19.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='5' then begin
       ArrFastGood[5]:=xrowbuf[1];
       StaticText21.Caption:='Код '+xrowbuf[1];
       StaticText22.Caption:=xrowbuf[2];
       StaticText23.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='6' then begin
       ArrFastGood[6]:=xrowbuf[1];
       StaticText25.Caption:='Код '+xrowbuf[1];
       StaticText26.Caption:=xrowbuf[2];
       StaticText27.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='7' then begin
       ArrFastGood[7]:=xrowbuf[1];
       StaticText29.Caption:='Код '+xrowbuf[1];
       StaticText30.Caption:=xrowbuf[2];
       StaticText31.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='8' then begin
       ArrFastGood[8]:=xrowbuf[1];
       StaticText33.Caption:='Код '+xrowbuf[1];
       StaticText34.Caption:=xrowbuf[2];
       StaticText35.Caption:=xrowbuf[3]+' руб';
     end;
     if xrowbuf[0]='9' then begin
       ArrFastGood[9]:=xrowbuf[1];
       StaticText37.Caption:='Код '+xrowbuf[1];
       StaticText38.Caption:=xrowbuf[2];
       StaticText39.Caption:=xrowbuf[3]+' руб';
     end;
    xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  stUTMStatus.Visible:= not formStart.fldisableutm;
   if not (formStart.flDemoMode OR formStart.fldisableutm) then begin
     str1:=formStart.SaveToServerGET('','');
     if str1='' then
       begin
         FRBeep;
         formShowMessage.Show('Нет связи с УТМ!');
         stUTMStatus.Font.Color:=clRed;
         exit;
       end else begin
         stUTMStatus.Font.Color:=clLime;
       end;
   end;
   str1:=FormStart.GetConstant('TypeKKM');
   if str1='' then
       flTypeKKM:=0
     else
       flTypeKKM:=StrToInt(str1);
  GetStatusFR(false);
  flPrefixCheck:= Formstart.GetConstant('PrefixCheck');
  if flPrefixCheck = '' then
   flPrefixCheck:='00';
  if flTypeKKM =1 then
    OleFR.OpenCheck () ;
  flCurUserName:=formspusers.GetPolice(formstart.flCurUserId).fullname;
  clearcheck();
  flGroupIdCigar:=formstart.GetConstant('groudidcigar');
end;

procedure TFormSalesBeerTS.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
 ParValue:='';
 if ParName='num' then begin
    ParValue:=inttostr(indCheck);
 end;
 if ParName='name' then
     ParValue:=Stringgrid1.Cells[2,indCheck];
if ParName='price' then
     ParValue:=Stringgrid1.Cells[3,indCheck];
if ParName='count' then
     ParValue:=Stringgrid1.Cells[4,indCheck];
 if ParName='summ' then
     ParValue:=Stringgrid1.Cells[5,indCheck];
{ if ParName='date' then
     ParValue:=rowbuf[5];    }

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
 if ParName='numdoc' then
      ParValue:=inttostr(flNumCheck)+' '+FormatDateTime('DD.MM.YYYY',now());
 if ParName='summtitle' then
      ParValue:=SummTitle(flallsumma);
 if ParName='firmname' then
      ParValue:=formstart.FirmFullName;
 if ParName='firmname' then
      ParValue:=formstart.FirmFullName;
 if ParName='innkpp' then
      ParValue:=formstart.FirmINN+'/'+formStart.firmkpp;
 if ParName='address' then
      ParValue:=formstart.FirmAddress;
end;

procedure TFormSalesBeerTS.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
   if indCheck>=Stringgrid1.RowCount then
      eof:=true
     else
      eof:=false;
end;

procedure TFormSalesBeerTS.frUserDataset1Next(Sender: TObject);
begin
  indCheck:=indCheck+1;
end;

procedure TFormSalesBeerTS.MenuItem1Click(Sender: TObject);
begin
   CloseDaySB();
end;

procedure TFormSalesBeerTS.MenuItem2Click(Sender: TObject);
begin
  GetReport();
end;

procedure TFormSalesBeerTS.miXReportClick(Sender: TObject);
begin
  if formloginadmin.showmodal=1377 then begin
    addtrans(formStart.prefixClient,inttostr(flNumCheck),'60','0','1','0','0','','','');
    self.PrintXReport();
    GetReport();
    GetStatusFR(true);
  end;
end;

procedure TFormSalesBeerTS.miZReportClick(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.Panel10Click(Sender: TObject);
begin
  if ArrFastGood[6]<>'' then
  addPLUcode(ArrFastGood[6],'1000');
  //  ShowMessage('Fast key6');

end;

procedure TFormSalesBeerTS.Panel10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel10.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel11Click(Sender: TObject);
begin
  if ArrFastGood[7]<>'' then
    addPLUcode(ArrFastGood[7],'1000');

end;

procedure TFormSalesBeerTS.Panel11MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel11.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel12Click(Sender: TObject);
begin
  if ArrFastGood[8]<>'' then
    addPLUcode(ArrFastGood[8],'1000');

end;

procedure TFormSalesBeerTS.Panel12MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel12.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel13Click(Sender: TObject);
begin
  if ArrFastGood[9]<>'' then
    addPLUcode(ArrFastGood[9],'1000');

end;

procedure TFormSalesBeerTS.Panel13MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel13.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel18Click(Sender: TObject);
begin
 formactwriteoffts.ShowModal;
end;

procedure TFormSalesBeerTS.Panel2Resize(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.Panel5Click(Sender: TObject);

begin
  if ArrFastGood[1]<>'' then
    addPLUcode(ArrFastGood[1],'1000');

end;

procedure TFormSalesBeerTS.Panel5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel5.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel5.borderstyle:=bsNone;
  panel6.borderstyle:=bsNone;
  panel7.borderstyle:=bsNone;
  panel8.borderstyle:=bsNone;
  panel9.borderstyle:=bsNone;
  panel10.borderstyle:=bsNone;
  panel11.borderstyle:=bsNone;
  panel12.borderstyle:=bsNone;
  panel13.borderstyle:=bsNone;
end;

procedure TFormSalesBeerTS.Panel6Click(Sender: TObject);
begin
  if ArrFastGood[2]<>'' then
    addPLUcode(ArrFastGood[2],'1000');

end;

procedure TFormSalesBeerTS.Panel6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel6.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel7Click(Sender: TObject);
begin
  if ArrFastGood[3]<>'' then
    addPLUcode(ArrFastGood[3],'1000');

end;

procedure TFormSalesBeerTS.Panel7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel7.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel8Click(Sender: TObject);
begin
  if ArrFastGood[4]<>'' then
    addPLUcode(ArrFastGood[4],'1000');

end;

procedure TFormSalesBeerTS.Panel8MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel8.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.Panel9Click(Sender: TObject);
begin
  if ArrFastGood[5]<>'' then
   addPLUcode(ArrFastGood[5],'1000');

end;

procedure TFormSalesBeerTS.Panel9MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel9.borderstyle:=bsSingle;
end;

procedure TFormSalesBeerTS.pnlRetDeferredCheckResize(Sender: TObject);
var
  i:integer;
begin

  bbretdeferredcheck1.Visible:=true;
end;

procedure TFormSalesBeerTS.pnlService1Click(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.pnlServiceClick(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.StaticText4MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  panel5.borderstyle:=bsNone;
  panel6.borderstyle:=bsNone;
  panel7.borderstyle:=bsNone;
  panel8.borderstyle:=bsNone;
  panel9.borderstyle:=bsNone;
  panel10.borderstyle:=bsNone;
  panel11.borderstyle:=bsNone;
  panel12.borderstyle:=bsNone;
  panel13.borderstyle:=bsNone;
end;

procedure TFormSalesBeerTS.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efefff, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin


    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[aRow mod 2];
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 2];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);

end;

procedure TFormSalesBeerTS.StringGrid1Resize(Sender: TObject);
var
   namesize:integer;
   i:integer;
begin
  namesize:=StringGrid1.Width;
  for i:=0 to Stringgrid1.Columns.Count-1 do
   if i<>1 then
    namesize:=namesize - StringGrid1.Columns.Items[i].Width;
  namesize:=namesize-3;
  StringGrid1.Columns.Items[1].Width:=namesize;

end;

procedure TFormSalesBeerTS.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
   if arow>0 then
     flSelRow:=aRow;
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   //stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
   //stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end else
  begin
   stBarcode.Caption:='';
   stPDF417.Caption:='';
   //stLitr.Caption:='';
   //stAlcValue.Caption:= '';
  end;
end;

procedure TFormSalesBeerTS.TimerHWTimer(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.ToolBar1Click(Sender: TObject);
begin

end;

procedure TFormSalesBeerTS.MyExceptHandler(Sender: TObject; E: Exception);
begin

end;

// ========  минимальные функции для ККМ =======================================
function TFormSalesBeerTS.PrintLineStringAnsi(const aStr: ansiString;dblStr:boolean = false): integer;
var
  i:byte;
  str1:WideString;
  ires:integer;

begin
  str1:=aStr;
  if (FlgLoadLibFR) then
   begin                     //12345678901234567890123456789012345678901234567890
     try
      case fltypeKKM of
       0:begin
         OleFR.Password:=30;
         OleFR.StringForPrinting:= str1;

         i:=3;
         repeat
         ires:=0;
               if dblStr  then
                 OleFR.PrintWideString()
               else
                 OleFR.PrintString();
              ires:=OleFr.ResultCode;

           if ires<>0 then begin
            if ires=88 then
              OleFR.ContinuePrint()
            else begin
              if ires = 80 then
                sleep(200)
              else begin
               if (ires=-1)or(ires=-8) then
               begin
                FRBeep;
                 formShowMessage.Show('Потеряна связь с ККМ, попытка восстановить. Нажмите "ОК".');

                 OleFR.Password:=30;
                 OleFR.Disconnect(){};
                 sleep(1000);
                 OleFR.Connect(){};
               end
               else begin
                 FRBeep;
                  formShowMessage.Show('Ошибка при печате:'+inttostr(ires)+'. Исправьте и нажмите "ОК".');
                end;
              end;
             end;
           end;
           i:=i-1;
         until (ires = 0)or(i<=0) ;

         if i<=0 then begin
          FRBeep;
           formShowMessage.Show('Неустранимая ошибка при печате:'+inttostr(ires)+'.');
         end;

       end;
       1:begin
         if flg_dto_10 then begin
           OleFR.setParam(OleFR.LIBFPTR_PARAM_TEXT,dblStr);
           OleFR.printText();
         end else begin
           OleFR.FontDblHeight := dblStr;
           OleFR.Caption:=Str1;
           OleFR.PrintString();
         end;
       end;
       2:begin
         if dblStr then
           VIKIPrintString(ansitoutf8(str1),0)
         else
           VIKIPrintString(ansitoutf8(str1),1);
       end;
       3:begin
         //OleFR.FontDblHeight := dblStr;
         OleFR.Caption:=Str1;
         OleFR.PrintString();
       end;
       4:begin
         if dblStr then
           OleFR.PrintFreeTextInFiscalInv(Str1,48,48,49,48,48,48)
         else
           OleFR.PrintFreeTextInFiscalInv(Str1,48,48,48,48,48,48);
       end;
      end;
     except
       result:=-1;
       exit;
     end;
   end
  else
  result:=0;
end;

function TFormSalesBeerTS.PrintLineStringWide(const aStr: WideString;
  dblStr: boolean): integer;
begin
  result:=0;
end;

procedure TFormSalesBeerTS.ShowKKMOption();
begin
  // Отображает параметры ККМ
  if FlgLoadLibFR then begin
     case flTypeKKM of
       0:OleFR.ShowProperties();
       1: if flg_dto_10 then
              OleFR.showProperties(OleFR.LIBFPTR_GUI_PARENT_NATIVE,self.Handle)
          else
              OleFR.ShowProperties();
       3:OleFR.ShowSettings();
     end;
  end;
end;

procedure TFormSalesBeerTS.PrintZReport();
var
  res:integer;
  nRep,nFD,SignFP: Integer;
  Sum1,Sum2,Sum3,Sum4,Sum5,Sum6: Double;
  Ret1,Ret2,Ret3,Ret4,Ret5,Ret6: Double;
  Purch1,Purch2,Purch3,Purch4,Purch5,Purch6: Double;
  RetPurch1,RetPurch2,RetPurch3,RetPurch4,RetPurch5,RetPurch6: Double;
  i:integer;
begin
  // Отчет без гашения ККМ
  if FlgLoadLibFR then begin
     case flTypeKKM of
       0: begin
         if not flMultiSection  then begin
           OleFR.PrintReportWithoutCleaning();
           res:= OleFR.resultCode;
           if res <> 0 then begin
              formShowMessage.Show('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                        ' вставьте новый рулон и нажмите "Ок".' );
              OleFR.Password:=30;
              OleFR.InterruptFullReport();
              res:= OleFR.ECRAdvancedMode;
            end;
          end else begin
             if not (SummCheck.depCash='') then begin
                OleFR.LDNumber:=Strtoint(SummCheck.depCash);
                OleFR.SetActiveLD;
               end;
                OleFR.Password:=30;
                OleFR.PrintReportWithoutCleaning();
           end;
         end;
       1:begin // == ATOL ===
         if flg_dto_10 then begin
            // ===== LOGIN USER =============
            SetCurrentKassirName();
            OleFR.cancelReceipt();
            // ==============================
            OleFR.setParam(OleFR.LIBFPTR_PARAM_REPORT_TYPE, OleFR.LIBFPTR_RT_X);
            OleFR.report;
            OleFR.checkDocumentClosed;
         end
         else begin
           OleFR.Password := 30;
           OleFR.CancelCheck () ;
           OleFR.Mode := 2;   // Режим отчетов без гашения
           OleFR.Password := 30;  // Пароль системного администратора
           OleFR.SetMode();
           OleFR.ReportType :=2;
           OleFR.Report();
         end;
       end;
       2:begin
         VIKIPrintXReport('Kassir');
       end;
       3:begin
         OleFR.Mode := 2;   // Режим отчетов без гашения
         OleFR.Password := 30;  // Пароль системного администратора
         OleFR.OperatorPassword := 30;  // Пароль системного администратора
         OleFR.SetMode();
         OleFR.ReportType :=2;
         OleFR.Report();
       end;
       4:begin
         OleFR.PrintReport(Byte('X'),nRep,nFD,SignFP,Sum1,Sum2,Sum3,Sum4,Sum5,Sum6,
      Ret1,Ret2,Ret3,Ret4,Ret5,Ret6,
      Purch1,Purch2,Purch3,Purch4,Purch5,Purch6,
      RetPurch1,RetPurch2,RetPurch3,RetPurch4,RetPurch5,RetPurch6);
       end;
     end;
  end;
end;

procedure TFormSalesBeerTS.PrintXReport();
var
  res:integer;
  i:integer;
begin
  // Отчет с гашением ККМ
  if FlgLoadLibFR then
  case flTypeKKM of
    0:begin
      if not flMultiSection  then begin
        OleFR.PrintReportWithCleaning();
        res:= OleFR.ResultCode;
        if res <>0 then begin
           formShowMessage.Show('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                       'вставьте новый рулон и нажмите "Ок".' );
           OleFR.Password:=30;
           OleFR.InterruptFullReport();
           res:= OleFR.ECRAdvancedMode;
         end;
       end else begin
         if  SummCheck.depCash='' then
            OleFR.LDNumber:=0
          else begin
             OleFR.LDNumber:=strtoint(SummCheck.depCash);
             OleFR.SetActiveLD;
          end;
         OleFR.Password:=30;
         OleFR.PrintReportWithCleaning();

       end;
    end;
    1:begin
      if flg_dto_10 then begin
         // ===== LOGIN USER =============
         self.SetCurrentKassirName();
         OleFR.cancelReceipt();
         // ==============================
         OleFR.setParam(OleFR.LIBFPTR_PARAM_REPORT_TYPE, OleFR.LIBFPTR_RT_CLOSE_SHIFT);
         OleFR.report;
         OleFR.checkDocumentClosed;
      end
      else begin
         OleFR.Password := 30;
         OleFR.CancelCheck () ;
         OleFR.Mode := 3;   // Режим отчетов без гашения
         OleFR.Password := 30;  // Пароль системного администратора
         OleFR.SetMode();
         OleFR.ReportType :=1;
         OleFR.Report();
      end;
    end;
    2:begin
      VIKIPrintZReport('Kassir',0);
    end;
    3:begin
      OleFR.Mode := 3;   // Режим отчетов без гашения
      OleFR.OperatorPassword := 30;  // Пароль системного администратора
      OleFR.Password := 30;  // Пароль системного администратора
      OleFR.SetMode();
      OleFR.ReportType :=1;
      OleFR.Report();
    end;
  end;

end;

procedure TFormSalesBeerTS.PrintBankReport();
begin
  // Отчет По банку
//  if FlgLoadLibSB then
//   CloseDaySB();
//     OleFR.PrintReportWithCleaning();
end;

procedure TFormSalesBeerTS.PrintInkass();
begin
  // Отчет Инкассация
  if FlgLoadLibFR then
//     OleFR.PrintReportWithCleaning();
end;

procedure TFormSalesBeerTS.PrintDepReport();
begin
  // Отчет по отделам
  if FlgLoadLibFR then
     OleFR.PrintDepartmentReport();

end;

function TFormSalesBeerTS.GetStatusFR(Messages: boolean): Integer;
var
  OldstatusFR:integer;
  i:integer;
begin
 result:=0;
 if FlgLoadLibFR then begin
 if fltypekkm=0 then  begin
     // ******* обработка состояния ккм **************
    if not (SummCheck.depCash='') then
     self.ActiveDep();
     OldStatusFR:=OleFR.ResultCode;
     if OldStatusFR <> 0 then begin
       case OldStatusFR of
         100:showmessage('Ошибка ФП!');
         113:begin
            formShowMessage.Show(
            'Ошибка отрезчика!'+#13#10+
            ' Попробуйте выключить аппарат, открыть крышку.'+#13#10+
            ' Удалить бумагу, вернуть нож отрезчика наместо и  включить устройство.'+#13#10+
            'Как просигналит аппарат нажмите кнопку "Ок"');
            result:=GetStatusFR(Messages);
            if result>=0 then
              exit;
         end;
         78: Showmessage('Не закрыта предыдущая смена!');
         116: Showmessage('Ошибка ОЗУ, требуется тех. обнуление.');
         -8,-1:begin
             OleFR.Password:=30;
                 OleFR.Disconnect(){};
                 sleep(1000);
                 OleFR.Connect(){};
         end
         else
           formstart.fshowmessage('Ошибка ККМ (1):'+inttostr(OldStatusFR));
       end;
       result:=-1;
       exit;
     end;
     OleFR.Password:=30;
     OleFR.GetECRStatus();
     result:=OleFR.ECRMode;
     if result in [0,2,3,4] then begin
       if result = 3 then // принудительно закрываем смену.
          PrintXReport();
       result:=0 ;
       exit;
     end;
    if result = 8 then begin
      FRBeep;
      if messages then
        showmessage('Будет отменен предыдущий чек!' );
      OleFR.Password:=30;
      OleFR.CancelCheck();
      result:=0;
     end;
     result:= OleFR.ECRAdvancedMode;
     if result = 1 then begin
         FRBeep;
         showmessage('Вставьте бумага в ККМ и нажмите "Ок".' );
         OleFR.Password:=30;
         OleFR.GetECRStatus();
         result:= OleFR.ECRAdvancedMode;
         if result<>0 then
           begin
             result:=-1;
             exit;
           end;
       end;
      if result = 3 then begin
          OleFR.Password:=30;
          OleFR.ContinuePrint ();
          result:= OleFR.ECRAdvancedMode;
          if result<>0 then
            begin
              result:=-1;
              exit;
            end;
        end;
     if result = 8 then begin
       FRBeep;
       if messages then
        showmessage('Будет отменен предыдущий чек!' );
        OleFR.Password:=30;
        OleFR.CancelCheck();
        result:=-1;
       end;
     result:=OleFR.GetStatus() ;
  end;

    if fltypekkm=1 then
    begin
     OleFR.DeviceEnabled := 1;
     result:= OleFR.ResultCode ;
     case result of
       -3822: PrintXReport();
     else
       if result<>0 then
         begin
          showmessage('Ошибка ККМ (2):'+IntToStr(result)) ;
          result:= OleFR.ResultCode ;
         end;
     end;
    end;
   if fltypekkm=2 then
     result:=0;

   if fltypekkm=3 then
   begin
   // OleFR.DeviceEnabled := 1;
    result:= OleFR.ResultCode ;
    case result of
      32694: PrintXReport();
    else
      if result<>0 then
        begin

         showmessage('Ошибка ККМ:('+IntToStr(result)+')'+AnsiToUtf8(AnsiString(OleFR.ResultDescription))) ;
       //  OleFR.GetLastError  ;
         result:= OleFR.ResultCode ;
        end;
    end;
   end;
 end;
end;

function TFormSalesBeerTS.GetNumberCheck(): Integer;
begin
  result:=0;
end;

function TFormSalesBeerTS.PrintLineGood(aname: String; count: String;dblStr:boolean = false): integer;
var
  sz1:integer;
  str0,
  str1:ansistring;
  str2:ansiString;
  SpaceStr1:ansiString;
  tmpSz:integer;
begin
  tmpSz:= SizeStrFr;
  if dblStr then
     tmpSz:= SizeStrFr div 2;
  str0:='';
  str1:=Utf8ToAnsi(aname);
  str2:=Utf8ToAnsi(count);
  if length(str1)> (tmpSz-Length(str2)) then begin
   str0:=copy(str1,1,tmpSz-5);
   str1:=copy(str1,tmpSz-4,tmpSz-Length(str2));
  end;
  SpaceStr1:='';
  for sz1:=(Length(str1)+Length(str2)) to tmpSz-1 do
    SpaceStr1:=SpaceStr1+' ';

  if FlgLoadLibFR then
   begin
    if str0<>'' then
      PrintLineStringAnsi(str0,dblStr);
    PrintLineStringAnsi(str1+SpaceStr1+str2,dblStr);
    // PrintLineStringAnsi(' ');
   end; {else
    showmessage('Не подключен ФР'); }
  result:=0;
end;

function TFormSalesBeerTS.PrintLineString(const aStr: String; dblStr:boolean = false): integer;
begin
  result:=PrintLineStringAnsi(Utf8ToAnsi(astr),dblstr);
end;

function TFormSalesBeerTS.StrCenter(const aStr: String): String;
begin

end;

{
В связи с участившимися обращениями в адрес службы технической поддержки сообщаем, что в текущих версиях (от 29.04.19) обновлений программного обеспечения контрольно-кассовой техники производства ГК «ШТРИХ-М», доступных для скачивания авторизированным пользователям в ЛК ЦТО, реализована возможность передачи на серверы ОФД и ФНС, в том числе следующих тегов:

Тег 1057 – Признак Агента;
Тег 1162 – Код товарной номенклатуры (применяется при реализации товаров, подлежащих обязательной маркировке);
Тег 1192 – Дополнительный реквизит чека (БСО);
Тег 1203 – ИНН Кассира;
Тег 1222 – Признак Агента по предмету расчета;
Тег 1224 – Данные поставщика;
Тег 1225 – Наименование поставщика;
Тег 1227 - Наименование покупателя;
Тег 1228 - ИНН покупателя;
Тег 1229 - Акциз;
Тег 1230 - Код страны происхождения товара;
Тег 1231 – Номер таможенной декларации».

Организовать передачу вышеприведенных тегов вы можете при помощи методов драйвера ККТ: FNSendTag, FNSendTagOperation и других.

Для передачи информации о товарах, подлежащих маркировке (тег 1162), вы можете использовать метод драйвера ФР: FNSendItemCodeData.

Ознакомится со списком всех изменений в программном обеспечении можно здесь.
{
// Версия с прямой записью Тэг значения в ФН
SerialNumber:=utf8toansi(  Copy(StringGrid1.Cells[19,ii],15,7) );
GTIN:=StrtoInt(Copy(StringGrid1.Cells[19,ii],1,14));
TLVData:= IntToHex( GTIN,6);
for i:=1 to 7 do
   TLVData:=TLVData+inttoHex(ord(SerialNumber[i]),2);

TLVData:='8A04'+inttohex((length(TLVData) div 2),2)+'00444D'+TLVData;
strw :=StrToWide(utf8toansi(TLVData));
OleFR.TLVData:= strw;
OleFR.FNSendTLVOperation();}
}


function TFormSalesBeerTS.OrderSale(aOperBank: boolean): integer;

function findNumber(aStr:string):integer;
var
  i:integer;
begin
 result:=0;
 for  i:=1 to length(aStr) do
  if aStr[i] in ['0'..'9'] then
    begin
     result:=i;
     break;
    end;
end;
function get_gtin_sn(astr:string; var gtin,sn:string):boolean;
var
    s1:string;
    i:integer;
begin
    result:= True;
    s1:=copy(astr,1,2);
    if s1 = '01' then begin
        gtin := copy(astr,3,14);
        sn := copy(astr,19,6);
        result:= True;
    end
    else begin
         gtin := copy(astr,1,14);
         sn := copy(astr,15,7);
         result:= True;
    end;


end;

var
  ItemCode1162:String; //Код товара для тега 1162
  // маркированный товар
  gtin_str:string;
  sn_str:string;

  resFR:integer;
  ii:INTEGER;
  strw:widestring;
  strw1:widestring;
  depInt:integer;
  countpop:integer;
  SubTotal:real;
  ch1:byte;
  res:integer;
  retAMount:Double;
  nFD,SignFP,nShift,SlipNumber,nDoc: Integer;
  tlvdata:ansistring;
  //GTIN:LongInt;
  //SerialNumber:AnsiString;
  startnum:integer;
  goods:integer;
  // ==== Переменные для эмулятора ===
  em_Quantity,
  em_summ,
  em_all_summ,
  em_price:float;

begin
  result:=-1;
  tlvdata :='';
  //  flallsumma - Сумма чека
  // проверяем сумма больше 0
  if flAllSumma<=0 then
   exit;
  //  flallsumma
  strw1:='ПРОДАЖА';
  // -- Здесь проверить наличные с суммой чека!!!
  if (flAllSumma)> flInpSumm then
      flInpSumm:=(flAllSumma);
  if SummCheck.depCash = '' then
      SummCheck.depCash:='0';
  if aOperBank then
     FormStart.DB_query('UPDATE `doccash` SET `banking`="+" WHERE `kassir`="'+formStart.prefixClient+'" AND `numdoc`="'+inttostr(flNumCheck)+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";');

  SubTotal:=GetSummDep(); // Всего в чеке
  // ---------------------------------------------
  if FlgLoadLibFR then begin
      case flTypeKKM of
        0:begin  // =========== Штрих-М

          //self.ActiveDep();
          OleFR.WaitForPrinting();
          OleFR.Password:=30;
          OleFR.GetECRStatus();
          result:=OleFR.ECRMode;
          if result = 8 then begin // 74 - Чек открыт
             em_summ := OleFR.Summ1;
             em_summ := em_summ + OleFR.Summ2;
             if em_summ > 0 then
               OleFR.CloseCheck();
          End;


          result:=-1;
          for ii:=1 to StringGrid1.RowCount-1 do begin
              {if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                OleFR.Password:=30;
                strw := StrToWide(utf8toansi(StringGrid1.Cells[19,ii]));
                OleFR.BarCode := strw;
                OleFR.ItemStatus := 1;
                OleFR.CheckItemMode := 0;
                OleFR.FNCheckItemBarcode();
                result:=OleFR.ResultCode;
                if result <> 0 then begin
                  ShowMessage('Error FNCheckItemBarcode:'+OleFR.ResultCodeDescription+' BC:'+StringGrid1.Cells[19,ii])
                end;
                OleFR.FNAcceptMarkingCode();
                result:=OleFR.ResultCode;
                if result <> 0 then begin
                  ShowMessage('Error FNAcceptMarkingCode:'+OleFR.ResultCodeDescription+' BC:'+StringGrid1.Cells[19,ii])
                end;
              end; }
              strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
               OleFR.Password:=30;
               OleFR.Quantity:=formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));
               if (flProcentSkid<>0.0) and (flProcentSkid<>100.0) then begin
                   OleFR.Price:= (formstart.StrToFloat(trim(StringGrid1.Cells[5,ii]))-formstart.StrToFloat(trim(Stringgrid1.Cells[13,ii])))/formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));
               end else
                   OleFR.Price:= formstart.StrToFloat(trim(StringGrid1.Cells[3,ii]));
               depInt:=0;
               if StringGrid1.Cells[15,ii]<>'' then
                  depInt:=strtoint(StringGrid1.Cells[15,ii]);
               OleFR.Department:=depInt;
               OleFR.Tax1:=0;
               OleFR.Tax2:=0;
               OleFR.Tax3:=0;
               OleFR.Tax4:=0;
               OleFR.CheckType:=1; // Приход (продажа)
               OleFR.Summ1Enabled :=False;
               OleFR.TaxValueEnabled := False;
               //1-если не маркируемый и 33, если маркируемый и акцизный, 31 - маркируем безакцизный
               {if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                  OleFR.PaymentItemSign := 31; // маркируем безакцизный
               end
               else}
               OleFR.PaymentItemSign := 1; // Товар

               OleFR.PaymentTypeSign := 4; // Полный расчет
               OleFR.StringForPrinting:=strw;
               OleFR.FNOperation();
               // ====== Добавляем сигареты ========
               if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                 startnum:=findnumber( StringGrid1.Cells[19,ii]);
                 if startnum = 0 then begin
                    ShowMessage('Ошибка добавления акцизного товара: "Не найден GTIN товара!" ['+StringGrid1.Cells[19,ii]+']');
                  end else begin

                   gtin_str:='';
                   sn_str:='';
                   if get_gtin_sn(StringGrid1.Cells[19,ii],gtin_str,sn_str) then
                       OleFR.MarkingType:=17485
                   else
                       OleFR.MarkingType:=5;
                   strw := StrToWide(utf8toansi(gtin_str));
                   OleFR.GTIN:=strw;
                   strw := StrToWide(utf8toansi(  sn_str ));
                   OleFR.SerialNumber :=strw;
                   OleFR.FNSendItemCodeData();
                   result:=OleFR.ResultCode;
                   if result <> 0 then begin
                      ShowMessage('Error FNCheckItemBarcode:'+OleFR.ResultCodeDescription+' BC:'+StringGrid1.Cells[19,ii]+' GTIN:'+gtin_str+' SN:'+sn_str);
                   end;
                   // ---- Старый вариант
                   //OleFR.MarkingType:=5; //OleFR.MarkingType:=17485; // --- Новый вариант - произвольный формат!!!
                   //strw := StrToWide(utf8toansi(Copy(StringGrid1.Cells[19,ii],startnum,14)));
                   //OleFR.GTIN:=strw;
                   //strw := StrToWide(utf8toansi(  Copy(StringGrid1.Cells[19,ii],startnum+14,7) ));
                   //OleFR.SerialNumber :=strw;
                   //OleFR.FNSendItemCodeData();
                   //if OleFR.ResultCode<>0 then
                   //   ShowMessage('Ошибка добавления акцизного товара:'+inttostr(OleFR.ResultCode)+' ['+StringGrid1.Cells[19,ii]+':'+TLVData+']')
                   //strw := StrToWide(utf8toansi(StringGrid1.Cells[19,ii]));
                   //OleFR.BarCode := strw;

                   //OleFR.FNSendItemBarcode();
                   //OleFR.ItemStatus := 1;
                   //OleFR.CheckItemMode := 0;
                   //OleFR.FNCheckItemBarcode();

                 end;
               end;

               OleFR.WaitForPrinting();
               if (flProcentSkid<>0) or (flProcentSkid<>100) then begin
                  OleFR.Password:=30;
                  OleFR.Summ1:=formstart.StrToFloat(trim(Stringgrid1.Cells[13,ii]));
                  OleFR.Discount();
               end;
            end;
            self.set_Customer_Email(FormInputSumm.flrecipientEmail);
            // === Получим сумму чека ===
            OleFR.Password:=30;
            OleFR.CheckSubTotal();
            SubTotal:= OleFR.Summ1;
            if SubTotal <= 0 then begin
               formstart.fshowMessage('Ошибка ККМ: Сумма чека меньше или равна 0!');
               SubTotal :=flallsumma;
            end;
            // === Получаем скидку ===
            OleFR.DiscountOnCheck:=0;  //  flallsumma - сумма чека
            if flallsumma<SubTotal then // Если внесено меньше суммы чека
                OleFR.DiscountOnCheck:=SubTotal-flallsumma; // считаем скидку
            OleFR.CheckSubTotal();
            SubTotal:= OleFR.Summ1;
            if SubTotal <= 0 then begin
               formstart.fshowMessage('Ошибка ККМ: Сумма чека меньше или равна 0!');
               SubTotal :=flallsumma;
            end;

            if  aOperBank then begin
               OleFR.Summ1:= 0;
               OleFR.Summ2:= SubTotal;
               SummCheck.inputsummNal:=SubTotal;
            end else begin
               OleFR.Summ1:= SubTotal;
               OleFR.Summ2:= 0;
            end;
            OleFR.Summ4:= 0;
            OleFR.Summ3:= 0;
            OleFR.Tax1:=0;
            OleFR.Tax2:=0;
            OleFR.Tax3:=0;
            OleFR.Tax4:=0;
            OleFR.StringForPrinting:='';
            OleFR.CloseCheck();
            result:=OleFR.ResultCode;
            if ( result = 107 ) or (result = 108 ) then begin
              formShowMessage.Show('Отсутстует бумага!');
              if  aOperBank then begin
                 OleFR.Summ1:= 0;
                 OleFR.Summ2:= SubTotal;
                 SummCheck.inputsummNal:=SubTotal;
              end else begin
                 OleFR.Summ1:= SubTotal;
                 OleFR.Summ2:= 0;
              end;
              OleFR.Summ4:= 0;
              OleFR.Summ3:= 0;
              OleFR.Tax1:=0;
              OleFR.Tax2:=0;
              OleFR.Tax3:=0;
              OleFR.Tax4:=0;
              OleFR.StringForPrinting:='';
              OleFR.CloseCheck();
            end;
            if result = 80 then
               OleFR.WaitForPrinting();
            result:=OleFR.ResultCode;
            if ( result = 107 ) or (result = 108 ) then begin
            end;


            flallsumma:= SubTotal;
            OleFR.WaitForPrinting();
            result:=OleFR.ResultCode;
            OpenDrawerAll;
            result:=OleFR.ResultCode;
        end;  // === END SHTRIH-M ===
        1:begin  // ==== ATOL10 =====
          if self.flg_dto_10 then begin
            OleFR.cancelReceipt();
            SetCurrentKassirName();
            OleFR.setParam(OleFR.LIBFPTR_PARAM_RECEIPT_TYPE, OleFR.LIBFPTR_RT_SELL);
            OleFR.openReceipt();
            OleFR.setParam(OleFR.LIBFPTR_PARAM_MARKING_CODE_TYPE, OleFR.LIBFPTR_MCT_OTHER);
            for ii:=1 to StringGrid1.RowCount-1 do begin
                strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
                OleFR.setParam(OleFR.LIBFPTR_PARAM_COMMODITY_NAME,strw);

                OleFR.setParam(OleFR.LIBFPTR_PARAM_PRICE,  formstart.StrToFloat(trim(StringGrid1.Cells[3,ii])));
                OleFR.setParam(OleFR.LIBFPTR_PARAM_QUANTITY,formstart.StrToFloat(trim(StringGrid1.Cells[4,ii])));
                OleFR.setParam(OleFR.LIBFPTR_PARAM_TAX_TYPE,OleFR.LIBFPTR_TAX_NO);
                if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                    OleFR.setParam(OleFR.LIBFPTR_PARAM_MARKING_CODE, trim(StringGrid1.Cells[19,ii]));
                end;
                goods:=1;
                OleFR.setParam(1212,goods);
            end;
            if  aOperBank then
              OleFR.setParam(OleFR.LIBFPTR_PARAM_PAYMENT_TYPE, OleFR.LIBFPTR_PT_ELECTRONICALLY)
            else
              OleFR.setParam(OleFR.LIBFPTR_PARAM_PAYMENT_TYPE, OleFR.LIBFPTR_PT_CASH);
            OleFR.setParam(OleFR.LIBFPTR_PARAM_PAYMENT_SUM, flInpSumm);
            OleFR.payment;
            resFR := OleFR.closeReceipt();
            if resFR <0 then
              ShowMEssage(OleFR.errorDescription);
            //fptr.checkDocumentClosed <> 0

          end else begin
          //flTaxType
            OleFR.Password := 30;
            if OleFR.CheckState() <> 0 then
              if OleFR.CancelCheck() <> 0 then
                 ShowMessage('Ошибка кассы!');
            OleFR.Password := 30;
            OleFR.Mode := 1;
            resFR := OleFR.SetMode();
            OleFR.Password := 30;
            OleFR.NewDocument();
            OleFR.CheckMode := 1;
            OleFR.CheckType := 1;
            resFR := OleFR.OpenCheck();


            // ==== строка чека
            for ii:=1 to StringGrid1.RowCount-1 do begin
              strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
              OleFR.Name := strw;

              OleFR.Price := formstart.StrToFloat(trim(StringGrid1.Cells[3,ii]));
              OleFR.Quantity := formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));


              depInt:=0;
              //showmessage('debug:Atol - dep  = '+StringGrid1.Cells[15,ii]);
              if (StringGrid1.Cells[15,ii]<>'') and (StringGrid1.Cells[15,ii]<>'0') then
                 depInt:= strtoint(StringGrid1.Cells[15,ii]);

              OleFR.Department := depInt;
              if flTaxType<>'' then
                 // TaxTypeNumber
                 OleFR.TaxTypeNumber:=strtoint(flTaxType) // Внимание !! Ставку по умолчанию указываем в настройках  !!!
              else
                 showmessage('Ошибка налоговой ставки  = '+flTaxType);

              resFR := OleFR.Registration() ;
              //showmessage('debug:Atol2-1  = '+trim(StringGrid1.Cells[4,ii]));
              if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                //ShowMessage('Сигареты'+StringGrid1.Cells[19,i]);
                OleFR.setParam(OleFR.LIBFPTR_PARAM_NOMENCLATURE_TYPE, OleFR.LIBFPTR_NT_TOBACCO);
                OleFR.setParam(OleFR.LIBFPTR_PARAM_GTIN, Copy(StringGrid1.Cells[19,ii],1,14));
                OleFR.setParam(OleFR.LIBFPTR_PARAM_SERIAL_NUMBER, Copy(StringGrid1.Cells[19,ii],15,7));
                OleFR.utilFormNomenclature();
                ItemCode1162 := OleFR.getParamByteArray(OleFR.LIBFPTR_PARAM_TAG_VALUE);
                OleFR.setParam(1162, ItemCode1162);
              end;
            end;

            //.. строка чека
            OleFR.Summ := flInpSumm;  // Сумма оплаты
            if  aOperBank then
               OleFR.TypeClose := 1
            else
              OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
            resFR := OleFR.Payment();
            resFR := OleFR.ResultCode;
            if resFR<>0 then
                showmessage('debug:Atol3  = '+inttostr(resFR));
            if  aOperBank then
              OleFR.TypeClose := 1
            else
              OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
            resFR := OleFR.CloseCheck() ;
            resFR := OleFR.ResultCode;
            if resFR<>0 then
                showmessage('Atol3  = '+inttostr(resFR));
            end;
          end;
          2:begin  {VIKI print}
             VIKIOpenDocument(2,1,'Kassir',flNumCheck);
             for ii:=1 to StringGrid1.RowCount-1 do begin
               if not VIKIAddPosition(StringGrid1.Cells[2,ii],StringGrid1.Cells[1,ii],formstart.StrToFloat(trim(StringGrid1.Cells[4,ii])),formstart.StrToFloat(trim(StringGrid1.Cells[3,ii])),
                ((StringGrid1.Cells[17,ii]<>'')and(StringGrid1.Cells[17,ii]<>'0')),formstart.StrToFloat(trim(StringGrid1.Cells[17,ii]))) then
                  showmessage('Ошибка при печати документа!');

             end;
             if aOperBank then
               VIKICloseCheck(1,flInpSumm,1)
             else
               VIKICloseCheck(0,flInpSumm,1);
          end ;
          3:begin

              OleFR.Mode := 1;
              OleFR.SetMode();
              OleFR.NewDocument();
              OleFR.CheckMode := 1;
              OleFR.CheckType := 1;
              OleFR.CorrType := -1;
              OleFR.OpenCheck;
              // ==== строка чека
              result:=OleFR.ResultCode;
              if OleFR.ResultCode<>0 then begin
                 GetStatusFR(true);
               end;

              for ii:=1 to StringGrid1.RowCount-1 do begin
                strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
                OleFR.Name := strw;
                OleFR.Price := formstart.StrToFloat(trim(StringGrid1.Cells[3,ii]));
                OleFR.Quantity := formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));
                depInt:=0;
                if StringGrid1.Cells[15,ii]<>'' then
                   depInt:= strtoint(StringGrid1.Cells[15,ii]);

                OleFR.Department := depInt;
                OleFR.Registration() ;
              end;
              //.. строка чека

              OleFR.Summ := flInpSumm;  // Сумма оплаты
              if  aOperBank then
                  OleFR.TypeClose := 1
                else
                  OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
              OleFR.Payment();

              OleFR.ClicheNum := 0;
              OleFR.TypeClose := 0;
              OleFR.CloseCheck() ;
              result:=OleFR.ResultCode;
              FRCutCheck();
            end;
          //--- ATOL
          4:begin
            OleFR.OpenFiscalInv(30,'30',1,byte('0'),'','','','',nFD,SignFP,nShift);
            result:=OleFR.ResultCode;
            //VIKIOpenDocument(3,0,'Kassir',flNumCheck);
            for ii:=1 to StringGrid1.RowCount-1 do begin
                DepInt:=1;
                if StringGrid1.Cells[15,ii]<>'' then
                  depInt:= strtoint(StringGrid1.Cells[15,ii]);
                OleFR.RegisterSale(
                 utf8toansi(StringGrid1.Cells[2,ii]), // Наименование
                 '',                                  // ставка НДС
                 formstart.StrToFloat(StringGrid1.Cells[3,ii]), // цена
                 formstart.StrToFloat(StringGrid1.Cells[4,ii]), // кол-во
                 0,                                             // ед измер ???
                 depInt,                                        // секция
                 byte('0'),                                     // тип скидки
                 0,                                     // процент скидки
                 0,                                     // сумма со скидкой
                formstart.StrToFloat(StringGrid1.Cells[5,ii]), // Сумма
                0,
                0,
                SlipNumber) ;
                res:=OleFR.ResultCode;

            end;
            //if aOpenBank then
            if aOperBank then
              OleFR.Total(byte('1'),flInpSumm,byte('0'),ch1,retAMount,SlipNumber)
             else
              OleFR.Total(byte('0'),flInpSumm,byte('0'),ch1,retAMount,SlipNumber);
             OleFR.CloseFiscalInv(SlipNumber,nFD,SignFP,nDoc,nShift);
             res:=OleFR.ResultCode;
           end;
           else begin
                formviewcheck.MmCheck.Lines.Clear();
                ItogSumm:=flAllSumma;
                result:=-1;
                em_summ := 0.00;
                em_all_summ := 0.00;
                  for ii:=1 to StringGrid1.RowCount-1 do begin
                    em_summ := 0.00;
                    em_Price:= 0.00;
                    if (flProcentSkid<>0.00) and (flProcentSkid<>100.00) then begin
                        em_Price:= formstart.StrToFloat( trim( StringGrid1.Cells[5,ii] ) ) ;
                        em_Price:= (em_Price - formstart.StrToFloat(trim(Stringgrid1.Cells[13,ii])));
                        em_Price:= em_Price/formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));
                    end else begin
                        em_Price:= Trunc(formstart.StrToFloat(trim(StringGrid1.Cells[3,ii]))*100);
                        em_Price:= em_Price/100;
                    end;
                    if (StringGrid1.Cells[19,ii] <> '')and(length(StringGrid1.Cells[19,ii])>22) then begin
                       self.get_gtin(5,StringGrid1.Cells[19,ii]);
                    End;

                    em_Quantity:=formstart.StrToFloat(trim(StringGrid1.Cells[4,ii]));
                    em_summ:=  RoundRub(em_Quantity*em_Price,100); // округление !!!!
                    em_all_summ := em_summ + em_all_summ;
                    formviewcheck.MmCheck.Lines.add( StringGrid1.Cells[2,ii]+' '+StringGrid1.Cells[4,ii]);
                    formviewcheck.MmCheck.Lines.add(StringGrid1.Cells[3,ii]+' = '+format('%0.2f',[em_summ]));

                     end;
                   formviewcheck.MmCheck.Lines.add('ИТОГО: '+format('%0.2f',[em_all_summ]));
                   if aOperBank then
                       formviewcheck.MmCheck.Lines.add('ЭЛЕКТРОННО: '+format('%0.2f',[flInpSumm]))
                   else
                       formviewcheck.MmCheck.Lines.add('НАЛИЧНЫМИ: '+format('%0.2f',[flInpSumm]));

                   if Ceil(em_all_summ*100) <> Ceil(flallsumma*100) then
                      formviewcheck.MmCheck.Lines.add('СКИДКА:'+format('%0.2f',[float(Ceil(em_all_summ*100) - Ceil(flallsumma*100))]));

                   //if Ceil(em_all_summ*100) <> Ceil(flInpSumm*100) then
                      formviewcheck.MmCheck.Lines.add('СДАЧА:'+format('%0.2f',[float(flInpSumm-em_all_summ)])+' ('+format('%0.2f',[float(Ceil(em_all_summ*100) - Ceil(flInpSumm*100))])+')');

                   // ******* обработка состояния ккм **************
                   result:=0;
                formviewcheck.ShowModal();
               end;
    end;
  end;
  //GetStatusFR(true);
  self.addtrans(formStart.prefixClient,inttostr(flNumCheck),'55','0','1',floattostr(flallsumma),floattostr(flInpSumm),'','','');
  stNumber.Caption:='СДАЧА:'+format('%0.2f',[(flInpSumm-flallsumma)]);
end;

function TFormSalesBeerTS.OrderReturn(aOperBank:boolean): integer;

var
  resFR:integer;
  NumberCheck,
  ii:INTEGER;
  i:integer;
  curDep:integer;
  summdep:real;
  summall:real;
  depSumm:array[0..15] of real;
  IndTr:Integer;
  strw:widestring;
  strw1:widestring;
  depInt:integer;
  countpop:integer;
  resECR:integer;
  SubTotal:real;
  ch1:byte;
  retAMount:Double;
    nFD,SignFP,nShift,SlipNumber,nDoc: Integer;
begin
  // -- Здесь проверить наличные с суммой чека!!!

  // ---------------------------------------------
 case flTypeKKM of
 0:begin
   OleFR.WaitForPrinting();
   OleFR.Password:=30;
   OleFR.GetECRStatus();
   ItogSumm:=flAllSumma-flAllSummDiscount;
   curDep:=0;
   summall:=0;
   // -- перебираем подразделения --
   curdep:=0;
   result:=-1;

  //  SummRep:=0;
  //   if depSumm[curdep] > 0 then begin
   for ii:=1 to StringGrid1.RowCount-1 do begin
      strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
      OleFR.Password:=30;
      OleFR.Quantity:=formstart.StrToFloat(StringGrid1.Cells[4,ii]);
      OleFR.Price:= formstart.StrToFloat(StringGrid1.Cells[3,ii]);
      depInt:=0;
      if StringGrid1.Cells[15,ii]<>'' then
         depInt:= strtoint(StringGrid1.Cells[15,ii]);
      OleFR.Department:= depInt;
      OleFR.Tax1:=0;
      OleFR.Tax2:=0;
      OleFR.Tax3:=0;
      OleFR.Tax4:=0;
      OleFR.StringForPrinting:=strw;
      OleFR.ReturnSale();
      OleFR.WaitForPrinting();
      end;
   ii:=1;
   IF  (flAllSumma>0) and FlgLoadLibFR then begin
      OleFR.Password:=30;
       OleFR.CheckSubTotal();
      SubTotal:= OleFR.Summ1;
      if flAllSumma < SubTotal then  begin
          OleFR.Password:=30;
          OleFR.Summ1:= flAllSumma- SubTotal;
          OleFR.StringForPrinting:='СКИДКА';
          OleFR.Discount();
          //flAllSumma:= SubTotal;
          end;
      OleFR.Password:=30;
//       OleFR.Quantity:=1;
      if  aOperBank then begin
       OleFR.Summ1:= 0;
       OleFR.Summ4:= SubTotal;
      end else
      begin
  //     if flAllSumma< SubTotal then
       OleFR.Summ1:= flInpSumm;
       OleFR.Summ4:= 0;
      end;
      OleFR.Summ2:= 0;
      OleFR.Summ3:= 0;
      //OleFR.Summ4:= 0;
      OleFR.Tax1:=0;
      OleFR.Tax2:=0;
      OleFR.Tax3:=0;
      OleFR.Tax4:=0;
      OleFR.DiscountOnCheck:=0;
      if (flProcentSkid<>0) or (flProcentSkid<>100) then
        OleFR.DiscountOnCheck:=flProcentSkid;
      OleFR.StringForPrinting:=strw1;
      OleFR.CloseCheck();
      OleFR.WaitForPrinting();
   end;
   countpop:=3;
   result:=OleFR.ResultCode;
   resFR:= OleFR.ResultCode;
   resECR:=OleFR.ECRMode;
   while (resFR<>0) and (countpop>0) do begin
     if resFR <> 0 then begin
         case resFR of
         69: begin
              OleFR.Password:=30;
  //            OleFR.Quantity:=1;
              if  aOperBank then begin
                OleFR.Summ1:= 10000;
                OleFR.Summ4:= flAllSumma;
              end else
              begin
               OleFR.Summ1:= flAllSumma;
               OleFR.Summ4:= 0;
              end;
              OleFR.Summ2:= 0;
              OleFR.Summ3:= 0;
              //OleFR.Summ4:= 0;
              OleFR.Tax1:=0;
              OleFR.Tax2:=0;
              OleFR.Tax3:=0;
              OleFR.Tax4:=0;
              OleFR.StringForPrinting:='';
              OleFR.CloseCheck();
              resFR:= OleFR.ResultCode;
         end;
         116: Showmessage('Ошибка ОЗУ, требуется тех. обнуление.');
         100:showmessage('Ошибка ФП!');
         113:begin
            showmessage(
            'Ошибка отрезчика!');
         end;
         else
           showmessage(
           'Ошибка ККТ:'+inttostr(resFR));
        end;

         resFR:= OleFR.ResultCode;

       end;
      countpop:=countpop-1;
    end;
    resECR:=OleFR.ECRMode;
    if resECR = 8 then begin
      FRBeep;
     ShowMessage('Ошибка при закрытии чека! Пробуем еще раз!');
     OleFR.Password:=30;
     OleFR.Quantity:=1;
     if  aOperBank then begin
      OleFR.Summ1:= 0;
      OleFR.Summ4:= flAllSumma;
     end else
     begin
      OleFR.Summ1:= flAllSumma+10;
      OleFR.Summ4:= 0;
     end;
     OleFR.Summ2:= 0;
     OleFR.Summ3:= 0;
     //OleFR.Summ4:= 0;
     OleFR.Tax1:=0;
     OleFR.Tax2:=0;
     OleFR.Tax3:=0;
     OleFR.Tax4:=0;
     OleFR.StringForPrinting:=strw1;
     OleFR.CloseCheck();
      end;
    OleFR.OpenDrawer();
    // ******* обработка состояния ккм **************
    result:=OleFR.ResultCode;
    //GetStatusFR(true);
    //OleFR.DeviceEnabled := 1;
    countpop:=countpop-1;
   end;
 // end;
  1:begin
      OleFR.Mode := 1;
      OleFR.SetMode();
      OleFR.Name := WIDESTring('ВОЗВРАТ');
      OleFR.Price := flAllSumma;
      OleFR.Quantity := 1;
      OleFR.Department := 0;
      OleFR.Return() ;
      OleFR.Summ := flAllSumma;  // Сумма оплаты
     if  aOperBank then
       OleFR.TypeClose := 1
     else
       OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
      OleFR.Payment();
      OleFR.TypeClose := 0;
      OleFR.CloseCheck() ;
    end;
   2:begin  {VIKI print}
     VIKIOpenDocument(3,0,'Kassir',flNumCheck);
     for ii:=1 to StringGrid1.RowCount-1 do begin
        if not VIKIAddPosition(utf8toansi(StringGrid1.Cells[2,ii]),StringGrid1.Cells[1,ii],formstart.StrToFloat(StringGrid1.Cells[4,ii]),formstart.StrToFloat(StringGrid1.Cells[3,ii]),
         ((StringGrid1.Cells[17,ii]<>'')and(StringGrid1.Cells[17,ii]<>'0')),formstart.StrToFloat(StringGrid1.Cells[17,ii])) then
           showmessage('Ошибка при печати документа!');
     end;
     //if aOpenBank then
     VIKICloseCheck(3,flInpSumm,0);
   end;
   3:begin {ImpulsFR}
        OleFR.Mode := 1;
        OleFR.SetMode();
        OleFR.Name := WIDESTring('ВОЗВРАТ');
        OleFR.Price := flAllSumma;
        OleFR.Quantity := 1;
        OleFR.Department := 0;
        OleFR.Return() ;
        GetStatusFR(true);
        OleFR.Summ := flAllSumma;  // Сумма оплаты
       if  aOperBank then
       OleFR.TypeClose := 1
       else
       OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
        OleFR.Payment();
  //      Драйвер.Summ = 10.00;  // Сумма оплаты
  //      Драйвер.TypeClose = 1;  // Тип оплаты 1
  //      Драйвер.Payment();
        OleFR.TypeClose := 0;
        GetStatusFR(true);
        OleFR.CloseCheck() ;
      end;
   4:begin
     OleFR.OpenFiscalInv(30,'30',1,byte('1'),'','','','',nFD,SignFP,nShift);
     result:=OleFR.ResultCode;
     //VIKIOpenDocument(3,0,'Kassir',flNumCheck);
     for ii:=1 to StringGrid1.RowCount-1 do begin
         DepInt:=1;
         if StringGrid1.Cells[15,ii]<>'' then
           depInt:= strtoint(StringGrid1.Cells[15,ii]);
         OleFR.RegisterSale(
          utf8toansi(StringGrid1.Cells[2,ii]), // Наименование
          '',                                  // ставка НДС
          formstart.StrToFloat(StringGrid1.Cells[3,ii]), // цена
          formstart.StrToFloat(StringGrid1.Cells[4,ii]), // кол-во
          0,                                             // ед измер ???
          depInt,                                        // секция
          byte('0'),                                     // тип скидки
          0,                                     // процент скидки
          0,                                     // сумма со скидкой
         formstart.StrToFloat(StringGrid1.Cells[5,ii]), // Сумма
         0,
         0,
         SlipNumber) ;
         result:=OleFR.ResultCode;

     end;
     //if aOpenBank then
     if aOperBank then
       OleFR.Total(byte('1'),flInpSumm,byte('0'),ch1,retAMount,SlipNumber)
      else
       OleFR.Total(byte('0'),flInpSumm,byte('0'),ch1,retAMount,SlipNumber);
      OleFR.CloseFiscalInv(SlipNumber,nFD,SignFP,nDoc,nShift);
      result:=OleFR.ResultCode;
    end;
   end;
 addtrans(formStart.prefixClient,inttostr(flNumCheck),'55','0','1',floattostr(flallsumma),floattostr(flInpSumm),'','','');
end;
// ===============================   C<TH<FYR ==================================
function TFormSalesBeerTS.CloseDaySB():integer;
var
    res:Longint;
begin
  if not FlgLoadLibSB then begin
      formstart.fshowmessage('Ошибка при загрузки модуля банка!');
      result:=-1;
      exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  // --- Вызываем функцию ----
  formInputSumm.fl_not_print  :=false;
  res := OleSBR.NFun(6000);
  if res = 0 then

        result:=PrintSlipSB(0)
  else begin
      formstart.fshowmessage('Ошибка при выполнении операции с банком:'+inttostr(res));
      result:=-1;
  end;
end;

function TFormSalesBeerTS.PrintSlipSB(aDep:integer;aCountSlip:integer=1):integer;
//  FlgLoadLibSB
var
  StrSlip:WideString;
  Query,
  strhex:string;
  ListStr:TStringList;
  i:integer;
  ind:integer;
  res:integer;
  tmpCut:boolean;
  ws_ClientCard:WideString;
  sb_ClientCard:string;
begin
  if flTypeKKM=0 then begin
   if SummCheck.depCash='' then
     SummCheck.depCash:='0';
   self.ActiveDep();
  end;
  if flTypeKKM=2 then
    VIKICloseDocument;

  if not FlgLoadLibSB then begin
    formstart.fshowmessage('Ошибка при загрузки модуля банка!');
   result:=-1;
   exit;
  End;
  result:=0;

  ListStr:= TStringList.Create;
  tmpCut:=true;
  StrSlip:=OleSBR.GParamString ('Cheque');
  ListStr.Text:=AnsiTOUtf8(StrSlip);
  strhex:=StringToHex(ListStr.Text);
  ws_ClientCard := OleSBR.GParamString('ClientCard');
  sb_ClientCard := AnsiTOUtf8(ws_ClientCard);
  Query:='INSERT INTO `egaisfiles` (`DATESTAMP`,`url`,`typefile`,`replyId`,`xmlfile`) VALUES (NOW(),"'+inttostr(flNumCheck)+'","slip","'+sb_ClientCard+'",0x'+strhex+');';
  formStart.DB_Query(query);

  if forminputsumm.fl_not_print then
     begin
       //strhex:='';
       //strhex:=StringToHex(ListStr.Text);
       //sb_ClientCard := OleSBR.GParamString('ClientCard');
       //Query:='INSERT INTO `egaisfiles` (`DATESTAMP`,`url`,`typefile`,`replyId`,`xmlfile`) VALUES (NOW(),"'+inttostr(flNumCheck)+'","slip","'+sb_ClientCard+'",0x'+strhex+');';
       //formStart.DB_Query(query);
     end
  else
    for ind:=1 to aCountSlip do begin
       tmpCut:=true;
      for i:=0 to ListStr.Count-1 do begin
          PrintLineString(ListStr.Strings[i]);
          if pos('==========',ListStr.Strings[i])<>0 then begin
            if FlgLoadLibFR then begin
              PrintLineString(' ');
              PrintLineString(' ');
              PrintLineString(' ');
              PrintLineString(' ');
              PrintLineString(' ');
              if flTypeKKM=0 then
                 OleFR.Password :=30;
              tmpCut:=false;
              FRCutCheck();
            end;
          end;
      end;
      if FlgLoadLibFR and tmpCut then begin
       PrintLineString(' ');
       PrintLineString(' ');
       PrintLineString(' ');
       PrintLineString(' ');
       FRCutCheck();
      end;

    end;

  result:=0;
  if flTypeKKM=2 then
    VIKICloseDocument;
  ListStr.Destroy;
end;
function sb_get_context_error(error_code:integer):string;
begin
   result:='';
   case error_code of
     12: result:='Данная версия не поддерживает режим РС-3.';
     36: result:='В пинпаде нет ключа в ячейке 9.';
     99: result:='Пинпад не подключен (клавиатура для ввода кода / цифр). Отсутствовать связь с ПИН-падо может по причине плохого подключения или повреждения провода/кабеля ПИН-пада, плохого контакта.';
   2000: result:='Операция прервана клиентом. Возможно случайно клиент нажал на кнопку отмены и транзакция прервалась. Иногда бывает, что терминал не успевает провести сверку итогов.';
   4451: result:='Нехватает средств на карте';
   end;
end;

function TFormSalesBeerTS.SalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
  MyClientCard,
  MyClientExpiryDate,
  MyCardName,
  MyTermNum:string;
  sb_result : integer;
begin
    if not FlgLoadLibSB then begin
        formstart.fshowmessage('Ошибка при загрузки модуля банка!');
        result:=-1;
        exit;
    End;
    // --- Очищаем все значениЯ переменных ---
    OleSBR.Clear();
    summ := Round(aSumm*100);
    // --- Вызываем функцию ----
    OleSBR.SParam('Amount',Summ) ;
    sb_result := OleSBR.NFun(4000);
    if sb_result = 0 then begin
        result:= sb_result;
        MyTermNum          := OleSBR.GParamString('TermNum');
        MyClientCard       := OleSBR.GParamString('ClientCard');
        MyClientExpiryDate := OleSBR.GParamString('ClientExpiryDate');
        MyCardName         := OleSBR.GParamString('CardName');
        if (FormInputSumm.flrecipientEmail <> '') and (formInputSumm.fl_not_print) then
           FormDiscountCard.add_user_card(MyClientCard,MyClientCard,FormInputSumm.flrecipientEmail);
        PrintSlipSB(SummCheck.DepBank,formstart.flCountSlip);
        CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'140','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);
    end else begin
        MyTermNum          := OleSBR.GParamString('TermNum');
        MyClientCard       := OleSBR.GParamString('ClientCard');
        formstart.fshowmessage(MyTermNum+' Ошибка оплаты банком:'+inttostr(sb_result)+' '+sb_get_context_error(sb_result)+' CC:'+MyClientCard);
        result:=-1;

    end;

end;

function TFormSalesBeerTS.SalesCardSBv2(aDepart: integer): integer;
var
  Summ:Int64;
  _exit:boolean;
begin
  if not FlgLoadLibSB then begin
    formstart.fshowmessage('Ошибка при загрузки модуля банка!');
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---

  repeat
    _exit:=true;
    OleSBR.Clear();
    summ := Round(SummCheck.AllSumm*100);
    // --- Вызываем функцию ----
    OleSBR.SParam('Amount',Summ) ;
    //OleSBR.SParam('Department',SummCheck.DepBank) ;
    result:= OleSBR.NFun(4000);

    if result = 0 then begin
  	  result:=PrintSlipSB(aDepart,formstart.flCountSlip);
  	  SummCheck.CodeRRN := OleSBR.GParamString ('RRN');
  	  SummCheck.CodeAuth := OleSBR.GParamString ('AuthCode');
          addtrans(formStart.prefixClient,inttostr(flNumCheck),'140','0','1',floattostr(SummCheck.AllSumm),floattostr(SummCheck.AllSumm),'',SummCheck.CodeRRN,SummCheck.CodeAuth);
    end else begin
      if result = 4451 then
        if formShowMessage.ShowYesNo('Не достаточно средств!!! Повторить?') then
           _exit:=false;
      SummCheck.CodeRRN := '';
      SummCheck.CodeAuth := '';
      result:=-1;
    end;
  until (_exit )or (result = 0) ;

end;


function TFormSalesBeerTS.CancelSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
  Str1:WideString;
begin
  if not FlgLoadLibSB then begin
  formstart.fshowmessage('Ошибка при загрузки модуля банка!');
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  Str1:=CodeRRN;
  summ := Round(aSumm*100);
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  //OleSBR.SParam('Department',SummCheck.DepBank) ;
  OleSBR.SParam('RNN',Str1) ;
  if OleSBR.NFun(4003) = 0 then begin
  	result:=PrintSlipSB(aDepart,formstart.flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'141','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);

  end else
    result:=-1;

end;

function TFormSalesBeerTS.ReturnSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
  Str1:WideString;
begin
  if not FlgLoadLibSB then begin
  formstart.fshowmessage('Ошибка при загрузки модуля банка!');
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  Str1:= CodeRRN;
  summ := Round(aSumm*100);
  OleSBR.SParam('RNN',Str1) ;
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  //OleSBR.SParam('Department',SummCheck.DepBank) ;
  if OleSBR.NFun(4002) = 0 then begin
  	result:=PrintSlipSB(aDepart,formstart.flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'144','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);

  end else
    result:=-1;

end;

procedure TFormSalesBeerTS.CashIncome();
var
  ind:integer;
  comment:string;
begin
 if flNumber = '' then
 begin
  FRBeep;
   showmessage('Не введена сумма!');
   exit;
 end;
 comment:='';
 if formcomment.ShowModal=1377 then
   comment:=formcomment.Memo1.Text;
 if FlgLoadLibFR then
   if flTypeKKM=0 then begin
      OleFR.Password:=30;
      OleFR.Summ1:=strtofloat(trim(flNumber));
      OleFR.CashIncome();
      ind:=OleFR.OpenDocumentNumber;
      addtrans(formStart.prefixClient,inttostr(ind),'50','0','1',flNumber,flNumber,comment,comment,'');
      flNumber:='';
      stNumber.Caption:='0';
      clearcheck();
    end;
end;

procedure TFormSalesBeerTS.CashOutcome();
var
  ind:integer;
  comment:string;
begin
if flNumber = '' then
 begin
  FRBeep;
   showmessage('Не введена сумма!');
   exit;
 end;
comment:='';
if formcomment.ShowModal=1377 then
  comment:=formcomment.Memo1.Text;
 if FlgLoadLibFR then
   if flTypeKKM=0 then begin
      OleFR.Password:=30;
      OleFR.Summ1:=strtofloat(trim(flNumber));
      OleFR.CashOutcome();
      ind:=OleFR.OpenDocumentNumber;
      addtrans(formStart.prefixClient,inttostr(ind),'51','0','1',flNumber,flNumber,comment,comment,'');
      flNumber:='';
      stNumber.Caption:='0';
      clearcheck();
    end;

end;

function TFormSalesBeerTS.summTitle(aSumm: real): string;
var
  st:string;
  n,i:integer;
  c:array[1..4]of integer;
  s:array[1..4,1..3]of string;
  cel1,drob1:string;

begin
 st:=format('%8.0f',[ aSumm]);
 n :=strtoint(st);
 drob1:=format('%2.2f',[ aSumm]);
 i:=pos('.',drob1);
 drob1:=copy(drob1,i+1,4);

s[1,1]:='миллиард';
s[1,2]:='миллиарда';
s[1,3]:='миллиардов';
s[2,1]:='миллион';
s[2,2]:='миллиона';
s[2,3]:='миллионов';
s[3,1]:='тысяча';
s[3,2]:='тысячи';
s[3,3]:='тысяч';
s[4,1]:='';
s[4,2]:='';
s[4,3]:='';


st:='';
c[1]:=n div 1000000000;
c[2]:=(n mod 1000000000) div 1000000;
c[3]:=(n mod 1000000) div 1000;
c[4]:=n mod 1000;
for i:=1 to 4 do
if c[i]<>0 then
 begin
  if c[i] div 100<>0 then
  case c[i] div 100 of
  1:st:=st+'сто';
  2:st:=st+'двести';
  3:st:=st+'триста';
  4:st:=st+'четыреста';
  5:st:=st+'пятьсот';
  6:st:=st+'шестьсот';
  7:st:=st+'семьсот';
  8:st:=st+'восемьсот';
  9:st:=st+'девятьсот';
  end;
  if (c[i] mod 100) div 10<>1 then
   begin
    case (c[i] mod 100) div 10 of
    2:st:=st+' двадцать';
    3:st:=st+' тридцать';
    4:st:=st+' сорок';
    5:st:=st+' пятьдесят';
    6:st:=st+' шестьдесят';
    7:st:=st+' семьдесят';
    8:st:=st+' восемьдесят';
    9:st:=st+' девяносто';
    end;
    case c[i] mod 10 of
    1:if i=3 then st:=st+' одна' else st:=st+' один';
    2:if i=3 then st:=st+' две' else st:=st+' два';
    3:st:=st+' три';
    4:st:=st+' четыре';
    5:st:=st+' пять';
    6:st:=st+' шесть';
    7:st:=st+' семь';
    8:st:=st+' восемь';
    9:st:=st+' девять';
    end;
   end
  else
   case (c[i] mod 100) of
   10:st:=st+' десять';
   11:st:=st+' одиннадцать';
   12:st:=st+' двенадцать';
   13:st:=st+' тринадцать';
   14:st:=st+' четырнадцать';
   15:st:=st+' пятндцать';
   16:st:=st+' шестнадцать';
   17:st:=st+' семнадцать';
   18:st:=st+' восемнадцать';
   19:st:=st+' девятнадцать';
   end;
   if (c[i] mod 100>=10) and (c[i] mod 100<=19) then st:=st+' '+s[i,3]+' '
   else
   case c[i] mod 10 of
   1:st:=st+' '+s[i,1]+' ';
   2..4:st:=st+' '+s[i,2]+' ';
   5..9,0:st:=st+' '+s[i,3]+' ';
   end;
 end;

 result:=st+' рублей '+drob1+' коп.';
end;

function TFormSalesBeerTS.InitDevice(): boolean;
function NumBaud(const iSpeed:integer):integer;
const f_Baud:array[1..10] of integer=(2400, 4800, 9600, 14400, 19200, 38400, 56000, 57600, 115200 ,0);
var
  i:integer;
  begin
    result:=0;
    for i:=1 to 9 do
     if f_baud[i]=iSpeed then
       result:=i;

  end;

var
  str1:string;
  verAtol:String;
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
 formlogging.AddMessage('Проверяем доступные устройства', '!');
 flMultiSection:=false;
  result:=true;
  if FlgLoadLibFR then
   begin
     if GetStatusFR(false)=-1 then
       FlgLoadLibFR:=false
     else
      exit;
   end;
  FlgLoadLibFR :=false;
    str1:=FormStart.GetConstant('TypeKKM');
  if str1='' then
      flTypeKKM:=0
    else
      flTypeKKM:=StrToInt(str1);
  str1:=FormStart.GetConstant('StringSizeKKM');
  if str1<>'' then
     SizeStrFr:=strtoint(str1)
   else
     SizeStrFr:=48; // -- Количество символов в строке FR
  if not formstart.flkkmenabled then
    exit;

   case flTypeKKM of
    0: begin

      try
        OleFR:= CreateOleObject('Addin.DRvFR') ;
        FlgLoadLibFR:=true;
      except
          showmessage('Ошибка драйвера ККМ/АСПД!');
          FlgLoadLibFR:=false;
      end;
      //OleFR.AddLD;
      end;
    1: begin
      self.flg_dto_10 := False;
      try
          OleFR   := CreateOleObject('AddIn.Fptr10');
          //OleFR.initWithID('KKM1');
          verAtol := OleFR.version();
          self.flg_dto_10:=True;
          OleFR.setSingleSetting(OleFR.LIBFPTR_SETTING_ACCESS_PASSWORD,0);
          OleFR.setSingleSetting(OleFR.LIBFPTR_SETTING_USER_PASSWORD,30);
          OleFR.applySingleSettings();
          OleFR.open;
          //
          OleFR.operatorLogin;
          OleFR.checkDocumentClosed;
          if OleFR.errorDescription<>'Ошибок нет' then
             showmessage(OleFR.errorDescription);
          FlgLoadLibFR:=true;
      except
          FlgLoadLibFR:=false;
          self.flg_dto_10 := False;
      end;
      if not self.flg_dto_10 then begin
        try
          OleFR:= CreateOleObject('Addin.FprnM45') ;
          FlgLoadLibFR:=true;
        except
          //showmessage('Ошибка драйвера ККМ/АСПД!');
          FlgLoadLibFR:=false;
        end;
      end;
    end;
    2: begin
      //showmessage('Подключаем ВИКИ!');
      VIKIInitDevice(formstart.flVIKIPort,formstart.flVIKIBaud);
      VIKIConnect(formstart.flVIKIPort,formstart.flVIKIBaud);
      FlgLoadLibFR:=true;
    end;
    3:begin
      try
      OleFR:= CreateOleObject('AddIn.ImpulsFR') ;
      FlgLoadLibFR:=true;
      except
          showmessage('Ошибка драйвера ККМ/АСПД!');
          FlgLoadLibFR:=false;
        end;
    end  ;
    4:begin // === Оле НЬЮТОН =====
    try
      OleFR:= CreateOleObject('AddIn.NewtonMicroFRRU') ;
      OleFR.Connect(StrtoInt(formstart.flVIKIPort),NumBaud(formstart.flVIKIBaud));
      FlgLoadLibFR:=true;
    except
        showmessage('Ошибка драйвера ККМ/АСПД!');
        FlgLoadLibFR:=false;
      end;
    end
    else
      ShowMessage('Запущен ЭМУЛЯТОР ККМ');
      //OleFR:= CreateOleObject('Addin.DRvFR') ;
      FlgLoadLibFR:=true;
    end;



  if FormStart.flKKMSberbank then begin
    try
      OleSBR:= CreateOleObject('SBRFSRV.Server');
      FlgLoadLibSB:=true;
    except
      formstart.fshowmessage('Ошибка драйвера Сбербанк!');
      FlgLoadLibSB:=false;
    end;
  end;
  if FlgLoadLibFR then begin
     if GetStatusFR(false)=-1 then
       FlgLoadLibFR:=false;
   end;
   InitSection;
   InitScale();
end;

procedure TFormSalesBeerTS.FRPrintHeader();
var
  res:integer;
begin
  if FlgLoadLibFR then begin
   case flTypeKKM of
      0:  OleFR.PrintCliche();
      1:  OleFR.PrintHeader();
      3:  ;//OleFR.PrintHeader();
   end;
  end;
  FRCutCheck();


end;

procedure TFormSalesBeerTS.FRPrintFooter();
begin
  if FlgLoadLibFR then begin
   case flTypeKKM of
      0:;
      1:OleFR.PrintFooter();
      3:;//OleFR.PrintFooter();
      else

   end;
  end;
end;

procedure TFormSalesBeerTS.FRBeep;
begin
  if FlgLoadLibFR then begin
   case flTypeKKM of
      0:OleFR.beep();
      1:;
      3:OleFR.Beep();
      4:OleFR.Beep(500, 500)
      else

   end;
  end;
end;

// ==== печать рекламы =====
procedure TFormSalesBeerTS.PrintReklamCheck;
begin

end;

procedure TFormSalesBeerTS.PrintNumCheck();
function SumBC(strBC:String):string;
var
  i:integer;
begin
 i:=3*(strtoint(strBC[2])+strtoint(strBC[4])+strtoint(strBC[6])+strtoint(strBC[8])+strtoint(strBC[10])+strtoint(strBC[12]));
 i:= i+  strtoint(strBC[1])+strtoint(strBC[3])+strtoint(strBC[5])+strtoint(strBC[7])+strtoint(strBC[9])+strtoint(strBC[11]);
 result:=inttostr(10-(i mod 10));
end;

var
  strBC:String;
  nCheck:string;
begin
  // %%%%%% Печатаем Номер дату и ШК документа %%%%%%%
  if FlgLoadLibFR then begin
   nCheck:= format('%5.5d',[flNumCheck]);
   if flTypeKKM=0 then begin

      StrBC:=flPrefixCheck+format('%0.4d',[flNumCheck])+FormatDateTime('DDMMYY',now());
      strBC:=StrBC+SumBC(StrBC);
      OleFr.BarCode:= StrBC;
      OleFr.PrintBarCode();
      PrintLineGood('№ '+nCheck,FormatDateTime('DD.MM.YYYY',now()));
    end else begin
      PrintLineGood('№ '+nCheck,FormatDateTime('DD.MM.YYYY',now()));
   end;
  end;
end;

procedure TFormSalesBeerTS.repaintTypeDoc;
begin
  SetTypeDocCapture(true);
  if flMultiTable then begin
    if flCurrentTable<>'' then
      stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
  end;
end;

procedure TFormSalesBeerTS.FRCutCheck();
var
  res:integer;
begin
  res:=0;
  sleep(100);
  if (FlgLoadLibFR)AND(not DB_Boolean(FormStart.GetConstant('DisabledCut'))) then begin
   case flTypeKKM of
     0: begin
        OleFR.Password :=30;
        //OleFR.FeedAfterCut:=true;
        OleFR.WaitForPrinting();
        OleFR.Password :=30;
        OleFR.CutType:=true;
        OleFR.CutCheck();
        res:=OleFR.ResultCode;
        if res <>0 then begin
          FormShowStatus.Hide;
          addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа','ERROR');
          showmessage('Ошибка ККМ "'+ansitoutf8(AnsiString(OleFR.ResultCodeDescription))+'", устраните ее и нажмите "ОК".');
          addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа (ОК):','ERROR');
          FormShowStatus.Show;
        end;
      end;
      1:begin
        OleFR.Password :=30;
        OleFR.PartialCut();
        end;
      2:begin
        VIKICutCheck;
      end;
      3:begin
        OleFR.OperatorPassword :=30;
        OleFR.FullCut();
        end;
      4:begin
        OleFR.CutPaper();
      end
     else
       //OleFR.PartialCut();

     end;
  end else
    FormShowMessage.Show('Отключен отрезчик, оторвите чек и нажмите "Принять"!');
end;
{Для каждого вида устройства свой способ присваивание имени кассира}
procedure TFormSalesBeerTS.SetOperName();
begin
 if formstart.flRMKOffline then // используем кассовый аппарат
 begin
   case flTypeKKM of
    0: begin  // shtrih-m
        end;
    1:;
    2:;
    3:begin

    end;
   end;
 end;

end;

function TFormSalesBeerTS.InitSection(): boolean;
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  CountLD:integer;
  res1:integer;
begin

  SummCheck.Active:=false;
  SummCheck.AllSumm:=0;
  SummCheck.DepBank:=0;
  SummCheck.inputsummBank:=0;
  SummCheck.depCash:='0';
  SummCheck.inputsummBank:=0;
  SummCheck.inputsummNal:=0;
  SummAlcCheck.Active:=false;
  SummAlcCheck.AllSumm:=0;
  SummAlcCheck.DepBank:=0;
  SummAlcCheck.inputsummBank:=0;
  SummAlcCheck.depCash:='';
  SummAlcCheck.inputsummBank:=0;
  SummAlcCheck.inputsummNal:=0;

 if (flTypeKKM = 0)and(FlgLoadLibFR ) then begin
     SummCheck.Active:=true;
     xrecbuf:=FormStart.DB_query('SELECT `numsection`,`devicehwport`,`devicehwbaud`,'+
     '`numhw`,`banking`,`deviceiphost`,`deviceipport`,`alckass` FROM `sprkass` WHERE `numkass`="'+formstart.prefixClient+'" AND `master`="0" AND `alckass`="1";');
     xrowbuf:=FormStart.DB_Next(xrecbuf);
     if xrowbuf<>nil then
     begin
        OleFR.GetCountLD;
        CountLD:=OleFr.LDCount;
        for i:=0 to CountLD do begin
          OleFR.LDNumber:=i;
          OleFR.DeleteLD;
         end;
       //showmessage( 'Добавлено устройство к секции '+ xrowbuf[0]);
         OleFR.ComNumber:= strtoint(xrowbuf[1]);
         OleFR.Baudrate:=StrToInt(xrowbuf[2]);
         OleFR.Timeout:=200;
         OleFR.LDNumber:=0;
         OleFR.LDName:=strtoWide('Device'+xrowbuf[3]) ;
         if xrowbuf[5]='' then  begin
           OleFR.LDComNumber:= strtoint(xrowbuf[1]);
           OleFR.LDBaudrate:=StrToInt(xrowbuf[2]);
           OleFR.UseIPAddress:=false;
           OleFR.LDUseIPAddress:= false;
           OleFR.LDConnectionType:=0;
           OleFR.ConnectionType:=0;
         end else begin
           OleFR.LDComNumber:= 1;
           OleFR.LDBaudrate:=1;
           OleFR.UseIPAddress:=true;
           OleFR.LDUseIPAddress:= true;
           OleFR.LDConnectionType:=6;
           OleFR.ConnectionType:=6;
           OleFR.LDTCPPort:=strtoint(xrowbuf[6]);
           OleFR.TCPPort:=strtoint(xrowbuf[6]);
           OleFR.LDIPAddress:= strtoWide(xrowbuf[5]);
           OleFR.IPAddress:= strtoWide(xrowbuf[5]);
           OleFR.LDProtocolType:=0;
           OleFR.LDComputerName:=strtoWide(xrowbuf[5]);
           OleFR.ComputerName:=strtoWide(xrowbuf[5]);
           OleFR.ComNumber:= 1;
           OleFR.Baudrate:= 1;
         end;
         OleFR.LDTimeout:=200;
         OleFR.AddLD;
         res1:=OleFR.ResultCode;
         i:=strtoint(xrowbuf[0]);
         SummAlcCheck.Active:=true;
         SummAlcCheck.depCash:=inttostr( OleFR.LDNumber);
         SummAlcCheck.DepBank:=0 ; //strtoint(xrowbuf[4]); // Отключаем поддержку департаментов в банке
         if db_boolean(xrowbuf[7]) then
           fldepEGAIS:=i ;
         flMultiSection:=true;
         formlogging.AddMessage( 'Добавлено устройство с номером:'+ xrowbuf[0]+' код:'+inttostr(res1));
        end;

     xrecbuf:=FormStart.DB_query('SELECT `numsection`,`devicehwport`,`devicehwbaud`,'+
     '`numhw`,`banking`,`deviceiphost`,`deviceipport`,`alckass` FROM `sprkass` WHERE `numkass`="'+formstart.prefixClient+'" AND `master`="1";');
     xrowbuf:=FormStart.DB_Next(xrecbuf);
     if xrowbuf<>nil then
     begin
        OleFR.GetCountLD;
        CountLD:=OleFr.LDCount;
        for i:=0 to CountLD do begin
          OleFR.LDNumber:=i;
          OleFR.DeleteLD;
         end;
       //showmessage( 'Добавлено устройство к секции '+ xrowbuf[0]);
         OleFR.ComNumber:= strtoint(xrowbuf[1]);
         OleFR.Baudrate:=StrToInt(xrowbuf[2]);
         OleFR.Timeout:=200;
         OleFR.LDNumber:=0;
         OleFR.LDName:=strtoWide('Device'+xrowbuf[3]) ;
         if xrowbuf[5]='' then  begin
           OleFR.LDComNumber:= strtoint(xrowbuf[1]);
           OleFR.LDBaudrate:=StrToInt(xrowbuf[2]);
           OleFR.UseIPAddress:=false;
           OleFR.LDUseIPAddress:= false;
           OleFR.LDConnectionType:=0;
           OleFR.ConnectionType:=0;
         end else begin
           OleFR.LDComNumber:= 1;
           OleFR.LDBaudrate:=1;
           OleFR.UseIPAddress:=true;
           OleFR.LDUseIPAddress:= true;
           OleFR.LDConnectionType:=6;
           OleFR.ConnectionType:=6;
           OleFR.LDTCPPort:=strtoint(xrowbuf[6]);
           OleFR.TCPPort:=strtoint(xrowbuf[6]);
           OleFR.LDIPAddress:= strtoWide(xrowbuf[5]);
           OleFR.IPAddress:= strtoWide(xrowbuf[5]);
           OleFR.LDProtocolType:=0;
           OleFR.LDComputerName:=strtoWide(xrowbuf[5]);
           OleFR.ComputerName:=strtoWide(xrowbuf[5]);
           OleFR.ComNumber:= 1;
           OleFR.Baudrate:= 1;
         end;
         OleFR.LDTimeout:=200;
         OleFR.AddLD;
         res1:=OleFR.ResultCode;
         i:=strtoint(xrowbuf[0]);
         SummCheck.Active:=true;
         SummCheck.depCash:=inttostr( OleFR.LDNumber);
         SummCheck.DepBank:=0; //strtoint(xrowbuf[4]); // Отключаем поддержку департаментов в банке
         if db_boolean(xrowbuf[7]) then
           fldepEGAIS:=i ;
         flMultiSection:=true;
         formlogging.AddMessage( 'Добавлено устройство с номером:'+ xrowbuf[0]+' код:'+inttostr(res1));
        end;


     //OleFR.AddLD;
     end else begin
       SummCheck.Active:=true;
     end;

end;

function TFormSalesBeerTS.GetSummDep(): real;
var
  i:integer;
  aSumm1:real;
  rDisc1:real;
begin
  aSumm1:=0;
  for i:=1 to StringGrid1.RowCount-1 do begin
    rDisc1:=0;
    if StringGrid1.Cells[17,i]<>'' then
       rDisc1:= round(strtofloat(trim(Stringgrid1.Cells[5,i]))*strtoFloat(StringGrid1.Cells[17,i]) )/100;
    aSumm1:=aSumm1+ strtofloat(trim(Stringgrid1.Cells[5,i]))-rDisc1;
  end;
  result:=aSumm1;
end;

procedure TFormSalesBeerTS.ActiveDep();
begin

 if SummCheck.Active then begin
  if SummCheck.depCash = '' then
    SummCheck.depCash:='0';
  OleFR.LDNumber:=StrToInt(SummCheck.depCash);
  OleFR.SetActiveLD;
 end;
end;

procedure TFormSalesBeerTS.ClearSummDep;
begin
  SummCheck.AllSumm:=0;
  SummCheck.inputsummBank:=0;
  SummCheck.inputsummBank:=0;
  SummCheck.inputsummNal:=0;

  SummAlcCheck.AllSumm:=0;
  SummAlcCheck.AllSumm:=0;
  SummAlcCheck.inputsummBank:=0;
  SummAlcCheck.inputsummBank:=0;
end;

function TFormSalesBeerTS.isDeleteDep(aDep: integer): boolean;
begin
 result:=true;
  if  (SummCheck.inputsummNal <>0 ) or (SummCheck.inputsummBank <>0)  then
  result:=false;
end;

procedure TFormSalesBeerTS.OpenDrawerAll;
var
  i:integer;
begin
 if formStart.flRMKOffline then
 begin
    if SummCheck.Active then begin
      if SummCheck.depCash='' then
      SummCheck.depCash:='0';
      self.ActiveDep();
      OleFR.OpenDrawer();
    end;
 end;
end;
// ======= Обновление надписей =======
procedure TFormSalesBeerTS.refreshStaticText;
begin
 stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
 GetAllSumm;
 SetTypeDocCapture();
 if flMultiTable then begin
   if flCurrentTable<>'' then
     stTypeDoc.Caption:=stTypeDoc.Caption+#13#10+' Стол № '+flCurrentTable;
 end;
end;

function TFormSalesBeerTS.GetSectionForGood(aStr: string): String;
begin
 result:=trim(aStr);
 if result = '' then
   result:='0';
end;

function TFormSalesBeerTS.InitScale: boolean;
begin
  //OleLP:=nil;
  try
    OleLP:= CreateOleObject('AddIn.DrvLP') ;
    FlgLoadLibLP:=true;
  except
    //  showmessage('Ошибка драйвера ККМ/АСПД!');
    FlgLoadLibLP:=false;
  end;
  try
    OleLPMini:= CreateOleObject('AddIn.Scale45') ;
    FlgLoadLibLPMini:=true;
  except
    //  showmessage('Ошибка драйвера ККМ/АСПД!');
    FlgLoadLibLPMini:=false;
  end;
  result:= FlgLoadLibLP ;
end;

procedure TFormSalesBeerTS.ScaleUploadGoods(idDevice: String);
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  CountGoods:string;
  RemoteHostLP:string;

begin
 if FlgLoadLibLP then begin
  if OleLP.Connected then
    OleLP.Disconnect();
  xrecbuf:=formstart.DB_query('SELECT `countgoods`,`deviceiphost` FROM `sprscale` WHERE `id`="'+idDevice+'";');
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf=nil then exit;
  CountGoods:=xrowbuf[0];
  RemoteHostLP:=xrowbuf[1];
  OleLP.DeviceInterface:=1;
  OleLP.RemoteHost:=RemoteHostLP;
  OleLP.Connect();
  if OleLP.Connected then begin
    OleLP.Password:=30;
    OleLP.QuickLoadON:=true;
    OleLP.SetLoadMode();
    xrecbuf:=formstart.DB_query('SELECT `plu`,`price`,`name` FROM `sprgoods` WHERE `plu`<'+CountGoods+' AND (`weightgood`="1" OR `weightgood`="+")');
    xrowbuf:=formstart.DB_Next(xrecbuf);
    while xrowbuf<> nil do begin
      OleLP.Password:=30;
      OleLP.PLUNumber:=strtoint(xrowbuf[0]);
      OleLP.Price:=formstart.strtoFloat(xrowbuf[1]);
      OleLP.ItemCode:= strtoint(xrowbuf[0]);
      OleLP.NameFirst:= copy(Utf8ToAnsi(xrowbuf[2]),1,28);
      OleLP.SetPLUData();
      xrowbuf:=formstart.DB_Next(xrecbuf);
    end;
   end else begin
    ShowMessage('Ошибка соединения!');
  end;
 end;

end;

function TFormSalesBeerTS.GetScaleCurrentCash(): string;
var
  i:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  CountGoods:string;
  RemoteHostLP:string;
  f1:real;
begin
 result:='';
 if FlgLoadLibLPMini then begin
  //if OleLPMini.Connected then
  //  OleLPMini.Disconnect();
  xrecbuf:=formstart.DB_query('SELECT `deviceiphost`,`devicehwport`,`devicehwbaud`,`localconnect` FROM `sprscale` WHERE `cash_id`="'+formstart.prefixClient+'" AND `cashconnect`="1";');
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf=nil then
    exit;
  if db_boolean(xrowbuf[3]) then begin
     {  OleLP.DeviceInterface:=0;
       RemoteHostLP:=xrowbuf[1];
       OleLP.ComNumber:=strtoint(RemoteHostLP);
      end else begin
          OleLP.DeviceInterface:=1;
          RemoteHostLP:=xrowbuf[0];
          OleLPMini.RemoteHost:=RemoteHostLP;
      end;  }

  try
      OleLPMini.DeviceEnabled:=true;
      if OleLPMini.DeviceEnabled then begin
        //OleLPMini.Password:=30;
        //OleLPMini.GoodsType:=0;
        //OleLPMini.SetGoodsType();
        //OleLPMini.Password:=30;
        //OleLPMini.Weight:=0;
        //OleLPMini.GetWeight();

        OleLPMini.ReadWeight();
        f1:= OleLPMini.Weight;
        result:=format('%0.3f',[f1]);

       end else begin
        ShowMessage('Ошибка соединения!'+inttostr(OleLPMini.ResultCode));
        OleLPMini.ShowProperties();
      end;

  except
    ShowMessage('Ошибка компоненты Scale45');
  end;
 end;

 end;

 if (FlgLoadLibLP)and(result='') then begin
  if OleLP.Connected then
    OleLP.Disconnect();
  xrecbuf:=formstart.DB_query('SELECT `deviceiphost`,`devicehwport`,`devicehwbaud`,`localconnect` FROM `sprscale` WHERE `cash_id`="'+formstart.prefixClient+'" AND `cashconnect`="1";');
  xrowbuf:= formstart.DB_Next(xrecbuf);
  if xrowbuf=nil then
    exit;
  if db_boolean(xrowbuf[3]) then begin
   OleLP.DeviceInterface:=0;
   RemoteHostLP:=xrowbuf[1];
   OleLP.ComNumber:=strtoint(RemoteHostLP);
  end else begin
      OleLP.DeviceInterface:=1;
      RemoteHostLP:=xrowbuf[0];
      OleLP.RemoteHost:=RemoteHostLP;
  end;

  OleLP.Connect();
  if OleLP.Connected then begin
    OleLP.Password:=30;
    OleLP.GoodsType:=0;
    OleLP.SetGoodsType();
    OleLP.Password:=30;
    OleLP.Weight:=0;
    OleLP.GetWeight();
    f1:= OleLP.Weight;
    result:=format('%0.3f',[f1]);
   end else begin
    ShowMessage('Ошибка соединения!');
  end;
 end;


end;

function TFormSalesBeerTS.InitSBClient(): boolean;
begin
 result:=false;
   if FormStart.flKKMSberbank then begin
    try
      OleSBR:= CreateOleObject('SBRFSRV.Server');
      FlgLoadLibSB:=true;
    except
      //showmessage('Ошибка драйвера Сбербанк!');
      FlgLoadLibSB:=false;
    end;
   result:= FlgLoadLibSB;
  end;
end;

procedure TFormSalesBeerTS.SetTypeDocCapture(AddUserName: boolean=FALSE);
{Обновление заголовка вида операций}

begin
  if AddUserName then begin
    if flg_view_only Then
      stTypeDoc.Caption:=flCurUserName+#13#10+'ПРОСМОТР'
    else begin
      if flCheckSales then
        stTypeDoc.Caption:=flCurUserName+#13#10+'ПРОДАЖА'
      else
        stTypeDoc.Caption:=flCurUserName+#13#10+'ВОЗВРАТ';
    end;
  end else begin
    if flg_view_only then
      stTypeDoc.Caption:='ПРОСМОТР'
    else begin
      if flCheckSales then
        stTypeDoc.Caption:='ПРОДАЖА'
       else
        stTypeDoc.Caption:='ВОЗВРАТ';
    end;
  end;
end;

procedure TFormSalesBeerTS.SetCurrentKassirName();
begin
  case self.flTypeKKM of
    1: if flg_dto_10 then begin
      OleFR.setParam(1021, 'Кассир '+self.flCurUserName);
      OleFR.setParam(1203, formStart.FirmINN);
      if OleFR.operatorLogin() < 0 then
        showmessage('"' + IntToStr(OleFR.errorCode) + ' [' + OleFR.errorDescription + ']"');
    end
    else

  end;
end;

function TFormSalesBeerTS.RoundRub(aFloat: real; asss: integer): real;
begin
  result:=float(Ceil (aFloat*asss))/asss;
end;

procedure TFormSalesBeerTS.InitTableShems();
begin
  // ===== Справочник секций ========
  Application.ProcessMessages;
  // ===== Документ Смены ===========
  formStart.DB_checkCol('doccash','numdoc','varchar(12)','');
  formStart.DB_checkCol('doccash','datedoc','DATE','');
  formStart.DB_checkCol('doccash','numkass','int(12)','');
  formStart.DB_checkCol('doccash','namesection','varchar(64)','');
  formStart.DB_checkCol('doccash','numsection','varchar(12)','');
  formStart.DB_checkCol('doccash','numhw','varchar(20)','');    // - заводской номер ККТ
  // ==== ===========================
  Application.ProcessMessages;
  formStart.DB_checkCol('doccash','numtrans','int(12)','');
  formStart.DB_checkCol('doccash','datetrans','TIMESTAMP','');
  formStart.DB_checkCol('doccash','numcheck','int(12)','');
  formStart.DB_checkCol('doccash','kassir','int(12)','');
  formStart.DB_checkCol('doccash','typetrans','int(3)','');
  formStart.DB_checkCol('doccash','plu','int(12)','');
  formStart.DB_checkCol('doccash','name','varchar(64)','');
  formStart.DB_checkCol('doccash','eanbc','varchar(13)','');
  formStart.DB_checkCol('doccash','fullname','varchar(512)','');
  formStart.DB_checkCol('doccash','price','float','');
  formStart.DB_checkCol('doccash','quantity','float','');
  formStart.DB_checkCol('doccash','summ','float','');
  //formStart.DB_checkCol('doccash','banking','varchar(64)','');
  formStart.DB_checkCol('doccash','urlegais','varchar(255)',''); // == ПДФ416 или УРЛ
  formStart.DB_checkCol('doccash','alccode','varchar(64)','');
  formStart.DB_checkCol('doccash','regfr','char(1)',''); // === признак регистрации через ФР
  formStart.DB_checkCol('doccash','idtable','int(12)',''); // === Номер стола  0 - Быстрая продажа
  formStart.DB_checkCol('doccash','closecheck','char(1)',''); // === "1" or "+"  - закрыть чек  - завершена полностью операция по чеку
  formStart.DB_checkCol('doccash','noclosecheck','char(1)',''); // === признак не проведен чек через аппарат
  formStart.DB_checkCol('doccash','regegais','char(1)',''); // === признак проведен через ЕГАИС
  // ==== ===========================
  Application.ProcessMessages;
  formStart.DB_checkCol('doccash','banking','char(1)','');  // === признак оплаты через банк
  formStart.DB_checkCol('doccash','storepoint','varchar(20)','');

  //formStart.addSPoint('doccash');
  Application.ProcessMessages;
end;

// =============================================================================
procedure TFormSalesBeerTS.GetReport();
var
  RStr:TStringList;
begin
 if formStart.flRMKOffline then begin
   if db_boolean(formStart.GetConstant('LoadExchMode')) then begin
     formStart.SaveShtrihMFile(now(),now());
   end
   else begin
     rStr:=TStringList.Create;
     if FormStart.flRMKFolderLoad[length(FormStart.flRMKFolderLoad)] <>'\' then
       FormStart.flRMKFolderLoad:=FormStart.flRMKFolderLoad+'\';
     if FileExists(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport)) then begin
          if formStart.GetConstant('AddReportFileZ')='1' then begin
           rStr.LoadFromFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
           if rStr.Strings[0] <> '#' then
             rStr.Clear;
          end
          else
           DeleteFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
     end;

     rStr.add(formStart.SaveShtrihMFile(now(),now()));
     rStr.SaveToFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
     rStr.free;
   end;
   FRBeep;
   showmessage('Отчет выгружен.');
 end;

end;

function TFormSalesBeerTS.GetAllSumm(): real;
var
  ii:integer;
  rPrice1,rQual,rDisc1,rSumm2,rSumm1,
  fDiscSumm:real;
begin
  //flAllSumma
  flAllSumma:=0;
  flAllSummDiscount:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
    if StringGrid1.Cells[3,ii]<>'' then
       rPrice1:=strtofloat(trim(StringGrid1.Cells[3,ii]))
    else begin
       StringGrid1.Cells[3,ii]:='0';
       rPrice1:=0;
    end;
    rQual:= strtoFloat(trim(StringGrid1.Cells[4,ii]));
    if StringGrid1.Cells[17,ii]<>'' then
      rDisc1:= strtoFloat(trim(StringGrid1.Cells[17,ii]))
     else
      rDisc1:=0;
    rSumm1:= RoundRub(rPrice1*rQual,100);  // === Сумма без скидок
    if rDisc1<>0 then
      rSumm2:=RoundRub(round(rSumm1*rDisc1)/100,100)
    else
      rSumm2:=0;


    StringGrid1.Cells[3,ii]:=trim(format('%0.2f',[rPrice1]));
    StringGrid1.Cells[4,ii]:=trim(format('%3.3f',[rQual]));
    StringGrid1.Cells[5,ii] := trim(format('%8.2f',[rSumm1]));

     Stringgrid1.Cells[13,ii]:= trim(format('%8.2f',[rSumm2]));
     flAllSumma:=flAllSumma+ rSumm1 ;
     flAllSummDiscount:=flAllSummDiscount+rSumm2;
  end;
  stSumma.Caption:=trim(format('СУММА: %8.2f',[flallsumma]));

  stDiscount.Caption:=trim(format('СКИДКА: %8.2f',[flAllSummDiscount]));
  result:=flallsumma-flAllSummDiscount;
end;

end.

