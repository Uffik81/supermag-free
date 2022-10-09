unit unitselgroup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons;

type

  { TFormSelGroup }

  TFormSelGroup = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ToolBar1: TToolBar;
    tvGroupGoods: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
    procedure tvGroupGoodsDblClick(Sender: TObject);
    procedure tvGroupGoodsKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    flSelGroup:string;
    flNameGroup:string;
    flGroupGoods:tstringlist;
    function selectfolder():string;
  end;

var
  FormSelGroup: TFormSelGroup;

implementation
uses unitstart, mysql50;
{$R *.lfm}

{ TFormSelGroup }

procedure TFormSelGroup.FormShow(Sender: TObject);
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
   ind:=0;
   query :='SELECT `groupid`,`name` FROM `sprgroups` WHERE `ownergroupid`='''' ORDER BY `name` ASC;';
   formstart.recbuf:= formstart.DB_query(query);
   // == weightgood - весовой --- делимый. россыпь
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   while formstart.rowbuf <> nil do begin
     twRoot:=tvGroupGoods.Items.Add(nil,formstart.rowbuf[1]);
     twroot.SelectedIndex:=flGroupGoods.Count;
     flGroupGoods.Add(formstart.rowbuf[0]);
     addItem1(twRoot,formstart.rowbuf[0]);
     formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
   end;


end;

procedure TFormSelGroup.tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
begin
   if node<>nil then begin
     flSelGroup:=flGroupGoods.Strings[node.SelectedIndex];
     flNameGroup:=node.Text;

   end;
end;

procedure TFormSelGroup.tvGroupGoodsDblClick(Sender: TObject);
begin
  BitBtn1Click(nil);
end;

procedure TFormSelGroup.tvGroupGoodsKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
     BitBtn1Click(nil);
     key:=#0;
  end;
end;

procedure TFormSelGroup.FormCreate(Sender: TObject);
begin
  flGroupGoods:=tstringlist.create;
end;

procedure TFormSelGroup.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;
end;

procedure TFormSelGroup.BitBtn1Click(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormSelGroup.BitBtn2Click(Sender: TObject);
begin
  modalresult:=0;
  close;
end;

function TFormSelGroup.selectfolder: string;
begin
  result:='';
  if showmodal=1377 then
    result:=flSelGroup;

end;

end.

