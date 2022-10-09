unit unitRegClient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons;

type

  { TFormRegclient }

  TFormRegclient = class(TForm)
    BitBtn1: TBitBtn;
    cbCloud: TComboBox;
    edINN: TEdit;
    edFirmKPP: TEdit;
    edEmail: TEdit;
    edClientRegId: TEdit;
    edProdukey: TEdit;
    EdNameFirm: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    strealtor: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbCloudChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure strealtorClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flBeginInstall:boolean;
    flCloud:String;
    fluiddb:String;
    flFreeLic:boolean;
    function regActivation():boolean;
  end;

var
  FormRegclient: TFormRegclient;

implementation
uses fphttpclient, unitstart, LCLIntf,INIFiles;
{$R *.lfm}

{ TFormRegclient }

procedure TFormRegclient.FormCreate(Sender: TObject);
begin
   self.flBeginInstall:=true;
   self.fluiddb:=formStart.getconstant('guid');
   self.flCloud:= formStart.GetConstant('cloudservice');
   if self.flCloud = '' then
      cbCloud.Text:='(По умолчанию)';
end;

procedure TFormRegclient.BitBtn1Click(Sender: TObject);
var
 i:integer;
 w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
 resp:TStringList;
 res1:String;
 Fini:TIniFile;
begin
  FIni:=TIniFile.Create('egaismon.ini');
  res1:='';
   if edINN.Text = '' then
     res1:='ИНН';
   //if (edfirmkpp.text = '')and(length(edINN.Text)<12) then
   //  res1:='КПП';
   if edNameFirm.text = '' then
     res1:='наименование организации';
   if (edClientregid.text = '') and (not self.flFreeLic) then
     res1:='код клиента в ЕГАИСе';
   if edemail.text = '' then
     res1:='электронная почта';
   if res1<>'' then
     begin
       showmessage('Не указан обязательное поле '+res1+'. Регистрация невозможна!');
       exit;
     end;
   Fini.WriteString('GLOBAL','firmShortname',edNameFirm.Text);
   Fini.WriteString('GLOBAL', 'mysqlurl', formstart.mysqlurl);
   Fini.WriteString('GLOBAL', 'mysqluser', formstart.mysqluser);
   Fini.WriteString('GLOBAL', 'mysqlpassword', formstart.mysqlpassword);
   formstart.FirmFullName := edNameFirm.Text;
   Fini.WriteString('GLOBAL', 'firmname', formstart.FirmFullName);
   Fini.WriteString('GLOBAL', 'version', formstart.curVersion);
   Fini.WriteString('GLOBAL', 'reportversion', formstart.curVerReport);
   formstart.FirmINN := edINN.Text;
   Fini.WriteString('GLOBAL', 'inn', formstart.FirmINN);
   formstart.Firmkpp := edFirmKPP.Text;
   Fini.WriteString('GLOBAL', 'kpp', formstart.Firmkpp );
   //formstart.FirmAddress :=
   //Fini.ReadString('GLOBAL', 'address', formstart.FirmAddress);
   Fini.Destroy;
   FormStart.SetConstant('email',edemail.Text); // 195.133.201.27
   case cbCloud.Text of
     '(По умолчанию)':begin

    w:= TFPHTTPClient.Create(nil);
    //www.retailika.ru/users/adduserfree.php
    resp:=TStringList.Create;
    try
      resp.Clear;
      resp.Add('inn='+edINN.Text);
      resp.Add('kpp='+edfirmkpp.text);
      resp.Add('name='+edNameFirm.Text);
      resp.Add('fsrarid='+edClientregid.Text);
      resp.Add('email='+edemail.Text);
      res1:=w.FormPost('http://egais.retailika.ru/users/adduserpo.php',resp);
      resp.free;
      w.free;
      if res1='{OK}' then
      begin
        showmessage('Регистрация пользователя проведена!');
        modalresult:=1377;
      end else begin
        showmessage('Регистрация невозможна по причине:'+res1);
        modalresult:=0;
      end;
    except
      showmessage('Нет доступа к интернет!');
      modalresult:=0;
    end;
    formstart.Setconstant('typelicense','0');
   end;
     'www.retailika.ru':begin

    w:= TFPHTTPClient.Create(nil);
    //www.retailika.ru/users/adduserfree.php
    resp:=TStringList.Create;
    try
      resp.Clear;
      resp.Add('inn='+edINN.Text);
      resp.Add('kpp='+edfirmkpp.text);
      resp.Add('name='+edNameFirm.Text);
      resp.Add('fsrarid='+edClientregid.Text);
      resp.Add('email='+edemail.Text);
      res1:=w.FormPost('http://egais.retailika.ru/users/adduserpo.php',resp);
      resp.free;
      w.free;
      if res1='{OK}' then
      begin
        showmessage('Регистрация пользователя проведена!');
        modalresult:=1377;
      end else begin
        showmessage('Регистрация невозможна по причине:'+res1);
        modalresult:=0;
      end;
    except
      showmessage('Нет доступа к интернет!');
      modalresult:=0;
    end;
    formstart.Setconstant('typelicense','0');
   end;
     '(Off-line)':begin
        formstart.Setconstant('typelicense','999');
            w:= TFPHTTPClient.Create(nil);
        //www.retailika.ru/users/adduserfree.php
        resp:=TStringList.Create;
        try
          resp.Clear;
          resp.Add('inn='+edINN.Text);
          resp.Add('kpp='+edfirmkpp.text);
          resp.Add('name='+edNameFirm.Text);
          resp.Add('fsrarid='+edClientregid.Text);
          resp.Add('email='+edemail.Text);
          res1:=w.FormPost('http://195.133.201.27/users/adduserpo.php',resp);
          resp.free;
          w.free;
          modalresult:=1377;
          formstart.Setconstant('typelicense','999');

        except
          showmessage('Нет доступа к интернет!');
          modalresult:=0;
        end;
     end;
   end;

  if edProdukey.Text<>'' then
    regActivation();


