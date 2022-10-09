unit unitjurnalets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,  Forms, Controls, Graphics,
  Dialogs, ComCtrls, Buttons, ExtCtrls, Grids;

type

  { TFormJurnaleTS }

  TFormJurnaleTS = class(TForm)
    bbAddGoods: TBitBtn;
    bbAddGroupGoods: TBitBtn;
    bbRefGoods: TBitBtn;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    pngoods: TPanel;
    pnFunction: TPanel;
    sgGoods: TStringGrid;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    ToolBar6: TToolBar;
    tvGroupGoods: TTreeView;
    procedure bbAddGroupGoodsClick(Sender: TObject);
    procedure bbRefGoodsClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pngoodsClick(Sender: TObject);
    procedure sgGoodsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
    procedure tvGroupGoodsChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    flSelectGroup:String;
    flPLU:String;
    flGroupGoods:TStringList;
    procedure refreshgoods(idGroup:string);
    procedure refreshGroup;
  end;

var
  FormJurnaleTS: TFormJurnaleTS;

implementation
uses unitstart, unitjurnale,unitinputstring,mysql50;
{$R *.lfm}

{ TFormJurnaleTS }

procedure TFormJurnaleTS.FormResize(Sender: TObject);
begin
  WindowState:=wsMaximized;
end;

procedure TFormJurnaleTS.pngoodsClick(Sender: TObject);
begin

end;

procedure TFormJurnaleTS.sgGoodsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin

end;

procedure TFormJurnaleTS.tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
  var
    ind:integer;
    typegood:string;
  begin
    if Node=nil then begin
      flSelectGroup:='';
      ind:=0;
    end else begin
    ind:= Node.SelectedIndex;
    flSelectGroup:=flGroupGoods.Strings[ind];
    end;
    begin
      sgGoods.RowCount:=1;
      ind:=0;
      formstart.recbuf:= formstart.DB_query('SELECT `plu`,`name`,`alcgoods`,`weightgood`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `alcName` FROM `sprgoods` WHERE `groupid`="'+flSelectGroup+'" GROUP BY `plu` ORDER BY `name` ASC;');
      // == weightgood - весовой --- делимый. россыпь
      formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
      while formstart.rowbuf <> nil do begin
        ind:=ind+1;
        sgGoods.RowCount:=ind+1;
        typegood:='';
        sgGoods.Cells[1,ind]:=formstart.rowbuf[0];
        sgGoods.Cells[2,ind]:=formstart.rowbuf[1];
        if formstart.rowbuf[2]='1' then typegood:='Алкоголь';
        if formstart.rowbuf[3]='1' then typegood:='Весовой';
        sgGoods.Cells[3,ind]:=typegood;
        sgGoods.Cells[5,ind]:=formstart.rowbuf[4];
        sgGoods.Cells[4,ind]:='0';
        sgGoods.Cells[6,ind]:=formstart.rowbuf[5];
        formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
      end;
    end;


end;

procedure TFormJurnaleTS.tvGroupGoodsChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin

end;

procedure TFormJurnaleTS.refreshgoods(idGroup: string);
var
    typegood:string;
    query:string;
    ind:integer;
begin
   sgGoods.RowCount:=1;
   ind:=0;
   query :='SELECT `plu`,`name`,`alcgoods`,`weightgood`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `alcName` FROM `sprgoods` WHERE `groupid`='''+idGroup+''' GROUP BY `plu` ORDER BY `name` ASC;';
   formstart.recbuf:= formstart.DB_query(query);
   // == weightgood - весовой --- делимый. россыпь
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   while formstart.rowbuf <> nil do begin
     ind:=ind+1;
     sgGoods.RowCount:=ind+1;
     typegood:='';
     sgGoods.Cells[1,ind]:=formstart.rowbuf[0];
     sgGoods.Cells[2,ind]:=formstart.rowbuf[1];
     if db_boolean(formstart.rowbuf[2]) then
       typegood:='Алкоголь';
     if db_boolean(formstart.rowbuf[3]) then
       typegood:='Весовой';
     sgGoods.Cells[3,ind]:=typegood;
     sgGoods.Cells[5,ind]:=formstart.rowbuf[4];
     sgGoods.Cells[4,ind]:='0';
     sgGoods.Cells[6,ind]:=formstart.rowbuf[5];
     formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   end;

end;

procedure TFormJurnaleTS.refreshGroup;
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

procedure TFormJurnaleTS.BitBtn1Click(Sender: TObject);
begin
  modalResult:=1377;
end;

procedure TFormJurnaleTS.bbRefGoodsClick(Sender: TObject);
begin
  refreshgoods('');
end;

procedure TFormJurnaleTS.bbAddGroupGoodsClick(Sender: TObject);
begin

end;

procedure TFormJurnaleTS.BitBtn2Click(Sender: TObject);
begin
  hide;
   formjurnale.showmodal;
  show;
end;

procedure TFormJurnaleTS.BitBtn3Click(Sender: TObject);
begin
  forminputstring.ShowOnTop;
end;

end.

