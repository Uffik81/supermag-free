unit unitprintticket;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, LR_Class, LR_DSet, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Grids, StdCtrls, Buttons, ComCtrls;

type

  { TFormPrintTicket }

  TFormPrintTicket = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    ind:integer;
    typeTicket1:integer;
  end;

var
  FormPrintTicket: TFormPrintTicket;

implementation

{$R *.lfm}
uses
  unitstart,
  mysql50,
  unitspgoods;

{ TFormPrintTicket }

procedure TFormPrintTicket.frUserDataset1First(Sender: TObject);
begin
  ind:=1;
end;

procedure TFormPrintTicket.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  if Stringgrid1.RowCount < ind+1 then
   eof:=true;
end;

procedure TFormPrintTicket.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  case ParName of
   'barcode':ParValue:=StringGrid1.Cells[2,ind];
   'NameFirm':ParValue:=formstart.FirmShortName;
   'DateDoc':ParValue:=FormatDateTime('DD.MM.YYYY',DateTimePicker1.Date);
   'NumPLU':ParValue:=StringGrid1.Cells[0,ind];
   'NameItem':ParValue:=StringGrid1.Cells[1,ind];
   'PriceItem':ParValue:=formstart.StrtoFloat(StringGrid1.Cells[4,ind]);
   'InItem':ParValue:=StringGrid1.Cells[3,ind];
   'Valuta':ParValue:='руб.';
  end;
end;

procedure TFormPrintTicket.BitBtn1Click(Sender: TObject);
var
  flPLU:string;
  spgoods:Tformspgoods;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  i:integer;
begin

  typeTicket1:=ComboBox1.Items.IndexOf(ComboBox1.Caption);
  spgoods:=Tformspgoods.Create(nil);
  spgoods.flSelectItem:=true;
  if spgoods.ShowModal=1377 then begin
    i:=stringgrid1.RowCount;
    stringgrid1.RowCount:=i+1;
    flPLU:=spgoods.flPLU;
    stringgrid1.Row:=i;
    stringgrid1.Cells[0,i]:=flPLU;
    xrecbuf:= formstart.DB_query(
    'SELECT `plu`,`name`,`currentprice`,`weightgood`,`barcodes` FROM `sprgoods` WHERE `plu`="'+flPLU+'" GROUP BY `plu` ORDER BY `name` ASC;');
    // == weightgood - весовой --- делимый. россыпь
    xrowbuf:=formstart.DB_Next(xrecbuf);
    if xrowbuf <> nil then begin
      DefaultFormatSettings.DecimalSeparator:='.';
      stringgrid1.Cells[2,i]:=xrowbuf[4];
      stringgrid1.Cells[1,i]:=xrowbuf[1];
      stringgrid1.Cells[4,i]:=xrowbuf[2];
      stringgrid1.Cells[3,i]:='шт.';
      if typeTicket1 = 0 then begin
        if db_boolean(xrowbuf[3]) then begin
          stringgrid1.Cells[3,i]:='кг.';
        end;
      end else begin
        if typeTicket1 = 3 then begin
         if db_boolean(xrowbuf[3]) then begin
          stringgrid1.Cells[3,i]:='100 гр.';
          stringgrid1.Cells[4,i]:=format('%0.2f',[formstart.StrToFloat( xrowbuf[2]) / 10]);
        end;
        end;
      stringgrid1.Cells[5,i]:='1';
    end;
    end;

  end;
  spgoods.flSelectItem:=false;
  spgoods.Destroy;

end;

procedure TFormPrintTicket.BitBtn2Click(Sender: TObject);
begin
  if StringGrid1.Row >0 then
   StringGrid1.DeleteRow(StringGrid1.Row);
end;

procedure TFormPrintTicket.BitBtn3Click(Sender: TObject);
begin
  frReport1.Clear;
  typeTicket1:=ComboBox1.Items.IndexOf(ComboBox1.Caption);
  if (fileExists( 'report\ticketbc.lrf' )) and (fileExists( 'report\ticket2.lrf' )) then
    case typeTicket1 of
     0: frReport1.LoadFromFile('report\ticketbc.lrf');
     else
      frReport1.LoadFromFile('report\ticket2.lrf');
    end;

 ind:=1;
 frReport1.ShowReport;
end;

procedure TFormPrintTicket.FormShow(Sender: TObject);
begin
  if (not fileExists( 'report\ticketbc.lrf' )) or (not fileExists( 'report\ticket2.lrf' )) then
   ShowMessage('Отсуствуют печатные формы! Требуется обновление.');
end;

procedure TFormPrintTicket.frUserDataset1Next(Sender: TObject);
begin
 if Stringgrid1.RowCount > ind then
  ind:=ind+1;
end;

end.

