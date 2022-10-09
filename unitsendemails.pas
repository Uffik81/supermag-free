unit unitsendemails;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, Buttons, StdCtrls;

type

  { TFormSendEMails }

  TFormSendEMails = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    sgClients: TStringGrid;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sgClientsGetCheckboxState(Sender: TObject; ACol, ARow: Integer;
      var Value: TCheckboxState);
    procedure sgClientsSetCheckboxState(Sender: TObject; ACol, ARow: Integer;
      const Value: TCheckboxState);
  private
    { private declarations }
  public
    { public declarations }
    procedure CreateXMLForm11(inn:string);
    procedure Clientzip(inn:string);
    procedure CreateXMLForm12(inn:string);
  end;

var
  FormSendEMails: TFormSendEMails;

implementation
uses mimemess, mimepart, smtpsend, unitstart, unitexportform5, zipper ,unitlogging, ssl_openssl;
{$R *.lfm}

{ TFormSendEMails }

function thisBeer(fIMNS:string):boolean;
begin
 result:=false;
 if fIMNS ='500' then result:=true;
 if fIMNS ='520' then result:=true;
 if fIMNS ='261' then result:=true;
 if fIMNS ='263' then result:=true;
 if fIMNS ='262' then result:=true;
end;

procedure TFormSendEMails.BitBtn4Click(Sender: TObject);  // ===Рассылка почты по клиентам ===
var
  tmpMsg : TMimeMess;
  tmpMIMEPart : TMimePart;
  SList : TStringList;
  ind:integer;
  email1:ansiString;
  clemail:string;
begin
  email1:=utf8toansi(formstart.getconstant('email'));

  tmpMsg := TMimeMess.Create;
  SList:= TStringList.create;
  tmpMsg.Header.Subject := utf8toansi('Авторассылка для клиентов');
  tmpMsg.Header.From := formstart.getconstant('email');
  tmpMsg.Header.XMailer:='TheBat';
  try
    for ind:=1 to sgClients.RowCount-1 do
     if sgClients.Cells[1,ind]='+' then begin
        clemail:=utf8toansi(sgClients.Cells[5,ind]);
        tmpMsg.Header.ToList.Add(clemail);
        tmpMIMEPart := tmpMsg.AddPartMultipart('alternate',nil);
        SList.Text:=utf8toansi('Авторассылка. Отвечать на это письмо не надо.');
        tmpMsg.AddPartText(SList, tmpMIMEPart);
        CreateXMLForm11(sgClients.Cells[2,ind]);
        CreateXMLForm12(sgClients.Cells[2,ind]);
        Clientzip(sgClients.Cells[2,ind]);
        tmpMsg.AddPartBinaryFromFile('d:\ka_'+sgClients.Cells[2,ind]+'.zip',tmpMIMEPart);
        tmpMsg.EncodeMessage;
        if smtpsend.SendToRaw(email1, clemail, utf8toansi(FormStart.GetConstant('smtpserver')), tmpMsg.Lines, FormStart.GetConstant('smtplogin'), FormStart.GetConstant('smtppassword')) then
           formlogging.AddMessage('Отправили на почту:'+sgClients.Cells[5,ind]);

     end;
  finally
    tmpMsg.Free;
    sList.Free;
  end;
end;

