unit unitInventShop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, Grids, ExtCtrls, Buttons, StdCtrls;

type

  { TFormInventShop }

  TFormInventShop = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    bbRefreshRestShop: TBitBtn;
    ComboBox1: TComboBox;
    OpenDialog1: TOpenDialog;
    tdDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    stEgaisOst: TStaticText;
    stFaktOst: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure bbRefreshRestShopClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure StringGrid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    { private declarations }
  public
    { public declarations }

    flPDF417:string;
    flNew:boolean;
    flShowBeer:boolean;
    flShowAP:boolean;
    procedure OpenDoc(const numDoc,DateDoc:string);
    procedure NewDoc();
    procedure NewDocBeer();
    procedure NewDocAP();
  end;

var
  FormInventShop: TFormInventShop;

implementation
uses unitstart, mysql50,unitActWriteOffShop,unitActChargeOnShop, unitspproduct,unitlogging;
{$R *.lfm}

{ TFormInventShop }

function thisBeer(fIMNS:string):boolean;
begin
 result:=false;
 if fIMNS ='500' then result:=true;
 if fIMNS ='520' then result:=true;
 if fIMNS ='261' then result:=true;
 if fIMNS ='263' then result:=true;
 if fIMNS ='262' then result:=true;
end;

procedure TFormInventShop.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
 i:=1;
 flPDF417:='';
 if flNew then begin
 query:='SELECT `alcname`,`alccode`,(SELECT `barcodes` FROM `sprgoods` WHERE `sprgoods`.`extcode`= `regrestsshop`.`alccode` LIMIT 1) AS `barcodes`,`Quantity`,(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`regrestsshop`.`alccode` LIMIT 1) AS `ProductVCode` FROM `regrestsshop` ORDER BY `alcname` ASC';

 xrecbuf:=formStart.DB_query(Query);
 xrowbuf:=formstart.db_next(xrecbuf);
 Stringgrid1.RowCount:=1;
 while xrowbuf <> nil do begin
   if (flShowBeer and flShowAP) then begin
     Stringgrid1.RowCount:=i+1;
     Stringgrid1.Cells[3,i]:=xrowbuf[0];
     Stringgrid1.Cells[1,i]:=xrowbuf[1];
     Stringgrid1.Cells[2,i]:=xrowbuf[2];
     Stringgrid1.Cells[4,i]:=xrowbuf[3];
     i:=i+1;
   end else begin
     if (thisBeer( xrowbuf[4]) and flShowBeer)or((not thisBeer( xrowbuf[4]))and( flShowAP) ) then begin
     Stringgrid1.RowCount:=i+1;
     Stringgrid1.Cells[3,i]:=xrowbuf[0];
     Stringgrid1.Cells[1,i]:=xrowbuf[1];
     Stringgrid1.Cells[2,i]:=xrowbuf[2];
     Stringgrid1.Cells[4,i]:=xrowbuf[3];
     i:=i+1;
     end;
   end;

   xrowbuf:=formstart.db_next(xrecbuf);
 end;
 BitBtn3Click(nil);
 end else begin
   query:='SELECT (SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode`= `doc29`.`alccode` LIMIT 1) AS `alcname`,`alccode`,(SELECT `barcodes` FROM `sprgoods` WHERE `sprgoods`.`extcode`= `doc29`.`alccode` LIMIT 1) AS `barcodes`,`count`,`countfact`,`countdelta` FROM `doc29` WHERE `numdoc`="'+edNumDoc.Text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',tddateDoc.Date)+'";';
   xrecbuf:=formStart.DB_query(Query);
   xrowbuf:=formstart.db_next(xrecbuf);
   Stringgrid1.RowCount:=1;
   while xrowbuf <> nil do begin
     Stringgrid1.RowCount:=i+1;
     Stringgrid1.Cells[3,i]:=xrowbuf[0];
     Stringgrid1.Cells[1,i]:=xrowbuf[1];
     Stringgrid1.Cells[2,i]:=xrowbuf[2];
     Stringgrid1.Cells[4,i]:=xrowbuf[3];
     Stringgrid1.Cells[5,i]:=xrowbuf[4];
     Stringgrid1.Cells[6,i]:=xrowbuf[5];
     i:=i+1;
     xrowbuf:=formstart.db_next(xrecbuf);
   end;
   BitBtn3Click(nil);
 end;
