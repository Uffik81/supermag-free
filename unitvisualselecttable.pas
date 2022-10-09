unit unitvisualselecttable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFormVisualSelectTable }

  TFormVisualSelectTable = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
  private
    { private declarations }
    arrItemGood:array[0..100] of TPanel;
    arrItemSt1:array[0..100,0..2] of TStaticText;
  public
    flSelectTableid:string;
    { public declarations }
    procedure SelectTable;
    procedure AddTable;
    //Procedure ClearTable(aNum:string);
    procedure createTable(ind,aTop,aLeft:integer; aColor:TColor);
  end;

var
  FormVisualSelectTable: TFormVisualSelectTable;

implementation
uses unitstart,unitsalesbeerts,mysql50;
{$R *.lfm}

{ TFormVisualSelectTable }

procedure TFormVisualSelectTable.FormCreate(Sender: TObject);
var
  ii:integer;
begin
       for ii:=0 to 99 do

       begin
        arrItemGood[ii]:=TPanel.Create(self);
        arrItemSt1[ii,0]:=TStaticText.Create(arrItemGood[ii]);
        arrItemSt1[ii,1]:=TStaticText.Create(arrItemGood[ii]);

       end;
end;

procedure TFormVisualSelectTable.FormShow(Sender: TObject);
const
   colorHall:array[0..4] of TColor = (clBlack,clGreen,clRed,clYellow,clBlue);
var
  ii:integer;
  lleft,
  ttop:integer;
  iHall:integer;
  arrHalls:array[0..4] of integer;
begin
  createTable(0,0,0,$00C7E1F1);
   arrItemSt1[0,0].Caption:='БЫСТРАЯ ПРОДАЖА';
  for ii:=1 to 3 do
   arrHalls[ii]:=strtoint(FormStart.GetConstant('quantityhall'+inttostr(ii)));
  iHall:=1;
  ii:=1;
  for ttop:=0 to 3 do
    for lleft:=0 to 3 do
    if not((ttop=0)and(lleft=0)) then
    begin
     if iHall<4 then
      createTable(ii,ttop,lleft,colorHall[iHall]);
     if arrHalls[iHall]>1 then
     begin
       arrHalls[iHall]:=arrHalls[iHall]-1;

     end else begin
      if iHall<4 then
       iHall:=iHall+1;
     end;
     ii:=ii+1;

    end;
end;

procedure TFormVisualSelectTable.Panel5Click(Sender: TObject);
begin
  flSelectTableid:=inttostr((Sender AS TWinControl).tag);
  if flSelectTableid='0' then
    flSelectTableid:='';
  SelectTable;
  //formsalesbeerts.Panel14.Visible:=true;
  formsalesbeerts.flCurrentTable := flSelectTableid;
  formsalesbeerts.pnlSelectTable.Visible:=false;
  Application.ProcessMessages;
end;

procedure TFormVisualSelectTable.SelectTable;
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  ii,
  i:integer;
  ind1:integer;
