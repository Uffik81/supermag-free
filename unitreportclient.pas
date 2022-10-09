{
  ***** Оборот по клиенту ******
}


unit unitReportClient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, LR_Class, LR_DSet, LR_Desgn,
  lr_e_pdf, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls,
  mysql50 ;

type

  { TFormReportClient }

  TFormReportClient = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Edit1: TEdit;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
  private
    { private declarations }
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
  public
    { public declarations }
    linenum:integer;
  end;

var
  FormReportClient: TFormReportClient;

implementation

{$R *.lfm}
uses unitstart , fpspreadsheet,  xlsbiff8, fpsRPN, fpsTypes;
{ TFormReportClient }

procedure TFormReportClient.FormCreate(Sender: TObject);
begin

end;

procedure TFormReportClient.BitBtn1Click(Sender: TObject);
var
  query:string;
begin      // 6140023217
 linenum:=0;
 query:=
   'SELECT `docjurnale`.`numdoc`,'+
          '`docjurnale`.`datedoc`,'+
          '`docjurnale`.`wbregid`,'+
          '`docjurnale`.`summa`,'+
          '`docjurnale`.`clientaccept`,'+
          '`docjurnale`.`status`,'+
          '`spproducer`.`fullname`,'+
          '`spproducer`.`inn`,'+
          '`spproducer`.`kpp`,'+
          '`spproducer`.`description`'+' FROM `docjurnale`,`spproducer`'+
 ' WHERE (`spproducer`.`inn`="'+edit1.Text+'")and(`docjurnale`.`clientregid`=`spproducer`.`clientregid`)AND'+
 '((`docjurnale`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',datetimepicker1.Date)+'")AND(`docjurnale`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',datetimepicker2.Date)+'"))AND(`docjurnale`.`isDelete`<>"+") ';
 if checkbox1.Checked then query:= query+' and(`docjurnale`.`clientaccept`<>"+") ';
 query:= query+' GROUP BY `docjurnale`.`numdoc`;';
 recbuf:=formstart.DB_query(query);
 rowbuf:=formstart.DB_Next(recbuf);
 frReport1.ShowReport;


end;

procedure TFormReportClient.BitBtn2Click(Sender: TObject);
var
  query:string;
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  MyDir: string;
  number: Double;
  //lCell: PCell;
  //lCol: TCol;
  i: Integer;
  r: Integer = 10;
  s: String;
  linenu:integer;
