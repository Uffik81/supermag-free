{
 Разработчик исходного кода:Уфандеев Е.В.
 е-майл:uffik@mail.ru

}
unit unitStart;

{$mode objfpc}{$H+}
{ стартовое окно, для первоночальных настроек}
{
 предполагается что будет 3 варианта режима работ
   РМК режим подозревает что ПЛУ заводить будет УчСистема
 1. Простой режим с поддержкой егаис
 2. Супермаркет - поддержка Тачскрин
 3. Кафе/бар или ресторан
    поддержка множество столов
}

interface

uses
  Classes, SysUtils, sqldb, mysql50conn, FileUtil, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, PopupNotifier,  mysql50, DOM, XMLRead, unitcommon;

const
  CurVer = '1.0.8.115';
  ReportVer = '1.0.0.3';
  NameOEM = 'МАГАЗИН'; // РИТЕЙЛИКА
  NameApp = 'Универсальный кассовый модуль';
  S_HTTPServerUpdate = 'http://egais.retailika.ru';

// MessageBox(0,"Текст сообщения","Заголовок",MB_OK);
type
  { Организация в егаис }

  t_egais_producer = record
    egais_id:string;    // Код по егаис
    tax_id:string;      // ИНН
    deport_id:string;   // КПП
    importer:boolean;   // Импортер
    production:boolean; // Производитель
    sale:boolean;       // Оптовик
    firm_name:string;   // Наименование организации
  end;
  { Тип для фонового Обновления }

  { TThreadComPort }
  TShowStatusEvent = procedure(Status: string) of object;
  { TThreadUpdate }
  {: Класс фоновой загрузки данных }
  TThreadUpdate = class(TThread)   //Указываем имя
  private
    SockMySQL: PMYSQL;
    qmysql: st_mysql;
    FToStarting: boolean;
    exchip:string;
    exchport:string;
    results: string;          //Переменная в которой будут хранитя вычисления
    FOnShowStatus: TShowStatusEvent;
    {: функция проверяет есть ли данные для загрузки
     : если файловая загрузка то проверяем файл флаг
     : проверяет через облако загрузку файла}
    function StatusFlag:boolean;
    {: Функция загружает данные из файла или облака}
    function LoadData:string;
    procedure ShowResult;     //Процедура которая будем показывать результат
    function GetConstant(aName: string): string;
    procedure SetConstant(const aName, aValue: string);
    function ConnectDB(): boolean;
    procedure disconnectDB();
    function DB_query(const sSQL: string): PMYSQL_RES;
    function DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
    function SaveToServerPOST(const fparam, fstr: string): string;
    function SaveToServerGET(const fparam, fstr: string): string;

  protected
    FileStr: string;
    FileFlag: string;
    prefixDB:String;
    ActiveForm: TForm;

    procedure initComPort(aName: string);
    procedure Execute; override;//virtual; abstract;       //Основной код потока.
    procedure closecom;
  public

    property ToStarting: boolean read FToStarting;
    constructor Create(CreateSuspended: boolean);
    function ExchReport(const areport:string):boolean;
    property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
  end;


  { TFormStart }
  TFormStart = class(TForm)
    Image1: TImage;
    PopupNotifier1: TPopupNotifier;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Timer1: TTimer;
    TimerRests: TTimer;
    TrayIcon1: TTrayIcon;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure MySQL50Connection1Log(Sender: TSQLConnection;
      EventType: TDBEventType; const Msg: string);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerRestsTimer(Sender: TObject);

  private
    { private declarations }
    {Ссылка на сервер}
    _cloudserver:string;
    TLoadFS: TThreadUpdate;
    {Процедура выводит статус обновления товара}
    procedure TTUShowStatus(Status: string);
  public
    { public declarations }
    EgaisKod: string;
    FirmAddress: string;
    FirmINN: string;
    FirmKPP: string;
    FirmShortName, FirmFullName: string;
    FirmEmail: string;
    utmip: string;
    utmport: string;
    flFileConfig: string;
    pathDir: string;
    flPathSalesOpt: string; // путь к файлам импортирования документов реализация
    mysqlurl: string;
    mysqluser: string;
    mysqlpassword: string;
    flErrorEGAIS: string;
    // ==== viki print ======
    flVIKIPort:string;
    flVIKIBaud:integer;
    // ==== режимы работ ======
    flLoadProcuct: boolean;
    flOptMode: boolean;
    flAsAdmin: boolean;
    flRefreshEGAIS: boolean;
    flUpdateAdmin: boolean;
    flDocStatusEdit: boolean;
    flHideLog: boolean; // <<< Скрывать служебные сообщения автоматически
    flDateLic: string;
    flCurUserId: string; // <<< текущий пользователь
    // ===============
    prefixdb: string; // === Префикс БД ====
    curVersion: string;
    curVerReport: string; // === Версия отчетов ====
    prefixClient: string;

    // ========= автообновление =====
    stepLoad: integer;
    autoload: boolean;
    deltaautoload: integer;
    // ============
    SockMySQL: PMYSQL;
    qmysql: st_mysql;
    rowbuf: MYSQL_ROW;
    recbuf: PMYSQL_RES;
    flLowConnect: boolean;

    flDemoMode: boolean;
    fldisableutm: boolean;
    // === Режимы работ интерфейса ====
    flfullscreen: boolean;  // <<<< Запустить только кассу
    flSuperMarket: boolean;
    // <<<< если этот флаг стоит переключаем в режим тача и просим авторизацию
    flBBQMode: boolean;     // <<<< включает режим бара/ кафе -
    flMultiTable: boolean;  // <<<< позволяет режим управлять столами
    //flFullScreen:boolean;

    // === Только алкоголь ======
    flKKMSberbank: boolean;
    flRMKOffline: boolean;
    // <<<< Флаг режима радоты ПО как касса-оффлайн ( надо сопоставлять на лету) заполнять товар вручную
    flRMKFlagLoad: string;
    flRMKFileLoad: string;
    flRMKFolderLoad: string;
    flRMKFileReport: string;
    flRMKStarting: boolean;
    flLoadingGoods: boolean;

    flAutoEAN13: boolean;
    flSuffixBC: string; // >>>> спецсимвол для ШК
    flTypeLic:String; // флаг лицензии
    rmkFont: TFont;
    flkkmenabled: boolean;
    flSpUpdate: boolean;
    flCountSlip: integer;
    flRealtorurl: string;
    flRealtorName: string;
    sslog:tstringlist;
    // error procedure
    procedure MyExceptHandler(Sender: TObject; E: Exception);
    // ========================================
    function SaveToServerPOST(const fparam, fstr: string): string;
    function SaveToServerGET(const fparam, fstr: string): string;
    function SaveToServerDELETE(const fparam, fstr: string): string;
    function GetFSRARID(): string;
    function PathFile(): string;
    function LoadEGAISTovar(const inn: string): string;
    function LoadEGAISClient(const inn: string; utmv2: boolean = False): string;
    // ===== Работа с СУБД =====
    {Проверяет актуальность БД}
    procedure CreateBD(autodetect:boolean=true);
    {Подключаемся к Базе данных}
    function ConnectDB(): boolean;
    procedure disconnectDB();
    function DB_query(const sSQL: string; aTable:string=''): PMYSQL_RES;
    function DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
    function DB_checkTable(aTable: string): boolean;
    function DB_checkCol(aTable, aCol, aType, aSize: string; aDefault: string = ''): boolean;
    function SpFindOfCode(const aSpr, aCode: string): string;
    function DB_StrToDate(const aStrDate: string): TdateTime;
    // ======
    procedure loadFromFileTTN();
    procedure loadFromEGAISTTN(const aSTR: string; utmv2: boolean = False);
    procedure refreshEGAIS();
    procedure refreshEGAISReply();
    procedure refreshEGAISformB();
    procedure GetTTNfromEGAIS(const NumDoc, DocDate: string; utmv2: boolean = false);
    function loadFromEGAISFormB(const aSTR: string): boolean;
    procedure FromEGAISofActTTH(const numdoc, datedoc, docid: string;
      autmv2: string = '');  // Отправка акта
    procedure GetRetTTNfromEGAIS(const NumDoc, DocDate: string);   // Отправка акта
    procedure readOstatok();     // Запрос остатков главного склада
    procedure loadFromEGAISRests(const aStr: string);
    // Получаем остаток в основном складе
    procedure LoadEGAISsprProduct(const aStr: string);
    procedure LoadEGAISsprPartner(const aStr, uid: string);
    function XmlToStrDate(const aStr: string): string;
    function loadWayBillAct(const aStr: string): boolean;
    procedure LoadTicketEGAIS(const aStr, aUID: string);
    procedure loadReplyFormA(const aStr, aUID: string);
    procedure loadReplyFormB(const aStr, aUID: string);
    function DecodeEGAISPlomb(const aStr: string;
      var aAlcCode, aPart, aSerial: string): boolean;
    procedure LoadActInventoryInformBReg(const aStr, aUID: string);
    procedure LoadReplyNATTN(const aStr, aUID: string);
    procedure FromSaleActTTH(const numdoc, datedoc: string; isAccept: boolean);
    procedure refreshEGAISIn();
    // === Обработка очереди документов ====
    procedure SendStackEGAIS();
    // === Работа с константами
    procedure SetConstant(const aName, aValue: string);
    procedure SetConstBool(const aName: string; aValue: boolean);
    function GetConstant(aName: string): string;
    function GetConstBool(aName: string): boolean;
    procedure LoadQueryHistoryFormB(const aStr, aUID: string);
    procedure SendQueryHistoryFormB(const fbTTN: string);
    function GetAlcCodeFormB(const aFormB: string): string;
    procedure QueryFormA(const aFormA: string);
    function updateReport(): string;
    function GetEAN13rib(s_alccode: string): string;
    function SetEAN13rib(s_alccode, a_name: string; s_ean13: string): string;
    function controlena13(strBC: string): boolean;
    function StrToFloat(const strDouble: string): double;
    function Str1ToDate(const strDate: string): TDateTime;
    // ===== ver 2 =====================
    function SendQueryRestsShopv2(): boolean;
    function ActChargeOnShopv2(const numdoc, datedoc: string): boolean;
    // === отправляем оприходование в розницу в2
    procedure QueryAP_v2(const aAlcCode: string);
    procedure loadFromEGAISRestsShop_v2(const aStr: string);
    // Получить остаток торгового зала
    // =======================================
    { Генерирует УИД}
    function NewGUID(): string;
    function getXMLtoURL(const aStr: string; aShowMessage:boolean=true): string;
    // ==== обработка статуса документа =====
    function GetStatusDoc(aNumdoc,           // == Номер документа
      aDateDoc,          // == Дата документа
      aGUID,             // == Ид документа
      aType: string; var     // == вид документа ===
      IsActive,          // == Отправлен в ЕГАИС без ошибок
      IsDelete,          // == Помеч на удаление
      isEgaisOk          // == Принят ЕГАИС - ответ от егаис имеется
      : boolean): boolean; // результат true- документ найден, false - нет такого документа
    function SetStatusDoc(aNumdoc,           // == Номер документа
      aDateDoc,          // == Дата документа
      aGUID,             // == Ид документа
      aType: string;      // == вид документа ===
      IsActive,          // == Отправлен в ЕГАИС без ошибок
      IsDelete,          // == Помеч на удаление
      IsUserOk,          // == Подтверж КА
      isUserDivisive,    // == Акт разн
      isEgaisOk          // == Принят ЕГАИС - ответ от егаис имеется
      : boolean): boolean; // результат true- документ найден, false - нет такого документа
    function readUTMinfo(): boolean;
    function Setwaybillv2(): boolean;
    function UpdateProducer(
      const ClientKodEgais, ClientName, ShortName, ClientINN, ClientKPP,
      ClientAddress, RegionCode, Country: string; aTypeProducer:string='UL'): boolean;
    function UpdateProduct(const AlcCode, AlcName, Capacity, ProductVCode,
      AlcVolume, flImport, ClientKodEgais, iClientKodEgais: string;
      aflUpdate: boolean = False; aflUnpacked: boolean = False): boolean;
    function loadXmlProducer(aChild: TDOMNode; oref: string = 'oref';typeProd1:string='UL'): string;
    function loadXmlProduct(aChild: TDOMNode; pref: string = 'pref';
      aflUpdate: boolean = False): string;
    function GetXmlProducer(aRegId: string; oref: string = 'oref';
      beginregid: boolean = False; flutmv2: boolean = False): string;
    function GetBeginDoc(): string;
    function LoadQueryBarcode(const aStr, uid: string): boolean;
    // *************** Работа с РМК *****************
    function LoadShtrihMFile(const aStr: string): boolean;
    function SaveShtrihMFile(const aDate, adate1: TDateTime; rmkId:string=''): string;
    {: Запускается если касса не оффлайн.
    Выполняет автозаполнение ПЛУ и настройка параметров по умолчанию:
    Пользователь Admin
    Отображать виз подбор}
    procedure reGenerationPLU();
    {Перемещение остатков из основного склада в торг зал 17.10.2017}
    procedure AutotransferToShop;
    Function ControleFixMarkSale(aFixMark:string):boolean;
    procedure fshowmessage(const _str:string);
    {:Операции с сопоставлением товара}
    procedure SetAlcToBarCode(alcCode,barcode:string);
    function GetAlcCodeOfBarCode(BarCode:string):String; // Возвращает список алккодов , разделитель #13#10
    function GetBarCodeOfAlcCode(AlcCode:string):string; // Возвращает список ШтрихКодов, разделитель #13#10
    function GetAlcNameOfCode(alcCode:string):string;
    function get_product_to_fix_mark(fix_mark:string;var res:T_product):boolean;
    {Восстановление таблицы локальной базы
    В случае возникновении ошибок}
    procedure RecoveryTable(atable:string);
    function get_producer_id(inn:string;kpp:string):t_egais_producer;
    function send_tbot_message(message:string; error_text:string):boolean;
  end;




var
  FormStart: TFormStart;


function replaceStr(aStr: string; fl1: boolean = True): string;
function StringToHex(aStr: string): string;
function db_replaceStr(aStr: string; fl1: boolean = True): string;
function db_boolean(aStr: string): boolean;
function db_boolToStr(flag:boolean):string;
function db_string(aStr: string): string;

implementation

{$R *.lfm}
uses
  lazutf8,
  typinfo,
  winsock,
  sockets,opensslsockets,
  comobj,
  variants,
  LCLIntf,
  base64,
  fpjson,
  jsonparser,
  lconvencoding,
  INIFiles
  , unitJurnale
  , unitBuyTTH
  , lclproc
  , fphttpclient // Стандартная библиотека для http
  , zipper
  , unitInfo
  , unitlogging
  , unitResendDoc
  , unitSalesBeer
  , unitSalesBeerts
  , unitregclient
  , unitShowStatus
  , unituserloginv2
  , unitnews,
  unitspusers,
  unitspkass
  ,fwcore

  ;

const
  CRLF = #13#10;

{ TThreadComPort }

function TimeStampToMSecs(const TT:TTimeStamp):Longint;
begin
  //showmessage(inttostr(TT.Time));
  result:=TT.Time;
  try
     result := int64(TT.Time) + int64(TT.date)*msecsperday;
  except
     showmessage('Ощибка в DateStamp');
  end;

  //system.TimeStampToMSecs(TT);
  //result:=0;
end;

procedure TThreadUpdate.initComPort(aName: string);
begin
  results := '';
end;

function TThreadUpdate.StatusFlag: boolean;
begin
  exchip  :=GetConstant('HostExchMode');
  exchport:=GetConstant('PortExchMode');
  if db_boolean(GetConstant('LoadExchMode')) then
    result:=true
  else
    result:=FileExists(FileFlag);
end;

function TThreadUpdate.LoadData: string;
var
  sline: TStringList;

begin
  sLine := TStringList.Create;
  if not db_boolean(GetConstant('LoadExchMode')) then begin
    sLine.LoadFromFile(FileStr);
    result:=sLine.Text;

  end  else begin
    result:=SaveToServerGET('loadrest/?guid='+getconstant('guid'),'');
    if result<>'' then
      if pos('/>',result)<>0 then
        result:='';
  end;
  sLine.Free;
end;

procedure TThreadUpdate.ShowResult;
begin
  //  FormSalesbeer.refreshEGAIS();   // == Запускаем обновление в фоне ===
  //ActiveForm.;
  SetConstant('statusfoneupdate',results);
{  if Assigned(FOnShowStatus) then
  begin
    FOnShowStatus(results);
  end; }
  results := '';
end;

function TThreadUpdate.GetConstant(aName: string): string;
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  xrecbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`=''' + aName + ''';');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    Result := xrowbuf[0]
  else
    Result := '';
  mysql_free_result(xrecbuf);
end;

procedure TThreadUpdate.SetConstant(const aName, aValue: string);
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  xrecbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`=''' + aName + ''' ;');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    DB_Query('UPDATE `const` SET `value`=''' + aValue +
      ''' WHERE `name`=''' + aName + ''' AND `storepoint` = '''';')
  else
    DB_Query('INSERT INTO `const` (`name`,`value`,`storepoint`) VALUE (''' +
      aName + ''',''' + aValue + ''', '''');');
   mysql_free_result(xrecbuf);
end;

function TThreadUpdate.ConnectDB: boolean;
begin

  Result := False;
  try
    if SockMySQL = nil then
    begin
      SockMySQL := mysql_init(PMYSQL(@qmysql));
      SockMySQL := mysql_real_connect(SockMySQL, PChar(UTF8ToANSI(FormStart.mysqlurl)),
        PChar(UTF8TOANSI(FormStart.mysqluser)), PChar(FormStart.mysqlpassword), nil, 3306, nil, 0);
      if SockMySQL = nil then
      begin
        ShowMessage(' Не могу подключиться к базе данных:' + FormStart.mysqlurl);
        exit;
      end;

      if (mysql_query(sockMySQL, 'SET NAMES utf8;') < 0) then
      begin
        ShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
        exit;
      end;

      if (mysql_query(sockMySQL, PChar('SHOW DATABASES LIKE "egais' +
        prefixDB + '";')) < 0) then
      else
      begin
        if mysql_fetch_row(mysql_store_result(sockMySQL)) = nil then
        begin
          mysql_query(sockMySQL, PChar('CREATE DATABASE egais' + prefixDB +
            ' CHARACTER SET utf8 COLLATE utf8_general_ci ;'));
        end;
      end;
      if mysql_select_db(SockMySQL, PChar('egais' + prefixdb)) < 0 then
      begin
        ShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
        exit;
      end;
    end;
    if (mysql_ping(SockMySQL) < 0) then
    begin
      ShowMessage('Потеряно подключение:' + mysql_error(sockMySQL));
      exit;
    end
    else
    begin

    end;
    Result := True;
  except
    ShowMessage(' Не могу подключиться к БД:' + FormStart.mysqlurl);
  end;

end;

procedure TThreadUpdate.disconnectDB;
begin
  // if recbuf<>nil then
  //    mysql_free_result(recbuf);
  //  recbuf    :=nil;
  //  if not flLowConnect then begin
  if SockMySQL <> nil then
    mysql_close(sockMySQL);
  SockMySQL := nil;
  //  end;
end;

function TThreadUpdate.DB_query(const sSQL: string): PMYSQL_RES;
var
  errno: integer;
  errstr: string;
begin
  if sockMySQL = nil then
    ConnectDB()
  else
  begin
    if mysql_ping(sockMySQL) <> 0 then
    begin
      sockMySQL := nil;
      connectDB();
    end;

  end;

  if sockMySQL <> nil then
  begin
    if (mysql_query(sockMySQL, PChar(sSQL)) < 0) then
    begin
      errno := mysql_errno(sockMySQL);
      errstr := mysql_error(sockMySQL);
      ShowMessage('Ошибка СУБД [' + IntToStr(errno) + ']:' + errstr);
      DisconnectDB();
      Result := DB_query(sSQL);
    end
    else
      Result := mysql_store_result(sockMySQL);
  end
  else
    Result := nil;

end;

function TThreadUpdate.DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
begin
  if aRes = nil then
    Result := nil
  else
    Result := mysql_fetch_row(aRes);
end;

function TThreadUpdate.SaveToServerPOST(const fparam, fstr: string): string;
var
  scAddr: TinetSockAddr;
  sc: longint;
  Sin, Sout: Text;
  buff: string;
  sep, f_exit: string;
  lens1: string;
  IsBody: boolean;
  i: integer;
  f1: Text;
  len1: integer;
  getip: string;
  SLine: TStringList;
  S: TStringStream;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
  //==================
  Sss: string;
  SS: TStringStream;
  Ffff: TFileStream;
begin    // Format(AResponse.Contents.Text,  [HexText, AsciiText])
  //  if flDemomode  then begin
  //    result:='<?xml version="1.0" encoding="UTF-8" standalone="no"?><A><url>5abe96ef-aef0-4a6d-ac3f-3416f7159377</url><sign>AAE11382828AE8D1BE0E3CA0B6CB14FDBB2E470BC46D23D26B0B6F8C232B051879F2D354976362FD3DF456F184906CA99B38096F25E6979CE5367B97F7779AF0</sign><ver>2</ver></A>';
  //    exit;
  //  end;
  SLine := TStringList.Create;
  sLine.Text := fstr;
  //sLine.SaveToFile('client.xml');
  w := TFPHTTPClient.Create(nil);
  S := TStringStream.Create(fstr);
  try
    Sep := Format('-------------------------%.8x', [Random($ffffff)]);
    w.AddHeader('Content-Type', 'multipart/form-data; boundary=' + Sep);
    Sss := '--' + Sep + CRLF;
    sss := sss + Format('Content-Disposition: form-data; name="%s"; filename="%s"' +
      CRLF, ['xml_file', 'client.xml']);
    sss := sss + 'Content-Type: text/xml' + CRLF + CRLF;
    SS := TStringStream.Create(sss);
    try
      SS.Seek(0, soFromEnd);
      Sss := fstr + CRLF + '--' + Sep + '--' + CRLF;
      SS.WriteBuffer(Sss[1], Length(Sss));
      SS.Position := 0;
      w.RequestBody := SS;
      if exchport<>'' then
       w.Post('http://' + exchip + ':' + exchport + '/' + fparam, s)
      else
        w.Post('http://' + exchip  + '/' + fparam, s);
    finally
      w.RequestBody := nil;
      SS.Free;
    end;
    //    w.FileFormPost('http://'+utmip+':'+utmport+'/'+fparam,'xml_file','client.xml',s);
    //result:=w.Post('http://'+utmip+':'+utmport+'/'+fparam);
  except
    // === ошибка при подключении
    Result := '';
  end;
  Result := s.DataString;
  s.Free;
  w.Free;

  Sline.Free;

