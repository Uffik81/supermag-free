unit unitspgoods;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  PairSplitter, Grids, Buttons, Menus, StdCtrls, ExtCtrls;

type

  { TFormSpGoods }

  TFormSpGoods = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Edit1: TEdit;
    ilSprGoods: TImageList;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    tvGroupGoods: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1Enter(Sender: TObject);
    procedure StringGrid1HeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
    procedure tvGroupGoodsDblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flSelectItem:boolean;
    flSelectGroup:String;
    flPLU:String;
    flGroupGoods:TStringList;
    procedure refreshtable();
    procedure refreshGroup();
  end;

var
  FormSpGoods: TFormSpGoods;

implementation

{$R *.lfm}
uses unitstart, unitedititem,uniteditgroup,  mysql50;
{ TFormSpGoods }

procedure TFormSpGoods.refreshtable();
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
   ind:=0;
   tmpGrp:= flSelectGroup;

    arrcount:=0;
    while tmpGrp<>'' do begin
      query :='SELECT `groupid`,`name`,`ownergroupid` FROM `sprgroups` WHERE `groupid`='''+tmpGrp+''' ORDER BY `name` ASC;';
      formstart.recbuf:= formstart.DB_query(query);
      // == weightgood - весовой --- делимый. россыпь
      formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
      if formstart.rowbuf <> nil then begin

        arrgrp[arrcount,1]:=formstart.rowbuf[1];
        arrgrp[arrcount,2]:=formstart.rowbuf[2];
        tmpGrp:=formstart.rowbuf[2];
        arrcount:=arrcount+1;
        //formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
      end else
        tmpgrp:='';
    end;

    for i:=arrcount-1 downto 0 do begin
      ind:=ind+1;
      StringGrid1.RowCount:=ind+1;
      typegood:='';
      StringGrid1.Cells[1,ind]:=arrgrp[i,2];
      StringGrid1.Cells[2,ind]:=arrgrp[i,1];
      StringGrid1.Cells[3,ind]:='';
      StringGrid1.Cells[5,ind]:='';
      StringGrid1.Cells[4,ind]:='';
      StringGrid1.Cells[6,ind]:='';
      StringGrid1.Cells[8,ind]:='1';
      StringGrid1.Cells[9,ind]:=arrgrp[i,2];
    end;

    query :='SELECT `groupid`,`name`,`groupid` FROM `sprgroups` WHERE `ownergroupid`='''+flSelectGroup+''' ORDER BY `name` ASC;';
    xrecbuf:= formstart.DB_query(query);
    xrowbuf:=formstart.DB_Next(xrecbuf);
    while xrowbuf<>nil do begin
      ind:=StringGrid1.RowCount;
      StringGrid1.RowCount:=ind+1;
      typegood:='';
      StringGrid1.Cells[1,ind]:=xrowbuf[0];
      StringGrid1.Cells[2,ind]:=xrowbuf[1];
      StringGrid1.Cells[3,ind]:='';
      StringGrid1.Cells[5,ind]:='';
      StringGrid1.Cells[4,ind]:='';
      StringGrid1.Cells[6,ind]:='';
      StringGrid1.Cells[8,ind]:='+';
      StringGrid1.Cells[9,ind]:=xrowbuf[0];
      xrowbuf:=formstart.DB_Next(xrecbuf);
    end;

    formstart.recbuf:= formstart.DB_query(
    'SELECT `plu`,`name`,`alcgoods`,`weightgood`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `alcName`, `isdelete` FROM `sprgoods` WHERE `groupid`="'+flSelectGroup+'" GROUP BY `plu` ORDER BY `name` ASC;');
    // == weightgood - весовой --- делимый. россыпь
    formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    while formstart.rowbuf <> nil do begin
      ind:=ind+1;
      StringGrid1.RowCount:=ind+1;
      typegood:='';
      StringGrid1.Cells[1,ind]:=formstart.rowbuf[0];
      StringGrid1.Cells[2,ind]:=formstart.rowbuf[1];
      if db_boolean(formstart.rowbuf[2]) then
         typegood:='Алкоголь';
      if db_boolean(formstart.rowbuf[3]) then
         typegood:='Весовой';
      StringGrid1.Cells[5,ind]:=typegood;
      StringGrid1.Cells[3,ind]:=formstart.rowbuf[4];
      StringGrid1.Cells[4,ind]:='0';
      StringGrid1.Cells[6,ind]:=formstart.rowbuf[5];
      StringGrid1.Cells[7,ind]:=formstart.rowbuf[6];
      //Stringgrid1
      formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    end;
 if StringGrid1.RowCount>1 then
  StringGrid1.Row:=1;
end;

procedure TFormSpGoods.refreshGroup;
// обновляем список групп для товара
procedure addItem1(aNode:TTreeNode;aGroupId:string);
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  twRoot:TTreeNode;
begin
  query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `ownergroupid`='''+aGroupId+''' ORDER BY `name` ASC;';
  xrecbuf:= formstart.DB_query(query);
  // == weightgood - весовой --- делимый. россыпь
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf <> nil do begin
    twRoot:=tvGroupGoods.Items.AddChild(aNode,xrowbuf[1]);
    twroot.SelectedIndex:=flGroupGoods.Count;
    flGroupGoods.Add(xrowbuf[0]);
    addItem1(twRoot,xrowbuf[0]);
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;
end;

var
    typegood:string;
    query:string;
    ind:integer;
    i:integer;
    twRoot:TTreeNode;
    twRootR:TTreeNode;
    twRootI:TTreeNode;
begin
   twRoot:=nil;
//   twRoot:=tvGroupGoods.Items.Add(nil,'');

   tvGroupGoods.Items.Clear;
   flGroupGoods.Clear;

   twRootR:=tvGroupGoods.Items.Add(twRoot,'Товар');
   flGroupGoods.add('');
   twrootr.SelectedIndex:=0;
   ind:=0;
   query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `ownergroupid`='''' ORDER BY `name` ASC;';
   formstart.recbuf:= formstart.DB_query(query);
   // == weightgood - весовой --- делимый. россыпь
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   while formstart.rowbuf <> nil do begin
     twRoot:=tvGroupGoods.Items.AddChild(twRootR,formstart.rowbuf[1]);
     twroot.SelectedIndex:=flGroupGoods.Count;
     flGroupGoods.Add(formstart.rowbuf[0]);
     addItem1(twRoot,formstart.rowbuf[0]);
     formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   end;


