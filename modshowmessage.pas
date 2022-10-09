unit modshowmessage;


{$mode objfpc}{$H+}

interface

uses
  Classes, forms, SysUtils;

  type

    { TModuleMercury }

  { TModshowmessage }

  TModshowmessage = class(TFORM)
    private

    public
      constructor create(aparent:tform);
      function ShowMess(aText:string;aButtonOk,aButtonCancel:boolean):boolean;
    end;


implementation
uses
  windows;

{ TModshowmessage }

constructor TModshowmessage.create(aparent:tform);
begin
  inherited create(nil);
  Parent:=aparent;
  align:=[alNone];
  borderstyle:=[bsNone];
  position:=poDesktopCenter;

end;

function TModshowmessage.ShowMess(aText: string; aButtonOk,
  aButtonCancel: boolean): boolean;
begin
  result:=false;
  if showmodal=1377 then
    result:=true;
end;

{ TModuleMercury }





end.

