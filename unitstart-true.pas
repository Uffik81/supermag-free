unit unitStart;

{$mode objfpc}{$H+}
{ стартовое окно, для первоночальных настроек}
interface

uses
  Classes, SysUtils, sqldb, mysql50conn, FileUtil, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,
  mysql50,  DOM,
  XMLRead;

CONST
  CurVer = '1.0.6.29';
  ReportVer = '1.0.0.3';
  NameOEM = '' ;
  NameApp = 'Клиент для ЕГАИС';

type

  { TFormStart }

  TFormStart = class(TForm)
    Image1: TImage;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure MySQL50Connection1Log(Sender: TSQLConnection;
      EventType: TDBEventType; const Msg: String);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    EgaisKod:String;
    FirmAddress:String;
    FirmINN:String;
    FirmKPP:String;
    FirmShortName,
    FirmFullName:String;
    utmip:string;
    utmport:string;
    pathDir:String;
    mysqlurl:string;
    mysqluser:String;
    mysqlpassword:string;
    flErrorEGAIS:String;
    // ==== режимы работ ======
    flLoadProcuct:boolean;
    flOptMode:boolean;
    flAsAdmin:boolean;
    flRefreshEGAIS:boolean;
    flUpdateAdmin:boolean;
    flDocStatusEdit:boolean;
    // ===============
    prefixdb:String; // === Префикс БД ====
    curVersion:String;
    curVerReport:string; // === Версия отчетов ====
    prefixClient:String;
    // ========= автообновление =====
    stepLoad:integer;
    autoload:boolean;
    deltaautoload:integer;
    // ============
    SockMySQL : PMYSQL;
    qmysql : st_mysql;
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
    flLowConnect:boolean;
    flDemoMode:boolean;
    rmkFont:TFont;
    flkkmenabled:boolean;
    flSpUpdate:boolean;
    // ========================================
    function SaveToServerPOST(const fparam,fstr:string):string;
    function SaveToServerGET(const fparam,fstr:string):string;
    function SaveToServerDELETE(const fparam,fstr:string):string;
    function GetFSRARID():String;
    function PathFile():String;
    function LoadEGAISTovar(const inn:string):String;
    function LoadEGAISClient(const inn:String):String;
    // ===== Работа с СУБД =====
    procedure CreateBD();
    function ConnectDB():boolean;
    procedure disconnectDB();
    function DB_query(const sSQL:String):PMYSQL_RES;
    function DB_Next(aRes:PMYSQL_RES):MYSQL_ROW;
    function DB_checkTable(aTable:String):boolean;
    function DB_checkCol(aTable,aCol,aType,aSize:String; aDefault:string=''):boolean;
    function SpFindOfCode(const aSpr,aCode:string):string;
    function DB_StrToDate(const aStrDate:string):TdateTime;
    // ======
    procedure loadFromFileTTN();
    procedure loadFromEGAISTTN(const aSTR:String);
    Procedure refreshEGAIS();
    Procedure refreshEGAISReply();
    Procedure refreshEGAISformB();
    Procedure GetTTNfromEGAIS(const NumDoc,DocDate:String);
    function loadFromEGAISFormB(const aSTR:String):boolean;
    Procedure FromEGAISofActTTH(const numdoc, datedoc,docid:String);  // Отправка акта
    Procedure GetRetTTNfromEGAIS(const NumDoc,DocDate:String);   // Отправка акта
    Procedure readOstatok();
    Procedure loadFromEGAISRests(const aStr:string);
    Procedure LoadEGAISsprProduct(const aStr:string);
    Procedure LoadEGAISsprPartner(const aStr, uid:string);
    function XmlToStrDate(const aStr:String):String;
    function loadWayBillAct(const aStr:String):boolean;
    Procedure LoadTicketEGAIS(const aStr, aUID:String);
    Procedure loadReplyFormA(const aStr, aUID:String);
    Procedure loadReplyFormB(const aStr, aUID:String);
    function DecodeEGAISPlomb(const aStr:string; var aAlcCode,aPart, aSerial:String):boolean;
    Procedure LoadActInventoryInformBReg(const aStr, aUID:String);
    Procedure FromSaleActTTH(const numdoc, datedoc:String;isAccept:boolean);
    Procedure refreshEGAISIn();
    // === Работа с константами
    procedure SetConstant(const aName, aValue:String);
    function  GetConstant(aName:String):String;
    Procedure LoadQueryHistoryFormB(const aStr, aUID:String);
    Procedure SendQueryHistoryFormB(const fbTTN:String);
    function GetAlcCodeFormB(const aFormB:String):String;
    procedure QueryFormA(const aFormA:String);
    function updateReport():String;
    function GetEAN13rib(s_alccode:string):string;
    function SetEAN13rib(s_alccode,a_name:string;s_ean13:string):string;
    Function controlena13(strBC:String):boolean;
    function StrToFloat(const strDouble:String):double;
    function Str1ToDate(const strDate:String):TDateTime;
    // ===== ver 2 =====================
    function SendQueryRestsShopv2():boolean;
    function  ActChargeOnShopv2(const numdoc,datedoc:string):boolean;// === отправляем оприходование в розницу в2
    procedure QueryAP_v2(const aAlcCode:String);
    Procedure loadFromEGAISRestsShop_v2(const aStr:string);
    // =======================================
    function NewGUID():String;
    function getXMLtoURL(const aStr:string):String;
    // ==== обработка статуса документа =====
    function GetStatusDoc(
      aNumdoc,           // == Номер документа
      aDateDoc,          // == Дата документа
      aGUID,             // == Ид документа
      aType:string; var     // == вид документа ===
      IsActive,          // == Отправлен в ЕГАИС без ошибок
      IsDelete,          // == Помеч на удаление
      isEgaisOk          // == Принят ЕГАИС - ответ от егаис имеется
      :boolean):boolean; // результат true- документ найден, false - нет такого документа
    function SetStatusDoc(
      aNumdoc,           // == Номер документа
      aDateDoc,          // == Дата документа
      aGUID,             // == Ид документа
      aType:string;      // == вид документа ===
      IsActive,          // == Отправлен в ЕГАИС без ошибок
      IsDelete,          // == Помеч на удаление
      IsUserOk,          // == Подтверж КА
      isUserDivisive,    // == Акт разн
      isEgaisOk          // == Принят ЕГАИС - ответ от егаис имеется
      :boolean):boolean; // результат true- документ найден, false - нет такого документа
    function readUTMinfo():boolean;
    function Setwaybillv2():boolean;
    function UpdateProducer(const ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,ClientAddress,RegionCode,Country:string):boolean;
    function UpdateProduct(const AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,iClientKodEgais:string):boolean;
    function loadXmlProducer(aChild:TDOMNode; oref:String = 'oref'):String;
    function loadXmlProduct(aChild:TDOMNode; pref:String = 'pref'):String;
  end;

var
  FormStart: TFormStart;


function replaceStr(aStr:string):String;
function StringToHex(aStr:String):String;

implementation

{$R *.lfm}
uses

  typinfo,
  winsock,
  sockets,
  comobj,
  variants,
  LCLIntf,
  base64,
  lconvencoding,
  INIFiles
  ,unitJurnale
  ,unitBuyTTH
  ,lclproc
  ,fphttpclient // Стандартная библиотека для http
  ,zipper
  ,unitInfo
  ,unitlogging
  ;

const
  CRLF = #13#10;


function TFormStart.GetStatusDoc(
    aNumdoc,
    aDateDoc,
    aGUID,
    aType:string; var
    IsActive,
    IsDelete,
    isEgaisOk
    :boolean):boolean;
var
  status1:string;
