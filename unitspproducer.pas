unit unitSpProducer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Menus, Grids, Buttons, StdCtrls, mysql50;

type

  { TFormSpProducer }

  TFormSpProducer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Edit1: TEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure ToggleBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    SelProducer:String;
    NameFl:String;
    flINNFilter:String;
    function SelectClientToMove():String;
  end;

var
  FormSpProducer: TFormSpProducer;

implementation

{$R *.lfm}
uses unitstart,uniteditproducer;
{ TFormSpProducer }

procedure TFormSpProducer.MenuItem1Click(Sender: TObject);
begin

end;

procedure TFormSpProducer.Panel1Click(Sender: TObject);
begin

end;
function TFormSpProducer.SelectClientToMove: String;
begin
  result:='';
  flINNFilter:=formStart.FirmINN;
  if ShowModal = 1377 then begin
    result:= SelProducer;
  end;

  flINNFilter:='';
end;

procedure TFormSpProducer.StringGrid1DblClick(Sender: TObject);
begin
  if StringGrid1.Row>0 then begin
    SelProducer:=StringGrid1.Rows[StringGrid1.Row].Strings[1];
    formEditProducer.flClientRegId:=SelProducer;
    formEditProducer.ShowOnTop;
  end;
end;

procedure TFormSpProducer.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
  if aRow>=0 then begin
    SelProducer:=StringGrid1.Rows[aRow].Strings[1];
  end;
end;

procedure TFormSpProducer.ToggleBox1Change(Sender: TObject);
begin


end;

procedure TFormSpProducer.FormShow(Sender: TObject);
var
  Query:String;
  i:integer;
begin
StringGrid1.clear;
  if flINNFilter<>'' then begin
      query:='SELECT `ClientRegId`,`FullName`,`inn`,`kpp`,`description` FROM `spproducer` WHERE `inn`="'+flINNFilter+'" ORDER BY `ClientRegId`' ;
    end else begin
    if edit1.text<>'' then
      query:='SELECT `ClientRegId`,`FullName`,`inn`,`kpp`,`description` FROM `spproducer` WHERE UPPER(`fullname`) LIKE ''%'+edit1.text+'%'' ORDER BY `ClientRegId`'
    else
      query:='SELECT `ClientRegId`,`FullName`,`inn`,`kpp`,`description` FROM `spproducer` ORDER BY `ClientRegId`' ;

    end;
formStart.recbuf := formStart.DB_query(Query);
formStart.rowbuf := formstart.DB_next(formStart.recbuf);
StringGrid1.RowCount:=1;
i:=0;
while formStart.rowbuf<>nil do begin
  i:=StringGrid1.RowCount;
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
//    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
  StringGrid1.cells[1,i]:=formStart.rowbuf[0];
  StringGrid1.cells[2,i]:=formStart.rowbuf[1];
  StringGrid1.cells[3,i]:=formStart.rowbuf[2];
  StringGrid1.cells[4,i]:=formStart.rowbuf[3];
  StringGrid1.cells[5,i]:=formStart.rowbuf[4];
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
end;
formstart.disconnectDB();

end;

procedure TFormSpProducer.BitBtn1Click(Sender: TObject);
begin
  modalresult:=1377;
end;

procedure TFormSpProducer.BitBtn2Click(Sender: TObject);
begin
   edit1.text:='';
   FormShow(sender);
end;

procedure TFormSpProducer.BitBtn3Click(Sender: TObject);
begin
    FormShow(sender);
end;

end.