end;

procedure TFormInventShop.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
begin
//  if value<>'' then
//     stringgrid1.Cells[6,arow]:=inttostr(strtoint(stringgrid1.Cells[4,arow])-strtoint(stringgrid1.Cells[5,arow]));
end;

procedure TFormInventShop.StringGrid1SelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin

end;

procedure TFormInventShop.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  i:integer;
begin
    if value<>'' then   begin
      for i:=1 to length(value) do
       if not (value[i] in ['0'..'9']) then begin
          stringgrid1.Cells[6,arow]:='0';
          exit;
       end;
     stringgrid1.Cells[6,arow]:=inttostr(strtoint(stringgrid1.Cells[4,arow])-strtoint(stringgrid1.Cells[5,arow]));
     end
     else begin
       // value:='0';
        if stringgrid1.Cells[5,arow]= '' then
          stringgrid1.Cells[5,arow]:='0';
       stringgrid1.Cells[6,arow]:=inttostr(strtoint(stringgrid1.Cells[4,arow])-strtoint(stringgrid1.Cells[5,arow]));
     end;
end;

procedure TFormInventShop.FormKeyPress(Sender: TObject; var Key: char);
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
      begin
        AlcCode1:='';
        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
        key:=#0;
        con1:=0;
        for i:=1 to Stringgrid1.RowCount-1 do begin
          if alccode1= stringgrid1.Cells[1,i] then
            begin
              con1:=i;
              break;
            end;
        end;
        if con1 > 0 then
          stringgrid1.Row:=con1
          else begin

            xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+AlcCode1+'" '  );
            xrowbuf:=formStart.DB_Next(xrecbuf);
            if xrowbuf<>nil then begin
              i:=StringGrid1.RowCount;
              StringGrid1.RowCount:=i+1;
              StringGrid1.Cells[2,i]:='';
              StringGrid1.Cells[4,i]:='0';
              StringGrid1.Cells[3,i]:=xrowbuf[0];
              StringGrid1.Cells[1,i]:=AlcCode1;
              StringGrid1.Col:=3;
              StringGrid1.Row:=i;
            end else begin
                showmessage('Нет данных по данному товару!');
            end;
            flPDF417:='';

          end;
        flPDF417:='';
    end;
      flPDF417:='';
  end;
end;

procedure TFormInventShop.BitBtn5Click(Sender: TObject);
var
  i:integer;
  ind:integer;
begin
  // ===== оприходование в торговый зал =====
  FormActChargeOnShop.StringGrid1.Clear;
  FormActChargeOnShop.StringGrid1.RowCount:=1;
  ind:=1;
  for i:=1 to stringgrid1.RowCount-1 do begin
     if (pos('-',StringGrid1.Cells[6,i])<>0) then begin
       FormActChargeOnShop.StringGrid1.RowCount:=FormActChargeOnShop.StringGrid1.RowCount+1;
       FormActChargeOnShop.StringGrid1.Cells[1,ind]:=StringGrid1.Cells[3,i];
       FormActChargeOnShop.StringGrid1.Cells[2,ind]:=StringGrid1.Cells[1,i];
       FormActChargeOnShop.StringGrid1.Cells[3,ind]:=inttostr(-1*strtoint(StringGrid1.Cells[6,i]));
       ind:=ind+1;

     end;
  end;
  FormActChargeOnShop.flNew:=true;
  FormActChargeOnShop.ShowModal;
  ind:=1;
  FormActWriteOffShop.NumDoc:='';
  FormActWriteOffShop.DateDoc:='';
  FormActWriteOffShop.StringGrid1.Clear;
  FormActWriteOffShop.StringGrid1.RowCount:=1;
  for i:=1 to Stringgrid1.RowCount-1  do begin
    if (pos('-',StringGrid1.Cells[6,i])=0 ) and (StringGrid1.Cells[6,i]<>'0') then begin
      FormActWriteOffShop.StringGrid1.RowCount:=ind+1;
      FormActWriteOffShop.StringGrid1.Cells[2,ind]:=StringGrid1.Cells[1,i];
      FormActWriteOffShop.StringGrid1.Cells[1,ind]:=StringGrid1.Cells[3,i];
      FormActWriteOffShop.StringGrid1.Cells[3,ind]:=StringGrid1.Cells[6,i];
      ind:=ind+1;
    end;
  end;
  FormActWriteOffShop.flNew:=false;
  FormActWriteOffShop.ShowModal;
