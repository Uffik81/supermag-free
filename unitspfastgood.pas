unit unitspfastgood;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ValEdit, ComCtrls, Buttons;

type

  { TFormspfastgood }

  TFormspfastgood = class(TForm)
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Formspfastgood: TFormspfastgood;

implementation
uses unitstart, unitspgoods;
{$R *.lfm}

{ TFormspfastgood }

procedure TFormspfastgood.FormShow(Sender: TObject);
var
  i:integer;
begin
  stringgrid1.Clean;
  stringgrid1.rowcount:=10;
  for i:=1 to 9 do begin
     stringgrid1.Cells[0,i]:=inttostr(i);
     formstart.recbuf:= formstart.DB_query(
     'SELECT `plu`,`name`,`price` FROM `sprfastgood` WHERE `id`="'+trim(inttostr(i))+'" ;');
     // == weightgood - весовой --- делимый. россыпь
     formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
     if formstart.rowbuf <> nil then begin
       stringgrid1.Cells[1,i]:=formstart.rowbuf[0];
       stringgrid1.Cells[2,i]:=formstart.rowbuf[1];
       stringgrid1.Cells[3,i]:=formstart.rowbuf[2];
     end;

  end;
end;

procedure TFormspfastgood.BitBtn1Click(Sender: TObject);
var
  i:integer;
begin
  formstart.DB_query('DELETE FROM `sprfastgood` ;');
  for i:=1 to 9 do begin
     formstart.DB_query('INSERT INTO `sprfastgood` (`id`,`plu`,`name`,`price`,`alcgoods`,`updating`) VALUES ('''+stringgrid1.Cells[0,i]+''','''+stringgrid1.Cells[1,i]+''','''+stringgrid1.Cells[2,i]+''','''+stringgrid1.Cells[3,i]+''','''','''');');
  end;

end;

procedure TFormspfastgood.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  BitBtn1Click(Sender);
end;

procedure TFormspfastgood.StringGrid1DblClick(Sender: TObject);
var
  flPLU:string;
  spgoods:Tformspgoods;
  i:integer;
begin
  spgoods:=Tformspgoods.Create(nil);
  spgoods.flSelectItem:=true;
  if spgoods.ShowModal=1377 then begin
    flPLU:=spgoods.flPLU;
    stringgrid1.Cells[1,stringgrid1.Row]:=flPLU;
    formstart.recbuf:= formstart.DB_query(
    'SELECT `plu`,`name`,`currentprice` FROM `sprgoods` WHERE `plu`="'+flPLU+'" GROUP BY `plu` ORDER BY `name` ASC;');
    // == weightgood - весовой --- делимый. россыпь
    formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    if formstart.rowbuf <> nil then begin

      stringgrid1.Cells[2,stringgrid1.Row]:=formstart.rowbuf[1];
      stringgrid1.Cells[3,stringgrid1.Row]:=formstart.rowbuf[2];
    end;

  end;
  spgoods.flSelectItem:=false;
  spgoods.Destroy;
  //spgoods.Free;
  formstart.DB_query('DELETE FROM `sprfastgood` ;');
  for i:=1 to 9 do begin
     if stringgrid1.Cells[3,i]= '' then
         stringgrid1.Cells[3,i] := '0';
     formstart.DB_query('INSERT INTO `sprfastgood` (`id`,`plu`,`name`,`price`,`alcgoods`,`updating`) VALUES ('''+stringgrid1.Cells[0,i]+''','''+stringgrid1.Cells[1,i]+''','''+stringgrid1.Cells[2,i]+''','''+stringgrid1.Cells[3,i]+''','''','''');');
  end;

end;

end.

