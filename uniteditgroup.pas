unit uniteditgroup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TFormEditGroup }

  TFormEditGroup = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    cbEditPrice: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    flidGroup:string;
    flNew:boolean;
    flOwnGroupid:string;
    { public declarations }
    function addNewGroup():boolean;
    function EditGroup(idGroup:string):boolean;

  end;

var
  FormEditGroup: TFormEditGroup;

implementation
uses unitstart,unitselgroup, mysql50;
{$R *.lfm}

{ TFormEditGroup }

procedure TFormEditGroup.BitBtn1Click(Sender: TObject);
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  if flNew then begin
    xrecbuf:=formstart.DB_query('SELECT `name` FROM `sprgroups` where `groupid`="'+flIdGroup+'"');
    xrowbuf:=formstart.db_next(xrecbuf);
    if xrowbuf<>nil then begin
      showmessage('С таким кодом группа существует!');
    end else
      modalresult:=1377;
  end else
    modalresult:=1377;

end;

procedure TFormEditGroup.BitBtn2Click(Sender: TObject);
begin
  flOwnGroupid:=formselgroup.selectfolder();
  if flOwnGroupId<>'' then
    ComboBox1.Caption:=formselgroup.flNameGroup;
end;

procedure TFormEditGroup.BitBtn3Click(Sender: TObject);
begin
  flOwnGroupId:='';
  ComboBox1.Caption:='';
end;

procedure TFormEditGroup.BitBtn4Click(Sender: TObject);
begin
  modalresult:=0;
  close;
end;

procedure TFormEditGroup.Edit1Change(Sender: TObject);
begin

end;

procedure TFormEditGroup.Edit1KeyPress(Sender: TObject; var Key: char);
begin
   if key=#13 then begin
    key:=#0;
    self.SelectNext(ActiveControl,True,True);
  end;
end;

procedure TFormEditGroup.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormEditGroup.FormCreate(Sender: TObject);
begin

end;

procedure TFormEditGroup.FormShow(Sender: TObject);
begin

end;

function TFormEditGroup.addNewGroup: boolean;
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  twRoot:TTreeNode;
  owngroup:string;
begin
  result:=false;
  owngroup:='';
  flIdgroup:=formstart.GetConstant('numbergrp');
  if flidgroup = '' then
    flidgroup:='100000'
   else
     flidgroup:=inttostr(strtoint(flidgroup)+1);

  if showmodal = 1377 then begin
    owngroup:=flOwnGroupid;
    xrecbuf:=formstart.DB_query('SELECT `name` FROM `sprgroups` where `groupid`="'+flIdGroup+'"');
    xrowbuf:=formstart.db_next(xrecbuf);
    if xrowbuf<>nil then begin
      showmessage('С таким кодом группа существует!');
    end else
    begin
      result:=true;
      formstart.DB_query('INSERT INTO `sprgroups` (`groupid`,`name`,`ownergroupid`,`fullname`,`viewcash`,`alcgoods`,`updating`) VALUES ('''+flIdGroup+''','''+edit1.text+''','''+owngroup+''','''+edit1.text+''',''+'','''',''+'')');
      formstart.SetConstant('numbergrp',flidgroup);
    end;
  end;

end;

function TFormEditGroup.EditGroup(idGroup: string): boolean;
  var
    query:string;
    xrowbuf:MYSQL_ROW;
    xrecbuf:PMYSQL_RES;
    twRoot:TTreeNode;
    owngroup:string;
  begin
    flIdgroup:=idGroup;
    result:=false;
    xrecbuf:=formstart.DB_query('SELECT `name`,`ownergroupid`,(SELECT `gp1`.`name` FROM `sprgroups` as `gp1` WHERE `gp1`.`groupid`=`sprgroups`.`ownergroupid`) AS `grpname` FROM `sprgroups` where `groupid`="'+flIdGroup+'"');
    xrowbuf:=formstart.db_next(xrecbuf);
    if xrowbuf<>nil then begin
      flOwnGroupid:= xrowbuf[1];
      ComboBox1.Caption:=xrowbuf[2];
      Edit1.Text:=xrowbuf[0];
    end ;

    if showmodal = 1377 then begin
      owngroup:=flOwnGroupid;
        result:=true;
        formstart.DB_query('UPDATE `sprgroups` SET  `name`='''+edit1.text+''',`ownergroupid`='''+owngroup+''' WHERE `groupid`='''+flIdGroup+''';');

    end;

end;

end.

