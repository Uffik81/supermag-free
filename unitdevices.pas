unit Unitdevices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function  ThisBeer(fIMNS:string):boolean;
function  GetShiftCash():string;
function  Utf8ToWide(const aStr:String):widestring;
function  AnsiToWide(const aStr: ansiString):widestring;
function  FloatToStrRub(aSumm: real): string;
Procedure FRCutCheck();
procedure FRFeedDocument(StepDown:integer);
procedure FRAddPosition(aName:string; aQuantity: real; aPrice:real; aTax:integer; aUser:integer; aReturn:boolean=false);
procedure FROpenDocSales();
procedure FROpenDocReturn;
procedure FRCloseCheck(aSumm:real;aOperBank:boolean;aUser:integer);
function  FRGetStatus(Messages: boolean): Integer;
function  InitDevices(aTypeKKM:integer; flkkmenabled,flbankenabled:boolean): boolean;
procedure FRPrintXReport;
function  FRCashIncome(aSumm:real):integer;
function  FRCashOutcome(aSumm:real):integer;
procedure FRPrintZReport;
procedure FRShowOptions;
function  FRPrintLineStringAnsi(const aStr: ansiString): integer;
procedure FRCancelCheck();
Procedure CBCloseDay();
procedure FRPrintSlipSB(aCountSlip:integer=1);
function  CBSalesCardSB( flCountSlip,aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;
function FRReturnSalesCardSB( flCountSlip, aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;
function FRCancelSalesCardSB( flCountSlip, aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;


{=== ФИТО ====}


implementation
uses
  mysql50,
  DOM, XMLRead, typinfo,
  qrcode,
  comobj,  variants,
  LCLIntf,
  lconvencoding,
  INIFiles,
  lclproc
  ,fphttpclient // Стандартная библиотека для http
  ,dialogs
  ;

const
  CRLF = #13#10;

var
  OleFR:Olevariant;
  OleSBR:Olevariant;
  flTypeKKM:integer;
  FlgLoadLibSB:boolean;
  FlgLoadLibFR:boolean;
  SizeStrFr:integer;

function  AnsiToWide(const aStr: ansiString):widestring;
var
  str1:WideString;
begin
  str1:=aStr;
  result:= str1;
end;

function  Utf8ToWide(const aStr: String):widestring;
var
  str1:AnsiString;
begin
  str1:=utf8toAnsi(aStr);
  result:=AnsiToWide(str1) ;
end;


function ThisBeer(fIMNS: string): boolean;
begin
   result:=false;
   if fIMNS ='500' then result:=true;
   if fIMNS ='520' then result:=true;
   if fIMNS ='261' then result:=true;
   if fIMNS ='263' then result:=true;
   if fIMNS ='262' then result:=true;
end;


function PrintLineStringAnsi(const aStr: ansiString): integer;
var
  i:byte;
  str1:WideString;
  str2:string;
begin
  str1:=aStr;
  if (FlgLoadLibFR) then
   begin                     //12345678901234567890123456789012345678901234567890
     try
      case fltypeKKM of
       0:begin OleFR.StringForPrinting:= str1;
               OleFR.PrintString();
         end;
       1:begin
         OleFR.Caption:=Str1;
         OleFR.PrintString();
       end;
       2:begin
         OleFR.PrintString(Str1,1);
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

function PrintLineString(const aStr: String): integer;
begin
  result:=PrintLineStringAnsi(Utf8ToAnsi(astr));
end;

function GetShiftCash: string;
var                // вычисляем смену количество дней прошедших от 2016-01-01
 year,month,day:word;
begin
 year:=0;
 month:=0;
 day:=0;
 DecodeDate(now(),year,month,day);
 year:=year-2016;
 result:=inttostr( year*12*32+month*32+day);
end;

function printURL(const aURL,aSIGN:string):boolean;
var
  str1:string;
  strwd1:WideString;
  res:integer;
begin
 result:=false;
//              AResponse.Content:= '';
//            AResponse.Content:=AResponse.Content+url+#13#10;  // первый url
   try
  if FlgLoadLibFR then
   begin
     case flTypeKKM of
       0:begin
         OleFR.password:=30;
         strwd1:=aURL;
         OleFR.BarCode := strwd1;
         OleFR.BarWidth :=2;
         OleFR.LineNumber:=150;
         OleFR.BarcodeAlignment:=0;
         OleFR.BarcodeType:=3;
         OleFR.PrintBarcodeGraph();
         printURL:=true;
       end;
       1:begin
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
           //showmessage('Atol error='+inttostr(res));
           printURL:=false;
         end else
           printURL:=true;
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
    except
     result:=false;
    end;


end;

function GetStatusFR(Messages: boolean): Integer;
var
  OldstatusFR:integer;
begin
 result:=0;
 if fltypekkm=0 then
  begin
     // ******* обработка состояния ккм **************
     OldStatusFR:=OleFR.ResultCode;
     //OleFR.DeviceEnabled := 1;
     OleFR.Password:=30;
     OleFR.GetECRStatus();
     //showmessage('Статус ККТ:'+inttostr(OleFR.ResultCode));
     if OleFR.ResultCode <> 0 then begin
       case OleFR.ResultCode of
         100:;//showmessage('Ошибка ФП!');
         113:;{begin
            showmessage(
            'Ошибка отрезчика!'+#13#10+
            ' Попробуйте выключить аппарат, открыть крышку.'+#13#10+
            ' Удалить бумагу, вернуть нож отрезчика наместо и  включить устройство.'+#13#10+
            'Как просигналит аппарат нажмите кнопку "Ок"');
            result:=GetStatusFR(Messages);
            if result>=0 then
              exit;
         end;  }
         78: ;//Showmessage('Не закрыта предыдущая смена!');
         116: ;//Showmessage('Ошибка ОЗУ, требуется тех. обнуление.');
         88:; // === ожидает команду продолжить печать
         else
           //showmessage('Ошибка ККМ:'+inttostr(OleFR.ResultCode));
       end;
       result:=-1;
       exit;
     end;

     result:=OleFR.ECRMode;
     if result in [0,2,3,4] then begin
       if result = 3 then // принудительно закрываем смену.
          //PrintXReport();
       result:=0 ;
       exit;
     end;
     result:= OleFR.ECRAdvancedMode;
     if result = 1 then begin
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
       if messages then
        //showmessage('Будет отменен предыдущий чек!' );
        OleFR.Password:=30;
        OleFR.CancelCheck();
        result:=-1;
       end;

    // result:=OleFR.GetStatus() ;

  end;
  if fltypekkm=1 then
  begin
   OleFR.DeviceEnabled := 1;
   result:= OleFR.ResultCode ;
  end;

end;

function InitDevices(aTypeKKM:integer; flkkmenabled,flbankenabled:boolean): boolean;
var
  str1:string;
begin
  if not (FlgLoadLibFR or FlgLoadLibSB) then begin
    flTypeKKM:=aTypeKKM;
    SizeStrFr:=48; // -- Количество символов в строке FR
    if not flkkmenabled then
      exit;
    try
     case flTypeKKM of
      0: OleFR:= CreateOleObject('Addin.DRvFR') ;
      1: OleFR:= CreateOleObject('Addin.FprnM45') ;
      else
        OleFR:= CreateOleObject('Addin.DRvFR')
      end;
      FlgLoadLibFR:=true;
    except
      //showmessage('Ошибка драйвера ККМ/АСПД!');
      FlgLoadLibFR:=false;
    end;
    if flbankenabled then begin
      try
        OleSBR:= CreateOleObject('SBRFSRV.Server');
        FlgLoadLibSB:=true;
      except
        FlgLoadLibSB:=false;
      end;
    end;
    if FlgLoadLibFR then
     begin
       if GetStatusFR(false)=-1 then
         FlgLoadLibFR:=false;
     end;

  end;
end;


function FloatToStrRub(aSumm: real): string;
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
 drob1:=copy(drob1,2,4);
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

procedure FRCutCheck;
var
  res:integer;
begin
  if FlgLoadLibFR then begin
      OleFR.Password :=30;
      OleFR.FeedAfterCut:=true;
      OleFR.CutType:=true;
      OleFR.CutCheck();
      if flTypeKKM = 0 then begin
        res:=OleFR.ResultCode;
        if res <>0 then begin
          showmessage('Ошибка ККМ "'+OleFR.ResultCodeDescription+'", устраните ее и нажмите "ОК".');
        end;
      end;

  end;
end;

procedure FRFeedDocument(StepDown:integer);
begin
  if FlgLoadLibFR then begin
    if flTypeKKM=0 then begin
     OleFR.Password :=30;
     OleFR.StringQuantity:=StepDown;
     OleFR.UseSlipDocument:=false;
     OleFR.UseReceiptRibbon:=true;
     OleFR.UseJournalRibbon:=false;
     OleFR.FeedDocument();
    end;
  end;
end;

procedure FRAddPosition(aName: string; aQuantity: real; aPrice: real;
  aTax: integer; aUser: integer; aReturn:boolean=false);
var
  strw:WideString;
begin
  strw:=utf8ToWide(aName);
//strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
  if FlgLoadLibFR then begin
    if flTypeKKM=0 then begin
      OleFR.Password:=aUser;
      OleFR.Quantity:=aQuantity;
      OleFR.Price:= aPrice;
      OleFR.Department:= 0;
      OleFR.Tax1:=aTax;
      OleFR.Tax2:=0;
      OleFR.Tax3:=0;
      OleFR.Tax4:=0;
      OleFR.StringForPrinting:=strw;
      if aReturn then
        OleFR.ReturnSale()
      else
        OleFR.sale();
    end;
    if flTypeKKM=1 then begin
     OleFR.Name := strw;
     OleFR.Price := aPrice;
     OleFR.Quantity := aQuantity; ;
     OleFR.Department := 0;
     if aReturn then
        OleFR.Return()
       else
        OleFR.Registration() ;
    end;
  end;
end;


procedure FROpenDocSales;
begin
  if FlgLoadLibFR then begin
    if flTypeKKM=1 then begin
      OleFR.Mode := 1;
      OleFR.SetMode();
      OleFR.CheckType:=1;
      OleFR.OpenCheck();
    end;
  end;
end;

procedure FROpenDocReturn;
begin
  if FlgLoadLibFR then begin
    if flTypeKKM=1 then begin
      OleFR.Mode := 1;
      OleFR.SetMode();
      OleFR.CheckType:=2;
      OleFR.OpenCheck();
    end;
  end;
end;

procedure FRCloseCheck(aSumm: real;aOperBank:boolean;aUser:integer);
var
  strw:WideString;
  res:integer;
begin
  strw:='';
  if FlgLoadLibFR then begin
    if flTypeKKM=1 then begin
      OleFR.Summ := aSumm;  // Сумма оплаты
      if  aOperBank then
       OleFR.TypeClose := 4
      else
      OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
      OleFR.Payment();
      OleFR.TypeClose := 0;
      OleFR.CloseCheck() ;
    end;
    if flTypeKKM=0 then begin
     OleFR.Password:=aUser;
     OleFR.Quantity:=1;
     if  aOperBank then begin
      OleFR.Summ1:= 0;
      OleFR.Summ4:= aSumm;
     end else
     begin
      OleFR.Summ1:= aSumm;
      OleFR.Summ4:= 0;
     end;
     OleFR.Summ2:= 0;
     OleFR.Summ3:= 0;
     //OleFR.Summ4:= 0;
     OleFR.Tax1:=0;
     OleFR.Tax2:=0;
     OleFR.Tax3:=0;
     OleFR.Tax4:=0;
     OleFR.StringForPrinting:=strw;
     res:=OleFR.CloseCheck();
     OleFR.OpenDrawer();
    end;
  end;
end;



function FRGetStatus(Messages: boolean): Integer;
var
  OldstatusFR:integer;
begin
 result:=0;
 if fltypekkm=0 then
  begin
     // ******* обработка состояния ккм **************
     OldStatusFR:=OleFR.ResultCode;
     //OleFR.DeviceEnabled := 1;
     OleFR.Password:=30;
     OleFR.GetECRStatus();
     //showmessage('Статус ККТ:'+inttostr(OleFR.ResultCode));
     if OleFR.ResultCode <> 0 then begin
       case OleFR.ResultCode of
         100:showmessage('Ошибка ФП!');
         113:begin
            showmessage(
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
         else
           showmessage('Ошибка ККМ:'+inttostr(OleFR.ResultCode));
       end;
       result:=-1;
       exit;
     end;

     result:=OleFR.ECRMode;
     if result in [0,2,3,4] then begin
       if result = 3 then // принудительно закрываем смену.
          FRPrintXReport();
       result:=0 ;
       exit;
     end;
     result:= OleFR.ECRAdvancedMode;
     if result = 1 then begin
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
  {    if result = 5 then begin
          showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                      ' вставьте новый рулон и нажмите "Ок".' );
          OleFR.Password:=30;
          OleFR.InterruptFullReport();
          result:= OleFR.ECRAdvancedMode;
          if result<>0 then
            begin
              result:=-1;
              exit;
            end;
        end;     }
     if result = 8 then begin
       if messages then
        showmessage('Будет отменен предыдущий чек!' );
        OleFR.Password:=30;
        OleFR.CancelCheck();
        result:=-1;
       end;

    // result:=OleFR.GetStatus() ;

  end;
  if fltypekkm=1 then
  begin
   OleFR.DeviceEnabled := 1;
   result:= OleFR.ResultCode ;
  end;

end;
procedure FRPrintXReport;
var
  res:integer;
begin
  // Отчет с гашением ККМ
  if FlgLoadLibFR then
  case flTypeKKM of
    0:begin
      OleFR.PrintReportWithCleaning();
      res:= OleFR.ECRAdvancedMode;
      if res = 5 then begin
         showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                     'вставьте новый рулон и нажмите "Ок".' );
         OleFR.Password:=30;
         OleFR.InterruptFullReport();
         res:= OleFR.ECRAdvancedMode;
       end;

    end;
    1:begin
      OleFR.Mode := 3;   // Режим отчетов без гашения
      OleFR.Password := 30;  // Пароль системного администратора
      OleFR.SetMode();
      OleFR.ReportType :=1;
      OleFR.Report();
    end;

  end;

end;

function FRCASHOutcome(aSumm:real):integer;
begin
  result:=0;
  if FlgLoadLibFR then begin
    if flTypeKKM=0 then begin
      OleFR.Password:=30;
      OleFR.Summ1:=aSumm;
      OleFR.CashOutcome();
      result:=OleFR.OpenDocumentNumber;
    end else
      result:=0;
  end;

end;
function FRCashIncome(aSumm:real):integer;
begin
  result:=0;
if FlgLoadLibFR then
  if flTypeKKM=0 then begin
     OleFR.Password:=30;
     OleFR.Summ1:=aSumm;
     OleFR.CashIncome();
     result:=OleFR.OpenDocumentNumber;
  end;
end;

procedure FRPrintZReport;
var
  res:integer;
begin
if FlgLoadLibFR then begin
   case flTypeKKM of
     0: begin
       OleFR.PrintReportWithoutCleaning();
       res:= OleFR.ECRAdvancedMode;
       if res = 5 then begin
          showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                      ' вставьте новый рулон и нажмите "Ок".' );
          OleFR.Password:=30;
          OleFR.InterruptFullReport();
          res:= OleFR.ECRAdvancedMode;
        end;
       end;
     1:begin
       OleFR.Mode := 2;   // Режим отчетов без гашения
       OleFR.Password := 30;  // Пароль системного администратора
       OleFR.SetMode();
       OleFR.ReportType :=2;
       OleFR.Report();
     end;

   end;
end;
end;

procedure FRShowOptions;
begin
if FlgLoadLibFR then
   OleFR.ShowProperties();
end;

function FRPrintLineStringAnsi(const aStr: ansiString): integer;
var
  i:byte;
  str1:WideString;
  str2:string;
begin
  str1:=aStr;
  if (FlgLoadLibFR) then
   begin                     //12345678901234567890123456789012345678901234567890
     try
      case fltypeKKM of
       0:begin OleFR.StringForPrinting:= str1;
               OleFR.PrintString();
         end;
       1:begin
         OleFR.Caption:=Str1;
         OleFR.PrintString();
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

procedure FRCancelCheck;
begin
  if FlgLoadLibFR then begin
   if fltypeKKM=0 then begin
      OleFR.Password :=30;
      OleFR.CancelCheck()
   end;
  end;
end;

procedure FRPrintSlipSB(aCountSlip:integer=1);
//  FlgLoadLibSB
var
  StrSlip:WideString;
  ListStr:TStringList;
  i:integer;
  ind:integer;
begin
  if not FlgLoadLibSB then begin
   exit;
  End;
  ListStr:= TStringList.Create;
  StrSlip:=OleSBR.GParamString ('Cheque');
  ListStr.Text:=AnsiTOUtf8(StrSlip);
  for ind:=1 to aCountSlip do begin
    for i:=0 to ListStr.Count-1 do begin
        PrintLineString(ListStr.Strings[i]);
        if pos('==========',ListStr.Strings[i])<>0 then begin
          if FlgLoadLibFR then begin
            FRFeedDocument(7);
            FRCutCheck();
          end;
        end;
    end;
  FRCutCheck();
  end;
  ListStr.Destroy;
end;

function CBSalesCardSB(flCountSlip, aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;
var
  Summ:Int64;
begin
  result:=false;
  if FlgLoadLibSB then begin
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  summ := Round(aSumm*100);
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  OleSBR.SParam('Department',aDepart) ;
  if OleSBR.NFun(4000) = 0 then begin
  	FRPrintSlipSB(flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        result:=true;
  end else begin
     result:=false;
     CodeAuth := '000000000000';
     CodeRRN  := '00000';
  end;

  End;
end;

procedure CBCloseDay;
begin
  if not FlgLoadLibSB then begin
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  // --- Вызываем функцию ----
  if OleSBR.NFun(6000) = 0 then
        FRPrintSlipSB(1);

end;

function FRCancelSalesCardSB( flCountSlip, aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;
var
  Summ:Int64;
  Str1:WideString;
begin
  result:=false;
  if  FlgLoadLibSB then begin
    // --- Очищаем все значениЯ переменных ---
    OleSBR.Clear();
    Str1:=CodeRRN;
    summ := Round(aSumm*100);
    // --- Вызываем функцию ----
    OleSBR.SParam('Amount',Summ) ;
    OleSBR.SParam('Department',aDepart) ;
    OleSBR.SParam('RNN',Str1) ;
    if OleSBR.NFun(4003) = 0 then begin
  	  FRPrintSlipSB(flCountSlip);
  	  CodeRRN := OleSBR.GParamString ('RRN');
  	  CodeAuth := OleSBR.GParamString ('AuthCode');
          result:=true;
    end else begin
      result:=false;
      CodeAuth := '000000000000';
      CodeRRN  := '00000';
    end;
  End;
end;

function VIKIInitDevice: boolean;
begin

end;

function FRReturnSalesCardSB( flCountSlip, aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):boolean;
var
  Summ:Int64;
  Str1:WideString;
begin
  result:=false;
  if FlgLoadLibSB then begin
    // --- Очищаем все значениЯ переменных ---
    OleSBR.Clear();
    Str1:= CodeRRN;
    summ := Round(aSumm*100);
    OleSBR.SParam('RNN',Str1) ;
    // --- Вызываем функцию ----
    OleSBR.SParam('Amount',Summ) ;
    OleSBR.SParam('Department',aDepart) ;
    if OleSBR.NFun(4002) = 0 then begin
  	  FRPrintSlipSB(flCountSlip);
  	  CodeRRN := OleSBR.GParamString ('RRN');
  	  CodeAuth := OleSBR.GParamString ('AuthCode');
          result:=true;
    end else
      result:=false;
  End;

end;

begin
  // ==== предварительная настройка переменных ====
  FlgLoadLibFR:=false;
  FlgLoadLibSB:=false;
  //OleSBR:=nil;
  //OleFR:=nil;
end.

