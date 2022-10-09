unit frameworkmodules;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql50;

type


  { TFWDataBase }

  TFWDataBase = class(TObject)
    FSockMySQL : PMYSQL;
    Fqmysql : st_mysql;
  public
    prefixdb:String;
    constructor Create;
    Destructor Destroy; override;
    procedure ConnectDB;
    procedure CreateBD;
    function Query(const sSQL:String):PMYSQL_RES;
    function Next(aRes:PMYSQL_RES):MYSQL_ROW;
    function checkTable(aTable:String):boolean;
    procedure ClearBuf(aRes:PMYSQL_RES);
    function checkCol(aTable,aCol,aType,aSize:String; aDefault:string=''):boolean;
  end;

  { TFWEnumItems }

  TFWEnumItems = class(TObject)
  private

    Frowbuf : MYSQL_ROW;
    Frecbuf : PMYSQL_RES;
    FFWDateBase:TFWDataBase;
    procedure clearBuf;
  protected

  public
    Constructor Create(FWDataBase:TFWDataBase);
    Destructor destroy;  override;
    procedure CheckTable; virtual;
    function QueryFind(aQuery:String):boolean; virtual;
    function NextItem:boolean; virtual;
  end;

  { TFWEnumAlcProduct }

  TFWEnumAlcProduct = class(TFWEnumItems)
  protected
  private
    FColNames:array[0..10] of string;
  public
    procedure CheckTable;
    constructor Create(FWDataBase:TFWDataBase);
    function QueryFind(aQuery:String):boolean;
    function NextItem:boolean;
  end;

implementation

{ TFWEnumAlcProduct }

procedure TFWEnumAlcProduct.CheckTable;
begin
  FFWDateBase.checkCol('spproduct','AlcCode','varchar(20)','');
  FFWDateBase.checkCol('spproduct','egaisname','varchar(512)','');
  FFWDateBase.checkCol('spproduct','name','varchar(512)','');
  FFWDateBase.checkCol('spproduct','Import','varchar(1)','');
  FFWDateBase.checkCol('spproduct','Capacity','varchar(10)','');
  FFWDateBase.checkCol('spproduct','AlcVolume','varchar(10)','');
  FFWDateBase.checkCol('spproduct','ProductVCode','varchar(3)','');
  FFWDateBase.checkCol('spproduct','ClientRegId','varchar(20)','');
  FFWDateBase.checkCol('spproduct','IClientRegId','varchar(20)','');
  FFWDateBase.checkCol('spproduct','listbarcode','varchar(512)','');
  FFWDateBase.checkCol('spproduct','unpacked','varchar(1)',''); // ==== без упаковки / разливное

end;

constructor TFWEnumAlcProduct.Create(FWDataBase: TFWDataBase);
begin
  inherited create( FWDataBase);
  //FColNames:=('AlcCode','egaisname','name','Import','Capacity','AlcVolume','ProductVCode','ClientRegId','IClientRegId','unpacked');
end;

function TFWEnumAlcProduct.QueryFind(aQuery: String): boolean;
var
  Query:string;
begin
  clearBuf;
  result:=false;
  Query:='SELECT `AlcCode`,`egaisname`,`name`,`Import`,`Capacity`,`AlcVolume`,`ProductVCode`,`ClientRegId`,`IClientRegId`,`unpacked` FROM `spproduct` ';
  if aQuery<>'' then
    Query:=Query+' WHERE '+aQuery+';';
  fRecBuf:= FFWDateBase.Query(Query);
  frowbuf:= FFWDateBase.Next(frecbuf);
  if fRowBuf<>nil then begin
    result:=true;
  end else begin
    clearBuf;
    result:=false;
  end;
end;

function TFWEnumAlcProduct.NextItem: boolean;
begin

  inherited NextItem;
end;

{ TFWDataBase }

constructor TFWDataBase.Create;
begin
  inherited Create;

end;

destructor TFWDataBase.Destroy;
begin

end;

procedure TFWDataBase.ConnectDB;
begin

end;

procedure TFWDataBase.CreateBD;
begin

end;

function TFWDataBase.Query(const sSQL: String): PMYSQL_RES;
var
  errno:integer;
  errstr:string;
begin
  if FsockMySQL = nil then
    ConnectDB()
  else begin
   if mysql_ping(FsockMySQL) <> 0 then begin
      FsockMySQL:=nil;
      connectDB();
   end;

  end;

  if FsockMySQL <> nil then begin
      if (mysql_query(FsockMySQL,PChar(sSQL) )<0 ) then begin
        errno:=mysql_errno(FsockMySQL);
        errstr:=mysql_error(FsockMySQL);
        //showmessage('Ошибка СУБД ['+inttostr(errno)+']:'+errstr );
        //DisconnectDB();
        result:=query(sSQL);
      end
      else
       result:= mysql_store_result(FsockMySQL);
    end
  else
    result:=nil;

end;

function TFWDataBase.Next(aRes: PMYSQL_RES): MYSQL_ROW;
begin
  if aRes = nil then
    result := nil
  else
    result := mysql_fetch_row(aRes);
end;

function TFWDataBase.checkTable(aTable: String): boolean;
var
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
begin
  result:=false;
  recbuf:=query('SHOW TABLES FROM `egais'+prefixDB+'` LIKE '''+aTable+''';');
  rowbuf := Next(recbuf);
  if rowbuf <> nil then
    result:=true;
end;

procedure TFWDataBase.ClearBuf(aRes: PMYSQL_RES);
begin

end;

function TFWDataBase.checkCol(aTable, aCol, aType, aSize: String;
  aDefault: string): boolean;
var
  s1:string;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
begin
  result:=true ;
  if checkTable(aTable) then begin
     s1:= 'SHOW COLUMNS FROM `'+aTable+'` LIKE "'+aCol+'";';
     recbuf:=Query(s1);
     rowbuf:=Next(recbuf);
     if rowbuf<>nil then begin
            s1:=rowbuf[1];
            if pos(aType,s1)<=0 then
              query('ALTER TABLE `'+aTable+'` CHANGE `'+aCol+'` `'+aCol+'` '+aType+' NOT NULL '+aDefault+';')
             else result:=false;
       end else
            query('ALTER TABLE `'+aTable+'` ADD `'+aCol+'` '+aType+' NOT NULL '+aDefault+';');
   end
    else begin
      query('CREATE TABLE `'+aTable+'` (`'+aCol+'` '+aType+' NOT NULL ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
      result:=true
    end;

end;

{ TFWEnumItems }

procedure TFWEnumItems.clearBuf;
begin
  if FRecBuf<>nil then
     FFWDateBase.ClearBuf(FrecBuf);
  FRecBuf:=nil;
end;

constructor TFWEnumItems.Create(FWDataBase: TFWDataBase);
begin
  inherited Create;
  FRecbuf:=nil;
  FRowBuf:=nil;
  if FWDataBase <>nil then
    FFWDateBase:= FWDataBase
    else begin
     FFWDateBase:= TFWDataBase.Create;
    end;
end;

destructor TFWEnumItems.destroy;
begin

end;

procedure TFWEnumItems.CheckTable;
begin

end;

function TFWEnumItems.QueryFind(aQuery: String): boolean;
begin

end;

function TFWEnumItems.NextItem: boolean;
begin
  result:=true;
  FRowBuf:=  FFWDateBase.Next(FRecBuf);
  if FRowBuf = nil then
   result:=false;
end;

end.

