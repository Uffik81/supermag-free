unit unitreportoborot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, Buttons, mysql50;

type

  { TFormReprotOborot }

  TFormReprotOborot = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    SaveDialog1: TSaveDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
    ind:integer;
  end;

var
  FormReprotOborot: TFormReprotOborot;

implementation

{$R *.lfm}

uses
  unitstart, unitostatok, fpspreadsheet,  xlsbiff8, fpsRPN, fpsTypes;

{ TFormReprotOborot }

procedure TFormReprotOborot.BitBtn1Click(Sender: TObject);
var
  query:string;
begin
 query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`regrestsproduct`.`alccode` ) AS `name`,(SELECT `crdate` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` ) AS `alcvolume`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`regrestsproduct`.`alccode` LIMIT 1) AS `productVCode`,SUM(`quantity`) AS `summ`,"","" FROM `regrestsproduct` '
 +' GROUP BY `AlcCode` ORDER BY `name` ASC;' ;
 recbuf:=formStart.DB_query(  query  );
 rowbuf:=formStart.DB_Next(recbuf);
 ind:=0;
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\ostatokap.lrf');
 frReport1.ShowReport;

end;

procedure TFormReprotOborot.BitBtn2Click(Sender: TObject);
var
  query:string;
begin
 query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`regrestsproduct`.`alccode` ) AS `name`,(SELECT `crdate` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` ) AS `alcvolume`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`regrestsproduct`.`alccode` LIMIT 1) AS `productVCode`,SUM(`quantity`) AS `summ`,"","" FROM `regrestsproduct` '
 +' GROUP BY `InformARegId` ORDER BY `name` ASC;' ;
 recbuf:=formStart.DB_query(  query  );
 rowbuf:=formStart.DB_Next(recbuf);
 ind:=0;
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\ostatokap.lrf');
 frReport1.ShowReport;

end;

procedure TFormReprotOborot.BitBtn3Click(Sender: TObject);
begin
  close;
end;

procedure TFormReprotOborot.BitBtn4Click(Sender: TObject);
begin
  FormStart.readOstatok();

end;

procedure TFormReprotOborot.BitBtn5Click(Sender: TObject);
  // == Сохранить в xls
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
  MyWorksheet.Options := MyWorksheet.Options;// - [soShowGridLines];
 linenu:=1;
 query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`regrestsproduct`.`alccode` LIMIT 1) AS `name`,(SELECT `crdate` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `alcvolume`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`regrestsproduct`.`alccode` LIMIT 1) AS `productVCode`,SUM(`quantity`) AS `summ`,(SELECT `numfix` FROM `spformfix` WHERE `forma`=`regrestsproduct`.`InformARegId` LIMIT 1) AS `numfix`,"" FROM `regrestsproduct` '
 +' GROUP BY `InformARegId` ORDER BY `name` ASC;' ;
 recbuf:=formStart.DB_query(  query  );
 rowbuf:=formStart.DB_Next(recbuf);
   // =====================================
   MyWorksheet.WriteUTF8Text(1, 1,'Остаток '+FormatDateTime('YYYY-MM-DD',now()));
     MyWorksheet.WriteBorders(9, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 1, 'пп');
