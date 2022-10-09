unit UnitVIKIDevice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
{ Внешние функции для VIKI}
function VIKIInitDevice(Port: String;aBaudPort:integer):boolean;
function VIKIConnect(Port:String;ABaudPort:integer=57600):boolean;
Procedure VIKIClosePort;
procedure VIKIPrintXReport(aName:String);
procedure VIKIPrintZReport(aName:string;aOptions:integer);
Procedure VIKICutCheck;
function VIKIOpenDocument(aType:byte;aDep:byte;aName:string;aNumDoc:longint):boolean;
function VIKIPrintString(aStr:string;aOptions:byte):boolean;
function VIKIPrintBarCode(aStr:string):boolean;
{libAddPosition(const char* goodsName, const char* barcode, double quantity,
  double price, unsigned char taxNumber, int numGoodsPos, unsigned char numDepart,
  unsigned char coefType, const char *coefName, double coefValue);}
function VIKIAddPosition(aNAme:string;aArticul:string; aQuality:real;aPrice:real;flDiscount:boolean;aDiscount:real):boolean;
function VIKIAddDiscount(aPercent:real):boolean;
function VIKICloseCheck(atypeCheck:byte;aSumm:real;aDiscount:real):boolean;
procedure VIKICloseDocument;
procedure VIKIOpenDrawer;
Procedure VIKIOpenDay;
function VIKIResultCode:Integer;
function VIKIStrResult:string;

implementation
uses
  windows,
  mysql50,
  unitstart,
  dateutils,
  LConvEncoding,
  synaser,synafpc;

type
  TVIKIData = record
    ErrNum:integer;
    Data:array[0..255] of char;
    Length:integer;
  end;

  TVIKIDate = record
    Year:integer;
    mon:byte;
    day:byte;
  end;

  TVIKITime = record
    hour:byte;
    minute:byte;
    second:byte;
  end;

  TVIKIFuncInt = function():integer; stdcall; // ===
  TVIKIFuncopenPort = function(aPort:PChar;aBound:longint):integer; stdcall;
  TVIKIFuncOpenDoc =  function(aTypeDoc:byte;aDep:byte;aName:pchar;NumDoc:longint):integer;stdcall;
  TVIKIFuncPayment =  function(aTypePayment:byte;aSumm:double;aName:pchar):integer;stdcall;
  TVIKIFuncCloseDoc = function(aTypeCut:byte):TVIKIData;stdcall;
  TVIKIFuncPrintStr = function(aStr:Pchar;aType:byte):integer;stdcall;
  TVIKIFuncPrintXReport  = function(aStr:Pchar):integer;stdcall;
  TVIKIFuncComStart = function(aDAte:TVIKIDate;aTime:TVIKITime):integer;stdcall;
  TVIKIFuncPrintZReport = function(aStr:Pchar;aOptions:integer):integer;stdcall;
  TVIKIFuncDiscount =  function(aType:byte;aDiscountName:Pchar;aPercent:double):integer;stdcall;
  TVIKIFuncAddPosition = function(aName:pchar;aBC:pchar;aQuality:double;aPrice:double;TaxType:byte;numGoodPos:pChar;aDep:byte; aCOEType:byte;aCOEName:pchar;aCOEValue:double):integer;stdcall;
//TVIKIFuncAddPosition = function(aName:pchar;aBC:pchar;aQuality:double;aPrice:double;TaxType:byte;numGoodPos:integer;aDep:byte;)
 //{aCOEType:byte;aCOEName:pchar;aCOEValue:double)}:integer;stdcall;

  TVIKIFuncOpenDrawer = function(Pulse:integer):integer;stdcall;
  TVIKIFuncBarCode       = function(posText:byte; widthBarCode:byte; heightBarCode:byte;typeBarCode:byte;barCode:pchar):integer;stdcall;
var
  DLLHandle: THandle;
  dllInstance: THandle;
  Fresult:integer;
  flgOpenDoc:boolean=false;
  strBuff:WideString='';
  FSerial: TBlockSerial;
  FStrResult:string;
  FBufSer:array[0..512] of byte;
  FSerPort:string;
  FBaudPort:integer;
  {=== Функции ВИКИ принт}
  FLogo:TStringList;
procedure wrtLogo(str:string);
begin
 flogo.Add(str);
 flogo.SaveToFile('vikilogo.log');
end;