begin
  {
   комбинации:
    IsActive - был отправлен в егаис
    isEgaisOk - принят в егаис
    isDelete -
  }
  result:=false;
  rowbuf:=DB_NEXT(DB_Query('SELECT `status`,`isDelete` FROM `docjurnale` WHERE (`type`='''+aType+''')AND(`dateDoc`='''+aDateDoc+''')AND(`numdoc`='''+aNumdoc+''') LIMIT 1; '));
  if rowbuf<>NIL then begin
    status1:=rowbuf[0];
    if rowbuf[1] = '+' then
      IsDelete:=true
      else IsDelete:=false;
    if status1[1] = '+' then
      IsActive:=true
      else IsActive:=false;
    if status1[3] = '+' then
      isEgaisOk:=true
      else isEgaisOk:=false;
    result:=true;
  end;
end;

function TFormStart.SetStatusDoc(
    aNumdoc,
    aDateDoc,
    aGUID,
    aType:string;
    IsActive,
    IsDelete,
    IsUserOk,
    isUserDivisive,
    isEgaisOk
    :boolean):boolean;
begin

end;

function tformstart.UpdateProducer(const ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,ClientAddress,RegionCode,Country:string):boolean;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin

  Query:='SELECT * FROM `spproducer` WHERE `ClientRegId`='''+ClientKodEgais+''';';
  xrecbuf := DB_Query(Query);
  xrowbuf:=DB_Next(xrecbuf);
 if xrowbuf=Nil then begin  // == Нет? Создаем.
    Query:='INSERT INTO `spproducer` (`ClientRegId`, `FullName`, `ShortName`,`inn`, `kpp`, `description`, `region`,`Country`) VALUES '
          +' ('''+ClientKodEgais+''','''+ClientName+''','''+ShortName+''','''+ClientINN+''','''+ClientKPP+''','''+ClientAddress+''','''+RegionCode+''','''+Country+''');';
    DB_Query(Query);
  end
  else if flSpUpdate then begin // == Обновляем
    Query:='UPDATE  `spproducer` SET `FullName`='''+ClientName+''', `ShortName`='''+ShortName+''','+
           '`Country`='''+Country+''', `description`='''+ClientAddress+''', `inn`='''+ClientINN+''',`kpp`='''+ClientKPP+''', `region`='''+RegionCode+'''  WHERE `ClientRegId`='''+ClientKodEgais+''';';
    DB_Query(Query);

  end;
  result:=true;
end;

// ======= обновление продукции ======
function tformstart.UpdateProduct(const AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,
          iClientKodEgais:string):boolean;
var
  aAlcName,
  egaisalcname,
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;

begin
  result:=true;
  formjurnale.StatusBar1.Panels.Items[2].Text:=AlcName;
    egaisalcname:= AlcName;
    aAlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
    formjurnale.StatusBar1.Panels.Items[2].Text:=aAlcName;
  Query:='SELECT * FROM `spproduct` WHERE `AlcCode`='''+AlcCode+''';';
  xrecbuf := DB_Query(Query);
  xrowbuf:=DB_Next(xrecbuf);
  if rowbuf=Nil then  begin  // == Нет? Создаем.
    Query:='INSERT INTO `spproduct` (`AlcCode`,`Name`,`egaisname`,`Capacity`,`AlcVolume`,`ProductVCode`,`ClientRegId`,`import`,`IClientRegId`) VALUES'
          +' ('''+AlcCode+''','''+aAlcName+''','''+egaisalcname+''','''+Capacity+''','''+AlcVolume+''','''+ProductVCode+''','''+ClientKodEgais+''','''+flImport+''','''+IClientKodEgais+''');';
    DB_Query(Query);
  END else
  begin
    if flImport='1' then begin
      Query:='UPDATE `spproduct` SET `Name`='''+aAlcName+''', `egaisname`='''+egaisalcname+''', `import`='''+flImport+''',`IClientRegId`='''+IClientKodEgais+''' WHERE '
            +'(`AlcCode`='''+AlcCode+''');';
      DB_Query(Query);
    end;
  end;
  DB_Query('UPDATE `sprgoods` SET `name`='''+aAlcName+''',`fullname`='''+aAlcName+''' WHERE `alccode`='''+AlcCode+''';');
end;



function ByteToAddr(const a1,a2,a3,a4:byte):Longint;
var
  i:integer;
begin
  result:=HostToNet(((a1 shl 24)or(a2 shl 16))or((a3 shl 8) or a4));
end;

// Получем IP адрес....
function HostToIP(name: string; var Ip: string): Longint;
var
  wsdata : TWSAData;
  hostName : array [0..255] of AnsiChar;
  hostEnt : PHostEnt;
  addr : PAnsiChar;
begin
  WSAStartup ($0101, wsdata);
  try
    gethostname (hostName, sizeof (hostName));
    StrPCopy(hostName, name);
    hostEnt := gethostbyname (hostName);
    if Assigned (hostEnt) then
      if Assigned (hostEnt^.h_addr_list) then begin
        addr := hostEnt^.h_addr_list^;
        if Assigned (addr) then begin
          IP := Format ('%d.%d.%d.%d', [byte (addr [0]),
          byte (addr [1]), byte (addr [2]), byte (addr [3])]);
          Result := ByteToAddr(byte(addr[0]),byte(addr[1]),byte(addr[2]),byte(addr[3]));
        end
        else
          Result := 0;
      end
      else
        Result := 0
    else begin
      Result := 0;
    end;
  finally
    WSACleanup;
  end
end;

function EncodeStringBase64(const Src: string): string;
var
  Outstream: TStringStream;
  Encoder: TBase64EncodingStream;
begin
  Outstream := TStringStream.Create('');
  try
    Encoder := TBase64EncodingStream.Create(outstream);
    try
      Encoder.Write(Src[1], Length(Src));
    finally
      Encoder.Free;
    end;
    Outstream.Position := 0;
    Result := Outstream.ReadString(Outstream.Size);
  finally
    Outstream.Free;
  end;
end;

function replaceStr(aStr:string):String;
var
  i:integer;
begin
  result:='';
  for i:=1 to length(aStr) do
    case aStr[i] OF
     '&': result:=result+'&amp;';
     '''': result:=result+'''''';
     '\': result:=result+'\\';
     ':': result:=result+''
     else
        result:=result+aStr[i];
    end;
end;

function StringToHex(aStr:String):String;
const
  HexChars: array[0..15] of Char = '0123456789ABCDEF';

var
  i:integer;
begin
  result:='';
  for i:=1 to length(aStr) do begin
     result :=result+ HexChars[(Byte(aStr[I]) and $F0) SHR 4]+HexChars[(Byte(aStr[I]) and $0F)];
  end;


end;

procedure TFormStart.FormCreate(Sender: TObject);
var
      Fini:TIniFile;
    i:integer;
   sFile:String;
begin
  DefaultFormatSettings.DecimalSeparator:='.';
//  PathFile:=extractfilepath(paramstr(0));
  // ---- ИД Клиента ----
  EgaisKod:='0'+inttoStr(50*2)+'2544'+IntToStr(9156);
  //EgaisKod:='01'+'000000'+'2716';//'0'+inttoStr(50*2)+'2544'+IntToStr(9156);
  FirmINN:='';
  FirmKPP:='';
  FirmAddress:='';
  FirmFullName:='';
  FirmShortName:='';
  flDemoMode:=false;
  flSpUpdate:=false;
  // === ввели понятие - администратор БД default = false
  flAsAdmin:=false;
    FIni:=           TIniFile.Create(sFile+'egaismon.ini');
    pathDir := Fini.ReadString('GLOBAL','pathDir','');
    mysqlurl := Fini.ReadString('GLOBAL','mysqlurl','');
    mysqluser := Fini.ReadString('GLOBAL','mysqluser','');
    mysqlpassword := Fini.ReadString('GLOBAL','mysqlpassword','');
    prefixdb := Fini.ReadString('GLOBAL','prefixdb','');
    curVersion:= Fini.ReadString('GLOBAL','version',CurVer);
    curVerReport:=Fini.ReadString('GLOBAL','reportversion',ReportVer);
    utmip := Fini.ReadString('GLOBAL','utmip','127.0.0.1');
    utmport := Fini.ReadString('GLOBAL','utmport','8080');
    FirmFullName := Fini.ReadString('GLOBAL','firmname','');
    FirmShortName:= Fini.ReadString('GLOBAL','firmShortname',FirmFullName);
    FirmINN :=    Fini.ReadString('GLOBAL','inn','');
    Firmkpp :=Fini.ReadString('GLOBAL','kpp','');
    FirmAddress :=Fini.ReadString('GLOBAL','address','');
    autoload :=Fini.ReadBool('GLOBAL','autoload',false);
    deltaautoload:=Fini.ReadInteger('GLOBAL','refresh',10);
    flOptMode:=Fini.ReadBool('GLOBAL','OptMode',false);
    prefixClient:=Fini.ReadString('GLOBAL','prefixClient','');
    flLowConnect:=Fini.ReadBool('GLOBAL','LowConnect',false);
    flkkmenabled:=Fini.ReadBool('GLOBAL','KKMEnabled',false);
    flDemoMode:=Fini.ReadBool('GLOBAL','demomode',false);
//    flUpdateAdmin:=Fini.ReadBool('GLOBAL','adminupdate',false);
    timer1.Interval:=3000;
    Fini.Destroy;
    stepload:=1;  // первый шаг загрузки
    timer1.Enabled:=true;
    Statictext1.Caption:='Загрузка параметров....';
    sFile:= PathFile();
    flLoadProcuct:=true;
    flAsAdmin:=false;
    flUpdateAdmin:=false;
    if pos('\\',pathDir)=-1 then begin
      if not DirectoryExists(Utf8ToAnsi(pathDir)) then
             mkdir(Utf8ToAnsi(pathDir));
      if not DirectoryExists(Utf8ToAnsi(pathDir+'\in')) then begin
             mkdir(Utf8ToAnsi(pathDir+'\in'));
             if not DirectoryExists(Utf8ToAnsi(pathDir+'\in\WayBill')) then
               mkdir(Utf8ToAnsi(pathDir+'\in\WayBill'));
      end;
      if not DirectoryExists(Utf8ToAnsi(pathDir+'\in\WayBill')) then
               mkdir(Utf8ToAnsi(pathDir+'\in\WayBill'));
      if not DirectoryExists(Utf8ToAnsi(pathDir+'\out')) then
             mkdir(Utf8ToAnsi(pathDir+'\out'));
      if not DirectoryExists(Utf8ToAnsi(sFile+'docs')) then
             mkdir(Utf8ToAnsi(sFile+'docs'));
    end;
//    if CurVer<> curVersion then


  rmkFont:=TFont.Create;
  rmkFont.CharSet:=16;
  rmkFont.Name:='Courier New';
end;

procedure TFormStart.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  flLowConnect:=false;
  disconnectDB();

end;

procedure TFormStart.FormShow(Sender: TObject);
begin
  TrayIcon1.Visible:=true;

end;

procedure TFormStart.Image1Click(Sender: TObject);
begin

end;

procedure TFormStart.MySQL50Connection1Log(Sender: TSQLConnection;
  EventType: TDBEventType; const Msg: String);
begin

end;

procedure TFormStart.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  case stepload of
   1:begin
      // ---- Подключаемся к ДБ
    Statictext1.Caption:='Подключение к БД....';
    if not ConnectDB() then
      ShowMessage(' Не могу подключиться к базе данных:'+mysqlurl);
    //  DisconnectDB();
    stepload:=2;
 //   formlogging.AddMessage('Подключение к БД','!');
    timer1.Enabled:=true;
    end;
   2:begin
    Statictext1.Caption:='Настройка таблиц БД....';
    CreateBD();
 //   formlogging.AddMessage('Проверили целостность БД','!');
    if GetConstant('AdminUpdate')='1' then
     flUpdateAdmin:=true
     else
       flUpdateAdmin:=false;

    if GetConstant('DocStatusEdit')='1' then
       flDocStatusEdit:=true
     else
       flDocStatusEdit:=false  ;
    stepload:=3;

    timer1.Enabled:=true;
    end;
   3:begin
    Statictext1.Caption:='Проверка связи с ЕГАИС.';
    EgaisKod:=GetFSRARID();    //010025449156   010025449156

    Statictext2.Caption:='Код ЕГАИС: '+EgaisKod;
    //flLoadProcuct:=false;
    stepload:=4;
    formlogging.AddMessage('Получили код ЕГАИСА:'+EgaisKod,'!');

    timer1.Enabled:=true;

   end;
   4:begin
    hide;
    FormJurnale.Show;
    stepload:=5;
    timer1.Interval:=deltaautoload*1000;
    timer1.Enabled:=autoload;
    end
  else

  // === Если загружаем программу с автообменом ==
  loadFromFileTTN();
  refreshEGAIS();
  timer1.Enabled:=true;
  // =============================================
  end;
  //timer1.Enabled:=true;
end;

// w: TFPHTTPClient;  uses fphttpclient
function TFormStart.SaveToServerPOST(const fparam,fstr:string):string;
var
  scAddr:TinetSockAddr;
  sc:longint;
  Sin, Sout:text;
  buff:string;
  sep,
  f_exit:string;
  lens1:string;
  IsBody:boolean;
  i:integer;
  f1:text;
  len1:integer;
  getip:string;
  SLine:TStringList;
  S:TStringStream;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
//==================
    Sss : string;
    SS : TStringStream;
    Ffff : TFileStream;
begin    // Format(AResponse.Contents.Text,  [HexText, AsciiText])
//  if flDemomode  then begin
//    result:='<?xml version="1.0" encoding="UTF-8" standalone="no"?><A><url>5abe96ef-aef0-4a6d-ac3f-3416f7159377</url><sign>AAE11382828AE8D1BE0E3CA0B6CB14FDBB2E470BC46D23D26B0B6F8C232B051879F2D354976362FD3DF456F184906CA99B38096F25E6979CE5367B97F7779AF0</sign><ver>2</ver></A>';
//    exit;
//  end;
  SLine:=TStringList.Create;
  sLine.Text:=fstr;
  sLine.SaveToFile('prepost.txt');
  //sLine.SaveToFile('client.xml');
  w:= TFPHTTPClient.Create(nil);
  S:= TStringStream.Create(fstr);
  try
    Sep:=Format('-------------------------%.8x',[Random($ffffff)]);
    w.AddHeader('Content-Type','multipart/form-data; boundary='+Sep);
    Sss:='--'+Sep+CRLF;
    sss:=sss+Format('Content-Disposition: form-data; name="%s"; filename="%s"'+CRLF,['xml_file','client.xml']);
    sss:=sss+'Content-Type: text/xml'+CRLF+CRLF;
    SS:=TStringStream.Create(sss);
    try
      SS.Seek(0,soFromEnd);
      Sss:=fstr+CRLF+'--'+Sep+'--'+CRLF;
      SS.WriteBuffer(Sss[1],Length(Sss));
      SS.Position:=0;
      w.RequestBody:=SS;
      w.Post('http://'+utmip+':'+utmport+'/'+fparam,s);
    finally
     w.RequestBody:=Nil;
     SS.Free;
    end;
//    w.FileFormPost('http://'+utmip+':'+utmport+'/'+fparam,'xml_file','client.xml',s);
    //result:=w.Post('http://'+utmip+':'+utmport+'/'+fparam);
  except
    // === ошибка при подключении
    result:='';
    showmessage('нет доступа к интернет!');
  end;
  result:=s.DataString;
  s.free;
  w.free;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');

  SLine.Add(result);
  SLine.SaveToFile(pathfile()+'\post.log');
  Sline.Free;

end;

function TFormStart.SaveToServerGET(const fparam,fstr:string):string;
var
  scAddr:TinetSockAddr;
  sc:longint;
  Sin, Sout:text;
  buff:string;
  f_exit:string;
  getip,lens1:string;
  IsBody:boolean;
  i:integer;
  f1:text;
  len1:integer;
  SLine:TStringList;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  w:= TFPHTTPClient.Create(nil);
  try
    result:=w.get('http://'+utmip+':'+utmport+'/'+fparam);
  except
    // === ошибка при подключении
    result:='';
    showmessage('нет доступа к интернет!');
  end;
  SLine:=TStringList.Create;
  SLine.Clear;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  SLine.Add(result);
  SLine.SaveToFile(pathfile()+'\get.log');
  Sline.Free;
  w.free;
end;

function TFormStart.SaveToServerDELETE(const fparam,fstr:string):string;
var
  SLine:TStringList;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  SLine:=TStringList.Create;
  SLine.Clear;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  result:='';
  w:= TFPHTTPClient.Create(nil);
  try
    result:=w.Delete('http://'+utmip+':'+utmport+'/'+fparam);
  except
        // === ошибка при подключении
    result:='';
    showmessage('нет доступа к интернет!');
  end;

  SLine.Add(result);
  SLine.SaveToFile(pathfile()+'\getDelete.log');
  Sline.Free;
  w.free;
end;

function TFormStart.GetFSRARID():String;
var
 i:integer;
 w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
 SLine:TStringList;
 ver:String;
 reg1:string;
begin
  w:= TFPHTTPClient.Create(nil);
  try
  result :=w.Get('http://www.retailika.ru/service/reginfo.php?inn='+firminn+'&kpp='+firmkpp);
  except
    // === ошибка при подключении
    result:='';
    showmessage('нет доступа к интернет!');
  end;
  w.free;
  i:=pos(']',result);
  if i>0 then begin
    result:=copy(result,2,i-2);
  end;

  if length(result)=0 then
   begin
     showMessage('Не возможно получить лицензию!');
     close;
   end;
  reg1:=result;

  if reg1='0000000000000000' then begin
      showMessage('Поддержка вашей лицензии окончилась!');
      close;
    end;
  // ==== Получение актуальной версии ===
  SLine:=TStringList.Create;
  SLine.Clear;
  w:= TFPHTTPClient.Create(nil);
  try
   ver :=w.Get('http://egais.retailika.ru/files/ver.txt');
  except
    // === ошибка при подключении
    ver:='';
  end;
  if ver<>'' then
   begin
     if ver<> CurVersion then begin
        ShowMessage('Имеется новая версия, будет запущено обновление!');
        try
          SLine.Text :=w.Get('http://egais.retailika.ru/files/info.txt');
          sLine.SaveToFile(pathFile()+'info.txt')
        except
          // === ошибка при подключении
          SLine.Text:='';
        end;
        FormInfo.BitBtn2Click(nil);
     end;
   end;
  try
   ver :=w.Get('http://egais.retailika.ru/files/reportver.txt');
  except
    // === ошибка при подключении
    ver:='';
  end;
  if ver<>'' then
   begin
     if ver<> curVerReport then begin
       curVerReport:= ver;
       updatereport();
     end;
   end;
  w.free;
  sLine.free;
  //result:='0'+inttoStr(50*2)+'2544'+IntToStr(9156);
end;

function TFormStart.PathFile():String;
begin
  result:=extractfilepath(paramstr(0));
end;

// Запрос сведеней о товарах производителя
function TFormStart.LoadEGAISTovar(const inn:string):string;
var
  ind:integer;
  lastname:string;
  regid:String;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  WBRegID,
  S1:String;
  SLine:TStringList;
  Query:String;
begin
  // ==== получим сведения л производителе
   result:='';

   SLine:= TStringList.Create;
   SLine.Clear;
   SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
   SLine.add('<ns:Documents Version="1.0"');
   SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
   SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
   SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
   SLine.add('<ns:Owner>');
   SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
   SLine.add('</ns:Owner>');
   SLine.add('<ns:Document>');
   SLine.add('<ns:QueryAP>');
   SLine.add('<qp:Parameters>');
   SLine.add('<qp:Parameter>');
   SLine.add('<qp:Name>ИНН</qp:Name>');
   SLine.add('<qp:Value>'+inn+'</qp:Value>');
   SLine.add('</qp:Parameter>');
   SLine.add('</qp:Parameters>');
   SLine.add('</ns:QueryAP>');
   SLine.add('</ns:Document>');
   SLine.add('</ns:Documents>');
   s1:=savetoserverpost('opt/in/QueryAP',Sline.text) ;
   S:= TStringStream.Create(s1);
     Try
       S.Position:=0;
       XML:=Nil;
       ReadXMLFile(XML,S); // XML документ целиком
       // Альтернативно:
   //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
     Finally
       S.Free;
     end;
     Child :=XML.DocumentElement.FirstChild;
     i:=1;
     if Assigned(Child) then
     begin
       if Child.NodeName <> 'url' then
           exit;
       if ConnectDB() then begin
          s1:= Child.FirstChild.NodeValue;//Child.Attributes.GetNamedItem('replyId').NodeValue;
          query:='SELECT fullname, clientregid  FROM `spproducer` WHERE `inn`="'+inn+'";';
         if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
          exit;
         formStart.recbuf := mysql_store_result(formStart.sockMySQL);
         if formStart.recbuf=Nil then
           exit;
         formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
         if formStart.rowbuf<>nil then begin
            fullname:= rowbuf[0] ;
            regid:=    rowbuf[1] ;
         end;
         Query:='INSERT INTO `docjurnale` (`uid`,`clientregid`,`numdoc`,`dateDoc`,`type`,`status`, `clientname`) VALUES ('''+s1+''','''+regid+''',''Запрос товара'','''+FormatDateTime('yyyy-mm-dd',now())+''',''ReplyAP'',''---'','''+fullname+''');';
         if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
          exit;
//         DisconnectDB()
       end;
     end;
   SLine.Free;

end;

function TFormStart.LoadEGAISClient(const inn:string):string;
var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  WBRegID,
  S1:String;
  SLine:TStringList;
  Query:String;
begin
   SLine:= TStringList.Create;
   SLine.Clear;
   SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
   SLine.add('<ns:Documents Version="1.0"');
   SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
   SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
   SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
   SLine.add('<ns:Owner>');
   SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
   SLine.add('</ns:Owner>');
   SLine.add('<ns:Document>');
   SLine.add('<ns:QueryClients>');
   SLine.add('<qp:Parameters>');
   SLine.add('<qp:Parameter>');
   SLine.add('<qp:Name>ИНН</qp:Name>');
   SLine.add('<qp:Value>'+inn+'</qp:Value>');
   SLine.add('</qp:Parameter>');
   SLine.add('</qp:Parameters>');
   SLine.add('</ns:QueryClients>');
   SLine.add('</ns:Document>');
   SLine.add('</ns:Documents>');
   s1:=SaveToServerPOST('opt/in/QueryPartner',SLine.Text);
 S:= TStringStream.Create(s1);
 Try
   S.Position:=0;
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
   // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
 Finally
   S.Free;
 end;
 Child :=XML.DocumentElement.FirstChild;
 i:=1;
 if Assigned(Child) then
 begin
   if Child.NodeName <> 'url' then
       exit;
   if ConnectDB then begin
     s1:=Child.FirstChild.NodeValue; // Child.Attributes.GetNamedItem('replyId').NodeValue;
     Query:='INSERT INTO `docjurnale` (`uid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+s1+'","Запрос Поставщиков","'+FormatDateTime('yyyy-mm-dd',now())+'","ReplyPartner","---");';
     if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
      exit;
    //     DisconnectDB();
//      Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+docdate+'");';
      // добавлен сброс подтверждения клиента для ОПТА
//     DB_query(Query);
   end;

 end;
   SLine.Free;

end;

Procedure TFormStart.CreateBD();

begin
 //
  // Создаем таблицу ЖУРНАЛА документов
  // Отвечает за обновление....
{
 //  SHOW COLUMNS FROM table - получим список колонок
 //
}

  // ====== Структура данных файла обмена ===
{  DB_checkCol('alcformab','nummark','int(3)','');
  DB_checkCol('alcformab','partmark','int(3)','');
  DB_checkCol('alcformab','formA','int(3)','');
  DB_checkCol('alcformab','formB','int(3)','');
  DB_checkCol('alcformab','oldformb','int(3)','');
  DB_checkCol('alcformab','alcitem','int(3)','');
  DB_checkCol('alcformab','minnummark','int(3)','');
  DB_checkCol('alcformab','maxnummark','int(3)','');
  DB_checkCol('alcformab','alcregid','int(3)','');
  DB_checkCol('alcformab','marknum','int(3)','');
  DB_checkCol('alcformab','crdate','DATE','');    }
  // ============
  DB_checkCol('egaisfiles','url','varchar(255)','');
  DB_checkCol('egaisfiles','xmlfile','MEDIUMTEXT',''); // mysql_real_escape_string
  DB_checkCol('egaisfiles','DATESTAMP','TIMESTAMP','');
  DB_checkCol('egaisfiles','typefile','varchar(48)','');
  DB_checkCol('egaisfiles','replyId','varchar(64)','');
  Application.ProcessMessages;
  DB_checkCol('spformfix','numfix','varchar(20)','');
  DB_checkCol('spformfix','datefix','DATE','');
  DB_checkCol('spformfix','AlcItem','varchar(20)','');
  DB_checkCol('spformfix','formA','varchar(32)','');
  DB_checkCol('spformfix','crdate','varchar(10)','');
  DB_checkCol('spformfix','nummark','varchar(3096)','');
  DB_Query('ALTER TABLE `spformfix` DROP PRIMARY KEY;');
  Application.ProcessMessages;
  DB_checkCol('spproduct','AlcCode','varchar(20)','');
  DB_checkCol('spproduct','egaisname','varchar(512)','');
  DB_checkCol('spproduct','name','varchar(512)','');
  DB_checkCol('spproduct','Import','varchar(1)','');
  DB_checkCol('spproduct','Capacity','varchar(10)','');
  DB_checkCol('spproduct','AlcVolume','varchar(10)','');
  DB_checkCol('spproduct','ProductVCode','varchar(3)','');
  DB_checkCol('spproduct','ClientRegId','varchar(20)','');
  DB_checkCol('spproduct','IClientRegId','varchar(20)','');
  DB_checkCol('spproduct','listbarcode','varchar(512)','');
  Application.ProcessMessages;
  DB_checkCol('spproducer','ClientRegId','varchar(20)','');
  DB_checkCol('spproducer','FullName','varchar(120)','');
  DB_checkCol('spproducer','inn','varchar(12)','');
  DB_checkCol('spproducer','kpp','varchar(9)','');
  DB_checkCol('spproducer','ShortName','varchar(50)','');
  DB_checkCol('spproducer','description','varchar(266)','');
  DB_checkCol('spproducer','region','varchar(3)','');
  DB_checkCol('spproducer','Country','varchar(3)','');
  DB_checkCol('spproducer','Active','int(1)','');
  Application.ProcessMessages;
  DB_checkCol('splicproducer','ClientRegId','varchar(20)','');
  DB_checkCol('splicproducer','FullName','varchar(120)','');
  DB_checkCol('splicproducer','startdatelic','DATE','');
  DB_checkCol('splicproducer','enddatelic','DATE','');
  DB_checkCol('splicproducer','serlic','varchar(20)','');
  DB_checkCol('splicproducer','numlic','varchar(20)','');
  DB_checkCol('splicproducer','deplic','varchar(255)','');
  DB_checkCol('splicproducer','Active','int(1)','');
  Application.ProcessMessages;
  {
  CREATE TABLE `spproduct` (
	`AlcCode` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
	`egaisname` VARCHAR(512) NOT NULL COLLATE 'utf8_bin',
	`name` VARCHAR(512) NOT NULL COLLATE 'utf8_bin',
	`Import` VARCHAR(1) NOT NULL COLLATE 'utf8_bin',
	`Capacity` VARCHAR(10) NOT NULL COLLATE 'utf8_bin',
	`AlcVolume` VARCHAR(10) NOT NULL COLLATE 'utf8_bin',
	`ProductVCode` VARCHAR(3) NOT NULL COLLATE 'utf8_bin',
	`ClientRegId` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
	`IClientRegId` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
	`listbarcode` VARCHAR(512) NOT NULL COLLATE 'utf8_bin',
	UNIQUE INDEX `AlcCode` (`AlcCode`)

        CREATE TABLE `spproducer` (
	`ClientRegId` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
	`FullName` VARCHAR(120) NOT NULL COLLATE 'utf8_bin',
	`inn` VARCHAR(12) NOT NULL COLLATE 'utf8_bin',
	`kpp` VARCHAR(9) NOT NULL COLLATE 'utf8_bin',
	`ShortName` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`description` VARCHAR(266) NOT NULL COLLATE 'utf8_bin',
	`region` VARCHAR(3) NOT NULL COLLATE 'utf8_bin',
	`Country` VARCHAR(3) NOT NULL COLLATE 'utf8_bin',
	`Active` INT(1) NOT NULL,
  }
// добавляем базу транспортного средства
{<wb:Transport>
<wb:TRAN_CAR>Камаз А174ОС61</wb:TRAN_CAR>
<wb:TRAN_CUSTOMER>Росси МПФ ООО</wb:TRAN_CUSTOMER>
<wb:TRAN_DRIVER>Иващенко Роман Александрович</wb:TRAN_DRIVER>
<wb:TRAN_LOADPOINT>
353540, Краснодарский край, Темрюкский район, Сенной п., Мира ул., дом № 49
</wb:TRAN_LOADPOINT>
<wb:TRAN_UNLOADPOINT>
346413, Ростовская обл, Новочеркасск г, Харьковское ш, дом № 5, литер Щ,этаж 1,комната №1(S=180,6кв м),литер И,этаж 1.комнаты №№ 1(S=339,3кв м),2(S=27
</wb:TRAN_UNLOADPOINT>
<wb:TRAN_FORWARDER>Иващенко Роман Александрович</wb:TRAN_FORWARDER>
</wb:Transport>  }
//  == Структура данных о транспорте/ перевозчике
  DB_checkCol('doctransp','numdoc','varchar(48)','');
  DB_checkCol('doctransp','datedoc','DATE','');
  DB_checkCol('doctransp','egaisid','varchar(48)','');
  DB_checkCol('doctransp','CAR','varchar(48)','');
  DB_checkCol('doctransp','CUSTOMER','varchar(48)','');
  DB_checkCol('doctransp','DRIVER','varchar(48)','');
  DB_checkCol('doctransp','LOADPOINT','varchar(512)','');
  DB_checkCol('doctransp','UNLOADPOINT','varchar(512)','');
  DB_checkCol('doctransp','FORWARDER','varchar(48)','');
  Application.ProcessMessages;
  // ===== Справочник Товара ========
  DB_checkCol('sprgoods','plu','int(12)',''); // текущий код товара
  DB_checkCol('sprgoods','name','varchar(64)','');
  DB_checkCol('sprgoods','fullname','varchar(254)','');
  DB_checkCol('sprgoods','weightgood','varchar(1)',''); // весовой товар
  DB_checkCol('sprgoods','alcgoods','varchar(1)','');  // Алкогольный товар - для чеков егаис
  DB_checkCol('sprgoods','barcodes','varchar(512)','');
  DB_checkCol('sprgoods','currentprice','float','');
  DB_checkCol('sprgoods','updating','varchar(1)','');
  DB_checkCol('sprgoods','extcode','varchar(48)','');
  Application.ProcessMessages;
  // ===== Справочник Кассовых мест =
  DB_checkCol('sprkass','numkass','int(12)','');
  DB_checkCol('sprkass','lastupdate','TIMESTAMP','');
  DB_checkCol('sprkass','alckass','varchar(1)','');
  DB_checkCol('sprkass','banking','varchar(1)','');
  DB_checkCol('sprkass','kassirname','varchar(64)','');
  DB_checkCol('sprkass','numhw','varchar(8)','');  // === заводской номер ====
  DB_checkCol('sprkass','multisection','varchar(1)','');  // === несколько секций ====
  DB_checkCol('sprkass','master','varchar(1)','');  // === основная касса ====

  // ===== Справочник секций ========
  Application.ProcessMessages;
  // ===== Документ Смены ===========
  DB_checkCol('doccash','numdoc','varchar(12)','');
  DB_checkCol('doccash','datedoc','DATE','');
  DB_checkCol('doccash','numkass','int(12)','');
  DB_checkCol('doccash','namesection','varchar(64)','');
  DB_checkCol('doccash','numsection','varchar(12)','');
  // ==== ===========================
  Application.ProcessMessages;
  DB_checkCol('doccash','numtrans','int(12)','');
  DB_checkCol('doccash','datetrans','TIMESTAMP','');
  DB_checkCol('doccash','numcheck','int(12)','');
  DB_checkCol('doccash','kassir','int(12)','');
  DB_checkCol('doccash','typetrans','int(3)','');
  DB_checkCol('doccash','plu','int(12)','');
  DB_checkCol('doccash','name','varchar(64)','');
  DB_checkCol('doccash','eanbc','varchar(13)','');
  DB_checkCol('doccash','fullname','varchar(512)','');
  DB_checkCol('doccash','price','float','');
  DB_checkCol('doccash','quantity','float','');
  DB_checkCol('doccash','summ','float','');
  DB_checkCol('doccash','banking','varchar(64)','');
  DB_checkCol('doccash','urlegais','varchar(255)',''); // == ПДФ416 или УРЛ
  DB_checkCol('doccash','alccode','varchar(64)','');

  Application.ProcessMessages;
  // ===== ReplyId =========================================================
  DB_checkCol('replyid','numdoc','varchar(48)','');
  DB_checkCol('replyid','datedoc','DATE','');
  DB_checkCol('replyid','egaisid','varchar(48)','');
  Application.ProcessMessages;
  // =======================================================================
  DB_checkCol('doc221','docid','varchar(64)','');
  DB_checkCol('doc221','tovar','varchar(200)','');
  DB_checkCol('doc221','numposit','varchar(20)','');
  Application.ProcessMessages;
  DB_checkCol('doc21','factcount','int(15)','');
  DB_checkCol('doc21','nowformb','varchar(20)','');
  DB_checkCol('doc21','tovar','varchar(200)','');
  Application.ProcessMessages;
  DB_checkCol('docformab','docid','varchar(64)','');
  DB_checkCol('docformab','numdoc','varchar(20)','');
  DB_checkCol('docformab','numPosition','varchar(20)','');
  DB_checkCol('docformab','datedoc','DATE','');
  Application.ProcessMessages;
  DB_checkCol('regrestsproduct','dateTTN','varchar(10)','');
  DB_checkCol('regrestsproduct','numTTN','varchar(32)','');
  Application.ProcessMessages;
  DB_checkCol('docjurnale','DocId','varchar(64)','');
  DB_checkCol('docjurnale','addressclient','varchar(512)','');
 // DB_checkCol('docjurnale','ClientAddress','varchar(512)','');
  DB_checkCol('docjurnale','dateDoc','DATE','');
  DB_checkCol('docjurnale','isDelete','varchar(1)','');
//  DB_checkCol('docjurnale','ClientAccept','varchar(1)','');
  DB_checkCol('docjurnale','ClientAccept','varchar(1)','');
  DB_checkCol('docjurnale','issueclient','varchar(1)','');    // === Отказ ===
  Application.ProcessMessages;
  DB_checkCol('ticket','dateDoc','DATE','');
  DB_checkCol('ticket','numDoc','varchar(20)','');
  DB_checkCol('ticket','comment','MEDIUMTEXT',''); // mysql_real_escape_string
  DB_checkCol('ticket','datestamp','TIMESTAMP','','DEFAULT CURRENT_TIMESTAMP');
  Application.ProcessMessages;
//  DB_checkCol('ticket','dateDoc','DATE','');
//  DB_checkCol('ticket','numDoc','varchar(20)','');
  // ============= Оборот Справки Б ============
  DB_checkCol('regFormB','WBRegId','varchar(48)','');
  DB_checkCol('regFormB','uid','varchar(64)','');
  DB_checkCol('regFormB','posit','int(15)','');
  DB_checkCol('regFormB','datefix','DATE','');
  DB_checkCol('regFormB','numttn','varchar(48)','');
  DB_checkCol('regFormB','comment','varchar(250)','');
  DB_checkCol('regFormB','quantity','float','');
  // =========================================
{  CREATE TABLE `doc23` (
  	`docid` VARCHAR(40) NOT NULL COLLATE 'utf8_bin',
  	`numdoc` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
  	`datedoc` VARCHAR(10) NOT NULL COLLATE 'utf8_bin',
  	`alccode` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
  	`markplomb` VARCHAR(70) NOT NULL COLLATE 'utf8_bin',
  	`forma` VARCHAR(32) NOT NULL COLLATE 'utf8_bin',
  	`formb` VARCHAR(32) NOT NULL COLLATE 'utf8_bin',
  	`numfix` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
  	`datefix` VARCHAR(10) NOT NULL COLLATE 'utf8_bin',
  	`import` TINYINT(1) NOT NULL,
  	`crdate` VARCHAR(10) NOT NULL COLLATE 'utf8_bin',
  	UNIQUE INDEX `docid` (`docid`)
  )}
  Application.ProcessMessages;
    // ==== списание доп значения журнала
  DB_checkCol('docx23','docid','varchar(48)','');
  DB_checkCol('docx23','numdoc','varchar(20)','');
  DB_checkCol('docx23','datedoc','DATE','');
  DB_checkCol('docx23','status','varchar(1)','');
  DB_checkCol('docx23','statusname','varchar(64)','');
  DB_checkCol('docx23','statusname','varchar(512)','');

  DB_checkCol('doc23','docid','varchar(48)','');
  DB_checkCol('doc23','numdoc','varchar(20)','');
  DB_checkCol('doc23','datedoc','DATE','');
  DB_checkCol('doc23','alccode','varchar(20)','');
  DB_checkCol('doc23','markplomb','varchar(70)','');
  DB_checkCol('doc23','forma','varchar(32)','');
  DB_checkCol('doc23','formb','varchar(32)','');
  DB_checkCol('doc23','count','int(10)','');
  DB_checkCol('doc23','numfix','varchar(20)','');
  DB_checkCol('doc23','datefix','DATE','');
  DB_checkCol('doc23','import','varchar(1)','');
  DB_checkCol('doc23','crdate','DATE','');
  DB_Query('ALTER TABLE `doc23` DROP INDEX `docid`;');
  Application.ProcessMessages;
  // ==== возврат доп значения журнала
  DB_checkCol('docx24','docid','varchar(48)','');
  DB_checkCol('docx24','numdoc','varchar(20)','');
  DB_checkCol('docx24','datedoc','DATE','');
  DB_checkCol('docx24','basedatedoc','DATE','');
  DB_checkCol('docx24','basenumdoc','varchar(20)','');
  DB_checkCol('docx24','Accepted','varchar(1)','');    // Отправили подтверждение

  // ==== табличная часть докум возврат
  DB_checkCol('doc24','docid','varchar(48)','');
  DB_checkCol('doc24','numdoc','varchar(20)','');
  DB_checkCol('doc24','datedoc','DATE','');
  DB_checkCol('doc24','tovar','varchar(512)','');
  DB_checkCol('doc24','alccode','varchar(20)','');
  DB_checkCol('doc24','price','float','');
  DB_checkCol('doc24','forma','varchar(32)','');
  DB_checkCol('doc24','formb','varchar(32)','');
  DB_checkCol('doc24','count','int(10)','');
  DB_checkCol('doc24','numposit','int(10)','');

  Application.ProcessMessages;
  // =====  ActChargeOnShop ==== Оприходование в розницу
  DB_checkCol('doc26','numdoc','varchar(20)','');
  DB_checkCol('doc26','datedoc','DATE','');
  DB_checkCol('doc26','count','int(10)','');
  DB_checkCol('doc26','alccode','varchar(20)','');
  DB_checkCol('doc26','crdate','DATE','');
  DB_checkCol('doc26','restcount','int(10)','');
  Application.ProcessMessages;
  DB_checkCol('docx26','numdoc','varchar(20)','');
  DB_checkCol('docx26','datedoc','DATE','');
  DB_checkCol('docx26','clientprovider','varchar(20)','');

  Application.ProcessMessages;
  // ==== Документ Инвентаризация по Марке пломб ===
  // (смысл такой в этой таблице не должно быть совпадений с маркой пломб)
  DB_checkCol('doc25','docid','varchar(48)','');
  DB_checkCol('doc25','numdoc','varchar(20)','');
  DB_checkCol('doc25','datedoc','DATE','');
  DB_checkCol('doc25','alccode','varchar(20)','');
  DB_checkCol('doc25','pdf417','varchar(70)','');
  DB_checkCol('doc25','forma','varchar(32)','');
  DB_checkCol('doc25','formb','varchar(32)','');
  DB_checkCol('doc25','numfix','varchar(20)','');
  DB_checkCol('doc25','datefix','DATE','');
  DB_checkCol('doc25','import','varchar(1)','');
  DB_checkCol('doc25','crdate','DATE','');
  DB_checkCol('doc25','count','int(20)','');
  DB_checkCol('doc25','restcount','int(20)','');
  Application.ProcessMessages;
  // ==== возврат доп значения журнала
  DB_checkCol('docx21','docid','varchar(48)','');
  DB_checkCol('docx21','numdoc','varchar(20)','');
  DB_checkCol('docx21','datedoc','DATE','');
//  DB_checkCol('docx21','basedatedoc','DATE','');
//  DB_checkCol('docx21','basenumdoc','varchar(20)','');
  DB_checkCol('docx21','Accepted','varchar(1)','');    // Отправили подтверждение
  Application.ProcessMessages;
  // =====  ActTransferOnShop ==== перемещение в розницу
  DB_checkCol('doc27','numdoc','varchar(20)','');
  DB_checkCol('doc27','datedoc','DATE','');
  DB_checkCol('doc27','count','int(10)','');
  DB_checkCol('doc27','alccode','varchar(20)','');
  DB_checkCol('doc27','form2','varchar(20)','');
  DB_checkCol('doc27','crdate','DATE','');
  Application.ProcessMessages;
  DB_checkCol('docx27','numdoc','varchar(20)','');
  DB_checkCol('docx27','datedoc','DATE','');
  DB_checkCol('docx27','ownernumdoc','varchar(20)','');
  DB_checkCol('docx27','ownerdatedoc','DATE','');

  // =====  ActWriteOffShop ==== перемещение в розницу
  DB_checkCol('doc28','numdoc','varchar(20)','');
  DB_checkCol('doc28','datedoc','DATE','');
  DB_checkCol('doc28','count','int(10)','');
  DB_checkCol('doc28','alccode','varchar(20)','');
  DB_checkCol('doc28','price','float','');
  Application.ProcessMessages;
  DB_checkCol('docx28','numdoc','varchar(20)','');
  DB_checkCol('docx28','datedoc','DATE','');
  DB_checkCol('docx28','notedoc','varchar(512)','');
  DB_checkCol('docx28','typedoc','varchar(20)','');

  Application.ProcessMessages;
  DB_checkCol('regrestsshop','alcname','varchar(512)','');
  DB_checkCol('regrestsshop','alccode','varchar(20)','');
  DB_checkCol('regrestsshop','Quantity','int(10)','');
  DB_checkCol('regrestsshop','daterests','DATE','');
  Application.ProcessMessages;
  DB_checkCol('d5structure','uuid','varchar(48)','');
  DB_checkCol('d5structure','typename','varchar(20)','');  // WayBill...
  DB_checkCol('d5structure','tablename','varchar(20)',''); // Табличная часть
  DB_checkCol('d5structure','statname','varchar(20)','');  // таблица значений
  DB_checkCol('d5structure','printname','varchar(48)',''); // Наименование документа
  DB_checkCol('d5structure','caption','varchar(48)',''); // заголовок формы
  DB_checkCol('d5structure','colcount','int(3)','');

end;


procedure TFormStart.loadFromFileTTN();
var
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  ii,i:Integer;
  S1:String;
  fs : TSearchRec;
  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  Query:String;
  strGUID:String;
  IDGUID: TGUID;
begin
 ConnectDB();
  dir := pathDir;
  findfirst(dir + '\*.xml',faAnyFile,fs);
  repeat
    application.ProcessMessages;
    if (fs.Name='')            //(fs.Name='') включать обязательно
     or(fs.Name='.')         //если указатель на текущий каталог
     or (fs.Name='..')       //если указатель на родительский каталог
        then continue;

    if ((fs.Attr and faDirectory) <> 0)  then continue;      //если каталог,
 // Обрабатываем полученный файл
    XML:=Nil;
    ReadXMLFile(XML,dir+'\'+fs.Name); // XML документ целиком
    Child :=XML.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
        summaDoc:=0;
       if Child.NodeName = 'document' then begin
          DocNumber:= AnsiToUtf8(Child.Attributes.GetNamedItem('number').NodeValue);
          DocDate  := Child.Attributes.GetNamedItem('date').NodeValue;
          Query:='SELECT * FROM `docjurnale` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;';
         if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
          exit;
         formStart.recbuf := mysql_store_result(formStart.sockMySQL);
         if formStart.recbuf=Nil then
           exit;
         formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
          if formStart.rowbuf=nil then
          begin
            Child1 := Child.FirstChild;
            ClientKodEgais:= Child1.Attributes.GetNamedItem('IdEgais').NodeValue;
            ClientINN:= Child1.Attributes.GetNamedItem('inn').NodeValue;
            ClientKPP:= Child1.Attributes.GetNamedItem('kpp').NodeValue;
            ClientAddress:= AnsiToUtf8(Child1.Attributes.GetNamedItem('address').NodeValue);
            ClientName:= AnsiToUtf8(Child1.Attributes.GetNamedItem('name').NodeValue);
            S1:= Child1.nodename;
            Child1 := Child1.NextSibling;
            S1:= Child1.nodename;
            // ===================================
             if length(ClientKodEgais)<10 then begin
               query:='SELECT ClientRegId,description FROM `spproducer` WHERE (`inn`="'+ClientINN+'")AND(`kpp`="'+ClientKPP+'");';
                if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
                 exit;
                recbuf := mysql_store_result(sockMySQL);
                if recbuf=Nil then
                  exit;
                rowbuf := mysql_fetch_row(recbuf);
                if rowbuf<>nil then begin
                   ClientKodEgais:= rowbuf[0] ;
                   ClientAddress := rowbuf[1] ;
                end;
             end;

            //====================================
            Child2 := Child1.FirstChild;
            i:=1;
           while Assigned(Child2) do
              begin

                Query:='INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`) VALUES '+
                '("'+DocNumber+'","'+DocDate+'","'+ClientKodEgais+'","'+ClientName+'",'+inttostr(i)+
                ',"'+AnsiToUtf8(Child2.Attributes.GetNamedItem('name').NodeValue)+'","'+Child2.Attributes.GetNamedItem('barcode').NodeValue+'","'+
                Child2.Attributes.GetNamedItem('IdEgais').NodeValue+'",'+Child2.Attributes.GetNamedItem('count').NodeValue+','+
                Child2.Attributes.GetNamedItem('price').NodeValue+',"'+Child2.Attributes.GetNamedItem('import').NodeValue+'");';
                StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                SummaDoc:=SummaDoc+(StrToFloat(STRPrice)*StrToFloat(Child2.Attributes.GetNamedItem('count').NodeValue));
                 if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
                  exit;
                i:=i+1;
                Child2 := Child2.NextSibling;

             end;
             // == Добавляем документ в журнал ==


            Query:='INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`status`,`summa`,`registry`,`type`,`docid`) VALUES '+
                   ' ("'+DocNumber+'","'+DocDate+'","'+ClientKodEgais+'","'+ClientName+'","---",'+FloatToStr(SummaDoc)+',"-","WayBill","");';
             if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
              exit;
            // ==================================

          end    // ============ Если документ уже есть =======
          Else begin

            Query:='DELETE FROM `doc211` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'");';
            if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
              exit;

            Child1 := Child.FirstChild;
            ClientKodEgais:= Child1.Attributes.GetNamedItem('IdEgais').NodeValue;
            ClientINN:= Child1.Attributes.GetNamedItem('inn').NodeValue;
            ClientKPP:= Child1.Attributes.GetNamedItem('kpp').NodeValue;
            ClientAddress:= AnsiToUtf8(Child1.Attributes.GetNamedItem('address').NodeValue);
            ClientName:= AnsiToUtf8(Child1.Attributes.GetNamedItem('name').NodeValue);
            S1:= Child1.nodename;
            Child1 := Child1.NextSibling;
            S1:= Child1.nodename;
            // ===================================
             if length(ClientKodEgais)<10 then begin
               query:='SELECT ClientRegId,description FROM `spproducer` WHERE (`inn`="'+ClientINN+'")AND(`kpp`="'+ClientKPP+'");';
                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                 exit;
                recbuf := mysql_store_result(sockMySQL);
                if recbuf=Nil then
                  exit;
                rowbuf := mysql_fetch_row(recbuf);
                if rowbuf<>nil then begin
                   ClientKodEgais:= rowbuf[0] ;
                   ClientAddress := rowbuf[1] ;
                end;
             end;
           Query:='UPDATE `docjurnale` SET `clientregid`="'+ClientKodEgais+'",`summa`='+FloatToStr(SummaDoc)+',`ClientName`="'+ClientName+'" WHERE '+
             ' `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'";';
            mysql_query(formStart.sockMySQL,PChar(Query));

            //====================================
            Child2 := Child1.FirstChild;
            i:=1;
           while Assigned(Child2) do
              begin

                Query:='INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`) VALUES'
                     +'("'+DocNumber+'","'+DocDate+'","'+ClientKodEgais+'","'+ClientName+'",'+inttostr(i)+
                ',"'+AnsiToUtf8(Child2.Attributes.GetNamedItem('name').NodeValue)+'","'+Child2.Attributes.GetNamedItem('barcode').NodeValue+'","'+
                Child2.Attributes.GetNamedItem('IdEgais').NodeValue+'",'+Child2.Attributes.GetNamedItem('count').NodeValue+','+
                Child2.Attributes.GetNamedItem('price').NodeValue+',"'+Child2.Attributes.GetNamedItem('import').NodeValue+'");';
                StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                SummaDoc:=SummaDoc+(StrToFloat(STRPrice)*StrToFloat(Child2.Attributes.GetNamedItem('count').NodeValue));
                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                  exit;
                i:=i+1;
                Child2 := Child2.NextSibling;

             end;
           Query:='UPDATE `docjurnale` SET `clientregid`="'+ClientKodEgais+'",`summa`='+FloatToStr(SummaDoc)+',`ClientName`="'+ClientName+'" WHERE '+
             ' `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'";';
            mysql_query(formStart.sockMySQL,PChar(Query));

          end;
        end;
        Child := Child.NextSibling;
    end;
 // ====== конец обработки ======
      DeleteFile(dir + '\'+fs.name);
      until findnext(fs) <> 0;
      findclose(fs);
//  DisconnectDB();
end;

procedure TFormStart.loadFromEGAISTTN(const aSTR:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  dir:string;
  StrPrice:String;
  sLine:TStringList;
  summaDoc:real;
  stopsearch:boolean;
  DocType,IdDoc,iDPosition,Quantity,informa,informb,price,alccode,alcname,Capacity,AlcVolume, ProductVCode,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  ConsigneeClientAddress,
  QUERY:String;
  TRAN_CAR,TRAN_CUSTOMER,TRAN_DRIVER,
  TRAN_LOADPOINT,TRAN_UNLOADPOINT, TRAN_FORWARDER:String;
begin
   ConsigneeClientAddress:='';
   S:= TStringStream.Create(aStr);
   sLine:=TStringList.Create;
   sLine.Clear;
   sLine.Text:=aStr;
   Try
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
   Finally
     S.Free;
   end;
   flNew:=true;
   summaDoc:=0;
   ConnectDB();
   Child :=XML.DocumentElement.FirstChild;
   while Assigned(Child) do begin
     if Child.NodeName = 'ns:Document' then begin
        Child1:=child.FirstChild;
        while Assigned(Child1) AND flNew do begin

          // ==== Заголовок документа =====
          if Child1.NodeName = 'ns:WayBill' then begin
            Child2 := child1.FirstChild;
            while Assigned(Child2) do begin
              if Child2.NodeName = 'wb:Identity' then
                IdDoc:=AnsiToUTF8(replaceStr(Child2.FirstChild.NodeValue));
              if Child2.NodeName = 'wb:Header' then begin
                Child3:=Child2.FirstChild;
                While Assigned(Child3) do begin
                  if Child3.NodeName = 'wb:NUMBER' then
                    DocNumber:= AnsiToUTF8(Child3.FirstChild.NodeValue);
                  if Child3.NodeName = 'wb:Date' then
                    docDate:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wb:Type' then
                    DocType:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wb:Shipper' then begin
                   ClientKodEgais:='';
                   ClientName:='';
                   ClientINN:='';
                   ClientKPP:='';
                   ClientAddress:='';
                    child4:=Child3.FirstChild;
                    while assigned(Child4) do begin
                      if Child4.NodeName = 'oref:ClientRegId' then
                        ClientKodEgais:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:FullName' then begin
                        if Assigned(Child4.FirstChild) then
                        ClientName:= AnsiToUTF8(replaceStr(Child4.FirstChild.NodeValue));
                      end;
                      if Child4.NodeName = 'oref:INN' then
                        ClientINN:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:KPP' then
                        ClientKPP:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:address' then
                      begin
                       child5:=Child4.FirstChild;
                       while assigned(Child5) do begin
                         if Child5.NodeName='oref:description' then  begin
                            if Assigned(Child5.FirstChild) then
                              ClientAddress:= AnsiToUTF8(Child5.FirstChild.NodeValue);  //oref:address
                          end;
                          Child5 := Child5.NextSibling;
                        End;
                      end;

                      Child4 := Child4.NextSibling;
                    end;
                  end;
                  if Child3.NodeName = 'wb:Consignee' then begin

                    child4:=Child3.FirstChild;
                    while assigned(Child4) do begin
    {                  if Child4.NodeName = 'oref:ClientRegId' then
                        ClientKodEgais:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:FullName' then
                        ClientName:= AnsiToUTF8(replaceStr(Child4.FirstChild.NodeValue));
                      if Child4.NodeName = 'oref:INN' then
                        ClientINN:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:KPP' then
                        ClientKPP:= Child4.FirstChild.NodeValue; }
                      if Child4.NodeName = 'oref:address' then
                      begin
                       child5:=Child4.FirstChild;
                       while assigned(Child5) do begin
                         if Child5.NodeName='oref:description' then  begin
                            if Assigned(Child5.FirstChild) then
                              ConsigneeClientAddress:= AnsiToUTF8(Child5.FirstChild.NodeValue);  //oref:address
                          end;
                          Child5 := Child5.NextSibling;
                        End;
                      end;

                      Child4 := Child4.NextSibling;
                    end;
                  end;


                  if Child3.NodeName = 'wb:Transport' then begin
                   TRAN_CAR:=''; TRAN_CUSTOMER:=''; TRAN_DRIVER:='';
                   TRAN_LOADPOINT:=''; TRAN_UNLOADPOINT:=''; TRAN_FORWARDER:='';
                    child4:=Child3.FirstChild;
                    while assigned(Child4) do begin
                      if Child4.NodeName = 'wb:TRAN_CAR' then
                         if assigned(Child4.FirstChild) then
                            TRAN_CAR:=AnsiToUTF8(Child4.FirstChild.NodeValue);
                      if Child4.NodeName = 'wb:TRAN_CUSTOMER' then begin
                        if Assigned(Child4.FirstChild) then
                          TRAN_CUSTOMER:= AnsiToUTF8(replaceStr(Child4.FirstChild.NodeValue));
                      end;
                      if Child4.NodeName = 'wb:TRAN_DRIVER' then begin
                        if assigned(Child4.FirstChild) then
                        TRAN_DRIVER:= AnsiToUTF8(Child4.FirstChild.NodeValue);

                      end;
                      if Child4.NodeName = 'wb:TRAN_LOADPOINT' then
                        if assigned(Child4.FirstChild) then
                        TRAN_LOADPOINT:= AnsiToUTF8(Child4.FirstChild.NodeValue);
                      if Child4.NodeName = 'wb:TRAN_UNLOADPOINT' then
                      begin
                        if assigned(Child4.FirstChild) then
                       TRAN_UNLOADPOINT:=AnsiToUTF8(Child4.FirstChild.NodeValue);
                      end;
                      if Child4.NodeName='wb:TRAN_FORWARDER' then  begin
                        if Assigned(Child4.FirstChild) then
                              TRAN_FORWARDER:= AnsiToUTF8(Child4.FirstChild.NodeValue);  //oref:address
                       end;
                      Child4 := Child4.NextSibling;
                    end;
                  end;

                  Child3 := Child3.NextSibling;
                end;

                // DocNumber:= AnsiToUtf8(Child.Attributes.GetNamedItem('number').NodeValue);
                // DocDate  := Child.Attributes.GetNamedItem('date').NodeValue;

                QUERY:='SELECT * FROM `docjurnale` WHERE ((`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'"))AND(`docid`="'+iddoc+'") ;';
                 recbuf :=DB_query(Query);
                 rowbuf:=DB_Next(recbuf);
                 if rowbuf<>Nil then
                   flNew:=false ;


              end;
              // ====== Содержимое документа ======
              if (Child2.NodeName = 'wb:Content')and(flNew) then begin
                  Child3:=Child2.FirstChild;
                  While Assigned(Child3) do begin
                    if Child3.NodeName ='wb:Position' then begin
                       child4:=Child3.FirstChild;
                       while assigned(Child4) do begin
                         if Child4.NodeName='wb:Identity' then begin
                             IdPosition:=Child4.FirstChild.NodeValue;
                           end;
                          if Child4.NodeName='wb:Quantity' then begin
                             Quantity:=Child4.FirstChild.NodeValue;
                           end;
                         if Child4.NodeName='wb:InformA' then begin
                            child5:=Child4.FirstChild;
                            while assigned(Child5) do begin
                             if Child5.NodeName='pref:RegId' then  begin
                                if Assigned(Child5.FirstChild) then
                                  InformA:= AnsiToUTF8(Child5.FirstChild.NodeValue);  //oref:address
                              end;
                              Child5 := Child5.NextSibling;
                            End;

                         //    InformA:=Child4.FirstChild.FirstChild.NodeValue;
                           end;
                         if Child4.NodeName='wb:InformB' then begin
                            // InformB:=Child4.FirstChild.FirstChild.FirstChild.NodeValue;
                            child5:=Child4.FirstChild;
                            while assigned(Child5) do begin
                             if Child5.NodeName='pref:InformBItem' then  begin
                                if Assigned(Child5.FirstChild) then
                                  InformB:= AnsiToUTF8(Child5.FirstChild.FirstChild.NodeValue);  //oref:address
                              end;
                              Child5 := Child5.NextSibling;
                            End;
                           end;
                          if Child4.NodeName='wb:Price' then begin
                             Price:=Child4.FirstChild.NodeValue;
                           end;
                         if Child4.NodeName='wb:Product' then begin
                             child5 := Child4.FirstChild;
                             while assigned(child5) do begin
                               if Child5.nodename = 'pref:AlcCode' then
                                 AlcCode:=Child5.FirstChild.NodeValue;
                               if Child5.nodename = 'pref:FullName' then
                               begin
                                  if assigned(Child5.FirstChild) then
                                    AlcName:=AnsiToUTF8(replaceStr(trim(Child5.FirstChild.NodeValue)))
                                  else
                                    begin
                                      alcname:='';
                                    end;
                               end;
                             { if Child5.nodename = 'pref:ShortName' then
                               begin
                                  if assigned(Child5.FirstChild) then
                                    AlcName:=AnsiToUTF8(replaceStr(trim(Child5.FirstChild.NodeValue)))
                               end;  }
                               if Child5.nodename = 'pref:Capacity' then
                                 Capacity:=Child5.FirstChild.NodeValue;
                               if Child5.nodename = 'pref:AlcVolume' then
                                 AlcVolume:=Child5.FirstChild.NodeValue;
                               if Child5.nodename = 'pref:ProductVCode' then
                                 ProductVCode:=Child5.FirstChild.NodeValue;
                               Child5 := Child5.NextSibling;
                             end;
                           end;
                         Child4 := Child4.NextSibling;
                       end;
                       if alcname='' then begin
                          recbuf:=DB_Query('select  `egaisname` from `spproduct` where `alccode`="'+AlcCode+'";');
                          rowbuf:=DB_Next(recbuf);
                          if rowbuf<>nil then
                            alcName:=rowbuf[0]
                           else
                             showmessage('Не полностью указаны данные по товару в накладной '+DocNumber+' от '+DocDate);

                       end else begin
                         UpdateProduct(AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,'',ClientKodEgais,'');
                       end;
                       // ====== Авто запрос Справки А =====
                       try
                         QueryFormA(informa);
                       except

                       end;

                       Query:='INSERT INTO `docformab` (`docid`,`AlcItem`,`numposition`,`forma`,`oldformb`) VALUES ('''+idDoc+''','''+AlcCode+''','+IdPosition+','''+informa+''','''+informb+''');';
                       DB_query(Query);
                       AlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
                       if self.flOptMode then
                            QUERY:='INSERT INTO `doc221` (`docid`,`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`factCount`,`Price`,`formA`,`formB`) VALUES'
                         +'('''+idDoc+''','''+DocNumber+''','''+DocDate+''','''+ClientKodEgais+''','''+ClientName+''','''+IdPosition+
                         ''','''+AlcName+''','''','''+AlcCode+''','''+Quantity+''',''0'','''+Price+''','''+informa+''','''+informb+''');'
                       else
                         QUERY:='INSERT INTO `doc221` (`docid`,`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`factCount`,`Price`,`formA`,`formB`) VALUES'
                         +'('''+idDoc+''','''+DocNumber+''','''+DocDate+''','''+ClientKodEgais+''','''+ClientName+''','''+IdPosition+
                         ''','''+AlcName+''','''','''+AlcCode+''','''+Quantity+''','''+Quantity+''','''+Price+''','''+informa+''','''+informb+''');';

            //   //    StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                       try
                          SummaDoc:=SummaDoc+(StrToFloat(Price)*StrToFloat(Quantity));
                       except
                       end;
                       DB_query(Query);
                       i:=i+1;

                    end;
                    Child3 := Child3.NextSibling;
                  end;

               end;
               Child2 := Child2.NextSibling;
            end;
            if flNew then  begin
              // == Добавляем документ в журнал ==
                Query:='INSERT INTO `docjurnale` (`DocId`,`numdoc`,`datedoc`,`clientregid`,`ClientName`,`status`,`summa`,`registry`,`type`,`addressclient`) VALUES'+
                    ' ('''+idDoc+''','''+DocNumber+''','''+DocDate+''','''+ClientKodEgais+''','''+ClientName+''',''---'','+FloatToStr(SummaDoc)+',''+'',''WayBill'','''+ReplaceStr(ConsigneeClientAddress)+''');';
             DB_query(Query);
             end ELSE  BEGIN
               Query:='UPDATE `docjurnale` SET `addressclient`='''+ConsigneeClientAddress+''' WHERE ((`datedoc`='''+docDate+''')AND(`numdoc`='''+DocNumber+'''))AND(`docid`='''+iddoc+''');';
              DB_query(Query);
             end;
             // ==== 02.03.2016 y =====================
             recbuf :=DB_query('SELECT * FROM `doctransp` WHERE (`datedoc`='''+docDate+''')AND(`numdoc`='''+DocNumber+''');');
             rowbuf:=DB_Next(recbuf);
 {                   TRAN_CAR:=''; TRAN_CUSTOMER:=''; TRAN_DRIVER:='';
                   TRAN_LOADPOINT:=''; TRAN_UNLOADPOINT:=''; TRAN_FORWARDER:='';}

             if rowbuf=nil then
               query:='INSERT INTO `doctransp` (`numdoc`,`datedoc`,`egaisid`,`CAR`,`CUSTOMER`,`DRIVER`,`LOADPOINT`,`UNLOADPOINT`,`FORWARDER`) VALUES '+
               '('''+DocNumber+''','''+docDate+''','''','''+TRAN_CAR+''','''+TRAN_CUSTOMER+''','''+TRAN_DRIVER+''','''+TRAN_LOADPOINT+''','''+TRAN_UNLOADPOINT+''','''+TRAN_FORWARDER +''');'
             else
                query :='UPDATE `doctransp` SET `CAR`='''+TRAN_CAR+''',`CUSTOMER`='''+TRAN_CUSTOMER+
                ''',`DRIVER`='''+TRAN_DRIVER+''',`LOADPOINT`='''+TRAN_LOADPOINT+
                ''',`UNLOADPOINT`='''+TRAN_UNLOADPOINT+
                ''',`FORWARDER`='''+TRAN_FORWARDER+''' WHERE (`datedoc`='''+docDate+''')AND(`numdoc`='''+DocNumber+''');' ;
             DB_Query(Query);
          end;
        // ===============================
        Child1 := Child1.NextSibling;
        end;

      end;
    Child := Child.NextSibling;
 end;
// DisconnectDB();
 // ====== конец обработки ======
 s1:='';
 for i:=1 to length(DocNumber) do
  if DocNumber[i] in ['\','/',':',';','&'] then s1:='-'
  else
    s1:=s1+ DocNumber[i];

 sLine.SaveToFile(utf8toansi(PathDir+'\in\WayBill\WayBill_'+docDate+'_'+s1+'_'+ClientINN+'.xml'));


end;


function TFormStart.loadFromEGAISFormB(const aSTR:String):boolean;
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate,
  DocType,IdDoc,iDPosition,Quantity,informa,informb,price,alccode,alcname,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  Query:String;
  corpos:integer;
  flSubWay:boolean;

begin
 flSubWay:=false;
 corpos:=0;
  result:=false;
   S:= TStringStream.Create(aStr);
   Try
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
   Finally
     S.Free;
   end;
   flNew:=true;
   summaDoc:=0;
   Child :=XML.DocumentElement.FirstChild;
   while Assigned(Child) do begin
     if Child.NodeName = 'ns:Document' then begin
        Child1:=child.FirstChild;
        while Assigned(Child1) AND flNew do begin

          // ==== Заголовок документа =====
          if Child1.NodeName = 'ns:TTNInformBReg' then begin
            Child2 := child1.FirstChild;
            ConnectDB();
            while Assigned(Child2) do begin

              if Child2.NodeName = 'wbr:Header' then begin
                Child3:=Child2.FirstChild;
                While Assigned(Child3) do begin
                  if Child3.NodeName = 'wbr:Identity' then
                    IdDoc:=AnsiToUTF8(replaceStr(Child3.FirstChild.NodeValue));
                  if Child3.NodeName = 'wbr:WBNUMBER' then
                    DocNumber:= AnsiToUTF8(Child3.FirstChild.NodeValue);
                  if Child3.NodeName = 'wbr:WBDate' then
                    docDate:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wbr:WBRegId' then
                    WBRegId:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wbr:EGAISFixNumber' then
                    EGAISFixNumber:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wbr:EGAISFixDate' then
                    EGAISFixDate:= Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'wbr:Shipper' then begin
                    child4:=Child3.FirstChild;
                    while assigned(Child4) do begin
                      if Child4.NodeName = 'oref:ClientRegId' then
                        ClientKodEgais:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:FullName' then
                        ClientName:= AnsiToUTF8(replaceStr(Child4.FirstChild.NodeValue));
                      if Child4.NodeName = 'oref:INN' then
                        ClientINN:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:KPP' then
                        ClientKPP:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName = 'oref:address' then
                        ClientAddress:= AnsiToUTF8(Child4.FirstChild.NextSibling.FirstChild.NodeValue);  //oref:address

                      Child4 := Child4.NextSibling;
                    end;
                  end;
                  Child3 := Child3.NextSibling;
                end;
              end;
              // ====== Содержимое документа ======

              if (Child2.NodeName = 'wbr:Content')and(flNew) then begin

                  recbuf := DB_Query('SELECT `registry` FROM `docjurnale` WHERE (`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");');
                  rowbuf:=DB_Next(recbuf);
                  if rowbuf <> nil then
                    if rowbuf[0]='-' then
                      flSubWay:=true;
                  Child3:=Child2.FirstChild;
                    i:=1;
                  While Assigned(Child3) do begin
                    if Child3.NodeName ='wbr:Position' then begin
                       child4:=Child3.FirstChild;
                       while assigned(Child4) do begin
                         if Child4.NodeName='wbr:Identity' then begin
                             IdPosition:=Child4.FirstChild.NodeValue;
                           end;
                         if Child4.NodeName='wbr:InformBRegId' then begin
                             InformB:=Child4.FirstChild.NodeValue;
                           end;
                         Child4 := Child4.NextSibling;
                       end;
                       recbuf:=DB_query('SELECT * FROM `docformab` WHERE (`docid`="'+idDoc+'") AND (`numposition`="'+IdPosition+'");');
                       rowbuf:=Db_Next(recbuf);
                      if rowbuf<>nil then
                        Query:='UPDATE `docformab` SET `formb`="'+informb+'" WHERE (`docid`="'+idDoc+'") AND (`numposition`="'+IdPosition+'");'
                      else
                        Query:='INSERT INTO `docformab` (`formb`,`docid`,`numposition`,`numdoc`,`datedoc` ) VALUES ("'+informb+'","'+idDoc+'","'+IdPosition+'","'+DocNumber+'","'+DocDate+'");' ;
                      DB_query(Query);
                      if flSubWay then begin
                        recbuf:= DB_query('SELECT `formb` FROM `doc21` WHERE `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'" AND `posit`="'+IdPosition+'" ;');
                        if db_next(recbuf)=nil then
                          i:=i+1;
                        DB_query('UPDATE `doc21` SET `nowformb`="'+InformB+'" WHERE `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'" AND `posit`="'+inttostr(i)+'" ;');
                      end;
                      i:=i+1;
                    end;
                    Child3 := Child3.NextSibling;
                  end;

               end;
               Child2 := Child2.NextSibling;
            end;
            if flNew then  begin
              // == Добавляем документ в журнал ==


              Query:='UPDATE `docjurnale` SET `WBRegId`="'+WBRegId+'", `EGAISFixNumber`="'+EGAISFixNumber+'", `EGAISFixDate`="'+EGAISFixDate+'" '
                    +'WHERE ( `DocId`="'+idDoc+'")AND(`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");';
              DB_query(Query);

              Query:='UPDATE `docjurnale` SET `WBRegId`="'+WBRegId+'", `EGAISFixNumber`="'+EGAISFixNumber+'", `EGAISFixDate`="'+EGAISFixDate+'",  `status`="+++"'
                    +'WHERE ( `registry`="-")AND(`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");';
              DB_query(Query);
              // ==================================
            end
            else
            begin
              Query:='UPDATE `docjurnale` SET `WBRegId`="'+WBRegId+'", `EGAISFixNumber`="'+EGAISFixNumber+'", `EGAISFixDate`="'+EGAISFixDate+'",  `status`="+++"'
                    +'WHERE ( `DocId`="'+idDoc+'")AND(`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");';
              DB_query(Query);
              Query:='UPDATE `docjurnale` SET `WBRegId`="'+WBRegId+'", `EGAISFixNumber`="'+EGAISFixNumber+'", `EGAISFixDate`="'+EGAISFixDate+'",  `status`="+++"'
                    +'WHERE ( `registry`="-")AND(`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");';
              DB_query(Query);
            end;
//            DisconnectDB();
            DB_Query('UPDATE `ticket` set `numdoc`="'+DocNumber+'" ,`datedoc`="'+DocDate+'" WHERE `RegId`="'+WBRegId+'";');
          end;
        // ===============================
        Child1 := Child1.NextSibling;
        end;

      end;
    Child := Child.NextSibling;
 end;

 // ====== конец обработки ======
 // =============================
 Query:='SELECT `ClientAccept` FROM `docjurnale` WHERE ( `DocId`="'+idDoc+'")AND(`numdoc`="'+DocNumber+'")AND(`datedoc`="'+DocDate+'");';
 recbuf :=DB_query(Query);
 rowbuf:=DB_Next(recbuf);
 if rowbuf<>Nil then begin
   if  rowbuf[0]='+' then
     result:=true;
 end;
 // =============================


end;
{
 перерабатываем механизм загрузки данных из ЕГАИС
 1. WayBill
 2. FormB
 3. Other

}

Procedure TFormStart.refreshEGAIS();
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  s2,S1:String;
  S : TStringStream;
 SLine:TStringList;
 tempurl:String;
  uid:String;
  eStatus:String;
  Query:String;
  fl1:boolean;
  indL:Integer;
  Hs1:String;
  blobxml:cardinal;
  spchar2,
  spchar:pchar;
  strhex:string;
begin
  formlogging.AddMessage('Запускаем обновление!');
  if flUpdateAdmin then begin
   if  (flAsAdmin) and (GetConstant('flagUpdate')<>'1') then
        SetConstant('flagUpdate','1')
      else begin
          showmessage('Обновление уже запущено!');
          exit;
      end;
  end;
  formJurnale.StatusBar1.Panels.Items[0].Text:='Получаем список документов';
  SLine:= TStringList.Create;
  SLine.Clear;
  SLine.Text:=SaveToServerGET('opt/out',S1);
  Try
   S:= TStringStream.Create(SLine.Text);
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
  except
   showmessage('Ошибка:'+sline.text);
   S.Free;
   SetConstant('flagUpdate','0');
   exit;
  end;
  S.Free;
  indL:=0;
  formJurnale.StatusBar1.Panels.Items[0].Text:='L:0';
 try
  // 1. Этап грузим накладные ===========
  formlogging.AddMessage('1. Получаем накладные:');
 Child :=XML.DocumentElement.FirstChild;
 while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
        s1:=Child.FirstChild.NodeValue;
        s2:=s1;
        i:=pos('/',s2);
        tempurl:='';
        while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
        end;
          // ============ Если не грузили то сначало Сохраним в БД ====
          //  mysql_real_escape_string()


        Hs1:=s1;
       if ((pos('opt/out/WAYBILL/',s1)<>0)or(pos('opt/out/WayBill/',s1)<>0))or(pos('opt/out/waybill/',s1)<>0) then begin
        formJurnale.StatusBar1.Panels.Items[0].Text:='L1:'+inttostr(IndL);
        formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
        Application.ProcessMessages;
        SLine.Clear;
        recbuf :=DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
        rowbuf:=DB_Next(recbuf);
        if rowbuf<>nil then
        else
          begin
            SLine.Text:=SaveToServerGET(tempurl,'');
            if  SLine.Text<>'' then begin
             if SLine.Strings[0]='' then
               SLine.Delete(0);
             strhex:='';
           //  strhex:=Format(SLine.Text,  [ AsciiText,HexText])
//             for i:=1 to length(SLine.Text) do
               strhex:=StringToHex(SLine.Text);//strhex+hexStr(ord(SLine.Text[i]),2);
             Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`xmlfile`) VALUES ("'+tempurl+'","xml",0x'+strhex+');';
             recbuf :=DB_Query(query);
             End;
          ii:=pos('opt/out/WAYBILL/',s1);
          if ii<=0 then ii:=pos('opt/out/WayBill/',s1);
          if ii<=0 then ii:=pos('opt/out/WAYBILL/',s1);
          if ii<=0 then ii:=pos('opt/out/waybill/',s1);

          ii:=ii+16;
          try
          SLine.SaveToFile(PathDir+'\in\WayBill\WayBill_'+copy(s1,ii+1,length(s1)-ii)+'.xml');
          Except
            SLine.SaveToFile(PathDir+'\in\WayBill\WayBill_'+'.xml');
          end;
          loadFromEGAISTTN(SLine.Text);
          end;
       end;

      end;
      indL  := indL+1;
      Child := Child.NextSibling
 end;
 // 2. Этап загрузки Справки Б =====
 formlogging.AddMessage('2. Получаем справки Б:');
 Child :=XML.DocumentElement.FirstChild;
 while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
        s1:=Child.FirstChild.NodeValue;
        s2:=s1;
        i:=pos('/',s2);
        tempurl:='';
        while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
        end;
          // ============ Если не грузили то сначало Сохраним в БД ====
          //  mysql_real_escape_string()


        Hs1:=s1;

      if (pos('opt/out/FORMBREGINFO/',Hs1)<>0)or(pos('opt/out/FORMBREGINFO/',s1)<>0) then begin
        formJurnale.StatusBar1.Panels.Items[0].Text:='L2:'+inttostr(IndL);
        formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
        Application.ProcessMessages;
        if child.Attributes.Length > 0 then
          uid:= child.Attributes.GetNamedItem('replyId').NodeValue
        else
          uid:='';
        formJurnale.StatusBar1.Panels.Items[2].Text:='L:';
        recbuf :=DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
        rowbuf:=DB_Next(recbuf);
        if rowbuf<>nil then begin
          if uid<>'' then
            SaveToServerPOST(tempurl,'');
        end
        else
          begin

            SLine.Text:=SaveToServerGET(tempurl,'');
            if  SLine.Text<>'' then begin
             if SLine.Strings[0]='' then
               SLine.Delete(0);
             strhex:='';
             for i:=1 to length(SLine.Text) do
               strhex:=strhex+hexStr(ord(SLine.Text[i]),2);
             Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'",0x'+strhex+');';
             recbuf :=DB_Query(query);
             ii:=pos('opt/out/FORMBREGINFO/',s1);
             if ii<=0 then ii:=pos('opt/out/FORMBREGINFO/',s1);
                ii:=ii+20;
             SLine.SaveToFile(PathDir+'\in\WayBill\FORMBREGINFO_'+copy(s1,ii+1,length(s1)-ii)+'.xml');
             if loadFromEGAISFormB(SLine.Text) THEN
               SaveToServerPOST(tempurl,'');
            end;
          end;
       end;

      end;
        indL:=indL+1;
       Child := Child.NextSibling
 end;
 // 3. ======================================================
 formlogging.AddMessage('3. Получаем Акты расхождения:');
   Child :=XML.DocumentElement.FirstChild;
 while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
              if child.Attributes.Length > 0 then
        uid:= child.Attributes.GetNamedItem('replyId').NodeValue
        else
          uid:='';
        s1:=Child.FirstChild.NodeValue;
        s2:=s1;
        i:=pos('/',s2);
        tempurl:='';
        while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
        end;
          // ============ Если не грузили то сначало Сохраним в БД ====
          //  mysql_real_escape_string()


        Hs1:=s1;

      if (pos('opt/out/WAYBILLACT/',Hs1)<>0)or(pos('opt/out/WayBillAct/',s1)<>0) then begin
        formJurnale.StatusBar1.Panels.Items[0].Text:='L3:'+inttostr(IndL);
        formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
        Application.ProcessMessages;
        formJurnale.StatusBar1.Panels.Items[2].Text:='L:';
        recbuf :=DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
        rowbuf:=DB_Next(recbuf);
        if rowbuf<>nil then
          SaveToServerPOST(tempurl,'')
        else
          begin

            SLine.Text:=SaveToServerGET(tempurl,'');
            if  SLine.Text<>'' then begin
             if SLine.Strings[0]='' then
               SLine.Delete(0);
             strhex:='';
             strhex:=StringToHex(SLine.Text);
             Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'",0x'+strhex+');';
             recbuf :=DB_Query(query);

             if loadWayBillAct(SLine.Text) then
                SaveToServerPOST(tempurl,'');
            end;
          end;
       end;

      end;
       indL:=indL+1;
       Child := Child.NextSibling
 end;

 // 4. Этап загрузки Прочее =====
 formlogging.AddMessage('4. Ответы от ЕГАИС:');
   Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
       if Child.NodeName = 'url' then begin
         s1:=Child.FirstChild.NodeValue;
         s2:=s1;
         i:=pos('/',s2);
         tempurl:='';
         while i<>0 do begin
             s2:=copy(s2,i+1,Length(s2)-i);
             if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
             i:=pos('/',s2);
         end;
           // ============ Если не грузили то сначало Сохраним в БД ====
           //  mysql_real_escape_string()


         Hs1:=s1;
         recbuf :=DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
         rowbuf:=DB_Next(recbuf);
         if rowbuf<>nil then begin
           if pos('opt/out/ReplyPartner/',s1)<>0 then
              SaveToServerDELETE(tempurl,'');
           if (pos('opt/out/Ticket/',s1)<>0)or(pos('opt/out/TICKET/',s1)<>0) then
              SaveToServerDELETE(tempurl,'');
           if (pos('out/ReplyRests/',s1)<>0)or(pos('out/ReplyAP/',s1)<>0) then
              SaveToServerDELETE(tempurl,'');
           formJurnale.StatusBar1.Panels.Items[0].Text:='D4:'+inttostr(IndL);
           formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
           Application.ProcessMessages;
           // ==================================================================
           if (((((pos('out/ReplyRests/',s1)<>0)or(pos('out/ReplyAP/',s1)<>0))
            OR((pos('opt/out/ReplyAP/',s1)<>0)or(pos('opt/out/ReplyPartner/',s1)<>0)))
            OR (((pos('opt/out/ReplyFormB/',s1)<>0)or(pos('opt/out/REPLYFORMB/',s1)<>0))
            OR ((pos('opt/out/ReplyHistoryFormB/',s1)<>0)or(pos('opt/out/REPLYHISTORYFORMB/',s1)<>0))))
            OR (((pos('opt/out/ReplyFormA/',s1)<>0)or(pos('opt/out/REPLYFORMA/',s1)<>0))
            OR ((pos('opt/out/CryptoTicket/',s1)<>0)or(pos('opt/out/CRYPTOTICKET/',s1)<>0))))OR(pos('opt/out/ReplyRestsShop_v2/',s1)<>0) then
              SaveToServerPOST(tempurl,'');
           // ==============
         end
         else
           begin
         formJurnale.StatusBar1.Panels.Items[0].Text:='L4:'+inttostr(IndL);
         formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
         Application.ProcessMessages;
            SLine.Text:=SaveToServerGET(tempurl,'');
            if  SLine.Text<>'' then begin
              if SLine.Strings[0]='' then
                    SLine.Delete(0);

              if child.Attributes.Length > 0 then
                uid:= child.Attributes.GetNamedItem('replyId').NodeValue
              else
                uid:='';
              // === сохраняем в журнал БД ===
              if (pos('out/ReplyRests/',s1)<>0)or(pos('out/ReplyAP/',s1)<>0) then
              begin
                strhex:='';
                Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'","");';
                recbuf :=DB_Query(query);
              end
              else begin
                strhex:='';
                strhex:=StringToHex(SLine.Text);
                Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'",0x'+strhex+');';
                recbuf :=DB_Query(query);
              end;
              // ==============  Загрузка формы ===============
              if pos('opt/out/ReplyAP/',s1)<>0 then begin
                if  SLine.Text<>'' then begin
                  SLine.SaveToFile(PathDir+'\out\ReplyAP_'+uid+'.xml');
                  LoadEGAISsprProduct( SLine.Text);
                  Query:='SELECT status FROM `docjurnale` WHERE (`uid`="'+uid+'")AND(`type`="ReplyAP");';
                  recbuf := DB_query(Query);
                  if recbuf<>Nil then begin
                   rowbuf := DB_Next(recbuf);
                   eStatus:=rowbuf[0];
                   if eStatus[1] = '-' then begin
                    Query:='UPDATE `docjurnale` SET `docid`="'+tempurl+'",`status`="+--" WHERE (`uid`="'+uid+'")AND(`type`="ReplyAP");';
                    DB_Query(Query);
                   end
                  end
                  else
                   DB_query('INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+uid+'","'+tempurl+
                      '","Запрос товара","2015-11-17","ReplyAP","+--");');
                  SaveToServerPOST(tempurl,'');
                 end;
              end;
          if (pos('opt/out/ReplyRestsShop_v2/',s1)<>0)or(pos('opt/out/REPLYRESTSSHOP_V2/',s1)<>0) then begin
            SLine.Clear;
            SLine.Text:=SaveToServerPOST(tempurl,S1);
           // if SLine.Count>1 then
            begin
              loadFromEGAISRestsShop_v2(SLine.Text);
            End;
            SLine.SaveToFile(PathDir+'\in\WayBill\ReplyRestsShop_v2_'+s2+'.xml');
         end;
              if pos('opt/out/ReplyPartner/',s1)<>0 then begin
               fl1:=false;
               Query:='SELECT `status` FROM `docjurnale` WHERE (`uid`="'+uid+'")AND(`type`="ReplyPartner" );';
               recbuf := DB_Query(Query);
               rowbuf := DB_Next(recbuf);
                 if rowbuf<>nil then begin
                 eStatus:=rowbuf[0];
                 if eStatus[1] = '-' then begin
                   fl1:=true;
                   Query:='UPDATE `docjurnale` SET `docid`="'+tempurl+'",`status`="+--" WHERE (`uid`="'+uid+'")AND(`type`="ReplyPartner");';
                   DB_Query(Query);
                 //Загружаем во внутренний справочник данные
                 end ;
               end ;
               if not fl1 then
               begin
                 fl1:=true;
                 Query:='INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+uid+'","'+tempurl+'","Запрос Поставщиков","2015-11-17","ReplyPartner","+--");';
                 DB_Query(Query);
               end;
               SLine.SaveToFile(PathDir+'\out\ReplyPartner_'+uid+'.xml');
               LoadEGAISsprPartner( SLine.Text, uid);
               formJurnale.StatusBar1.Panels.Items[2].Text:='Загрузка о клиентах:'+uid;
               SaveToServerPOST(tempurl,'');
              end;

           if (pos('opt/out/Ticket/',s1)<>0)or(pos('opt/out/TICKET/',s1)<>0) then begin
                  SLine.SaveToFile(PathDir+'\out\Ticket_'+uid+'.xml');
                 LoadTicketEGAIS(SLine.Text, uid);
                 if pos('>Accepted</',SLine.Text)<>0  then begin
                   if connectDB() then begin
                     Query:='SELECT * FROM `docjurnale` WHERE `uid`="'+uid+'";';
                     recbuf :=DB_query(Query);
                     if recbuf<>Nil then begin
                      Query:='UPDATE `docjurnale` SET `status`="+++" WHERE `uid`="'+uid+'";';
                      DB_query(Query);
                     end;
                   end;
                 end;
               end;
            end;

            if (pos('opt/out/InventoryRegInfo/',s1)<>0)or(pos('opt/out/INVENTORYREGINFO/',s1)<>0) then begin
                 SLine.SaveToFile(PathDir+'\out\InventoryRegInfo_'+uid+'.xml');
                 LoadActInventoryInformBReg(SLine.Text, uid);
                 SaveToServerPOST(tempurl,'');
            end;
            // Остаток Товара из ЕГАИС
            if pos('out/ReplyRests/',s1)<>0 then begin
               SLine.text:=SaveToServerGET(tempurl,S1);
               if GetConstant('lastupdateRests') = uid then begin
                   loadFromEGAISRests(SLine.Text);
                   formlogging.AddMessage('Получили документ с остатками в ЕГАИС');
                 end;
               SaveToServerPOST(tempurl,'');
            end;

            if (pos('opt/out/WAYBILLACT/',Hs1)<>0)or(pos('opt/out/WayBillAct/',s1)<>0) then begin
                SLine.SaveToFile(PathDir+'\in\WayBill\WayBillAct_'+s2+'.xml');
                if loadWayBillAct(SLine.Text) then
                   SaveToServerPOST(tempurl,'');

            end;
            if (pos('opt/out/ReplyFormA/',s1)<>0)or(pos('opt/out/REPLYFORMA/',s1)<>0) then begin
                SLine.SaveToFile(PathDir+'\in\WayBill\ReplyFormA_'+s2+'.xml');
                  loadReplyFormA(SLine.Text, uid);
               SaveToServerPOST(tempurl,'');
            end;
            if (pos('opt/out/ReplyFormB/',s1)<>0)or(pos('opt/out/REPLYFORMB/',s1)<>0) then begin
                SLine.SaveToFile(PathDir+'\in\WayBill\ReplyFormB_'+s2+'.xml');
               loadReplyFormB(SLine.Text, uid);
               SaveToServerPOST(tempurl,'');
            end;
            if (pos('opt/out/ReplyHistoryFormB/',s1)<>0)or(pos('opt/out/REPLYHISTORYFORMB/',s1)<>0) then begin
                SLine.SaveToFile(PathDir+'\in\WayBill\ReplyHistoryFormB'+s2+'.xml');
               LoadQueryHistoryFormB(SLine.Text, uid);
               SaveToServerPOST(tempurl,'');
            end;
              // ===================   LoadQueryHistoryFormB
             end;
          end;
        indL:=indL+1;
        Child := Child.NextSibling ;
     end;  // end while

 except
   // ==== Снимаем семафор обновления =====
   ShowMessage('При обновлении произошла ошибка!'+#13#10+s1);
   SetConstant('flagUpdate','0');
 end;
  SLine.Free;
   // ==== Снимаем семафор обновления =====
  SetConstant('flagUpdate','0');
  formlogging.AddMessage('Закончили обновление!');
end;
// =================================================================

Procedure TFormStart.refreshEGAISformB();
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  s2,S1:String;
  S : TStringStream;
 SLine:TStringList;
 tempurl:String;
  uid:String;
  eStatus:String;
  Query:String;
  fl1:boolean;
  indL:Integer;
  Hs1:String;
begin
   if GetConstant('flagUpdate')<>'1' then
      SetConstant('flagUpdate','1')
    else begin
        showmessage('Обновление уже запущено!');
        exit;
    end;
   SLine:= TStringList.Create;
   SLine.Clear;
   SLine.Text:=SaveToServerGET('opt/out',S1);
   s1:= SLine.Text;
   if sline.Strings[0]='' then
     SLine.Delete(0);
   s1:=SLine.Text;
 Try
   S:= TStringStream.Create(SLine.Text);
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
 except
   showmessage('Ошибка:'+sline.text);
   S.Free;
   SetConstant('flagUpdate','0');
   exit;
 end;

   S.Free;

   indL:=0;
   formJurnale.StatusBar1.Panels.Items[0].Text:='L:0';
   Child :=XML.DocumentElement.FirstChild;
 try
   while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
          s1:=Child.FirstChild.NodeValue;
          s2:=s1;
          i:=pos('/',s2);
          tempurl:='';
          while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
          end;
          formJurnale.StatusBar1.Panels.Items[0].Text:='L:'+inttostr(IndL);
          formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
          Application.ProcessMessages;
          Hs1:=s1;
          //Hs1:=UTF8UpperCase(s1);
//          if Child.Attributes.Length> 0 then
          if (pos('opt/out/FORMBREGINFO/',Hs1)<>0)or(pos('opt/out/FORMBREGINFO/',s1)<>0) then begin
           formJurnale.StatusBar1.Panels.Items[2].Text:='L:';
           SLine.Clear;
           SLine.Text:=SaveToServerGET(tempurl,'');
           if  SLine.Text<>'' then begin

             ii:=pos('opt/out/FORMBREGINFO/',s1);
             if ii<=0 then ii:=pos('opt/out/FORMBREGINFO/',s1);
             ii:=ii+20;

             SLine.SaveToFile(PathDir+'\in\WayBill\FORMBREGINFO_'+copy(s1,ii+1,length(s1)-ii)+'.xml');

             if loadFromEGAISFormB(SLine.Text) THEN SaveToServerPOST(tempurl,'');

           end;
          end;


          if (pos('opt/out/WAYBILLACT/',Hs1)<>0)or(pos('opt/out/WayBillAct/',s1)<>0) then begin
            SLine.Clear;
            SLine.Text:=SaveToServerGET(tempurl,'');
            if SLine.Count>5 then begin

            SLine.SaveToFile(PathDir+'\in\WayBill\WayBillAct_'+s2+'.xml');
            if loadWayBillAct(SLine.Text) then

            //SaveToServerPOST(tempurl,'');

            End;
          end;


      end;
       indL:=indL+1;
      Child := Child.NextSibling
   end;
 finally
   SLine.Free;
   // ==== Снимаем семафор обновления =====
   SetConstant('flagUpdate','0');
   //DB_Query(Query);
 end;
 // SQLTransaction1.Commit;
    SetConstant('flagUpdate','0');

end;
//==================================================================

Procedure TFormStart.refreshEGAISReply();
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  s2,S1:String;
  S : TStringStream;
 SLine:TStringList;
 tempurl:String;
  uid:String;
  eStatus:String;
  Query:String;
  fl1:boolean;
  indL:Integer;
  Hs1:String;
begin
   if GetConstant('flagUpdate')<>'1' then
      SetConstant('flagUpdate','1')
    else begin
        showmessage('Обновление уже запущено!');
        exit;
    end;
   SLine:= TStringList.Create;
   SLine.Clear;
   SLine.Text:=SaveToServerGET('opt/out',S1);
   s1:= SLine.Text;

   if sline.Strings[0]='' then
     SLine.Delete(0);
   s1:=SLine.Text;
 Try
   S:= TStringStream.Create(SLine.Text);
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
 except
   showmessage('Ошибка:'+sline.text);
   S.Free;
   SetConstant('flagUpdate','0');
   exit;
 end;
   S.Free;
   indL:=0;
   formJurnale.StatusBar1.Panels.Items[0].Text:='L:0';
   Child :=XML.DocumentElement.FirstChild;
 try
   while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
          s1:=Child.FirstChild.NodeValue;
          s2:=s1;
          i:=pos('/',s2);
          tempurl:='';
          while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
          end;
          formJurnale.StatusBar1.Panels.Items[0].Text:='L:'+inttostr(IndL);
          formJurnale.StatusBar1.Panels.Items[2].Text:='D:'+s1;
          Application.ProcessMessages;
          Hs1:=s1;
          //Hs1:=UTF8UpperCase(s1);
//          if Child.Attributes.Length> 0 then


          if (pos('opt/out/ReplyAP/',s1)<>0)and(flLoadProcuct) then begin
            uid:= child.Attributes.GetNamedItem('replyId').NodeValue;
            SLine.Clear;
            SLine.Text:=SaveToServerPOST(tempurl,'');
            if  SLine.Text<>'' then begin
            // ==================
              SLine.SaveToFile(PathDir+'\out\ReplyAP_'+uid+'.xml');
              LoadEGAISsprProduct( SLine.Text);

              if  ConnectDB() then begin

              Query:='SELECT status FROM `docjurnale` WHERE (`uid`="'+uid+'")AND(`type`="ReplyAP");';
              if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                exit;
              recbuf := mysql_store_result(sockMySQL);
              if recbuf<>Nil then begin
               rowbuf := mysql_fetch_row(recbuf);
               eStatus:=rowbuf[0];
               if eStatus[1] = '-' then begin
                Query:='UPDATE `docjurnale` SET `docid`="'+tempurl+'",`status`="+--" WHERE (`uid`="'+uid+'")AND(`type`="ReplyAP");';
                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                  showmessage('ERROR:1361');
               end
              end
              else
             begin
               Query:='INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+uid+'","'+tempurl+'","Запрос товара","2015-11-17","ReplyAP","+--");';
               if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                 showmessage('ERROR:1368');
             end;
  //           DisconnectDB();
             end;
           // ======================
           end;
          end;


          if pos('opt/out/ReplyPartner/',s1)<>0 then begin
           uid:= child.Attributes.GetNamedItem('replyId').NodeValue;
           fl1:=false;
           Query:='SELECT `status` FROM `docjurnale` WHERE (`uid`="'+uid+'")AND(`type`="ReplyPartner" );';
           recbuf := DB_Query(Query);
             rowbuf := mysql_fetch_row(recbuf);
             if rowbuf<>nil then begin
             eStatus:=rowbuf[0];
             if eStatus[1] = '-' then begin
               fl1:=true;
               Query:='UPDATE `docjurnale` SET `docid`="'+tempurl+'",`status`="+--" WHERE (`uid`="'+uid+'")AND(`type`="ReplyPartner");';
               DB_Query(Query);
             //Загружаем во внутренний справочник данные
             end ;
           end ;
           if not fl1 then
           begin
             fl1:=true;
             Query:='INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+uid+'","'+tempurl+'","Запрос Поставщиков","2015-11-17","ReplyPartner","+--");';
             DB_Query(Query);
           end;
//           DisconnectDB();
             SLine.Clear;
              SLine.Text:=SaveToServerPOST(tempurl,'');
              if SLine.Text<>'' then begin
                SLine.SaveToFile(PathDir+'\out\ReplyPartner_'+uid+'.xml');
                LoadEGAISsprPartner( SLine.Text, uid);
              end;
//           SaveToServerPOST(tempurl,'');
            formJurnale.StatusBar1.Panels.Items[2].Text:='Загрузка о клиентах:'+uid;
          end;
          // Остаток Товара из ЕГАИС
          if pos('out/ReplyRests/',s1)<>0 then begin
            uid:= child.Attributes.GetNamedItem('replyId').NodeValue;
            if GetConstant('lastupdateRests') = uid then begin
               SLine.text:= SaveToServerGET(tempurl,S1);
               if SLine.text<>'' then begin
                 //for i:=1 to 5 do  SLine.Delete(0);
                 loadFromEGAISRests(SLine.Text);
               end;
              end
             else
               SLine.text:=SaveToServerPOST(tempurl,S1);
          end;

          if (pos('opt/out/ReplyFormA/',s1)<>0)or(pos('opt/out/REPLYFORMA/',s1)<>0) then begin
            SLine.Clear;
            SLine.Text:=SaveToServerPOST(tempurl,S1);
           // if SLine.Count>1 then
            begin
              loadReplyFormA(SLine.Text, uid);
            End;
            SLine.SaveToFile(PathDir+'\in\WayBill\ReplyFormA_'+s2+'.xml');
         end;

          if (pos('opt/out/ReplyRestsShop_v2/',s1)<>0)or(pos('opt/out/REPLYRESTSSHOP_V2/',s1)<>0) then begin
            SLine.Clear;
            SLine.Text:=SaveToServerPOST(tempurl,S1);
           // if SLine.Count>1 then
            begin
              loadFromEGAISRestsShop_v2(SLine.Text);
            End;
            SLine.SaveToFile(PathDir+'\in\WayBill\ReplyRestsShop_v2_'+s2+'.xml');
         end;
         if (pos('opt/out/ReplyFormB/',s1)<>0)or(pos('opt/out/REPLYFORMB/',s1)<>0) then begin
            SLine.Clear;
            SLine.Text:=SaveToServerPOST(tempurl,'');
            if SLine.Count>1 then begin
              loadReplyFormB(SLine.Text, uid);
            End;
            SLine.SaveToFile(PathDir+'\in\WayBill\ReplyFormB_'+s2+'.xml');
         end;
      end;

       indL:=indL+1;
      Child := Child.NextSibling
   end;
 finally
   SLine.Free;
   // ==== Снимаем семафор обновления =====
   SetConstant('flagUpdate','0');
   //DB_Query(Query);
 end;
 SetConstant('flagUpdate','0');
 // SQLTransaction1.Commit;
end;

Procedure TFormStart.GetTTNfromEGAIS(const NumDoc,DocDate:String);

var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  dir,
  S1:String;
  S2:String;
  SLine:TStringList;
  ID:TGUID;
  strGUID,
  Query:String;
begin
  strGUID:='';
  if CreateGuid(ID) = S_OK then begin
    strGUID:= GUIDToString(ID);
    s1:='';
    //  убираем фигурные скобки
    for i:=2 to length(strGuid)-1 do
      s1:=s1+strGuid[i];
    strGuid:=s1;
  end;

  SLine:=TStringList.Create;
  SLine.Clear;
  SLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  SLine.Add(' <ns:Documents Version="1.0"');
  SLine.Add('            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('            xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('            xmlns:c="http://fsrar.ru/WEGAIS/Common"');
  SLine.Add('            xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
  SLine.Add('            xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" ');
  SLine.Add('            xmlns:wb= "http://fsrar.ru/WEGAIS/TTNSingle"> ');
  SLine.Add('<ns:Owner>');
  SLine.Add(' <ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add(' <ns:Document>');
  SLine.Add('  <ns:WayBill>');
  SLine.Add('  <wb:Identity>'+strGUID+'</wb:Identity>');
  SLine.Add('<wb:Header>');

  SLine.Add('<wb:Type>WBInvoiceFromMe</wb:Type>');
  SLine.Add('<wb:UnitType>Packed</wb:UnitType>');
  SLine.Add('<wb:NUMBER>'+NumDoc+'</wb:NUMBER>');
  SLine.Add('<wb:Date>'+DocDate+'</wb:Date>');
  SLine.Add('<wb:ShippingDate>'+DocDate+'</wb:ShippingDate> ');
  // Прописываем транспорт
  SLine.Add('<wb:Transport>');
{
 <wb:Transport>
<wb:TRAN_CAR>Камаз А174ОС61</wb:TRAN_CAR>
<wb:TRAN_CUSTOMER>Росси МПФ ООО</wb:TRAN_CUSTOMER>
<wb:TRAN_DRIVER>Иващенко Роман Александрович</wb:TRAN_DRIVER>
<wb:TRAN_LOADPOINT>
353540, Краснодарский край, Темрюкский район, Сенной п., Мира ул., дом № 49
</wb:TRAN_LOADPOINT>
<wb:TRAN_UNLOADPOINT>
346413, Ростовская обл, Новочеркасск г, Харьковское ш, дом № 5, литер Щ,этаж 1,комната №1(S=180,6кв м),литер И,этаж 1.комнаты №№ 1(S=339,3кв м),2(S=27
</wb:TRAN_UNLOADPOINT>
<wb:TRAN_FORWARDER>Иващенко Роман Александрович</wb:TRAN_FORWARDER>
</wb:Transport>
}
  SLine.Add('</wb:Transport>');
  // Отправитель ------
  SLine.Add('<wb:Shipper >');
//  form1.Memo1.Add('<oref:Identity>1</oref:Identity>');
  SLine.Add('<oref:ClientRegId>'+EgaisKod+'</oref:ClientRegId>');
  SLine.Add('<oref:INN>'+FirmINN+'</oref:INN>');
  SLine.Add('<oref:KPP>'+FirmKPP+'</oref:KPP> ');
  SLine.Add('<oref:FullName>'+FirmFullName+'</oref:FullName>');
  SLine.Add('<oref:ShortName>'+UTF8copy(FirmShortName,1,56)+'</oref:ShortName> ');
  SLine.Add('     <oref:address >');
  SLine.Add('      <oref:Country>643</oref:Country>');
  SLine.Add('      <oref:RegionCode>61</oref:RegionCode>');
  SLine.Add('       <oref:description>'+FirmAddress+'</oref:description> ');
  SLine.Add('     </oref:address>');
  SLine.Add('</wb:Shipper>');
  // получатель ------
  if not ConnectDB() then exit;
  Query:= 'SELECT `spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`fullname`,`spproducer`.`region`,`spproducer`.`description`  FROM `doc211`,`spproducer`  WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'")AND'+
                       '(`spproducer`.`ClientRegId`=`doc211`.`ClientRegId`);';
 if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
  exit;
 recbuf := mysql_store_result(sockMySQL);
 if recbuf=Nil then
   exit;
 rowbuf := mysql_fetch_row(recbuf);
 if rowbuf<>nil then begin

  SLine.Add('<wb:Consignee >');
//  form1.Memo1.Add('<oref:Identity>1</oref:Identity>');
  SLine.Add('    <oref:INN>'+rowbuf[0]+'</oref:INN>');
  if rowbuf[1]<>'' then
    SLine.Add('     <oref:KPP>'+rowbuf[1]+'</oref:KPP>');
  SLine.Add('     <oref:ClientRegId>'+rowbuf[2]+'</oref:ClientRegId>');
  s2:= rowbuf[3];
  SLine.Add('     <oref:FullName>'+s2+'</oref:FullName>  ');
//  SLine.Add('     <oref:ShortName>'+SQLQuery1.FieldByName('spproducer.fullname').AsString+'</oref:ShortName>  ');
  SLine.Add('     <oref:address >');
  SLine.Add('      <oref:Country>643</oref:Country>');
  SLine.Add('      <oref:RegionCode>'+rowbuf[4]+'</oref:RegionCode>');
  SLine.Add('      <oref:description>'+rowbuf[5]+'</oref:description> ');
  SLine.Add('     </oref:address>');
  SLine.Add('</wb:Consignee>');
  SLine.Add('</wb:Header>');
  // Товар для ттн
  SLine.Add('<wb:Content >');
  end else
  begin
    ShowMessage('Не найден Клиент!!!! Отправить не возможно!!!');
    Exit;
  end;

  Query:= 'SELECT `spproduct`.`egaisname`,`doc21`.`alcitem`,`spproduct`.`Capacity`,`spproduct`.`AlcVolume`,`spproduct`.`ProductVCode`,`spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`FullName`,`spproducer`.`description`,`doc21`.`valuetov`,`doc21`.`Price`,`doc21`.`forma`,`doc21`.`formb`,`spproducer`.`Country`,`spproduct`.`import`  FROM `doc21`,`spproduct`,`spproducer` WHERE (`doc21`.`numdoc`="'+NumDoc+'")AND(`doc21`.`datedoc`="'+docdate+'")'+
                       'AND(`spproduct`.`AlcCode`=`doc21`.`alcitem`)AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`);';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
  exit;
 recbuf := mysql_store_result(sockMySQL);
 if recbuf=Nil then
   exit;
 rowbuf := mysql_fetch_row(recbuf);
  ind:=1;
  while rowbuf<>nil do begin
    SLine.Add(' <wb:Position >');
    SLine.Add(' <wb:Identity>'+intToStr(ind)+'</wb:Identity>');
    SLine.Add('  <wb:Product >');
    SLine.Add('   <pref:Identity>1</pref:Identity> ');
    SLine.Add('    <pref:Type>АП</pref:Type>');
    SLine.Add('      <pref:FullName>'+ReplaceSTR(rowbuf[0])+'</pref:FullName>  ');
    SLine.Add('      <pref:ShortName>'+UTF8Copy(ReplaceSTR(rowbuf[0]),1,64)+'</pref:ShortName>     ');
    SLine.Add('      <pref:AlcCode>'+rowbuf[1]+'</pref:AlcCode>                                 ');
    SLine.Add('      <pref:Capacity>'+rowbuf[2]+'</pref:Capacity>           ');
    SLine.Add('      <pref:AlcVolume>'+rowbuf[3]+'</pref:AlcVolume>        ');
    SLine.Add('      <pref:ProductVCode>'+rowbuf[4]+'</pref:ProductVCode>     ');
    SLine.Add('      <pref:Producer >                               ');
    SLine.Add('       <oref:Identity>1</oref:Identity>');
    if (rowbuf[15]='1')or(rowbuf[5]='') then
    else begin
    SLine.Add('       <oref:INN>'+rowbuf[5]+'</oref:INN>               ');
    SLine.Add('       <oref:KPP>'+rowbuf[6]+'</oref:KPP>                ');
    end;

    SLine.Add('       <oref:ClientRegId>'+rowbuf[7]+'</oref:ClientRegId>  ');
    SLine.Add('       <oref:FullName>'+replaceSTR(rowbuf[8])+'</oref:FullName>  ');
 //   SLine.Add('       <oref:ShortName></oref:ShortName> ');
    SLine.Add('       <oref:address >');
    if rowbuf[14]='' then
    SLine.Add('        <oref:Country>463</oref:Country>              ')
    else
    SLine.Add('        <oref:Country>'+rowbuf[14]+'</oref:Country>              ');
    SLine.Add('        <oref:description>'+rowbuf[9]+'</oref:description>  ');
    SLine.Add('       </oref:address>                               ');
    SLine.Add('      </pref:Producer>                               ');
    SLine.Add('   </wb:Product>                                        ');
    SLine.Add('   <wb:Pack_ID>0</wb:Pack_ID>                         ');
    SLine.Add('   <wb:Quantity>'+rowbuf[10]+'</wb:Quantity>                     ');
    SLine.Add('   <wb:Price>'+rowbuf[11]+'</wb:Price>                     ');
    SLine.Add('   <wb:Party>'+rowbuf[12]+rowbuf[13]+'</wb:Party>                            ');
    SLine.Add('   <wb:InformA >                                   ');
    SLine.Add('      <pref:RegId>'+rowbuf[12]+'</pref:RegId>                ');
    SLine.Add('   </wb:InformA>                                    ');
    SLine.Add('  <wb:InformB >                                         ');
    SLine.Add('     <pref:InformBItem >                              ');
    SLine.Add('       <pref:BRegId>'+rowbuf[13]+'</pref:BRegId>             ');
    SLine.Add('      </pref:InformBItem>                             ');
    SLine.Add('  </wb:InformB>                                    ');
    SLine.Add('  </wb:Position>');
    ind:=ind+1;
    rowbuf := mysql_fetch_row(recbuf);
  end;

  SLine.Add('   </wb:Content>');
  SLine.Add('</ns:WayBill>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
//  form1.Edit1.Text := '/opt/in/WayBill' ;
  SLine.SaveToFile(pathfile()+'\logPOSTTTH.txt');

  SLine.Text:= SaveToServerPOST('opt/in/WayBill',SLine.text);
  if SLine.Count < 1 then begin
    SLine.SaveToFile(pathfile()+'\logGetTTH.txt');
     exit;
  end;
  s1:='';
  S:= TStringStream.Create(SLine.Text);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  Finally
    S.Free;
  end;
  ShowMessage('Документ отправлен в ЕГАИС!');
  Child :=XML.DocumentElement.FirstChild;
  i:=1;
  if Assigned(Child) then
  begin
   if Child.NodeName <> 'url' then begin
        // "0--" -
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", status="0--", docid="'+strGUID+'", ClientAccept="" '+
               'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'");';
               // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''','''','''','''',''Rejected'','''+Child.NodeValue+''',''WayBill'',''WayBill'',''WayBill'','''+numdoc+''','''+docdate+''');';
     DB_query(Query);


   end else begin
     s1:= Child.NextSibling.FirstChild.NodeValue;
     Delete(s1,pos(#10,s1),1);
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", sign="'+s1+'", docid="'+strGUID+'", ClientAccept="" '+
           'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+docdate+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
   end;
  end;
//  DisconnectDB();

End;

Procedure TFormStart.GetRetTTNfromEGAIS(const NumDoc,DocDate:String);

var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  dir,
  S1:String;
  S2:String;
  SLine:TStringList;
  ID:TGUID;
  strGUID,
  Query:String;
begin
  strGUID:='';
  if CreateGuid(ID) = S_OK then begin
    strGUID:= GUIDToString(ID);
    s1:='';
    //  убираем фигурные скобки
    for i:=2 to length(strGuid)-1 do
      s1:=s1+strGuid[i];
    strGuid:=s1;
  end;

  SLine:=TStringList.Create;
  SLine.Clear;
  SLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  SLine.Add(' <ns:Documents Version="1.0"');
  SLine.Add('            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('            xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('            xmlns:c="http://fsrar.ru/WEGAIS/Common"');
  SLine.Add('            xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
  SLine.Add('            xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" ');
  SLine.Add('            xmlns:wb= "http://fsrar.ru/WEGAIS/TTNSingle"> ');
  SLine.Add('<ns:Owner>');
  SLine.Add(' <ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add(' <ns:Document>');
  SLine.Add('  <ns:WayBill>');
  SLine.Add('  <wb:Identity>'+strGUID+'</wb:Identity>');
  SLine.Add('<wb:Header>');

  SLine.Add('<wb:Type>WBReturnFromMe</wb:Type>'); // === Тип возврат
  SLine.Add('<wb:UnitType>Packed</wb:UnitType>');
  SLine.Add('<wb:NUMBER>'+NumDoc+'</wb:NUMBER>');
  SLine.Add('<wb:Date>'+DocDate+'</wb:Date>');
  SLine.Add('<wb:ShippingDate>'+DocDate+'</wb:ShippingDate> ');
  // Прописываем транспорт
  SLine.Add('<wb:Transport>');
{
 <wb:Transport>
<wb:TRAN_CAR>Камаз А174ОС61</wb:TRAN_CAR>
<wb:TRAN_CUSTOMER>Росси МПФ ООО</wb:TRAN_CUSTOMER>
<wb:TRAN_DRIVER>Иващенко Роман Александрович</wb:TRAN_DRIVER>
<wb:TRAN_LOADPOINT>
353540, Краснодарский край, Темрюкский район, Сенной п., Мира ул., дом № 49
</wb:TRAN_LOADPOINT>
<wb:TRAN_UNLOADPOINT>
346413, Ростовская обл, Новочеркасск г, Харьковское ш, дом № 5, литер Щ,этаж 1,комната №1(S=180,6кв м),литер И,этаж 1.комнаты №№ 1(S=339,3кв м),2(S=27
</wb:TRAN_UNLOADPOINT>
<wb:TRAN_FORWARDER>Иващенко Роман Александрович</wb:TRAN_FORWARDER>
</wb:Transport>
}
  SLine.Add('</wb:Transport>');
  // Отправитель ------
  SLine.Add('<wb:Shipper >');
//  form1.Memo1.Add('<oref:Identity>1</oref:Identity>');
  SLine.Add('<oref:ClientRegId>'+EgaisKod+'</oref:ClientRegId>');
  SLine.Add('<oref:INN>'+FirmINN+'</oref:INN>');
  SLine.Add('<oref:KPP>'+FirmKPP+'</oref:KPP> ');
  SLine.Add('<oref:FullName>'+FirmFullName+'</oref:FullName>');
  SLine.Add('<oref:ShortName>'+UTF8copy(FirmShortName,1,56)+'</oref:ShortName> ');
  SLine.Add('     <oref:address >');
  SLine.Add('      <oref:Country>643</oref:Country>');
  SLine.Add('      <oref:RegionCode>61</oref:RegionCode>');
  SLine.Add('       <oref:description>'+FirmAddress+'</oref:description> ');
  SLine.Add('     </oref:address>');
  SLine.Add('</wb:Shipper>');
  // получатель ------
  if not ConnectDB() then exit;
  Query:= 'SELECT `spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`fullname`,`spproducer`.`region`,`spproducer`.`description`  FROM `docjurnale`,`spproducer`  WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'")AND'+
                       '(`spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`);';
 if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
  exit;
 recbuf := mysql_store_result(sockMySQL);
 if recbuf=Nil then
   exit;
 rowbuf := mysql_fetch_row(recbuf);
 if rowbuf<>nil then begin

  SLine.Add('<wb:Consignee >');
//  form1.Memo1.Add('<oref:Identity>1</oref:Identity>');
  SLine.Add('    <oref:INN>'+rowbuf[0]+'</oref:INN>');
  if rowbuf[1]<>'' then
    SLine.Add('     <oref:KPP>'+rowbuf[1]+'</oref:KPP>');
  SLine.Add('     <oref:ClientRegId>'+rowbuf[2]+'</oref:ClientRegId>');
  s2:= rowbuf[3];
  SLine.Add('     <oref:FullName>'+s2+'</oref:FullName>  ');
//  SLine.Add('     <oref:ShortName>'+SQLQuery1.FieldByName('spproducer.fullname').AsString+'</oref:ShortName>  ');
  SLine.Add('     <oref:address >');
  SLine.Add('      <oref:Country>643</oref:Country>');
  SLine.Add('      <oref:RegionCode>'+rowbuf[4]+'</oref:RegionCode>');
  SLine.Add('      <oref:description>'+rowbuf[5]+'</oref:description> ');
  SLine.Add('     </oref:address>');
  SLine.Add('</wb:Consignee>');
  SLine.Add('</wb:Header>');
  // Товар для ттн
  SLine.Add('<wb:Content >');
  end else
  begin
    ShowMessage('Не найден Клиент!!!! Отправить не возможно!!!');
    Exit;
  end;

  Query:= 'SELECT `spproduct`.`egaisname`,`doc24`.`alccode`,`spproduct`.`Capacity`,`spproduct`.`AlcVolume`,`spproduct`.`ProductVCode`,`spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`FullName`,`spproducer`.`description`,`doc24`.`count`,`doc24`.`Price`,`doc24`.`forma`,`doc24`.`formb`,`spproducer`.`Country`,`spproduct`.`import`  FROM `doc24`,`spproduct`,`spproducer` WHERE (`doc24`.`numdoc`="'+NumDoc+'")AND(`doc24`.`datedoc`="'+docdate+'")'+
                       'AND(`spproduct`.`AlcCode`=`doc24`.`alccode`)AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`);';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
  exit;
 recbuf := mysql_store_result(sockMySQL);
 if recbuf=Nil then
   exit;
 rowbuf := mysql_fetch_row(recbuf);
  ind:=1;
  while rowbuf<>nil do begin
    SLine.Add(' <wb:Position >');
    SLine.Add(' <wb:Identity>'+intToStr(ind)+'</wb:Identity>');
    SLine.Add('  <wb:Product >');
    SLine.Add('   <pref:Identity>1</pref:Identity> ');
    SLine.Add('    <pref:Type>АП</pref:Type>');
    SLine.Add('      <pref:FullName>'+ReplaceSTR(rowbuf[0])+'</pref:FullName>  ');
    SLine.Add('      <pref:ShortName>'+UTF8Copy(ReplaceSTR(rowbuf[0]),1,64)+'</pref:ShortName>     ');
    SLine.Add('      <pref:AlcCode>'+rowbuf[1]+'</pref:AlcCode>                                 ');
    SLine.Add('      <pref:Capacity>'+rowbuf[2]+'</pref:Capacity>           ');
    SLine.Add('      <pref:AlcVolume>'+rowbuf[3]+'</pref:AlcVolume>        ');
    SLine.Add('      <pref:ProductVCode>'+rowbuf[4]+'</pref:ProductVCode>     ');
    SLine.Add('      <pref:Producer >                               ');
    SLine.Add('       <oref:Identity>1</oref:Identity>');
    if (rowbuf[15]='1')or(rowbuf[5]='') then
    else begin
    SLine.Add('       <oref:INN>'+rowbuf[5]+'</oref:INN>               ');
    SLine.Add('       <oref:KPP>'+rowbuf[6]+'</oref:KPP>                ');
    end;

    SLine.Add('       <oref:ClientRegId>'+rowbuf[7]+'</oref:ClientRegId>  ');
    SLine.Add('       <oref:FullName>'+replaceSTR(rowbuf[8])+'</oref:FullName>  ');
 //   SLine.Add('       <oref:ShortName></oref:ShortName> ');
    SLine.Add('       <oref:address >');
    if rowbuf[14]='' then
    SLine.Add('        <oref:Country>463</oref:Country>              ')
    else
    SLine.Add('        <oref:Country>'+rowbuf[14]+'</oref:Country>              ');
    SLine.Add('        <oref:description>'+rowbuf[9]+'</oref:description>  ');
    SLine.Add('       </oref:address>                               ');
    SLine.Add('      </pref:Producer>                               ');
    SLine.Add('   </wb:Product>                                        ');
    SLine.Add('   <wb:Pack_ID>0</wb:Pack_ID>                         ');
    SLine.Add('   <wb:Quantity>'+rowbuf[10]+'</wb:Quantity>                     ');
    SLine.Add('   <wb:Price>'+rowbuf[11]+'</wb:Price>                     ');
    SLine.Add('   <wb:Party>'+rowbuf[12]+rowbuf[13]+'</wb:Party>                            ');
    SLine.Add('   <wb:InformA >                                   ');
    SLine.Add('      <pref:RegId>'+rowbuf[12]+'</pref:RegId>                ');
    SLine.Add('   </wb:InformA>                                    ');
    SLine.Add('  <wb:InformB >                                         ');
    SLine.Add('     <pref:InformBItem >                              ');
    SLine.Add('       <pref:BRegId>'+rowbuf[13]+'</pref:BRegId>             ');
    SLine.Add('      </pref:InformBItem>                             ');
    SLine.Add('  </wb:InformB>                                    ');
    SLine.Add('  </wb:Position>');
    ind:=ind+1;
    rowbuf := mysql_fetch_row(recbuf);
  end;

  SLine.Add('   </wb:Content>');
  SLine.Add('</ns:WayBill>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
//  form1.Edit1.Text := '/opt/in/WayBill' ;
  SLine.SaveToFile(pathfile()+'\logPOSTretTTH.txt');

  SLine.Text:= SaveToServerPOST('opt/in/WayBill',SLine.text);
  if SLine.Count < 1 then begin
    SLine.SaveToFile(pathfile()+'\logGetTTH.txt');
     exit;
  end;
  s1:='';
  S:= TStringStream.Create(SLine.Text);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  Finally
    S.Free;
  end;
  ShowMessage('Документ отправлен в ЕГАИС!');
  Child :=XML.DocumentElement.FirstChild;
  i:=1;
  if Assigned(Child) then
  begin
   if Child.NodeName <> 'url' then begin
        // "0--" -
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", status="0--", docid="'+strGUID+'", ClientAccept="" '+
               'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'");';
               // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''','''','''','''',''Rejected'','''+Child.NodeValue+''',''WayBill'',''WayBill'',''WayBill'','''+numdoc+''','''+docdate+''');';
     DB_query(Query);


   end else begin
     s1:= Child.NextSibling.FirstChild.NodeValue;
     Delete(s1,pos(#10,s1),1);
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", sign="'+s1+'", docid="'+strGUID+'", ClientAccept="" '+
           'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+docdate+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+docdate+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
   end;
  end;
//  DisconnectDB();

End;

// Акт подтверждения ТТН
Procedure TFormStart.FromEGAISofActTTH(const numdoc, datedoc,docid:String);
var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  flSub:boolean;
  WBRegID,
  S1:String;
  SLine:TStringList;
  sLine1:TStringList;
  flAccept:String;
  Query:String;
  flAcceptedAct:boolean;
  strNote:String;
begin
  flAccept:='Accepted';
  strNote:='Приниаем продукцию';
  if not ConnectDB() then
   exit;
 Query:= 'SELECT WBRegID  FROM `docjurnale` WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND(`docid`="'+docid+'");';
  if (mysql_query(sockMySQL,PChar(Query)) < 0) then
   exit;
  recbuf := mysql_store_result(sockMySQL);
  if recbuf=Nil then
    exit;
  rowbuf := DB_Next(recbuf);
  if rowbuf=nil then exit;
 WBRegID:= rowbuf[0];
 if WBRegID='' then begin
//  disconnectDB();
  exit;
 end;
 // =============== Собираем расхождение =================
 flSub:=false;
 SLine1:= TStringList.Create;
 sLine1.clear;
 flAcceptedAct:=false;
 Query:='SELECT `doc221`.`count`,`doc221`.`factcount`,`docformab`.`formB`,`doc221`.`numposit` FROM `doc221`,`docformab`'+
 ' WHERE (`doc221`.`datedoc`="'+datedoc+'")AND(`doc221`.`numdoc`="'+NumDoc+'")AND(`doc221`.`docid`="'+docid+'") AND(`docformab`.`docid`=`doc221`.`docid`) AND(`docformab`.`numposition`=`doc221`.`numposit` );'; // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")
 if (mysql_query(sockMySQL,PChar(Query)) < 0) then
  exit;
 recbuf := mysql_store_result(sockMySQL);
 if recbuf=Nil then
   exit;
 rowbuf := mysql_fetch_row(recbuf);
  i:=0;
  while rowbuf<>nil do begin
     if StrToFloat(rowbuf[1]) < StrToFloat(rowbuf[0])  then
       i:=1;
      sLine1.Add('<wa:Position>');
      sLine1.Add('<wa:Identity>'+rowbuf[3]+'</wa:Identity> ');
      sLine1.Add('<wa:InformBRegId>'+rowbuf[2]+'</wa:InformBRegId>');
      sLine1.Add('<wa:RealQuantity>'+rowbuf[1]+'</wa:RealQuantity>');
      sLine1.Add('</wa:Position>');
      flSub:=true;
    if StrToFloat(rowbuf[1])<>0 then
      flAcceptedAct:=true;

    rowbuf := mysql_fetch_row(recbuf);
 End;
 if i=0 then
  sLine1.Clear;
 if not flAcceptedAct then begin
     flAccept:='Rejected';
      sLine1.Clear;
      strNote:='Не приниаем продукцию';
  end;
// ================================
 SLine:= TStringList.Create;

 SLine.Clear;
 SLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
 SLine.Add('<ns:Documents Version="1.0"');
 SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
 SLine.Add('xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
 SLine.Add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
 SLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"');
 SLine.Add('xmlns:wa= "http://fsrar.ru/WEGAIS/ActTTNSingle"');
 SLine.Add('>');
 SLine.Add('<ns:Owner>');
 SLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
 SLine.Add('</ns:Owner>');
 SLine.Add('<ns:Document>');
 SLine.Add('<ns:WayBillAct>');
 SLine.Add('<wa:Header>');
 SLine.Add('<wa:IsAccept>'+flAccept+'</wa:IsAccept>');
 SLine.Add('<wa:ACTNUMBER>'+numdoc+'</wa:ACTNUMBER>');
 SLine.Add('<wa:ActDate>'+DateDoc+'</wa:ActDate>');
 SLine.Add('<wa:WBRegId>'+WBRegID+'</wa:WBRegId>');
 SLine.Add('<wa:Note>'+strNote+'</wa:Note>'); // Приниаем продукцию

 SLine.Add('</wa:Header>');
 SLine.Add('<wa:Content>');
{
<wa:Position>
<wa:Identity>1</wa:Identity>
<wa:InformBRegId>000000000002142</wa:InformBRegId>
<wa:RealQuantity>1</wa:RealQuantity>
</wa:Position>
}
 for i:=0 to sline1.Count-1 do
   sLine.Add(sLine1.Strings[i]);
 SLine.Add('</wa:Content>');
 SLine.Add('</ns:WayBillAct>');
 SLine.Add('</ns:Document>');
 SLine.Add('</ns:Documents>');
 SLine.SaveToFile(pathFile()+'\logPOSTAct.log');
 S1:= SaveToServerPOST('opt/in/WayBillAct',SLine.text);
 SLine.Text:= s1;
 SLine.SaveToFile(pathFile()+'\logGetAct.log');
  S:= TStringStream.Create(SLine.Text);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    // Альтернативно:
  Finally
    S.Free;
  end;
  Child :=XML.DocumentElement.FirstChild;
  i:=1;
  if Assigned(Child) then
  begin
   s1:= Child.NextSibling.FirstChild.NodeValue;
    Delete(s1,pos(#10,s1),1);
    if Child.NodeName <> 'url' then begin
     Query:='UPDATE `docjurnale`   SET status="0--" WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND(`docid`="'+docid+'")'; //,NumDoc="'+DocNumber+'"
     ShowMessage('Ошибка при отправке Акта!');
    end else begin
     Query:='UPDATE `docjurnale` SET uid="'+Child.FirstChild.NodeValue+'", sign="'+s1+'", status="++-",`ClientAccept`="+"  WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND(`docid`="'+docid+'")'; //,NumDoc="'+DocNumber+'"
     ShowMessage('Акт отправлен успешно!');
    end;
    DB_Query(Query) ;
    Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+datedoc+'");';
          // добавлен сброс подтверждения клиента для ОПТА
    DB_query(Query);
  end;

end;

Procedure  TFormStart.readOstatok();
var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  WBRegID,
  S1:String;
  SLine:TStringList;
  Query:String;
begin
  SLine:= TStringList.Create;
  Sline.Clear;
  SLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.Add('<ns:Documents Version="1.0"');
   SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
   SLine.Add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
   SLine.Add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
   SLine.Add('<ns:Owner>');
   SLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
   SLine.Add('</ns:Owner>');
   SLine.Add('<ns:Document>');
   SLine.Add('<ns:QueryRests></ns:QueryRests>');
   SLine.Add('</ns:Document>');
   SLine.Add('</ns:Documents>');
   SLine.Text:= SaveToServerPOST('opt/in/QueryRests',SLine.text);
   SLine.SaveToFile(pathFile()+'\logGetAct.log');

     s1:='';
     S:= TStringStream.Create(SLine.Text);
     Try
       S.Position:=0;
       XML:=Nil;
       ReadXMLFile(XML,S); // XML документ целиком
       // Альтернативно:
   //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
     Finally
       S.Free;
     end;
     Child :=XML.DocumentElement.FirstChild;
     i:=1;
     if Assigned(Child) then
     begin
       if Child.NodeName <> 'url' then
           exit;
       s1:= Child.FirstChild.NodeValue;
       SetConstant('lastupdateRests',s1) ;
//       DisconnectDB();
     end;
end;

Procedure TFormStart.loadFromEGAISRests(const aStr:string);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6, Child7,Child8,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
    str2:String;
  S : TStringStream;
  sz:integer;

  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate,Capacity,AlcVolume,ProductVCode,
  DocType,IdDoc,iDPosition,Quantity,informa,informb,price,alccode,alcname,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  Query:String;
  RegionCode,iRegionCode,ICountry,
  egaisAlcName,
  iClientKodEgais,iClientINN,iClientKPP,iClientAddress,iClientName,  ShortName,   iShortName, Country:String;
  flgAutoUpdateCr:boolean;
  flImport:String;
begin
 flgAutoUpdateCr:=true;
  if GetConstant('AutoUpdateCrDate')='1' then
    flgAutoUpdateCr:=true;
  flImport:='1';
  S:= TStringStream.Create(aStr);
  Try
  S.Position:=0;
// Обрабатываем полученный файл
  XML:=Nil;
  ReadXMLFile(XML,S); // XML документ целиком
  Finally
    S.Free;
  end;
  flNew:=true;
  summaDoc:=0;
  Child :=XML.DocumentElement.FirstChild;
  if not ConnectDB() then
       exit;
  Query:='TRUNCATE TABLE `regrestsproduct` ;';
  if (mysql_query(sockMySQL,PChar(Query)) < 0) then
   exit;

  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1) AND flNew do begin

         // ==== Заголовок документа =====
         if Child1.NodeName = 'ns:ReplyRests' then begin
           Child3 := child1.FirstChild;
           while Assigned(Child3) do begin
             // ====== Содержимое документа ======

                   if Child3.NodeName ='rst:Products' then begin
                      child4:=Child3.FirstChild;
                      while assigned(Child4) do begin
                         if Child4.NodeName='rst:StockPosition' then begin
                            child5 := Child4.FirstChild;
                            while assigned(child5) do begin
                               if child5.NodeName='rst:Quantity' then begin
                                  Quantity:=child5.FirstChild.NodeValue;
                                end;
                               if child5.NodeName='rst:InformARegId' then begin
                                    InformA:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='rst:InformBRegId' then begin
                                  InformB:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='rst:Product' then begin
                                    child6 := child5.FirstChild;
                                    while assigned(child6) do begin
                                      if child6.nodename = 'pref:AlcCode' then
                                        AlcCode:=Child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:FullName' then
                                        AlcName:=replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                                      if child6.nodename = 'pref:Capacity' then
                                        Capacity:=child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:AlcVolume' then
                                        AlcVolume:=child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:ProductVCode' then
                                        ProductVCode:=child6.FirstChild.NodeValue;
                                      // =====
                                      if child6.NodeName='pref:Producer' then begin
                                            ClientINN:='';
                                            ClientKPP:='';
                                            child7 := child6.FirstChild;
                                            while assigned(child7) do begin

                                              if child7.nodename = 'oref:ClientRegId' then
                                                ClientKodEgais:=Child7.FirstChild.NodeValue;
                                              if child7.nodename = 'oref:FullName' then
                                                ClientName:=replaceStr(AnsiToUTF8(Child7.FirstChild.NodeValue));
                                              if child7.NodeName='oref:INN' then begin
                                                  ClientINN:=child7.FirstChild.NodeValue;
                                                  flImport:='';
                                                end;
                                              if child7.NodeName='oref:KPP' then begin
                                                  ClientKPP:=child7.FirstChild.NodeValue;
                                                end;
                                              if child7.nodename = 'oref:address' then begin
                                                child8 := Child7.FirstChild;
                                                while assigned(child8) do begin
                                                   if child8.nodename = 'oref:Country' then
                                                     Country:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                   if child8.nodename = 'oref:description' then begin
                                                     if Assigned(Child8.FirstChild) then begin
                                                       str2:=Child8.FirstChild.NodeValue;
                                                       ClientAddress:=replaceStr(AnsiToUTF8(str2));

                                                     end else
                                                       ClientAddress:='';
                                                   end;
                                                   child8 := child8.NextSibling;
                                                end;

                                              end;

                                              child7 := child7.NextSibling;
                                            end;
                                       End;
                                      IClientKodEgais:='';
                                      if child5.NodeName='pref:Importer' then begin
                                        flImport:='1';
                                        iClientINN:='';
                                        iClientKPP:='';
                                            child7 := child6.FirstChild;
                                            while assigned(child7) do begin

                                              if child7.nodename = 'oref:INN' then
                                                iClientINN:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                              if child7.nodename = 'oref:INN' then
                                                iClientKPP:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                              if child7.nodename = 'oref:ClientRegId' then
                                                IClientKodEgais:=Child7.FirstChild.NodeValue;
                                              if child7.nodename = 'oref:FullName' then
                                                IClientName:=replaceStr(AnsiToUTF8(Child7.FirstChild.NodeValue));
                                               if child7.nodename = 'oref:address' then begin
                                                 child8 := Child7.FirstChild;
                                                 while assigned(child8) do begin
                                                    if child8.nodename = 'oref:Country' then
                                                      iCountry:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    if child8.nodename = 'oref:description' then
                                                      iClientAddress:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    if child8.nodename = 'oref:RegionCode' then
                                                      iRegionCode:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    child8 := child8.NextSibling;
                                                 end;

                                               end;
                                                child7 := child7.NextSibling;
                                            end;
                                       End;
                                      // =====
                                      child6 := child6.NextSibling;
                                    end;
                               End;
                              Child5 := Child5.NextSibling;
                            end;

                           // AlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
                            Query:='INSERT INTO `regrestsproduct` (`AlcCode`,`AlcName`,`Quantity`,`InformARegId`,`InformBRegId`) VALUES'
                                  +'('''+AlcCode+''','''+AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)'+''','''+Quantity+''','''+InformA+''','''+InformB+''');';
                 //           StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                            if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                             exit;
                            formJurnale.StatusBar1.Panels.Items[2].Text:=AlcName;
                            Application.ProcessMessages;
                            //  ==== Надо запросить сведения о справке А ====
                            if flgAutoUpdateCr then begin
                              Query:= 'SELECT `crdate` FROM `spformfix` WHERE `formA`='''+InformA+''' AND `AlcItem`='''+AlcCode+''';';
                              recbuf:=DB_Query(Query);
                              rowbuf:=DB_Next(recbuf);
                              if rowbuf<>nil then begin
                                 if rowbuf[0]='' then
                                   QueryFormA(InformA);
                              end else begin
                                QueryFormA(InformA);
                              end;
                            end;
                              UpdateProduct(AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,IClientKodEgais);
                             // ===========================
                              if flImport = '1' then begin
                               UpdateProducer(iClientKodEgais,iClientName,iClientName,iClientINN,iClientKPP,iClientAddress,iRegionCode,iCountry);
                               UpdateProducer(ClientKodEgais,ClientName,ShortName,'','',ClientAddress,'',Country);
                             end  else
                              begin
                               UpdateProducer(ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,ClientAddress,RegionCode,Country);
                              end;


                          end;
                        Child4 := Child4.NextSibling;
                      end;
                    end;



              Child3 := Child3.NextSibling;
           end;
         end;
       // ===============================
       Child1 := Child1.NextSibling;
       end;

     end;
   Child := Child.NextSibling;
end;
//  disconnectDB();
// ====== конец обработки ======

end;

Procedure TFormStart.loadFromEGAISRestsShop_v2(const aStr:string);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6, Child7,Child8,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
    str2:String;
  S : TStringStream;
  sz:integer;

  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate,Capacity,AlcVolume,ProductVCode,
  DocType,IdDoc,iDPosition,Quantity,informa,informb,price,alccode,alcname,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  Query:String;
  RegionCode,iRegionCode,ICountry,
  egaisAlcName,
  iClientKodEgais,iClientINN,iClientKPP,iClientAddress,iClientName,  ShortName,   iShortName, Country:String;
  flgAutoUpdateCr:boolean;
  flImport:String;
  daterest:string;
begin
 RegionCode:='';
 flgAutoUpdateCr:=true;
  if GetConstant('AutoUpdateCrDate')='1' then
    flgAutoUpdateCr:=true;
  flImport:='1';
  S:= TStringStream.Create(aStr);
  Try
  S.Position:=0;
// Обрабатываем полученный файл
  XML:=Nil;
  ReadXMLFile(XML,S); // XML документ целиком
  Finally
    S.Free;
  end;
  flNew:=true;
  summaDoc:=0;
  Child :=XML.DocumentElement.FirstChild;
  if not ConnectDB() then
       exit;
//  Query:='TRUNCATE TABLE `regrestsshop` ;';
//  if (mysql_query(sockMySQL,PChar(Query)) < 0) then
//   exit;
  daterest:=FormatDateTime('YYYY-MM-DD',now());
  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1) AND flNew do begin

         // ==== Заголовок документа =====
         if Child1.NodeName = 'ns:ReplyRestsShop_v2' then begin
           Child3 := child1.FirstChild;
           while Assigned(Child3) do begin
             // ====== Содержимое документа ======
                   //if Child3.NodeName ='rst:RestsDate
                   if Child3.NodeName ='rst:Products' then begin
                      child4:=Child3.FirstChild;
                      while assigned(Child4) do begin
                         if Child4.NodeName='rst:ShopPosition' then begin
                            child5 := Child4.FirstChild;
                            while assigned(child5) do begin
                               if child5.NodeName='rst:Quantity' then begin
                                  Quantity:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='rst:Product' then begin
                                    child6 := child5.FirstChild;
                                    while assigned(child6) do begin
                                      if child6.nodename = 'pref:AlcCode' then
                                        AlcCode:=Child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:FullName' then
                                        AlcName:=replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                                      if child6.nodename = 'pref:Capacity' then
                                        Capacity:=child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:AlcVolume' then
                                        AlcVolume:=child6.FirstChild.NodeValue;
                                      if child6.nodename = 'pref:ProductVCode' then
                                        ProductVCode:=child6.FirstChild.NodeValue;
                                      // =====
                                      if child6.NodeName='pref:Producer' then begin
                                            ClientINN:='';
                                            ClientKPP:='';
                                            child7 := child6.FirstChild;
                                            while assigned(child7) do begin

                                              if child7.nodename = 'oref:ClientRegId' then
                                                ClientKodEgais:=Child7.FirstChild.NodeValue;
                                              if child7.nodename = 'oref:FullName' then
                                                ClientName:=replaceStr(AnsiToUTF8(Child7.FirstChild.NodeValue));
                                              if child7.NodeName='oref:INN' then begin
                                                  ClientINN:=child7.FirstChild.NodeValue;
                                                  flImport:='';
                                                end;
                                              if child7.NodeName='oref:KPP' then begin
                                                  ClientKPP:=child7.FirstChild.NodeValue;
                                                end;
                                              if child7.nodename = 'oref:address' then begin
                                                child8 := Child7.FirstChild;
                                                while assigned(child8) do begin
                                                   if child8.nodename = 'oref:Country' then
                                                     Country:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                   if child8.nodename = 'oref:description' then begin
                                                     if Assigned(Child8.FirstChild) then begin
                                                       str2:=Child8.FirstChild.NodeValue;
                                                       ClientAddress:=replaceStr(AnsiToUTF8(str2));

                                                     end else
                                                       ClientAddress:='';
                                                   end;
                                                   child8 := child8.NextSibling;
                                                end;

                                              end;

                                              child7 := child7.NextSibling;
                                            end;
                                       End;
                                      IClientKodEgais:='';
                                      if child5.NodeName='pref:Importer' then begin
                                        flImport:='1';
                                        iClientINN:='';
                                        iClientKPP:='';
                                            child7 := child6.FirstChild;
                                            while assigned(child7) do begin

                                              if child7.nodename = 'oref:INN' then
                                                iClientINN:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                              if child7.nodename = 'oref:INN' then
                                                iClientKPP:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                              if child7.nodename = 'oref:ClientRegId' then
                                                IClientKodEgais:=Child7.FirstChild.NodeValue;
                                              if child7.nodename = 'oref:FullName' then
                                                IClientName:=replaceStr(AnsiToUTF8(Child7.FirstChild.NodeValue));
                                               if child7.nodename = 'oref:address' then begin
                                                 child8 := Child7.FirstChild;
                                                 while assigned(child8) do begin
                                                    if child8.nodename = 'oref:Country' then
                                                      iCountry:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    if child8.nodename = 'oref:description' then
                                                      iClientAddress:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    if child8.nodename = 'oref:RegionCode' then
                                                      iRegionCode:=AnsiToUTF8(Child8.FirstChild.NodeValue);
                                                    child8 := child8.NextSibling;
                                                 end;

                                               end;
                                                child7 := child7.NextSibling;
                                            end;
                                       End;
                                      // =====
                                      child6 := child6.NextSibling;
                                    end;
                               End;
                              Child5 := Child5.NextSibling;
                            end;

                           // AlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
                            Query:='INSERT INTO `regrestsshop` (`AlcCode`,`AlcName`,`Quantity`,`daterests`) VALUES'
                                  +'('''+AlcCode+''','''+AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)'+''','''+Quantity+''','''+daterest+''');';
                 //           StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                            if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                             exit;
                            formJurnale.StatusBar1.Panels.Items[2].Text:=AlcName;
                            Application.ProcessMessages;
                            //  ==== Надо запросить сведения о справке А ====
                            Query:='SELECT * FROM `spproduct` WHERE `AlcCode`='''+AlcCode+''';';
                             recbuf := DB_Query(Query);
                             rowbuf:=DB_Next(recbuf);
                             if rowbuf=Nil then  begin  // == Нет? Создаем.
                               egaisalcname:= AlcName;
                               AlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
                               sz:=length(AlcName);
                               Query:='INSERT INTO `spproduct` (`AlcCode`,`Name`,`egaisname`,`Capacity`,`AlcVolume`,`ProductVCode`,`ClientRegId`,`import`,`IClientRegId`) VALUES'
                                     +' ('''+AlcCode+''','''+AlcName+''','''+egaisalcname+''','''+Capacity+''','''+AlcVolume+''','''+ProductVCode+''','''+ClientKodEgais+''','''+flImport+''','''+IClientKodEgais+''');';
                    //           StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                               if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                 exit;
                             END else
                             begin
                               egaisalcname:= AlcName;
                               AlcName:=AlcName+' ('+Capacity+' л.,'+AlcVolume+'%)';
                               if flImport='1' then begin
                               Query:='UPDATE `spproduct` SET `Name`='''+AlcName+''', `egaisname`='''+egaisalcname+''', `import`='''+flImport+''',`IClientRegId`='''+IClientKodEgais+''' WHERE '
                                     +'(`AlcCode`='''+AlcCode+''');';
                    //           StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                  exit;

                               end;
                             end;
                             UpdateProduct(AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,IClientKodEgais);
                             // ===========================
                              if flImport = '1' then begin
                               UpdateProducer(iClientKodEgais,iClientName,iClientName,iClientINN,iClientKPP,iClientAddress,iRegionCode,iCountry);
                               UpdateProducer(ClientKodEgais,ClientName,ShortName,'','',ClientAddress,'',Country);
                             end  else
                              begin
                               UpdateProducer(ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,ClientAddress,RegionCode,Country);
                              end;
                          end;
                        Child4 := Child4.NextSibling;
                      end;
                    end;



              Child3 := Child3.NextSibling;
           end;
         end;
       // ===============================
       Child1 := Child1.NextSibling;
       end;

     end;
   Child := Child.NextSibling;
end;
//  disconnectDB();
// ====== конец обработки ======

end;


Procedure TFormStart.LoadEGAISsprProduct(const aStr:string);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,Child7,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  str2,
  S1:String;
  S : TStringStream;
  sz:integer;
  dir:string;
  Query,
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate, RegionCode,iRegionCode,ICountry,
  DocType,IdDoc,iDPosition,Capacity,AlcVolume,ProductVCode,price,alccode,alcname,egaisAlcName,
  iClientKodEgais,iClientINN,iClientKPP,iClientAddress,iClientName,  ShortName,   iShortName, Country,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  flImport:String;
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
  flNew:=true;
  summaDoc:=0;
  iShortName:='';
  ShortName:='';
  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1) AND flNew do begin

         // ==== Заголовок документа =====
         if Child1.NodeName = 'ns:ReplyAP' then begin
           Child3 := child1.FirstChild;
           while Assigned(Child3) do begin
             // ====== Содержимое документа ======

                   if Child3.NodeName ='rap:Products' then begin
                      child4:=Child3.FirstChild;
                      while assigned(Child4) do begin
                         if Child4.NodeName='rap:Product' then begin
                            flImport:='0';
                            child5 := Child4.FirstChild;
                            while assigned(child5) do begin
                               if child5.nodename = 'pref:AlcCode' then
                                  AlcCode:=Child5.FirstChild.NodeValue;
                               if child5.nodename = 'pref:FullName' then
                                  AlcName:=AnsiToUTF8(replaceStr(Child5.FirstChild.NodeValue));
                               if child5.NodeName='pref:Capacity' then begin
                                  Capacity:=child5.FirstChild.NodeValue;
                                end;
                               if child5.NodeName='pref:AlcVolume' then begin
                                    AlcVolume:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='pref:ProductVCode' then begin
                                  ProductVCode:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='pref:Producer' then begin
                                    child6 := child5.FirstChild;
                                    while assigned(child6) do begin

                                      if child6.nodename = 'oref:ClientRegId' then
                                        ClientKodEgais:=Child6.FirstChild.NodeValue;
                                      if child6.nodename = 'oref:FullName' then
                                        ClientName:=replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                                      if child6.nodename = 'oref:address' then begin
                                        child7 := Child6.FirstChild;
                                        while assigned(child7) do begin
                                           if child7.nodename = 'oref:Country' then
                                             Country:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                           if child7.nodename = 'oref:description' then begin
                                             if Assigned(Child7.FirstChild) then begin
                                               str2:=Child7.FirstChild.NodeValue;
                                               ClientAddress:=replaceStr(AnsiToUTF8(str2));

                                             end else
                                               ClientAddress:='';
                                           end;
                                           child7 := child7.NextSibling;
                                        end;

                                      end;

                                      child6 := child6.NextSibling;
                                    end;
                               End;
                              IClientKodEgais:='';
                              if child5.NodeName='pref:Importer' then begin
                                flImport:='1';
                                    child6 := child5.FirstChild;
                                    while assigned(child6) do begin

                                      if child6.nodename = 'oref:INN' then
                                        iClientINN:=AnsiToUTF8(Child6.FirstChild.NodeValue);
                                      if child6.nodename = 'oref:INN' then
                                        iClientKPP:=AnsiToUTF8(Child6.FirstChild.NodeValue);
                                      if child6.nodename = 'oref:ClientRegId' then
                                        IClientKodEgais:=Child6.FirstChild.NodeValue;
                                      if child6.nodename = 'oref:FullName' then
                                        IClientName:=replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                                       if child6.nodename = 'oref:address' then begin
                                         child7 := Child6.FirstChild;
                                         while assigned(child7) do begin
                                            if child7.nodename = 'oref:Country' then
                                              iCountry:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                            if child7.nodename = 'oref:description' then
                                              iClientAddress:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                            if child7.nodename = 'oref:RegionCode' then
                                              iRegionCode:=AnsiToUTF8(Child7.FirstChild.NodeValue);
                                            child7 := child7.NextSibling;
                                         end;

                                       end;

                                      child6 := child6.NextSibling;
                                    end;
                               End;

                              Child5 := Child5.NextSibling;
                            end;
                            UpdateProduct(AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,IClientKodEgais);
                            // ===========================
                             if flImport = '1' then begin
                              UpdateProducer(iClientKodEgais,iClientName,iClientName,iClientINN,iClientKPP,iClientAddress,iRegionCode,iCountry);
                              UpdateProducer(ClientKodEgais,ClientName,ShortName,'','',ClientAddress,'',Country);
                    {          // ==========================================================
                              // == Ищем такую же запись ==
                              Query:='SELECT * FROM `spproducer` WHERE `ClientRegId`='''+iClientKodEgais+''';';
                               if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                exit;
                               recbuf := mysql_store_result(formStart.sockMySQL);
                               rowbuf := mysql_fetch_row(recbuf);
                               if rowbuf=Nil then begin  // == Нет? Создаем.

                                Query:='INSERT INTO `spproducer` (`ClientRegId`, `FullName`, `inn`, `kpp`, `ShortName`, `description`, `region`,`Country`) VALUES '
                                      +' ('''+iClientKodEgais+''','''+iClientName+''','''+iClientINN+''','''+iClientKPP+''','''+ShortName+''','''+iClientAddress+''','''+iRegionCode+''','''+iCountry+''');';
                     //           StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
                                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                    exit;
                              end
                              else begin // == Обновляем
                                Query:='UPDATE  `spproducer` SET `FullName`='''+iClientName+''', `inn`='''+iClientINN+''',`kpp`='''+iClientKPP+''','
                                      +'`ShortName`='''+ShortName+''',`Country`='''+iCountry+''',`description`='''+iClientAddress+''',`region`='''+iRegionCode+''' WHERE `ClientRegId`='''+iClientKodEgais+''';';
                                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                     exit;

                              end;
                               // == Ищем такую же запись ==
                              Query:='SELECT * FROM `spproducer` WHERE `ClientRegId`='''+ClientKodEgais+''';';
                             if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                              exit;
                             recbuf := mysql_store_result(formStart.sockMySQL);
                             rowbuf := mysql_fetch_row(recbuf);
                             if rowbuf=Nil then begin  // == Нет? Создаем.
                                Query:='INSERT INTO `spproducer` (`ClientRegId`, `FullName`, `ShortName`, `description`, `region`,`Country`) VALUES '
                                      +' ('''+ClientKodEgais+''','''+ClientName+''','''+ShortName+''','''+ClientAddress+''','''+RegionCode+''','''+Country+''');';
                                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                  exit;
                              end
                              else begin // == Обновляем
                                Query:='UPDATE  `spproducer` SET `FullName`='''+ClientName+''', `ShortName`='''+ShortName+''','+
                                       '`Country`='''+Country+''', `description`='''+ClientAddress+''', `region`='''+RegionCode+'''  WHERE `ClientRegId`='''+ClientKodEgais+''';';
                                if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                                    exit;
                              end;    }
                      //         disconnectDB();
                            end;

                            // ==========================================================
                          end;
                        Child4 := Child4.NextSibling;
                      end;
                    end;



              Child3 := Child3.NextSibling;
           end;
         end;
       // ===============================
       Child1 := Child1.NextSibling;
       end;

     end;
   Child := Child.NextSibling;
end;

// ====== конец обработки ======


end;

Procedure TFormStart.LoadEGAISsprPartner(const aStr, uid:string);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate, ClientRegId,RegionCode,
  DocType,IdDoc,iDPosition,ShortName,description,ProductVCode,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  Query:String;
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
  flNew:=true;
  summaDoc:=0;
  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1) AND flNew do begin

         // ==== Заголовок документа =====
         if Child1.NodeName = 'ns:ReplyClient' then begin
           Child3 := child1.FirstChild;
           while Assigned(Child3) do begin
             // ====== Содержимое документа ======

                   if Child3.NodeName ='rc:Clients' then begin
                      child4:=Child3.FirstChild;
                      while assigned(Child4) do begin
                         if Child4.NodeName='rc:Client' then begin
                            child5 := Child4.FirstChild;
                            while assigned(child5) do begin
                               if child5.nodename = 'oref:ClientRegId' then
                                  ClientKodEgais:=Child5.FirstChild.NodeValue;
                               if child5.nodename = 'oref:FullName' then
                                  ClientName:=replaceStr(AnsiToUTF8(Child5.FirstChild.NodeValue));
                               if child5.NodeName='oref:ShortName' then begin
                                if assigned(Child5.FirstChild) then
                                    ShortName:=replaceStr(AnsiToUTF8(Child5.FirstChild.NodeValue))
                                  else
                                    ShortName:='';
                                end;
                               if child5.NodeName='oref:INN' then begin
                                    ClientINN:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='oref:KPP' then begin
                                  ClientKPP:=child5.FirstChild.NodeValue;
                                end;
                              if child5.NodeName='oref:address' then begin
                                    child6 := child5.FirstChild;
                                    while assigned(child6) do begin
                                      if child6.nodename = 'oref:RegionCode' then
                                        RegionCode:=Child6.FirstChild.NodeValue;
                                      if child6.nodename = 'oref:description' then
                                        description:=replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                                      child6 := child6.NextSibling;
                                    end;
                               End;
                              Child5 := Child5.NextSibling;
                            end;

                            if not formStart.ConnectDB() then
                              exit;
                            Query:='UPDATE `docjurnale` SET `clientname`='''+ShortName+''' WHERE (`uid` LIKE '''+uid+''')AND(`type`=''ReplyPartner'');';
                            if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
                               exit;
                            if UpdateProducer(ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,description,RegionCode,'643') then
                              formlogging.AddMessage('Добавлен:'+ClientName,'')
                            else
                              formlogging.AddMessage('Ошибка:'+ClientName,'!!!');
                            // == Ищем такую же запись ==
                         //   disconnectDB();
                          end;
                        Child4 := Child4.NextSibling;
                      end;
                    end;



              Child3 := Child3.NextSibling;
           end;
         end;
       // ===============================
       Child1 := Child1.NextSibling;
       end;

     end;
   Child := Child.NextSibling;
end;

// ====== конец обработки ======


end;

function TFormStart.XmlToStrDate(const aStr:String):String;
begin
  if Length(aStr) = 10 then
    result:=aStr[9]+aStr[10]+'.'+aStr[6]+aStr[7]+'.'+aStr[1]+aStr[2]+aStr[3]+aStr[4]
    else
      result:=aStr;
end;

{
<ns:Documents Version="1.0"><ns:Owner><ns:FSRAR_ID>020000288921</ns:FSRAR_ID></ns:Owner><ns:Document><ns:WayBillAct><wa:Header><wa:IsAccept>Accepted</wa:IsAccept><wa:ACTNUMBER>РНу0077831</wa:ACTNUMBER><wa:ActDate>2015-11-25</wa:ActDate><wa:WBRegId>TEST-TTN-0000176937</wa:WBRegId><wa:Note>Приниаем продукцию</wa:Note></wa:Header><wa:Content>
</wa:Content></ns:WayBillAct></ns:Document></ns:Documents>
}
function TFormStart.loadWayBillAct(Const aStr:String):boolean;
  var
    XML: TXMLDocument;
    Child4,Child3,CHild5, Child6,
    Child2, Child1, Child: TDOMNode;
    ii,i:Integer;
    InformBRegId,
    RealQuantity,
    posit:String;

    S1:String;
    S : TStringStream;
    dir:string;
    StrPrice:String;
    summaDoc:real;
    stopsearch:boolean;
    ActNum,
    DocID,RegID,OperationResult, Comments,
    ActDate,Accepted,WBRegId,DocType:String;
    flSubAct,
    flNew:boolean;
    st1:String;
    Query:String;
  begin
    result:=false;
    S:= TStringStream.Create(aStr);
    Try
    S.Position:=0;
  // Обрабатываем полученный файл
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    Finally
      S.Free;
    end;
    flSubAct:=false;
    flNew:=true;
    summaDoc:=0;
    DocID:='';
    RegID:='';
    try
    Child :=XML.DocumentElement.FirstChild;
    while Assigned(Child) do begin
      if Child.NodeName = 'ns:Document' then begin
         Child1:=child.FirstChild;
         while Assigned(Child1)  do begin  // ns:Ticket
           if Child1.NodeName ='ns:WayBillAct' then begin
             DocType:='WayBillAct';
             Child2:=child1.FirstChild;  // tc:DocType tc:DocId
             while Assigned(Child2)  do begin
               if Child2.NodeName ='wa:Header' then begin
                  Child3:= Child2.FirstChild;
                  while Assigned(Child3)  do begin
                     if Child3.NodeName ='wa:IsAccept' then begin
                        if Assigned(Child3.FirstChild) then
                        Accepted:= Child3.FirstChild.NodeValue;
                     end;
                     if Child2.NodeName ='wa:ACTNUMBER' then begin
                        if Assigned(Child2.FirstChild) then
                        ActNum:= Child2.FirstChild.NodeValue;
                     end;
                       if Child3.NodeName ='wa:WBRegId' then begin
                         WBRegId:= Child3.FirstChild.NodeValue;
                      end;
                      if Child3.NodeName ='wa:Note' then begin
                       if Assigned(Child3.FirstChild) then
                         Comments:= ANSITOUTF8(replaceStr(Child3.FirstChild.NodeValue));
                      end;
                       if Child3.NodeName ='wa:ActDate' then begin
                         ActDate:= Child3.FirstChild.NodeValue;
                      end;

                    Child3:=Child3.NextSibling;
                  end;
               end;             // tc:RegID
               // ===============================================
               if Child2.NodeName ='wa:Content' then begin
                        Child4:=Child2.FirstChild;
                        while assigned(Child4) do begin
                            if Child4.NodeName ='wa:Position' then begin
                              Child5:=Child4.FirstChild;
                              while assigned(Child5) do begin
                               //ActDate:= Child3.FirstChild.NodeValue;
                                // wa:Identity
                                if Child5.NodeName ='wa:Identity' then begin
                                    posit:=Child5.FirstChild.NodeValue;
                                 end;
                                // wa:InformBRegId
                                if Child5.NodeName ='wa:InformBRegId' then begin
                                    InformBRegId:= Child5.FirstChild.NodeValue;
                                 end;
                                // wa:RealQuantity
                                if Child5.NodeName ='wa:RealQuantity' then begin
                                    RealQuantity:= Child5.FirstChild.NodeValue;
                                 end;
                               Child5:=Child5.NextSibling;
                              end;
                              // Заносим фактич колич
                              flSubAct:=true;
                              Query:='UPDATE `doc21` SET `factcount`='''+RealQuantity+''' WHERE (`nowformb`='''+InformBRegId+''');';
                              DB_Query(Query);
                            end;
                         Child4:=Child4.NextSibling;
                        end;
               end;
               // ===============================================
               Child2:=Child2.NextSibling;
             end;
              // ====== Вносим в журнал ===========
             ConnectDB();

             Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`) VALUES'+
                 '('''+WBRegId+''','''+ActNum+''','''+WBRegId+''','''+WBRegId+''','''+Accepted+''','''+Comments+''','''+DocType+''');';
             if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                exit;
             if Accepted='Rejected' then begin
                 st1:='++2' ;
                 Query:='UPDATE `docjurnale` SET `status`=''++2'',`ClientAccept`=''-'' WHERE (`WBRegId`='''+WBRegId+''');';
                 end
               else begin
                 st1:='+1+';
                 if flSubAct then
                  Query:='UPDATE `docjurnale` SET `status`=''+1+'',`block`=''+'',`ClientAccept`=''+'',`issueclient`=''+'' WHERE (`WBRegId`='''+WBRegId+''');'
                 else
                  Query:='UPDATE `docjurnale` SET `status`=''+1+'',`block`=''+'',`ClientAccept`=''+'' WHERE (`WBRegId`='''+WBRegId+''');';
               end;
             DB_Query(Query);
             // ==================================
           end;
           Child1:=Child1.NextSibling;
         end;
      end;
      Child:=Child.NextSibling;
    end;
  result:=true;
  except



  end;
end;

Procedure TFormStart.LoadTicketEGAIS(const aStr, aUID:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  numdoc,datedoc,iddoc,
  DocID,RegID,OperationResult, Comments,
  OperationName,Accepted,TransportId,DocType:String;
  flNew:boolean;
  Query:String;
  st1:String;
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
  flNew:=true;
  summaDoc:=0;
  DocID:='';
  RegID:='';

  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1)  do begin  // ns:Ticket
         if Child1.NodeName ='ns:Ticket' then begin
           Child2:=child1.FirstChild;  // tc:DocType tc:DocId
           while Assigned(Child2)  do begin
             if Child2.NodeName ='tc:DocType' then begin
                DocType:= Child2.FirstChild.NodeValue;
             end;             // tc:RegID
             if Child2.NodeName ='tc:DocID' then begin
                if Assigned(Child2.FirstChild) then
                DocID:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='tc:RegID' then begin
                if Assigned(Child2.FirstChild) then
                RegID:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='tc:TransportId' then begin
                TransportId:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='tc:Result' then begin
              OperationName:='';
              OperationResult:='Result';
                Child3:= Child2.FirstChild;
                while Assigned(Child3)  do begin  // tc:Conclusion
                  if Child3.NodeName ='tc:Conclusion' then begin
                     Accepted:= Child3.FirstChild.NodeValue;
                  end;
                  if Child3.NodeName ='tc:Comments' then begin
                     Comments:= ANSITOUTF8(replaceStr(Child3.FirstChild.NodeValue));
                  end;
                  Child3:=Child3.NextSibling;
                end;
             end;                      //OperationResult
             if Child2.NodeName ='tc:OperationResult' then begin
              OperationResult:='OperationResult';
                Child3:= Child2.FirstChild;
                while Assigned(Child3)  do begin  // tc:Conclusion
                  if Child3.NodeName ='tc:OperationResult' then begin
                     Accepted:= Child3.FirstChild.NodeValue;
                  end;
                  if Child3.NodeName ='tc:OperationComment' then begin
                     Comments:= AnsiToUTF8(replaceStr(Child3.FirstChild.NodeValue));
                  end;
                  if Child3.NodeName ='tc:OperationName' then begin
                     OperationName:= Child3.FirstChild.NodeValue;
                  end;
                 Child3:=Child3.NextSibling;
                end;
             end;                      //OperationResult

           Child2:=Child2.NextSibling;
           end;
           // ================== Обработать статусы по тикетам ======================
           // ====== Вносим в журнал ===========
           Query:='SELECT numdoc,datedoc,docid FROM `docjurnale` WHERE (`WBRegId`='''+RegID+''')OR(`uid`='''+auid+''');';
           recbuf := DB_query(Query);
           rowbuf:=DB_Next(recBuf);
           if rowbuf<>nil then begin
             numdoc:=rowbuf[0];
             datedoc:=rowbuf[1];
             iddoc:=rowbuf[2];
           end else begin
             numdoc:='';
             datedoc:='0000-00-00';
             iddoc:='';
           end;

           Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''+auid+''','''+DocID+''','''+RegID+''','''+TransportId+''','''+Accepted+''','''+Comments+''','''+DocType+''','''+OperationResult+''','''+OperationName+''','''+numdoc+''','''+datedoc+''');';
           DB_query(Query);

           if DocType = 'WAYBILL' then begin

            if Accepted='Rejected' then
                st1:='++1'
              else
                st1:='+++';
            if numdoc<>'' then
               Query:='UPDATE `docjurnale` SET `status`='''+st1+''' WHERE (`WBRegId`='''+RegID+''')OR(`uid`='''+auid+''');'
              else
               Query:='INSERT INTO `docjurnale` (`docid`, `status`,`WBRegId`,`uid`,`type`) VALUE ('''+auid+''','''+st1+''','''+RegID+''','''+auid+''','''+doctype+''');';
               DB_query(Query);
            end;

         end;
         Child1:=Child1.NextSibling;
       end;

    end;
    Child:=Child.NextSibling;
  end;

end;

function TFormStart.DecodeEGAISPlomb(const aStr:string;var aAlcCode,aPart, aSerial:String):boolean;


var
  aCh:char;
  HiNum:word;
  num1:byte;
  aRes:String;
  aDev,aNum1,aNum2:String;
  i:integer;
  r:double;
  res1:array[0..20] of byte;
  ii:integer;
  r2,
  r1:word;
  idp:integer;
begin
  HiNum:=0;
  aPart:='';
  aSerial:='';
  result:=true;
  aAlcCode:='';
  idp:=pos('22N',aStr);
  if idp <> 0 then
     idp:=idp-1;
  adev:=aStr[1]+aStr[2];
  aNum1:=aStr[3]+aStr[4]+aStr[5]+aStr[6];
  anum2:='';
  for ii:=0 to 20 do res1[ii]:=0;
  r:=1;
  for i:=0 to 12 do begin
     aNum2:=aNum2+aStr[i+7+idp];
     aCh := aStr[i+7+idp];
      result:=true;
      if aCh in ['0'..'9'] then
        num1:=ord(aCH)-ord('0')
        else begin
          if aCh in ['A'..'Z'] then
        num1:=ord(aCH)-ord('A')+10
        else
          result:=false;
        end;

     if not result then
       exit;

     r:=r*36+Num1;

     r2:=0;
     for ii:= 20 downto 0 do begin
       r1:=res1[ii]*36+r2;
       r2:=r1 div 10;
       res1[ii]:= lo(r1 mod 10);
     end;

     r2:=num1;
     for ii:= 20 downto 0 do begin
       r1:=res1[ii]+r2;
       r2:=r1 div 10;
       res1[ii]:= lo(r1 mod 10);
     end;
     aAlcCode:='';
  //   Num1:=Num1+HiNum;
  //   HiNum:= Num1 div 10;
  //   Num1:= Num1 mod 10;
  //   aAlcCode:=Chr(ord('0')+byte(Num1))+aAlcCode;

  end;
  for ii:=2 to 20 do
    aAlcCode:=aAlcCode+inttostr(res1[ii]);

end;
{
<ns:Documents xmlns:aint="http://fsrar.ru/WEGAIS/ActInventoryInformBReg" xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef" xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ns:Owner>
    <ns:FSRAR_ID>3463047</ns:FSRAR_ID>
  </ns:Owner>
  <ns:Document>
    <ns:ActInventoryInformBReg>
      <aint:Header xmlns:aint="http://fsrar.ru/WEGAIS/ActInventoryInformBReg" xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef" xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <aint:ActRegId>TEST-INV-0000003569</aint:ActRegId>
        <aint:Number>0000101400</aint:Number>
      </aint:Header>
      <aint:Content xmlns:aint="http://fsrar.ru/WEGAIS/ActInventoryInformBReg" xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef" xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <aint:Position>
          <aint:Identity>1</aint:Identity>
          <aint:InformARegId>000000000248347</aint:InformARegId>
          <aint:InformB xmlns:aint="http://fsrar.ru/WEGAIS/ActInventoryInformBReg" xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef" xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <aint:InformBItem>
              <aint:Identity>1</aint:Identity>
              <aint:BRegId>TEST-FB-000000001078852</aint:BRegId>
            </aint:InformBItem>
          </aint:InformB>
        </aint:Position>
      </aint:Content>
    </ns:ActInventoryInformBReg>
  </ns:Document>
</ns:Documents>
}


Procedure TFormStart.LoadActInventoryInformBReg(const aStr, aUID:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, CHild6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  dir:string;
  StrPrice:String;
  summaDoc:real;
  stopsearch:boolean;
  WBRegId, EGAISFixNumber,  EGAISFixDate,
  DocType,IdDoc,iDPosition,Quantity,informa,informb,price,alccode,alcname,
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  flNew:boolean;
  Query:String;
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
   flNew:=true;
   summaDoc:=0;
   Child :=XML.DocumentElement.FirstChild;
   while Assigned(Child) do begin
     if Child.NodeName = 'ns:Document' then begin
        Child1:=child.FirstChild;
        while Assigned(Child1) AND flNew do begin

          // ==== Заголовок документа =====
          if Child1.NodeName = 'ns:ActInventoryInformBReg' then begin
            Child2 := child1.FirstChild;
            ConnectDB();
            while Assigned(Child2) do begin

              if Child2.NodeName = 'aint:Header' then begin
                Child3:=Child2.FirstChild;
                While Assigned(Child3) do begin
                  if Child3.NodeName = 'aint:ActRegId' then
                    WBRegId:=Child3.FirstChild.NodeValue;
                  if Child3.NodeName = 'aint:Number' then
                    DocNumber:= AnsiToUTF8(Child3.FirstChild.NodeValue);
                  Child3 := Child3.NextSibling;
                end;
              end;
              // ====== Содержимое документа ======
              if (Child2.NodeName = 'aint:Content')and(flNew) then begin
                  Child3:=Child2.FirstChild;
                  While Assigned(Child3) do begin
                    if Child3.NodeName ='aint:Position' then begin
                       child4:=Child3.FirstChild;
                       while assigned(Child4) do begin
                         if Child4.NodeName='<aint:InformB' then begin
                             Child5:=Child4.FirstChild;
                             While Assigned(Child5) do begin
                               if Child5.NodeName ='aint:InformBItem' then begin
                                 Child6:=Child4.FirstChild;
                                 While Assigned(Child6) do begin
                                   if Child6.NodeName='aint:Identity' then
                                      iDPosition:=Child6.FirstChild.NodeValue;
                                   if Child6.NodeName='aint:BRegId' then begin
                                      InformB:=Child6.FirstChild.NodeValue;
                                   end;
                                   Child6 := Child6.NextSibling;
                                 end;
                               End;
                               Child5 := Child5.NextSibling;
                             end;
                           end;
                         if Child4.NodeName='aint:InformARegId' then begin
                             InformA:=Child4.FirstChild.NodeValue;
                           end;
                         Child4 := Child4.NextSibling;
                       end;


                       Query:='INSERT INTO `docformab` (`formb`,`formA`,`numposition`,`docid`)  VALUE ("'+informb+'","'+informA+'","'+IdPosition+'","'+aUID+'");';
                       DB_query(Query);
                       i:=i+1;

                    end;
                    Child3 := Child3.NextSibling;
                  end;

               end;
               Child2 := Child2.NextSibling;
            end;
            if flNew then  begin
              // == Добавляем документ в журнал ==
              Query:='UPDATE `docjurnale` SET `WBRegId`="'+WBRegId+'" WHERE ( `DocId`="'+aUID+'")AND(`NumDoc`="'+DocNumber+'");';
              DB_query(Query);

              // ==================================
            end;
          //  DisconnectDB();
          end;
        // ===============================
        Child1 := Child1.NextSibling;
        end;

      end;
    Child := Child.NextSibling;
 end;

 // ====== конец обработки ======



end;

function TFormStart.ConnectDB():boolean;
begin

 result:=false;
  try
  if SockMySQL=nil then begin
   SockMySQL:=mysql_init(PMYSQL(@qmysql));
   SockMySQL :=mysql_real_connect(SockMySQL,pChar(UTF8ToANSI(mysqlurl)),PChar(UTF8TOANSI(mysqluser)),Pchar(mysqlpassword),nil,3306,nil,0);
   if SockMySQL = nil then begin
     ShowMessage(' Не могу подключиться к базе данных:'+mysqlurl);
     close;
     exit;
   end;

   if (mysql_query(sockMySQL,'SET NAMES utf8;') < 0) then begin
    ShowMessage(' Не могу создать транзакцию:'+mysql_error(sockMySQL));
    Close;
    exit;
   end;

  if (mysql_query(sockMySQL,pchar('SHOW DATABASES LIKE "egais'+prefixDB+'";')) < 0) then
  else begin
    if mysql_fetch_row( mysql_store_result(sockMySQL))=nil then begin
      mysql_query(sockMySQL,pchar('CREATE DATABASE egais'+prefixDB+' CHARACTER SET utf8 COLLATE utf8_general_ci ;'));
    end;
   end;
   if mysql_select_db(SockMySQL,pChar('egais'+prefixdb)) < 0 then
   begin
     ShowMessage(' Не могу создать транзакцию:'+mysql_error(sockMySQL));
     Close;
     exit;
   end;
  end;
  result:=true;
  except
    ShowMessage(' Не могу подключиться к БД:'+mysqlurl);
  end;

end;

procedure TFormStart.disconnectDB();
begin
 if recbuf<>nil then
   mysql_free_result(recbuf);
 recbuf    :=nil;
 if not flLowConnect then begin
   if SockMySQL<>nil then
     mysql_close(sockMySQL);
   SockMySQL :=nil;
 end;
end;

Procedure TFormStart.loadReplyFormA(const aStr, aUID:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  BottlingDate,
  numfix,datefix,forma, Comments,
  sAlcCode:String;
  Query:String;
  st1:String;
  S : TStringStream;

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
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1)  do begin  // ns:Ticket
         if Child1.NodeName ='ns:ReplyFormA' then begin
           Child2:=child1.FirstChild;  // tc:DocType tc:DocId
           while Assigned(Child2)  do begin
             if Child2.NodeName ='rfa:InformARegId' then begin
               if Assigned(Child2.FirstChild) then
                  forma:= Child2.FirstChild.NodeValue;
             end;             // tc:RegID
             if Child2.NodeName ='rfa:EGAISNumber' then begin
                if Assigned(Child2.FirstChild) then
                   numfix:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='rfa:EGAISDate' then begin
                if Assigned(Child2.FirstChild) then
                   datefix:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='rfa:TTNNumber' then begin
                if Assigned(Child2.FirstChild) then
                   Comments:= Child2.FirstChild.NodeValue;
             end;
             if Child2.NodeName ='rfa:TTNDate' then begin
                if Assigned(Child2.FirstChild) then
                   Comments:= Child2.FirstChild.NodeValue;
             end;                      //OperationResult
             if Child2.NodeName ='rfa:Quantity' then begin
                if Assigned(Child2.FirstChild) then
                   Comments:= Child2.FirstChild.NodeValue;
             end;                      //OperationResult  sAlcCode
             //rfa:BottlingDate
             if Child2.NodeName ='rfa:BottlingDate' then begin
                if Assigned(Child2.FirstChild) then
                   BottlingDate:= Child2.FirstChild.NodeValue;
             end;                      //OperationResult  sAlcCode
             if  Child2.NodeName ='rfa:Product' then begin
               Child3:=child2.FirstChild;
               while Assigned(Child3)  do begin
                 if Child3.NodeName ='pref:AlcCode' then begin
                   if Assigned(Child3.FirstChild) then
                     sAlcCode := Child3.FirstChild.NodeValue;
                 end;
                 Child3:=Child3.NextSibling;
               end;
               loadXmlProduct(child2.FirstChild);
             end;
            Child2:=Child2.NextSibling;
           end;
           // ====== Вносим в журнал ===========
           if ConnectDB() then begin
             Query:='SELECT * FROM `spformfix` WHERE (`forma`='''+forma+''')AND(`alcitem`='''+sAlcCode+''');';
             recbuf:=DB_query(Query);
//             rowbuf:=db_next(recbuf);
             if DB_Next(recbuf)<>nil then
                 Query:='UPDATE `spformfix` SET `numfix`='''+numfix+''', `datefix`='''+datefix+''',`crdate`='''+BottlingDate+''' WHERE (`forma`='''+forma+''')AND(`alcitem`='''+sAlcCode+''');'
                else
                 Query:='INSERT INTO `spformfix` (`numfix`, `datefix`,`alcitem`,`forma`,`crdate`) VALUES ('''+numfix+''','''+datefix+''','''+sAlcCode+''','''+forma+''','''+BottlingDate+''');';
               // ==================================
             recbuf:=DB_query(Query);
           end;
         end;
          Child1:=Child1.NextSibling;
         end;

       end;
      Child:=Child.NextSibling;
    end;

end;

//===== Обработки справки Б ===================
// ==== Запрос сведеней об обороте ====
Procedure TFormStart.SendQueryHistoryFormB(const fbTTN:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  Query:String;
  st1:String;
  S : TStringList;
  s1:tstringstream;
begin
  s:=TStringList.Create;
  s.Clear;
  s.add('<?xml version="1.0" encoding="UTF-8"?> <ns:Documents Version="1.0"');
  s.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  s.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  s.add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters" >');
 // <!--Кто запрашивает документы-->
  s.add('<ns:Owner>');
  //<!--Идентификатор организации в ФС РАР-->
  s.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
  s.add('</ns:Owner>');
  //<!--Запрос на алкогольную продукцию-->
  s.add('<ns:Document>');
  s.add('<ns:QueryFormBHistory>');
  s.add('<qp:Parameters>');
  s.add('<qp:Parameter>');
  s.add('<qp:Name>RFB</qp:Name> ');
  s.add('<qp:Value>'+fbTTN+'</qp:Value>');
  s.add('</qp:Parameter>');
  s.add('</qp:Parameters> ');
  s.add('</ns:QueryFormBHistory>');
  s.add('</ns:Document> ');
  s.add('</ns:Documents>');
  S.Text:= SaveToServerPOST('opt/in/QueryHistoryFormB',s.text);
  S.SaveToFile(pathFile()+'\logGetAct.log');

  //  s1:='';
    S1:= TStringStream.Create(S.Text);
    Try
      S1.Position:=0;
      XML:=Nil;
      ReadXMLFile(XML,S1); // XML документ целиком
      // Альтернативно:
  //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
    Finally
      S1.Free;
    end;
    Child :=XML.DocumentElement.FirstChild;
    i:=1;
    if Assigned(Child) then
    begin
      if Child.NodeName <> 'url' then
          exit;
      st1:= Child.FirstChild.NodeValue;
     DB_Query('INSERT INTO `docjurnale` (`docid`, `status`,`WBRegId`,`uid`,`type`,`numdoc`,`dateDoc`) VALUE ('''
      +st1+''',''+++'','''+fbTTN+''','''+st1+''',''QueryHistoryFormB'','''+copy(fbTTN,3,length(fbTTN))+''',NOW());');

      SHowMessage('Запрос отправлен!');
    end;
end;

// === Загрузка оборота
Procedure TFormStart.LoadQueryHistoryFormB(const aStr, aUID:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  doctype,OperDate,Quantity,
  numfix,datefix,wbregid, Comments,
  sAlcCode:String;
  Query:String;
  st1:String;
  S : TStringStream;
  LogRes:TStringList;
  posit1:integer;
begin
  LogRes:=TStringList.Create;
  LogRes.Clear;
  S:= TStringStream.Create(aStr);
  Try
  S.Position:=0;
// Обрабатываем полученный файл
  XML:=Nil;
  ReadXMLFile(XML,S); // XML документ целиком
  Finally
    S.Free;
  end;
  posit1:=1;
  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1)  do begin  // ns:Ticket
         if Child1.NodeName ='ns:ReplyHistFormB' then begin
           Child2:=child1.FirstChild;  // tc:DocType tc:DocId
           while Assigned(Child2)  do begin
             if Child2.NodeName ='hf:InformBRegId' then begin
               if Assigned(Child2.FirstChild) then
                  numfix:= Child2.FirstChild.NodeValue;
             end;             // tc:RegID
             if Child2.NodeName ='hf:HistFormBDate' then begin
                if Assigned(Child2.FirstChild) then
                   datefix:= Child2.FirstChild.NodeValue;
             end;                      //OperationResult
             if  Child2.NodeName ='hf:HistoryB' then begin
               Child3:=child2.FirstChild;
               while Assigned(Child3)  do begin
                 if Child3.NodeName ='hf:OperationB' then begin
                   Child4:=child3.FirstChild;
                   while Assigned(Child4)  do begin
                     if Child4.NodeName ='hf:DocType' then
                       if Assigned(Child4.FirstChild) then
                          doctype:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName ='hf:DocId' then
                       if Assigned(Child4.FirstChild) then
                          wbregid:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName ='hf:Operation' then
                        if Assigned(Child4.FirstChild) then
                          Comments:= AnsiToUTF8(Child4.FirstChild.NodeValue);
                      if Child4.NodeName ='hf:Quantity' then
                        if Assigned(Child4.FirstChild) then
                          Quantity:= Child4.FirstChild.NodeValue;
                      if Child4.NodeName ='hf:OperDate' then
                        if Assigned(Child4.FirstChild) then
                          OperDate:= Child4.FirstChild.NodeValue;

                       Child4:=Child4.NextSibling;
                      end;

                     // == обработка документа
                     recbuf:=DB_Query('SELECT `numdoc`,`datedoc`,`status`,`ClientAccept` FROM `docjurnale` WHERE wbregid="'+wbregid+'";');
                     rowbuf:=DB_next(recbuf);
                     if rowbuf=nil then
                       LogRes.Add(format('Не найден документ по номеру ЕГАИС:%s с комментарием: %s. Движение %s',[wbregid,Comments,Quantity]))
                     else begin
                      if rowbuf[3]='+' then
                       LogRes.Add(format('Найден ПРИНЯТЫЙ КЛИЕНТОМ документ ЕГАИС:%s с комментарием: %s. Движение %s',[wbregid,Comments,Quantity]))
                      else begin
                        if rowbuf[2]='+++' then
                         LogRes.Add(format('Найден НЕ ПРИНЯТЫЙ КЛИЕНТОМ документ ЕГАИС:%s с комментарием: %s. Движение %s',[wbregid,Comments,Quantity]))
                        else
                         LogRes.Add(format('Найден НЕ ОПРЕДЕЛЕННЫЙ документ ЕГАИС:%s с комментарием: %s. Движение %s',[wbregid,Comments,Quantity]));
                       end;
                     end;
                     //DB_Query('DELETE FROM `regFormB` WHERE wbregid="'+wbregid+'";');

                    // recbuf:=DB_Query('DELETE FROM `regFormB` WHERE wbregid="'+wbregid+'";');
                     recbuf:=DB_Query('SELECT * FROM `regFormB` WHERE `wbregid`="'+wbregid+'" AND `posit`="'+inttoStr(posit1)+'";');
                     rowbuf:=DB_next(recbuf);
                     if rowbuf<>nil then
                       DB_Query('UPDATE `regFormB` SET `datefix`="'+OperDate+'",`numttn`="'+wbregid+'",`comment`="'+Comments+'",`quantity`="'+Quantity+'",`uid`="'+aUID+'" WHERE `wbregid`="'+wbregid+'" AND `posit`="'+inttoStr(posit1)+'";')
                       else
                        DB_Query('INSERT INTO `regFormB` (`wbregid`,`posit`,`datefix`,`numttn`,`comment`,`quantity`,`uid`) VALUES'+
                        ' ("'+numfix+'","'+inttoStr(posit1)+'","'+OperDate+'","'+wbregid+'","'+Comments+'","'+Quantity+'","'+aUID+'");');

 //                  if Assigned(Child3.FirstChild) then
 //                    sAlcCode := Child3.FirstChild.NodeValue;
                     posit1:=posit1+1;
                 end;
                 Child3:=Child3.NextSibling;
               end;
             end;
            Child2:=Child2.NextSibling;
           end;
           // ====== Вносим в журнал ===========
           if ConnectDB() then begin
              recbuf:=DB_Query('SELECT `docformab`.`AlcItem`,`spproduct`.`name` FROM `docformab`,`spproduct` WHERE `docformab`.`formb`="'+numfix+'" and `spproduct`.`AlcCode`=`docformab`.`AlcItem`;');
              rowbuf:=DB_next(recbuf);
              if rowbuf<>nil then
               LogRes.Add(format('Для справки Б:%s Код товара: %s Наимен:%s',[numfix,rowbuf[0],rowbuf[1]]))
            end;
         end;
          Child1:=Child1.NextSibling;
         end;

       end;
      Child:=Child.NextSibling;
    end;
  st1:=StringToHex(LogRes.Text);
  DB_Query('INSERT INTO `ticket` (`uid`,`docid`,`RegID`,`accept`,`comment`,`numdoc`,`datedoc`,`datestamp`,`type`) VALUES ("'+aUID+'","'+aUID+'","","Accepted",0x'+st1+',"",NOW(),NOW(),''QueryHistoryFormB'');');

   LogRes.SaveToFile('QueryHistoryFormB_'+aUID+'.xml');
   LogRes.Free;
end;
//=============================================

Procedure TFormStart.loadReplyFormB(const aStr, aUID:String);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  S1:String;
  numfix,datefix,forma, Comments,
  sAlcCode:String;
  Query:String;
  st1:String;
  S : TStringStream;
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
    if Child.NodeName = 'ns:Document' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1)  do begin  // ns:Ticket
         if Child1.NodeName ='ns:ReplyFormB' then begin
           Child2:=child1.FirstChild;  // tc:DocType tc:DocId
           while Assigned(Child2)  do begin
             if Child2.NodeName ='rfb:InformBRegId' then begin
               if Assigned(Child2.FirstChild) then
                  forma:= Child2.FirstChild.NodeValue;
             end;             // tc:RegID
             if Child2.NodeName ='rfb:TTNNumber' then begin
                if Assigned(Child2.FirstChild) then
                   numfix:= AnsiToUTF8(Child2.FirstChild.NodeValue);
             end;
             if Child2.NodeName ='rfb:TTNDate' then begin
                if Assigned(Child2.FirstChild) then
                   datefix:= Child2.FirstChild.NodeValue;
             end;                      //OperationResult
             if  Child2.NodeName ='rfb:Product' then begin
               Child3:=child2.FirstChild;
               while Assigned(Child3)  do begin
                 if Child3.NodeName ='pref:AlcCode' then begin
                   if Assigned(Child3.FirstChild) then
                     sAlcCode := Child3.FirstChild.NodeValue;
                 end;
                 Child3:=Child3.NextSibling;
               end;
               loadXmlProduct(child2.FirstChild);
             end;
            Child2:=Child2.NextSibling;
           end;
           // ====== Вносим в журнал ===========
           if ConnectDB() then begin
              Query:='UPDATE `regrestsproduct` SET `numTTN`='''+numfix+''', `dateTTN`='''+datefix+''' WHERE (`InformBRegId`='''+forma+''')AND(`alcCode`='''+sAlcCode+''');' ;
              recbuf:=DB_query(Query);
           end;
         end;
          Child1:=Child1.NextSibling;
         end;

       end;
      Child:=Child.NextSibling;
    end;

end;


// Акт подтверждения расходных ТТН
Procedure TFormStart.FromSaleActTTH(const numdoc, datedoc:String;isAccept:boolean);
var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  flSub:boolean;
  WBRegID,
  S1:String;
  SLine:TStringList;
  sLine1:TStringList;
  flAccept:String;
  Query:String;
begin
 if isAccept then
  flAccept:='Accepted'
  else
  flAccept:='Rejected';
  if not ConnectDB() then
   exit;
 Query:= 'SELECT `WBRegID`, `issueclient`  FROM `docjurnale` WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");';
  recbuf := DB_Query(Query);
  rowbuf := DB_Next(recbuf);
  if rowbuf=nil then
     exit;
 WBRegID:= rowbuf[0];
 s1 :=  rowbuf[1];
 if WBRegID='' then begin
  //  disconnectDB();
  exit;
 end;
 if s1='1' then
   exit;
 if (s1='+') then  begin

// ================================
 SLine:= TStringList.Create;

 SLine.Clear;
 SLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
 SLine.Add('<ns:Documents Version="1.0"');
 SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
 SLine.Add('xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
 SLine.Add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
 SLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"');
 SLine.Add('xmlns:wt= "http://fsrar.ru/WEGAIS/ConfirmTicket"');
 SLine.Add('>');
 SLine.Add('<ns:Owner>');
 SLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
 SLine.Add('</ns:Owner>');
 SLine.Add('<ns:Document>');
 SLine.Add('<ns:ConfirmTicket>');
 SLine.Add('<wt:Header>');
 SLine.Add('<wt:IsConfirm>'+flAccept+'</wt:IsConfirm>');
 SLine.Add('<wt:TicketNumber>'+numdoc+'</wt:TicketNumber>');
 SLine.Add('<wt:TicketDate>'+DateDoc+'</wt:TicketDate>');
 SLine.Add('<wt:WBRegId>'+WBRegID+'</wt:WBRegId>');
 SLine.Add('<wt:Note>'+flAccept+'</wt:Note>'); // Приниаем продукцию

 SLine.Add('</wt:Header>');
 SLine.Add('</ns:ConfirmTicket>');
 SLine.Add('</ns:Document>');
 SLine.Add('</ns:Documents>');
 SLine.Text:= SaveToServerPOST('opt/in/WayBillTicket',SLine.text);
 SLine.SaveToFile(pathFile()+'\logGetAct.log');

  S:= TStringStream.Create(SLine.Text);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  Finally
    S.Free;
  end;
  Child :=XML.DocumentElement.FirstChild;
  i:=1;
  if Assigned(Child) then
  begin
//   if not ConnectDB() then
//    exit;
   s1:= Child.NextSibling.FirstChild.NodeValue;
    Delete(s1,pos(#10,s1),1);
    if Child.NodeName <> 'url' then begin
     Query:='UPDATE `docjurnale`   SET `status`="0--", `Clientaccept`=""  WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");'; //,NumDoc="'+DocNumber+'"
    end else begin
     Query:='UPDATE `docjurnale` SET uid="'+Child.FirstChild.NodeValue+'", `sign`="'+s1+'", `status`="+1+",`block`="+", `Clientaccept`="+" ,`issueclient`="1" WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");'; //,NumDoc="'+DocNumber+'"
    end;
    if (mysql_query(sockMySQL,PChar(Query)) < 0) then
      exit;

  end;
  End else
  begin
    // ================================
     SLine:= TStringList.Create;

     SLine.Clear;
     SLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
     SLine.Add('<ns:Documents Version="1.0"');
     SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
     SLine.Add('xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
     SLine.Add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
     SLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"');
     SLine.Add('xmlns:wa= "http://fsrar.ru/WEGAIS/ActTTNSingle"');
     SLine.Add('>');
     SLine.Add('<ns:Owner>');
     SLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
     SLine.Add('</ns:Owner>');
     SLine.Add('<ns:Document>');
     SLine.Add('<ns:WayBillAct>');
     SLine.Add('<wa:Header>');
     SLine.Add('<wa:IsAccept>'+flAccept+'</wa:IsAccept>');
     SLine.Add('<wa:ACTNUMBER>'+numdoc+'</wa:ACTNUMBER>');
     SLine.Add('<wa:ActDate>'+DateDoc+'</wa:ActDate>');
     SLine.Add('<wa:WBRegId>'+WBRegID+'</wa:WBRegId>');
     SLine.Add('<wa:Note>'+flAccept+'</wa:Note>'); // Приниаем продукцию
     SLine.Add('</wa:Header>');
     SLine.Add('<wa:Content>');
     SLine.Add('</wa:Content>');
     SLine.Add('</ns:WayBillAct>');
     SLine.Add('</ns:Document>');
     SLine.Add('</ns:Documents>');
     SLine.Text:= SaveToServerPOST('opt/in/WayBillAct',SLine.text);
     SLine.SaveToFile(pathFile()+'\logGetAct.log');
      S:= TStringStream.Create(sLine.text);
      Try
        S.Position:=0;
        XML:=Nil;
        ReadXMLFile(XML,S); // XML документ целиком
        // Альтернативно:
    //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
      Finally
        S.Free;
      end;
      Child :=XML.DocumentElement.FirstChild;
      i:=1;
      if Assigned(Child) then
      begin
       s1:= Child.NextSibling.FirstChild.NodeValue;
        Delete(s1,pos(#10,s1),1);
        if Child.NodeName <> 'url' then begin
         Query:='UPDATE `docjurnale` SET status="0--" WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");'; //,NumDoc="'+DocNumber+'"
         ShowMessage('Ошибка при отправке!');
        end else begin
         Query:='UPDATE `docjurnale` SET uid="'+Child.FirstChild.NodeValue+'", sign="'+s1+'", status="+++",`block`="1"  WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");'; //,NumDoc="'+DocNumber+'"
         ShowMessage('Акт отправлен с номером:'+Child.FirstChild.NodeValue);
        end;
        DB_query(Query) ;
        Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+datedoc+'");';
              // добавлен сброс подтверждения клиента для ОПТА
        DB_query(Query);
 end;

  end;
  ShowMessage('Уведомление отправлено!')
end;

Procedure TFormStart.refreshEGAISIn();
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  s2,S1:String;
  S : TStringStream;
 SLine:TStringList;
 tempurl:String;
  uid:String;
  eStatus:String;
  Query:String;
  fl1:boolean;
  indL:Integer;
begin
   SLine:= TStringList.Create;
   SLine.Clear;
   SLine.Text:=SaveToServerGET('opt/in',S1);
   s1:= SLine.Text;

   s1:=SLine.Text;
   S:= TStringStream.Create(SLine.Text);

   Try
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
   Finally
     S.Free;
   end;
   indL:=0;
   formJurnale.StatusBar1.Panels.Items[0].Text:='L:0';
   Child :=XML.DocumentElement.FirstChild;
   while Assigned(Child) do begin
      if Child.NodeName = 'url' then begin
          s1:=Child.FirstChild.NodeValue;
          s2:=s1;
          i:=pos('/',s2);
          tempurl:='';
          while i<>0 do begin
            s2:=copy(s2,i+1,Length(s2)-i);
            if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
            i:=pos('/',s2);
          end;
          formJurnale.StatusBar1.Panels.Items[1].Text:='C:'+inttostr(IndL);
          formJurnale.Repaint;
//          if Child.Attributes.Length> 0 then
          SLine.Clear;
          SLine.Text:=SaveToServerDELETE(tempurl,'');

         end;

       indL:=indL+1;
      Child := Child.NextSibling
   end;
   SLine.Free;
 // SQLTransaction1.Commit;
end;

function TFormStart.DB_query(const sSQL:String):PMYSQL_RES;
begin
  if sockMySQL = nil then
    ConnectDB();

  if sockMySQL <> nil then begin
      if (mysql_query(sockMySQL,PChar(sSQL) )<0 ) then begin
        DisconnectDB();
        result:=DB_query(sSQL);
      end

      else
       result:= mysql_store_result(sockMySQL);
    end
  else
    result:=nil;
end;

function TFormStart.DB_Next(aRes:PMYSQL_RES):MYSQL_ROW;
begin
  if aRes = nil then
    result := nil
  else
    result := mysql_fetch_row(aRes);
end;

function TFormStart.DB_checkTable(aTable:String):boolean;
begin
  //SHOW DATABASES;
  // CREATE DATABASE `text1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
  result:=false;
  recbuf:=DB_query('SHOW TABLES FROM `egais'+prefixDB+'` LIKE '''+aTable+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf <> nil then
    result:=true;
