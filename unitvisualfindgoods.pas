unit unitvisualfindgoods;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, Grids;

type

  { TFormVisualFindGoods }

  TFormVisualFindGoods = class(TForm)
    BitBtn1: TBitBtn;
    EdGoods: TEdit;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure EdGoodsKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    { private declarations }
    FSelPLU:string;
  public
    { public declarations }
    procedure refreshGoods();
    Function GetPLU():string;
  end;

var
  FormVisualFindGoods: TFormVisualFindGoods;

implementation

{$R *.lfm}
 uses mysql50,unitstart;
{ TFormVisualFindGoods }

procedure TFormVisualFindGoods.FormShow(Sender: TObject);
begin
  edGoods.Text:='';
  edGoods.SetFocus;
  refreshGoods();
end;

procedure TFormVisualFindGoods.StringGrid1DblClick(Sender: TObject);
begin
  fselplu:=Stringgrid1.Cells[3,Stringgrid1.Row];
  modalresult:=1377;
end;

procedure TFormVisualFindGoods.refreshGoods;
var
  ind:integer;
  query:String;
  typegood:string;
  tmpGrp:string;
  i:integer;
  arrgrp:array[0..100,0..2] of string;
  arrcount:integer=0;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  StringGrid1.RowCount:=1;
  tmpGrp:= edGoods.Text;
  if length(tmpGrp)>0 then
    while pos(' ',tmpGrp) >0 do begin
        i:=pos(' ',tmpGrp);
        tmpGrp[i]:='%';
    end;
  xrecbuf:= formstart.DB_query(
  'SELECT `plu`,`name`,`currentprice`,(SELECT `name` FROM `sprgroups` WHERE `groupid`=`sprgroups`.`groupid` limit 1) AS `groupName`,'+
  '`barcodes` FROM `sprgoods` WHERE `isdelete`='''' AND (UPPER(`name`) LIKE UPPER(''%'+tmpGrp+'%'') ) GROUP BY `plu` ORDER BY `name` ASC  LIMIT 200;');
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf <> nil do begin
    ind:=StringGrid1.RowCount;
    StringGrid1.RowCount:=ind+1;
    typegood:='';
    StringGrid1.Cells[0,ind]:=xrowbuf[3];
    StringGrid1.Cells[1,ind]:=xrowbuf[1];
    StringGrid1.Cells[2,ind]:=xrowbuf[2];
    StringGrid1.Cells[3,ind]:=xrowbuf[0];
    StringGrid1.Cells[4,ind]:=xrowbuf[4];
    //Stringgrid1
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
  if StringGrid1.RowCount>1 then
    StringGrid1.Row:=1;
  StringGrid1.Col:=2;

end;

function TFormVisualFindGoods.GetPLU: string;
begin
  fSelPLU:='';
  if showmodal=1377 then
      result:=fselplu
    else
      result:='';
end;

procedure TFormVisualFindGoods.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFormVisualFindGoods.BitBtn1Click(Sender: TObject);
begin
  fselplu:=Stringgrid1.Cells[3,Stringgrid1.Row];
  modalresult:=1377;
end;

procedure TFormVisualFindGoods.EdGoodsKeyPress(Sender: TObject; var Key: char);
begin
 if (key<#31)and (key<>#8) then begin
   if key=#13 then begin
         key:=#0;
    BitBtn1Click(Sender);
   end else
     StringGrid1.SetFocus;
 end;
    refreshGoods();
end;

procedure TFormVisualFindGoods.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormVisualFindGoods.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if key =0013 then begin
    key:=0;
    BitBtn1Click(Sender);
  end else begin
    if (key=38) or (key=40) then
        Stringgrid1.SetFocus
      else begin
    //showmessage('k:' +inttostr(key));
    edGoods.SetFocus;
      end;
  end;
end;

end.

