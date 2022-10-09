unit unitexportform12;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Grids, Buttons;

type

  { TFormExportForm12 }

  TFormExportForm12 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flStartDate, flEndDate:tdatetime;
    flFilter:String;
    flIMNSKods:String; // === коды учавствущие в отчете ====
  end;

var
  FormExportForm12: TFormExportForm12;

implementation

uses unitstart, mysql50;
{$R *.lfm}

{ TFormExportForm12 }

procedure TFormExportForm12.BitBtn2Click(Sender: TObject);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
  i:integer=1;
begin
  query:='SELECT `clientname`,`clientregid` FROM `docjurnale` WHERE (`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'") GROUP BY `clientregid`;';
  xRecBuf:=formstart.DB_query(Query);
  xRowBuf:=formStart.DB_Next(xrecbuf);
  StringGrid3.Clear;
  StringGrid3.RowCount:=2;
  while xrowbuf<>nil do begin
    StringGrid3.RowCount:=i+1;
    StringGrid3.Cells[1,i]:=xrowbuf[0];
    xRowBuf:=formStart.DB_Next(xrecbuf);
    i:=i+1;
  end;

  query:='SELECT (SELECT `ClientRegId` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `ClientRegId`'+
  ',(SELECT `IClientRegId` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `IClientRegId`'+ ',SUM(`factcount`)'+
  ',(SELECT `capacity` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `capacity`'+
  ',(SELECT `productvcode` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `productvcode` '+
  ', `datedoc`,`numdoc`'+
      ',(SELECT `Import` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `Import`'+' FROM `doc221`'+
  ' WHERE '+flFilter+' (`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'") GROUP BY `numdoc`,`productvcode`,`capacity`;';
  xRecBuf:=formstart.DB_query(Query);
  xRowBuf:=formStart.DB_Next(xrecbuf);
  StringGrid1.Clear;
  StringGrid1.RowCount:=2;
  while xrowbuf<>nil do begin
    StringGrid1.RowCount:=i+1;
    if xrowbuf[7]='' then
    StringGrid1.Cells[3,i]:=xrowbuf[0] else
       StringGrid1.Cells[3,i]:=xrowbuf[1];
    StringGrid1.Cells[13,i]:=FloatToStr(formStart.StrToFloat(xrowbuf[3])*formStart.StrToFloat(xrowbuf[2])*0.1);
    StringGrid1.Cells[1,i]:=xrowbuf[4];
    StringGrid1.Cells[12,i]:=xrowbuf[5];
    StringGrid1.Cells[11,i]:=xrowbuf[6];

    xRowBuf:=formStart.DB_Next(xrecbuf);
    i:=i+1;
  end;
end;

end.

