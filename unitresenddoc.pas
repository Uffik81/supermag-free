unit unitResendDoc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TFormResendDoc }

  TFormResendDoc = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LabeledEdit1: TLabeledEdit;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flShowMessage:boolean;
  end;

var
  FormResendDoc: TFormResendDoc;

implementation

{$R *.lfm}
uses unitstart, DOM, XMLRead, typinfo;
{ TFormResendDoc }

procedure TFormResendDoc.BitBtn2Click(Sender: TObject);
var
  i:integer;
  status1:String;
  query:string;
  sLine:TStringList;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
begin
  sLine:=TStringList.Create();
  sLine.Clear;
  sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
  sLine.Add('<ns:Documents Version="1.0"');
  sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
  sLine.Add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters"> ');
  sLine.Add('<ns:Owner>');
  sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
  sLine.Add('</ns:Owner>');
  sLine.Add('<ns:Document>');
  sLine.Add('<ns:QueryResendDoc>');
  sLine.Add('<qp:Parameters>');
  sLine.Add('<qp:Parameter>');
  sLine.Add('<qp:Name>WBREGID</qp:Name>');
  sLine.Add('<qp:Value>'+LabeledEdit1.Text+'</qp:Value>');
  sLine.Add('</qp:Parameter>');
  sLine.Add('</qp:Parameters>');
  sLine.Add('</ns:QueryResendDoc> ');
  sLine.Add('</ns:Document>');
  sLine.Add('</ns:Documents>');
  status1:= formStart.SaveToServerPOST('opt/in/QueryResendDoc',SLine.text);
  sLine.Add(Status1);
  SLine.SaveToFile('ResendDoc.log');
  S:= TStringStream.Create(status1);
  Try
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
  Finally
   S.Free;
  end;
  Child :=XML.DocumentElement.FirstChild;
  i:=1;
  while Assigned(Child) do begin
   if Child.NodeName = 'url' then begin
     status1:=Child.FirstChild.NodeValue;
     Query:='INSERT INTO `docjurnale` (`uid`,`numdoc`,`dateDoc`,`type`,`status`) VALUES ("'+status1+'","'+LabeledEdit1.Text+'","'+FormatDateTime('yyyy-mm-dd',now())+'","ResendDoc","---");';
     formStart.DB_query(Query);
     if flShowMessage then
        Showmessage('Заявка отправлена в ЕГАИС');
   end;
   Child := Child.NextSibling;
  end;
  sLine.Free;
  close;
end;

procedure TFormResendDoc.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