end;

procedure TFormRegclient.cbCloudChange(Sender: TObject);
begin
  if cbCloud.Text = '(Off-line)' then
      edClientRegId.ReadOnly:=true
  else
      edClientRegId.ReadOnly:=False;
  self.flFreeLic := edClientRegId.ReadOnly;
end;

procedure TFormRegclient.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
   CloseAction:=cahide;
end;

procedure TFormRegclient.FormShow(Sender: TObject);
begin
  if formstart.FirmShortName<>'' then
   flBeginInstall:=true;

  //edinn.ReadOnly:=not flBeginInstall;
  //edfirmkpp.ReadOnly:=not flBeginInstall;
  //edNameFirm.ReadOnly:=not flBeginInstall;
  //edemail.ReadOnly:=not flBeginInstall;
  //edClientregid.ReadOnly:=not flBeginInstall;
  edINN.Text:=formstart.FirmINN;
  edfirmkpp.text:=formstart.FirmKPP;
  edNameFirm.Text:=formstart.FirmShortName;
  edemail.Text:=formstart.getconstant('email');
  edClientregid.Text:=formstart.EgaisKod;
  strealtor.Caption:=formstart.flRealtorName;
end;

procedure TFormRegclient.strealtorClick(Sender: TObject);
begin
  OpenURL(formstart.flRealtorurl);
end;

function TFormRegclient.regActivation: boolean;
var
 i:integer;
 w: TFPHTTPClient; // --- Стандартные средства обработки запросов к HTTP
 resp:TStringList;
 res1:String;
begin
  if showmodal = 1377 then begin
    if edProdukey.Text = '' then
    begin
      result:=true;
      exit;
    end;
    result:=false;
    w:= TFPHTTPClient.Create(nil);
    //www.retailika.ru/users/adduserfree.php
    try
      resp:=TStringList.create;
      resp.Clear;
      resp.Add('inn='+edINN.Text);
      resp.Add('kpp='+edfirmkpp.text);
      resp.Add('fsrarid='+edClientregid.Text);
      resp.Add('masterkey='+edProdukey.Text);
      res1:=w.FormPost('http://egais.retailika.ru/users/activekey.php',resp);
      if res1='{OK}' then
      begin
      end else
       showmessage('Активация не возможна по причине:'+res1+#13#10+' Попробуйте позже через кнопку "Продлить подписку".');

     result:=true;
    except
      // === ошибка при подключении
      result:=false;
      showmessage('нет доступа к интернет!');
    end;
    resp.free;
    w.free;
  end;
end;

end.

