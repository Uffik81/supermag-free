unit unitframework;
// **********************************************************
//  FrameWork для конфигурируемой через схемы xml СУБД

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql50;

type
  // *** форматы записи ****
  TListOfvalues = record

  end;

  // *** запись справочник *** reference
  TDBReference = class
  private
    fNameTable:String;
    fColumeName:array of String;

  public
    constructor Create(aName:String);
    destructor Destroy();
  end;

var
  LocDBMySQL:PMYSQL;     // === Ссылка на СУБД =====
  LocNameFileCFG:String; // === Имя файла конфигурации =====

  function ConnectDB(mysqlurl,mysqluser,mysqlpassword,prefixdb:String):boolean;

implementation

uses DOM, XMLRead, typinfo;
var
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
  flLowConnect:boolean;
  prefixDB:string;
// *********** Базовые функции ************
function ConnectDB(mysqlurl,mysqluser,mysqlpassword,prefixdb:String):boolean;
var
  qmysql : st_mysql;
begin

 result:=false;
  try
  if LocDBMySQL=nil then begin
   LocDBMySQL:=mysql_init(PMYSQL(@qmysql));
   LocDBMySQL :=mysql_real_connect(LocDBMySQL,pChar(UTF8ToANSI(mysqlurl)),PChar(UTF8TOANSI(mysqluser)),Pchar(mysqlpassword),nil,3306,nil,0);
   if LocDBMySQL = nil then begin
     //ShowMessage(' Не могу подключиться к базе данных:'+mysqlurl);
     //close;
     exit;
   end;
   if mysql_select_db(LocDBMySQL,pChar('egais'+prefixdb)) < 0 then
   begin
     //ShowMessage(' Не могу создать транзакцию:'+mysql_error(LocDBMySQL));
    // Close;
     exit;
   end;
   if (mysql_query(LocDBMySQL,'SET NAMES utf8;') < 0) then begin
    //ShowMessage(' Не могу создать транзакцию:'+mysql_error(LocDBMySQL));
    //Close;
    exit;
   end;
 end;
  result:=true;
  except
    //ShowMessage(' Не могу подключиться к БД:'+mysqlurl);
  end;

end;

procedure disconnectDB();
begin
 if recbuf<>nil then
   mysql_free_result(recbuf);
 recbuf    :=nil;
 if not flLowConnect then begin
   if LocDBMySQL<>nil then
     mysql_close(LocDBMySQL);
   LocDBMySQL :=nil;
 end;
end;

function DB_query(const sSQL:String):PMYSQL_RES;
begin
  if LocDBMySQL = nil then
    begin
      result:=nil;
      exit;
    //ConnectDB();
    end;

  if LocDBMySQL <> nil then begin
      if (mysql_query(LocDBMySQL,PChar(sSQL) )<0 ) then begin
        DisconnectDB();
        result:=DB_query(sSQL);
      end

      else
       result:= mysql_store_result(LocDBMySQL);
    end
  else
    result:=nil;
end;

function DB_Next(aRes:PMYSQL_RES):MYSQL_ROW;
begin
  if aRes = nil then
    result := nil
  else
    result := mysql_fetch_row(aRes);
end;

function DB_checkTable(aTable:String):boolean;
begin
  //SHOW DATABASES;
  // CREATE DATABASE `text1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
  result:=false;
  recbuf:=DB_query('SHOW TABLES FROM `egais'+prefixDB+'` LIKE '''+aTable+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf <> nil then
    result:=true;
end;

function DB_checkCol(aTable,aCol,aType,aSize:String):boolean;
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
              DB_query('ALTER TABLE `'+aTable+'` CHANGE `'+aCol+'` `'+aCol+'` '+aType+' NOT NULL ;')
             else result:=false;
       end else
            DB_query('ALTER TABLE `'+aTable+'` ADD `'+aCol+'` '+aType+' NOT NULL ;');
   end
    else begin
      DB_query('CREATE TABLE `'+aTable+'` (`'+aCol+'` '+aType+' NOT NULL ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
      result:=true
    end;
end;

procedure SetConstant(const aName, aValue:String);
begin
  recbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`='''+aName+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf<>nil then
    recbuf :=DB_Query('UPDATE `const` SET `value`='''+aValue+''' WHERE `name`='''+aName+''';')
   else
     recbuf :=DB_Query('INSERT INTO `const` (`name`,`value`) VALUE ('''+aName+''','''+aValue+''');');
end;

function  GetConstant(aName:String):String;
begin
  recbuf := DB_Query('SELECT `value` FROM `const` WHERE `name`='''+aName+''';');
  rowbuf := DB_Next(recbuf);
  if rowbuf<>nil then
      result:=rowbuf[0]
    else
      result:='';
end;

// *********** reference ******************
constructor TDBReference.Create(aName:String);
begin
  fNameTable:=aName;
  SetLength(fColumeName,20);

end;
destructor TDBReference.Destroy();
begin
end;

end.

