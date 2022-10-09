unit unitextreport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,fpspreadsheet, Dialogs;

type

  { TFormExtReport }

  TFormExtReport = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }

    ArrNameValue:array[0..1024] of string;
    ArrValue:array[0..1024] of string;
  public
    { public declarations }
    xlsBook: TsWorkbook;
    xlsSheet: TsWorksheet;
    flReportFile:string;
    flCurrentRow:integer;
    procedure InitBook;
    procedure setColWidth(aCol,aSize:integer);
    Procedure SetValueCell(aRow,aCol:integer; aValue:string);
    procedure LoadTemplare(aFileName:string);
    procedure SelectGroup(aName:string);
    procedure SetValue(const aName,aValue:string);
    procedure SaveToFile(aName:string);
    procedure SetValueRow(aCol:integer;aValue:String);
    procedure SetValueRowBold(aCol:integer;aValue:String);
    procedure OpenViewer();
    procedure mergedCells(aRow,aCol,aRow2,aCol2:integer);
  end;

var
  FormExtReport: TFormExtReport;

implementation
uses  xlsbiff8, fpsRPN, fpsTypes;

{$R *.lfm}

{ TFormExtReport }

procedure TFormExtReport.FormCreate(Sender: TObject);
begin

end;

procedure TFormExtReport.InitBook;
begin
  flCurrentRow:=0;
  xlsBook := TsWorkbook.Create;
  xlsBook.SetDefaultFont('Calibri', 9);
  //xlsBook.UsePalette(@PALETTE_BIFF8, Length(PALETTE_BIFF8));
  xlsBook.FormatSettings.CurrencyFormat := 2;
  xlsBook.FormatSettings.NegCurrFormat := 14;
  xlsBook.Options := xlsBook.Options + [boCalcBeforeSaving];
  xlssheet := xlsBook.AddWorksheet('list1');
  xlssheet.Options := xlssheet.Options;// - [soShowGridLines];
end;

procedure TFormExtReport.setColWidth(aCol, aSize: integer);
begin
  xlssheet.WriteColWidth(aCol, aSize);
end;

procedure TFormExtReport.SetValueCell(aRow, aCol: integer; aValue: string);
begin
  xlssheet.WriteBorders(aRow, aCol, [cbNorth, cbEast, cbSouth, cbWest]);
  xlssheet.WriteUTF8Text(aRow, aCol,aValue);
end;



procedure TFormExtReport.LoadTemplare(aFileName: string);
begin

end;

procedure TFormExtReport.SelectGroup(aName: string);
begin

end;

procedure TFormExtReport.SetValue(const aName, aValue: string);
begin

end;

procedure TFormExtReport.SaveToFile(aName: string);
begin
  xlsBook.WriteToFile( utf8ToAnsi(aName), sfExcel8, true);
  ShowMessage('Отчет сохранен в '+aName);
end;

procedure TFormExtReport.SetValueRow(aCol: integer; aValue: String);
begin
  SetValueCell(flCurrentRow,aCol,aValue);
end;

procedure TFormExtReport.SetValueRowBold(aCol: integer; aValue: String);
begin
  //xlssheet.WriteUsedFormatting(flCurrentRow,aCol, [uffBold]);
  SetValueCell(flCurrentRow,aCol,aValue);
end;

procedure TFormExtReport.OpenViewer;
begin

end;

procedure TFormExtReport.mergedCells(aRow, aCol, aRow2, aCol2: integer);
begin
  xlssheet.MergeCells(aRow, aCol, aRow2, aCol2);
end;


end.