begin

       Query:='select `plu`,`name`,`price`,`quantity`,`summ`,`eanbc`,`urlegais`,`alccode`,`numsection` from `regshoptable` where `idtable`='''+flSelectTableid+''' AND `numkass`='''+formstart.prefixClient+''' ;';
       xrecbuf:= formstart.DB_query(query);

    // == weightgood - весовой --- делимый. россыпь
       xrowbuf:=formstart.DB_Next(xrecbuf);
       if xrowbuf<>nil then begin
            formSalesBeerTS.clearcheck();
            /// === Заполняем товар из справочника столов ==========
            while xrowbuf<> nil do begin
              i:= formSalesBeerTS.Stringgrid1.RowCount;
              formSalesBeerTS.Stringgrid1.RowCount:=i+1;
              formSalesBeerTS.Stringgrid1.Cells[0,i]:= inttostr(i);
              formSalesBeerTS.Stringgrid1.Cells[1,i]:= xrowbuf[0];
              formSalesBeerTS.Stringgrid1.Cells[2,i]:= xrowbuf[1];
              formSalesBeerTS.Stringgrid1.Cells[3,i]:= xrowbuf[2];
              formSalesBeerTS.Stringgrid1.Cells[4,i]:= xrowbuf[3];
              formSalesBeerTS.Stringgrid1.Cells[5,i]:= xrowbuf[4];
              formSalesBeerTS.Stringgrid1.Cells[6,i]:= xrowbuf[5];
              formSalesBeerTS.Stringgrid1.Cells[8,i]:= xrowbuf[6];
              formSalesBeerTS.Stringgrid1.Cells[12,i]:= xrowbuf[7];
              formSalesBeerTS.Stringgrid1.Cells[15,i]:= xrowbuf[8];
              xrowbuf:=formstart.DB_Next(xrecbuf);
            end;
            formSalesBeerTS.flSelRow:= i;
            formSalesBeerTS.stringgrid1.Row:=formSalesBeerTS.flSelRow;
       end else
        formSalesBeerTS.clearcheck();

 Application.ProcessMessages;


 formSalesBeerTS.flAllSumma:=0;
 for ii:=1 to formSalesBeerTS.StringGrid1.RowCount-1 do begin
    formSalesBeerTS.flAllSumma:=formSalesBeerTS.flAllSumma+ StrToFloat(trim(formSalesBeerTS.StringGrid1.Cells[5,ii])) ;
 end;
 formSalesBeerTS.CurLine:= formSalesBeerTS.flSelRow;

 formSalesBeerTS.stSumma.Caption:=format('СУММА: %8.2f',[formSalesBeerTS.flallsumma]);
 formSalesBeerTS.repaintTypeDoc
end;

procedure TFormVisualSelectTable.AddTable;
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  ii,
  i:integer;
  ind1:integer;
begin
  //      ShowMessage(flSelectTableid);
  if  flSelectTableid<>'' then begin
       Query:='DELETE FROM `regshoptable` WHERE `idtable`='''+flSelectTableid+''' AND `numkass`='''+formstart.prefixClient+''' ;';
       formstart.DB_query(query);
       QUERY:='INSERT INTO `regshoptable` (`idtable`,`numkass`,`plu`,`name`,`price`,`quantity`,`summ`,`eanbc`,`urlegais`,`alccode`,`numsection`) VALUES ';
       for i:=1 to FormSalesBeerTS.StringGrid1.RowCount-1 do begin
         if i<>1 then
           query:=query+',';
         QUERY:=QUERY +' ('+
         db_string(flSelectTableid)+','+
         db_string(formstart.prefixClient)+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[1,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[2,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[3,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[4,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[5,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[6,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[8,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[12,i])+','+
         db_string(FormSalesBeerTS.StringGrid1.cells[15,i])+
         ') ';

       end;
       formstart.DB_query(query+';');
    //   showmessage(query);
     end
       else begin

         end;
   FormSalesBeerTS.Repaint;
   //Application.ProcessMessages;


end;

procedure TFormVisualSelectTable.createTable(ind, aTop, aLeft: integer; aColor:TColor);
var
    query:string;
    xrowbuf:MYSQL_ROW;
    xrecbuf:PMYSQL_RES;
    ii:integer;
begin
 ii:=ind;
 arrItemGood[ii].Parent:=self AS TWinControl;
 arrItemGood[ii].Caption:='';
 arrItemGood[ii].Width:=120;
 arrItemGood[ii].Height:=72;
 arrItemGood[ii].left:=aLeft*124+6;
 arrItemGood[ii].Top:=aTop*74+2;
 arrItemGood[ii].tag:=ii;
 arrItemGood[ii].Color:= aColor;//$00C7E1F1;
 arrItemGood[ii].visible:=true;
 arrItemGood[ii].OnClick:=@Panel5Click;
 arrItemSt1[ii,0]:=TStaticText.Create(arrItemGood[ii]);
 arrItemSt1[ii,0].Parent:=arrItemGood[ii];
 arrItemSt1[ii,0].Width:=110;
 arrItemSt1[ii,0].Height:=36;
 arrItemSt1[ii,0].left:=5;
 arrItemSt1[ii,0].Top:=8;
 arrItemSt1[ii,0].tag:=ii;
 arrItemSt1[ii,0].Font.Size:=10;
 arrItemSt1[ii,0].Caption:='Стол №'+inttostr(ii);
 arrItemSt1[ii,0].Visible:=true;
 arrItemSt1[ii,0].OnClick:=@Panel5Click;
 arrItemSt1[ii,1].Parent:=arrItemGood[ii];
 arrItemSt1[ii,1].Width:=79;
 arrItemSt1[ii,1].Height:=16;
 arrItemSt1[ii,1].left:=30;
 arrItemSt1[ii,1].Top:=48;
 arrItemSt1[ii,1].tag:=ii;
 arrItemSt1[ii,1].Font.Size:=10;
 arrItemSt1[ii,1].Alignment:=taRightJustify;
 if ii<>0 then
 arrItemSt1[ii,1].Caption:='свободно';
 query:='SELECT SUM(`summ`) AS `asumm` FROM `regshoptable` WHERE `idtable`='''+inttostr(ii)+'''  AND `numkass`='''+formstart.prefixClient+''' GROUP BY `idtable`;';
 xrecbuf:= formstart.DB_query(query);
 xrowbuf:=formstart.DB_Next(xrecbuf);
 if xrowbuf<>nil then begin
        if xrowbuf[0]<>'' then
          arrItemSt1[ii,1].Caption:=xrowbuf[0];
      end;
 arrItemSt1[ii,1].Visible:=true;
 arrItemSt1[ii,1].OnClick:=@Panel5Click;
end;

end.

