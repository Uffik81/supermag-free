unit moduledb;

{$mode objfpc}{$H+}

interface

uses
  Classes, mysql50, SysUtils;

type
  { TModuleDB }

  TModuleDB = class(TObject)
  private
    FRecBuf:PMYSQL_RES;
    FRowBuf:MYSQL_ROW;
    SockMySQL: PMYSQL;
    qmysql: st_mysql;
    FprefixDB:String;
    FUserName:string;
    FPassword:string;
    Fmysqlurl:string;

    function ConnectDB(): boolean;
    procedure disconnectDB();

    function GetAsString(aItems:integer):string;
    procedure SetPrefixDB(aValue:string);
  public
    property prefixDB:string read FprefixDB write SetPrefixDB;
    property AsString[AIndex:integer]:string read GetAsString;
    constructor Create(const mysqlurl,User,password:string);
    function NextRecord:boolean;
    function SelectRec(aCols:String;aTable:String;aWhere:string):boolean;
    function GetConstant(aName: string): string;
    procedure SetConstant(const aName, aValue: string);
    function DB_query(const sSQL: string): PMYSQL_RES;
    function DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
  end;


implementation
uses
  windows, dateutils,LConvEncoding;

{ TModuleDB }


function TModuleDB.GetConstant(aName: string): string;
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

procedure TModuleDB.SetConstant(const aName, aValue: string);
var
  xrowbuf: MYSQL_ROW;
  xrecbuf: PMYSQL_RES;
begin
  xrecbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`=''' + aName + ''';');
  xrowbuf := DB_Next(xrecbuf);
  if xrowbuf <> nil then
    DB_Query('UPDATE `const` SET `value`=''' + aValue +
      ''' WHERE `name`=''' + aName + ''';')
  else
    DB_Query('INSERT INTO `const` (`name`,`value`) VALUE (''' +
      aName + ''',''' + aValue + ''');');
   mysql_free_result(xrecbuf);
end;

function TModuleDB.ConnectDB: boolean;
begin

    Result := False;
    try
      if SockMySQL = nil then
      begin
        SockMySQL := mysql_init(PMYSQL(@qmysql));
        SockMySQL := mysql_real_connect(SockMySQL, PChar(UTF8ToANSI(Fmysqlurl)),
          PChar(UTF8TOANSI(FUserName)), PChar(FPassword), nil, 3306, nil, 0);
        if SockMySQL = nil then
        begin
//          ShowMessage(' Не могу подключиться к базе данных:' + Fmysqlurl);
          exit;
        end;

        if (mysql_query(sockMySQL, 'SET NAMES utf8;') < 0) then
        begin
//          ShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
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
//          ShowMessage(' Не могу создать транзакцию:' + mysql_error(sockMySQL));
          exit;
        end;
      end;
      if (mysql_ping(SockMySQL) < 0) then
      begin
//        ShowMessage('Потеряно подключение:' + mysql_error(sockMySQL));
        exit;
      end
      else
      begin

      end;
      Result := True;
    except
//      ShowMessage(' Не могу подключиться к БД:' + FormStart.mysqlurl);
    end;

end;

procedure TModuleDB.disconnectDB;
begin
  if SockMySQL <> nil then
    mysql_close(sockMySQL);
  SockMySQL := nil;
end;

function TModuleDB.DB_query(const sSQL: string): PMYSQL_RES;
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
//      ShowMessage('Ошибка СУБД [' + IntToStr(errno) + ']:' + errstr);
      DisconnectDB();
      Result := DB_query(sSQL);
    end
    else
      Result := mysql_store_result(sockMySQL);
  end
  else
    Result := nil;


end;

function TModuleDB.DB_Next(aRes: PMYSQL_RES): MYSQL_ROW;
begin
  if aRes = nil then
    Result := nil
  else
    Result := mysql_fetch_row(aRes);
end;

function TModuleDB.GetAsString(aItems: integer): string;
begin
  result:=FRowBuf[aItems];
end;

procedure TModuleDB.SetPrefixDB(aValue: string);
begin
  FPrefixDB:=aValue;
  ConnectDB();
end;

constructor TModuleDB.Create(const mysqlurl, User, password: string);
begin
  Fmysqlurl:=mysqlurl;
  FUsername:=user;
  FPassword:=password;
  inherited Create();
end;

function TModuleDB.NextRecord: boolean;
begin

  Frowbuf := DB_Next(Frecbuf);
  result:= FRowBuf <> nil ;
  if FRowBuf = nil then
    mysql_free_result(Frecbuf);
end;

function TModuleDB.SelectRec(aCols: String; aTable: String; aWhere: string
  ): boolean;
begin
   FRecBuf:=DB_Query('SELECT '+aCols+' FROM '+aTable+' WHERE ' + aWhere + ';');
   result:=NextRecord;
end;


end.