begin      // 6140023217
 if savedialog1.Execute then begin
  MyWorkbook := TsWorkbook.Create;
  MyWorkbook.SetDefaultFont('Calibri', 9);
  //MyWorkbook.UsePalette(@PALETTE_BIFF8, Length(PALETTE_BIFF8));
  MyWorkbook.FormatSettings.CurrencyFormat := 2;
  MyWorkbook.FormatSettings.NegCurrFormat := 14;
  MyWorkbook.Options := MyWorkbook.Options + [boCalcBeforeSaving];

  MyWorksheet := MyWorkbook.AddWorksheet('list1');
  MyWorksheet.Options := MyWorksheet.Options - [soShowGridLines];

 linenu:=1;
 query:=
   'SELECT `docjurnale`.`numdoc`,'+
          '`docjurnale`.`datedoc`,'+
          '`docjurnale`.`wbregid`,'+
          '`docjurnale`.`summa`,'+
          '`docjurnale`.`clientaccept`,'+
          '`docjurnale`.`status`,'+
          '`spproducer`.`fullname`,'+
          '`spproducer`.`inn`,'+
          '`spproducer`.`kpp`,'+
          '`spproducer`.`description`'+' FROM `docjurnale`,`spproducer`'+
 ' WHERE (`spproducer`.`inn`="'+edit1.Text+'")and(`docjurnale`.`clientregid`=`spproducer`.`clientregid`)AND'+
 '((`docjurnale`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',datetimepicker1.Date)+'")AND(`docjurnale`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',datetimepicker2.Date)+'"))AND(`docjurnale`.`isDelete`<>"+") ';
 if checkbox1.Checked then query:= query+' and(`docjurnale`.`clientaccept`<>"+") ';
 query:= query+' GROUP BY `docjurnale`.`numdoc`;';
 recbuf:=formstart.DB_query(query);
 rowbuf:=formstart.DB_Next(recbuf);
   // =====================================
   MyWorksheet.WriteUTF8Text(1, 1,'Отчет за период с '+FormatDateTime('YYYY-MM-DD',datetimepicker1.Date)+
   ' по '+FormatDateTime('YYYY-MM-DD',datetimepicker2.Date));
     MyWorksheet.WriteBorders(9, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 1, 'пп');
    MyWorksheet.WriteBorders(9, 2, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 2,'Номер ТТН');
    MyWorksheet.WriteBorders(9, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 3,'Дата');
    MyWorksheet.WriteBorders(9, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 4,'ТТН по ЕГАИС');
    MyWorksheet.WriteBorders(9, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 5,'Сумма (руб)');
    MyWorksheet.WriteBorders(9, 6, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 6,'КПП');
    MyWorksheet.WriteBorders(9, 7, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 7,'Адрес');
    MyWorksheet.WriteUTF8Text(9, 8,'Статус');
    MyWorksheet.WriteBorders(9, 8, [cbNorth, cbEast, cbSouth, cbWest]);
   // =====================================
 while rowbuf<>nil do begin
    MyWorksheet.WriteBorders(r, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 1, inttostr(linenu));
    MyWorksheet.WriteBorders(r, 2, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 2,rowbuf[0]);
    MyWorksheet.WriteBorders(r, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 3,rowbuf[1]);
    MyWorksheet.WriteBorders(r, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 4,rowbuf[2]);
    MyWorksheet.WriteBorders(r, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 5,rowbuf[3]);
    MyWorksheet.WriteBorders(r, 6, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 6,rowbuf[8]);
    MyWorksheet.WriteBorders(r, 7, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 7,rowbuf[9]);
        if rowbuf[4] = '+' then
          MyWorksheet.WriteUTF8Text(r, 8,'Подтвержден')
         else
          MyWorksheet.WriteUTF8Text(r, 8,'Не подтвержден');
    MyWorksheet.WriteBorders(r, 8, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(2, 1,'Наименование организации '+rowbuf[6]);
    MyWorksheet.WriteUTF8Text(3, 1,'ИНН организации '+rowbuf[7]);

      rowbuf:=formstart.DB_Next(recbuf);
      inc(r);
      inc(linenu);

 end;
   MyWorksheet.WriteColWidth(0, 3);
   MyWorksheet.WriteColWidth(1, 5);
   MyWorksheet.WriteColWidth(2, 20);
   MyWorksheet.WriteColWidth(3, 10);
   MyWorksheet.WriteColWidth(4, 20);
   MyWorksheet.WriteColWidth(5, 10);
   MyWorksheet.WriteColWidth(6, 20);
   MyWorksheet.WriteColWidth(7, 70);
   MyWorksheet.WriteColWidth(8, 20);
  MyWorkbook.WriteToFile( utf8ToAnsi(savedialog1.FileName), sfExcel8, true);
  MyWorkbook.Free;
  ShowMessage('Отчет сформирован!');
 end;

end;

procedure TFormReportClient.FormShow(Sender: TObject);
begin
   FrReport1.Clear;
 FrReport1.LoadFromFile('report\report1.lrf');

end;

procedure TFormReportClient.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
 ParValue:='';
  if ParName='num' then begin
     ParValue:=inttostr(linenum);
     linenum:=linenum+1;
  end;
  if rowbuf<>nil then begin
    if ParName='nameclient' then
       ParValue:=rowbuf[6];
    if ParName='innclient' then
       ParValue:=rowbuf[7];
    if ParName='kppclient' then
       ParValue:=rowbuf[8];
    if ParName='address' then
       ParValue:=rowbuf[9];
    if ParName='number' then
       ParValue:=rowbuf[0];
    if ParName='date' then
       ParValue:=rowbuf[1];
    if ParName='ttnnum' then
       ParValue:=rowbuf[2];
    if ParName='sum' then
       ParValue:=rowbuf[3];
    if ParName='status' then begin
      if rowbuf[4] = '+' then
       ParValue:='Подтвержден'
       else
        ParValue:='Не подтвержден'
    end;
    if ParName='startdate' then
       ParValue:=FormatDateTime('YYYY-MM-DD',datetimepicker1.Date);
    if ParName='enddate' then
       ParValue:=FormatDateTime('YYYY-MM-DD',datetimepicker2.Date);
  end;
end;

procedure TFormReportClient.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  if (rowbuf= nil )or(recbuf=nil) then
     eof:=true
     else
       eof:=false;
end;

procedure TFormReportClient.frUserDataset1First(Sender: TObject);
begin

end;

procedure TFormReportClient.frUserDataset1Next(Sender: TObject);
begin
  if recbuf<>nil then
      rowbuf:=formstart.DB_Next(recbuf);
end;

end.

