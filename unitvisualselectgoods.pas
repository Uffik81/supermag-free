unit unitvisualselectgoods;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFormVisualSelectGoods }

  TFormVisualSelectGoods = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
  private
    { private declarations }
  public

    { public declarations }
    flActWriteOff:boolean;
    flSelGroup:string;
    flItemStep:integer;
    flGoodStep:integer;
    flCurStep:integer;
    arrItemGood:array[0..100] of tPanel;
    arrItemSt1:array[0..100,0..1] of tStaticText;
    procedure refreshitems;
  end;

var
  FormVisualSelectGoods: TFormVisualSelectGoods;

implementation

{$R *.lfm}
uses unitstart,unitsalesbeerts,mysql50,unitactwriteoffts;
{ TFormVisualSelectGoods }
type
  tItemGood = record
    flfolder:boolean;
    itemid:string;

  end;
var
  arrSpGood:array[0..101] of tItemGood;

procedure TFormVisualSelectGoods.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  ii,
  i:integer;
  theight,
  twidth:integer;
  tleft,
  ttop:integer;
begin
  //showmessage(inttostr(screen.Width));
  flCurStep:=0;
  ttop:=8;
  flSelGroup:='';
  tleft:=6;
  flItemStep:=0;
  twidth:=((screen.Width-450) div 160);

  theight:=((Parent.Height-65) div 74);
  for ii:=0 to 100 do begin
      arrItemGood[ii]:=nil;
      arrItemGood[ii]:=TPanel.Create(self);
      arrItemSt1[ii,0]:=TStaticText.Create(arrItemGood[ii]);
      arrItemSt1[ii,1]:=TStaticText.Create(arrItemGood[ii]);
  end;
  ii:=0;

  for i:=0 to twidth-1 do
    for ttop:=0 to theight-1 do
      if ii<100 then
     begin
      arrSpGood[ii].flfolder:=false;
      arrSpGood[ii].itemid:='';

      arrItemGood[ii].Parent:=self AS TWinControl;
      arrItemGood[ii].Caption:='';
      arrItemGood[ii].Width:=146;
      arrItemGood[ii].Height:=72;
      arrItemGood[ii].left:=i*152+6;
      arrItemGood[ii].Top:=ttop*74+2;
      arrItemGood[ii].tag:=ii;
      arrItemGood[ii].Color:= $00C7E1F1;
      arrItemGood[ii].visible:=false;
      arrItemGood[ii].OnClick:=@Panel5Click;
      arrItemSt1[ii,0]:=TStaticText.Create(arrItemGood[ii]);
      arrItemSt1[ii,0].Parent:=arrItemGood[ii];
      arrItemSt1[ii,0].Width:=139;
      arrItemSt1[ii,0].Height:=36;
      arrItemSt1[ii,0].left:=5;
      arrItemSt1[ii,0].Top:=8;
      arrItemSt1[ii,0].tag:=ii;
      arrItemSt1[ii,0].Font.Size:=10;
      arrItemSt1[ii,0].Visible:=true;
      arrItemSt1[ii,0].OnClick:=@Panel5Click;
      arrItemSt1[ii,1].Parent:=arrItemGood[ii];
      arrItemSt1[ii,1].Width:=79;
      arrItemSt1[ii,1].Height:=16;
      arrItemSt1[ii,1].left:=64;
      arrItemSt1[ii,1].Top:=48;
      arrItemSt1[ii,1].tag:=ii;
      arrItemSt1[ii,1].Font.Size:=10;
      arrItemSt1[ii,1].Alignment:=taRightJustify;
      arrItemSt1[ii,1].Visible:=true;
      arrItemSt1[ii,1].OnClick:=@Panel5Click;
      ii:=ii+1;
    end;
  flItemStep:=ii;
  i:=0;
  if  flSelGroup<>'' then begin
    query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `groupid`='''+flSelGroup+''' ORDER BY `name` ASC;';
    xrecbuf:= formstart.DB_query(query);
    // == weightgood - весовой --- делимый. россыпь
    xrowbuf:=formstart.DB_Next(xrecbuf);
    if  xrowbuf <> nil then begin
      arrItemGood[i].Color:= $0069F18E;
      arrItemSt1[i,0].Caption:=xrowbuf[1];
      arrItemSt1[i,1].Caption:='...';
      arrItemGood[i].visible:=true;
      arrSpGood[i].flfolder:=true;
      arrSpGood[i].itemid:='';
      i:=1;
    end;
  end;
  query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `ownergroupid`='''+flSelGroup+''' ORDER BY `name` ASC;';
  xrecbuf:= formstart.DB_query(query);
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf <> nil do begin
    //arrItemGood[i].Caption:=xrowbuf[1];
    arrItemGood[i].Color:= $00C7E1F1;
    arrItemSt1[i,0].Caption:=xrowbuf[1];
    arrItemSt1[i,1].Caption:='';
    arrItemGood[i].visible:=true;
    arrSpGood[i].flfolder:=true;
    arrSpGood[i].itemid:=xrowbuf[0];
    i:=i+1;
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
  flGoodStep:= flItemStep-i;
  if flActWriteOff then
    query :='SELECT `plu`,`name`,`currentprice` FROM `sprgoods` WHERE `groupid`='''+flSelGroup+''' AND (`weightgood`="1" OR `weightgood`="+") ORDER BY `name` ASC LIMIT '+inttostr(flCurStep)+','+inttostr(flItemStep-i)+';'
    else
  query :='SELECT `plu`,`name`,`currentprice` FROM `sprgoods` WHERE `groupid`='''+flSelGroup+''' ORDER BY `name` ASC LIMIT '+inttostr(flItemStep-i)+';';
  xrecbuf:= formstart.DB_query(query);
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while ((xrowbuf <> nil)and (i<ii))and(i<99) do begin
    //arrItemGood[i].Caption:=xrowbuf[1];
    arrItemGood[i].Color:= $00E7E1F1;
    arrItemSt1[i,0].Caption:=xrowbuf[1];
    arrItemSt1[i,1].Caption:=xrowbuf[2]+' руб';
    arrItemGood[i].visible:=true;
    arrSpGood[i].flfolder:=false;
    arrSpGood[i].itemid:=xrowbuf[0];
    i:=i+1;
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
  if i< flGoodStep then
      Panel7.Visible:=false
    else
      Panel7.Visible:=true;

  if flCurStep>0 then
      Panel6.Visible:=true
    else
      panel6.Visible:=false;
end;

procedure TFormVisualSelectGoods.Image1Click(Sender: TObject);
begin

end;

procedure TFormVisualSelectGoods.FormResize(Sender: TObject);
begin
 height:=Parent.Height;
 Width:=Parent.Width;
 // FormShow(nil);
end;

procedure TFormVisualSelectGoods.Panel5Click(Sender: TObject);
var
  ii:integer;
begin
  ii:=(Sender as TWinControl).Tag;
  if arrSpGood[ii].flfolder then begin
    flSelGroup:= arrSpGood[ii].itemid

    end
  else begin
    if flActWriteOff then
      FormSalesBeerTs.addPLUcode(arrSpGood[ii].itemid,'1000')
    else
      FormSalesBeerTs.addPLUcode(arrSpGood[ii].itemid,'1000');
  end;
  refreshitems;
end;
{Предыдущая страница}
procedure TFormVisualSelectGoods.Panel6Click(Sender: TObject);
begin
  if flCurStep>0 then
    flCurStep:=flCurStep-flGoodStep;
  if flCurStep<0 then
    flCurStep:=0;
  refreshitems();
end;
{Следующая страница}
procedure TFormVisualSelectGoods.Panel7Click(Sender: TObject);
begin
  if flGoodStep>0 then begin
    flCurStep:=flCurStep+flGoodStep;
    refreshitems();
  end;
end;

procedure TFormVisualSelectGoods.refreshitems;
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  ii,
  i:integer;
  theight,
  twidth:integer;
  tleft,
  ttop:integer;
begin

  ttop:=8;
  tleft:=6;
  twidth:=(Parent.Width div 152);
  theight:=(Parent.Height div 74);
  for ii:=0 to 100 do
     begin
       arrSpGood[ii].flfolder:=false;
          arrSpGood[ii].itemid:='';
          arrItemGood[ii].Color:= $00C7E1F1;
          arrItemGood[ii].visible:=false;
    end;

  i:=0;
  if  flSelGroup<>'' then begin
    query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `groupid`='''+flSelGroup+''' ORDER BY `name` ASC;';
    xrecbuf:= formstart.DB_query(query);
    // == weightgood - весовой --- делимый. россыпь
    xrowbuf:=formstart.DB_Next(xrecbuf);
    if  xrowbuf <> nil then begin
      arrItemGood[i].Color:= $0069F18E;
      arrItemSt1[i,0].Caption:=xrowbuf[1];
      arrItemSt1[i,1].Caption:='...';
      arrItemGood[i].visible:=true;
      arrSpGood[i].flfolder:=true;
      arrSpGood[i].itemid:='';
      i:=1;
    end;
  end;
  query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `ownergroupid`='''+flSelGroup+''' ORDER BY `name` ASC;';
  xrecbuf:= formstart.DB_query(query);
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);

  while xrowbuf <> nil do begin
    //arrItemGood[i].Caption:=xrowbuf[1];
    arrItemGood[i].Color:= $00C7E1F1;
    arrItemSt1[i,0].Caption:=xrowbuf[1];
    arrItemSt1[i,1].Caption:='';
    arrItemGood[i].visible:=true;
    arrSpGood[i].flfolder:=true;
    arrSpGood[i].itemid:=xrowbuf[0];
    i:=i+1;
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
  flGoodStep:= flItemStep-i;
  if flActWriteOff then
    query :='SELECT `plu`,`name`,`currentprice` FROM `sprgoods` WHERE `groupid`='''+flSelGroup+''' AND (`weightgood`="1" OR `weightgood`="+") ORDER BY `name` ASC LIMIT '+inttostr(flCurStep)+','+inttostr(flItemStep-i)+';'
    else
  query :='SELECT `plu`,`name`,`currentprice` FROM `sprgoods` WHERE `groupid`='''+flSelGroup+''' ORDER BY `name` ASC LIMIT '+inttostr(flCurStep)+','+inttostr(flItemStep-i)+';';
  xrecbuf:= formstart.DB_query(query);
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while ((xrowbuf <> nil)and (i<ii))and(i<99) do begin
    //arrItemGood[i].Caption:=xrowbuf[1];
    arrItemGood[i].Color:= $00E7E1F1;
    arrItemSt1[i,0].Caption:=xrowbuf[1];
    arrItemSt1[i,1].Caption:=xrowbuf[2]+' руб';
    arrItemGood[i].visible:=true;
    arrSpGood[i].flfolder:=false;
    arrSpGood[i].itemid:=xrowbuf[0];
    i:=i+1;
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;

  if (i+1)< flGoodStep then
      Panel7.Visible:=false
    else
      Panel7.Visible:=true;

  if flCurStep>0 then
      Panel6.Visible:=true
    else
      panel6.Visible:=false;
end;

end.

