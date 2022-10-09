unit unitSelectTov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, mysql50;

type

  { TFormSelectTov }

  TFormSelectTov = class(TForm)
    BitBtn1: TBitBtn;
    ListView1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    selItem:string;
  end;

var
  FormSelectTov: TFormSelectTov;

implementation

{$R *.lfm}
uses unitStart;
{ TFormSelectTov }

procedure TFormSelectTov.FormShow(Sender: TObject);
var
  i:integer;
  //status1:String;
  Query:String;
begin
  i:=1;
  Listview1.items.Clear;
  Query:='SELECT AlcName,InformARegId,InformBRegId,Quantity,(SELECT `crdate` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `crdate`,`AlcCode` FROM `regrestsproduct`;';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  if formStart.recbuf=Nil then
    exit;
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin

     with ListView1.Items.Add do begin
       caption:= formStart.rowbuf[5];
       subitems.Add(formStart.rowbuf[0]);         //3
       subitems.Add(formStart.rowbuf[1]);
       subitems.Add(formStart.rowbuf[2]);
       subitems.Add(formStart.rowbuf[3]);
       subitems.Add(formStart.rowbuf[4]);
      i:=i+1;
     end;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end ;
end;

procedure TFormSelectTov.ListView1Click(Sender: TObject);
begin

end;

procedure TFormSelectTov.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
   selItem:=item.Caption;
end;

procedure TFormSelectTov.BitBtn1Click(Sender: TObject);
begin

  modalresult:=1377;

end;

end.

