unit unitsetpdf417;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormSetPDF417 }

  TFormSetPDF417 = class(TForm)
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    stAlcValue: TStaticText;
    StaticText5: TStaticText;
    stQual: TStaticText;
    stDal: TStaticText;
    stBarcode: TStaticText;
    stName: TStaticText;
    StaticText2: TStaticText;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    flName:string;
    flbarCode:string;
    flPDF417:String;
    flAlcCode:String;
    flAlcVolume:String;
    flPrice:String;
    flProductVCode:String;
    flCapacity:String;
    flReturn:boolean;
    function getpdf417():boolean;
    function controlpdf417(aPDF417:string):integer;
  end;

var
  FormSetPDF417: TFormSetPDF417;

implementation

{$R *.lfm}
uses unitstart,mysql50,unitsalesbeerts;

function TFormSetPDF417.controlpdf417(aPDF417:string):integer;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  Query:='SELECT `quantity` from `doccash` WHERE UPPER(`urlegais`)=UPPER("'+aPDF417+'");';
  xrecbuf:=FormStart.DB_Query(Query);
  ares:=0;
  result:=0;
  xrowbuf:=FormStart.db_next(xrecbuf);
  while xrowbuf<>nil do begin
     if xrowbuf[0]='1' then ares:=ares+1;
     if xrowbuf[0]='-1' then ares:=ares-1;
     xrowbuf:=FormStart.db_next(xrecbuf);
  end;
  result:=ares;

end;

procedure TFormSetPDF417.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormSetPDF417.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFormSetPDF417.FormKeyPress(Sender: TObject; var Key: char);
var
  con1:integer;
begin
//  if key<>#13 then begin
//   if key in ['A'..'Z','0'..'9'] then
//     flPDF417:=flPDF417+key;
///   end
//  else
  if key=#13 then begin

    flPDF417:=trim(flPDF417);
    if Length(flPDF417)>150 then
      begin  // если имеется суффикс
        formsalesbeerts.FRBeep;
        ShowMessage('Акцизная марка - длинее ожидаемого ШК.('+inttostr(Length(flPDF417))+')');
        flPDF417:='';
        modalresult:=0;
        key:=#0;
        exit;
      end;
    {
    if Length(flPDF417)>68 then
      begin  // если имеется суффикс
        formsalesbeerts.FRBeep;
        ShowMessage('Акцизная марка - длинее ожидаемого ШК.('+inttostr(Length(flPDF417))+')');
        flPDF417:='';
        modalresult:=0;
        key:=#0;
        exit;
      end;  }
    if Length(flPDF417)<68 then
      begin
        formsalesbeerts.FRBeep;
        ShowMessage('Акцизная марка  - короче ожидаемого ШК.('+inttostr(Length(flPDF417))+')');
        flPDF417:='';
        modalresult:=0;
        key:=#0;
        exit;
      end;
    con1:=controlpdf417(flPDF417);
    if flReturn and (con1=1) then begin
      key:=#0;
      self.ModalResult:=1377;

    end else begin
       if (con1<>0)and(not flReturn) then begin
          formsalesbeerts.FRBeep;
          showmessage('Товар с такой акцизной маркой уже продавался, отложите ее для разбирательст!');
          flPDF417:='';
          key:=#0;
          Modalresult:=0;

       end else begin
           if flreturn then begin
              formsalesbeerts.FRBeep;
              showmessage('Товар с такой акцизной маркой не продавался, невозможно вернуть!');
              flPDF417:='';
              key:=#0;
              self.Modalresult:=0;
              close;
             end
             else begin
           key:=#0;
           self.ModalResult:=1377;
          end;
        end;


    end;

  end;

  key:=#0;

end;

procedure TFormSetPDF417.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key<96) and (key>32) then  begin
    if (flPDF417='')and( char(lo(key)) in ['0'..'9'] ) then
      flPDF417:=flPDF417+char(lo(key))
      else begin
        if (flPDF417<>'') and (length(flPDF417)<150) then
          flPDF417:=flPDF417+char(lo(key));
      end;
   key:=0;
  end;
end;

function TFormSetPDF417.getpdf417():boolean;
var
  res:integer;
  resQ:string;
  ResQi:integer;
begin
  result:=false;
  flPDF417:='';
  stName.Caption:=flName;
  stBarcode.Caption:=flBarcode;
  stDal.Caption:=flCapacity+' л.';
  stAlcValue.Caption:=flAlcVolume+'%';
  formstart.recbuf:= formstart.DB_query(
  'SELECT SUM(`Quantity`),( SELECT `quantity` FROM `doccash` WHERE `doccash`.`AlcCode`=`regreservshop`.`AlcCode` AND `datedoc`>="'+FormStart.GetConstant('finupdaterestshop')+'" LIMIT 1) as `countitem`   FROM `regreservshop`  WHERE `AlcCode`="'+flAlcCode+'";');
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  if formstart.rowbuf<> nil then begin
    resQ:='0';
    if formstart.rowbuf[0]<>'' then
       resQ:= formstart.rowbuf[0];
    resQi:=  strtoInt(resQ);
    resQ:='0';
    if formstart.rowbuf[0]<>'' then
       resQ:= formstart.rowbuf[1];
    resQi:= resQi - strtoInt(resQ);
    stQual.Caption:=inttostr(resQi);
  End;
  res:=showmodal;
  if res = 1377 then begin
    if (Length(flPDF417) = 68)or(Length(flPDF417)=150) then  // проверка на размер кода
       result:=true
      else
       showmessage('Неверная длина акцизы:'+inttostr(Length(flPDF417)));
  end;


end;

end.

