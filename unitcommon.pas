unit unitcommon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  {
  DB_checkCol('spproducer','ClientRegId','varchar(20)','');
  DB_checkCol('spproducer','FullName','varchar(120)','');
  DB_checkCol('spproducer','inn','varchar(12)','');
  DB_checkCol('spproducer','kpp','varchar(9)','');
  DB_checkCol('spproducer','ShortName','varchar(50)','');
  DB_checkCol('spproducer','description','varchar(266)','');
  DB_checkCol('spproducer','region','varchar(3)','');
  DB_checkCol('spproducer','Country','varchar(3)','');
  DB_checkCol('spproducer','Active','int(1)','');
  DB_checkCol('spproducer','typeproducer','varchar(8)','');
  // === адрес лицензиата ===
  DB_checkCol('spproducer','liter','varchar(512)','');
  DB_checkCol('spproducer','sity','varchar(64)','');
  DB_checkCol('spproducer','area','varchar(64)','');  // ==== район
  DB_checkCol('spproducer','locality','varchar(64)','');  // === населенный пункт
  DB_checkCol('spproducer','street','varchar(64)','');  // === населенный пункт
  DB_checkCol('spproducer','home','varchar(5)','');
  DB_checkCol('spproducer','homecorpus','varchar(5)','');
  DB_checkCol('spproducer','room','varchar(5)','');
  DB_checkCol('spproducer','indexregion','varchar(8)','');
  DB_checkCol('spproducer','addressimns','varchar(512)','');
  }
  T_product = record
    type_product:integer;
    name_product:string;
    alc_code:string;
    form_f1:string;
    form_f2:string;
    fix_mark:string;
    waybill_date:string;
    waybill_num:string;
    waybill_id:string;
    plu:string;
    bar_code:string;
    price:string;
  end;

  TSprProducer = record
    shortname:string;
    fullname:string;
    ClientRegId:string;
    inn:string;
    kpp:string;
    description:string;
    region:string;
    country:string;
    typeproducer:integer; {1- розница, 2 - оптовый склад , 3 или 0 - производитель\ импортер, 4 - импортный производитель}
    zip:string;
    active:boolean;
  end;

  {>>>> TCustomReportDB <<<<}

  { TItemDataBase }

  TItemDataBase = class(TObject)
    FNameColumns:TstringList;
  private
  public
    procedure valid_columns();
    procedure add_column(colName:string);
    procedure set_value(colName:string;avalue:string);
    function get_value(colName:string):string;
  end;

  { TCoreDataBase }
  TCoreDataBase = class(TObject)
  private
    FErrorMessage:string;
    FErrorCode:string;

  public
    function OpenDB(const hostname,login,password,namedb:string):boolean;
  end;

  function GetDeviceId():string;

  {$IFDEF UNIX}

  {$ELSE}
  {$ENDIF}

implementation

uses
  {}
  nb30,
  mysql50, fphttpclient;
{$IFDEF UNIX}
function GetDeviceId: string;
begin
  result:='1';
end;
{$ELSE}
{Определяем ИД Устройства}
function GetAdapterlnfo(Lana: byte):string;
  var
    Adapter: ADAPTER_STATUS;
    NCB: _NCB;
    res:string;
    begin
      FillChar(NCB, SizeOf(NCB), 0);
      //Обнуление LANA. В NetBIOS, прежде чем использовать любой
      //  LANA, его надо обнулить. Для этого вызывается  процедура
      // NbReset, в которой выполня¬ется NetBIOS-команду NCB_RESET
      NCB.ncb_command:= NCBRESET;
      NCB.ncb_lana_num:= Lana;
      if NetBios(@NCB) <> NRC_GOODRET then
      begin
        result:='-';
        Exit;
      end;
      //Получение информации об адаптере
      	FillChar(NCB, SizeOf(NCB), 0); NCB.ncb_command := NCBASTAT;
      NCB.ncb_lana_num := Lana;
      NCB.ncb_callname[0] :=ord('*');
      FillChar(Adapter, SizeOf(Adapter), 0);
      NCB.ncb_buffer := @Adapter;
      NCB.ncb_length:= SizeOf(Adapter);
      if NetBios(@NCB) <> NRC_GOODRET then
      begin
        result:='-';
        Exit;
      end;

    // Формирование аппаратного адреса для вывода на экран
      res:=
        IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[5]), 2);
        result:=res;

end;

function GetDeviceId: string;
var
  AdapterList: TLANA_ENUM;
  NCB: _NCB;
  i :byte;
begin
  result:='-';
  FillChar(NCB, SizeOf(NCB), 0);
  //Определение доступных сетевых устройств
//Заполнение структура NCB
  NCB.ncb_command:= NCBENUM;
  NCB.ncb_buffer:= @AdapterList;
  NCB.ncb_length:= SizeOf(AdapterList);
  Netbios(@NCB);
  if Byte(AdapterList.length) < 0 then
    exit;
  for i:=0 to Byte(AdapterList.length)-1 do begin
     result:= GetAdapterlnfo(AdapterList.lana[i]) ;
  end;

end;



{$ENDIF}

{ TItemDataBase }

procedure TItemDataBase.valid_columns();
begin

end;

procedure TItemDataBase.add_column(colName: string);
begin

end;

procedure TItemDataBase.set_value(colName: string; avalue: string);
begin

end;

function TItemDataBase.get_value(colName: string): string;
begin

end;

{ TCoreDataBase }

function TCoreDataBase.OpenDB(const hostname, login, password, namedb: string
  ): boolean;
begin
  result:=true;
end;

end.

