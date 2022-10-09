unit unitInv2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ComCtrls, Buttons, Grids, StdCtrls, Menus, mysql50;
  {документ тип InventRest}
type

  { TFormInv2 }

  TFormInv2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    miRestSub: TMenuItem;
    miNotRest: TMenuItem;
    miWritingOff: TMenuItem;
    miChangeOnCash: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure dpDateDocEditingDone(Sender: TObject);
    procedure edNumDocEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure miChangeOnCashClick(Sender: TObject);
    procedure miNotRestClick(Sender: TObject);
    procedure miRestSubClick(Sender: TObject);
    procedure miWritingOffClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    flNew:boolean;
    flReadOnly:boolean;

    NumDoc:string;
    DateDoc:String;
    flPDF417:string;
    selectrow:integer;
    function controlpdf417(aPDF417:string):integer;
  end;

var
  FormInv2: TFormInv2;

implementation


{$R *.lfm}
uses unitStart, unitJurnale,UnitSelItem, unitsetalcdate, unitActWriteOff, fpspreadsheet,  xlsbiff8, fpsRPN, fpsTypes, unitActChargeOnShop;

{ TFormInv2 }

procedure TFormInv2.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  aRes:integer;
begin
  formSelItem.flInv2:=true;
  StringGrid1.Clear;
  StringGrid1.RowCount:=1;
  if ( NumDoc<>'' )and( DateDoc<>'' ) then begin    //,(SELECT `InformARegId` FROM `regrestsproduct` WHERE `alccode`=`doc25`.`alccode` AND `crdate`=`doc25`.`crdate` LIMIT 1) AS `forma`
    Query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`doc25`.`alccode` LIMIT 1) AS `name`,`pdf417`,`crdate`,`alccode`,`count`,`restcount`,(SELECT `InformARegId` FROM `regrestsproduct` WHERE `alccode`=`doc25`.`alccode` AND (`crdate`=`doc25`.`crdate` OR `crdate`="") LIMIT 1) AS `forma` FROM `doc25` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
    xrecbuf:=FormStart.DB_Query(Query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
      i:=1;
      StringGrid1.Clear;
      StringGrid1.RowCount:=2;
      while xrowbuf<>nil do begin
        StringGrid1.RowCount:=i+1;
        StringGrid1.Cells[1,i]:=xrowbuf[0];
        StringGrid1.Cells[2,i]:=xrowbuf[1];
        StringGrid1.Cells[3,i]:=xrowbuf[2];
        StringGrid1.Cells[4,i]:=xrowbuf[3];
        StringGrid1.Cells[5,i]:=xrowbuf[5];
        StringGrid1.Cells[6,i]:=xrowbuf[4];
        StringGrid1.Cells[8,i]:=xrowbuf[6];
        //    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
        i:=i+1;
        Stringgrid1.Row:=i;
        flNew:=false;
        xrowbuf:= formStart.DB_Next(xrecbuf);
      end;
      edNumDoc.Text:=NumDoc;
      dpDateDoc.date:=formstart.Str1ToDate(DateDoc);
  end;

  edNumDoc.ReadOnly:=not flNew;
  dpDateDoc.ReadOnly:=not flNew;
end;

procedure TFormInv2.miChangeOnCashClick(Sender: TObject);
var
  i:integer;
  ind:integer;
begin
  // ===== оприходование в торговый зал =====
  FormActChargeOnShop.StringGrid1.Clear;
  FormActChargeOnShop.StringGrid1.RowCount:=1;
  ind:=1;
  for i:=1 to stringgrid1.RowCount-1 do begin
     if ((pos('-',StringGrid1.Cells[7,i])<>0)and(pos('2016',StringGrid1.Cells[3,i])=0)) then begin
       FormActChargeOnShop.StringGrid1.RowCount:=FormActChargeOnShop.StringGrid1.RowCount+1;
       FormActChargeOnShop.StringGrid1.Cells[1,ind]:=StringGrid1.Cells[1,i];
       FormActChargeOnShop.StringGrid1.Cells[4,ind]:=StringGrid1.Cells[3,i];
       FormActChargeOnShop.StringGrid1.Cells[2,ind]:=StringGrid1.Cells[4,i];
       FormActChargeOnShop.StringGrid1.Cells[3,ind]:=inttostr(-1*strtoint(StringGrid1.Cells[7,i]));
       ind:=ind+1;

     end;
  end;
  FormActChargeOnShop.flNew:=true;
  FormActChargeOnShop.ShowModal;
end;

procedure TFormInv2.miNotRestClick(Sender: TObject);
var
  find1:boolean;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  xrecbuf:=FormStart.DB_Query('SELECT `InformARegId`,SUM(`Quantity`),`alcname`,`alccode`,(SELECT `crdate` FROM `spformfix` WHERE `forma` = `regrestsproduct`.`InformARegId` LIMIT 1) AS `crdate` FROM `regrestsproduct`   GROUP BY `regrestsproduct`.`InformARegId` ; '  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
      find1:=true;
      for i:=1 to stringgrid1.RowCount-1 do  begin
        if xrowbuf[0]= stringgrid1.Cells[8,i] then
          find1:=false;
      end;
      if find1 then begin
        i:= stringgrid1.RowCount;
        stringgrid1.RowCount:=stringgrid1.RowCount+1;
        stringgrid1.Cells[1,i]:=xrowbuf[2];
        stringgrid1.Cells[4,i]:=xrowbuf[3];
        stringgrid1.Cells[3,i]:=xrowbuf[4];
        stringgrid1.Cells[5,i]:=xrowbuf[1];
        stringgrid1.Cells[6,i]:='0';
        stringgrid1.Cells[7,i]:=xrowbuf[1];
        stringgrid1.Cells[8,i]:=xrowbuf[0];
      end;
      xrowbuf:=formStart.DB_Next(xrecbuf);
  end;

end;

procedure TFormInv2.miRestSubClick(Sender: TObject);
var
  con1:integer;
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  r2,
  r1:integer;
begin
  // расчитывает на основании остатков
  for i:=1 to stringgrid1.RowCount-1 do  begin                                                                                                                                                                   //,`spformfix` AND `spformfix`.`forma` = `regrestsproduct`.`InformARegId` AND ((`spformfix`.`crdate`="'+stringgrid1.Cells[3,i]+'")OR (`spformfix`.`crdate`="") )
    xrecbuf:=FormStart.DB_Query(
    'SELECT `regrestsproduct`.`InformARegId`,SUM(`regrestsproduct`.`Quantity`) FROM `regrestsproduct`  WHERE `regrestsproduct`.`alccode`="'+stringgrid1.Cells[4,i]+'" AND  `regrestsproduct`.`InformARegId`="'+stringgrid1.Cells[8,i]+'" GROUP BY `regrestsproduct`.`InformARegId` ; '
    );
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      stringgrid1.Cells[5,i]:=xrowbuf[1];
 //     stringgrid1.Cells[7,i]:=floattostr(formstart.StrToFloat(xrowbuf[1])-formstart.StrToFloat(stringgrid1.Cells[6,i]));
    end else begin
      stringgrid1.Cells[5,i]:='0';
 //     stringgrid1.Cells[7,i]:='-'+stringgrid1.Cells[6,i];
    end;
//    xrecbuf:=FormStart.DB_Query('SELECT SUM(`quantity`) FROM `doccash`  WHERE `datedoc`="'+datedoc+'" AND `alccode`="'+stringgrid1.Cells[4,i]+'" AND (`typetrans`="11" OR `typetrans`="13") GROUP BY `alccode` ;' );
//    xrowbuf:=formStart.DB_Next(xrecbuf);
//    if xrowbuf<>nil then begin
//      if (stringgrid1.Cells[5,i]='0')OR (stringgrid1.Cells[5,i]='') then
//        stringgrid1.Cells[5,i]:=xrowbuf[0]
//       else
//        stringgrid1.Cells[5,i]:=inttostr(strtoint(stringgrid1.Cells[5,i])+strtoint(xrowbuf[0]));
//
//    end;

    r1:=strtoint(stringgrid1.Cells[5,i]);
    r2:=strtoint(stringgrid1.Cells[6,i]);
    stringgrid1.Cells[7,i]:=inttostr(r1-r2);
  end;


end;

procedure TFormInv2.miWritingOffClick(Sender: TObject);
var
  i:integer;

  count1:integer;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  ind:integer;
  spcount:integer;
  fbcount:integer;
begin
  ind:=1;
  // === ПЕРВЫЙ ЭТАП формируем справки Б
   for i:=1 to stringgrid1.RowCount-1 do begin
     if (pos('2016',StringGrid1.Cells[3,i])<>0) then
        count1:=0
       else
     count1:= strtoint(stringgrid1.cells[7,i]);
     if (count1>0)and(stringgrid1.cells[8,i]<>'') then begin
       for ind:=i+1 to stringgrid1.RowCount-1 do
         if  stringgrid1.cells[8,ind]=stringgrid1.cells[8,i] then begin
           count1:= count1 - strtoint(stringgrid1.cells[7,ind]);
           stringgrid1.cells[7,ind]:='0';
          end else begin
            if (stringgrid1.cells[4,ind]=stringgrid1.cells[4,i])and(stringgrid1.cells[8,ind]='')  then
              begin
                count1:= count1 - strtoint(stringgrid1.cells[7,ind]);
                stringgrid1.cells[7,ind]:='0';
              end;
          end;
       query:='SELECT `InformBRegId`,`Quantity` FROM `regrestsproduct` WHERE `alccode`="'+stringgrid1.cells[4,i]+'" AND (`InformARegId`="'+stringgrid1.cells[8,i]+'" OR `InformARegId`="" ) ;';
       xrecbuf:=FormStart.DB_Query(Query);
       xrowbuf:=FormStart.db_next(xrecbuf);
        while (xrowbuf<>nil)AND(count1>0) do begin
          fbcount:=strtoint(xrowbuf[1]);
          if fbcount>=count1 then
             spcount:=count1
            else
             spcount:=fbcount;
            with formActWriteOff.listview1.Items.Add do begin
               caption:=InTToStr(ind);
               subitems.Add(stringgrid1.cells[1,i]);
               subitems.Add(xrowbuf[0]);
               subitems.Add(inttostr(spcount));
               subitems.Add(xrowbuf[1]);
            end;
            count1:=count1-spcount;
            ind:=ind+1;
            xrowbuf:=FormStart.db_next(xrecbuf);
        end;
     end;
   end;
  for i:=0 to formActWriteOff.listview1.Items.Count-1 do begin
     ;
  end;
  formActWriteOff.edit1.text:=edNumDoc.text;
  formActWriteOff.ShowModal;

end;

procedure TFormInv2.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
    if (StringGrid1.Cells[8,aRow]='')and(pos('2016',StringGrid1.Cells[3,aRow])<>0)  then
    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=$ef44FF;//Colores1[aRow mod 4];
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=$444444;//ColSele[aRow mod 4];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
      end;
  (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);

end;

procedure TFormInv2.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key<96) and (key>32) then  begin
    flPDF417:=flPDF417+char(lo(key));
    key:=0;
  end;
  if (key=46)AND(StringGrid1.Row>0) then begin
     StringGrid1.DeleteRow(StringGrid1.Row);
  end;
end;

procedure TFormInv2.FormKeyPress(Sender: TObject; var Key: char);
var
  con1:integer;
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
//  if key<>#13 then begin
//   if key in ['A'..'Z','0'..'9'] then
//     flPDF417:=flPDF417+key;
///   end
//  else
  if key=#13 then begin
    flPDF417:=trim(flPDF417);
    if Length(flPDF417)<>68 then
      begin
        ShowMessage('Акцизная марка не соответствует требованиям ЕГАИС!');
        flPDF417:='';
        key:=#0;
        exit;
      end;
    con1:=controlpdf417(flPDF417);
    if (con1>0) then begin
          showmessage('Товар с такой акцизной маркой уже продавался или добавлен в инвентаризацию, отложите ее для разбирательст!');
          flPDF417:='';
          key:=#0;
    end else begin
        AlcCode1:='';
        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
        key:=#0;
        xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+AlcCode1+'" '  );
        xrowbuf:=formStart.DB_Next(xrecbuf);
        if xrowbuf<>nil then begin
          i:=StringGrid1.RowCount;
          StringGrid1.RowCount:=i+1;
          StringGrid1.Cells[1,i]:=xrowbuf[0];
          StringGrid1.Cells[2,i]:=flPDF417;
          formsetalcdate.flAlcCode:=AlcCode1;
          formsetalcdate.StaticText1.Caption:=xrowbuf[0];
          formsetalcdate.ShowModal;
          StringGrid1.Cells[3,i]:=formsetalcdate.flDate;
          StringGrid1.Cells[4,i]:=AlcCode1;
          StringGrid1.Cells[6,i]:=formsetalcdate.Edit1.text;
          StringGrid1.Cells[8,i]:=formsetalcdate.flform1;
          StringGrid1.Col:=3;
          StringGrid1.Row:=i;
        end else begin
            showmessage('Нет данных по данному товару!');
        end;
        flPDF417:='';
    end;
  end;
