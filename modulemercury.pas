unit modulemercury;


{$mode objfpc}{$H+}

interface

uses
  Classes, moduledb, SysUtils;

  type

    { TModuleMercury }

  TModuleMercury = class(TObject)
    private
      FUserMerc:string;
      FPassMerc:string;
      FServMerc:string;
      ModuleDB:TModuleDB;
      function GetMercury(param:string):string;
    public
      constructor create();
    end;


implementation
uses
  windows, dateutils,LConvEncoding,
  httpsend ,ssockets, ssl_openssl,sockets;

{ TModuleMercury }

function TModuleMercury.GetMercury(param: string): string;
var
  w: THTTPSend; // --- Стандартные средства обработки запросов к HTTP
begin
  w := THTTPSend.Create();
  try
    //Res := w.get('https://api2.vetrf.ru:8002/platform/services/2.0/DictionaryService');
    if w.HTTPMethod('GET','https://'+FUserMerc+':'+FPassMerc+'@'+FServMerc+'/'+param) then
     begin

       w.Document.Seek(0,soBeginning);
       result:=w.Document.ReadAnsiString;
     end;
  except
    // === ошибка при подключении
    Result := '';

  end;

  w.Free;
end;
constructor TModuleMercury.create;
begin
  inherited create();
end;


end.