Procedure FInitDevice;
begin
  FSerial:=TBlockSerial.Create;
  FSerial.LinuxLock:= False;
  FSerial.Connect(FSerPort);
  sleep(300);
  FSerial.Config(FBaudPort, 8, 'N', SB1, False, False);
  sleep(300);
  wrtLogo('connect port:'+FSerPort);
end;

function FSetCommand(IdCommand:String;  // - ИЛ команды
  aParam:array of string; // - Параметры в строковом виде
  aCount:integer    // - колич параметров
  ;szResult:integer=9  // - Ожидаемый время ответа
  ):integer;
const
  FStrEnd = #$01C;
var
  ind1:integer;
  ii,
  i:integer;
  arrBuff:array[0..512] of char;
  strCommand:string;
  crcByte:byte=0;
  strCrc:string;
begin
  result:=0;
  strCommand:=idCommand;
  arrBuff[0] := #002; // ==STX- байт начала пакета (0x02).
  arrBuff[1]:='P';
  arrBuff[2]:='I';
  arrBuff[3]:='R';
  arrBuff[4]:='I';
  arrBuff[5] := '$'; {ID пакета- идентификатор пакета. Произвольный байт, имеющий код в промежутке между 0x20 и 0xF0}
  arrBuff[6] := strCommand[1];
  arrBuff[7] := strCommand[2];
  ind1:=8;
  for i:=0 to aCount-1 do begin
    /// передаем параметры;
    strCommand:=Utf8Tocp866(aParam[i]);
    for ii:=1 to length(strCommand) do begin

      arrbuff[ind1]:=strCommand[ii];
      ind1:=ind1+1;
    end;
    arrbuff[ind1]:=FStrEnd;
    ind1:=ind1+1;
  end;
  arrbuff[ind1]:=#03;
  ind1:=ind1+1;
  for i:=1 to ind1-1 do
    crcByte:=crcByte XOR ord(arrbuff[i] );
  strCrc:=inttohex(crcByte,2);
  arrBuff[ind1] := strCrc[1];
  ind1:=ind1+1;
  arrBuff[ind1] := strCrc[2];
  ind1:=ind1+1;
  wrtLogo(arrBuff);
  if FSerial<>nil then begin

    for i:=0 to ind1-1 do
      FSerial.SendByte(ord(arrbuff[i]));

    sleep(200);
    i:=0;
    FStrResult:='';

    i:=FSerial.RecvBufferEx(@FBufSer[0],512,szResult*30);
    if FSerial.LastError <> ErrTimeout then begin
      wrtlogo('>'+FSerial.LastErrorDesc);
    end else begin
      wrtlogo('Time out!!!'+FSerial.LastErrorDesc);
      result:=-1;
    end;
    if i<>0 then begin
        for ii:=1 to i do
          FStrResult:=FStrResult+chr(FBufSer[ii]);
        wrtlogo(FStrResult);
        if i>5 then
           result:=strtoint(chr(FBufSer[4])+chr(FBufSer[5]));
        wrtlogo(':'+chr(FBufSer[4])+chr(FBufSer[5]));
      end;
  end;
  wrtlogo('END command!!!');
  //FStrResult:=result;
end;

Procedure FCloseDevice();
begin
  if FSerial<>nil then
     begin
       wrtlogo('Close socket!!!');
       FSerial.CloseSocket;
       FSerial.Destroy;
       FSerial:=nil;
     end;
end;

function VIKIInitDevice(Port: String;aBaudPort:integer): boolean;
begin
 FSerPort:=Port;
 FBaudPort:= aBaudPort;
  result:=true;
  try
  FInitDevice;
  except
    result:=false;
  end;

end;

function VIKIConnect(Port: String;aBaudPort:integer): boolean;

begin
  wrtLogo('setting port:'+Port);

  result:=true;
  if FSerial=nil then
    VIKIInitDevice(port,aBaudport);
  try

    if FSetCommand('20',['ОПЕРАТОР'],1)=1 then
         VIKIOpenDay;
  except
    fresult:=-1;
  end;


end;

procedure VIKIClosePort;
begin
  FCloseDevice();
end;

procedure VIKIPrintXReport(aName: String);
begin

  fresult:=FSetCommand('20',[aName],1);
end;

procedure VIKIPrintZReport(aName: string; aOptions: integer);
begin
  Fresult:=FSetCommand('21',[aName,inttostr(aOptions)],2);
end;

procedure VIKICutCheck;
begin

  Fresult:=FSetCommand('34',[],0);
end;

function VIKIOpenDocument(aType: byte; aDep: byte; aName: string;
  aNumDoc: longint): boolean;