end;

procedure TFormSpGoods.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;
end;

procedure TFormSpGoods.FormCreate(Sender: TObject);
begin
  flSelectGroup:='';
  flSelectItem:=false;
  flGroupGoods:=tstringlist.create();
end;

procedure TFormSpGoods.FormShow(Sender: TObject);
begin

  refreshGroup;
  refreshtable()
end;

procedure TFormSpGoods.MenuItem10Click(Sender: TObject);
var
  plu:string;
  res:integer;
begin
  if (StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount) then
  begin
    res:=MessageDlg('Удалить товар?',mtWarning,[ mbYes, mbNo],0);
    if 6 = res then begin
        plu:=StringGrid1.Cells[1,StringGrid1.Row];
        formstart.DB_query('DELETE FROM `sprgoods`  WHERE `plu`="'+plu+'" AND `isdelete`="1";');
        refreshtable();
      end;

  end;

end;

procedure TFormSpGoods.MenuItem1Click(Sender: TObject);
var
  plu:string;
  res:integer;
begin
  if (StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount) then
  begin
    res:=MessageDlg('Удалить товар?',mtWarning,[ mbYes, mbNo],0);
    if 6 = res then begin
        plu:=StringGrid1.Cells[1,StringGrid1.Row];
        formstart.DB_query('UPDATE `sprgoods` SET `isdelete`="1" WHERE `plu`="'+plu+'";');
        Stringgrid1.Cells[7,StringGrid1.Row] :='+';

      end;

  end;
end;

procedure TFormSpGoods.MenuItem2Click(Sender: TObject);
var
  plu:string;
begin
  if (StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount) then begin
    plu:=StringGrid1.Cells[1,StringGrid1.Row];
    flPLU:=PLU;
    modalresult:=1377;
  end;

end;

procedure TFormSpGoods.MenuItem3Click(Sender: TObject);
var
  plu:string;
begin
  if ((StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount))and(db_boolean(StringGrid1.Cells[8,StringGrid1.Row])) then begin
  end else begin
    plu:=StringGrid1.Cells[1,StringGrid1.Row];
    formedititem.flAlcCode:='';