procedure TFormSendEMails.BitBtn2Click(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to sgClients.RowCount-1 do begin
        sgClients.Cells[1,i] :='';
  end;
end;

procedure TFormSendEMails.BitBtn1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to sgClients.RowCount-1 do begin
        sgClients.Cells[1,i] :='+';
  end;

end;

procedure TFormSendEMails.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormSendEMails.FormShow(Sender: TObject);
var
  i:integer=1;
  ind:integer;
begin
  sgClients.Clean;
  sgClients.RowCount:=1;
   for ind:=1 to formexportform5.sgClients.RowCount-1 do begin
     if formexportform5.sgClients.Cells[12,ind] = '-' then
       begin
         i:= sgClients.RowCount;
         sgClients.RowCount:=i+1;
         sgClients.Cells[1,i] :='+';
         sgClients.Cells[2,i] :=formexportform5.sgClients.Cells[1,ind];
         sgClients.Cells[3,i] :=formexportform5.sgClients.Cells[2,ind];
         sgClients.Cells[4,i] :=formexportform5.sgClients.Cells[3,ind];
         sgClients.Cells[5,i] :=formexportform5.sgClients.Cells[16,ind];

       end;
   end;
end;

procedure TFormSendEMails.sgClientsGetCheckboxState(Sender: TObject; ACol,
  ARow: Integer; var Value: TCheckboxState);
begin
  if sgClients.Cells[ACol,ARow]='+' then
    value:=cbChecked
  else
    value:=cbUnchecked;

end;

procedure TFormSendEMails.sgClientsSetCheckboxState(Sender: TObject; ACol,
  ARow: Integer; const Value: TCheckboxState);
begin
  if value = cbChecked then
    sgClients.Cells[ACol,ARow]:='+'
    else
    sgClients.Cells[ACol,ARow]:='' ;
end;

procedure TFormSendEMails.CreateXMLForm11(inn: string);
var
  sline:TStringList;
  ind:integer;
  imnsKod:string='';
  prKod:string='';
  i:integer;
begin
  sline:=TStringList.Create;
  i:=1;
  sline.add('<?xml version="1.0" encoding="windows-1251"?>');
  sline.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',formExportForm5.flEndDate)+'" ВерсФорм="4.20" НаимПрог="РИТЕЙЛИКА Клиент для ЕГАИС" >');
  for ind:=1 to formExportForm5.sgSales6.RowCount-1 do
  if not thisBeer(formExportForm5.sgSales6.Cells[1,ind]) then begin
    if formExportForm5.sgSales6.Cells[6,ind] = inn then begin
      if imnsKod<> formExportForm5.sgSales6.Cells[1,ind] then
        begin
           //	   Атриб = " ПN="""+НомОбор+""" П000000000003="""+Лев(отчетПр.к_2,3)+""" ";
           //	ХМЛОткрытьЭлем(текст,"Оборот",Атриб);  // Табл 3.9.1
          if prKod<>'' then
             sline.add('</СведПроизвИмпорт>');
          if imnsKod<>'' then
            sline.add('</Оборот>');
          imnsKod:= formExportForm5.sgSales6.Cells[1,ind];
          sline.add('<Оборот ПN="'+inttostr(i)+'" П000000000003="'+imnsKod+'" >');
          prKod:='';
        end;
      if  prKod<> formExportForm5.sgSales6.Cells[2,ind] then begin
        if prKod<>'' then
           sline.add('</СведПроизвИмпорт>');
        sline.add('<СведПроизвИмпорт NameOrg="'+replaceStr(formExportForm5.sgSales6.Cells[3,ind],false)+'" INN="'+formExportForm5.sgSales6.Cells[4,ind]+'" KPP="'+formExportForm5.sgSales6.Cells[5,ind]+'" >');
        prKod:= formExportForm5.sgSales6.Cells[2,ind];
      end;
       sline.add('<Продукция П200000000013="'+formExportForm5.sgSales6.Cells[10,ind]+'" П200000000014="'+formExportForm5.sgSales6.Cells[11,ind]+'" П200000000015="" П200000000016="'+formExportForm5.sgSales6.Cells[12,ind]+'"  />');
    end;
  End;
  if prKod<>'' then
     sline.add('</СведПроизвИмпорт>');
  if imnsKod<>'' then
     sline.add('</Оборот>');
  sline.add('</Файл>');
  sline.Text:=utf8toansi(sline.Text);
  sline.SaveToFile(utf8toAnsi('d:\KA_'+inn+'_11.xml'));

end;

procedure TFormSendEMails.Clientzip(inn: string);
var
  OurZipper: TZipper;
begin
  OurZipper := TZipper.Create;
  try
    OurZipper.FileName := 'd:\ka_'+inn+'.zip';
    if fileexists('d:\KA_'+inn+'_12.xml') then
    OurZipper.Entries.AddFileEntry('d:\KA_'+inn+'_12.xml', 'KA_'+inn+'_12.xml');
    if fileexists('d:\KA_'+inn+'_11.xml') then
    OurZipper.Entries.AddFileEntry('d:\KA_'+inn+'_11.xml', 'KA_'+inn+'_11.xml');
    OurZipper.ZipAllFiles;
  finally
    OurZipper.Free;
  end;
end;

procedure TFormSendEMails.CreateXMLForm12(inn: string);
var
  sline:TStringList;
  ind:integer;
  imnsKod:string='';
  prKod:string='';
  i:integer;
begin
  sline:=TStringList.Create;
  i:=1;
  sline.add('<?xml version="1.0" encoding="windows-1251"?>');
  sline.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',formExportForm5.flEndDate)+'" ВерсФорм="4.20" НаимПрог="РИТЕЙЛИКА Клиент для ЕГАИС" >');
  for ind:=1 to formExportForm5.sgSales6.RowCount-1 do
  if thisBeer(formExportForm5.sgSales6.Cells[1,ind]) then begin
    if formExportForm5.sgSales6.Cells[6,ind] = inn then begin
      if imnsKod<> formExportForm5.sgSales6.Cells[1,ind] then
        begin
           //	   Атриб = " ПN="""+НомОбор+""" П000000000003="""+Лев(отчетПр.к_2,3)+""" ";
           //	ХМЛОткрытьЭлем(текст,"Оборот",Атриб);  // Табл 3.9.1
          if prKod<>'' then
             sline.add('</СведПроизвИмпорт>');
          if imnsKod<>'' then
            sline.add('</Оборот>');
          imnsKod:= formExportForm5.sgSales6.Cells[1,ind];
          sline.add('<Оборот ПN="'+inttostr(i)+'" П000000000003="'+imnsKod+'" >');
          prKod:='';
        end;
      if  prKod<> formExportForm5.sgSales6.Cells[2,ind] then begin
        if prKod<>'' then
           sline.add('</СведПроизвИмпорт>');
        sline.add('<СведПроизвИмпорт NameOrg="'+replaceStr(formExportForm5.sgSales6.Cells[3,ind],false)+'" INN="'+formExportForm5.sgSales6.Cells[4,ind]+'" KPP="'+formExportForm5.sgSales6.Cells[5,ind]+'" >');
        prKod:= formExportForm5.sgSales6.Cells[2,ind];
      end;
       sline.add('<Продукция П200000000013="'+formExportForm5.sgSales6.Cells[10,ind]+'" П200000000014="'+formExportForm5.sgSales6.Cells[11,ind]+'" П200000000015="" П200000000016="'+formExportForm5.sgSales6.Cells[12,ind]+'"  />');
    end;
  End;
  if prKod<>'' then
     sline.add('</СведПроизвИмпорт>');
  if imnsKod<>'' then
     sline.add('</Оборот>');
  sline.add('</Файл>');
  sline.Text:=utf8toansi(sline.Text);
  sline.SaveToFile(utf8toAnsi('d:\KA_'+inn+'_12.xml'));

end;

end.

