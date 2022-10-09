{
 Разработчик мсходного кода:Уфандеев Е.В.
 е-майл:uffik@mail.ru

}
unit unitInfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type

  { TFormInfo }

  TFormInfo = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Edit1: TEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    stLicDate: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormInfo: TFormInfo;

implementation

{$R *.lfm}
uses
  LCLIntf,
  unitStart,
  Process
 ,fphttpclient
 ,zipper
  ,unitregclient
    ;
{ TFormInfo }

procedure TFormInfo.FormShow(Sender: TObject);
var
  lists:TStringList;
begin
  lists:=TStringList.Create;
  if fileExists( 'info.txt') then  begin
    lists.LoadFromFile('info.txt');
    memo1.Lines.Text:=AnsiToUtf8(lists.Text);
  end
  else
    memo1.Lines.text:='Требуется обновить ПО!';
  lists.free;
  edit1.Text:=formstart.EgaisKod;
  StaticText4.Caption:=formStart.curVerReport;
  stLicDate.caption:=formStart.flDateLic;
end;

procedure TFormInfo.BitBtn2Click(Sender: TObject);
var
  AProcess: TProcess;
begin
  if formstart.GetConstant('typelicense') = '999' then
    exit;
  // Создаем объект TProcess
  AProcess := TProcess.Create(nil);
  // Зададим командную строку
  AProcess.CommandLine := 'updatemod.exe';
  // Установим опции программы. Первая из них не позволит нашей программе
  // выполнятся до тех пор, пока не закончит выполнение запущенная программа
  // Также добавим опцию, которая говорит, что мы хотим прочитать
  // вывод запущенной программы
  AProcess.Options := AProcess.Options;// + [poWaitOnExit, poUsePipes];
  AProcess.Parameters.Clear;
  AProcess.Parameters.Add('-u');
  // Теперь запускаем программу
  AProcess.Execute;

  AProcess.Free;
  formStart.close;

end;

procedure TFormInfo.BitBtn3Click(Sender: TObject);
var
  AProcess: TProcess;


begin
  // Создаем объект TProcess
  AProcess := TProcess.Create(nil);



  // Зададим командную строку
  AProcess.CommandLine := 'instantsupport.exe';

  // Установим опции программы. Первая из них не позволит нашей программе
  // выполнятся до тех пор, пока не закончит выполнение запущенная программа
  // Также добавим опцию, которая говорит, что мы хотим прочитать
  // вывод запущенной программы
  AProcess.Options := AProcess.Options;// + [poWaitOnExit, poUsePipes];
  AProcess.Parameters.Clear;
  AProcess.Parameters.Add('-u');
  // Теперь запускаем программу
  AProcess.Execute;

  AProcess.Free;

end;

procedure TFormInfo.BitBtn1Click(Sender: TObject);
{ var
   w: TFPHTTPClient;
   fzip:TUnZipper;  }



begin
//  OpenURL('http://www.retailika.ru/users/');
  formregclient.flBeginInstall:=false;
  formregclient.regActivation();
{
    w:=TFPHTTPClient.Create(Nil);
    w.Get('http://egais.retailika.ru/files/report.zip','./report.zip');
    w.Free;
    fzip := TUnZipper.Create;
    try
      fzip.FileName := './report.zip';
      fzip.OutputPath := './';
      fzip.Examine;
      fzip.UnZipAllFiles;
    finally
      fzip.Free;
    end;    }

end;

end.