//    formedititem.flPLU:=PLU;
//    formedititem.ShowModal;
    formedititem.CopyItem(plu);
    refreshtable();
  end;

end;

procedure TFormSpGoods.MenuItem4Click(Sender: TObject);
begin
  if formeditgroup.addNewGroup() then
    refreshGroup;
end;

procedure TFormSpGoods.MenuItem5Click(Sender: TObject);
var
  plu:string;
begin
  if ((StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount))and(db_boolean(StringGrid1.Cells[8,StringGrid1.Row])) then begin
     flSelectGroup:= StringGrid1.Cells[9,StringGrid1.Row];

     if formEditGroup.EditGroup(flselectgroup) then
     begin
       refreshgroup;
       refreshtable();
     end;
  end else begin
    plu:=StringGrid1.Cells[1,StringGrid1.Row];
//    formedititem.flAlcCode:='';
//    formedititem.flPLU:=PLU;
//    formedititem.ShowModal;
    formedititem.EditItem(plu,'');

  end;
  refreshtable();
end;

procedure TFormSpGoods.MenuItem6Click(Sender: TObject);
begin
  {
  formedititem.flAlcCode:='';
  formedititem.flPLU:='';
  formedititem.flNew:=true;
  formedititem.ShowModal;
  refreshtable();             }

  formedititem.NewItem;
  formedititem.flNew:=false;
  refreshtable();
end;

procedure TFormSpGoods.MenuItem7Click(Sender: TObject);
var
  plu:string;
begin
  if (StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount) then begin
    plu:=StringGrid1.Cells[1,StringGrid1.Row];
    formstart.DB_query('UPDATE `sprgoods` SET `isdelete`="0" WHERE `plu`="'+plu+'";');
    Stringgrid1.Cells[7,StringGrid1.Row] :='';
  end;

end;

procedure TFormSpGoods.MenuItem8Click(Sender: TObject);
begin
  refreshtable();
end;

procedure TFormSpGoods.MenuItem9Click(Sender: TObject);
begin
  if formEditGroup.EditGroup(flselectgroup) then
  begin
    refreshgroup;
  end;
end;

procedure TFormSpGoods.PopupMenu1Popup(Sender: TObject);
begin
  MenuItem2.Visible := flSelectItem;
  MenuItem1.visible:=true;
  MenuItem7.visible:=true;
  MenuItem10.visible:=true;
  if db_boolean(Stringgrid1.Cells[7,StringGrid1.Row]) then begin
    MenuItem1.Visible:=false
  end
  else  begin
    MenuItem7.Visible:=false;
    MenuItem10.Visible:=false;
  end;
end;

procedure TFormSpGoods.StringGrid1ButtonClick(Sender: TObject; aCol,
  aRow: Integer);
begin

end;

procedure TFormSpGoods.StringGrid1DblClick(Sender: TObject);
var
  plu:string;
begin
  if StringGrid1.Row>0 then begin
  if flSelectItem then begin
       MenuItem2Click(Sender);
    end else begin
      if ((StringGrid1.Row>0 )and (StringGrid1.Row<StringGrid1.RowCount))and(db_boolean(StringGrid1.Cells[8,StringGrid1.Row])) then begin
        flSelectGroup:= StringGrid1.Cells[9,StringGrid1.Row];
        refreshtable();
      end else begin
        plu:=StringGrid1.Cells[1,StringGrid1.Row];
        formedititem.EditItem(plu,'');
      end;

    end;
  end;
end;

