{

}
unit unitViewReport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, LR_Class, LR_View, LR_Desgn,
  LR_DSet, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids, Buttons,
  Printers, ExtCtrls, lclproc;

type
  tcellt = record
    str:string;
    Width:integer;
    Height:integer;
    col,
    row:integer;
    borLeft:boolean;
    borTop:boolean;
    borDown:boolean;
    borRight:boolean;
  end;

  { TFormViewReport }

  TFormViewReport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    frPreview1: TfrPreview;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure frDesigner1LoadReport(Report: TfrReport; var ReportName: String);
    procedure frReport1BeginColumn(Band: TfrBand);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    arRep:array[0..1000] of TCellT;
    WidthCol:array[0..100] of integer;
    linenum:integer;
    Paperleft:Integer;
    PaperTop:integer;
    Function fmtLine(Wid: integer; s: string): string;
    function getLeftCol(aCol:integer):integer;
    procedure getListRMK();
  end;

var
  FormViewReport: TFormViewReport;

implementation

{$R *.lfm}

uses
  unitstart,
  unitbuytth//;
  , pdf417lib
  , qrcode
  ;
{ TFormViewReport }

function TFormViewReport.getLeftCol(aCol:integer):integer;
var
  i:integer;
begin
  result:=Paperleft;
  for i:=0 to aCol-1 do
    result:=result+WidthCol[i];
end;

procedure TFormViewReport.getListRMK();
begin

end;

function TFormViewReport.fmtLine(Wid: integer; s: string): string;
begin
end;


procedure TFormViewReport.BitBtn1Click(Sender: TObject);
var
  FromPage, ToPage, NumberCopies: Integer;
  ind: Integer;
  Collap: Boolean;
  MyPrinter : TPrinter;
begin

    ind:= Printer.PrinterIndex;
    // Prepare the report and just stop if we hit an error as continuing makes no sense
    if not frReport1.PrepareReport then Exit;
    // Set up dialog with some sensible defaults which user can change
    with PrintDialog1 do
    begin
      Options:=[poPageNums ]; // allows selecting pages/page numbers
      Copies:=1;
      Collate:=true; // ordened copies
      FromPage:=1; // start page
      ToPage:=frReport1.EMFPages.Count; // last page
      MaxPage:=frReport1.EMFPages.Count; // maximum allowed number of pages
      if Execute then // show dialog; if succesful, process user feedback
      begin
        if (Printer.PrinterIndex <> ind ) // verify if selected printer has changed
          or frReport1.CanRebuild // ... only makes sense if we can reformat the report
          or frReport1.ChangePrinter(ind, Printer.PrinterIndex) //... then change printer
          then
          frReport1.PrepareReport //... and reformat for new printer
        else
          exit; // we couldn't honour the printer change

        if PrintDialog1.PrintRange = prPageNums then // user made page range selection
        begin
          FromPage:=PrintDialog1.FromPage; // first page
          ToPage:=PrintDialog1.ToPage;  // last page
        end;
        NumberCopies:=PrintDialog1.Copies; // number of copies
        // Print the report using the supplied pages & copies
        frReport1.PrintPreparedReport(inttostr(FromPage)+'-'+inttostr(ToPage), NumberCopies);
      end;
    end;

end;

procedure TFormViewReport.BitBtn3Click(Sender: TObject);
var
  i:integer;
  vLeft:integer;
begin
  IF printerSetupDialog1.Execute then BEGIN
  end;
end;

procedure TFormViewReport.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i:integer;
begin
  for i:=0 to 1000 do
    arRep[i].row:=0;

end;

procedure TFormViewReport.FormShow(Sender: TObject);
var
  i:integer;
  vLeft:integer;
   b: TfrBandView;
begin
 FRpREVIEW1.Clear;
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\test.lrf');
 FrReport1.Values.FindVariable('numdoc').Field := QuotedStr(formbuytth.DocNumber);
 FrReport1.Values.FindVariable('datedoc').Field := QuotedStr(formbuytth.DocDate);
 FrReport1.Values.FindVariable('ttnnum').Field := QuotedStr(formbuytth.DocId);
 frReport1.ShowReport;

 linenum:=0;

end;

procedure TFormViewReport.frDesigner1LoadReport(Report: TfrReport;
  var ReportName: String);
begin

end;

procedure TFormViewReport.frReport1BeginColumn(Band: TfrBand);
begin
  if Band.Typ in [btMasterData] then

end;

procedure TFormViewReport.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  bm:TBitmap;
  Height1,Width1:integer;
  p1:Pdf417param;
  qrpm: TDelphiZXingQRCode;
begin
  if View.Name = 'Picture1' then begin
    Height1:= TfrPictureView(View).Picture.Bitmap.Height;
    Width1 := TfrPictureView(View).Picture.Bitmap.Width;
    TfrPictureView(View).Picture.Bitmap.FreeImage;
   // TfrPictureView(View).Picture.Bitmap.;
    BM:= TBitMap.Create;
    BM.Width:=300;
    BM.Height:=300;
    BM.PixelFormat:=pf4bit;
    BM.Canvas.Brush.Color:=clWhite;
    BM.Canvas.Pen.Color:=clBlack;
//    BM.Canvas.FillRect(BM.Canvas.ClipRect);
//    BM.Canvas.Line(0,0,199,100);
  //  pdf417lib.pdf417init(@p1);
  //  p1.text:=;
    qrpm:=TDelphiZXingQRCode.Create;
    qrpm.Data:=''+formbuytth.DocNumber+' '+formbuytth.DocDate+' '+formbuytth.DocId;
   // qrpm.
    qrcode.DrawQR(BM.Canvas,rect(0,0,300,300),qrpm);
    TfrPictureView(View).Picture.Bitmap.Assign(BM);
    if BM<>nil then begin
      BM.free;
      BM:=nil;
     end;
    qrpm.Free;
  end;
//  showmessage('pic4');

end;

procedure TFormViewReport.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
 ParValue:='';
  if ParName='num' then begin
     ParValue:=formbuytth.ListView1.Items.Item[linenum].caption;
  end;
  if linenum < formbuytth.ListView1.Items.Count then begin
    if ParName='name' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[0];
    if ParName='count123' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[1];
    if ParName='forma' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[6];
    if ParName='formb' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[9];
    if ParName='cena' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[3];
    if ParName='summ1' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[4];
    if ParName='nowformb' then
       ParValue:=formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[7];
    if ParName='manufactur' then
       begin
         ParValue:=trim(formbuytth.ListView1.Items.Item[linenum].SubItems.Strings[10]);
         formstart.rowbuf:=formstart.db_next(formstart.db_query('select `fullname`,`inn`,`kpp` from `spproducer` where `clientregid`="'+ParValue+'";'));

         if formstart.rowbuf<>nil then
            ParValue:=formstart.rowbuf[0]+' ('+formstart.rowbuf[1]+'/'+formstart.rowbuf[2]+') ['+ParValue+']';
       end;
  end;
  if ParName='numdoc' then
       ParValue:=QuotedStr(formbuytth.DocNumber);
  if ParName='datedoc' then
       ParValue:=QuotedStr(formbuytth.DocDate);
    if ParName='ttnnum' then
       ParValue:=QuotedStr(formbuytth.WBregID);

end;

procedure TFormViewReport.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  if linenum >= formbuytth.ListView1.Items.Count then
      eof:=true
    else
      eof:=false;
end;

procedure TFormViewReport.frUserDataset1First(Sender: TObject);
begin
  linenum:=0;
end;

procedure TFormViewReport.frUserDataset1Next(Sender: TObject);
begin
  linenum:=linenum+1;
end;


end.