end;

function TThreadUpdate.SaveToServerGET(const fparam, fstr: string): string;
var
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  w := TFPHTTPClient.Create(nil);
  try
    if exchport<>'' then
      Result := w.get('http://' + exchip + ':' + exchport + '/' + fparam)
    else
      Result := w.get('http://' + exchip  + '/' + fparam);
  except
    // === ошибка при подключении
    Result := '';
  end;
  w.Free;

end;

procedure TThreadUpdate.Execute;
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
  sline: TStringList;
  strl1: TStringList;
  i: integer;
  // lf:TStringList;
  // i:integer;
  str1: string;
  ii, ij: integer;
  tmp1, name2, price1, alcgoods, plu1, name1, bc1, ves1, alccode: string;
  Query: string;
  lstalccode: array[0..20] of string;
  f_countprod: integer;
  f_section: string;
  flgFone: boolean;

  logl: TStringList;
begin
  logl := TStringList.Create;
  logl.Add('Стартуем!');
  logl.SaveToFile('threadlog.log');
  FToStarting := True;

  flgFone := db_boolean(GetConstant('LoadFoneGoods'));
  // Добавлена оптимизация по fldisableutm
  repeat
    f_section := '0';
    logl.Add('Проверяем флаг:' + FileFlag);
    logl.SaveToFile('threadlog.log');
    if StatusFlag then
    begin  // ===== Обновить автоматов ====  FormStart.flRMKOffline
      // ====
      results := 'Запустили обновление товара.';
      Synchronize(@ShowResult); //Выводим результат
      sleep(1);
      // ====
      sLine := TStringList.Create;
      strl1 := TStringList.Create;
      strl1.Clear;
      sLine.text:=LoadData;

      if sLine.Count > 3 then begin // +++++ Начало обработки документа +++++
          if sLine.Strings[1] = '#' then
          begin
            if (sLine.Strings[2]='$$$CLR')OR(pos(sLine.Strings[0],'$$$CLR')<>0) then
            begin
              query := 'UPDATE `sprgoods` SET `updating`="" ;';
              DB_query(Query);
            end;
            // === считаем что актуальный файл =====
            for i := 3 to sLine.Count - 1 do
            begin
              results := 'Загружено ' + IntToStr(sLine.Count) + ':' + IntToStr(i);
              Synchronize(@ShowResult); //Выводим результат
              sleep(2);
              strl1.Clear;
              str1 := sLine.Strings[i];
              if not (str1[1] in ['+', '*']) then begin
                ii := pos(';', str1);
                strl1.Text := '';
                while (ii > 0) and (str1 <> '') do
                begin
                  plu1 := copy(str1, 1, ii - 1);
                  str1 := copy(str1, ii + 1, length(str1));
                  ii := pos(';', str1);
                  strl1.add(plu1);
                end;
              end;
              logl.Add(':' + sLine.Strings[i]);
              logl.SaveToFile('threadlog.log');
              strl1.add(replaceStr(str1));
              if strl1.Count > 1 then
              begin
                if  strl1.Strings[0]<>'' then begin
                if (strl1.Strings[1] <> '') then begin
                  if (((strl1.Strings[0][1] = '#') or (strl1.Strings[0][1] = '@')) or (strl1.Strings[0][1] = '$')) then  begin
                    if strl1.Strings[0][2] <> '#' then  begin
                      plu1 := trim(copy(strl1.Strings[0], 2, length(strl1.Strings[0])));
                      bc1 := strl1.Strings[1];
                      name1 := CP1251toutf8(replaceStr(strl1.Strings[2]));
                      name2 := CP1251toutf8(replaceStr(strl1.Strings[3]));
                      price1 := strl1.Strings[4];
                      alccode := '';
                      alcgoods := '';
                      f_countprod := 0;
                      ves1 := '';
                      logl.Add('PLU:' + plu1);
                      logl.SaveToFile('threadlog.log');
                      //if strl1.Strings[7] = '1' then
                      //  ves1:='+';
                      f_section := '0';//strl1.Strings[8];
                      lstalccode[f_countprod] := '';
                      if not (ActiveForm as TFormStart).fldisableutm then
                      begin // ==== Оптимезация для обычного товара
                        xrecbuf :=
                          DB_query('SELECT `alccode`,(SELECT `name` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`doccash`.`alccode` LIMIT 1) AS `name`, `plu` FROM `doccash` WHERE `eanbc`="' + bc1 + '" AND `alccode`<>""   GROUP BY `alccode`;');
                        // == weightgood - весовой --- делимый. россыпь
                        xrowbuf := DB_Next(xrecbuf);
                        while xrowbuf <> nil do
                        begin
                          lstalccode[f_countprod] := xrowbuf[0];
                          alccode := xrowbuf[0];
                          name2 := db_replaceStr(xrowbuf[1]);
                          if length(alccode) > 15 then
                            alcgoods := '+';
                          f_countprod := f_countprod + 1;
                          lstalccode[f_countprod] := '';
                          xrowbuf := DB_Next(xrecbuf);
                        end;
                      end;
                      xrecbuf := DB_query('SELECT `section`,`weightgood` FROM `sprgoods` WHERE `plu`="'+plu1+'"   LIMIT 1;');
                      // == weightgood - весовой --- делимый. россыпь
                      xrowbuf := DB_Next(xrecbuf);
                      if xrowbuf <> nil then
                      begin
                        ves1 := xrowbuf[1];
                        f_section := xrowbuf[0];
                        if f_Section = '' then
                          f_section:='0';
                      end;
                      if not (ActiveForm as TFormStart).fldisableutm then
                      begin
                        xrecbuf :=
                          DB_query('SELECT `extcode`, `plu` FROM `sprgoods` WHERE `plu`="' +
                          plu1 + '" AND `alcgoods`="+"   LIMIT 1;');
                        xrowbuf := DB_Next(xrecbuf);
                        if xrowbuf <> nil then
                        begin
                          alcgoods := '+';
                        end;
                      end;
                      xrecbuf :=
                        DB_query('SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '" limit 1;');
                      xrowbuf := DB_Next(xrecbuf);
                      if xrowbuf = nil then begin
                        if f_countprod = 0 then begin
                          query := 'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' +
                            '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                          DB_query(Query);
                        end else
                          for ii := 0 to f_countprod - 1 do
                          begin
                            alcCode := lstalccode[ii];
                            query := 'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' +
                              '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                            DB_query(Query);
                          end;
                      end else begin
                        if f_countprod = 0 then
                        begin
                          xrecbuf := DB_query('SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '"    LIMIT 1;');
                          xrowbuf := DB_Next(xrecbuf);
                          if xrowbuf <> nil then
                          begin
                            if xrowbuf[3] <> '0' then
                              DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                price1 + ''',`name`=''' + name1 + ''',`extcode`=''' +
                                alccode + ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                                alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`=''' +
                                plu1 + ''' and `barcodes`=''' + bc1 + '''  ;')
                            else
                              DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                price1 + ''',`plu`=''' + plu1 + ''',`name`=''' + name1 +
                                ''',`extcode`=''' + alccode + ''',`fullname`=''' + name2 +
                                ''',`alcgoods`=''' + alcgoods + ''',`section`=''' + f_section +
                                ''',`updating`=''+''  WHERE `barcodes`=''' + bc1 + ''' ;');
                          end;
                        end
                        else
                        begin
                          for ii := 0 to f_countprod - 1 do
                          begin
                            alcCode := lstalccode[ii];
                            xrecbuf :=
                              DB_query('SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '"  AND ((`extcode`="")OR(`extcode`="' + alccode + '"))  LIMIT 1;');
                            xrowbuf := DB_Next(xrecbuf);
                            if xrowbuf <> nil then
                            begin
                              if xrowbuf[3] <> '0' then
                                DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                  price1 + ''',`name`=''' + name1 + ''',`extcode`=''' +
                                  alccode + ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                                  alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`="' +
                                  plu1 + '" and `barcodes`=''' + bc1 + ''' AND ((`extcode`='''')OR(`extcode`=''' +
                                  alccode + ''')) ;')
                              else
                                DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                  price1 + ''',`plu`=''' + plu1 + ''',`name`=''' + name1 +
                                  ''',`extcode`=''' + alccode + ''',`fullname`=''' + name2 +
                                  ''',`alcgoods`=''' + alcgoods + ''',`section`=''' + f_section +
                                  ''',`updating`=''+''  WHERE `barcodes`=''' + bc1 + ''' AND ((`extcode`='''')OR(`extcode`=''' +
                                  alccode + '''));');
                            end
                            else
                            begin
                              query := 'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                              DB_query(Query);
                            end;

                          end;
                        end;
                      end;
                    end;
                  end else begin // == Новая позиция товара

                    plu1 := trim(strl1.Strings[0]);
                    bc1 := strl1.Strings[1];
                    name1 := CP1251toutf8(replaceStr(strl1.Strings[2]));
                    name2 := CP1251toutf8(replaceStr(strl1.Strings[3]));
                    price1 := strl1.Strings[4];
                    ves1 := '';
                    alccode := '';
                    alcgoods := '';
                    f_countprod := 0;
                    logl.Add('new product PLU:' + plu1);
                    logl.SaveToFile('threadlog.log');
                    f_section := strl1.Strings[8];
                    lstalccode[f_countprod] := '';
                    if not (ActiveForm as TFormStart).fldisableutm then
                    begin
                      xrecbuf := DB_query(
                        'SELECT `alccode`,(SELECT `name` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`doccash`.`alccode` LIMIT 1) AS `name`, `plu` FROM `doccash` WHERE `eanbc`="' + bc1 + '" AND `alccode`<>"" GROUP BY `alccode`;');
                      // == weightgood - весовой --- делимый. россыпь
                      xrowbuf := DB_Next(xrecbuf);
                      while xrowbuf <> nil do
                      begin
                        if length(alccode) > 15 then
                          alcgoods := '+';
                        lstalccode[f_countprod] := xrowbuf[0];
                        alccode := xrowbuf[0];
                        name2 := db_replaceStr(utf8toAnsi(xrowbuf[1]));
                        f_countprod := f_countprod + 1;
                        xrowbuf := DB_Next(xrecbuf);
                        logl.Add('new product PLU:' + plu1+' alccode='+alccode);
                        logl.SaveToFile('threadlog.log');
                      end;
                    end;
                    if strl1.Count > 17 then
                    begin
                      if strl1.Strings[18] = '1' then
                        alcgoods := '+';
                    end
                    else
                    begin
                      if (strl1.Strings[10] = strl1.Strings[11]) and (strl1.Strings[10] <> '') and
                        (strl1.Strings[10] <> '0') then
                        alcgoods := '+';
                    end;
                    if strl1.Strings[7] = '1' then
                      ves1 := '+';
                    f_section := strl1.Strings[8];
                    // ====== barcode ======
                    if bc1 <> '' then
                    begin
                      logl.Add('new product PLU:' + plu1+' f_section='+f_section);
                      logl.SaveToFile('threadlog.log');
                      xrecbuf := DB_query(
                        'SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '"   LIMIT 1;');
                      xrowbuf := DB_Next(xrecbuf);
                      if xrowbuf = nil then
                      begin
                        if f_countprod = 0 then
                        begin
                          query :=
                            'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                          DB_query(Query);
                          logl.Add('new product insert PLU:' + plu1+' query='+query);
                          logl.SaveToFile('threadlog.log');
                        end
                        else
                          for ii := 0 to f_countprod - 1 do
                          begin
                            alcCode := lstalccode[ii];
                            query :=
                              'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                            DB_query(Query);
                            logl.Add('new product insert PLU:' + plu1+' query='+query);
                            logl.SaveToFile('threadlog.log');
                          end;
                      end
                      else
                      begin
                        if f_countprod = 0 then
                        begin
                          xrecbuf := DB_query(
                            'SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '"    LIMIT 1;');
                          xrowbuf := DB_Next(xrecbuf);
                          if xrowbuf <> nil then
                          begin
                            if xrowbuf[3] <> '0' then
                              DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                price1 + ''',`name`=''' + name1 + ''',`extcode`=''' +
                                alccode + ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                                alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`=''' +
                                plu1 + ''' and `barcodes`=''' + bc1 + '''  ;')
                            else
                              DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                price1 + ''',`plu`=''' + plu1 + ''',`name`=''' + name1 +
                                ''',`extcode`=''' + alccode + ''',`fullname`=''' + name2 +
                                ''',`alcgoods`=''' + alcgoods + ''',`section`=''' + f_section +
                                ''',`updating`=''+''  WHERE `barcodes`=''' + bc1 + ''' ;');
                          end;
                        end
                        else
                        begin

                          for ii := 0 to f_countprod - 1 do
                          begin
                            alcCode := lstalccode[ii];
                            xrecbuf := DB_query(
                              'SELECT `extcode`,`alcgoods`,(SELECT `ProductVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode`=`sprgoods`.`extcode` LIMIT 1) AS `ProductVCode`, `plu` FROM `sprgoods` WHERE `barcodes`="' + bc1 + '"  AND ((`extcode`="")OR(`extcode`="' + alccode + '"))  LIMIT 1;');
                            xrowbuf := DB_Next(xrecbuf);
                            if xrowbuf <> nil then
                            begin
                              if xrowbuf[3] <> '0' then
                                DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                  price1 + ''',`name`=''' + name1 + ''',`extcode`=''' +
                                  alccode + ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                                  alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`="' +
                                  plu1 + '" and `barcodes`=''' + bc1 + ''' AND ((`extcode`='''')OR(`extcode`=''' +
                                  alccode + ''')) ;')
                              else
                                DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                                  price1 + ''',`plu`=''' + plu1 + ''',`name`=''' + name1 +
                                  ''',`extcode`=''' + alccode + ''',`fullname`=''' + name2 +
                                  ''',`alcgoods`=''' + alcgoods + ''' ,`section`=''' + f_section +
                                  ''',`updating`=''+'' WHERE `barcodes`=''' + bc1 + ''' AND ((`extcode`='''')OR(`extcode`=''' +
                                  alccode + '''));');
                            end
                            else
                            begin
                              query :=
                                'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                              DB_query(Query);
                            end;

                          end;
                        end;
                      end;
                      // ==== barcode =====

                    end
                    else
                    begin
                      // === not barcode ====
                      xrecbuf := DB_query('SELECT `plu` FROM `sprgoods` WHERE `plu`="' +
                        plu1 + '"   LIMIT 1;');
                      xrowbuf := DB_Next(xrecbuf);
                      if xrowbuf = nil then
                      begin

                        query :=
                          'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                        DB_query(Query);

                      end
                      else
                      begin
                        DB_query('UPDATE `sprgoods` SET `currentprice`=''' +
                          price1 + ''',`name`=''' + name1 + ''',`extcode`=''' +
                          alccode + ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                          alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`=''' + plu1 + '''  ;');

                      end;

                    end;
                  end;
                end else begin   // ==== Весовой товар =====  Не имеет ШК == оперируем ШК  == Группа товара ===
                  if(strl1.Strings[0][1]<> '#') then begin
                  plu1 := trim(strl1.Strings[0]);
                  bc1 := strl1.Strings[1];
                  name1 := CP1251toutf8(replaceStr(strl1.Strings[2]));
                  name2 := CP1251toutf8(replaceStr(strl1.Strings[3]));
                  price1 := strl1.Strings[4];
                  ves1 := '';
                  alccode := '';
                  alcgoods := '';
                  f_countprod := 0;
                       logl.Add('PLU vesi:' + plu1);
                      logl.SaveToFile('threadlog.log');
                  f_section := strl1.Strings[8];
                  if strl1.Strings[7] = '1' then
                    ves1 := '+';
                  //f_section:=strl1.Strings[8];
                  // === not barcode ====
                  xrecbuf := DB_query('SELECT `plu` FROM `sprgoods` WHERE `plu`="'+plu1+'"   LIMIT 1;');
                  xrowbuf := DB_Next(xrecbuf);
                  if xrowbuf = nil then  begin
                    query := 'INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`,`section`) VALUES (' + '''' + plu1 + ''',''' + name1 + ''',''' + name2 + ''',''' + price1 + ''',''+'',''' + plu1 + ''',''' + trim(bc1) + ''',''' + trim(ves1) + ''',''' + alccode + ''',''' + alcgoods + ''',''' + f_section + ''');';
                    DB_query(Query);
                  end else begin
                    DB_query('UPDATE `sprgoods` SET `currentprice`=''' + price1 +
                      ''',`name`=''' + name1 + ''',`extcode`=''' + alccode +
                      ''',`fullname`=''' + name2 + ''',`alcgoods`=''' +
                      alcgoods + ''',`section`=''' + f_section + ''',`updating`=''+'' WHERE `plu`=''' + plu1 + '''  ;');
                  end;
                  // ======
                  end;
                end;
              end;
              // =======
              end;
            end;
          end;
        sLine.Strings[1] := '@';
      end; // ++++ Конец обработки +++++
      if not db_boolean(GetConstant('LoadExchMode')) then  begin
        sLine.SaveToFile(FileStr);
        DeleteFile(FileFlag);
      end;
      sLine.Free;

      results := 'Время:'+FormatDateTime('DD.MM.YYYY hh:mm', now());

      Synchronize(@ShowResult); //Выводим результат
      logl.SaveToFile('threadlog.log');
    end;
    query := 'DELETE FROM `sprgoods` WHERE `updating`="" ;';
    DB_query(Query);
    logl.Add('Ожидаем 30 сек');
    sleep(30000);
    logl.SaveToFile('threadlog.log');
  until Terminated; // ==== Останавливаем если прервана загрузка или закрыли программу
  logl.SaveToFile('threadlog.log');
  FToStarting := False;
  Terminate;

end;

procedure TThreadUpdate.closecom;
begin
end;

constructor TThreadUpdate.Create(CreateSuspended: boolean);
begin
  FToStarting := False;
  FileStr := '';
  FileFlag := '';
  Priority := tpLower;
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
end;

function TThreadUpdate.ExchReport(const areport: string): boolean;
begin
  SaveToServerPOST('savecash/?guid='+getconstant('guid'),areport);
end;

{TFormStart}

function TFormStart.get_producer_id(inn:string;kpp:string):t_egais_producer;
var
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  query:='SELECT `clientregid`,`inn`,`kpp`,`shortname` FROM `spproducer` WHERE `inn`="'+inn+'" AND `kpp`="'+kpp+'"; ';
  xrecbuf:=self.DB_Query(Query);
  xrowbuf:=self.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    result.egais_id:=xrowbuf[0];
    result.tax_id:=xrowbuf[1];
    result.deport_id:=xrowbuf[2];
  end else
    fshowmessage(Query);
end;

{Отправка сообщения через телеграм}

function TFormStart.send_tbot_message(message: string; error_text: string
  ): boolean;
var
  //rr:TReplaceFlags = rfReplaceAll;
   TheURL:string = 'https://api.telegram.org/bot603836756:AAHptkcTtMU1iBOV74xK8hoHWDzxudaesjs/sendMessage';
    Client: TFPHttpClient;
    Response : TStringStream;
    Params : string = '{"chat_id": -664035000,"text": "%%text%%","parse_mode":"HTML"}';    // -664035000   590795372
begin
    //TheURL:= 'https://api.telegram.org/bot'+'603836756:AAHptkcTtMU1iBOV74xK8hoHWDzxudaesjs'+'/sendMessage';
    Client := TFPHttpClient.Create(nil);
    Client.AddHeader('User-Agent','Mozilla/5.0 (compatible; fpweb)');
    Client.AddHeader('Content-Type','application/json; charset=UTF-8');
    Client.AddHeader('Accept', 'application/json');
    Client.AllowRedirect := true;
    //Client.UserName:=USER;
    //Client.Password:=PW;
    Params:=UTF8StringReplace(Params,'%%text%%',message,[rfReplaceAll]);
    client.RequestBody := TRawByteStringStream.Create(Params);
    Response := TStringStream.Create('');
    try
        try
            client.Post(TheURL, Response);
            error_text:='Response Code is ' + inttostr(Client.ResponseStatusCode);   // better be 200
        except on E:Exception do
            error_text:='Something bad happened : ' + E.Message;

        end;
    finally
        Client.RequestBody.Free;
        Client.Free;
        Response.Free;
    end;

end;

procedure TFormStart.RecoveryTable(atable:string);
begin
  case atable of
    'sprkass':begin
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
      //fshowmessage('Recovery table `sprkass`');
    end;
    'sprscale':begin
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
      //fshowmessage('Recovery table `sprscale`');
    end;
    'const':begin
      DB_checkCol('const','name','varchar(20)','');
      DB_checkCol('const','value','varchar(128)','');
      DB_checkCol('const','storepoint','varchar(32)','');
      //fshowmessage('Recovery table `const`');
      Application.ProcessMessages;
    end;
    'ticket':begin // `uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`
      DB_checkCol('ticket','dateDoc','DATE','');
      DB_checkCol('ticket','docid','varchar(48)','');
      DB_checkCol('ticket','uid','varchar(48)','');
      DB_checkCol('ticket','transportid','varchar(32)','');
      DB_checkCol('ticket','regid','varchar(20)','');
      DB_checkCol('ticket','type','varchar(20)','');
      DB_checkCol('ticket','accept','varchar(32)','');
      DB_checkCol('ticket','dateDoc','DATE','');
      DB_checkCol('ticket','numDoc','varchar(20)','');
      DB_checkCol('ticket','OperationResult','varchar(255)','');
      DB_checkCol('ticket','OperationName','varchar(64)','');
      DB_checkCol('ticket','comment','MEDIUMTEXT',''); // mysql_real_escape_string
      DB_checkCol('ticket','datestamp','TIMESTAMP','','DEFAULT CURRENT_TIMESTAMP');
      //fshowmessage('Recovery table `ticket`');
      Application.ProcessMessages;
    end;
    'doccash':begin
      DB_checkCol('doccash','regegais','varchar(1)','');

    end;
    'discountcards':begin
      DB_checkCol('discountcards','card','varchar(20)','');
      DB_checkCol('discountcards','crdate','DATE','');
      DB_checkCol('discountcards','discount','varchar(20)','');
      DB_checkCol('discountcards','name','varchar(20)','');
      DB_checkCol('discountcards','contacts','varchar(120)','');
      DB_checkCol('discountcards','isdelete','varchar(1)','');
    end;
  end;
end;

function TFormStart.GetStatusDoc(aNumdoc, aDateDoc, aGUID, aType: string;
  var IsActive, IsDelete, isEgaisOk: boolean): boolean;
var
  status1: string;
begin
  {
   комбинации:
    IsActive - был отправлен в егаис
    isEgaisOk - принят в егаис
    isDelete -
  }
  Result := False;
  rowbuf := DB_NEXT(DB_Query(
    'SELECT `status`,`isDelete` FROM `docjurnale` WHERE (`type`=''' +
    aType + ''')AND(`dateDoc`=''' + aDateDoc + ''')AND(`numdoc`=''' + aNumdoc + ''') LIMIT 1; '));
  if rowbuf <> nil then
  begin
    status1 := rowbuf[0];
    if rowbuf[1] = '+' then
      IsDelete := True
    else
      IsDelete := False;
    if status1[1] = '+' then
      IsActive := True
    else
      IsActive := False;
    if status1[3] = '+' then
      isEgaisOk := True
    else
      isEgaisOk := False;
    Result := True;
  end;
end;

function TFormStart.SetStatusDoc(aNumdoc, aDateDoc, aGUID, aType: string;
  IsActive, IsDelete, IsUserOk, isUserDivisive,
  isEgaisOk: boolean): boolean;
begin

end;






function ByteToAddr(const a1, a2, a3, a4: byte): longint;
var
  i: integer;
begin
  Result := HostToNet(((a1 shl 24) or (a2 shl 16)) or ((a3 shl 8) or a4));
end;

// Получем IP адрес....
function HostToIP(Name: string; var Ip: string): longint;
var
  wsdata: TWSAData;
  hostName: array [0..255] of AnsiChar;
  hostEnt: PHostEnt;
  addr: PAnsiChar;
begin
  WSAStartup($0101, wsdata);
  try
    gethostname(hostName, sizeof(hostName));
    StrPCopy(hostName, Name);
    hostEnt := gethostbyname(hostName);
    if Assigned(hostEnt) then
      if Assigned(hostEnt^.h_addr_list) then
      begin
        addr := hostEnt^.h_addr_list^;
        if Assigned(addr) then
        begin
          IP := Format('%d.%d.%d.%d', [byte(addr[0]), byte(addr[1]),
            byte(addr[2]), byte(addr[3])]);
          Result := ByteToAddr(byte(addr[0]), byte(addr[1]), byte(addr[2]), byte(addr[3]));
        end
        else
          Result := 0;
      end
      else
        Result := 0
    else
    begin
      Result := 0;
    end;
  finally
    WSACleanup;
  end;
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

function replaceStr(aStr: string; fl1: boolean = True): string;
  // mysql_real_escape_string
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(aStr) do
    case aStr[i] of
      '&': Result := Result + '&amp;';
      '''': Result := Result + '''''';
      '\': Result := Result + '\\';
      ':': Result := Result + '';
      '"': if fl1 then
          Result := Result + aStr[i]
        else
          Result := Result + '&quot;';
      else
        Result := Result + aStr[i];
    end;
end;

function db_replaceStr(aStr: string; fl1: boolean = True): string;
  // mysql_real_escape_string
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(aStr) do
    case aStr[i] of
      '&': Result := Result + '&amp;';
      '''': Result := Result + '\''';
      '\': Result := Result + '\\';
      // ':': result:=result+'';
      '"': if fl1 then
          Result := Result + aStr[i]
        else
          Result := Result + '&quot;';
      else
        Result := Result + aStr[i];
    end;
end;

function db_boolean(aStr: string): boolean;
var
  aStr1: string;
begin
  aStr1 := trim(aStr);
  Result := False;
  if (aStr1 = '1') or (aStr1 = '+') then
    Result := True;
end;

function db_boolToStr(flag: boolean): string;
begin
  if flag then
    result:='1'
    else
    result:='0';
end;

function db_string(aStr: string): string;
begin
  Result := '''' + aStr + '''';
end;

function StringToHex(aStr: string): string;
const
  HexChars: array[0..15] of char = '0123456789ABCDEF';

var
  i: integer;
begin
  Result := '';
  for i := 1 to length(aStr) do
  begin
    Result := Result + HexChars[(byte(aStr[I]) and $F0) shr 4] + HexChars[
      (byte(aStr[I]) and $0F)];
  end;

end;

procedure TFormStart.FormCreate(Sender: TObject);
var
  Fini: TIniFile;
  i: integer;
  sFile: string;

begin
  Application.OnException := @MyExceptHandler;



  sslog:=tstringlist.Create;
  TLoadFS := TThreadUpdate.Create(True);
  TLoadFS.OnShowStatus := @TTUShowStatus;
  TLoadFS.ActiveForm := self;
  DefaultFormatSettings.DecimalSeparator := '.';
  //  PathFile:=extractfilepath(paramstr(0));
  // ---- ИД Клиента ----
  EgaisKod := '0' + IntToStr(50 * 2) + '2544' + IntToStr(9156);
  //EgaisKod:='01'+'000000'+'2716';//'0'+inttoStr(50*2)+'2544'+IntToStr(9156);
  FirmINN := '';
  FirmKPP := '';
  FirmAddress := '';
  FirmFullName := '';
  FirmShortName := '';
  fldisableutm := False; // <<<
  flDemoMode := False;
  flSpUpdate := true;
  flRMKOffline := False; // <<< создание номенклатуры через учсистему
  flRMKStarting := False;
  flAutoEAN13 := False;
  flSuperMarket := False; // <<<< отключаем этот режим по умолчанию
  flMultiTable := False; // <<<< поддежка множество столов
  flBBQMode := False; // <<<< Режим Бара
  flFullScreen := False; // <<<< режим только РМК
  flVIKIPort:='COM4';
  flVIKIBaud:=57600;
  flFileConfig := 'egaismon.ini';
  // === ввели понятие - администратор БД default = false
  sFile := PathFile();
  flAsAdmin := False;
  FIni := TIniFile.Create(sFile + flFileConfig);
  pathDir := Fini.ReadString('GLOBAL', 'pathDir', '');
  mysqlurl := Fini.ReadString('GLOBAL', 'mysqlurl', '127.0.0.1');
  mysqluser := Fini.ReadString('GLOBAL', 'mysqluser', 'root');
  mysqlpassword := Fini.ReadString('GLOBAL', 'mysqlpassword', '');
  prefixdb := Fini.ReadString('GLOBAL', 'prefixdb', ''); //ИД базы данных для ЕГАИС
  _cloudserver := Fini.ReadString('GLOBAL', 'cloudserver', ''); //ИД базы данных для ЕГАИС
  curVersion := Fini.ReadString('GLOBAL', 'version', CurVer);
  curVerReport := Fini.ReadString('GLOBAL', 'reportversion', ReportVer);
  utmip := Fini.ReadString('GLOBAL', 'utmip', '127.0.0.1');
  utmport := Fini.ReadString('GLOBAL', 'utmport', '8080');
  FirmFullName := Fini.ReadString('GLOBAL', 'firmname', '');
  FirmShortName := Fini.ReadString('GLOBAL', 'firmShortname', FirmFullName);
  FirmINN := Fini.ReadString('GLOBAL', 'inn', '');
  Firmkpp := Fini.ReadString('GLOBAL', 'kpp', '');
  FirmAddress := Fini.ReadString('GLOBAL', 'address', '');
  autoload := Fini.ReadBool('GLOBAL', 'autoload', False);
  deltaautoload := Fini.ReadInteger('GLOBAL', 'refresh', 120);
  flOptMode := Fini.ReadBool('GLOBAL', 'OptMode', False);
  prefixClient := Fini.ReadString('GLOBAL', 'prefixClient', '1');
  flLowConnect := Fini.ReadBool('GLOBAL', 'LowConnect', False);
  flkkmenabled := Fini.ReadBool('GLOBAL', 'KKMEnabled', False);
  flDemoMode := Fini.ReadBool('GLOBAL', 'demomode', False);
  flHideLog := Fini.ReadBool('GLOBAL', 'hidelog', True);
  flRMKFolderLoad := Fini.ReadString('GLOBAL', 'rmkfolderload', '');
  flRMKFileLoad := Fini.ReadString('GLOBAL', 'rmkfileload', '');
  flRMKFlagLoad := Fini.ReadString('GLOBAL', 'rmkflagload', '');
  flRMKFileReport := Fini.ReadString('GLOBAL', 'rmkfilereport', '');
  flrmkoffline := Fini.ReadBool('GLOBAL', 'rmkoffline', False);
  flKKMSberbank := Fini.ReadBool('GLOBAL', 'kkmsberbank', False);
  flCountSlip := Fini.ReadInteger('GLOBAL', 'countslip', 2);
  Firmemail := Fini.ReadString('GLOBAL', 'email', '');
  flRealtorurl := Fini.ReadString('GLOBAL', 'realtorurl', '');
  flRealtorname := Fini.ReadString('GLOBAL', 'realtorname', '');
  fldisableutm := Fini.ReadBool('GLOBAL', 'disableutm', True);  // Надо будет явно включить УТМ
  flVIKIPort:= Fini.ReadString('GLOBAL', 'vikiport', 'COM4');
  flVIKIBaud:= Fini.ReadInteger('GLOBAL', 'vikibaud', 57600);
  //    flUpdateAdmin:=Fini.ReadBool('GLOBAL','adminupdate',false);
  timer1.Interval := 3000;
  Fini.Destroy;
  stepload := 1;  // первый шаг загрузки
  timer1.Enabled := True;
  Statictext1.Caption := 'Загрузка параметров....';
  flLoadProcuct := True;
  flAsAdmin := False;
  flUpdateAdmin := False;
  if pos('\\', pathDir) = -1 then
  begin
    if not DirectoryExists(Utf8ToAnsi(pathDir)) then
      mkdir(Utf8ToAnsi(pathDir));
    if not DirectoryExists(Utf8ToAnsi(pathDir + '\in')) then
    begin
      mkdir(Utf8ToAnsi(pathDir + '\in'));
      if not DirectoryExists(Utf8ToAnsi(pathDir + '\in\WayBill')) then
        mkdir(Utf8ToAnsi(pathDir + '\in\WayBill'));
    end;
    if not DirectoryExists(Utf8ToAnsi(pathDir + '\in\WayBill')) then
      mkdir(Utf8ToAnsi(pathDir + '\in\WayBill'));
    if not DirectoryExists(Utf8ToAnsi(pathDir + '\out')) then
      mkdir(Utf8ToAnsi(pathDir + '\out'));
    if not DirectoryExists(Utf8ToAnsi(sFile + 'docs')) then
      mkdir(Utf8ToAnsi(sFile + 'docs'));
  end;
  //    if CurVer<> curVersion then

{  if
    Application.Params[1];  }

  rmkFont := TFont.Create;
  rmkFont.CharSet := 16;
  rmkFont.Name := 'Courier New';
  TLoadFS.FileStr := utf8toAnsi(flRMKFolderLoad+'\' + flRMKFileLoad);
  TloadFS.FileFlag := utf8toAnsi(flRMKFolderLoad+'\' + flRMKFlagLoad);
  TLoadFS.prefixDB:=PrefixDB;
  flLoadingGoods := False;
  //TLoadFS.Resume;
end;

procedure TFormStart.FormDestroy(Sender: TObject);
begin
  TLoadFS.Terminate;
  inherited;
end;

procedure TFormStart.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  flLowConnect := False;
  disconnectDB();

end;

procedure TFormStart.FormShow(Sender: TObject);
var
    testfw:TFWCore;
begin
  //testfw:=TFWCore.Create();
  //testfw.PyExecuteScript('print(''Status loading script: OK!'')');

  TrayIcon1.Visible := True;

  GetDeviceId;
end;

procedure TFormStart.Image1Click(Sender: TObject);
begin

end;

procedure TFormStart.MySQL50Connection1Log(Sender: TSQLConnection;
  EventType: TDBEventType; const Msg: string);
begin

end;

procedure TFormStart.Timer1Timer(Sender: TObject);
var
  timest: TTimeStamp;
  MSec: comp;// === аналог int64 ====
  LastMSec: comp;
  fStr: TStringList;
  flag1: boolean;
  str1: string;
  //TLoadFS:TThreadUpdate;
  MFinSec, MAutoSec: comp;
  FS: TFormatSettings;
  StrTD: string;
begin
  timer1.Enabled := False;
  timest := DateTimeToTimeStamp(Now);

  MSec := TimeStampToMSecs(timest);
  MAutoSec := 0;
  MFinSec := 0;
  if GetConstant('TimeUpdateRest') <> '' then
  begin
    timest := DateTimeToTimeStamp(
      StrToDateTime(FormatDateTime('DD.MM.YYYY', now()) + ' ' + GetConstant('TimeUpdateRest')));
    MAutoSec := comp(TimeStampToMSecs(timest));
    if GetConstant('finupdaterest') <> '' then
    begin
      StrTD := GetConstant('finupdaterest');
      StrTD[pos('T', StrTD)] := ' ';
      StrTD := copy(StrTD, 1, 19);
      FS := DefaultFormatSettings;
      FS.DateSeparator := '-';
      FS.ShortDateFormat := 'yyyy-mm-dd';
      timest := DateTimeToTimeStamp(StrToDateTime(StrTD, FS));
      MFinSec := TimeStampToMSecs(timest);
    end;
  end;

  case stepload of
    1:
    begin
      // ---- Подключаемся к ДБ

      Statictext1.Caption := 'Подключение к БД....';
      if not ConnectDB() then
        ShowMessage(' Не могу подключиться к базе данных:' + mysqlurl);
      //  DisconnectDB();
      stepload := 2;
      //   formlogging.AddMessage('Подключение к БД','!');
      if firmINN = '' then
        firmINN := getConstant('firminn')
      else
        SetConstant('firminn', firmINN);
      timer1.Enabled := True;
    end;
    2:
    begin
      Statictext1.Caption := 'Настройка таблиц БД....';
      CreateBD();
      //   formlogging.AddMessage('Проверили целостность БД','!');
      if GetConstant('AdminUpdate') = '1' then
        flUpdateAdmin := True
      else
        flUpdateAdmin := False;

      if GetConstant('DocStatusEdit') = '1' then
        flDocStatusEdit := True
      else
        flDocStatusEdit := False;

      if GetConstant('installdb') = '' then
        SetConstant('installdb', FormatDateTime('DD-MM-YYYY HH:MM:SS', now()));

      stepload := 3;
      timer1.Enabled := True;
    end;
    3:
    begin
      Statictext1.Caption := 'Проверка лицензии ПО.';
      EgaisKod := GetFSRARID();

      Statictext2.Caption := 'Код ЕГАИС: ' + EgaisKod;
      //flLoadProcuct:=false;
      stepload := 4;
      formlogging.AddMessage('Проверка прошла успешно. Код ЕГАИС:' + EgaisKod, '!');
      //trayicon1.AnimateInterval:=;
      GetBeginDoc();
      formlogging.AddMessage('Проверяем доступные устройства', '!');
      if flSuperMarket or flfullscreen then begin
        formsalesbeerts.InitDevice;
        //formsalesbeerts.InitSection;
      end;
      if not flBBQMode then
        flBBQMode := db_boolean(GetConstant('enableresto'));
      flMultiTable := db_boolean(getConstant('enablemultitable'));
      // Выбор жедима с несколькими столами
      timer1.Enabled := True;
    end;
    4:
    begin
      timer1.Enabled := False;
      hide;
      if getconstant('shownews') = '' then
        setconstant('shownews', '1');
      if db_boolean(getconstant('shownews')) then
        formnews.Showmodal;
      //if not flrmkoffline then
      reGenerationPLU;
      if flSuperMarket or flfullscreen then
      else begin
        timerRests.Enabled:=true;
        FormJurnale.Show;
      end;
      //formUserLoginv2.showv2; // отобразить как главная заставка
      stepload := 5;
      timer1.Interval := deltaautoload * 1000;
      timer1.Enabled := autoload;
      if flSuperMarket or flfullscreen then
         formUserLoginv2.showv2
        else begin
         timerRests.Enabled:=true;
        end;
    end
    else
      if not formsalesbeerts.Visible then
      begin // == только в режиме управления
        //formjurnale.StatusBar1.Panels.Items[2].Text:='Обновление:'+FormatDateTime('DD-MM-YYYY HH:MM:SS',now());
        // === Если загружаем программу с автообменом ==
        if not FlDisableutm then
        begin
          loadFromFileTTN();
          //refreshEGAIS();
          SendStackEGAIS();
        end;
        // ==== Автозагрузка остатков ==========
        LastMSec := 0;
        if db_boolean(GetConstant('AutoUpdateRest' + prefixClient)) then
          //AND(GetConstant('LastUpdateRest') <> '') then
        begin

          if not db_boolean(GetConstant('flagUpdate')) then
          begin
            formjurnale.StatusBar1.Panels.Items[2].Text :=
              'Запущено автообновление:' + FormatDateTime('DD.MM.YYYY HH:MM:SS', now());
            if (GetConstant('LastUpdateRestShop') <> '') then
            begin
              LastMSec := StrToFloat(GetConstant('LastUpdateRestShop'));
            end
            else
            begin
              if (MFinSec <> 0) and (MAutoSec <> 0) then
              begin
                if (MFinSec < MSec) and (MSec > MAutoSec) then
                  readOstatok();
              end;
            end;
            if ((LastMSec + 60 * 15) < MSec) and (GetConstant('LastUpdateRestShop') <> '') then
            begin
              FormLogging.AddMessage('Запустили автозагрузку', '*');
              formjurnale.StatusBar1.Panels.Items[2].Text :=
                'Запущено автообновление:' + FormatDateTime('DD.MM.YYYY HH:MM:SS', now());
              refreshEGAIS();
            end
            else
            begin
              LastMSec := 0;
              if (GetConstant('LastUpdateRestDate') <> '') then
                LastMSec := StrTofloat(GetConstant('LastUpdateRestDate'));
              if ((LastMSec + 60 * 15) < MSec) and (GetConstant('LastUpdateRestDate') <> '') then
              begin
                FormLogging.AddMessage('Запустили автозагрузку', '*');
                formjurnale.StatusBar1.Panels.Items[2].Text :=
                  'Запущено автообновление остатков:' + FormatDateTime('DD.MM.YYYY HH:MM:SS', now());
                refreshEGAIS();
              end
              else
                refreshEGAIS();
            end;

          end
          else
          begin
            FormLogging.AddMessage('Обновление уже запущено', '!!!');
          end;

        end;
      end;
      // ==== автозагрузка данных ===
      if flRMKoffline then
      begin
        if flRMKFolderLoad[length(flRMKFolderLoad)] <> '\' then
          flRMKFolderLoad := flRMKFolderLoad + '\';
        if DirectoryExists(flRMKFolderLoad) then
        begin
          formsalesbeerts.stOnline.Caption := 'В СЕТИ';
          formUserLoginv2.stOnline.Caption := 'В СЕТИ';
          formsalesbeerts.stOnline.Font.Color := clgreen;
          formUserLoginv2.stOnline.Font.Color := clgreen;
          if FileExists(utf8toAnsi(flRMKFolderLoad + flRMKFlagLoad)) then
          begin
            str1 := GetConstant('LoadFoneGoods');
            flag1 := db_boolean(str1);
            if flag1 then
            begin
              if db_boolean(GetConstant('extexchenge')) then
                  TTUShowStatus(GetConstant('statusfoneupdate'))
               else begin
                if not TLoadFS.ToStarting then  begin
                     SetConstant('statusfoneupdate','Запущена фоновая загрузка');
                     TLoadFS.Start;
                     TTUShowStatus(GetConstant('statusfoneupdate'))  ;
                    end else  begin
                     TTUShowStatus(GetConstant('statusfoneupdate'))  ;
                    end;
               end;

            end
            else
            begin
              fStr := TStringList.Create;
              fStr.Clear;
              fStr.LoadFromFile(utf8toAnsi(flRMKFolderLoad + flRMKFileLoad));
              if LoadShtrihMFile(fstr.Text) then
              begin
                fStr.Strings[1] := '@';
                fStr.SaveToFile(utf8toAnsi(flRMKFolderLoad + flRMKFileLoad));
                DeleteFile(utf8toAnsi(flRMKFolderLoad + flRMKFlagLoad));
                fStr.Free;
              end;
            end;
          end else begin
            str1 := GetConstant('LoadFoneGoods');
            flag1 := db_boolean(str1);
            if flag1 then
            begin
              if db_boolean(GetConstant('extexchenge')) then
                  TTUShowStatus(GetConstant('statusfoneupdate'))
               else begin
                if not TLoadFS.ToStarting then  begin
                     SetConstant('statusfoneupdate','Запущена фоновая загрузка');
                     TLoadFS.Start;
                     TTUShowStatus(GetConstant('statusfoneupdate'))  ;
                    end else  begin
                     TTUShowStatus(GetConstant('statusfoneupdate'))  ;
                    end;
               end;

            end
            end;

        end
        else
        begin
          formUserLoginv2.stOnline.Caption := 'НЕТ СЕТИ';
          formUserLoginv2.stOnline.Font.Color := clRed;
          formsalesbeerts.stOnline.Caption := 'НЕТ СЕТИ';
          formsalesbeerts.stOnline.Font.Color := clRed;
        end;
      end;


      timer1.Enabled := True;
      // =============================================
  end;
  //timer1.Enabled:=true;
end;
{Отвечает за переодичность запроса остатков и получения документов. Период более часа}
procedure TFormStart.TimerRestsTimer(Sender: TObject);
begin

  if (not fldisableutm) then
    begin
     refreshEGAIS;
     ReadOstatok();
     if not flOptMode then
         SendQueryRestsShopv2;
    end;

end;

procedure TFormStart.MyExceptHandler(Sender: TObject; E: Exception);
begin
  sslog.Add(FormatDateTime('DD-MM-YY hh:mm',now())+':Error ['+E.ClassName+'] :'+E.Message);
  sslog.SaveToFile('messages.log');
  showmessage('Error:'+E.Message);
end;

procedure TFormStart.TTUShowStatus(Status: string);
begin
  if formSalesBeerTS.Visible then
    formSalesBeerTS.stLoadGoods.Caption := 'Фоновая загрузка:' + Status
  else
    formjurnale.StatusBar1.Panels.Items[2].Text := 'Фон:' + Status;

  Application.ProcessMessages;
end;

// w: TFPHTTPClient;  uses fphttpclient
function TFormStart.SaveToServerPOST(const fparam, fstr: string): string;
var
  scAddr: TinetSockAddr;
  sc: longint;
  Sin, Sout: Text;
  buff: string;
  sep, f_exit: string;
  lens1: string;
  IsBody: boolean;
  i: integer;
  f1: Text;
  len1: integer;
  getip: string;
  SLine: TStringList;
  S: TStringStream;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
  //==================
  Sss: string;
  SS: TStringStream;
  Ffff: TFileStream;
begin    // Format(AResponse.Contents.Text,  [HexText, AsciiText])
  //  if flDemomode  then begin
  //    result:='<?xml version="1.0" encoding="UTF-8" standalone="no"?><A><url>5abe96ef-aef0-4a6d-ac3f-3416f7159377</url><sign>AAE11382828AE8D1BE0E3CA0B6CB14FDBB2E470BC46D23D26B0B6F8C232B051879F2D354976362FD3DF456F184906CA99B38096F25E6979CE5367B97F7779AF0</sign><ver>2</ver></A>';
  //    exit;
  //  end;
  SLine := TStringList.Create;
  sLine.Text := fstr;
  sLine.SaveToFile('prepost.txt');
  //sLine.SaveToFile('client.xml');
  w := TFPHTTPClient.Create(nil);
  S := TStringStream.Create('');
  try
    Sep := Format('-------------------------%.8x', [Random($ffffff)]);
    w.AddHeader('Content-Type', 'multipart/form-data; boundary=' + Sep);
    Sss := '--' + Sep + CRLF;
    sss := sss + Format('Content-Disposition: form-data; name="%s"; filename="%s"' +
      CRLF, ['xml_file', 'client.xml']);
    sss := sss + 'Content-Type: text/xml' + CRLF + CRLF;
    SS := TStringStream.Create(sss);
    try
      SS.Seek(0, soFromEnd);
      Sss := fstr + CRLF + '--' + Sep + '--' + CRLF;
      SS.WriteBuffer(Sss[1], Length(Sss));
      SS.Position := 0;
      w.RequestBody := SS;
      w.Post('http://' + utmip + ':' + utmport + '/' + fparam,s);
    finally
      w.RequestBody := nil;
      SS.Free;
    end;
    //    w.FileFormPost('http://'+utmip+':'+utmport+'/'+fparam,'xml_file','client.xml',s);
    //result:=w.Post('http://'+utmip+':'+utmport+'/'+fparam);
  except
    // === ошибка при подключении
    Result := '';
    ShowMessage('нет доступа к интернет!');
  end;
  Result := s.DataString;
  s.Free;
  w.Free;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');

  SLine.Add(Result);
  SLine.SaveToFile(pathfile() + '\post.log');
  Sline.Free;

end;

function TFormStart.SaveToServerGET(const fparam, fstr: string): string;
var
  scAddr: TinetSockAddr;
  sc: longint;
  Sin, Sout: Text;
  buff: string;
  f_exit: string;
  getip, lens1: string;
  IsBody: boolean;
  i: integer;
  f1: Text;
  len1: integer;
  SLine: TStringList;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  w := TFPHTTPClient.Create(nil);
  try
    Result := w.get('http://' + utmip + ':' + utmport + '/' + fparam);
  except
    // === ошибка при подключении
    Result := '';
    ShowMessage('нет доступа к интернет!');
  end;
  SLine := TStringList.Create;
  SLine.Clear;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  SLine.Add(Result);
  SLine.SaveToFile(pathfile() + '\get.log');
  Sline.Free;
  w.Free;
end;

function TFormStart.SaveToServerDELETE(const fparam, fstr: string): string;
var
  SLine: TStringList;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  SLine := TStringList.Create;
  SLine.Clear;
  SLine.Add('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& IN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  Result := '';
  w := TFPHTTPClient.Create(nil);
  try
    Result := w.Delete('http://' + utmip + ':' + utmport + '/' + fparam);
  except
    // === ошибка при подключении
    Result := '';
    ShowMessage('нет доступа к интернет!');
  end;

  SLine.Add(Result);
  SLine.SaveToFile(pathfile() + '\getDelete.log');
  Sline.Free;
  w.Free;
end;

function TFormStart.GetFSRARID(): string;
var
  i: integer;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
  SLine: TStringList;
  ver: string;
  reg1: string;
  getret: string;
  CntError: integer;

  fluiddb:string;
  FLGErrInet:boolean;
begin
  {Переработать под json формат}
  flTypeLic:= self.getconstant('typelicense');
  Result  := self.GetConstant('ClientRegId');

  fluiddb:=getconstant('guid');
  if fluiddb='' then begin
    fluiddb:=NEWguid();
    setconstant('guid',fluiddb);
  end;
  if flTypeLic = '999' then begin
     result:=fluiddb;
  end;
end;

function TFormStart.PathFile(): string;
var
  param1: string;
  i: integer;
begin
  Result := extractfilepath(ParamStr(0));
  i := 1;
  param1 := ParamStr(1);
  while (param1 <> '') and (i < 10) do
  begin
    if UPCASE(param1) = '--BBQ' then
      flBBQMode := True;
    if UPCASE(param1) = '--RMK' then
      flfullscreen := True;
    if POS('--CONFIG=', UPCASE(param1)) <> 0 then
    begin
      flFileConfig := copy(param1, 10, length(param1));
    end;
    i := i + 1;
    param1 := ParamStr(i);
  end;

end;

// Запрос сведеней о товарах производителя
function TFormStart.LoadEGAISTovar(const inn: string): string;
var
  ind: integer;
  lastname: string;
  regid: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  WBRegID, S1: string;
  SLine: TStringList;
  Query: string;
begin
  // ==== получим сведения л производителе
  Result := '';

  SLine := TStringList.Create;
  SLine.Clear;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:QueryAP>');
  SLine.add('<qp:Parameters>');
  SLine.add('<qp:Parameter>');
  SLine.add('<qp:Name>ИНН</qp:Name>');
  SLine.add('<qp:Value>' + inn + '</qp:Value>');
  SLine.add('</qp:Parameter>');
  SLine.add('</qp:Parameters>');
  SLine.add('</ns:QueryAP>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  s1 := savetoserverpost('opt/in/QueryAP', Sline.Text);
  s1 := getXMLtoURL(s1);
  if s1 <> '' then
  begin
    query := 'SELECT fullname, clientregid  FROM `spproducer` WHERE `inn`="' + inn + '";';
    recbuf := DB_query(Query);
    if recbuf = nil then
      exit;
    rowbuf := DB_Next(recbuf);
    if rowbuf <> nil then
    begin
      fullname := rowbuf[0];
      regid := rowbuf[1];
    end;
    Query := 'INSERT INTO `docjurnale` (`uid`,`clientregid`,`numdoc`,`dateDoc`,`type`,`status`, `clientname`) VALUES ('''
      + s1 + ''',''' + regid + ''',''Запрос товара'',''' + FormatDateTime('yyyy-mm-dd', now()) +
      ''',''ReplyAP'',''---'',''' + fullname + ''');';
    DB_query(Query);
  end;
  SLine.Free;

end;

function TFormStart.LoadEGAISClient(const inn: string; utmv2: boolean = False): string;
var
  ind: integer;
  lastname: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  WBRegID, S1: string;
  SLine: TStringList;
  Query: string;
begin
  SLine := TStringList.Create;
  SLine.Clear;
  if utmv2 then
  begin
    SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
    SLine.add('<ns:Documents Version="1.0"            ');
    SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
    SLine.add(' xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
    SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters" ');
    SLine.add('> ');
    SLine.add('<ns:Owner> ');
    SLine.add(' <ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID> ');
    SLine.add(' </ns:Owner> ');
    SLine.add(' <ns:Document> ');
    SLine.add(' <ns:QueryClients_v2> ');
    SLine.add(' <qp:Parameters> ');
    SLine.add(' <qp:Parameter> ');
    SLine.add(' <qp:Name>СИО</qp:Name> ');
    SLine.add(' <qp:Value>' + inn + '</qp:Value> ');
    SLine.add(' </qp:Parameter> ');
    SLine.add(' </qp:Parameters> ');
    SLine.add(' </ns:QueryClients_v2> ');
    SLine.add(' </ns:Document> ');
    SLine.add('</ns:Documents>  ');
    s1 := SaveToServerPOST('opt/in/QueryClients_v2', SLine.Text);
  end
  else
  begin
    SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
    SLine.add('<ns:Documents Version="1.0"');
    SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
    SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
    SLine.add('<ns:Owner>');
    SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
    SLine.add('</ns:Owner>');
    SLine.add('<ns:Document>');
    SLine.add('<ns:QueryClients>');
    SLine.add('<qp:Parameters>');
    SLine.add('<qp:Parameter>');
    SLine.add('<qp:Name>ИНН</qp:Name>');
    SLine.add('<qp:Value>' + inn + '</qp:Value>');
    SLine.add('</qp:Parameter>');
    SLine.add('</qp:Parameters>');
    SLine.add('</ns:QueryClients>');
    SLine.add('</ns:Document>');
    SLine.add('</ns:Documents>');
    s1 := SaveToServerPOST('opt/in/QueryPartner', SLine.Text);
  end;
  s1 := getXMLtoUrl(s1);

  if s1 <> '' then
  begin
    Query := 'INSERT INTO `docjurnale` (`uid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'
      + s1 + '","Запрос Поставщиков","' + FormatDateTime('yyyy-mm-dd', now()) +
      '","ReplyPartner","---");';
    DB_Query(Query);
  end;
  SLine.Free;

end;



procedure TFormStart.loadFromFileTTN();
var
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  ii, i: integer;
  S1: string;
  fs: TSearchRec;
  dir: string;
  StrPrice: string;
  summaDoc: real;
  stopsearch: boolean;
  docNumber, DocDate, ClientKodEgais, ClientINN, ClientKPP, ClientAddress, ClientName: string;
  Query: string;
  strGUID: string;
  IDGUID: TGUID;
begin
  ConnectDB();
  dir := GetConstant('PathSalesOpt');//pathDir;
  if dir = '' then
    dir := pathDir;
  findfirst(dir + '\*.xml', faAnyFile, fs);
  repeat
    application.ProcessMessages;
    if (fs.Name = '')            //(fs.Name='') включать обязательно
      or (fs.Name = '.')         //если указатель на текущий каталог
      or (fs.Name = '..')       //если указатель на родительский каталог
    then
      continue;

    if ((fs.Attr and faDirectory) <> 0) then
      continue;      //если каталог,
    // Обрабатываем полученный файл
    formlogging.AddMessage('Загружаем Файл:' + ansitoutf8(fs.Name), '>');
    XML := nil;
    ReadXMLFile(XML, dir + '\' + fs.Name); // XML документ целиком
    Child := XML.DocumentElement.FirstChild;
    while Assigned(Child) do
    begin
      summaDoc := 0;
      if Child.NodeName = 'document' then
      begin
        DocNumber := AnsiToUtf8(Child.Attributes.GetNamedItem('number').NodeValue);
        DocDate := Child.Attributes.GetNamedItem('date').NodeValue;
        Query := 'SELECT * FROM `docjurnale` WHERE (datedoc="' + docDate +
          '")AND(numdoc="' + DocNumber + '") ;';
        recbuf := DB_Query(Query);
        rowbuf := DB_Next(recbuf);
        if rowbuf = nil then
        begin
          formlogging.AddMessage('Загружаем Накладную:' + DocNumber, '>');
          Child1 := Child.FirstChild;
          ClientKodEgais := Child1.Attributes.GetNamedItem('IdEgais').NodeValue;
          ClientINN := Child1.Attributes.GetNamedItem('inn').NodeValue;
          ClientKPP := Child1.Attributes.GetNamedItem('kpp').NodeValue;
          ClientAddress := AnsiToUtf8(Child1.Attributes.GetNamedItem(
            'address').NodeValue);
          ClientName := AnsiToUtf8(Child1.Attributes.GetNamedItem('name').NodeValue);
          S1 := Child1.nodename;
          Child1 := Child1.NextSibling;
          S1 := Child1.nodename;
          // ===================================
          if length(ClientKodEgais) < 10 then
          begin
            query := 'SELECT ClientRegId,description FROM `spproducer` WHERE (`inn`="' +
              ClientINN + '")AND(`kpp`="' + ClientKPP + '");';
            recbuf := DB_Query(Query);
            rowbuf := DB_Next(recbuf);
            if rowbuf <> nil then
            begin
              ClientKodEgais := rowbuf[0];
              ClientAddress := rowbuf[1];
            end
            else
            begin
              ShowMessage('Ошибка загрузки Реализации ' + DocNumber +
                ', не найден клиент с кодом:' + ClientKodEgais);
              exit;
            end;

          end;
          // ===== Проверяем был ли загружен ранее документ в бд
          Query := 'SELECT `numposit` FROM `doc211` WHERE `numdoc`="' +
            DocNumber + '" AND `datedoc`="' + DocDate + '";';
          if db_next(db_query(Query)) = nil then
          begin
            //====================================
            Child2 := Child1.FirstChild;
            i := 1;
            while Assigned(Child2) do
            begin

              Query :=
                'INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`) VALUES ' +
                '("' + DocNumber + '","' + DocDate + '","' + ClientKodEgais +
                '","' + ClientName + '",' + IntToStr(i) + ',"' + AnsiToUtf8(
                Child2.Attributes.GetNamedItem('name').NodeValue) + '","' +
                Child2.Attributes.GetNamedItem('barcode').NodeValue + '","' +
                Child2.Attributes.GetNamedItem('IdEgais').NodeValue +
                '",' + Child2.Attributes.GetNamedItem('count').NodeValue + ',' +
                Child2.Attributes.GetNamedItem('price').NodeValue +
                ',"' + Child2.Attributes.GetNamedItem('import').NodeValue + '");';
              StrPrice := Child2.Attributes.GetNamedItem('price').NodeValue;
              SummaDoc := SummaDoc +
                (StrToFloat(STRPrice) * StrToFloat(Child2.Attributes.GetNamedItem('count').NodeValue));
              DB_Query(Query);
              i := i + 1;
              Child2 := Child2.NextSibling;

            end;
          end
          else
          begin
            ShowMessage('Документ "' + DocNumber +
              '" был ранее загружен, возможно не полностью. Проверьте одержимое!');
          end;
          // == Добавляем документ в журнал ==


          Query :=
            'INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`status`,`summa`,`registry`,`type`,`docid`) VALUES '
            +
            ' ("' + DocNumber + '","' + DocDate + '","' + ClientKodEgais +
            '","' + ClientName + '","---",' + FloatToStr(SummaDoc) + ',"-","WayBill","");';

          DB_Query(Query);
          // ==================================

        end    // ============ Если документ уже есть =======
        else
        begin
          formlogging.AddMessage('Обновляем накладную:' + DocNumber, '>');
          Query := 'DELETE FROM `doc211` WHERE (datedoc="' + docDate +
            '")AND(numdoc="' + DocNumber + '");';
          DB_Query(Query);
          Child1 := Child.FirstChild;
          ClientKodEgais := Child1.Attributes.GetNamedItem('IdEgais').NodeValue;
          ClientINN := Child1.Attributes.GetNamedItem('inn').NodeValue;
          ClientKPP := Child1.Attributes.GetNamedItem('kpp').NodeValue;
          ClientAddress := AnsiToUtf8(Child1.Attributes.GetNamedItem(
            'address').NodeValue);
          ClientName := AnsiToUtf8(Child1.Attributes.GetNamedItem('name').NodeValue);
          S1 := Child1.nodename;
          Child1 := Child1.NextSibling;
          S1 := Child1.nodename;
          // ===================================
          if length(ClientKodEgais) < 10 then
          begin
            query := 'SELECT ClientRegId,description FROM `spproducer` WHERE (`inn`="' +
              ClientINN + '")AND(`kpp`="' + ClientKPP + '");';
            recbuf := DB_Query(Query);
            rowbuf := DB_Next(recbuf);
            if rowbuf <> nil then
            begin
              ClientKodEgais := rowbuf[0];
              ClientAddress := rowbuf[1];
            end
            else
            begin
              ShowMessage('Ошибка загрузки Реализации ' + DocNumber +
                ', не найден клиент с кодом:' + ClientKodEgais);
              exit;
            end;
          end;
          Query := 'UPDATE `docjurnale` SET `clientregid`="' +
            ClientKodEgais + '",`summa`=' + FloatToStr(SummaDoc) + ',`ClientName`="' + ClientName + '" WHERE ' +
            ' `numdoc`="' + DocNumber + '" AND `datedoc`="' + DocDate + '";';
          DB_Query(Query);

          //====================================
          Child2 := Child1.FirstChild;
          i := 1;
          while Assigned(Child2) do
          begin

            Query :=
              'INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`) VALUES'
              + '("' + DocNumber + '","' + DocDate + '","' + ClientKodEgais +
              '","' + ClientName + '",' + IntToStr(i) + ',"' + AnsiToUtf8(
              Child2.Attributes.GetNamedItem('name').NodeValue) + '","' +
              Child2.Attributes.GetNamedItem('barcode').NodeValue + '","' +
              Child2.Attributes.GetNamedItem('IdEgais').NodeValue +
              '",' + Child2.Attributes.GetNamedItem('count').NodeValue + ',' +
              Child2.Attributes.GetNamedItem('price').NodeValue +
              ',"' + Child2.Attributes.GetNamedItem('import').NodeValue + '");';
            StrPrice := Child2.Attributes.GetNamedItem('price').NodeValue;
            SummaDoc := SummaDoc +
              (StrToFloat(STRPrice) * StrToFloat(Child2.Attributes.GetNamedItem('count').NodeValue));
            DB_Query(Query);
            i := i + 1;
            Child2 := Child2.NextSibling;

          end;
          Query := 'UPDATE `docjurnale` SET `clientregid`="' +
            ClientKodEgais + '",`summa`=' + FloatToStr(SummaDoc) + ',`ClientName`="' + ClientName + '" WHERE ' +
            ' `numdoc`="' + DocNumber + '" AND `datedoc`="' + DocDate + '";';
          DB_Query(Query);
        end;
      end;
      Child := Child.NextSibling;
    end;
    // ====== конец обработки ======
    DeleteFile(dir + '\' + fs.Name);
  until findnext(fs) <> 0;
  findclose(fs);

end;


procedure TFormStart.GetTTNfromEGAIS(const NumDoc, DocDate: string; utmv2: boolean = False);

var
  ind: integer;
  lastname: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  dir, S1: string;
  S2: string;
  SLine: TStringList;
  ID: TGUID;
  strGUID, Query: string;
  ver2UTM: boolean;
  url1: string;
begin
  ver2UTM := utmv2;
  if getConstant('utmversion') = '2' then
    ver2utm := True;
  strGUID := '';
  if CreateGuid(ID) = S_OK then
  begin
    strGUID := GUIDToString(ID);
    s1 := '';
    //  убираем фигурные скобки
    for i := 2 to length(strGuid) - 1 do
      s1 := s1 + strGuid[i];
    strGuid := s1;
  end;

  SLine := TStringList.Create;
  SLine.Clear;
 { SLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  SLine.Add(' <ns:Documents Version="1.0"');
  SLine.Add('            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('            xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('            xmlns:c="http://fsrar.ru/WEGAIS/Common"');

  if ver2utm then
  begin
    SLine.Add('            xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2"');
    SLine.Add('            xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2" ');
    SLine.Add('            xmlns:wb= "http://fsrar.ru/WEGAIS/TTNSingle_v2"> ');

  end
  else
  begin
    SLine.Add('            xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"');
    SLine.Add('            xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" ');
    SLine.Add('            xmlns:wb= "http://fsrar.ru/WEGAIS/TTNSingle"> ');
  end; }
  SLine.Add('<ns:Documents Version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" xmlns:c="http://fsrar.ru/WEGAIS/Common" xmlns:ce="http://fsrar.ru/WEGAIS/CommonV3" xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2" xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2" xmlns:wb="http://fsrar.ru/WEGAIS/TTNSingle_v3">');
  SLine.Add('<ns:Owner>');
  SLine.Add(' <ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add(' <ns:Document>');
  SLine.Add('  <ns:WayBill_v3>') ;

  SLine.Add('  <wb:Identity>' + strGUID + '</wb:Identity>');
  SLine.Add('<wb:Header>');

  SLine.Add('<wb:Type>WBInvoiceFromMe</wb:Type>');
  SLine.Add('<wb:NUMBER>' + NumDoc + '</wb:NUMBER>');
  SLine.Add('<wb:Date>' + DocDate + '</wb:Date>');
  SLine.Add('<wb:ShippingDate>' + DocDate + '</wb:ShippingDate> ');
  // Прописываем транспорт
  SLine.Add('<wb:Transport>');
  SLine.Add('</wb:Transport>');
  // Отправитель ------
  SLine.Add('<wb:Shipper >');
  SLine.Add(GetXmlProducer(EgaisKod, 'oref', True, ver2utm));
  SLine.Add('</wb:Shipper>');
  // получатель ------
  Query :=
    'SELECT `spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`fullname`,`spproducer`.`region`,`spproducer`.`description`  FROM `doc211`,`spproducer`  WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + docdate + '")AND' + '(`spproducer`.`ClientRegId`=`doc211`.`ClientRegId`);';

  rowbuf := DB_Next(DB_Query(Query));
  if rowbuf <> nil then
  begin

    SLine.Add('<wb:Consignee >');
    SLine.Add(GetXmlProducer(rowbuf[2], 'oref', False, ver2utm));
    SLine.Add('</wb:Consignee>');
    SLine.Add('</wb:Header>');
    // Товар для ттн
    SLine.Add('<wb:Content >');
  end
  else
  begin
    ShowMessage('Не найден Клиент!!!! Отправить не возможно!!!');
    Exit;
  end;

  Query :=
    'SELECT `spproduct`.`egaisname`,`doc21`.`alcitem`,`spproduct`.`Capacity`,`spproduct`.`AlcVolume`,`spproduct`.`ProductVCode`,'
    +
    '`spproduct`.`ClientRegId`,`doc21`.`valuetov`,' +
    '`doc21`.`Price`,`doc21`.`forma`,`doc21`.`formb`,`spproduct`.`import`,`spproduct`.`unpacked`  FROM `doc21`,`spproduct` WHERE (`doc21`.`numdoc`="' + NumDoc + '")AND(`doc21`.`datedoc`="' + docdate + '")' + 'AND(`spproduct`.`AlcCode`=`doc21`.`alcitem`);';

  recbuf := DB_Query(Query);
  rowbuf := DB_Next(recbuf);
  ind := 1;
  while rowbuf <> nil do
  begin
    SLine.Add(' <wb:Position >');
    SLine.Add(' <wb:Identity>' + IntToStr(ind) + '</wb:Identity>');
    SLine.Add('  <wb:Product >');

    SLine.Add('    <pref:Type>АП</pref:Type>');
    SLine.Add('      <pref:FullName>' + ReplaceSTR(rowbuf[0]) + '</pref:FullName>  ');
    SLine.Add('      <pref:ShortName>' + UTF8Copy(ReplaceSTR(rowbuf[0]), 1, 64) +
      '</pref:ShortName>     ');
    SLine.Add('      <pref:AlcCode>' + rowbuf[1] +
      '</pref:AlcCode>                                 ');
    SLine.Add('      <pref:Capacity>' + rowbuf[2] + '</pref:Capacity>           ');
    SLine.Add('      <pref:AlcVolume>' + rowbuf[3] + '</pref:AlcVolume>        ');
    SLine.Add('      <pref:ProductVCode>' + rowbuf[4] + '</pref:ProductVCode>     ');
    if db_boolean(rowbuf[11]) then
        SLine.Add('      <pref:UnitType>Unpacked</pref:UnitType>')
      else
        SLine.Add('      <pref:UnitType>Packed</pref:UnitType>');
    SLine.Add('      <pref:Producer >                               ');
    SLine.Add(GetXmlProducer(rowbuf[5], 'oref', False, ver2utm));
    SLine.Add('      </pref:Producer>                               ');
    SLine.Add('   </wb:Product>                                        ');
    SLine.Add('   <wb:Quantity>' + rowbuf[6] + '</wb:Quantity>                     ');
    SLine.Add('   <wb:Price>' + rowbuf[7] + '</wb:Price>                     ');
      SLine.Add(' <wb:FARegId>' + rowbuf[8] + '</wb:FARegId>                ');
      SLine.Add('  <wb:InformF2 >                                         ');
      SLine.Add('       <ce:F2RegId>' + rowbuf[9] + '</ce:F2RegId>');
     SLine.Add('  </wb:InformF2>');
     SLine.Add('  </wb:Position>');
    ind := ind + 1;
    rowbuf := DB_Next(recbuf);
  end;

  SLine.Add('   </wb:Content>');

    SLine.Add('</ns:WayBill_v3>');

  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
  //  form1.Edit1.Text := '/opt/in/WayBill' ;
  SLine.SaveToFile(pathfile() + '\logPOSTTTH.txt');
  SLine.Text := SaveToServerPOST('opt/in/WayBill_v4', SLine.Text);

  url1 := SLine.Text;
  url1 := getXMLtoURL(url1);
  if url1 <> '' then
  begin
    //ShowMessage('Документ отправлен в ЕГАИС!');
    Query := 'UPDATE `docjurnale`   SET uid="' + url1 + '", sign="' + s1 +
      '", docid="' + strGUID + '", ClientAccept="" ' +
      'WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + docdate + '");';
    DB_query(Query);
    Query := 'INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUES ("' +
      url1 + '","' + NumDoc + '","' + docdate + '");';
    DB_query(Query);
  end
  else
  begin
    // "0--" -
    Query := 'UPDATE `docjurnale`   SET uid="' + strGUID + '", status="0--", docid="' +
      strGUID + '", ClientAccept="" ' + 'WHERE (`numdoc`="' +
      NumDoc + '")AND(`datedoc`="' + docdate + '");';
    DB_query(Query);
    Query :=
      'INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES' + ' ('''','''','''','''',''Rejected'',''' + flErrorEGAIS + ''',''WayBill'',''WayBill'',''WayBill'',''' + numdoc + ''',''' + docdate + ''');';
    DB_query(Query);

  end;
  //  DisconnectDB();

end;

procedure TFormStart.GetRetTTNfromEGAIS(const NumDoc, DocDate: string);

var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  ind: integer;
  lastname: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  dir, S1: string;
  S2: string;
  SLine: TStringList;
  ID: TGUID;
  ver2utm : boolean;
  strGUID, Query: string;
begin
  ver2utm := True;
  strGUID := '';
  if CreateGuid(ID) = S_OK then
  begin
    strGUID := GUIDToString(ID);
    s1 := '';
    //  убираем фигурные скобки
    for i := 2 to length(strGuid) - 1 do
      s1 := s1 + strGuid[i];
    strGuid := s1;
  end;

  SLine := TStringList.Create;
  SLine.Clear;
  SLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  SLine.Add(' <ns:Documents Version="1.0"');
  SLine.Add('            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('            xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('            xmlns:c="http://fsrar.ru/WEGAIS/Common"   xmlns:ce="http://fsrar.ru/WEGAIS/CommonV3"');
  SLine.Add('            xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2"');
  SLine.Add('            xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2" ');
  SLine.Add('            xmlns:wb="http://fsrar.ru/WEGAIS/TTNSingle_v4"> ');
  SLine.Add('<ns:Owner>');
  SLine.Add(' <ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add(' <ns:Document>');
  SLine.Add('  <ns:WayBill_v4>');
  SLine.Add('  <wb:Identity>' + strGUID + '</wb:Identity>');
  SLine.Add('<wb:Header>');
  SLine.Add('<wb:NUMBER>' + NumDoc + '</wb:NUMBER>');
  SLine.Add('<wb:Date>' + DocDate + '</wb:Date>');
  SLine.Add('<wb:ShippingDate>' + DocDate + '</wb:ShippingDate> ');
  SLine.Add('<wb:Type>WBReturnFromMe</wb:Type>'); // === Тип возврат

  // Отправитель ------
  SLine.Add('<wb:Shipper >');
  SLine.Add(GetXmlProducer(EgaisKod, 'oref', True, ver2utm));
  SLine.Add('</wb:Shipper>');
  // Прописываем транспорт

  Query :=
    'SELECT `spproducer`.`ClientRegId`  FROM `docjurnale`,`spproducer`  WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + docdate + '")AND' + '(`spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`);';
  xrowbuf := DB_Next(DB_Query(Query));
  if xrowbuf = nil then begin
    ShowMessage('Не найден Клиент!!!! Отправить не возможно!!!');
    Exit;
  end;
  SLine.Add('<wb:Consignee >');
  SLine.Add(GetXmlProducer(xrowbuf[0], 'oref', False, ver2utm));
  SLine.Add('</wb:Consignee>');
  //SLine.Add('<wb:Transport>');
  //SLine.Add('</wb:Transport>');
  SLine.Add('<wb:Note>Пересорт</wb:Note>');
  SLine.Add('</wb:Header>');

    // Товар для ттн
  SLine.Add('<wb:Content >');
  Query := //         0                    1                    2                       3                      4                       5                    6                         7                          8                    9                    10           11                 12             13              14                     15                      16
    'SELECT `spproduct`.`egaisname`,`doc24`.`alccode`,`spproduct`.`Capacity`,`spproduct`.`AlcVolume`,`spproduct`.`ProductVCode`,`spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`ClientRegId`,`spproducer`.`FullName`,`spproducer`.`description`,`doc24`.`count`,`doc24`.`Price`,`doc24`.`forma`,`doc24`.`formb`,`spproducer`.`Country`,`spproduct`.`import`,`spproduct`.`unpacked`  FROM `doc24`,`spproduct`,`spproducer` WHERE (`doc24`.`numdoc`="' + NumDoc + '")AND(`doc24`.`datedoc`="' + docdate + '")' + 'AND(`spproduct`.`AlcCode`=`doc24`.`alccode`)AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`);';

  xrecbuf := DB_query(Query);
  xrowbuf := DB_Next(xrecbuf);
  ind := 1;
  while xrowbuf <> nil do
  begin
    SLine.Add(' <wb:Position >');
    SLine.Add(' <wb:Identity>' + IntToStr(ind) + '</wb:Identity>');
    SLine.Add('  <wb:Product >');
    // --- Позиция ----
    SLine.Add('    <pref:Type>АП</pref:Type>');
    SLine.Add('      <pref:FullName>' + ReplaceSTR(xrowbuf[0]) + '</pref:FullName>  ');
    SLine.Add('      <pref:ShortName>' + UTF8Copy(ReplaceSTR(xrowbuf[0]), 1, 64) +'</pref:ShortName>     ');
    SLine.Add('      <pref:AlcCode>' + xrowbuf[1] +'</pref:AlcCode> ');
    SLine.Add('      <pref:Capacity>' + xrowbuf[2] + '</pref:Capacity>           ');
    SLine.Add('      <pref:AlcVolume>' + xrowbuf[3] + '</pref:AlcVolume>        ');
    SLine.Add('      <pref:ProductVCode>' + xrowbuf[4] + '</pref:ProductVCode>     ');
    // --- тара ---
    if db_boolean(xrowbuf[16]) then
        SLine.Add('      <pref:UnitType>Unpacked</pref:UnitType>')
      else
        SLine.Add('      <pref:UnitType>Packed</pref:UnitType>');
    // -- производитель --
    SLine.Add('      <pref:Producer >  ');
    SLine.Add(GetXmlProducer(xrowbuf[7], 'oref', False, ver2utm));
    SLine.Add('      </pref:Producer>  ');
    SLine.Add('   </wb:Product> ');
    SLine.Add('   <wb:Quantity>' + xrowbuf[10] + '</wb:Quantity>                     ');
    SLine.Add('   <wb:Price>' + xrowbuf[11] + '</wb:Price>                     ');
    SLine.Add(' <wb:FARegId>' + xrowbuf[12] + '</wb:FARegId>                ');

    SLine.Add('  <wb:InformF2 >                                         ');
    SLine.Add('       <ce:F2RegId>' + xrowbuf[13] + '</ce:F2RegId>');
   SLine.Add('  </wb:InformF2>');
    SLine.Add('  </wb:Position>');
    ind := ind + 1;
    xrowbuf := DB_Next(xrecbuf);
  end;

  SLine.Add('   </wb:Content>');
  SLine.Add('</ns:WayBill_v4>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
  //  form1.Edit1.Text := '/opt/in/WayBill' ;
  SLine.SaveToFile(pathfile() + '\logPOSTretTTH.txt');

  SLine.Text := SaveToServerPOST('opt/in/WayBill_v4', SLine.Text);
  if SLine.Count < 1 then
      begin
            SLine.SaveToFile(pathfile() + '\logGetTTH.txt');
            exit;
      end;
  s1 := '';
  S := TStringStream.Create(SLine.Text);
  try
    S.Position := 0;
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
    // Альтернативно:
    //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  finally
    S.Free;
  end;
  ShowMessage('Документ отправлен в ЕГАИС!');
  Child := XML.DocumentElement.FirstChild;
  i := 1;
  if Assigned(Child) then
  begin
    if Child.NodeName <> 'url' then
    begin
      // "0--" -
      Query := 'UPDATE `docjurnale`   SET uid="' + Child.FirstChild.NodeValue +
        '", status="0--", docid="' + strGUID + '", ClientAccept="" ' +
        'WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + docdate + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
      Query :=
        'INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES' + ' ('''','''','''','''',''Rejected'',''' + Child.NodeValue + ''',''WayBill'',''WayBill'',''WayBill'',''' + numdoc + ''',''' + docdate + ''');';
      DB_query(Query);

    end
    else
    begin
      s1 := Child.NextSibling.FirstChild.NodeValue;
      Delete(s1, pos(#10, s1), 1);
      Query := 'UPDATE `docjurnale`   SET uid="' + Child.FirstChild.NodeValue +
        '", sign="' + s1 + '", docid="' + strGUID + '", ClientAccept="" ' +
        'WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + docdate + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
      Query := 'INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("' +
        Child.FirstChild.NodeValue + '","' + NumDoc + '","' + docdate + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
    end;
  end;
  //  DisconnectDB();

end;

// Акт подтверждения ТТН
{
procedure TFormStart.FromEGAISofActTTH(const numdoc, datedoc, docid: String; autmv2:boolean=false);
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
  StrCurDate:String;
  VerUTM:string;
  verForm:string;
  verQ:string;
  flutmv2:boolean;
begin
 flutmv2:=autmv2;
 if GetConstant('utmversion') = '2' then
   flutmv2:=true;
 VerUTM:='WayBillAct';
 verForm:='InformBRegId';
 verQ:='RealQuantity';
 if flutmv2 then begin
   VerUTM:='WayBillAct_v2';
   verForm:='InformF2RegId';
   verQ:='RealQuantity';
 end;
 StrCurdate:=FormatDateTime('YYYY-MM-DD',now());
  flAccept:='Accepted';
  strNote:='Приниаем продукцию';
  Query:= 'SELECT `WBRegID`,`utmv2`  FROM `docjurnale` WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND(`docid`="'+docid+'");';
  recbuf := DB_Query(Query);
  rowbuf := DB_Next(recbuf);
 if rowbuf=nil then
    exit;
 WBRegID:= rowbuf[0];
 if db_boolean(rowbuf[1]) then begin
   VerUTM:='WayBillAct_v2';
   verForm:='InformF2RegId';
   verQ:='RealQuantity';
 end;

 if WBRegID='' then begin
  exit;
 end;
 // =============== Собираем расхождение =================
 flSub:=false;
 SLine1:= TStringList.Create;
 sLine1.clear;
 flAcceptedAct:=false;
 Query:='SELECT `doc221`.`count`,`doc221`.`factcount`,`docformab`.`formB`,`doc221`.`numposit` FROM `doc221`,`docformab`'+
 ' WHERE (`doc221`.`datedoc`="'+datedoc+'")AND(`doc221`.`numdoc`="'+NumDoc+'")AND(`doc221`.`docid`="'+docid+'") AND(`docformab`.`docid`=`doc221`.`docid`) AND(`docformab`.`numposition`=`doc221`.`numposit` );'; // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")

 recbuf := DB_Query(Query);
 rowbuf := DB_Next(recbuf);
 i:=0;
 while rowbuf<>nil do begin
     if StrToFloat(rowbuf[1]) < StrToFloat(rowbuf[0])  then
       i:=1;
      sLine1.Add('<wa:Position>');
      sLine1.Add('<wa:Identity>'+rowbuf[3]+'</wa:Identity> ');
      sLine1.Add('<wa:'+verForm+'>'+rowbuf[2]+'</wa:'+verForm+'>');
      sLine1.Add('<wa:'+verQ+'>'+rowbuf[1]+'</wa:'+verQ+'>');
      sLine1.Add('</wa:Position>');
      flSub:=true;
    if StrToFloat(rowbuf[1])<>0 then
      flAcceptedAct:=true;
    rowbuf := DB_Next(recbuf);
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
 if flutmv2 then
   SLine.Add('xmlns:wa= "http://fsrar.ru/WEGAIS/ActTTNSingle_v2"')
 else
   SLine.Add('xmlns:wa= "http://fsrar.ru/WEGAIS/ActTTNSingle"');
 SLine.Add('>');
 SLine.Add('<ns:Owner>');
 SLine.Add('<ns:FSRAR_ID>'+EgaisKod+'</ns:FSRAR_ID>');
 SLine.Add('</ns:Owner>');
 SLine.Add('<ns:Document>');

 SLine.Add('<ns:'+VerUTM+'>');

 SLine.Add('<wa:Header>');
 SLine.Add('<wa:IsAccept>'+flAccept+'</wa:IsAccept>');
 SLine.Add('<wa:ACTNUMBER>'+numdoc+'</wa:ACTNUMBER>');
 SLine.Add('<wa:ActDate>'+StrCurdate+'</wa:ActDate>');
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
 SLine.Add('</ns:'+VerUTM+'>');
 SLine.Add('</ns:Document>');
 SLine.Add('</ns:Documents>');
 SLine.SaveToFile(pathFile()+'\logPOSTAct.log');
 S1:= SaveToServerPOST('opt/in/'+VerUTM,SLine.text);
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
}

procedure TFormStart.readOstatok();
var
  ind: integer;
  lastname: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  WBRegID, S1: string;
  SLine: TStringList;
  Query: string;
  MSec: comp;
  timest: TTimeStamp;
begin
  timest := DateTimeToTimeStamp(Now());
  MSec := TimeStampToMSecs(timest);
  SLine := TStringList.Create;
  Sline.Clear;
  SLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.Add('<ns:Documents Version="1.0"');
  SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
  SLine.Add('<ns:Owner>');
  SLine.Add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add('<ns:Document>');
  SLine.Add('<ns:QueryRests></ns:QueryRests>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
  SLine.Text := SaveToServerPOST('opt/in/QueryRests', SLine.Text);
  SLine.SaveToFile(pathFile() + '\logGetAct.log');
  s1 := '';
  S := TStringStream.Create(SLine.Text);
  try
    S.Position := 0;
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
    // Альтернативно:
    //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  finally
    S.Free;
  end;
  Child := XML.DocumentElement.FirstChild;
  i := 1;
  if Assigned(Child) then
  begin
    if Child.NodeName <> 'url' then
      exit;
    s1 := Child.FirstChild.NodeValue;
    SetConstant('lastupdateRests', s1);
    //       DisconnectDB();
    setConstant('LastUpdateRestDate', FloattoStr(mSec));
  end;

end;




procedure TFormStart.LoadEGAISsprProduct(const aStr: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child7, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  str2, S1: string;
  S: TStringStream;
  sz: integer;
  dir: string;
  Query, StrPrice: string;
  summaDoc: real;
  stopsearch: boolean;
  WBRegId, EGAISFixNumber, EGAISFixDate, RegionCode, iRegionCode, ICountry,
  DocType, IdDoc, iDPosition, Capacity, AlcVolume, ProductVCode, price,
  alccode, alcname, egaisAlcName, iClientKodEgais, iClientINN, iClientKPP,
  iClientAddress, iClientName, ShortName, iShortName, Country,
  docNumber, DocDate, ClientKodEgais, ClientINN, ClientKPP, ClientAddress, ClientName: string;
  flNew: boolean;
  flImport: string;
  flUpdateProd: boolean;
begin
  flUpdateProd := True;
  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  flNew := True;
  summaDoc := 0;
  iShortName := '';
  ShortName := '';
  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) and flNew do
      begin

        // ==== Заголовок документа =====
        if (Child1.NodeName = 'ns:ReplyAP') or (Child1.NodeName = 'ns:ReplyAP_v2') then
        begin
          Child3 := child1.FirstChild;
          while Assigned(Child3) do
          begin
            // ====== Содержимое документа ======

            if Child3.NodeName = 'rap:Products' then
            begin
              child4 := Child3.FirstChild;
              while assigned(Child4) do
              begin
                if Child4.NodeName = 'rap:Product' then
                begin
                  flImport := '0';
                  child5 := Child4.FirstChild;
                  ClientKodEgais := '';
                  ClientINN := '';
                  ClientKPP := '';
                  loadXmlProduct(child4.FirstChild);

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

procedure TFormStart.LoadEGAISsprPartner(const aStr, uid: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  S: TStringStream;
  dir: string;
  StrPrice: string;
  summaDoc: real;
  stopsearch: boolean;
  WBRegId, EGAISFixNumber, EGAISFixDate, ClientRegId, RegionCode,
  DocType, IdDoc, iDPosition, ShortName, description, ProductVCode,
  docNumber, DocDate, ClientKodEgais, ClientINN, ClientKPP, ClientAddress, ClientName: string;
  flNew: boolean;
  Query: string;
begin
  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  flNew := True;
  summaDoc := 0;
  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) and flNew do
      begin

        // ==== Заголовок документа =====
        if Child1.NodeName = 'ns:ReplyClient' then
        begin
          Child3 := child1.FirstChild;
          while Assigned(Child3) do
          begin
            // ====== Содержимое документа ======

            if Child3.NodeName = 'rc:Clients' then
            begin
              child4 := Child3.FirstChild;
              while assigned(Child4) do
              begin
                if Child4.NodeName = 'rc:Client' then
                begin
                  child5 := Child4.FirstChild;
                  while assigned(child5) do
                  begin
                    if child5.nodename = 'oref:ClientRegId' then
                      ClientKodEgais := Child5.FirstChild.NodeValue;
                    if child5.nodename = 'oref:FullName' then
                      ClientName :=
                        replaceStr(AnsiToUTF8(Child5.FirstChild.NodeValue));
                    if child5.NodeName = 'oref:ShortName' then
                    begin
                      if assigned(Child5.FirstChild) then
                        ShortName :=
                          replaceStr(AnsiToUTF8(Child5.FirstChild.NodeValue))
                      else
                        ShortName := '';
                    end;
                    if child5.NodeName = 'oref:INN' then
                    begin
                      ClientINN := child5.FirstChild.NodeValue;
                    end;
                    if child5.NodeName = 'oref:KPP' then
                    begin
                      ClientKPP := child5.FirstChild.NodeValue;
                    end;
                    if child5.NodeName = 'oref:address' then
                    begin
                      child6 := child5.FirstChild;
                      while assigned(child6) do
                      begin
                        if child6.nodename = 'oref:RegionCode' then
                          RegionCode := Child6.FirstChild.NodeValue;
                        if child6.nodename = 'oref:description' then
                          description :=
                            replaceStr(AnsiToUTF8(Child6.FirstChild.NodeValue));
                        child6 := child6.NextSibling;
                      end;
                    end;
                    Child5 := Child5.NextSibling;
                  end;

                  if not formStart.ConnectDB() then
                    exit;
                  Query :=
                    'UPDATE `docjurnale` SET `clientname`=''' + ShortName + ''' WHERE (`uid` LIKE ''' +
                    uid + ''')AND(`type`=''ReplyPartner'');';
                  DB_Query(Query);
                  if UpdateProducer(
                    ClientKodEgais, ClientName, ShortName, ClientINN, ClientKPP, description,
                    RegionCode, '643') then
                    formlogging.AddMessage('Добавлен:' + ClientName, '')
                  else
                    formlogging.AddMessage('Ошибка:' + ClientName, '!!!');
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

function TFormStart.XmlToStrDate(const aStr: string): string;
begin
  if Length(aStr) = 10 then
    Result := aStr[9] + aStr[10] + '.' + aStr[6] + aStr[7] + '.' + aStr[1] + aStr[2] + aStr[3] + aStr[4]
  else
    Result := aStr;
end;

{
<ns:Documents Version="1.0"><ns:Owner><ns:FSRAR_ID>020000288921</ns:FSRAR_ID></ns:Owner><ns:Document><ns:WayBillAct><wa:Header><wa:IsAccept>Accepted</wa:IsAccept><wa:ACTNUMBER>РНу0077831</wa:ACTNUMBER><wa:ActDate>2015-11-25</wa:ActDate><wa:WBRegId>TEST-TTN-0000176937</wa:WBRegId><wa:Note>Приниаем продукцию</wa:Note></wa:Header><wa:Content>
</wa:Content></ns:WayBillAct></ns:Document></ns:Documents>
}
{function TFormStart.loadWayBillAct(const aStr: String): boolean;
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

             Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`) VALUES'+
                 '('''+WBRegId+''','''+ActNum+''','''+WBRegId+''','''+WBRegId+''','''+Accepted+''','''+Comments+''','''+DocType+''');';
             DB_Query(Query);
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
end;    }

procedure TFormStart.LoadTicketEGAIS(const aStr, aUID: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  S: TStringStream;
  dir: string;
  StrPrice: string;
  summaDoc: real;
  stopsearch: boolean;
  numdoc, datedoc, iddoc, DocID, RegID, OperationResult, Comments,
  OperationName, Accepted, TransportId, DocType: string;
  flNew: boolean;
  Query: string;
  st1: string;
begin

  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  flNew := True;
  summaDoc := 0;
  DocID := '';
  RegID := '';

  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) do
      begin  // ns:Ticket
        if Child1.NodeName = 'ns:Ticket' then
        begin
          Child2 := child1.FirstChild;  // tc:DocType tc:DocId
          while Assigned(Child2) do
          begin
            if Child2.NodeName = 'tc:DocType' then
            begin
              DocType := Child2.FirstChild.NodeValue;
            end;             // tc:RegID
            if Child2.NodeName = 'tc:DocID' then
            begin
              if Assigned(Child2.FirstChild) then
                DocID := Child2.FirstChild.NodeValue;
            end;
            if Child2.NodeName = 'tc:RegID' then
            begin
              if Assigned(Child2.FirstChild) then
                RegID := Child2.FirstChild.NodeValue;
            end;
            if Child2.NodeName = 'tc:TransportId' then
            begin
              TransportId := Child2.FirstChild.NodeValue;
            end;
            if Child2.NodeName = 'tc:Result' then
            begin
              OperationName := '';
              OperationResult := 'Result';
              Child3 := Child2.FirstChild;
              while Assigned(Child3) do
              begin  // tc:Conclusion
                if Child3.NodeName = 'tc:Conclusion' then
                begin
                  Accepted := Child3.FirstChild.NodeValue;
                end;
                if Child3.NodeName = 'tc:Comments' then
                begin
                  Comments := ANSITOUTF8(replaceStr(Child3.FirstChild.NodeValue));
                end;
                Child3 := Child3.NextSibling;
              end;
            end;                      //OperationResult
            if Child2.NodeName = 'tc:OperationResult' then
            begin
              OperationResult := 'OperationResult';
              Child3 := Child2.FirstChild;
              while Assigned(Child3) do
              begin  // tc:Conclusion
                if Child3.NodeName = 'tc:OperationResult' then
                begin
                  Accepted := Child3.FirstChild.NodeValue;
                end;
                if Child3.NodeName = 'tc:OperationComment' then
                begin
                  Comments := AnsiToUTF8(replaceStr(Child3.FirstChild.NodeValue));
                end;
                if Child3.NodeName = 'tc:OperationName' then
                begin
                  OperationName := Child3.FirstChild.NodeValue;
                end;
                Child3 := Child3.NextSibling;
              end;
            end;                      //OperationResult

            Child2 := Child2.NextSibling;
          end;
          // ================== Обработать статусы по тикетам ======================
          // ====== Вносим в журнал ===========
          Query := 'SELECT `numdoc` , `datedoc` , `docid` FROM `docjurnale` WHERE (`WBRegId`='''
            + RegID + ''')OR(`uid`=''' + auid + ''');';
          recbuf := DB_query(Query);
          rowbuf := DB_Next(recBuf);
          if rowbuf <> nil then
          begin
            numdoc := rowbuf[0];
            datedoc := rowbuf[1];
            iddoc := rowbuf[2];
          end
          else
          begin
            numdoc := '';
            datedoc := '0000-00-00';
            iddoc := '';
          end;

          Query :=
            'INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES' + ' (''' + auid + ''',''' + DocID + ''',''' + RegID + ''',''' + TransportId + ''',''' + Accepted + ''',''' + Comments + ''',''' + DocType + ''',''' + OperationResult + ''',''' + OperationName + ''',''' + datedoc + ''',''' + numdoc + ''');';
          DB_query(Query);

          if DocType = 'WAYBILL' then
          begin

            if Accepted = 'Rejected' then
              st1 := '++1'
            else
              st1 := '+++';
            if numdoc <> '' then
              Query := 'UPDATE `docjurnale` SET `status`=''' + st1 +
                ''' WHERE (`WBRegId`=''' + RegID + ''')OR(`uid`=''' + auid + ''');'
            else
              Query := 'INSERT INTO `docjurnale` (`docid`, `status`,`WBRegId`,`uid`,`type`) VALUE ('''
                + auid + ''',''' + st1 + ''',''' + RegID + ''',''' + auid + ''',''' + doctype + ''');';
            DB_query(Query);
          end
          else
          begin
            if Accepted = 'Rejected' then
              st1 := '0--'
            else
            begin
              Query := 'UPDATE `docjurnale` SET `WBRegID`=''' + RegID +
                ''' WHERE (`uid`=''' + auid + ''');';
              DB_query(Query);
              st1 := '+++';
            end;
            Query := 'UPDATE `docjurnale` SET `status`=''' + st1 +
              ''' WHERE (`uid`=''' + auid + ''');';
            DB_query(Query);
          end;

        end;
        Child1 := Child1.NextSibling;
      end;

    end;
    Child := Child.NextSibling;
  end;

end;

function TFormStart.DecodeEGAISPlomb(const aStr: string;
  var aAlcCode, aPart, aSerial: string): boolean;

var
  aCh: char;
  HiNum: word;
  num1: byte;
  aRes: string;
  aDev, aNum1, aNum2: string;
  i: integer;
  r: double;
  res1: array[0..20] of byte;
  ii: integer;
  r2, r1: word;
  idp: integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  HiNum := 0;
  aPart := '';
  aSerial := '';
  Result := True;
  aAlcCode := '';
  if length(aStr)=150 then begin
     xrecbuf:= DB_query('SELECT `alccode` FROM `doc221fix` WHERE `fixmark`="'+aStr+'" LIMIT 1;');
     xrowbuf:= DB_Next(xrecbuf);
     if xrowbuf<>nil then begin
        aAlcCode:=  xrowbuf[0];
     end;

     exit;
  end;

  idp := pos('22N', aStr);
  if idp <> 0 then
    idp := idp - 1;
  adev := aStr[1] + aStr[2];
  aNum1 := aStr[3] + aStr[4] + aStr[5] + aStr[6];
  anum2 := '';
  for ii := 0 to 20 do
    res1[ii] := 0;
  r := 1;
  for i := 0 to 12 do
  begin
    aNum2 := aNum2 + aStr[i + 7 + idp];
    aCh := aStr[i + 7 + idp];
    Result := True;
    if aCh in ['0'..'9'] then
      num1 := Ord(aCH) - Ord('0')
    else
    begin
      if aCh in ['A'..'Z'] then
        num1 := Ord(aCH) - Ord('A') + 10
      else
        Result := False;
    end;

    if not Result then
      exit;

    r := r * 36 + Num1;

    r2 := 0;
    for ii := 20 downto 0 do
    begin
      r1 := res1[ii] * 36 + r2;
      r2 := r1 div 10;
      res1[ii] := lo(r1 mod 10);
    end;

    r2 := num1;
    for ii := 20 downto 0 do
    begin
      r1 := res1[ii] + r2;
      r2 := r1 div 10;
      res1[ii] := lo(r1 mod 10);
    end;
    aAlcCode := '';


  end;
  for ii := 2 to 20 do
    aAlcCode := aAlcCode + IntToStr(res1[ii]);

end;


procedure TFormStart.LoadActInventoryInformBReg(const aStr, aUID: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, CHild6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  S: TStringStream;
  dir: string;
  StrPrice: string;
  summaDoc: real;
  stopsearch: boolean;
  WBRegId, EGAISFixNumber, EGAISFixDate, DocType, IdDoc, iDPosition,
  Quantity, informa, informb, price, alccode, alcname,
  docNumber, DocDate, ClientKodEgais, ClientINN, ClientKPP, ClientAddress, ClientName: string;
  flNew: boolean;
  Query: string;
begin
  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  flNew := True;
  summaDoc := 0;
  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) and flNew do
      begin

        // ==== Заголовок документа =====
        if Child1.NodeName = 'ns:ActInventoryInformBReg' then
        begin
          Child2 := child1.FirstChild;
          ConnectDB();
          while Assigned(Child2) do
          begin

            if Child2.NodeName = 'aint:Header' then
            begin
              Child3 := Child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'aint:ActRegId' then
                  WBRegId := Child3.FirstChild.NodeValue;
                if Child3.NodeName = 'aint:Number' then
                  DocNumber := AnsiToUTF8(Child3.FirstChild.NodeValue);
                Child3 := Child3.NextSibling;
              end;
            end;
            // ====== Содержимое документа ======
            if (Child2.NodeName = 'aint:Content') and (flNew) then
            begin
              Child3 := Child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'aint:Position' then
                begin
                  child4 := Child3.FirstChild;
                  while assigned(Child4) do
                  begin
                    if Child4.NodeName = '<aint:InformB' then
                    begin
                      Child5 := Child4.FirstChild;
                      while Assigned(Child5) do
                      begin
                        if Child5.NodeName = 'aint:InformBItem' then
                        begin
                          Child6 := Child4.FirstChild;
                          while Assigned(Child6) do
                          begin
                            if Child6.NodeName = 'aint:Identity' then
                              iDPosition := Child6.FirstChild.NodeValue;
                            if Child6.NodeName = 'aint:BRegId' then
                            begin
                              InformB := Child6.FirstChild.NodeValue;
                            end;
                            Child6 := Child6.NextSibling;
                          end;
                        end;
                        Child5 := Child5.NextSibling;
                      end;
                    end;
                    if Child4.NodeName = 'aint:InformARegId' then
                    begin
                      InformA := Child4.FirstChild.NodeValue;
                    end;
                    Child4 := Child4.NextSibling;
                  end;


                  Query :=
                    'INSERT INTO `docformab` (`formb`,`formA`,`numposition`,`docid`)  VALUE ("' +
                    informb + '","' + informA + '","' + IdPosition + '","' + aUID + '");';
                  DB_query(Query);
                  i := i + 1;

                end;
                Child3 := Child3.NextSibling;
              end;

            end;
            Child2 := Child2.NextSibling;
          end;
          if flNew then
          begin
            // == Добавляем документ в журнал ==
            Query := 'UPDATE `docjurnale` SET `WBRegId`="' + WBRegId +
              '" WHERE ( `DocId`="' + aUID + '")AND(`NumDoc`="' + DocNumber + '");';
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

function TFormStart.ConnectDB(): boolean;
begin

  Result := False;
  try
    if SockMySQL = nil then
    begin
      SockMySQL := mysql_init(PMYSQL(@qmysql));
      SockMySQL := mysql_real_connect(SockMySQL, PChar(UTF8ToANSI(mysqlurl)),
        PChar(UTF8TOANSI(mysqluser)), PChar(mysqlpassword), nil, 3306, nil, 0);
      if SockMySQL = nil then
      begin
        fShowMessage(' Не могу подключиться к базе данных:' + mysqlurl);
        Close;
        exit;
      end;

      if (mysql_query(sockMySQL, 'SET NAMES utf8;') < 0) then
      begin
        fShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
        Close;
        exit;
      end;

      if (mysql_query(sockMySQL, PChar('SHOW DATABASES LIKE "egais' + prefixDB + '";')) < 0) then
      else
      begin
        if mysql_fetch_row(mysql_store_result(sockMySQL)) = nil then
        begin
          mysql_query(sockMySQL, PChar('CREATE DATABASE egais' + prefixDB +
            ' CHARACTER SET utf8 COLLATE utf8_general_ci ;'));
        end;
      end;
      if mysql_select_db(SockMySQL, PChar('egais' + prefixdb)) < 0 then
      begin
        fShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
        Close;
        exit;
      end;
    end;
    if (mysql_ping(SockMySQL) < 0) then
    begin
      fShowMessage('Потеряно подключение:' + mysql_error(sockMySQL));
      Close;
      exit;
    end
    else
    begin

    end;
    Result := True;
  except
    On E: Exception Do
          fShowMessage('Exception: '+E.ToString);
    else
    //SockMySQL := nil;
    if sockMySQL<>nil then
     fShowMessage(' Не могу подключиться к БД:' + mysqlurl+' mysqlError:'+mysql_error(sockMySQL))
    else
     fShowMessage(' Не могу подключиться к БД:' + mysqlurl+' sockMySQL=nil')  ;


  end;

end;

procedure TFormStart.disconnectDB();
begin
  if recbuf <> nil then
    mysql_free_result(recbuf);
  recbuf := nil;
  if not flLowConnect then
  begin
    if SockMySQL <> nil then
      mysql_close(sockMySQL);
    SockMySQL := nil;
  end;
end;

//===== Обработки справки Б ===================
// ==== Запрос сведеней об обороте ====
procedure TFormStart.SendQueryHistoryFormB(const fbTTN: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  Query: string;
  st1: string;
  S: TStringList;
  s1: tstringstream;
begin
  s := TStringList.Create;
  s.Clear;
  s.add('<?xml version="1.0" encoding="UTF-8"?> <ns:Documents Version="1.0"');
  s.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  s.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  s.add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters" >');
  // <!--Кто запрашивает документы-->
  s.add('<ns:Owner>');
  //<!--Идентификатор организации в ФС РАР-->
  s.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  s.add('</ns:Owner>');
  //<!--Запрос на алкогольную продукцию-->
  s.add('<ns:Document>');
  s.add('<ns:QueryFormBHistory>');
  s.add('<qp:Parameters>');
  s.add('<qp:Parameter>');
  s.add('<qp:Name>RFB</qp:Name> ');
  s.add('<qp:Value>' + fbTTN + '</qp:Value>');
  s.add('</qp:Parameter>');
  s.add('</qp:Parameters> ');
  s.add('</ns:QueryFormBHistory>');
  s.add('</ns:Document> ');
  s.add('</ns:Documents>');
  S.Text := SaveToServerPOST('opt/in/QueryHistoryFormB', s.Text);
  S.SaveToFile(pathFile() + '\logGetAct.log');

  //  s1:='';
  S1 := TStringStream.Create(S.Text);
  try
    S1.Position := 0;
    XML := nil;
    ReadXMLFile(XML, S1); // XML документ целиком
    // Альтернативно:
    //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  finally
    S1.Free;
  end;
  Child := XML.DocumentElement.FirstChild;
  i := 1;
  if Assigned(Child) then
  begin
    if Child.NodeName <> 'url' then
      exit;
    st1 := Child.FirstChild.NodeValue;
    DB_Query('INSERT INTO `docjurnale` (`docid`, `status`,`WBRegId`,`uid`,`type`,`numdoc`,`dateDoc`) VALUE ('''
      + st1 + ''',''+++'',''' + fbTTN + ''',''' + st1 + ''',''QueryHistoryFormB'',''' +
      copy(fbTTN, 3, length(fbTTN)) + ''',NOW());');

    ShowMessage('Запрос отправлен!');
  end;
end;

// === Загрузка оборота
procedure TFormStart.LoadQueryHistoryFormB(const aStr, aUID: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  doctype, OperDate, Quantity, numfix, datefix, wbregid, Comments, sAlcCode: string;
  Query: string;
  st1: string;
  S: TStringStream;
  LogRes: TStringList;
  posit1: integer;
begin
  LogRes := TStringList.Create;
  LogRes.Clear;
  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  posit1 := 1;
  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) do
      begin  // ns:Ticket
        if Child1.NodeName = 'ns:ReplyHistFormB' then
        begin
          Child2 := child1.FirstChild;  // tc:DocType tc:DocId
          while Assigned(Child2) do
          begin
            if Child2.NodeName = 'hf:InformBRegId' then
            begin
              if Assigned(Child2.FirstChild) then
                numfix := Child2.FirstChild.NodeValue;
            end;             // tc:RegID
            if Child2.NodeName = 'hf:HistFormBDate' then
            begin
              if Assigned(Child2.FirstChild) then
                datefix := Child2.FirstChild.NodeValue;
            end;                      //OperationResult
            if Child2.NodeName = 'hf:HistoryB' then
            begin
              Child3 := child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'hf:OperationB' then
                begin
                  Child4 := child3.FirstChild;
                  while Assigned(Child4) do
                  begin
                    if Child4.NodeName = 'hf:DocType' then
                      if Assigned(Child4.FirstChild) then
                        doctype := Child4.FirstChild.NodeValue;
                    if Child4.NodeName = 'hf:DocId' then
                      if Assigned(Child4.FirstChild) then
                        wbregid := Child4.FirstChild.NodeValue;
                    if Child4.NodeName = 'hf:Operation' then
                      if Assigned(Child4.FirstChild) then
                        Comments := AnsiToUTF8(Child4.FirstChild.NodeValue);
                    if Child4.NodeName = 'hf:Quantity' then
                      if Assigned(Child4.FirstChild) then
                        Quantity := Child4.FirstChild.NodeValue;
                    if Child4.NodeName = 'hf:OperDate' then
                      if Assigned(Child4.FirstChild) then
                        OperDate := Child4.FirstChild.NodeValue;

                    Child4 := Child4.NextSibling;
                  end;

                  // == обработка документа
                  recbuf :=
                    DB_Query('SELECT `numdoc`,`datedoc`,`status`,`ClientAccept` FROM `docjurnale` WHERE wbregid="'
                    +
                    wbregid + '";');
                  rowbuf := DB_next(recbuf);
                  if rowbuf = nil then
                    LogRes.Add(
                      format('Не найден документ по номеру ЕГАИС:%s с комментарием: %s. Движение %s',
                      [wbregid, Comments, Quantity]))
                  else
                  begin
                    if rowbuf[3] = '+' then
                      LogRes.Add(
                        format('Найден ПРИНЯТЫЙ КЛИЕНТОМ документ ЕГАИС:%s с комментарием: %s. Движение %s',
                        [wbregid, Comments, Quantity]))
                    else
                    begin
                      if rowbuf[2] = '+++' then
                        LogRes.Add(
                          format('Найден НЕ ПРИНЯТЫЙ КЛИЕНТОМ документ ЕГАИС:%s с комментарием: %s. Движение %s',
                          [wbregid, Comments, Quantity]))
                      else
                        LogRes.Add(
                          format('Найден НЕ ОПРЕДЕЛЕННЫЙ документ ЕГАИС:%s с комментарием: %s. Движение %s',
                          [wbregid, Comments, Quantity]));
                    end;
                  end;
                  //DB_Query('DELETE FROM `regFormB` WHERE wbregid="'+wbregid+'";');

                  // recbuf:=DB_Query('DELETE FROM `regFormB` WHERE wbregid="'+wbregid+'";');
                  recbuf := DB_Query('SELECT * FROM `regFormB` WHERE `wbregid`="' +
                    wbregid + '" AND `posit`="' + IntToStr(posit1) + '";');
                  rowbuf := DB_next(recbuf);
                  if rowbuf <> nil then
                    DB_Query('UPDATE `regFormB` SET `datefix`="' +
                      OperDate + '",`numttn`="' + wbregid + '",`comment`="' + Comments + '",`quantity`="' +
                      Quantity + '",`uid`="' + aUID + '" WHERE `wbregid`="' + wbregid + '" AND `posit`="' +
                      IntToStr(posit1) + '";')
                  else
                    DB_Query(
                      'INSERT INTO `regFormB` (`wbregid`,`posit`,`datefix`,`numttn`,`comment`,`quantity`,`uid`) VALUES'
                      +
                      ' ("' + numfix + '","' + IntToStr(posit1) + '","' +
                      OperDate + '","' + wbregid + '","' + Comments + '","' + Quantity + '","' + aUID + '");');

                  //                  if Assigned(Child3.FirstChild) then
                  //                    sAlcCode := Child3.FirstChild.NodeValue;
                  posit1 := posit1 + 1;
                end;
                Child3 := Child3.NextSibling;
              end;
            end;
            Child2 := Child2.NextSibling;
          end;
          // ====== Вносим в журнал ===========
          if ConnectDB() then
          begin
            recbuf := DB_Query(
              'SELECT `docformab`.`AlcItem`,`spproduct`.`name` FROM `docformab`,`spproduct` WHERE `docformab`.`formb`="'
              +
              numfix + '" and `spproduct`.`AlcCode`=`docformab`.`AlcItem`;');
            rowbuf := DB_next(recbuf);
            if rowbuf <> nil then
              LogRes.Add(format('Для справки Б:%s Код товара: %s Наимен:%s',
                [numfix, rowbuf[0], rowbuf[1]]));
          end;
        end;
        Child1 := Child1.NextSibling;
      end;

    end;
    Child := Child.NextSibling;
  end;
  st1 := StringToHex(LogRes.Text);
  DB_Query('INSERT INTO `ticket` (`uid`,`docid`,`RegID`,`accept`,`comment`,`numdoc`,`datedoc`,`datestamp`,`type`) VALUES ("'
    + aUID + '","' + aUID + '","","Accepted",0x' + st1 + ',"",NOW(),NOW(),''QueryHistoryFormB'');');

  LogRes.SaveToFile('QueryHistoryFormB_' + aUID + '.xml');
  LogRes.Free;
end;
//=============================================

procedure TFormStart.loadReplyFormB(const aStr, aUID: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  numfix, datefix, forma, Comments, sAlcCode: string;
  Query: string;
  st1: string;
  S: TStringStream;
begin

  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;

  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) do
      begin  // ns:Ticket
        if Child1.NodeName = 'ns:ReplyFormB' then
        begin
          Child2 := child1.FirstChild;  // tc:DocType tc:DocId
          while Assigned(Child2) do
          begin
            if Child2.NodeName = 'rfb:InformBRegId' then
            begin
              if Assigned(Child2.FirstChild) then
                forma := Child2.FirstChild.NodeValue;
            end;             // tc:RegID
            if Child2.NodeName = 'rfb:TTNNumber' then
            begin
              if Assigned(Child2.FirstChild) then
                numfix := AnsiToUTF8(Child2.FirstChild.NodeValue);
            end;
            if Child2.NodeName = 'rfb:TTNDate' then
            begin
              if Assigned(Child2.FirstChild) then
                datefix := Child2.FirstChild.NodeValue;
            end;                      //OperationResult
            if Child2.NodeName = 'rfb:Product' then
            begin
              Child3 := child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'pref:AlcCode' then
                begin
                  if Assigned(Child3.FirstChild) then
                    sAlcCode := Child3.FirstChild.NodeValue;
                end;
                Child3 := Child3.NextSibling;
              end;
              loadXmlProduct(child2.FirstChild);
            end;
            Child2 := Child2.NextSibling;
          end;
          // ====== Вносим в журнал ===========
          if ConnectDB() then
          begin
            Query := 'UPDATE `regrestsproduct` SET `numTTN`=''' +
              numfix + ''', `dateTTN`=''' + datefix + ''' WHERE (`InformBRegId`=''' + forma +
              ''')AND(`alcCode`=''' + sAlcCode + ''');';
            recbuf := DB_query(Query);
          end;
        end;
        Child1 := Child1.NextSibling;
      end;

    end;
    Child := Child.NextSibling;
  end;

end;
// ==== Загрузка необработанных накладных ====
procedure TFormStart.LoadReplyNATTN(const aStr, aUID: string);
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  numttn, datettn, awbreg, Comments, sAlcCode: string;
  Query: string;
  st1: string;
  S: TStringStream;
begin

  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;

  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) do
      begin  // ns:Ticket
        if Child1.NodeName = 'ns:ReplyNoAnswerTTN' then
        begin
          Child2 := child1.FirstChild;  // tc:DocType tc:DocId
          while Assigned(Child2) do
          begin
            if Child2.NodeName = 'ttn:ttnlist' then
            begin
              Child3 := child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'ttn:NoAnswer' then
                begin
                  Child4 := child3.FirstChild;
                  awbreg := '';
                  while Assigned(Child4) do
                  begin
                    if Child4.NodeName = 'ttn:WbRegID' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        awbreg := Child4.FirstChild.NodeValue;
                    end;             // tc:RegID
                    if Child4.NodeName = 'ttn:ttnNumber' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        numttn := AnsiToUTF8(Child4.FirstChild.NodeValue);
                    end;
                    if Child4.NodeName = 'ttn:ttnDate' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        datettn := Child4.FirstChild.NodeValue;
                    end;                      //OperationResult
                    Child4 := Child4.NextSibling;
                  end;
                  if awbreg <> '' then
                  begin
                    formlogging.AddMessage('Есть необработаная накладная:' +
                      numttn + ' от ' + datettn);
                    recbuf :=
                      db_query('SELECT * FROM `docjurnale` WHERE `wbregid`="' + awbreg +
                      '" and `registry`="+" ;');
                    rowbuf := db_Next(recbuf);
                    if rowbuf = nil then
                    begin  // == накладную с таким WBreg не нашли значит отправляем повторно запрос.
                      formlogging.AddMessage('Накладную ' + numttn +
                        ' от ' + datettn + ' запрашиваем повторно!');
                      FormResendDoc.LabeledEdit1.Text := awbreg;
                      FormResendDoc.BitBtn2Click(nil);
                    end;
                  end;
                  // ==== проверяем и если надо запрашиваем повторно документ из егаис ====

                end;

                Child3 := Child3.NextSibling;
              end;

            end;
            Child2 := Child2.NextSibling;
          end;
        end;
        Child1 := Child1.NextSibling;
      end;

    end;
    Child := Child.NextSibling;
  end;

end;

// Акт подтверждения расходных ТТН - ОПТ
procedure TFormStart.FromSaleActTTH(const numdoc, datedoc: string; isAccept: boolean);
var
  ind: integer;
  lastname: string;
  fullname: string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
  i: integer;
  flSub: boolean;
  WBRegID, S1: string;
  SLine: TStringList;
  sLine1: TStringList;
  flAccept: string;
  Query: string;
begin
  if isAccept then
    flAccept := 'Accepted'
  else
    flAccept := 'Rejected';
  if not ConnectDB() then
    exit;
  Query := 'SELECT `WBRegID`, `issueclient`  FROM `docjurnale` WHERE (`numdoc`="' +
    NumDoc + '")AND(`datedoc`="' + datedoc + '");';
  recbuf := DB_Query(Query);
  rowbuf := DB_Next(recbuf);
  if rowbuf = nil then
    exit;
  WBRegID := rowbuf[0];
  s1 := rowbuf[1];
  if WBRegID = '' then
  begin
    //  disconnectDB();
    exit;
  end;
  if s1 = '1' then
    exit;
  if (s1 = '+') then
  begin

    // ================================
    SLine := TStringList.Create;

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
    SLine.Add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
    SLine.Add('</ns:Owner>');
    SLine.Add('<ns:Document>');
    SLine.Add('<ns:ConfirmTicket>');
    SLine.Add('<wt:Header>');
    SLine.Add('<wt:IsConfirm>' + flAccept + '</wt:IsConfirm>');
    SLine.Add('<wt:TicketNumber>' + numdoc + '</wt:TicketNumber>');
    SLine.Add('<wt:TicketDate>' + DateDoc + '</wt:TicketDate>');
    SLine.Add('<wt:WBRegId>' + WBRegID + '</wt:WBRegId>');
    SLine.Add('<wt:Note>' + flAccept + '</wt:Note>'); // Приниаем продукцию

    SLine.Add('</wt:Header>');
    SLine.Add('</ns:ConfirmTicket>');
    SLine.Add('</ns:Document>');
    SLine.Add('</ns:Documents>');
    SLine.Text := SaveToServerPOST('opt/in/WayBillTicket', SLine.Text);
    SLine.SaveToFile(pathFile() + '\logGetAct.log');

    S := TStringStream.Create(SLine.Text);
    try
      S.Position := 0;
      XML := nil;
      ReadXMLFile(XML, S); // XML документ целиком
      // Альтернативно:
      //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
    finally
      S.Free;
    end;
    Child := XML.DocumentElement.FirstChild;
    i := 1;
    if Assigned(Child) then
    begin
      //   if not ConnectDB() then
      //    exit;
      s1 := Child.NextSibling.FirstChild.NodeValue;
      Delete(s1, pos(#10, s1), 1);
      if Child.NodeName <> 'url' then
      begin
        Query := 'UPDATE `docjurnale`   SET `status`="0--", `Clientaccept`=""  WHERE (`numdoc`="'
          + NumDoc + '")AND(`datedoc`="' + datedoc + '");'; //,NumDoc="'+DocNumber+'"
      end
      else
      begin
        Query := 'UPDATE `docjurnale` SET uid="' + Child.FirstChild.NodeValue +
          '", `sign`="' + s1 +
          '", `status`="+1+",`block`="+", `Clientaccept`="+" ,`issueclient`="1" WHERE (`numdoc`="' + NumDoc
          +
          '")AND(`datedoc`="' + datedoc + '");'; //,NumDoc="'+DocNumber+'"
      end;
      DB_Query(Query);

    end;
  end
  else
  begin
    // ================================
    SLine := TStringList.Create;

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
    SLine.Add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
    SLine.Add('</ns:Owner>');
    SLine.Add('<ns:Document>');
    SLine.Add('<ns:WayBillAct>');
    SLine.Add('<wa:Header>');
    SLine.Add('<wa:IsAccept>' + flAccept + '</wa:IsAccept>');
    SLine.Add('<wa:ACTNUMBER>' + numdoc + '</wa:ACTNUMBER>');
    SLine.Add('<wa:ActDate>' + DateDoc + '</wa:ActDate>');
    SLine.Add('<wa:WBRegId>' + WBRegID + '</wa:WBRegId>');
    SLine.Add('<wa:Note>' + flAccept + '</wa:Note>'); // Приниаем продукцию
    SLine.Add('</wa:Header>');
    SLine.Add('<wa:Content>');
    SLine.Add('</wa:Content>');
    SLine.Add('</ns:WayBillAct>');
    SLine.Add('</ns:Document>');
    SLine.Add('</ns:Documents>');
    SLine.Text := SaveToServerPOST('opt/in/WayBillAct', SLine.Text);
    SLine.SaveToFile(pathFile() + '\logGetAct.log');
    S := TStringStream.Create(sLine.Text);
    try
      S.Position := 0;
      XML := nil;
      ReadXMLFile(XML, S); // XML документ целиком
      // Альтернативно:
      //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
    finally
      S.Free;
    end;
    Child := XML.DocumentElement.FirstChild;
    i := 1;
    if Assigned(Child) then
    begin
      s1 := Child.NextSibling.FirstChild.NodeValue;
      Delete(s1, pos(#10, s1), 1);
      if Child.NodeName <> 'url' then
      begin
        Query := 'UPDATE `docjurnale` SET status="0--" WHERE (`numdoc`="' +
          NumDoc + '")AND(`datedoc`="' + datedoc + '");'; //,NumDoc="'+DocNumber+'"
        ShowMessage('Ошибка при отправке!');
      end
      else
      begin
        Query := 'UPDATE `docjurnale` SET uid="' + Child.FirstChild.NodeValue +
          '", sign="' + s1 + '", status="+++",`block`="1"  WHERE (`numdoc`="' +
          NumDoc + '")AND(`datedoc`="' + datedoc + '");'; //,NumDoc="'+DocNumber+'"
        ShowMessage('Акт отправлен с номером:' + Child.FirstChild.NodeValue);
      end;
      DB_query(Query);
      Query := 'INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("' +
        Child.FirstChild.NodeValue + '","' + NumDoc + '","' + datedoc + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
    end;

  end;
  ShowMessage('Уведомление отправлено!');
end;

procedure TFormStart.refreshEGAISIn();
begin
  refreshEGAIS;
end;

procedure TFormStart.SendStackEGAIS();
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
  query: string;
  rType: string;
begin
  Query := 'SELECT `type`,`value` FROM `stacksender` WHERE `sending`="" LIMIT 1;';
  xrecbuf := DB_Query(Query);
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
  begin
    rType := xrowbuf[0];
    if rtype = 'form1' then
    begin
      formlogging.AddMessage(' Запросим Справку А:' + xrowbuf[1]);
      queryFormA(xrowbuf[1]);
    end;
    if rtype = 'queryap' then
    begin
      formlogging.AddMessage(' Запросим сведения о товаре с кодом:' + xrowbuf[1]);
      QueryAP_v2(xrowbuf[1]);
    end;
    DB_Query('UPDATE `stacksender` SET `sending`="+" WHERE `type`="' +
      rType + '" AND `value`="' + xrowbuf[1] + '";');
  end;

end;

function TFormStart.DB_query(const sSQL: string; aTable:string=''): PMYSQL_RES;
var
  errno: integer;
  errstr: string;
begin
  if sockMySQL = nil then
    ConnectDB()
  else
  begin
    if mysql_ping(sockMySQL) <> 0 then
    begin
      sockMySQL := nil;
      connectDB();
    end;

  end;

  if sockMySQL <> nil then
  begin
    if (mysql_query(sockMySQL, PChar(sSQL)) < 0) then
    begin
      errno := mysql_errno(sockMySQL);
      errstr := mysql_error(sockMySQL);
      ShowMessage('Ошибка СУБД [' + IntToStr(errno) + ']:' + errstr+' QUERY:'+sSQL);
      DisconnectDB();
      Result := DB_query(sSQL);
    end
    else begin
      Result := mysql_store_result(sockMySQL);
      errno := mysql_errno(sockMySQL);
      errstr := mysql_error(sockMySQL);
      if errno<>0 then begin
         fShowMessage('Ошибка СУБД [' + IntToStr(errno) + ']:' + errstr+' QUERY:'+sSQL);
         self.RecoveryTable(aTable);
      end;
    end;
  end
  else begin
    Result := nil;
    fshowmessage('Ошибка при выполнении запроса:'+sSQL);
  end;
end;

function TFormStart.DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
begin
  if aRes = nil then
    Result := nil
  else
    Result := mysql_fetch_row(aRes);
end;

function TFormStart.DB_checkTable(aTable: string): boolean;
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  //SHOW DATABASES;
  // CREATE DATABASE `text1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
  Result := False;
  xrecbuf := DB_query('SHOW TABLES FROM `egais' + prefixDB + '` LIKE ''' + aTable + ''';');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    Result := True;
end;

function TFormStart.DB_checkCol(aTable, aCol, aType, aSize: string;
  aDefault: string = ''): boolean;
var
  s1: string;
begin
  Result := True;
  if DB_checkTable(aTable) then
  begin
    s1 := 'SHOW COLUMNS FROM `' + aTable + '` LIKE "' + aCol + '";';
    recbuf := DB_Query(s1);
    rowbuf := DB_Next(recbuf);
    if rowbuf <> nil then
    begin
      s1 := rowbuf[1];
      if pos(aType, s1) <= 0 then
        DB_query('ALTER TABLE `' + aTable + '` CHANGE `' + aCol + '` `' +
          aCol + '` ' + aType + ' NOT NULL ' + aDefault + ';')
      else
        Result := False;
    end
    else
      DB_query('ALTER TABLE `' + aTable + '` ADD `' + aCol + '` ' + aType +
        ' NOT NULL ' + aDefault + ';');
  end
  else
  begin
    DB_query('CREATE TABLE `' + aTable + '` (`' + aCol + '` ' + aType +
      ' NOT NULL ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
    Result := True;
  end;
end;

procedure TFormStart.SetConstant(const aName, aValue: string);
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  xrecbuf:=nil;
  xrecbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`=''' + aName + ''';','const');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    xrecbuf := DB_Query('UPDATE `const` SET `value`=''' + aValue +
      ''' WHERE `name`=''' + aName + ''';')
  else
    xrecbuf := DB_Query('INSERT INTO `const` (`name`,`value`,`storepoint` ) VALUE (''' +
      aName + ''',''' + aValue + ''', '''');','const');
end;

procedure TFormStart.SetConstBool(const aName: string; aValue: boolean);
begin
  if aValue then
    SetConstant(aName, '1')
  else
    SetConstant(aName, '0');
end;

function TFormStart.GetConstant(aName: string): string;
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  xrecbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`=''' + aName + ''';','const');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    Result := xrowbuf[0]
  else
    Result := '';
end;

function TFormStart.GetConstBool(aName: string): boolean;
begin
  Result := db_boolean(GetCOnstant(aName));
end;

//function TFormStart.DeleteKeyDB(const aTable,aCol:string):boolean;
//begin
//  ALTER TABLE `spformfix`
//    DROP INDEX `numfix`,
//    DROP PRIMARY KEY;
//end;

// == получаем код алкпродукции по справке Б
function TFormStart.GetAlcCodeFormB(const aFormB: string): string;

begin
  recbuf := DB_Query('SELECT `AlcCode` FROM `regrestsproduct` WHERE `InformBRegId` LIKE "'
    +
    aFormB + '";');
  rowbuf := DB_Next(recBuf);
  if rowbuf <> nil then
    Result := rowbuf[0]
  else
    Result := '';
end;

procedure TFormStart.QueryFormA(const aFormA: string);
var
  SLine: TStringList;
begin
  sLine := TStringList.Create();
  sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
  sLine.Add('<ns:Documents Version="1.0"');
  sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
  sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
  sLine.Add('<ns:Owner>');
  sLine.Add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  sLine.Add('</ns:Owner>');
  sLine.Add('<ns:Document>');
  sLine.Add('<ns:QueryFormA>');
  sLine.Add('<qf:FormRegId>' + aFormA + '</qf:FormRegId>');
  sLine.Add('</ns:QueryFormA> ');
  sLine.Add('</ns:Document>');
  sLine.Add('</ns:Documents>');
  formStart.SaveToServerPOST('opt/in/QueryFormA', SLine.Text);
  sLine.Free;
  // showMessage('Запрос отправлен!');
end;

procedure TFormStart.QueryAP_v2(const aAlcCode: string);
var
  SLine: TStringList;
  str: string;
begin
  SLine := TStringList.Create;
  SLine.Clear;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:QueryAP_v2>');
  //SLine.add('<ns:QueryAP>');
  SLine.add('<qp:Parameters>');
  SLine.add('<qp:Parameter>');
  SLine.add('<qp:Name>КОД</qp:Name>');
  SLine.add('<qp:Value>' + aAlcCode + '</qp:Value>');
  SLine.add('</qp:Parameter>');
  SLine.add('</qp:Parameters>');
  SLine.add('</ns:QueryAP_v2>');
  //SLine.add('</ns:QueryAP>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str:=savetoserverpost('opt/in/QueryAP_V2',Sline.text) ;
  //str := savetoserverpost('opt/in/QueryAP', Sline.Text);
  //showmessage(str);
  SLine.Free;
  // showMessage('Запрос отправлен!');
end;

function TFormStart.ActChargeOnShopv2(const numdoc, datedoc: string): boolean;
var
  S: TStringStream;
  SLine: TStringList;
  idAlcCode, strGUID, aClientRegId, query: string;
  s1, str: string;
  aClientProvider: string;
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
  ind: integer;
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  flrussia: boolean;
  // === doc26, docx26 - Оприходование в розницу ----
begin
  aClientProvider := '';
  SLine := TStringList.Create;
  SLine.Clear;
  query := 'SELECT (SELECT `fullname` FROM `spproducer` WHERE `clientregid`= `docx26`.`clientprovider` LIMIT 1) AS `name` FROM `docx26` WHERE `numdoc`="' + numdoc + '" AND `datedoc`="' + datedoc + '";';
  recbuf := DB_Query(query);
  rowbuf := DB_Next(recbuf);
  if rowbuf <> nil then
    aClientProvider := rowbuf[0];
  strGUID := NewGUID();
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
  SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:ActChargeOnShop_v2>');
  SLine.add('<ainp:Identity>' + strGUID + '</ainp:Identity>');
  SLine.add('<ainp:Header>');
  SLine.add('<ainp:ActDate>' + datedoc + '</ainp:ActDate>');
  SLine.add('<ainp:Number>' + numdoc + '</ainp:Number>');
  SLine.add('<ainp:TypeChargeOn>Продукция, полученная до 01.01.2016</ainp:TypeChargeOn>');
  SLine.add('<ainp:Note>Акт постановки на баланс от участника системы ' +
    aClientProvider + ',версия 2.0</ainp:Note>');
  SLine.add('</ainp:Header>');
  SLine.add('<ainp:Content>');
  // ==== Описание позиции =====
  idAlcCode := '';
  ind := 1;
  query := 'SELECT `alccode`,`count` FROM `doc26` WHERE `numdoc`="' +
    numdoc + '" AND `datedoc`="' + datedoc + '";';
  recbuf := DB_Query(Query);
  rowBuf := DB_Next(recbuf);
  while rowbuf <> nil do
  begin
    idAlcCode := rowbuf[0];
    SLine.add('<ainp:Position>');
    SLine.add('<ainp:Identity>' + IntToStr(ind) + '</ainp:Identity>');
    Query := 'SELECT `name`,`capacity`,`clientregid`  FROM `spproduct` WHERE `alccode`="' +
      idAlcCode + '" LIMIT 1;';
    xrecbuf := DB_Query(query);
    xrowbuf := DB_Next(xrecbuf);
    if xrowbuf <> nil then
    begin
      aClientRegId := xrowbuf[2];
      SLine.add('<ainp:Product>');
      SLine.add('<pref:UnitType>Packed</pref:UnitType>');
      SLine.add('<pref:Type>АП</pref:Type>');
      SLine.add('<pref:FullName>' + ReplaceStr(xrowbuf[0]) + '</pref:FullName>');
      SLine.add('<pref:AlcCode>' + idAlcCode + '</pref:AlcCode>');
      SLine.add('<pref:Capacity>' + xrowBuf[1] + '</pref:Capacity>');
      // === получим данные о производителе ===
      Query :=
        'SELECT `inn`,`kpp`,`FullName`,`description`,`Country`,`region`  FROM `spproducer` WHERE `ClientRegId`="'
        +
        aClientRegId + '" LIMIT 1;';
      xrecbuf := DB_Query(query);
      xrowbuf := DB_Next(xrecbuf);
      if xrowbuf <> nil then
      begin
        if (xrowbuf[4] = '') or (xrowbuf[4] = '643') then
          flrussia := True
        else
          flrussia := False;

        SLine.add('<pref:Producer>');
        if flrussia then
          SLine.add('<oref:UL>')
        else
          SLine.add('<oref:FO>');
        SLine.add('<oref:ClientRegId>' + aClientRegId + '</oref:ClientRegId>');
        SLine.add('<oref:FullName>' + replacestr(xrowbuf[2]) + '</oref:FullName>');
        SLine.add('<oref:ShortName>' + UTF8Copy(replacestr(xrowbuf[2]), 1, 64) +
          '</oref:ShortName>');
        if xrowbuf[0] <> '' then
        begin
          SLine.add('<oref:INN>' + xrowbuf[0] + '</oref:INN>');
          if xrowbuf[1] <> '' then
            SLine.add('<oref:KPP>' + xrowbuf[1] + '</oref:KPP>');
        end;
        SLine.add('<oref:address>');
        if (xrowbuf[4] = '') or (xrowbuf[4] = '643') then
        begin
          SLine.add('<oref:Country>643</oref:Country>');
          if xrowbuf[5] <> '' then
            SLine.add('<oref:RegionCode>' + xrowbuf[5] + '</oref:RegionCode>')
          else
            SLine.add('<oref:RegionCode>' + copy(xrowbuf[0], 1, 2) + '</oref:RegionCode>');
        end
        else
        begin
          SLine.add('<oref:Country>' + xrowbuf[4] + '</oref:Country>');
          if xrowbuf[5] <> '' then
            SLine.add('<oref:RegionCode>' + xrowbuf[5] + '</oref:RegionCode>');
        end;

        SLine.add('<oref:description>' + replaceStr(xrowbuf[3]) + '</oref:description>');
        SLine.add('</oref:address>');
        if flrussia then
          SLine.add('</oref:UL>')
        else
          SLine.add('</oref:FO>');
        SLine.add('</pref:Producer>');
      end;
      SLine.add('<pref:ProductVCode>АП</pref:ProductVCode>');
      SLine.add('</ainp:Product>');
    end;
    SLine.add('<ainp:Quantity>' + rowbuf[1] + '</ainp:Quantity>');
    SLine.add('</ainp:Position>');
    rowbuf := DB_Next(recbuf);
    ind := ind + 1;
  end;
  // ==== Описание позиции ===========
  SLine.add('</ainp:Content>');
  SLine.add('</ns:ActChargeOnShop_v2>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');

  str := savetoserverpost('opt/in/ActChargeOnShop_v2', Sline.Text);
  //ShowMessage(str);
  SLine.Text := str;
  if SLine.Count < 1 then
  begin
    SLine.SaveToFile(pathfile() + '\logGetActChargeOnShop.txt');
    exit;
  end;
  s1 := '';
  S := TStringStream.Create(SLine.Text);
  try
    S.Position := 0;
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
    // Альтернативно:
    //    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.
  finally
    S.Free;
  end;
  ShowMessage('Документ отправлен в ЕГАИС!');
  Child := XML.DocumentElement.FirstChild;

  if Assigned(Child) then
  begin
    if Child.NodeName <> 'url' then
    begin
      // "0--" -
      Query := 'UPDATE `docjurnale`   SET uid="' + Child.FirstChild.NodeValue +
        '", status="0--", docid="' + strGUID + '", ClientAccept="" ' +
        'WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + datedoc + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
      Query :=
        'INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportid`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES' + ' ('''','''','''','''',''Rejected'',''' + Child.NodeValue + ''',''ActChargeOnShop'',''ActChargeOnShop'',''ActChargeOnShop'',''' + numdoc + ''',''' + datedoc + ''');';
      DB_query(Query);

    end
    else
    begin
      s1 := Child.NextSibling.FirstChild.NodeValue;
      Delete(s1, pos(#10, s1), 1);
      Query := 'UPDATE `docjurnale`   SET uid="' + Child.FirstChild.NodeValue +
        '", sign="' + s1 + '", docid="' + strGUID + '", ClientAccept="" ' +
        'WHERE (`numdoc`="' + NumDoc + '")AND(`datedoc`="' + datedoc + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
      Query := 'INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("' +
        Child.FirstChild.NodeValue + '","' + NumDoc + '","' + datedoc + '");';
      // добавлен сброс подтверждения клиента для ОПТА
      DB_query(Query);
    end;
  end;
  SLine.Free;

end;

function TFormStart.SendQueryRestsShopv2(): boolean;
var

  SLine: TStringList;
  str: string;
  sURL: string;
  MSec: comp;
  timest: TTimeStamp;
begin
  timest := DateTimeToTimeStamp(Now());
  MSec := TimeStampToMSecs(timest);
  SLine := TStringList.Create;
  SLine.Clear;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?> ');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:QueryRestsShop_v2>');
  SLine.add('</ns:QueryRestsShop_v2>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str := savetoserverpost('opt/in/QueryRestsShop_v2', Sline.Text);
  sURL := getXMLtoURL(str);
  setConstant('uidrestshop', sURL);
  setConstant('LastUpdateRestShop', FloattoStr(mSec));
  setConstant('finupdaterestshop', '');

  //showmessage(str);
end;

function TFormStart.Setwaybillv2(): boolean;
var
  S: TStringStream;
  SLine: TStringList;
  str: string;
begin
  SLine := TStringList.Create;
  SLine.Clear;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/InfoVersionTTN"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>' + EgaisKod + '</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:InfoVersionTTN>');
  SLine.add('<qp:ClientId>' + EgaisKod + '</qp:ClientId>');
  SLine.add('<qp:WBTypeUsed>WayBill_v4</qp:WBTypeUsed>');
  SLine.add('</ns:InfoVersionTTN>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str := savetoserverpost('opt/in/InfoVersionTTN', Sline.Text);
  ShowMessage('Отправлен переход на версию 4:' + str);
end;


function TFormStart.updateReport(): string;
var
  w: TFPHTTPClient;
  fzip: TUnZipper;
  Fini: TIniFile;
begin
  result:='';
  if not (prefixdb = '') then
     exit;
  w := TFPHTTPClient.Create(nil);

  w.Get('http://egais.retailika.ru/files/report.zip', './report.zip');
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
  FIni := TIniFile.Create('egaismon.ini');
  Fini.WriteString('GLOBAL', 'reportversion', curVerReport);
  Fini.Destroy;
end;

function TFormStart.SpFindOfCode(const aSpr, aCode: string): string;

begin

end;

function TFormStart.DB_StrToDate(const aStrDate: string): TdateTime;
begin
  Result := StrToDate(aStrDate[9] + aStrDate[10] + DateSeparator + aStrDate[6] +
    aStrDate[7] + DateSeparator + aStrDate[1] + aStrDate[2] + aStrDate[3] + aStrDate[4]);
end;

function TFormStart.GetEAN13rib(s_alccode: string): string;
var
  i: integer;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  w := TFPHTTPClient.Create(nil);
  try
    Result := w.Get('http://www.retailika.ru/service/getean13.php?regid=' +
      egaiskod + '&alccode=' + s_alccode);
  except
    // === ошибка при подключении
    Result := '';
    formlogging.AddMessage('нет доступа к интернет!', '!!!');
  end;
  w.Free;
  i := pos(']', Result);
  if i > 0 then
  begin
    Result := copy(Result, 2, i - 2);
  end;
  if pos('error:', Result) > 0 then
  begin
    formlogging.AddMessage('' + Result, '!!!');
    Result := '';
  end;

  if length(Result) = 0 then
  begin
    formlogging.AddMessage('Не возможно получить данные!', '!!!');
  end;
end;

function TFormStart.SetEAN13rib(s_alccode, a_name: string; s_ean13: string): string;
var
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  w := TFPHTTPClient.Create(nil);
  formlogging.AddMessage('sms:' + s_alccode + '', '>');
  try
    Result := w.Get('http://egais.retailika.ru/service/setean13h.php?ean13=' +
      s_ean13 + '&alccode=' + s_alccode + '&name=' + StringToHex(a_name));
  except
    // === ошибка при подключении
    Result := '';
  end;
  formlogging.AddMessage('sms:' + Result, '>');
  w.Free;
end;

function TFormStart.controlena13(strBC: string): boolean;
var
  i: integer;
  str: string;
begin
  Result := False;
  if length(strBC) = 13 then
  begin
    i := 3 * (StrToInt(strBC[2]) + StrToInt(strBC[4]) + StrToInt(strBC[6]) +
      StrToInt(strBC[8]) + StrToInt(strBC[10]) + StrToInt(strBC[12]));
    i := i + StrToInt(strBC[1]) + StrToInt(strBC[3]) + StrToInt(strBC[5]) +
      StrToInt(strBC[7]) + StrToInt(strBC[9]) + StrToInt(strBC[11]);
    str := IntToStr(10 - (i mod 10));
    if strBC[13] = str[1] then
      Result := True;
  end;
end;

function TFormStart.StrToFloat(const strDouble: string): double;
var
  subres: double;
  i: integer;
  iPoint: integer;
  istr: string;
  k: double;
begin
  Result := 0.00;
  iStr := trim(strDouble); // !!! Убираем лишник пробелы

  for i := 1 to length(iStr) do
    if not (iStr[i] in ['.', '0'..'9']) then
      exit; // !!!! что бы небыло символов
  iPoint := pos('.', iStr);  // ищем позицию точки
  if iPoint = 0 then
    iPoint := length(iStr) + 1;
  // теперь  надо x*10^n+r степени -
  subres := 0.0;
  for i := 1 to iPoint - 1 do
    subres := subres * 10 + StrToInt(iStr[i]);
  Result := subres;
  // можно наоборот

  subres := 0;
  k := 0.1;
  for i := iPoint + 1 to length(iStr) do
  begin
    subres := subres + StrToInt(iStr[i]) * k;
    k := k * 0.1;
  end;
  Result := Result + subres;
end;

function TFormStart.Str1ToDate(const strDate: string): TDateTime;
var
  str1: string;
begin
  str1 := trim(strdate);
  Result := StrtoDate(str1, 'YYYY-MM-DD', '-');
end;

{Генерируем уникальный ID}
function TFormStart.NewGUID(): string;  // === генератор GUID
var
  ID: TGUID;
  s1, strGUID: string;
  i: integer;
begin
  strGUID := '';
  if CreateGuid(ID) = S_OK then
  begin
    strGUID := GUIDToString(ID);
    s1 := '';
    //  убираем фигурные скобки
    for i := 2 to length(strGuid) - 1 do
      s1 := s1 + strGuid[i];
    strGuid := s1;
  end;
  Result := strGUID;
end;

function TFormStart.getXMLtoURL(const aStr: string; aShowMessage:boolean=true): string;  // === генератор GUID
var
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S: TStringStream;
begin
  flErrorEGAIS := '';
  Result := '';
  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;
  Child := XML.DocumentElement.FirstChild;
  if Assigned(Child) then
  begin
    if Child.NodeName = 'url' then
    begin
      Result := Child.FirstChild.NodeValue;
      // Child.Attributes.GetNamedItem('replyId').NodeValue;
      if ashowmessage then
        ShowMessage('Отправленно в ЕГАИС!')
       else
         formlogging.AddMessage('Отправленно в ЕГАИС!');
    end
    else
    begin
      if ashowmessage then
        ShowMessage('Ошибка:' + Child.FirstChild.NodeValue)
      else
       formlogging.AddMessage('Ошибка:' + Child.FirstChild.NodeValue);
      flErrorEGAIS := Child.FirstChild.NodeValue;
      Result := '';
    end;
  end
  else
  begin
    if ashowmessage then
       ShowMessage('Ошибка:' + aStr)
      else
       formlogging.AddMessage('Ошибка:' + aStr);
    flErrorEGAIS := aStr;
  end;

  // formStart.disconnectDB();
end;

function TFormStart.readUTMinfo(): boolean;
var
  str1: string;
begin
  Result := True;
  // ==== запрашиваем Стартовую страницу УТМ
  str1 := SaveToServerGET('', '');
  if str1 = '' then
  begin
    Result := False;
    ShowMessage('Нет связи с УТМ!');
  end;
end;



function TFormStart.GetXmlProducer(aRegId: string; oref: string;
  beginregid: boolean; flutmv2: boolean): string;
var
  utmv2: boolean;
  str1: string;
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
  flagUL: string;
  flcountry: string;
begin
  utmv2 := flutmv2;
  if getConstant('utmversion') = '4' then
    utmv2 := True;
  xrecbuf := db_query(
    'SELECT `inn`, `kpp`,`fullname`,`country`,`region`,`description` FROM `spproducer` WHERE `clientregid`="'
    +
    aregId + '"; ');
  str1 := '';
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
  begin
    flCountry := xrowbuf[3];
    if flCountry = '' then
      flCountry := '643';
    if utmv2 then
    begin
      if flCountry = '643' then
      begin
        if xrowbuf[1] <> '' then
          str1 := str1 + '<oref:UL>' + #13#10
        else
          str1 := str1 + '<oref:FL>' + #13#10;
      end
      else
        str1 := str1 + '<oref:FO>' + #13#10;
    end;
    if beginregid then
      str1 := str1 + '     <oref:ClientRegId>' + aRegId + '</oref:ClientRegId>' + #13#10;
    if xrowbuf[0] <> '' then
      str1 := str1 + '    <oref:INN>' + xrowbuf[0] + '</oref:INN>' + #13#10;
    if xrowbuf[1] <> '' then
      str1 := str1 + '     <oref:KPP>' + xrowbuf[1] + '</oref:KPP>' + #13#10;
    if not beginregid then
      str1 := str1 + '     <oref:ClientRegId>' + aRegId + '</oref:ClientRegId>' + #13#10;
    str1 := str1 + '     <oref:FullName>' + xrowbuf[2] + '</oref:FullName>  ' + #13#10;
    str1 := str1 + '     <oref:address >' + #13#10;
    str1 := str1 + '      <oref:Country>' + flCountry + '</oref:Country>' + #13#10;
    if (xrowbuf[4] <> '') then
      str1 := str1 + '      <oref:RegionCode>' + xrowbuf[4] + '</oref:RegionCode>' + #13#10
    else
    if ((flutmv2) and (flCountry = '643')) then
    begin
      if xrowbuf[1] <> '' then
        str1 := str1 + '      <oref:RegionCode>' + copy(xrowbuf[1], 1, 2) +
          '</oref:RegionCode>' + #13#10
      else
        str1 := str1 + '      <oref:RegionCode>' + copy(xrowbuf[0], 1, 2) +
          '</oref:RegionCode>' + #13#10;
    end;

    str1 := str1 + '      <oref:description>' + xrowbuf[5] + '</oref:description> ' + #13#10;
    str1 := str1 + '     </oref:address>' + #13#10;
    if utmv2 then
    begin
      if flCountry = '643' then
      begin
        if xrowbuf[1] <> '' then
          str1 := str1 + '</oref:UL>' + #13#10
        else
          str1 := str1 + '</oref:FL>' + #13#10;

      end
      else
      begin
        str1 := str1 + '</oref:FO>' + #13#10;
      end;
    end;

  end;
  Result := str1;

end;

function TFormStart.LoadQueryBarcode(const aStr, uid: string): boolean;
var
  XML: TXMLDocument;
  Child4, Child3, CHild5, Child6, Child2, Child1, Child: TDOMNode;
  ii, i: integer;
  S1: string;
  BottlingDate, TypeMark, serialmark, Numbermark, Comments, DocDate, DocNumber,
  sAlcCode: string;
  Query: string;
  st1: string;
  S: TStringStream;

begin

  S := TStringStream.Create(aStr);
  try
    S.Position := 0;
    // Обрабатываем полученный файл
    XML := nil;
    ReadXMLFile(XML, S); // XML документ целиком
  finally
    S.Free;
  end;

  Child := XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
    if Child.NodeName = 'ns:Document' then
    begin
      Child1 := child.FirstChild;
      while Assigned(Child1) do
      begin  // ns:Ticket
        if Child1.NodeName = 'ns:ReplyBarcode' then
        begin
          Child2 := child1.FirstChild;  // tc:DocType tc:DocId
          while Assigned(Child2) do
          begin
            if Child2.NodeName = 'bk:QueryNumber' then
            begin
              if Assigned(Child2.FirstChild) then
                DocNumber := Child2.FirstChild.NodeValue;
            end;             // tc:RegID
            if Child2.NodeName = 'bk:Date' then
            begin
              if Assigned(Child2.FirstChild) then
                DocDate := copy(Child2.FirstChild.NodeValue, 1, 10);
            end;
            if Child2.NodeName = 'bk:Marks' then
            begin
              Child3 := child2.FirstChild;
              while Assigned(Child3) do
              begin
                if Child3.NodeName = 'bk:Mark' then
                begin
                  Child4 := child3.FirstChild;
                  while Assigned(Child4) do
                  begin
                    if Child4.NodeName = 'bk:Type' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        TypeMark := Child4.FirstChild.NodeValue;
                    end;
                    if Child4.NodeName = 'bk:Rank' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        serialmark := Child4.FirstChild.NodeValue;
                    end;
                    if Child4.NodeName = 'bk:Number' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        Numbermark := Child4.FirstChild.NodeValue;
                    end;
                    if Child4.NodeName = 'bk:Barcode' then
                    begin
                      if Assigned(Child4.FirstChild) then
                        sAlcCode := Child4.FirstChild.NodeValue;
                    end;
                    Child4 := Child4.NextSibling;
                  end;
                end;
                Child3 := Child3.NextSibling;
              end;

            end;
            Child2 := Child2.NextSibling;
          end;
          // ====== Вносим в журнал ===========
          if ConnectDB() then
          begin
            Query := 'SELECT * FROM `doc30` WHERE `numdoc`="' + docnumber +
              '" AND `datedoc`="' + DocDate + '";';
            recbuf := DB_query(Query);
            rowbuf := db_next(recbuf);
            if rowbuf <> nil then
              Query := 'UPDATE `doc30` SET `pdf417`="' + sAlcCode +
                '"  WHERE `numdoc`="' + docnumber + '" AND `datedoc`="' + DocDate + '";'
            else
              Query :=
                'INSERT INTO `doc30` (`numdoc`,`datedoc`,`marktype`,`markserial`,`marknumber`,`pdf417`) VALUES ("'
                +
                DocNumber + '","' + DocDate + '","' + TypeMark + '","' + serialmark + '","' + Numbermark +
                '","' + sAlcCode + '");';

            //Query:='INSERT INTO `spformfix` (`numfix`, `datefix`,`alcitem`,`forma`,`crdate`,`ttnnumber`,`ttndate`) VALUES ('''+numfix+''','''+datefix+''','''+sAlcCode+''','''+forma+''','''+BottlingDate+''','''+TTNNumber+''','''+TTNDate+''');';
            // ==================================
            recbuf := DB_query(Query);
            DB_query('UPDATE `docjurnale` SET `status`="+++" WHERE `numdoc`="' +
              docnumber + '" AND `datedoc`="' + DocDate + '" AND `type`="QueryPDF417" ;');
          end;
        end;
        Child1 := Child1.NextSibling;
      end;

    end;
    Child := Child.NextSibling;
  end;

end;

// === загрузка сведений о товаре для внешней уч системы


function TFormStart.SaveShtrihMFile(const aDate, adate1: TDateTime;
  rmkId:string=''): string;
var
  i: integer;
  Query: string;
  sLine: TStringList;
  date1: string;
  ssection: string;
  fplu: string;
  strDate, strDate1: string;
  aHWKass:string;
begin
  if formStart.prefixClient='' then
    aHWKass:='1'
   else
    aHWKass:=formStart.prefixClient;
  if not (rmkId = '') then
     aHWKass:= rmkId;
  strDate := FormatDateTime('YYYY-MM-DD', aDate);
  strDate1 := FormatDateTime('YYYY-MM-DD', aDate1);
  sLine := TStringList.Create();
  sLine.Clear;
  Query := 'SELECT DATE_FORMAT(`datetrans`,"%T") AS `times1`,`typetrans`,`kassir`,`numcheck`,`plu`,`numsection`,`price`,`quantity`,`summ`,`plu`,DATE_FORMAT(`datetrans`,"%d.%m.%y") AS `dates1` FROM `doccash` WHERE (`datedoc`>="' + strDate + '" AND `datedoc`<="' + strDate1 + '") AND `typetrans`<>"155" AND (`kassir`="'+aHWKass+'" OR `numkass`="'+aHWKass+'") ;';
  recbuf := DB_Query(Query);
  rowbuf := DB_Next(recbuf);
  i := 1;
  sLine.Add('#');
  sLine.Add(PrefixClient);
  sLine.Add(getshiftcash());
  while rowbuf <> nil do
  begin
    date1 := rowbuf[0];
    strDate1 := rowbuf[10];
    ssection := '0';
    if rowbuf[5] <> '' then
      ssection := rowbuf[5];
    if rowbuf[4] = '0' then
      fplu := rowbuf[9]
    else
      fplu := rowbuf[4];
    sLine.Add(IntToStr(i) + ';' + strDate1 + ';' + date1 + ';' + rowbuf[1] +
      ';' + rowbuf[2] + ';' + rowbuf[3] + ';30;' + fplu + ';' + ssection + ';' +
      rowbuf[6] + ';' + rowbuf[7] + ';' + rowbuf[8]);
    rowbuf := DB_Next(recbuf);
    i := i + 1;
  end;
  if db_boolean(GetConstant('LoadExchMode')) then
    TLoadFS.ExchReport(sLine.Text);
  Result := sLine.Text;
end;

procedure TFormStart.reGenerationPLU();
// >>>> Автоформирование ПЛУ для товара на кассу
var
  i: longint;
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
  bc: string;
begin
  if (not fldisableutm) AND ( GetConstant('waybill_v3') = '' )  then begin
    Setwaybillv2();
    SetConstant('waybill_v3','+');
  end;

  if GetConstant('NumberSKU') = '' then
    i := 1
  else
    i := StrToInt(GetConstant('NumberSKU'));
  recbuf := db_query('SELECT `barcodes`FROM `sprgoods` WHERE `plu`="0" GROUP BY `barcodes`;');
  rowbuf := DB_Next(recbuf);
  while rowbuf <> nil do
  begin
    bc := rowbuf[0];
    xrecbuf := DB_QUery('SELECT `barcodes` FROM `sprgoods` WHERE `plu`="' +
      IntToStr(i) + '" GROUP BY `barcodes`;');
    xrowbuf := DB_Next(xrecbuf);
    while xrowbuf <> nil do
    begin
      i := i + 1;
      xrecbuf := DB_QUery('SELECT `barcodes` FROM `sprgoods` WHERE `plu`="' +
        IntToStr(i) + '" GROUP BY `barcodes`;');
      xrowbuf := DB_Next(xrecbuf);
    end;
    db_query('UPDATE `sprgoods` SET `plu`="' + IntToStr(i) + '" WHERE `barcodes`="' + bc + '";');
    i := i + 1;
    SetConstant('NumberSKU', IntToStr(i));
    rowbuf := DB_Next(recbuf);
  end;

  recbuf := db_query('SELECT `plu` FROM `sprgoods` WHERE `plu`<>"0" ORDER BY `plu` DESC;');
  rowbuf := DB_Next(recbuf);
  if rowbuf <> nil then
  begin
    if StrToInt(rowbuf[0]) > i then
      i := StrToInt(rowbuf[0]) + 1;
    SetConstant('NumberSKU', IntToStr(i));
  end;
  if GetConstant('visiblevisualfind') = '' then
    SetConstant('visiblevisualfind', '1');
  recbuf := db_query('SELECT `pincode` FROM `sprusers` ;');
  rowbuf := DB_Next(recbuf);
  if rowbuf = nil then
  begin
    db_Query(
      'INSERT INTO `sprusers` (`userid`,`name`,`fullname`,`pincode`,`interface`,`groupid`) VALUES ("30","Admin","Admin","0000","M","A");');
  end;
  recbuf := db_query(
    'SELECT `mysql`.`user`.`user` FROM `mysql`.`user` where `mysql`.`user`.`user`=''admin'' ;');
  rowbuf := DB_Next(recbuf);
  if rowbuf = nil then
  begin
    db_Query('CREATE USER ''admin''@''%'' IDENTIFIED BY ''admin'';');
    db_Query('GRANT ALL PRIVILEGES ON * . * TO ''admin''@''%'';');
    db_Query('FLUSH PRIVILEGES;');
  end;
  recbuf := db_query('SELECT `closecheck` FROM `doccash` WHERE `closecheck`=''1'' OR `closecheck`=''+'' ;');
  rowbuf := DB_Next(recbuf);
  if rowbuf=nil then begin
    DB_checkCol('doccash','closecheck','char(1)','');
    DB_Query('UPDATE `doccash` SET `closecheck`=''1'' ;');
  end;
end;

function TFormStart.GetBeginDoc(): string;
var
  str1: string;
  w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
begin
  Result := '';
  recbuf := DB_query(
    'SELECT `numdoc`,`datedoc`,DATE_FORMAT(`datestamp`,"%Y-%m-%d") FROM `docjurnale` WHERE `type`="WayBill" LIMIT 1');
  rowbuf := DB_Next(recbuf);
  if rowbuf <> nil then
  begin
    str1 := rowbuf[2];
    w := TFPHTTPClient.Create(nil);
    //formlogging.AddMessage('sms:'+s_alccode+'','>');
    try
      Result := w.Get('http://egais.retailika.ru/service/begindoc.php?inn=' +
        firminn + '&kpp=' + firmkpp + '&begindoc=' + str1);
    except
      // === ошибка при подключении
      Result := '';
    end;
    w.Free;
  end;
end;

{$I common/unitstart.inc}

end.
