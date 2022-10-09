unit unitDocDelete;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CheckLst, Buttons;

type

  { TFormDocDelete }

  TFormDocDelete = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    slDate:TStringList;
    slnum:TStringList;
  end;

var
  FormDocDelete: TFormDocDelete;

implementation

{$R *.lfm}
uses unitstart;

{ TFormDocDelete }

procedure TFormDocDelete.FormShow(Sender: TObject);
begin
  slDate.Clear;
  slnum.Clear;
  formStart.recbuf:= formstart.DB_query('SELECT `numdoc`,`datedoc` FROM `docjurnale` WHERE `isDelete`="+";');
  formStart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  while formStart.rowbuf<>nil do begin
    CheckListBox1.Items.Add('Документ '+formStart.rowbuf[0]+' от '+formStart.rowbuf[1]);
    slnum.Add(formStart.rowbuf[0]);
    slDate.Add(formStart.rowbuf[1]);
    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
  end;
end;

procedure TFormDocDelete.FormCreate(Sender: TObject);
begin
  slDate:=TStringList.Create;
  slnum:=TStringList.Create;
end;

procedure TFormDocDelete.BitBtn2Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
     CheckListBox1.Checked[i]:=true;
end;

procedure TFormDocDelete.BitBtn1Click(Sender: TObject);
var
  i:integer;
begin
  i:=MessageDlg('Уверены что хотите безвозвратно удалить документы?',mtConfirmation,mbYesNo,0);
  if i = 6 then
  for i:=0 to CheckListBox1.Items.Count-1 do
    if CheckListBox1.Checked[i] then
    begin
      formstart.DB_query('DELETE FROM `docjurnale` WHERE `isDelete`="+" and (`numdoc`="'+slNum.Strings[i]+'" and `datedoc`="'+slDate.Strings[i]+'");');
      formstart.DB_query('DELETE FROM `doc211` WHERE  (`numdoc`="'+slNum.Strings[i]+'" and `datedoc`="'+slDate.Strings[i]+'");');
      formstart.DB_query('DELETE FROM `doc21` WHERE  (`numdoc`="'+slNum.Strings[i]+'" and `datedoc`="'+slDate.Strings[i]+'");');
    end;
  ShowMessage('Операция выполнена!');
end;

procedure TFormDocDelete.BitBtn3Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
     CheckListBox1.Checked[i]:=false;
end;

end.