end;

procedure TFormInv2.FormCreate(Sender: TObject);
begin
  NumDoc:='';
  DateDoc:='';
end;

procedure TFormInv2.BitBtn1Click(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
  i:integer;
  flEditing:boolean;
begin
  flEditing:=false;
  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
    xrecbuf:=formstart.DB_query('SELECT `crdate` FROM `doc25` WHERE `pdf417`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      flEditing:=true;
      formstart.DB_query('UPDATE `doc25` SET `crdate`="'+StringGrid1.Cells[3,i]+'", `count`="'+StringGrid1.Cells[6,i]+'" WHERE `pdf417`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc25` (`numdoc`,`datedoc`,`pdf417`,`alccode`,`crdate`,`count`,`restcount`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[2,i]+'","'+StringGrid1.Cells[4,i]+'","'+StringGrid1.Cells[3,i]+'","'+StringGrid1.Cells[6,i]+'","'+StringGrid1.Cells[5,i]+'");');
    end;
  end;
  if flEditing then begin

  end else
  begin
    formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","InventRest","---");');

  end;
end;

procedure TFormInv2.BitBtn4Click(Sender: TObject);
var
  con1:integer;
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  // расчитывает на основании остатков
 { for i:=1 to stringgrid1.RowCount-1 do  begin
    xrecbuf:=FormStart.DB_Query('SELECT `regrestsproduct`.`InformARegId`,SUM(`regrestsproduct`.`Quantity`) FROM `regrestsproduct`,`spformfix`  WHERE `regrestsproduct`.`alccode`="'+stringgrid1.Cells[4,i]+'" AND `spformfix`.`forma` = `regrestsproduct`.`InformARegId` AND ((`spformfix`.`crdate`="'+stringgrid1.Cells[3,i]+'")OR (`spformfix`.`crdate`="")) GROUP BY `regrestsproduct`.`InformARegId` ; '  );
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      stringgrid1.Cells[5,i]:=xrowbuf[1];
      stringgrid1.Cells[7,i]:=floattostr(formstart.StrToFloat(xrowbuf[1])-formstart.StrToFloat(stringgrid1.Cells[6,i]));
    end else begin
      stringgrid1.Cells[5,i]:='0';
      stringgrid1.Cells[7,i]:='-'+stringgrid1.Cells[6,i];
    end;
  end;
  for i:=1 to stringgrid1.RowCount-1 do  begin
    xrecbuf:=FormStart.DB_Query('SELECT SUM(`quantity`) FROM `doccash`  WHERE `datedoc`="'+datedoc+'" AND `alccode`="'+stringgrid1.Cells[4,i]+'" AND (`typetrans`="11" OR `typetrans`="11") GROUP BY `alccode` ;' );
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      stringgrid1.Cells[5,i]:=inttostr(strtoint(stringgrid1.Cells[5,i])+strtoint(xrowbuf[0]));
      stringgrid1.Cells[7,i]:=floattostr(formstart.StrToFloat(xrowbuf[1])-formstart.StrToFloat(stringgrid1.Cells[6,i]));
    end;
  end;     ]}
  miRestSubClick(nil);
  //
end;

procedure TFormInv2.BitBtn5Click(Sender: TObject);
var
{  i:integer;
  count1:integer;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  ind:integer;
  spcount:integer;
  fbcount:integer;  }

  r:Tpoint;
begin
  r:=BitBtn5.ClientOrigin;
//  r.Top:=;

  PopupMenu1.PopUp(r.x,r.y+BitBtn5.Height);
end;

procedure TFormInv2.BitBtn6Click(Sender: TObject);
var
  find1:boolean;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  xrecbuf:=FormStart.DB_Query('SELECT `InformARegId`,SUM(`Quantity`),`alcname`,`alccode`,(SELECT `crdate` FROM `spformfix` WHERE `forma` = `regrestsproduct`.`InformARegId` LIMIT 1) AS `crdate` FROM `regrestsproduct`   GROUP BY `regrestsproduct`.`InformARegId` ; '  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
      find1:=true;
      for i:=1 to stringgrid1.RowCount-1 do  begin
        if xrowbuf[0]= stringgrid1.Cells[8,i] then
          find1:=false;
      end;
      if find1 then begin
        i:= stringgrid1.RowCount;
        stringgrid1.RowCount:=stringgrid1.RowCount+1;
        stringgrid1.Cells[1,i]:=xrowbuf[2];
        stringgrid1.Cells[4,i]:=xrowbuf[3];
        stringgrid1.Cells[3,i]:=xrowbuf[4];
        stringgrid1.Cells[5,i]:=xrowbuf[1];
        stringgrid1.Cells[6,i]:='0';
        stringgrid1.Cells[7,i]:=xrowbuf[1];
        stringgrid1.Cells[8,i]:=xrowbuf[0];
      end;
      xrowbuf:=formStart.DB_Next(xrecbuf);
  end;

end;

procedure TFormInv2.BitBtn7Click(Sender: TObject);

var
  query:string;
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  MyDir: string;
  number: Double;
  //lCell: PCell;
  // lCol: TCol;
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
  MyWorkbook.Options := MyWorkbook.Options ;//+ [boCalcBeforeSaving];

  MyWorksheet := MyWorkbook.AddWorksheet('list1');
  MyWorksheet.Options := MyWorksheet.Options ;//- [soShowGridLines];

   r:=10;
   // =====================================
   MyWorksheet.WriteUTF8Text(1, 1,'Инвентаризация за '+FormatDateTime('YYYY-MM-DD',dpDateDoc.Date));
     MyWorksheet.WriteBorders(9, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 1, 'пп');
    MyWorksheet.WriteBorders(9, 2, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 2,'Наименование');
    MyWorksheet.WriteBorders(9, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 3,'Дата розлива');
    MyWorksheet.WriteBorders(9, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 4,'Количество (шт)');
    MyWorksheet.WriteBorders(9, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 5,'По факту (шт)');
    MyWorksheet.WriteBorders(9, 6, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 6,'Разница');
    MyWorksheet.WriteBorders(9, 7, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(9, 7,'Справка Б');
//    MyWorksheet.WriteUTF8Text(9, 8,'Статус');
//    MyWorksheet.WriteBorders(9, 8, [cbNorth, cbEast, cbSouth, cbWest]);
   // =====================================
 for linenu:=1 to stringgrid1.RowCount-1 do begin
    MyWorksheet.WriteBorders(r, 1, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 1, inttostr(linenu));
    MyWorksheet.WriteBorders(r, 2, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 2,Stringgrid1.Cells[1,linenu]);
    MyWorksheet.WriteBorders(r, 3, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 3,Stringgrid1.Cells[3,linenu]);
    MyWorksheet.WriteBorders(r, 4, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 4,Stringgrid1.Cells[5,linenu]);
    MyWorksheet.WriteBorders(r, 5, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 5,Stringgrid1.Cells[6,linenu]);
    MyWorksheet.WriteBorders(r, 6, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 6,Stringgrid1.Cells[7,linenu]);
    MyWorksheet.WriteBorders(r, 7, [cbNorth, cbEast, cbSouth, cbWest]);
    MyWorksheet.WriteUTF8Text(r, 7,Stringgrid1.Cells[8,linenu]);
//        if rowbuf[4] = '+' then
//          MyWorksheet.WriteUTF8Text(r, 8,'Подтвержден')
//         else
//          MyWorksheet.WriteUTF8Text(r, 8,'Не подтвержден');
//    MyWorksheet.WriteBorders(r, 8, [cbNorth, cbEast, cbSouth, cbWest]);
//    MyWorksheet.WriteUTF8Text(2, 1,'Наименование организации '+rowbuf[6]);
//    MyWorksheet.WriteUTF8Text(3, 1,'ИНН организации '+rowbuf[7]);
    inc(r);
 end;
   MyWorksheet.WriteColWidth(0, 3);
   MyWorksheet.WriteColWidth(1, 5);
   MyWorksheet.WriteColWidth(2, 70);
   MyWorksheet.WriteColWidth(3, 10);
   MyWorksheet.WriteColWidth(4, 10);
   MyWorksheet.WriteColWidth(5, 10);
   MyWorksheet.WriteColWidth(6, 20);
   MyWorksheet.WriteColWidth(7, 20);
   MyWorksheet.WriteColWidth(8, 20);
  MyWorkbook.WriteToFile( utf8ToAnsi(savedialog1.FileName), sfExcel8, true);
  MyWorkbook.Free;
  ShowMessage('Отчет сформирован!');
 end;


end;

procedure TFormInv2.dpDateDocEditingDone(Sender: TObject);
begin
  if flNew then
    DateDoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.Date);
end;

procedure TFormInv2.edNumDocEditingDone(Sender: TObject);
begin
  if flNew then
    NumDoc:=edNumDoc.Text;
end;

function TFormInv2.controlpdf417(aPDF417:string):integer;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
  i:integer;
begin  // === если продовался или уже добавлялся этот код то откидываем
  Query:='SELECT `quantity` from `doccash` WHERE `urlegais`="'+aPDF417+'";';
  xrecbuf:=FormStart.DB_Query(Query);
  ares:=0;
  result:=0;
  xrowbuf:=FormStart.db_next(xrecbuf);
  while xrowbuf<>nil do begin
     if xrowbuf[0]='1' then ares:=ares+1;
     if xrowbuf[0]='-1' then ares:=ares-1;
     xrowbuf:=FormStart.db_next(xrecbuf);
  end;
  result:=ares;
  for i:=1 to stringgrid1.RowCount-1 do
  if stringgrid1.cells[2,i] = aPDF417 then
    result:=result+1;
end;

end.

