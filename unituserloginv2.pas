unit unituserloginv2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFormUserLoginv2 }

  TFormUserLoginv2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Image1: TImage;
    Panel1: TPanel;
    pnlStatusBar: TPanel;
    pLogin: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    stError: TStaticText;
    stOnline: TStaticText;
    stCurrentUser: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pLoginClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    bgImg1:TPicture;
    flTypeInterface:string;
    flCurPass:string;
    flCurcard:string;
    flUserId:string;
    flCloseForm:boolean;
    flBlockForm:boolean;
    function AuthUser():string;
    procedure showv2;
  end;

var
  FormUserLoginv2: TFormUserLoginv2;

implementation
uses
  unitStart,
  unitsalesbeerts,
  unitsalesbeer,
  unitjurnalets,
  mysql50,
  unitShowMessage;
{$R *.lfm}

{ TFormUserLoginv2 }

procedure TFormUserLoginv2.FormResize(Sender: TObject);
begin
  // развернуть на весь экран
  self.WindowState:=wsMaximized;
end;

procedure TFormUserLoginv2.FormShow(Sender: TObject);
begin
  image1.AutoSize:=false;
  image1.Stretch:=true;
  if Width < Image1.Width then
    image1.Width:=image1.Width-200;

  StaticText1.SetFocus;
end;

procedure TFormUserLoginv2.pLoginClick(Sender: TObject);
begin

end;

procedure TFormUserLoginv2.BitBtn3Click(Sender: TObject);
begin
  stError.Caption:='';

  flCurPass:=flCurPass+inttostr((Sender AS TBitBtn).tag);
  staticText1.Caption:=staticText1.Caption+'*';
  if length(flCurPass)>=4 then
    BitBtn12Click(nil);
end;

procedure TFormUserLoginv2.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  cLoseAction:=caHide;
end;

procedure TFormUserLoginv2.FormCreate(Sender: TObject);
begin
  //BGimg1:=TPicture.Create;
  //BGimg1.LoadFromFile('bgr1.jpg');
end;

procedure TFormUserLoginv2.FormDestroy(Sender: TObject);
begin
  BgImg1.Free;
end;

procedure TFormUserLoginv2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=0;
end;

procedure TFormUserLoginv2.FormKeyPress(Sender: TObject; var Key: char);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  if key=#13 then
    begin

      key:=#0;
      xrecbuf:=formstart.db_query('SELECT `userid`,`interface` FROM `sprusers` WHERE `password`="'+flCurcard+'" or `barcodes`="'+flCurcard+'";');
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf<>nil then
        begin
          flCurPass:='';
          flCurCard:='';
          flUserId:=xrowbuf[0];
          flTypeInterface:=xrowbuf[1];
          modalresult:=1377;
        end else begin
          flCurPass:='';

          flUserId:='';
          stError.Caption:='Ошибка авторизации!';
          BitBtn10Click(nil);
        end;
    end else
    begin
          if key in ['0'..'9','a'..'Z'] then begin
      staticText1.caption:= staticText1.caption+'*';
      flCurcard:=flCurcard+key;
      key:=#0;
      end;
    end;
    key:=#0;
end;

procedure TFormUserLoginv2.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  if key = 13 then
    begin

      key:=0;
      xrecbuf:=formstart.db_query('SELECT `userid`,`interface` FROM `sprusers` WHERE `password`="'+flCurcard+'" OR `barcodes`="'+flCurcard+'";');
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf<>nil then
        begin
          flCurPass:='';
          flCurCard:='';
          flUserId:=xrowbuf[0];
          flTypeInterface:=xrowbuf[1];
          modalresult:=1377;
        end else begin
          stError.Caption:='Ошибка авторизации!';
          flCurPass:='';
          staticText1.caption:='';
          flUserId:='';
          flCurcard:='';

          BitBtn10Click(nil);
        end;
    end else
    begin
      if chr(lo(key)) in ['0'..'9','a'..'Z'] then begin
        staticText1.caption:= staticText1.caption+'*';
        flCurcard:=flCurcard+chr(lo(key));
        key:=0;
      end;
    end;
   // key:=#0;
end;

procedure TFormUserLoginv2.FormPaint(Sender: TObject);
begin
  //self.Canvas.StretchDraw(rect(0,0,width,height),BGimg1.Graphic);
  //pLogin.Canvas.Draw(0,0,BGimg1.Graphic);
end;

procedure TFormUserLoginv2.BitBtn10Click(Sender: TObject);
begin
  flCurPass:='';
  flCurCard:='';
  flTypeInterface:='';
  staticText1.Caption:='';
end;

procedure TFormUserLoginv2.BitBtn12Click(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  xrecbuf:=formstart.db_query('SELECT `userid`,`interface` FROM `sprusers` WHERE `pincode`="'+flCurPass+'"');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
    begin
      flCurPass:='';
      flUserId:=xrowbuf[0];
      flTypeInterface:=xrowbuf[1];
      modalresult:=1377;
     // close;
    end else begin
      flCurPass:='';
      flUserId:='';
      stError.Caption:='Ошибка авторизации!['+flCurPass+']';
      BitBtn10Click(nil);
    end;
end;

procedure TFormUserLoginv2.BitBtn13Click(Sender: TObject);
var
  res:integer;
begin
  //res:=FormShowMessage.ShowYesNo('Выйти из программы.');
  if FormShowMessage.ShowYesNo('Выйти из программы.') then begin
    flCloseForm:=true;
    formstart.Close;
    modalresult:=1377;
  end;

end;

function TFormUserLoginv2.AuthUser: string;
begin
  result:='';
  if self.showmodal =1377 then
    result:=flUserId;
end;

procedure TFormUserLoginv2.showv2;
begin
  flCloseForm:=false;
  flBlockForm:=false;
  while not flCloseForm do begin
    flCurPass:='';
    flCurCard:='';
    flTypeInterface:='';
    staticText1.Caption:='';
    formStart.flCurUserId:=AuthUser;
    if formStart.flCurUserId <> '' then
      begin
          begin
            FormSalesBeerTS.clearcheck();
            FormSalesBeerTS.showmodal;
          end;
      end;
  end;

end;

end.