end;

procedure TFormInventShop.BitBtn6Click(Sender: TObject);
var
  y,
  i:integer;
  str:string;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
    SLine:TStringList;
    plu,barcode,name1,count1:string;
    count2:integer;
    count3:integer;
    alccode1:string;
begin
  if opendialog1.Execute  then begin
    sLine:=TStringList.Create;
    sLine.Clear;
    sline.LoadFromFile(opendialog1.FileName);
    for i:=0 to sline.Count-1 do begin
      str:=sLine.Strings[i];
      y:=pos(';',str);
      plu:=copy(str,1,y-1);
      str:=copy(str,y+1,length(str));
      y:=pos(';',str);
      barcode:=copy(str,1,y-1);
      str:=copy(str,y+1,length(str));
      y:=pos(';',str);
      name1:=copy(str,1,y-1);
      count1:=copy(str,y+1,length(str));

        if  (pos(',',count1)<>0 )or (pos('.',count1)<>0 ) then
          begin
  //          count1:='0';
  //          count2:=0;
            y:=pos(',',count1);
            if y=0 then
               y:=pos('.',count1);
            count1:=copy(count1,1,y-1);
            count2:=strtoint(count1)+1;
            count1:=inttostr(count2);
            formlogging.AddMessage('Дробный товар:'+sLine.Strings[i])

          end
        else begin
         if count1<>'' then
          count2:=strtoint(count1)
          else begin
            count2:=0;
            count1:='0';
            end;

      end;
      xrecbuf:=formstart.DB_query('SELECT `extcode` FROM `sprgoods` WHERE `plu`="'+plu+'" AND `extcode`<>"";');
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf = nil then
        formlogging.AddMessage('Не найден товар:'+sLine.Strings[i])
        else
          while (xrowbuf<> nil)and(count2>0) do begin
            alccode1:=xrowbuf[0];
            for y:=1 to stringgrid1.RowCount -1 do begin
               if Stringgrid1.Cells[1,y] = alccode1 then begin
                  count3:=strtoint(Stringgrid1.Cells[4,y])-strtoint(Stringgrid1.Cells[5,y]);
                  if count3>0 then begin
                    if count3>count2 then begin
                      //count4:=
                      Stringgrid1.Cells[5,y]:=inttostr(strtoint(Stringgrid1.Cells[5,y])+count2);
                      count2:=0;
                    end else begin
                      count2:=count2-count3;
                      Stringgrid1.Cells[5,y]:= Stringgrid1.Cells[4,y];
                    end;

                  end;

               end;
            end;
            xrowbuf:=formstart.DB_Next(xrecbuf);
          end;
      if  count2>0 then
          formlogging.AddMessage('Недостаточно товара:'+sLine.Strings[i])

    end;
    sline.free;
  end;
end;

procedure TFormInventShop.BitBtn1Click(Sender: TObject);
var
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  if formspproduct.showmodal = 1377 then begin
    for i:=1 to Stringgrid1.RowCount-1 do begin
      if formspproduct.sAlcCode= stringgrid1.Cells[1,i] then
        begin
          Stringgrid1.row:=i;
          exit;
        end;
    end;
    Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
    xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+formspproduct.sAlcCode+'" '  );
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      i:=StringGrid1.RowCount;
      StringGrid1.RowCount:=i+1;
      StringGrid1.Cells[2,Stringgrid1.RowCount-1]:='';
      StringGrid1.Cells[4,Stringgrid1.RowCount-1]:='0';
      StringGrid1.Cells[3,Stringgrid1.RowCount-1]:=xrowbuf[0];
      StringGrid1.Cells[1,Stringgrid1.RowCount-1]:=formspproduct.sAlcCode;
      StringGrid1.Col:=3;
      StringGrid1.Row:=i;
    end else begin
        showmessage('Нет данных по данному товару!');
    end;
  end;
end;