procedure TFormSpGoods.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
//const
//  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin

  if (aCol=0)and (aRow<>0) then
   begin
     if ( db_boolean(Stringgrid1.Cells[8,arow])) then begin
         if Stringgrid1.Cells[8,arow]='1' then
         ilSprGoods.Draw(StringGrid1.Canvas, aRect.Left, aRect.Top+1, 2, True)
         else
           ilSprGoods.Draw(StringGrid1.Canvas, aRect.Left, aRect.Top+1, 3, True)
       end else begin
         if  db_boolean(Stringgrid1.Cells[7,aRow]) then
           ilSprGoods.Draw(StringGrid1.Canvas, aRect.Left, aRect.Top+1, 1, True)
         else
           ilSprGoods.Draw(StringGrid1.Canvas, aRect.Left, aRect.Top+1, 0, True);


     end;
   end else begin
     if (aRow<>0) and ( db_boolean(Stringgrid1.Cells[8,arow])) then  begin
       if not (gdFixed in aState) then // si no es el tituloŽ
         if not (gdSelected in aState) then
           begin
           (Sender as TStringGrid).Canvas.Brush.Color:=$ffefee;
           end
         else
           begin
            if Stringgrid1.Cells[8,arow] ='+' then
                (Sender as TStringGrid).Canvas.Brush.Color:=$222222
              else
           (Sender as TStringGrid).Canvas.Brush.Color:=$444444;
           (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
           end;

       //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
       (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);
     end;
   end;
end;

procedure TFormSpGoods.StringGrid1Enter(Sender: TObject);
var
  plu:string;
begin
end;

procedure TFormSpGoods.StringGrid1HeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if not IsColumn then begin
     Stringgrid1.Row:=index;
  end else begin

  end;
end;

procedure TFormSpGoods.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //showmessage(inttostr(key));
  // 35 - END;
  // 36 - HOME
  // 45 - INSERT
  // 46 - DELETE
  case key of
  35:begin
    key:=0;
    stringgrid1.row:= stringgrid1.RowCount-1;
  end;
  36: begin
    key:=0;
    stringgrid1.row:= 1;
  end;
  46: begin
    key:=0;
    MenuItem1Click(Sender);
  end;
  45: begin
    key:=0;
    MenuItem6Click(Sender);
  end;
  {MenuItem6Click(Sender);}
  {else
    showmessage(inttostr(KEY))   }
  end;
end;

procedure TFormSpGoods.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    StringGrid1DblClick(Sender);
    Stringgrid1.SetFocus;
  end else begin
    //showmessage('key'+inttostr(ord(key)));
  end;

end;

procedure TFormSpGoods.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin

end;

procedure TFormSpGoods.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer
  );
begin
  // flSelectGroup:= StringGrid1.Cells[9,StringGrid1.Row];
end;

procedure TFormSpGoods.tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
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
  if Node=nil then begin
    flSelectGroup:='';
    refreshtable;
    exit;
  end;
  ind:= Node.SelectedIndex;
    flSelectGroup:=flGroupGoods.Strings[ind];
    StringGrid1.RowCount:=1;
    ind:=0;
  refreshtable();


end;

procedure TFormSpGoods.tvGroupGoodsDblClick(Sender: TObject);
begin
{  if formEditGroup.EditGroup(flselectgroup) then
  begin
    refreshgroup;

  end;      }
end;

procedure TFormSpGoods.BitBtn1Click(Sender: TObject);
var
  lf:TStringList;
  i:integer;
  str1:string;
  ii,ij:integer;
  tmp1,name2, price1,
  plu1,name1,bc1,ves1:string;
