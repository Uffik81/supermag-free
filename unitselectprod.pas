unit unitSelectProd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Buttons,mysql50;

type

  { TFormSelectProd }

  TFormSelectProd = class(TForm)
    BitBtn1: TBitBtn;
    ListView1: TListView;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    sBarCode:String;
    sAlcCode:String;
    sName:String;
    //flRetail:boolean;
  end;

var
  FormSelectProd: TFormSelectProd;

implementation

{$R *.lfm}
uses unitStart;
{ TFormSelectProd }

procedure TFormSelectProd.FormShow(Sender: TObject);


var
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  countitem:integer;
begin
  ListView1.Items.Clear;

  if formstart.flOptMode then
    Query:= 'SELECT `spproduct`.`Name`,`spproducer`.`FullName`,`spproduct`.`AlcCode`  FROM `spproduct`,`spproducer`,( SELECT SUM(`Quantity`) FROM `regrestsproduct` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countitem` ,( SELECT SUM(`Quantity`) FROM `regrestsshop` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countshop` WHERE '+
                       '(`listbarcode` LIKE ''%,'+sBarCode+'%'')AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`);'
  else
     Query:='SELECT `spproduct`.`Name`,`spproducer`.`FullName`,`spproduct`.`AlcCode` ,( SELECT SUM(`Quantity`) FROM `regrestsproduct` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countitem` ,( SELECT SUM(`Quantity`) FROM `regrestsshop` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countshop` FROM `sprgoods`,`spproduct`,`spproducer` WHERE `sprgoods`.`barcodes`="'
     +sBarCode+
     '"  AND `sprgoods`.`extcode`<>"" AND `spproduct`.`AlcCode`=`sprgoods`.`extcode`  AND`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`;';

  xrecbuf := formstart.DB_query(Query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  countitem:=0;
  while xrowbuf<>nil do
   begin
     if ((xrowbuf[4]<>'0')and(xrowbuf[4]<>''))and(xrowbuf[4]<>nil) then begin
       countitem:=countitem+1;
       sName:=  xrowbuf[0];
       sAlcCode:= xrowbuf[2];
     end;
     with ListView1.Items.Add do begin
       caption:= xrowbuf[0];
       subitems.Add(xrowbuf[1]);         //3
       subitems.Add(xrowbuf[2]);
       subitems.Add(xrowbuf[3]);
       subitems.Add(xrowbuf[4]);

     end;
    xrowbuf:=formstart.DB_Next(xrecbuf);
   end ;
  if countitem=1 then
    begin
      self.ModalResult:=1377;
    end;
  formStart.disconnectDB();
  listview1.SetFocus;
end;

procedure TFormSelectProd.ListView1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    BitBtn1Click(nil);
    key:=#0;
  end;
end;

procedure TFormSelectProd.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if selected then
    panel1.Caption:=item.SubItems.Strings[0]
  else
    panel1.Caption:='';
end;

procedure TFormSelectProd.BitBtn1Click(Sender: TObject);
begin
  if listview1.Selected<>nil then begin
    sName:=listview1.Selected.Caption;
    sAlcCode:=listview1.Selected.SubItems.Strings[1];
    self.ModalResult:=1377;

  end;

end;

end.