procedure TFormInventShop.bbRefreshRestShopClick(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
 i:=1;
 flPDF417:='';
 for i:=1 to StringGrid1.RowCount-1 do begin
   query:='SELECT `Quantity` FROM `regrestsshop` WHERE `alccode`="'+Stringgrid1.cells[1,i]+'" LIMIT 1;';
   xrecbuf:=formStart.DB_query(Query);
   xrowbuf:=formstart.db_next(xrecbuf);
   if xrowbuf<>nil then
       Stringgrid1.Cells[4,i]:=xrowbuf[0]
   else
      Stringgrid1.Cells[4,i]:='0';

 end;
 BitBtn3Click(sender);
end;

procedure TFormInventShop.BitBtn3Click(Sender: TObject);
var
  i:integer;
  summ:integer;
begin
  summ:=0;
  for i:=1 to StringGrid1.RowCount-1 do begin
    if StringGrid1.cells[4,i]='' then
      StringGrid1.cells[4,i]:='0';
    summ:=summ+strtoint(StringGrid1.cells[4,i]);

  end;
  stEgaisOst.caption:='Итого по ЕГАИС:'+inttostr(summ);
  summ:=0;
  for i:=1 to StringGrid1.RowCount-1 do begin
    if StringGrid1.cells[5,i]='' then
     StringGrid1.cells[5,i]:='0';
    summ:=summ+strtoint(StringGrid1.cells[5,i]);
    stringgrid1.Cells[6,i]:=inttostr(strtoint(stringgrid1.Cells[4,i])-strtoint(stringgrid1.Cells[5,i]));
  end;

  stFaktOst.caption:='Итого по Факт:'+inttostr(summ);
end;

procedure TFormInventShop.BitBtn4Click(Sender: TObject);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  Query:String;
  i:integer;
begin
  if edNumDoc.Text<>'' then begin
     formStart.DB_query('DELETE FROM `doc29` WHERE `numdoc`="'+edNumDoc.Text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',tddateDoc.Date)+'";');
     for i:=1 to StringGrid1.RowCount-1 do begin
       Query:='INSERT `doc29` (`numdoc`,`datedoc`,`alccode`,`count`,`countfact`,`countdelta`) VALUES '+
       '("'+edNumDoc.Text+'" ,"'+FormatDateTime('YYYY-MM-DD',tddateDoc.Date)+'","'+StringGrid1.Cells[1,i]+'","'+StringGrid1.Cells[4,i]+'","'+StringGrid1.Cells[5,i]+'","'+StringGrid1.Cells[6,i]+'");';
       formStart.DB_query(Query);

     end;
     Query:='SELECT `status` FROM `docjurnale` WHERE `numdoc`="'+edNumDoc.Text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',tddateDoc.Date)+'" AND `type`="InventShop";';
     xrecbuf:=formStart.DB_query(Query);
     xrowbuf:=Formstart.DB_Next(xrecbuf);
     if xrowbuf= nil then
       formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+edNumDoc.Text+'" ,"'+FormatDateTime('YYYY-MM-DD',tddateDoc.Date)+'","InventShop","---");');
  end;
end;

procedure TFormInventShop.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=46)AND(StringGrid1.Row>0) then begin
     StringGrid1.DeleteRow(StringGrid1.Row);
  end;
  if (key<96) and (key>32) then  begin
    flPDF417:=flPDF417+char(lo(key));
    key:=0;
  end;

end;
procedure TFormInventShop.OpenDoc(const numDoc,DateDoc:string);
begin
  flnew:=false;
  tddateDoc.Date:=formStart.Str1ToDate(datedoc);
  edNumDoc.Text:=numdoc;

  showmodal;
end;

procedure TFormInventShop.NewDoc();
begin
  flShowBeer:=true;
  flShowAP:=true;
  flnew:=true;
  tddateDoc.Date:=now();
  edNumDoc.Text:='';
  Caption:='Инвентаризация торгового зала';
  showmodal;
end;

procedure TFormInventShop.NewDocBeer;
begin
  flShowBeer:=true;
  flShowAP:=false;
  flnew:=true;
  tddateDoc.Date:=now();
  edNumDoc.Text:='';
  Caption:='Инвентаризация торгового зала (только пиво и пивные напитки)';
  showmodal;
end;

procedure TFormInventShop.NewDocAP;
begin
  flShowBeer:=false;
  flShowAP:=true;
  flnew:=true;
  tddateDoc.Date:=now();
  edNumDoc.Text:='';
  Caption:='Инвентаризация торгового зала (только подакцизный товар)';
  showmodal;
end;

end.