begin
  if opendialog1.Execute then begin
    lf:=TStringList.Create;
    lf.LoadFromFile(opendialog1.FileName);
   // lf.Text:=ANsiToUtf8(lf.Text);
    for i:=1 to lf.Count do begin
      str1:=lf.Strings[i];
      if ((str1[1]= '#')or (str1[1]= '@'))or(str1[1]='$') then
      begin
            if Length(str1)>1 then
              if str1[2]<>'#' then begin
                 str1:=copy(str1,2,length(str1));
                 ii:=pos(';',str1);
                 plu1:=copy(str1,1,ii-1);
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 bc1:=ansitoutf8(copy(str1,1,ii-1));
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 name1:=ansitoutf8(copy(str1,1,ii-1));
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 name2:=ansitoutf8(copy(str1,1,ii-1));
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 ves1:='';
                 price1:=ansitoutf8(copy(str1,1,ii-1)); {
                 ij:=pos(',',price1);
                 if ij>0 then price1[ij]:='.';
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 tmp1:=ansitoutf8(copy(str1,1,ii-1));
           {      for ij:=0 to 18 do begin
                   str1:=copy(str1,ii+1,length(str1));
                   ii:=pos(';',str1);
                   tmp1:=ansitoutf8(copy(str1,1,ii-1));
                 end;  }

                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 ves1:=ansitoutf8(copy(str1,1,ii-1));
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
         //        ves1:=ansitoutf8(copy(str1,1,ii-1));
                 if ves1='1' then ves1:='+';
                 str1:=copy(str1,ii+1,length(str1));
                 ii:=pos(';',str1);
                 tmp1:=ansitoutf8(copy(str1,1,ii-1));  }
             //    str1:=copy(str1,ii+1,length(str1));
                 // ==== проверяем и записываем данные =
                 // == проверяем Штрихкода ===
                 ij:=pos(',',bc1);
                 if price1='' then
                   price1:='0.0';
                 while ij<>0 do begin
                   tmp1:=copy(bc1,1,ij-1);
                   formstart.recbuf:= formstart.DB_query('SELECT `extcode`,`alcgoods` FROM `sprgoods` WHERE `barcodes`="'+bc1+'" LIMIT 1;');
                   // == weightgood - весовой --- делимый. россыпь
                   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
                   if formstart.rowbuf = nil then begin
                     formstart.DB_query('INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`) VALUES ('
                     +'"'+plu1+'","'+replaceStr(name1)+'","'+replaceStr(name2)+'","'+price1+'","+","'+plu1+'","'+trim(tmp1)+'","'+trim(ves1)+'");');
                   end;
                   bc1:=copy(bc1,ij+1,length(bc1));
                   ij:=pos(',',bc1);
                 end;
                 formstart.recbuf:= formstart.DB_query('SELECT `extcode`,`alcgoods` FROM `sprgoods` WHERE `barcodes` LIKE "%'+bc1+'%" LIMIT 1;');
                 // == weightgood - весовой --- делимый. россыпь
                 formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
                 if formstart.rowbuf = nil then begin
                   formstart.DB_query('INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`) VALUES ('
                   +'"'+plu1+'","'+replaceStr(name1)+'","'+replaceStr(name2)+'","'+price1+'","+","'+plu1+'","'+trim(bc1)+'","'+trim(ves1)+'");');
                 end;
             end;

      end
      else begin
        // 1    ;2200001      ;Сыр РОССИЙСКИЙ Золотоноша ()         ;Сыр РОССИЙСКИЙ Золотоноша ()         ;382,00;0;0;1,1,1,0,0,0,0,1;;;;;;1,000;;;1;0;;;;;;;1;;;;;;;;
        // 14414;2900948005694;Пирожок ШАРМ с яйцом  и рисом 100г ();Пирожок ШАРМ с яйцом  и рисом 100г ();22,00 ;0;0;0,1,1,0,0,0,0,1; ; ; ; ; ;1,000;;;1;0;;;;;;; ;;;;;;;;
        // 12548;4600682addNewGroup124351;Пиво БАЛТИКА Лайт с/б 0,5л 4%;Пиво БАЛТИКА Лайт с/б 0,5л 4%                ;      ; ;0;0;0            ;0;0;0;0;0;0;0;1
        ii:=pos(';',str1);
        plu1:=copy(str1,1,ii-1);
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        bc1:=ansitoutf8(copy(str1,1,ii-1));
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        name1:=ansitoutf8(copy(str1,1,ii-1));
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        name2:=ansitoutf8(copy(str1,1,ii-1));
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        price1:=ansitoutf8(copy(str1,1,ii-1));
        ij:=pos(',',price1);
        if ij>0 then price1[ij]:='.';
        ves1:='';
{        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        tmp1:=ansitoutf8(copy(str1,1,ii-1));
  {      for ij:=0 to 18 do begin
          str1:=copy(str1,ii+1,length(str1));
          ii:=pos(';',str1);
          tmp1:=ansitoutf8(copy(str1,1,ii-1));
        end;  }

        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        ves1:=ansitoutf8(copy(str1,1,ii-1));
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
   //     ves1:=ansitoutf8(copy(str1,1,ii-1));
        if ves1='1' then ves1:='+';
        str1:=copy(str1,ii+1,length(str1));
        ii:=pos(';',str1);
        tmp1:=ansitoutf8(copy(str1,1,ii-1));
        str1:=copy(str1,ii+1,length(str1));          }
            if price1='' then
             price1:='0.0';
        // ==== проверяем и записываем данные =
        // == проверяем Штрихкода ===
        ij:=pos(',',bc1);
        while ij<>0 do begin
          tmp1:=copy(bc1,1,ij-1);
          formstart.recbuf:= formstart.DB_query('SELECT `extcode`,`alcgoods` FROM `sprgoods` WHERE `barcodes`="'+bc1+'" LIMIT 1;');
          // == weightgood - весовой --- делимый. россыпь
          formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
          if formstart.rowbuf = nil then begin
            formstart.DB_query('INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`) VALUES ('
            +'"'+plu1+'","'+replaceStr(name1)+'","'+replaceStr(name2)+'","'+price1+'","+","'+plu1+'","'+trim(tmp1)+'","'+trim(ves1)+'");');
          end;
          bc1:=copy(bc1,ij+1,length(bc1));
          ij:=pos(',',bc1);
        end;
        formstart.recbuf:= formstart.DB_query('SELECT `extcode`,`alcgoods` FROM `sprgoods` WHERE `barcodes` LIKE "%'+bc1+'%" LIMIT 1;');
        // == weightgood - весовой --- делимый. россыпь
        formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
        if formstart.rowbuf = nil then begin
          formstart.DB_query('INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`) VALUES ('
          +'"'+plu1+'","'+replaceStr(name1)+'","'+replaceStr(name2)+'","'+price1+'","+","'+plu1+'","'+trim(bc1)+'","'+trim(ves1)+'");');
        end;
      end ;
    end;
    lf.free;

  end;
