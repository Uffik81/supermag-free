unit unitshoprest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Grids, StdCtrls;

type

  { TFormShopRest }

  TFormShopRest = class(TForm)
    StaticText1: TStaticText;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    RowSelected:integer;
    flAlcCode:string;
    flSelectMode:boolean;
  end;

var
  FormShopRest: TFormShopRest;

implementation

{$R *.lfm}
uses unitstart;

{ TFormShopRest }

procedure TFormShopRest.FormShow(Sender: TObject);
var
  i:integer;
  status1:String;
  query:string;
begin
  status1:=  FormStart.GetConstant('finupdaterestshop');
  if status1 = '' then
    StaticText1.caption:='Ожидается ответ от ЕГАИС!'
    else
     StaticText1.caption:='Последняя дата обновления остатков:'+status1;
  RowSelected:=-1;
  i:=1;
  StringGrid1.clear;
  StringGrid1.RowCount:=5;
  if not formStart.ConnectDB() then
    exit;
  Query:='SELECT AlcName,Quantity,AlcCode,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`regrestsshop`.`AlcCode` LIMIT 1) AS `barcode`,(SELECT `currentprice` FROM `sprgoods` WHERE `extcode`=`regrestsshop`.`AlcCode` LIMIT 1) AS `price` FROM `regrestsshop` ';
 // if ToggleBox1.Checked then Query:=Query+' WHERE `AlcCode` LIKE "%'+Edit1.text+'%" OR `AlcName` LIKE "%'+Edit1.text+'%"';
  Query:=Query+' ORDER BY `AlcCode` ASC;' ;

  formStart.recbuf := formstart.db_query(Query);
  formStart.rowbuf := formstart.db_next(formStart.recbuf);
  if formStart.rowbuf=Nil then begin
    Caption:='Текущие остатки в ЕГАИС - Ожидает ответ из ЕГАИС'   ;
    formStart.disconnectDB();
    exit;
  end;
//  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
     with StringGrid1.rows[i] do begin
       Add('');
       Add(formStart.rowbuf[0]);
       Add(formStart.rowbuf[3]);         //3
       Add(formStart.rowbuf[4]);
       Add(formStart.rowbuf[1]);
       Add(formStart.rowbuf[2]);

     end;
      i:=i+1;
     formStart.rowbuf := formstart.db_next(formStart.recbuf);
   end  ;
  formStart.disconnectDB();

end;

procedure TFormShopRest.StringGrid1DblClick(Sender: TObject);
begin
  if flSelectMode then begin
     flAlcCode:= StringGrid1.Cells[5,StringGrid1.row];
     modalresult:=1377;
  end;

end;

procedure TFormShopRest.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
    begin
       key:=#0;
       if flSelectMode then begin
          flAlcCode:= StringGrid1.Cells[5,StringGrid1.row];
          modalresult:=1377;
       end;

    end;
end;

end.