end;

function TFormStart.DB_checkCol(aTable,aCol,aType,aSize:String; aDefault:string=''):boolean;
var
  s1:string;
begin
  result:=true ;
  if DB_checkTable(aTable) then begin
     s1:= 'SHOW COLUMNS FROM `'+aTable+'` LIKE "'+aCol+'";';
     recbuf:=DB_Query(s1);
     rowbuf:=DB_Next(recbuf);
     if rowbuf<>nil then begin
            s1:=rowbuf[1];
            if pos(aType,s1)<=0 then
              DB_query('ALTER TABLE `'+aTable+'` CHANGE `'+aCol+'` `'+aCol+'` '+aType+' NOT NULL '+aDefault+';')
             else result:=false;
       end else
            DB_query('ALTER TABLE `'+aTable+'` ADD `'+aCol+'` '+aType+' NOT NULL '+aDefault+';');
   end
    else begin
      DB_query('CREATE TABLE `'+aTable+'` (`'+aCol+'` '+aType+' NOT NULL ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
      result:=true
    end;
end;

procedure TFormStart.SetConstant(const aName, aValue:String);
begin
  recbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`='''+aName+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf<>nil then
    recbuf :=DB_Query('UPDATE `const` SET `value`='''+aValue+''' WHERE `name`='''+aName+''';')
   else
     recbuf :=DB_Query('INSERT INTO `const` (`name`,`value`) VALUE ('''+aName+''','''+aValue+''');');
end;

function  TFormStart.GetConstant(aName:String):String;
begin
  recbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`='''+aName+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf<>nil then
      result:=rowbuf[0]
    else
      result:='';
end;

//function TFormStart.DeleteKeyDB(const aTable,aCol:string):boolean;
//begin
//  ALTER TABLE `spformfix`
//  	DROP INDEX `numfix`,
//  	DROP PRIMARY KEY;
//end;

// == получаем код алкпродукции по справке Б
function TFormStart.GetAlcCodeFormB(const aFormB:String):String;

begin
  recbuf :=DB_Query('SELECT `AlcCode` FROM `regrestsproduct` WHERE `InformBRegId` LIKE "'+aFormB+'";');
  rowbuf:=DB_Next(recBuf);
  if rowbuf<>nil then
     result:=rowbuf[0]
  else
     result:='';
end;

procedure tformStart.QueryFormA(const aFormA:String);
var
  SLine:TStringList;
begin
  sLine:=TStringList.Create();
    sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
    sLine.Add('<ns:Documents Version="1.0"');
    sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
    sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
    sLine.Add('<ns:Owner>');
    sLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
    sLine.Add('</ns:Owner>');
    sLine.Add('<ns:Document>');
    sLine.Add('<ns:QueryFormA>');
    sLine.Add('<qf:FormRegId>'+aFormA+'</qf:FormRegId>');
    sLine.Add('</ns:QueryFormA> ');
    sLine.Add('</ns:Document>');
    sLine.Add('</ns:Documents>');
    formStart.SaveToServerPOST('opt/in/QueryFormA',SLine.text);
    sLine.Free;
   // showMessage('Запрос отправлен!');
end;

procedure tformStart.QueryAP_v2(const aAlcCode:String);
var
  SLine:TStringList;
  str:string;
begin
  SLine:= TStringList.Create;
  SLine.Clear;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:QueryAP_v2>');
  SLine.add('<qp:Parameters>');
  SLine.add('<qp:Parameter>');
  SLine.add('<qp:Name>КОД</qp:Name>');
  SLine.add('<qp:Value>'+aAlcCode+'</qp:Value>');
  SLine.add('</qp:Parameter>');
  SLine.add('</qp:Parameters>');
  SLine.add('</ns:QueryAP_v2>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str:=savetoserverpost('opt/in/QueryAP_V2',Sline.text) ;
  showmessage(str);
  SLine.Free
   // showMessage('Запрос отправлен!');
end;

function  tformStart.ActChargeOnShopv2(const numdoc,datedoc:string):boolean;
var
  S:TStringStream;
  SLine:TStringList;
  idAlcCode,strGUID,
  aClientRegId,
  query:string;
  s1,
  str:string;
  aClientProvider:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  ind:integer;
  XML: TXMLDocument;
  Child4,Child3,CHild5, Child6,
  Child2, Child1, Child: TDOMNode;
  flrussia:boolean;
  // === doc26, docx26 - Оприходование в розницу ----
begin
  aClientProvider:='';
  SLine:= TStringList.Create;
  SLine.Clear;
  query:='SELECT (SELECT `fullname` FROM `spproducer` WHERE `clientregid`= `docx26`.`clientprovider` LIMIT 1) AS `name` FROM `docx26` WHERE `numdoc`="'+numdoc+'" AND `datedoc`="'+datedoc+'";';
  recbuf:=DB_Query(query);
  rowbuf:=DB_Next(recbuf);
  if rowbuf<>nil then
      aClientProvider:=rowbuf[0];
  strGUID:=NewGUID();
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="2.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2"');
  SLine.add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"');
  SLine.add('xmlns:ainp="http://fsrar.ru/WEGAIS/ActChargeOnShop_v2"');
  SLine.add('xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:ActChargeOnShop_v2>');
  SLine.add('<ainp:Identity>'+strGUID+'</ainp:Identity>');
  SLine.add('<ainp:Header>');
  SLine.add('<ainp:ActDate>'+datedoc+'</ainp:ActDate>');
  SLine.add('<ainp:Number>'+numdoc+'</ainp:Number>');
  SLine.add('<ainp:TypeChargeOn>Продукция, полученная до 01.01.2016</ainp:TypeChargeOn>');
  SLine.add('<ainp:Note>Акт постановки на баланс от участника системы '+aClientProvider+',версия 2.0</ainp:Note>');
  SLine.add('</ainp:Header>');
  SLine.add('<ainp:Content>');
  // ==== Описание позиции =====
  idAlcCode:='';
  ind:=1;
  query:='SELECT `alccode`,`count` FROM `doc26` WHERE `numdoc`="'+numdoc+'" AND `datedoc`="'+datedoc+'";';
  recbuf:=DB_Query(Query);
  rowBuf:=DB_Next(recbuf);
  while rowbuf<>nil do begin
    idAlcCode:=rowbuf[0];
    SLine.add('<ainp:Position>');
    SLine.add('<ainp:Identity>'+inttostr(ind)+'</ainp:Identity>');
    Query:= 'SELECT `name`,`capacity`,`clientregid`  FROM `spproduct` WHERE `alccode`="'+idAlcCode+'" LIMIT 1;';
    xrecbuf:=DB_Query(query);
    xrowbuf:=DB_Next(xrecbuf);
    if xrowbuf<> nil then begin
      aClientRegId:= xrowbuf[2];
      SLine.add('<ainp:Product>');
      SLine.add('<pref:UnitType>Packed</pref:UnitType>');
      SLine.add('<pref:Type>АП</pref:Type>');
      SLine.add('<pref:FullName>'+ReplaceStr(xrowbuf[0])+'</pref:FullName>');
      SLine.add('<pref:AlcCode>'+idAlcCode+'</pref:AlcCode>');
      SLine.add('<pref:Capacity>'+xrowBuf[1]+'</pref:Capacity>');
      // === получим данные о производителе ===
      Query:= 'SELECT `inn`,`kpp`,`FullName`,`description`,`Country`,`region`  FROM `spproducer` WHERE `ClientRegId`="'+aClientRegId+'" LIMIT 1;';
      xrecbuf:=DB_Query(query);
      xrowbuf:=DB_Next(xrecbuf);
      if xrowbuf<> nil then begin
        if (xrowbuf[4]='') or (xrowbuf[4]='643') then flrussia:=true else flrussia:=false;

        SLine.add('<pref:Producer>');
        if flrussia then SLine.add('<oref:UL>') else SLine.add('<oref:FO>');
        SLine.add('<oref:ClientRegId>'+aClientRegId+'</oref:ClientRegId>');
        SLine.add('<oref:FullName>'+replacestr(xrowbuf[2])+'</oref:FullName>');
        SLine.add('<oref:ShortName>'+UTF8Copy(replacestr(xrowbuf[2]),1,64)+'</oref:ShortName>');
        if xrowbuf[0]<>'' then begin
          SLine.add('<oref:INN>'+xrowbuf[0]+'</oref:INN>');
          if xrowbuf[1]<>'' then
            SLine.add('<oref:KPP>'+xrowbuf[1]+'</oref:KPP>');
        end;
        SLine.add('<oref:address>');
        if (xrowbuf[4]='')or(xrowbuf[4]='643') then begin
            SLine.add('<oref:Country>643</oref:Country>') ;
            if  xrowbuf[5]<>'' then
             SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>')
             else
              SLine.add('<oref:RegionCode>'+copy(xrowbuf[0],1,2)+'</oref:RegionCode>')
            end
          else begin
            SLine.add('<oref:Country>'+xrowbuf[4]+'</oref:Country>');
            if xrowbuf[5]<>'' then SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>') ;
          end;

        SLine.add('<oref:description>'+replaceStr(xrowbuf[3])+'</oref:description>');
        SLine.add('</oref:address>');
        if flrussia then SLine.add('</oref:UL>') else SLine.add('</oref:FO>');
        SLine.add('</pref:Producer>');
      end;
      SLine.add('<pref:ProductVCode>АП</pref:ProductVCode>');
      SLine.add('</ainp:Product>');
    end;
    SLine.add('<ainp:Quantity>'+rowbuf[1]+'</ainp:Quantity>');
    SLine.add('</ainp:Position>');
    rowbuf:=DB_Next(recbuf);
    ind:=ind+1;
  end;
  // ==== Описание позиции ===========
  SLine.add('</ainp:Content>');
  SLine.add('</ns:ActChargeOnShop_v2>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');

  str:=savetoserverpost('opt/in/ActChargeOnShop_v2',Sline.text) ;
  showmessage(str);
  SLine.text:=str;
  if SLine.Count < 1 then begin
    SLine.SaveToFile(pathfile()+'\logGetActChargeOnShop.txt');
     exit;
  end;
  s1:='';
  S:= TStringStream.Create(SLine.Text);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
    // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  Finally
    S.Free;
  end;
  ShowMessage('Документ отправлен в ЕГАИС!');
  Child :=XML.DocumentElement.FirstChild;

  if Assigned(Child) then
  begin
   if Child.NodeName <> 'url' then begin
        // "0--" -
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", status="0--", docid="'+strGUID+'", ClientAccept="" '+
               'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");';
               // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''','''','''','''',''Rejected'','''+Child.NodeValue+''',''ActChargeOnShop'',''ActChargeOnShop'',''ActChargeOnShop'','''+numdoc+''','''+datedoc+''');';
     DB_query(Query);


   end else begin
     s1:= Child.NextSibling.FirstChild.NodeValue;
     Delete(s1,pos(#10,s1),1);
     Query:='UPDATE `docjurnale`   SET uid="'+Child.FirstChild.NodeValue+'", sign="'+s1+'", docid="'+strGUID+'", ClientAccept="" '+
           'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
     Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+Child.FirstChild.NodeValue+'","'+NumDoc+'","'+datedoc+'");';
           // добавлен сброс подтверждения клиента для ОПТА
     DB_query(Query);
   end;
  end;
  SLine.Free

end;

function  tformStart.SendQueryRestsShopv2():boolean;
var
  S:TStringStream;
  SLine:TStringList;
  str:string;
begin
  SLine:= TStringList.Create;
   SLine.Clear;
   SLine.add('<?xml version="1.0" encoding="UTF-8"?> ');
   SLine.add('<ns:Documents Version="1.0"');
   SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
   SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
   SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters"');
   SLine.add('>');
   SLine.add('<ns:Owner>');
   SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
   SLine.add('</ns:Owner>');
   SLine.add('<ns:Document>');
   SLine.add('<ns:QueryRestsShop_v2>');
   SLine.add('</ns:QueryRestsShop_v2>');
   SLine.add('</ns:Document>');
   SLine.add('</ns:Documents>');
   str:=savetoserverpost('opt/in/QueryRestsShop_v2',Sline.text) ;
   showmessage(str);
end;
function  tformStart.Setwaybillv2():boolean;
var
  S:TStringStream;
  SLine:TStringList;
  str:string;
begin
  SLine:= TStringList.Create;
   SLine.Clear;
   SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
   SLine.add('<ns:Documents Version="1.0"');
   SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
   SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
   SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/InfoVersionTTN"');
   SLine.add('>');
   SLine.add('<ns:Owner>');
   SLine.add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
   SLine.add('</ns:Owner>');
   SLine.add('<ns:Document>');
   SLine.add('<ns:InfoVersionTTN>');
   SLine.add('<qp:ClientId>'+EgaisKod+'</qp:ClientId>');
   SLine.add('<qp:WBTypeUsed>WayBill_v2</qp:WBTypeUsed>');
   SLine.add('</ns:InfoVersionTTN>');
   SLine.add('</ns:Document>');
   SLine.add('</ns:Documents>');
   str:=savetoserverpost('opt/in/InfoVersionTTN',Sline.text) ;
   showmessage('Отправлен переход на версию 2:'+str);
end;
{
RequestRepealACO
Технические требования версия 1.0.13
37
<?xml
version="1.0" encoding="UTF
-
8"?>
<ns:Documents Version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema
-
instance"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:qp="http://fsrar.ru/WEGAIS/RequestRepealACO"
>
<n
s:Owner>
<ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
(1.15.9)
<ns:RequestRepealACO>
<qp:ClientId>030000194005</qp:ClientId>
<qp:RequestNumber>011</qp:RequestNumber>
<qp:RequestDate>2016
-
05
-
06T13
:00:00</qp:RequestDate>
<qp:ACORegId>TEST
-
INV
-
0000001216</qp:ACORegId>
</ns:RequestRepealACO>
</ns:Document>
</ns:Documents>

<?xml version="1.0" encoding="UTF
-
8"?>
<ns:Doc
uments Version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema
-
instance"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:qp="http://fsrar.ru/WEGAIS/RequestRepealAWO"
>
<ns:Owner>
<ns:FSRAR_ID>030000194005<
/ns:FSRAR_ID>
</ns:Owner>
(1.16.
3
)
<ns:Document>
<ns:RequestRepealAWO>
<qp:ClientId>030000194005</qp:ClientId>
<qp:RequestNumber>011</qp:RequestNumber>
<qp:RequestDate>2016
-
05
-
06T13:00:00</qp:RequestDate>
<qp:AWO
RegId>TEST
-
WOF
-
0000001072</qp:AWORegId>
</ns:RequestRepealAWO>
</ns:Document>
</ns:Documents>
Чтобы отправить запрос (1.16.3) на сервер, воспользуйтей командой:
curl
–
F "xml_file=@RequestRepealAWO.xml" http://localhost:8080/opt/in/
RequestRepealAWO

/
QueryClientVersion

<?xml version="1.0" encoding="utf
-
8"?>
<ns:Documents Version="1.0"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:c="http://fsrar.ru/WEGAIS/Common
"
xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"
xmlns:tts="http://fsrar.ru/WEGAIS/TransferToShop"
>
<ns:Owner>
<ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:TransferToShop>
(1.21.
1
)
<
tts:Identity>1/1</tts:Identity>
<tts:Header>
<tts:TransferNumber>1/1</tts:TransferNumber>
<tts:TransferDate>2016
-
04
-
08</tts:TransferDate>
</tts:Header>
<tts:Content>
<tts:Position>
<tts:Identity>1</tts:Identity>
<tts:ProductCode>00355430000
01238259</tts:ProductCode>
<tts:Quantity>11</tts:Quantity>
<tts:InformF2>
<pref:F2RegId>TEST
-
FB
-
000000012124173</pref:F2RegId>
</tts:InformF2>
</tts:Position>
</tts:Content>
</ns:TransferToShop>
</ns:Document>
</ns:Documents>
Отправьте
TransferToShop
.
xml
на
УТМ
командой
вида
:
curl
-
F
"
xml
_
file
=@
TransferToShop
.
xml
"
http
://
localhost
:8080/
opt
/
in
/
TransferToShop


Акт возврата продукции из торгов
ого
зал
а
(
TransferFromShop
.
xml
)
имеет вид:
<?xml version="1.0" encoding="utf
-
8"?>
<ns:Documents Version="1.0"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:c="http://fsrar.ru/WEGAIS/Common"
xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"
xmlns:tfs="http://fsrar.ru/WEGAIS
/TransferFromShop"
>
<ns:Owner>
<ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:TransferFromShop>
<tfs:Identity>1/1</tfs:Identity>
<tfs:Header>
<tfs:TransferNumber>1/1</tfs:TransferNumber>
<tfs:TransferDate>
2016
-
04
-
08</tfs:TransferDate>
</tfs:Header>
<tfs:Content>
(1.22.
1
)
<tfs:Position>
<tfs:Identity>1</tfs:Identity>
<tfs:ProductCode>0035543000001238259</tfs:ProductCode>
<tfs:Quantity>10</tfs:Quantity>
<tfs:InformF2>
<pref:F2RegId>TEST
-
FB
-
000000012124173</pref:F2RegId>
</tfs:InformF2>
</tfs:Position>
</tfs:Content>
</ns:TransferFromShop>
</ns:Document>
</ns:Documents>
Отправьте документ на УТМ командой вида:
curl
-
F
"
xml
_
file
=@
TransferFromShop
.
xml
"
http
://
localhost
:8080/
opt
/
in
/
TransferFromShop


Чтобы узнать, какая продукция и в каком количестве зарезервирована за магазином,
но еще не реализована, сформируйте документ
QueryRestsShop.xml вида:
<?xml version="1.0" encoding="UTF
-
8"?>
<ns:D
ocuments Version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema
-
instance"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters"
>
(
1.23.1
)
<ns:Owner>
<ns:FSRAR_ID>030000194005</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:QueryRestsShop_v2>
</ns:QueryRestsShop_v2>
</ns:Document>
</
ns
:
Documents
>
Отправьте документ на УТМ командой:
curl
-
F "xml_file=@QueryRestsShop.xml"
http://localhost:8080/opt/in/QueryRestsShop_v2


}

function tformStart.updateReport():String;
var
  w: TFPHTTPClient;
  fzip:TUnZipper;
  Fini:TIniFile;
begin

  w:=TFPHTTPClient.Create(Nil);
  w.Get('http://egais.retailika.ru/files/report.zip','./report.zip');
  w.Free;
  fzip := TUnZipper.Create;
  try
    fzip.FileName := './report.zip';
    fzip.OutputPath := './';
    fzip.Examine;
    fzip.UnZipAllFiles;
  finally
    fzip.Free;
  end;
  FIni:=TIniFile.Create('egaismon.ini');
  Fini.WriteString('GLOBAL','reportversion',curVerReport);
  Fini.Destroy;
end;

function  tformStart.SpFindOfCode(const aSpr,aCode:string):string;
var
  namecode:string;
begin
  //recbuf:=DB_query(
end;

function tformStart.DB_StrToDate(const aStrDate:string):TdateTime;
begin
  result:=StrToDate(aStrDate[9]+aStrDate[10]+DateSeparator+aStrDate[6]+aStrDate[7]+DateSeparator+aStrDate[1]+aStrDate[2]+aStrDate[3]+aStrDate[4]);
end;

function tformStart.GetEAN13rib(s_alccode:string):string;
var
   i:integer;
   w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
    w:= TFPHTTPClient.Create(nil);
    try
      result :=w.Get('http://www.retailika.ru/service/getean13.php?regid='+egaiskod+'&alccode='+s_alccode);
    except
      // === ошибка при подключении
      result:='';
      formlogging.AddMessage('нет доступа к интернет!','!!!');
    end;
    w.free;
    i:=pos(']',result);
    if i>0 then begin
      result:=copy(result,2,i-2);
    end;
    if  pos('error:',result)>0 then begin
      formlogging.AddMessage(''+result,'!!!');
      result:='';
    end;

    if length(result)=0 then
     begin
       formlogging.AddMessage('Не возможно получить данные!','!!!');
    end ;
end;

function tformStart.SetEAN13rib(s_alccode,a_name:string;s_ean13:string):string;
var
   w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
    w:= TFPHTTPClient.Create(nil);
    formlogging.AddMessage('sms:'+s_alccode+'','>');
    try
      result :=w.Get('http://www.retailika.ru/service/setean13.php?ean13='+s_ean13+'&alccode='+s_alccode+'&name='+s_alccode);
    except
      // === ошибка при подключении
      result:='';
    end;
    formlogging.AddMessage('sms:'+result,'>');
    w.free;
end;

Function tformStart.controlena13(strBC:String):boolean;
var
   i:integer;
   str:string;
begin
  result:=false;
  if length(strBC)=13 then
   begin
     i:=3*(strtoint(strBC[2])+strtoint(strBC[4])+strtoint(strBC[6])+strtoint(strBC[8])+strtoint(strBC[10])+strtoint(strBC[12]));
     i:= i+  strtoint(strBC[1])+strtoint(strBC[3])+strtoint(strBC[5])+strtoint(strBC[7])+strtoint(strBC[9])+strtoint(strBC[11]);
     str:=inttostr(10-(i mod 10));
     if  strBC[13] = str[1] then
      result:=true;
   end;
end;

function tformStart.StrToFloat(const strDouble:String):double;
var
   subres:double;
   i:integer;
   iPoint:integer;
   istr:String;
   k:double;
begin
  result:=0.00;
  iStr:=trim(strDouble); // !!! Убираем лишник пробелы

  for i:=1 to length(iStr) do
    if not (iStr[i] in ['.','0'..'9']) then exit; // !!!! что бы небыло символов
  iPoint:=pos('.',iStr);  // ищем позицию точки
  if iPoint=0 then iPoint:=length(iStr)+1 ;
  // теперь  надо x*10^n+r степени -
  subres:=0.0;
  for i:=1 to iPoint-1 do
    subres:=subres*10+strtoint(iStr[i]);
  result:=subres;
  // можно наоборот

    subres:=0 ;
    k:=0.1;
    for i:=iPoint+1 to length(iStr) do
      begin
       subres:=subres+strtoint(iStr[i])*k;
        k:=k*0.1;
      end;
    result:=result+ subres;
end;

function  tformStart.Str1ToDate(const strDate:String):TDateTime;
var
   str1:string;
begin
  str1:=trim(strdate);
  result:=StrtoDate(str1,'YYYY-MM-DD','-');
end;

function tformStart.NewGUID():String;  // === генератор GUID
var
  ID:TGUID;
  s1,
  strGUID:String;
  i:integer;
begin
  strGUID:='';
  if CreateGuid(ID) = S_OK then begin
    strGUID:= GUIDToString(ID);
    s1:='';
    //  убираем фигурные скобки
    for i:=2 to length(strGuid)-1 do
      s1:=s1+strGuid[i];
    strGuid:=s1;
  end;
  result:=strGUID;
end;

function tformStart.getXMLtoURL(const aStr:string):String;  // === генератор GUID
var
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
begin
  flErrorEGAIS:='';
  result:='';
  S:= TStringStream.Create(aStr);
  Try
    S.Position:=0;
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
  Finally
    S.Free;
  end;
  Child :=XML.DocumentElement.FirstChild;
  if Assigned(Child) then
  begin
    if Child.NodeName = 'url' then begin
      result:=Child.FirstChild.NodeValue; // Child.Attributes.GetNamedItem('replyId').NodeValue;
      ShowMessage('Отправленно в ЕГАИС!');
     end else
    begin
      ShowMessage('Ошибка:'+Child.FirstChild.NodeValue);
      flErrorEGAIS:=Child.FirstChild.NodeValue;
      result:='';
    end;
  end else begin
    ShowMessage('Ошибка:'+aStr);
    flErrorEGAIS:=aStr;
    end;

   // formStart.disconnectDB();
end;

function tformStart.readUTMinfo():boolean;
var
  str1:string;
begin
  result:=true;
  // ==== запрашиваем Стартовую страницу УТМ
  str1:=SaveToServerGET('','');
  if str1='' then
    begin
      result:=false;
      showmessage('Нет связи с УТМ!');
    end;
end;

function TFormStart.loadXmlProducer(aChild:TDOMNode; oref:String = 'oref'):String;
var
  ClientAddress,
  RegionCode,
  ClientINN,
  ClientKPP,
  ClientKodEgais,
  ClientName, str2,ShortName,
  Country:String;
  Child1,Child2:TDOMNode;
begin
  ClientAddress:='';
  RegionCode:='';
  ClientINN:='';
  ClientKPP:='';
  ClientKodEgais:='';
  ClientName:='';
  Country:='643';
  ShortName:='';
  while assigned(aChild) do begin
       if aChild.nodename = oref+':INN' then
         ClientINN:=AnsiToUTF8(aChild.FirstChild.NodeValue);
       if aChild.nodename = oref+':INN' then
         ClientKPP:=AnsiToUTF8(aChild.FirstChild.NodeValue);
       if aChild.nodename = oref+':ClientRegId' then
         ClientKodEgais:=aChild.FirstChild.NodeValue;
       if aChild.nodename = oref+':FullName' then
         ClientName:=replaceStr(AnsiToUTF8(aChild.FirstChild.NodeValue));
        if aChild.nodename = oref+':address' then begin
          Child1 := aChild.FirstChild;
          while assigned(Child1) do begin
             if Child1.nodename = oref+':Country' then
               Country:=AnsiToUTF8(Child1.FirstChild.NodeValue);
             if Child1.nodename = oref+':description' then
                if Assigned(Child1.FirstChild) then begin
                    str2:=Child1.FirstChild.NodeValue;
                    ClientAddress:=replaceStr(AnsiToUTF8(str2));
                  end;
              // ClientAddress:=AnsiToUTF8(Child1.FirstChild.NodeValue);
             if Child1.nodename = oref+':RegionCode' then
               RegionCode:=AnsiToUTF8(Child1.FirstChild.NodeValue);
             Child1 := Child1.NextSibling;
          end;

        end;
        aChild := aChild.NextSibling;
  end;
  result:=ClientKodEgais;
  UpdateProducer(ClientKodEgais,ClientName,ShortName,ClientINN,ClientKPP,ClientAddress,RegionCode,Country);
end;

function TFormStart.loadXmlProduct(aChild:TDOMNode; pref:String = 'pref'):String;
var
  ClientKodEgais,
  IClientKodEgais,
  flImport,
  AlcCode,
  AlcName,
  Capacity,
  AlcVolume,
  ProductVCode:String;
  Child1:TDOMNode;
begin
  AlcCode:='';
  flImport:='';
  AlcName:='';
  Capacity:='';
  AlcVolume:='';
  ProductVCode:='';
  ClientKodEgais:='';
  IClientKodEgais:='';
  while assigned(aChild) do begin
      if aChild.nodename = pref+':AlcCode' then
        AlcCode:=aChild.FirstChild.NodeValue;
      if aChild.nodename = pref+':FullName' then
        AlcName:=replaceStr(AnsiToUTF8(aChild.FirstChild.NodeValue));
      if aChild.nodename = pref+':Capacity' then
        Capacity:=aChild.FirstChild.NodeValue;
      if aChild.nodename = pref+':AlcVolume' then
        AlcVolume:=aChild.FirstChild.NodeValue;
      if aChild.nodename = pref+':ProductVCode' then
        ProductVCode:=aChild.FirstChild.NodeValue;
      if aChild.NodeName = pref+':Producer' then begin
        ClientKodEgais:=loadxmlProducer(aChild.FirstChild);
      end;
      if aChild.NodeName = pref+':Importer' then begin
        flImport:='1';
        IClientKodEgais:=loadxmlProducer(aChild.FirstChild);
      end;
      aChild := aChild.NextSibling;
  end;
  UpdateProduct(AlcCode,AlcName,Capacity,ProductVCode,AlcVolume,flImport,ClientKodEgais,IClientKodEgais);
end;

end.