end;

procedure TFormSpGoods.BitBtn2Click(Sender: TObject);
//var
  //flsku:longint;
begin
  //if  formStart.GetConstant('NumberSKU')='' then
  //     flSKU:=1
  //   else
  //     flSKU:=strtoint(formStart.GetConstant('NumberSKU'))+1 ; // === Номер последнего товара
  formedititem.flAlcCode:='';
  formedititem.flPLU:='';
  formedititem.flNew:=true;
  formedititem.NewItem;
  refreshtable();
//  formedititem.flNew:=false;
end;

procedure TFormSpGoods.BitBtn3Click(Sender: TObject);
var
  ind:integer;
  typegood:string;
  aName1:String;
begin
  aName1:= edit1.text;
  while pos(' ',aName1)>0 do
    aName1[pos(' ',aName1)] := '%';

  if flSelectGroup='' then begin
    StringGrid1.RowCount:=1;
    ind:=0;
    formstart.recbuf:= formstart.DB_query(
    'SELECT `plu`,`name`,`alcgoods`,`weightgood`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `alcName`,`isdelete` FROM `sprgoods` WHERE (`barcodes` LIKE "%'+aName1+'%") OR (UPPER(`name`) LIKE UPPER("%'+aName1+'%")) OR (UPPER(`fullname`) LIKE "%'+edit1.text+'%") OR (UPPER(`name`) LIKE "%'+edit1.text+'%") GROUP BY `plu` ORDER BY `name` ASC;');
    // == weightgood - весовой --- делимый. россыпь
    formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    while formstart.rowbuf <> nil do begin
      ind:=ind+1;
      StringGrid1.RowCount:=ind+1;
      typegood:='';
      StringGrid1.Cells[1,ind]:=formstart.rowbuf[0];
      StringGrid1.Cells[2,ind]:=formstart.rowbuf[1];
      if formstart.rowbuf[2]='1' then
         typegood:='Алкоголь';
      if formstart.rowbuf[3]='1' then
         typegood:='Весовой';
      StringGrid1.Cells[5,ind]:=typegood;
      StringGrid1.Cells[3,ind]:=formstart.rowbuf[4];
      StringGrid1.Cells[4,ind]:='0';
      StringGrid1.Cells[6,ind]:=formstart.rowbuf[5];
      StringGrid1.Cells[7,ind]:=formstart.rowbuf[6];
      formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    end;
  end;
end;

procedure TFormSpGoods.BitBtn4Click(Sender: TObject);
begin
  edit1.text:='';
  refreshtable();
end;

procedure TFormSpGoods.BitBtn5Click(Sender: TObject);
begin
  if formeditgroup.addNewGroup() then
    refreshGroup;
end;

procedure TFormSpGoods.BitBtn6Click(Sender: TObject);
begin

end;

procedure TFormSpGoods.Edit1Change(Sender: TObject);
begin

end;

procedure TFormSpGoods.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    BitBtn3Click(Sender);

  end;
end;

end.

