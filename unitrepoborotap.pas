unit unitrepoborotap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, Buttons, ExtCtrls, StdCtrls,mysql50;

type

  { TFormRepOborotAP }

  TFormRepOborotAP = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    frUserDataset2: TfrUserDataset;
    frUserDataset3: TfrUserDataset;
    pnCommand: TPanel;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure frReport1BeginColumn(Band: TfrBand);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
    procedure frUserDataset2CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset2First(Sender: TObject);
    procedure frUserDataset2Next(Sender: TObject);
    procedure frUserDataset3CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset3First(Sender: TObject);
    procedure frUserDataset3Next(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    startDate:TdateTime;
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
    ind:integer;
    endDate:TdateTime;
  end;

var
  FormRepOborotAP: TFormRepOborotAP;

implementation

{$R *.lfm}
uses unitstart,unitfilter, fpspreadsheet,  xlsbiff8, fpsRPN, fpsTypes;
{ TFormRepOborotAP }

procedure TFormRepOborotAP.FormShow(Sender: TObject);
begin
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\oborotap.lrf');
 StartDate:=now();
 endDate:=now();
 statictext1.Caption:='С '+FormatDateTime('DD-MM-YYYY',StartDate)+' по '+FormatDateTime('DD-MM-YYYY',endDate)+'';
 ind:=0;
end;

procedure TFormRepOborotAP.frReport1BeginColumn(Band: TfrBand);
begin
  //band.GroupCondition;
end;



procedure TFormRepOborotAP.BitBtn3Click(Sender: TObject);

begin
  if FormFilter.ShowModal = 1377 then begin
    startDate:= FormFilter.StartDate;
    endDate  := FormFilter.EndDate;
    statictext1.Caption:='С '+FormatDateTime('DD-MM-YYYY',StartDate)+' по '+FormatDateTime('DD-MM-YYYY',endDate)+'';

  end;
end;

procedure TFormRepOborotAP.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

{$I common/unitrepoborotap.inc}

end.