//    MyWorksheet.WriteBorders(9, 2, [cbNorth, cbEast, cbSouth, cbWest]);
//    MyWorksheet.WriteUTF8Text(9, 2,'Дата');
//    MyWorksheet.WriteBorders(9, 3, [cbNorth, cbEast, cbSouth, cbWest]);
//    MyWorksheet.WriteUTF8Text(9, 3,'Штриховой код');
    MyWorksheet.WriteBorders(9, 2, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 2,'Наименование товара');
    MyWorksheet.WriteBorders(9, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 3,'Штрихкод');
    MyWorksheet.WriteBorders(9, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 4,'Дата розлива');
    MyWorksheet.WriteBorders(9, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 5,'Количество (шт)');
    MyWorksheet.WriteUTF8Text(9, 6,'Номер фиксации');
    MyWorksheet.WriteBorders(9, 6, [cbNorth, cbEast, cbSouth, cbWest]);
   // =====================================
 while rowbuf<>nil do begin
    MyWorksheet.WriteBorders(r, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 1, inttostr(linenu));
    MyWorksheet.WriteBorders(r, 2, [cbNorth, cbEast, cbSouth, cbWest]);
   // MyWorksheet.wr
    MyWorksheet.WriteUTF8Text(r, 2,rowbuf[0]);
    MyWorksheet.WriteBorders(r, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 3,rowbuf[2]);
    MyWorksheet.WriteBorders(r, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 4,rowbuf[1]);
    MyWorksheet.WriteBorders(r, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 5,rowbuf[3]);
    MyWorksheet.WriteBorders(r, 6, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 6,rowbuf[4]);
//        if rowbuf[4] = '+' then
//          MyWorksheet.WriteUTF8Text(r, 8,'Подтвержден')
//         else
//          MyWorksheet.WriteUTF8Text(r, 8,'Не подтвержден');
//    MyWorksheet.WriteBorders(r, 8, [cbNorth, cbEast, cbSouth, cbWest]);
//    MyWorksheet.WriteUTF8Text(2, 1,'Наименование организации '+rowbuf[6]);
//    MyWorksheet.WriteUTF8Text(3, 1,'ИНН организации '+rowbuf[7]);
      rowbuf:=formstart.DB_Next(recbuf);
      inc(r);
      inc(linenu);
 end;
   MyWorksheet.WriteColWidth(0, 3);
   MyWorksheet.WriteColWidth(1, 5);
   MyWorksheet.WriteColWidth(2, 70);
   MyWorksheet.WriteColWidth(3, 20);
   MyWorksheet.WriteColWidth(4, 20);
   MyWorksheet.WriteColWidth(5, 20);
   MyWorksheet.WriteColWidth(6, 20);
   MyWorksheet.WriteColWidth(7, 20);
  // MyWorksheet.WriteColWidth(8, 20);
  MyWorkbook.WriteToFile( utf8ToAnsi(savedialog1.FileName), sfExcel8, true);
  MyWorkbook.Free;
  ShowMessage('Отчет сформирован!');
 end;
end;

procedure TFormReprotOborot.BitBtn6Click(Sender: TObject);
begin
  hide;
  FormOstatok.ShowModal();
  show;
end;

procedure TFormReprotOborot.BitBtn7Click(Sender: TObject);
begin
  formStart.SendQueryRestsShopv2();
end;

procedure TFormReprotOborot.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    CloseAction:=caHide;
end;

procedure TFormReprotOborot.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
 ParValue:='';
 if ParName='num' then begin
    ParValue:=inttostr(ind);
 end;
 if ParName='name' then
     ParValue:=rowbuf[0];
 if ParName='dal' then
     ParValue:=rowbuf[1];
if ParName='imnscode' then
     ParValue:=rowbuf[2];
if ParName='count' then
     ParValue:=rowbuf[3];
 if ParName='barcode' then
     ParValue:=rowbuf[4];
 if ParName='date' then
     ParValue:=rowbuf[5];
{  if linenum < formbuytth.ListView1.Items.Count then begin
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
 end;         }
 if ParName='firmname' then
      ParValue:=formstart.FirmFullName;
 if ParName='innkpp' then
      ParValue:=formstart.FirmINN+'/'+formStart.firmkpp;
   if ParName='address' then
      ParValue:=formstart.FirmAddress;
end;

procedure TFormReprotOborot.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
   if rowbuf = nil then eof:=true
                   else eof:=false;
end;

procedure TFormReprotOborot.frUserDataset1First(Sender: TObject);
begin

end;

procedure TFormReprotOborot.frUserDataset1Next(Sender: TObject);
begin
 rowbuf:=formStart.DB_Next(recbuf);
 ind:=ind+1;
end;

end.