begin
  wrtLogo('Open document:');
  Fresult:=FSetCommand('30',[inttostr(aType),inttostr(aDep),aName,inttostr(aNumDoc)],4);
  if Fresult= 52 then
    wrtLogo('Исчерпан ресурс КС!!!');
  result:=true;
  flgOpenDoc:=true;
end;

function VIKIPrintString(aStr: string; aOptions: byte): boolean;
begin
  wrtLogo('Print str:'+aStr);
  if not flgOpenDoc then
     VIKIOpenDocument(1,0,'СИС.АДМИН',0);
  try
    Fresult:=FSetCommand('40',[astr,inttostr(aOptions)],2);
  except
    result:=false;
  end;
end;

function VIKIPrintBarCode(aStr: string): boolean;
begin
  result:=true;
  //libPrintBarCode(unsigned char posText, unsigned char widthBarCode, unsigned char heightBarCode, unsigned char typeBarCode, const char* barCode);
  //strbuff:=utf8tocp866(aStr);
  try
    //Fresult:=FVIKIFuncBarCode(0,2,2,8,pchar(strbuff));
    Fresult:=FSetCommand('41',['0',
    '5',
    '5',
    '8',
    aStr],5);
  except
    Fresult:=-1;
    result:=false;
  end;
end;

function VIKIAddPosition(aNAme: string; aArticul: string; aQuality: real;
  aPrice: real;flDiscount:boolean;aDiscount:real): boolean;
var
  aNameD:Widestring;
  aTypeD:string;
begin
  result:=true;
  strbuff:=utf8tocp866(aNAme);
  aTyped:='0';
  aNAmeD:='';
  if flDiscount then begin
     aTypeD:='1';
     aNAmeD:=('СКИДКА '+floattostr(aDiscount));
  end;
  try
   { Fresult:=FVIKIFuncAddPosition(
    pchar(string(strbuff)),
    pchar(aArticul),
    double(aQuality),
    double(aPrice),0,pchar('1:'),1,aTyped,pchar(aNameD),Double(aDiscount));
    }
    Fresult:=FSetCommand('42',[aNAme,
    aArticul,
    format('%0.3f',[aQuality]),
    format('%0.2f',[aPrice]),
    '0',
    '',
    '1',
    aTypeD,
    aNAmeD,
    format('%0.2f',[aDiscount])],10);

  except
    Fresult:=-1;
    result:=false;
  end;
end;

function VIKIAddDiscount(aPercent: real): boolean;
begin
  result:=true;
  strbuff:=('СКИДКА '+floattostr(aPercent)+'%');
  try
    //Fresult:=FVIKIFuncDiscount(0,pchar(string(strbuff)),Double(aPercent));
    Fresult:=FSetCommand('45',['0',strbuff,format('%0.2f',[aPercent])],3);
  except
    fResult:=-1;
    result:=false;
  end;
end;

function VIKICloseCheck(atypeCheck: byte;  {0 - Наличными }
  aSumm:real;
  aDiscount: real): boolean;
begin
  {1. подитог
   2. скидка
   3. ПОдитог
   4. Оплата
   5. Закрыть документ}
  result:=true;
  try
    Fresult:=FSetCommand('44',[],0);
    Fresult:=FSetCommand('44',[],0);
  except
    Fresult:=-1;
    result:=false;
  end;
  try
    // fresult:=FVIKIFuncPayment(aTypeCheck,double(aSumm),'kassir');
     Fresult:=FSetCommand('47',[inttostr(aTypeCheck),format('%0.2f',[aSumm]),''],3);

  except
    FResult:=-1;
    result:=false;
  end;
  try
    VIKICloseDocument;

  except
    result:=false;
    fResult:=-1;
  end;
end;

procedure VIKICloseDocument;
begin
  Fresult:=FSetCommand('31',['1',''],2);
  flgOpenDoc:=false;
end;

procedure VIKIOpenDrawer;
begin
  Fresult:=FSetCommand('80',['150','0'],2);
end;

procedure VIKIOpenDay;
begin

  try
    fresult:=FSetCommand('10',[FormatDateTime('DDMMYY',now()),FormatDateTime('hhmmss',now())],2);
  except
    fresult:=-1;
  end;



end;

function VIKIResultCode: Integer;
begin
  result:=FResult;
end;

function VIKIStrResult: string;
begin
 result:=FStrResult;
end;

begin
  FSerial:=nil;
  FLogo:=TStringList.Create;
end.

