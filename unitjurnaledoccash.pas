unit unitjurnaledoccash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  Grids, Menus, ExtDlgs, mysql50, Types;

type

  { TFormJurnaleDocCash }

  TFormJurnaleDocCash = class(TForm)
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn26: TBitBtn;
    cldDialog: TCalendarDialog;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem60: TMenuItem;
    pmMenuCash: TPopupMenu;
    StringGrid2: TStringGrid;
    ToolBar7: TToolBar;
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItem54Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem56Click(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private

  public

  end;

var
  FormJurnaleDocCash: TFormJurnaleDocCash;

implementation

{$R *.lfm}
uses unitstart
  ,unitcashreport
  ,unitActWriteBeer
  ,unitrepoborotap
  ,unitsalesbeer
  ,unitReportSalesGoods;

{ TFormJurnaleDocCash }

procedure TFormJurnaleDocCash.FormShow(Sender: TObject);
var
  i:integer;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  query:='SELECT `numdoc`,`datedoc`,`summ`,`kassir`,`numkass`,`banking`,`regfr`,`regegais` FROM `doccash` WHERE `typetrans`="40" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',now())+'";';
  xrecbuf:=formstart.DB_query(query,'doccash');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  i:=0;
  while xrowbuf <> nil do begin
    i:=i+1;
    StringGrid2.RowCount:=i+1;
    StringGrid2.Rows[i].Clear;
    StringGrid2.Cells[1,i]:=xrowbuf[0];
    StringGrid2.Cells[2,i]:=xrowbuf[1];
    StringGrid2.Cells[4,i]:=xrowbuf[2];
    StringGrid2.Cells[3,i]:=xrowbuf[3];
    StringGrid2.Cells[8,i]:=xrowbuf[5];
    StringGrid2.Cells[7,i]:=xrowbuf[6];
    StringGrid2.Cells[6,i]:=xrowbuf[7];
    xrowbuf:=formstart.DB_Next(xrecbuf);
  end;


end;

procedure TFormJurnaleDocCash.MenuItem54Click(Sender: TObject);
begin
  formrepoborotap.showmodal;
end;

procedure TFormJurnaleDocCash.MenuItem55Click(Sender: TObject);
begin
  FormReportSalesGoods.ShowModal;
end;

procedure TFormJurnaleDocCash.MenuItem56Click(Sender: TObject);
begin
  formsalesbeer.PrintAlcReport(FormatDateTime('YYYY-MM-DD',now()));
end;

procedure TFormJurnaleDocCash.MenuItem60Click(Sender: TObject);
begin

end;

procedure TFormJurnaleDocCash.StringGrid2DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin


    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[aRow mod 4];
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 4];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);


end;

procedure TFormJurnaleDocCash.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormJurnaleDocCash.BitBtn16Click(Sender: TObject);
begin
  FormSalesBeer.clearcheck();
  FormSalesBeer.showmodal;
end;

procedure TFormJurnaleDocCash.BitBtn20Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn20.ClientOrigin;
  pmMenuCash.PopUp(r.x,r.y+BitBtn20.Height);

end;

procedure TFormJurnaleDocCash.BitBtn21Click(Sender: TObject);
begin
  formcashreport.showmodal;
end;

procedure TFormJurnaleDocCash.BitBtn26Click(Sender: TObject);
begin
  if db_boolean(FormStart.GetConstant('autoactwritebeer')) then
  if  cldDialog.Execute then  begin
      formActWriteBeer.CurData:=cldDialog.Date;
      formActWriteBeer.showmodal;
  end;
end;

end.

