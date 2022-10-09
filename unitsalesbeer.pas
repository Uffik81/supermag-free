unit unitSalesBeer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Grids, Buttons, StdCtrls, Menus, ComCtrls;

type

  { TFormSalesBeer }

  TFormSalesBeer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    bbBlockScreen: TBitBtn;
    bbExit: TBitBtn;
    BitBtn7: TBitBtn;
    bbVnesti: TBitBtn;
    bbViplata: TBitBtn;
    BitBtn8: TBitBtn;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miXReport: TMenuItem;
    miZReport: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    stAlcValue: TStaticText;
    stLitr: TStaticText;
    stSumma: TStaticText;
    stTypeDoc: TStaticText;
    stNumCheck: TStaticText;
    stBarcode: TStaticText;
    stPDF417: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    stNumber: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure bbBlockScreenClick(Sender: TObject);
    procedure bbViplataClick(Sender: TObject);
    procedure bbVnestiClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1Next(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure miXReportClick(Sender: TObject);
    procedure miZReportClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1Resize(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
    FlgLoadLibFR:boolean;
    FlgLoadLibSB:boolean;
    SizeStrFr:Integer;
  public
    { public declarations }
    flNumber:string;
    flCheckSales:boolean;
    flSession:integer;
    flNumcheck:integer;
    flAllSumma:real;
    flInpSumm:real;
    curLine:integer;
    Itogsumm:real;
    flSelRow:integer;
    flOpenDoc:boolean;
    flTypeKKM:integer; // 0,1 - ШтрихМ , 2 - Атол ....
    indCheck:integer;
    flPrefixVes:string;
    flPrefixCard:String;
    flIdCard:string;
    flProcentCard:string;
    flProcentSkid:real;
    function addBarcode(aBC:String):boolean;
    function addPLUcode(aBC,aCount:string):boolean;
    function getvolumebc(abc:string):string;
    procedure addPositionEGAIS(Sender: TObject);
    function addtrans(aKassaHW,aNumCheck,aTrans,aPLU,aCount,aPrice,aSumm,aBarCode,alccode,aPDF417:String; aName:string = ''):boolean;
    function controlpdf417(aPDF417:string):boolean;
    function printcheck():boolean;
    function closecheck():boolean;
    function printURL(aURL,aSIGN:string):boolean;
    function OrderSale(aOperBank:boolean):integer;
    function OrderReturn(aOperBank:boolean):integer;
    Procedure ShowKKMOption();
    Procedure PrintZReport();
    Procedure PrintXReport();
    Procedure PrintBankReport();
    Procedure PrintInkass();
    Procedure PrintDepReport();
    function GetStatusFR(Messages:boolean):Integer;
    function GetNumberCheck():Integer;
    Function PrintLineGood(aname:String;count:String):integer;
    Function PrintLineString(const aStr:String):integer;
    FUNCTION StrCenter(const aStr:String):String;
    Function PrintLineStringAnsi(const aStr:ansiString):integer;
    procedure NewCheck();
    procedure clearcheck();
    procedure PrintAlcReport(aDate:String);
    procedure GetReport();
    // === СБЕРБАНК =====
    // --- Сбербанк - обработки
    function PrintSlipSB(aCountSlip:integer=1):integer;
    function CloseDaySB():integer;
    function SalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    function CancelSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    function ReturnSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
    procedure CashIncome();
    procedure CashOutcome();
    function summTitle(aSumm:real):string;
    function InitDevice():boolean;
  end;

var
  FormSalesBeer: TFormSalesBeer;


function thisBeer(fIMNS:string):boolean;
function getshiftcash():string;


implementation
uses
  mysql50,
  DOM, XMLRead, typinfo,
  qrcode,
  comobj,  variants,
  LCLIntf,
 // base64,
  lconvencoding,
  INIFiles,
  lclproc
  //,ssockets
  ,fphttpclient // Стандартная библиотека для http
  ,unitsetpdf417
  ,unitstart
  , unitloginadmin
  , unitinputprice
  ,unitaddbarcode,
  unitinputsumm
  ,unitSelectProd,
  unitShowStatus,
  unitunlockscreen,
  unitcomment;
{$R *.lfm}

const
  CRLF = #13#10;
{ TFormSalesBeer }

var
  OleFR:Olevariant;
  OleSBR:Olevariant;

function  StrToWide(const aStr: ansiString):widestring;
var
  i:byte;
  str1:WideString;
  str2:string;
begin
  str1:=aStr;
  result:= str1;
end;

function thisBeer(fIMNS:string):boolean;
begin
 result:=false;
 if fIMNS ='500' then result:=true;
 if fIMNS ='520' then result:=true;
 if fIMNS ='261' then result:=true;
 if fIMNS ='263' then result:=true;
 if fIMNS ='262' then result:=true;
end;

procedure TFormSalesBeer.clearcheck();
var
  ii:integer;
begin
  flNumber:='';
  curLine:=0;
  flCheckSales:=true;
  flAllSumma:=0;
  Itogsumm:=0;
  flselrow:=0;
  flOpenDoc:=false;
  flPrefixVes:=formStart.GetConstant('prefixvesi');
  flPrefixcard:=formStart.GetConstant('prefixcard');
  flIdCard:='';
  flProcentCard:='';
  flProcentSkid:=100;
  for ii:= 1 to StringGrid1.RowCount-1 do
    StringGrid1.Rows[ii].Clear;
  StringGrid1.RowCount:=curLine+1;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  if flCheckSales then
    stTypeDoc.Caption:='ПРОДАЖА'
  else
    stTypeDoc.Caption:='ВОЗВРАТ';
  stNumCheck.Caption:='Номер чека:'+#13#10+inttostr(flNumCheck);
  StringGrid1Selection(nil,0,0);
end;

procedure TFormSalesBeer.PrintAlcReport(aDate:String);
var
  i:integer;
  allsumm:integer;
  AllCount:integer;
begin
 formstart.recbuf:=formStart.DB_query('SELECT (SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode`) AS `Capacity`,`name`, COUNT(*) AS `scount`,`alccode` FROM `doccash` WHERE `datedoc`="'+aDate+'" AND `typetrans`="11" GROUP BY `alccode`;');
 formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 i:=1;
 allsumm:=0;
 PrintLineStringAnsi(utf8toansi('Отчет о продажах за '+aDate));
 PrintLineGood('Наименование','шт.');
 while formstart.rowbuf<>nil do begin
   PrintLineGood(inttostr(i)+' '+formstart.rowbuf[1]+' '+formstart.rowbuf[0],formstart.rowbuf[2]);
   allsumm:=allsumm+strtoint(trim(formstart.rowbuf[2]));
   i:=i+1;
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 end;
 PrintLineStringAnsi(utf8toansi('========================================================================================='));
 PrintLineGood('Итого продано:',inttostr(allsumm));
 PrintLineStringAnsi(utf8toansi('Отчет о возвратах за '+aDate));
 formstart.recbuf:=formStart.DB_query('SELECT (SELECT `Capasity` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode`) AS `Capasity`,(SELECT `egaisname` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode`) AS `name`, COUNT(*) AS `scount`,`alccode` FROM `doccash` WHERE `datedoc`="'+aDate+'" AND `typetrans`="13" GROUP BY `alccode`;');
 formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 i:=1;
 AllCount:=allsumm;
 allsumm:=0;
 PrintLineGood('Наименование','шт.');
 while formstart.rowbuf<>nil do begin
   PrintLineGood(inttostr(i)+' '+formstart.rowbuf[1]+' '+formstart.rowbuf[0],formstart.rowbuf[2]);
   allsumm:=allsumm+strtoint(trim(formstart.rowbuf[2]));
   i:=i+1;
   formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
 end ;
 AllCount:=AllCount-allsumm;
 PrintLineGood('Итого возвращено:',inttostr(allsumm));
 PrintLineGood('Итого :',inttostr(AllCount));

end;

procedure TFormSalesBeer.NewCheck();
begin
 flNumber:='';
 clearcheck();
 showmodal;

end;

function TFormSalesBeer.printcheck():boolean;
var
  ii:integer;
begin
 result:=false;
 try
  for ii:=1 to stringgrid1.RowCount-1 do  begin
    PrintLineGood(inttostr(ii)+' '+StringGrid1.Cells[2,ii]+' '+StringGrid1.Cells[9,ii]+' л.',StringGrid1.Cells[3,ii]);
  end;
  result:=true;
 except
  result:=false;
 end;
end;

function TFormSalesBeer.closecheck():boolean;

begin
 result:=false;
 try
  if flCheckSales then
    OrderSale(forminputsumm.flOperBank)
  else
    OrderReturn(forminputsumm.flOperBank);
  result:=true;
 except
   result:=false;
 end;

end;

function TFormSalesBeer.printURL(aURL,aSIGN:string):boolean;
var
  str1:string;
  strwd1:WideString;
  res:integer;
  i:integer;
begin
 result:=false;
//              AResponse.Content:= '';
//            AResponse.Content:=AResponse.Content+url+#13#10;  // первый url
   try
  if FlgLoadLibFR then
   begin
     case flTypeKKM of
       0:begin
         str1:=StringToHex(aURL);
  	for i:=1 to (Length(str1) div 128)+1 do begin
  		OleFR.Password:=30;
          	OleFR.BlockType := 0;
         	OleFR.BlockNumber := i-1;
                 strwd1:=Copy(str1,1+(i-1)*128,125);
         	OleFR.BlockDataHex := strwd1;
         	OleFR.LoadBlockData();
  	end;
  	OleFR.BarcodeType:=3;		//тип ШК - QR
  	OleFR.BarcodeDataLength:=length(aURL);
  	OleFR.BarcodeStartBlockNumber:=0;
  	OleFR.BarcodeParameter1:=0; //версия ШК 0-авто
  	OleFR.BarcodeParameter2:=0; //маска ШК 0-авто
  	OleFR.BarcodeParameter3:=5; //размер точки в ШК 3..8
  	OleFR.BarcodeParameter4:=0;
  	OleFR.BarcodeParameter5:=2; //уровень коррекции ошибок 0..3
  	OleFR.BarcodeAlignment:=0;  //выравнивание посередине
  	OleFR.Password:=30;
  	OleFR.Print2DBarcode();
  	OleFR.WaitForPrinting();
         printURL:=true;
       end;
       1:begin
         OleFR.password:=30;
         strwd1:=aURL;
        // OleFR.PixelLineLength :=300;
         OleFR.PrintPurpose :=1;
         OleFR.LeftMargin :=10;
         OleFR.BarcodeType :=84;
         OleFR.Alignment :=1;
         OleFR.Barcode := strwd1;
         OleFr.Height :=1200;
         OleFR.BarcodeControlCode :=0;
         OleFR.PrintBarcodeText :=0;
         OleFR.Scale  :=400;
         OleFR.AutoSize :=0;
         res:=OleFR.PrintBarcode();
         if res<>0 then begin
           showmessage('Atol error='+inttostr(res));
           printURL:=false;
         end else
           printURL:=true;
       end
       else
         OleFR.password:=30;
         strwd1:=aURL;
         OleFR.BarCode := strwd1;
         OleFR.BarWidth :=2;
         OleFR.LineNumber:=150;
         OleFR.BarcodeAlignment:=0;
         OleFR.BarcodeType:=3;
         OleFR.PrintBarcodeGraph();
         OleFR.BarcodeOptions := $011;
         OleFR.PrintBarcode();
         printURL:=true;

       end;
    end;
    str1:=asign;
    while length(str1)>32 do begin
      PrintLineString(copy(str1,1,32));
      str1 :=copy(str1,33,length(asign)-32);
    end;
    if length(str1)>1 then
       PrintLineString(str1);

    str1:=aurl;
    while length(str1)>32 do begin
      PrintLineString(copy(str1,1,32));
      str1 :=copy(str1,33,length(str1)-32);
    end;
    if length(str1)>1 then
       PrintLineString(str1);
    except
     result:=false;
    end;


end;
function TFormSalesBeer.addPLUcode(aBC,aCount:string):boolean;
var
  Query:string;
  PrdVCode:integer;
  vPDF417,vAlcCode,aPart,aSerial:string;
  strPrice:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  fplu:string;
begin
  strprice:='0.00';
  PrdVCode:=0;
  vPDF417:='';
  result:=false;
  flAlcGoods:=false;
  { formstart.AutoUpdateGoods}
  Query:='SELECT `aBC`,`currentprice` FROM `sprgoods` WHERE `plu`="'+aBC+'" AND `alcgoods`="+";';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    flAlcGoods:=true;
    fplu:=xrowbuf[0];
    strprice:=xrowbuf[1];
    showmessage('Алкогольный товар продовать по коду нельзя!');
    result:=false;
    exit;
  end;
     Query:='SELECT `extcode`,`currentprice`,`name`,'+
          ''''','+
          ''''','
          +''''',`sprgoods`.`name`,`sprgoods`.`barcodes`,COUNT(*) AS `countline`, `freeprice`  FROM `sprgoods` WHERE `plu`='''+aBC+''' AND `alcgoods`<>''+'' GROUP BY `barcodes`;';
   xrecbuf:= formStart.DB_query(Query);
   xrowbuf:=formStart.DB_Next(xrecbuf);
   if  xrowbuf<>nil then
         begin
            strprice := format('%8.2f',[formstart.StrToFloat(xrowbuf[1])]);
             if xrowbuf[9]='+' then begin
                forminputprice.flPrice:=strprice;
                forminputprice.flName:=xrowbuf[6];
                forminputprice.flAlcCode:=xrowbuf[7];
                forminputprice.flAlcVolume:='-';
                forminputprice.flbarCode:=aBC;
                forminputprice.flCapacity:='-';
                forminputprice.flReturn:=not flCheckSales;
                if  not forminputprice.getPrice() then begin
                   exit;
                end;
                strprice:=forminputprice.flPrice;
              end;
            CurLine:=CurLine+1;
            StringGrid1.RowCount:=CurLine+1;
            Stringgrid1.Rows[curLine].Clear;
            Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
            Stringgrid1.Rows[curLine].Add(aBC);
            Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
            Stringgrid1.Rows[curLine].Add(strprice);
            Stringgrid1.Rows[curLine].Add(aCount);
            Stringgrid1.Rows[curLine].Add(FloattoStr(StrToFloat(strprice)*strtoFloat(aCount)*0.001));
            Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
            Stringgrid1.Rows[curLine].Add('');
            Stringgrid1.Rows[curLine].Add(vPDF417);
            Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
            Stringgrid1.Rows[curLine].Add('0');
            Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
            Stringgrid1.Rows[curLine].Add('');
         end else begin
            showMessage('Не найден товар с кодом товара:'+aBC);
         result:=false;
     //showmessage('надо сопоставить товар!');
    end;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
end;

function TFormSalesBeer.addBarcode(aBC:String):boolean;
var
  Query:string;
  PrdVCode:integer;
  vPDF417,vAlcCode,aPart,aSerial:string;
  strPrice:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  flAlcGoods:boolean;
  fplu:string;
begin
  strprice:='0.00';
  PrdVCode:=0;
  vPDF417:='';
  result:=false;
  // ==== получим по ШК статус алкоголь =====
  flAlcGoods:=false;
  { formstart.AutoUpdateGoods}
  Query:='SELECT `plu`,`currentprice` FROM `sprgoods` WHERE `barcodes`="'+aBC+'" AND `alcgoods`="+" LIMIT 1;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    flAlcGoods:=true;
    fplu:=xrowbuf[0];
    strprice:=xrowbuf[1];
  end;
  // ========================================

  Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
         '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
         '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
         +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`, `freeprice`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `extcode`<>'''' GROUP BY `barcodes`;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
   begin
     fplu:=xrowbuf[7];
     if xrowbuf[4]<>'' then begin
      PrdVCode:=StrToInt(xrowbuf[4]) ;
     if not thisBeer(xrowbuf[4]) then
      begin
        formsetpdf417.flName:=xrowbuf[2];
        formsetpdf417.flAlcCode:=trim(xrowbuf[0]);
        formsetpdf417.flAlcVolume:=xrowbuf[3];
        formsetpdf417.flbarCode:=aBC;
        formsetpdf417.flCapacity:=xrowbuf[5];
        formsetpdf417.flReturn:=not flCheckSales;
        if formsetpdf417.getpdf417() then
         begin

             vPDF417:=formsetpdf417.flPDF417;
             if controlpdf417(vPDF417) then begin
               showmessage('Данная марка уже добавлена в ЧЕК!');
               exit;
             end;
             formStart.DecodeEGAISPlomb(vPDF417,vAlcCode,aPart,aSerial);
             if vAlcCode='' then begin
               ShowMessage('Нет данных по данному алкоголю, пожалуйста исправте в справочнике товара!');
               exit;
             end;
             if vAlcCode<> trim(xrowbuf[0]) then
              begin
               if (formstart.flRMKOffline) then begin

                 query:='INSERT `sprgoods` (`plu`,`name`,`fullname`,`currentprice`,`updating`,`article`,`barcodes`,`weightgood`,`extcode`,`alcgoods`) VALUES ('
                 +''''+fplu+''','''+xrowbuf[6]+''','''+xrowbuf[2]+''','''+xrowbuf[1]+''',''+'','''+fplu+''','''+trim(aBC)+''','''','''+vAlcCode+''',''+'');';
                 formstart.DB_query(Query);
               end else begin
                 showmessage('Данный товар не соответствует акцизной марке, проверьте данные в справочнике товара!');
               // formStart.DB_query('UPDATE `sprgoods` SET `extcode`="'+vAlcCode+'",`updating`="+",`alcgoods`="+" WHERE `barcodes`="'+aBC+'";');
                 exit;

               end;
              end;
              forminputprice.flPrice:=xrowbuf[1];
              forminputprice.flName:=xrowbuf[2];
              forminputprice.flAlcCode:=trim(xrowbuf[0]);
              forminputprice.flAlcVolume:=xrowbuf[3];
              forminputprice.flbarCode:=aBC;
              forminputprice.flCapacity:=xrowbuf[5];
              forminputprice.flReturn:=not flCheckSales;
              if (not formstart.flRMKOffline) then begin
                if flCheckSales then begin
                  if  not forminputprice.getPrice() then
                   exit;
                end;
              end;
             strprice:=forminputprice.flPrice;
           end
          else begin
           showmessage('Ошибка акцизы:'+formsetpdf417.flPDF417);
           exit;
          end;
        end
       else
        begin
          // ==== это пиво
          if xrowbuf[8]<>'1' then
            begin
              FormSelectProd.sBarCode:= aBC;
              if FormSelectProd.ShowModal <> 1377 then
                 exit;
              vAlcCode:=FormSelectProd.sAlcCode
            end else
              vAlcCode:= trim(xrowbuf[0]);
          forminputprice.flPrice:=xrowbuf[1];
          forminputprice.flName:=xrowbuf[2];
          forminputprice.flAlcCode:=trim(xrowbuf[0]);
          forminputprice.flAlcVolume:=xrowbuf[3];
          forminputprice.flbarCode:=aBC;
          forminputprice.flCapacity:=xrowbuf[5];
          forminputprice.flReturn:=not flCheckSales;
          if (not formstart.flRMKOffline) then begin
            if  not forminputprice.getPrice() then
             exit;
          end;
          strprice:=forminputprice.flPrice;
        end;
         strprice := format('%8.2f',[formstart.StrToFloat(strprice)]);
         CurLine:=CurLine+1;
         StringGrid1.RowCount:=CurLine+1;
         Stringgrid1.Rows[curLine].Clear;
         Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
         Stringgrid1.Rows[curLine].Add(fplu);
         Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add('1');
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add(aBC);
         Stringgrid1.Rows[curLine].Add('');
         Stringgrid1.Rows[curLine].Add(vPDF417);
         Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[4]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
         Stringgrid1.Rows[curLine].Add(vAlcCode);
      end else begin
         strprice := format('%8.2f',[formstart.StrToFloat(xrowbuf[1])]);
         // >>> Обработаем ввод цены для обычного товара <<<
         if xrowbuf[9]='+' then begin
              forminputprice.flPrice:=strprice;
              forminputprice.flName:=xrowbuf[6];
              forminputprice.flAlcCode:=xrowbuf[7];
              forminputprice.flAlcVolume:='-';
              forminputprice.flbarCode:=aBC;
              forminputprice.flCapacity:='-';
              forminputprice.flReturn:=not flCheckSales;
              if (not formstart.flRMKOffline) then begin
                if  not forminputprice.getPrice() then
                 exit;
              end;
              strprice:=forminputprice.flPrice;
            end;
         CurLine:=CurLine+1;
         StringGrid1.RowCount:=CurLine+1;
         Stringgrid1.Rows[curLine].Clear;
         Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
         Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
         Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add('1');
         Stringgrid1.Rows[curLine].Add(strprice);
         Stringgrid1.Rows[curLine].Add(aBC);
         Stringgrid1.Rows[curLine].Add('');
         Stringgrid1.Rows[curLine].Add(vPDF417);
         Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
         Stringgrid1.Rows[curLine].Add('0');
         Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
         Stringgrid1.Rows[curLine].Add(vAlcCode);

      end;
     result:=true;
   end
  else begin  // ==== Не найден товар  ========  или не алкогольный товар =====
    if formStart.flRMKOffline then begin  // === в ккм оффлайне сопоставим только алк товар
      if flAlcGoods then begin
        if formaddbarcode.AddBarCode(abc) then
          result:=addBarcode(aBC)
        else   result:=false;
        exit;
        end else begin
          Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
                  '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
                  '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
                  +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`,`freeprice`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `alcgoods`<>''+'' GROUP BY `barcodes`;';
           xrecbuf:= formStart.DB_query(Query);
           xrowbuf:=formStart.DB_Next(xrecbuf);
           if  xrowbuf<>nil then   // === Ищем не алкогольный товар
                 begin
                    strprice := format('%.2f',[formstart.StrToFloat(xrowbuf[1])]);
                   if xrowbuf[9]='+' then begin
                        forminputprice.flPrice:=strprice;
                        forminputprice.flName:=xrowbuf[6];
                        forminputprice.flAlcCode:=xrowbuf[7];
                        forminputprice.flAlcVolume:='-';
                        forminputprice.flbarCode:=aBC;
                        forminputprice.flCapacity:='-';
                        forminputprice.flReturn:=not flCheckSales;
                        if  not forminputprice.getPrice() then begin
                           exit;
                        end;
                        strprice:=forminputprice.flPrice;
                      end;
                    CurLine:=CurLine+1;
                    StringGrid1.RowCount:=CurLine+1;
                    Stringgrid1.Rows[curLine].Clear;
                    Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
                    Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
                    Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
                    Stringgrid1.Rows[curLine].Add(strprice);
                    Stringgrid1.Rows[curLine].Add('1');
                    Stringgrid1.Rows[curLine].Add(strprice);
                    Stringgrid1.Rows[curLine].Add(aBC);
                    Stringgrid1.Rows[curLine].Add('');
                    Stringgrid1.Rows[curLine].Add(vPDF417);
                    Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
                    Stringgrid1.Rows[curLine].Add('0');
                    Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
                    Stringgrid1.Rows[curLine].Add('');
                 end else  begin
                    result:=false;
                    showMessage('Не найден товар со штрихкодом: '+aBC);
                    result:=false;
                    exit;
             //showmessage('надо сопоставить товар!');
                end;
      end;
    end else  /// ==== в обычной кассе это может как алк так обычный
    begin
      Query:='SELECT `extcode`,`currentprice`,(SELECT `name` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `name`,'+
             '(SELECT `AlcVolume` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `AlcVolume`,'+
             '(SELECT `ProductVCode` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode` limit 1) AS `ProductVCode`,'
             +'(SELECT `Capacity` FROM `spproduct` WHERE `alccode`=`sprgoods`.`extcode`) AS `Capacity`,`sprgoods`.`name`,`sprgoods`.`plu`,COUNT(*) AS `countline`,`freeprice`  FROM `sprgoods` WHERE `barcodes`='''+aBC+''' AND `alcgoods`<>''+'' GROUP BY `barcodes`;';
      xrecbuf:= formStart.DB_query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if  xrowbuf<>nil then   // === Ищем не алкогольный товар
            begin
               strprice := format('%.2f',[formstart.StrToFloat(xrowbuf[1])]);
              if xrowbuf[9]='+' then begin
                   forminputprice.flPrice:=strprice;
                   forminputprice.flName:=xrowbuf[6];
                   forminputprice.flAlcCode:=xrowbuf[7];
                   forminputprice.flAlcVolume:='-';
                   forminputprice.flbarCode:=aBC;
                   forminputprice.flCapacity:='-';
                   forminputprice.flReturn:=not flCheckSales;
                   if  not forminputprice.getPrice() then begin
                      exit;
                   end;
                   strprice:=forminputprice.flPrice;
                 end;
               CurLine:=CurLine+1;
               StringGrid1.RowCount:=CurLine+1;
               Stringgrid1.Rows[curLine].Clear;
               Stringgrid1.Rows[curLine].Add(inttoStr(curLine));
               Stringgrid1.Rows[curLine].Add(xrowbuf[7]);
               Stringgrid1.Rows[curLine].Add(xrowbuf[6]);
               Stringgrid1.Rows[curLine].Add(strprice);
               Stringgrid1.Rows[curLine].Add('1');
               Stringgrid1.Rows[curLine].Add(strprice);
               Stringgrid1.Rows[curLine].Add(aBC);
               Stringgrid1.Rows[curLine].Add('');
               Stringgrid1.Rows[curLine].Add(vPDF417);
               Stringgrid1.Rows[curLine].Add(xrowbuf[5]);
               Stringgrid1.Rows[curLine].Add('0');
               Stringgrid1.Rows[curLine].Add(xrowbuf[3]);
               Stringgrid1.Rows[curLine].Add('');
            end else begin  // === не нашли значит сопоставляем с алкоголем ===
              if formaddbarcode.AddBarCode(abc) then
                result:=addBarcode(aBC)
              else begin
               result:=false;
               showMessage('Не найден товар со штрихкодом: '+aBC);
               result:=false;
               exit;
              end;
        //showmessage('надо сопоставить товар!');
           end;


    end;

  end;
 StringGrid1.SetFocus;
 flSelRow:= stringgrid1.RowCount -1;
 stringgrid1.Row:=flSelRow;
end;



function getshiftcash():string;
var                // вычисляем смену количество дней прошедших от 2016-01-01
 year,month,day:word;
begin
 year:=0;
 month:=0;
 day:=0;
 DecodeDate(now(),year,month,day);
 year:=year-2016;
 result:=inttostr( year*12*32+month*32+day);
end;

procedure TFormSalesBeer.addPositionEGAIS(Sender: TObject);
const
  xbit:array[0..7] of byte=(1,2,4,8,16,32,64,128);
var
  //bm:TBitmap;

  xx,yy:integer;
  buf:string;
  //qrpm: TDelphiZXingQRCode;
  bt:byte;
  i:integer;
  ii:integer;
  url:string;
  aStr,
  str1:string;
  strbc:string;
  strpdf417:string;
  strprice:string;
  //lists:TstringList;
  flcloseCH:boolean;
  strvolume:string;
  strnumber:string;
  flalccheck:boolean;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  sign:String;
  part,ser:string;
  alccode:String;
  ikkmnum:integer;
  strkkm:string;
  flclear:boolean;
  flcount,strenable:string;
  flreturn:boolean;
  strNumCheck:string;
  strerror:string;
  lists:TStringList;
  EGAISEnabled:boolean;
  fltranst:string;
begin
 str1:=formStart.SaveToServerGET('','');
 if str1='' then
   begin
     showmessage('Нет связи с УТМ!');
     lists.free;
     exit;
   end;
  if GetStatusFR(true)<>0 then begin
    exit;
  end;
  flInpSumm:=flAllSumma;
  //if flCheckSales then begin
    formInputSumm.flCheckSales:=  flCheckSales;
    if not formInputSumm.InputSumm(flInpSumm) then
      exit;
  //end;
  if GetStatusFR(true)<>0 then begin
    if formInputSumm.flOperBank then begin
        CancelSalesCardSB(0,flAllSumma,formInputSumm.flCodeRRN,formInputSumm.flCodeAuth);
      end;

    exit;
  end;
  // ====
  FormShowStatus.Panel1.Caption:='Идет печать документа!';
  FormShowStatus.Show;
  Application.ProcessMessages;
  // ====
  lists:=TStringList.create();
  strNumCheck:=inttostr(flNumCheck);
  DefaultFormatSettings.DecimalSeparator:='.';
  // ===================
  str1:=formStart.SaveToServerGET('','');
  if str1='' then
    begin
      showmessage('Нет связи с УТМ!');
      lists.free;
      FormShowStatus.Hide;
      exit;
    end;
  // ===================
  EGAISEnabled:=false;
  if flCheckSales then begin
    flcount:='';
    fltranst:='11';
    end
  else begin
    flcount:='-';
    fltranst:='13';
    end;
       // в в буфере есть позиции которые надо закрыть
   if (StringGrid1.RowCount>1) then begin
        strNumCheck:=inttostr(flNumCheck);
        {if not printcheck() then
           begin
                showmessage('Ошибка печати чека!');
                lists.free;
                FormShowStatus.Hide;
                exit;
           end;      }
        lists.Clear;
        lists.Add('<?xml version="1.0" encoding="UTF-8"?>');
        lists.Add('<Cheque');
        lists.Add('inn="'+formStart.FirmINN+'"');
        lists.Add('datetime="'+FormatDateTime('DDMMYYhhmm',now())+'"');
        lists.Add('kpp="'+formStart.firmKPP+'"');
        lists.Add('kassa="'+formStart.prefixClient+'"');
        lists.Add('address="'+formStart.FirmAddress+'"');
        lists.Add('name="'+formStart.FirmFullName+'"');
        lists.Add('number="'+strNumCheck+'"');
        lists.Add('shift="'+getshiftcash()+'"');
        lists.Add('>');
        for ii:=1 to StringGrid1.RowCount-1 do
          if (trim(StringGrid1.Cells[10,ii])<>'')AND(trim(StringGrid1.Cells[10,ii])<>'0') then begin
           EGAISEnabled:=true;

           if thisBeer(StringGrid1.Cells[10,ii]) then begin
                 // ==== это пиво
              //<nopdf code="258" bname="Клинское светлое"  volume="0.1" alc="0.1" price="0.50" ean="46054060129760" count="2" />
              addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[5,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),'',trim(StringGrid1.Cells[2,ii]));
              lists.Add('<nopdf code="'+StringGrid1.Cells[10,ii]+'" bname="'+trim(ReplaceStr(StringGrid1.Cells[2,ii],false))+'" volume="'+trim(StringGrid1.Cells[9,ii])+'" alc="'+trim(StringGrid1.Cells[11,ii])+'" price="'+flcount+trim(StringGrid1.Cells[3,ii])+'" ean="'+trim(StringGrid1.Cells[6,ii])+'" count="'+trim(StringGrid1.Cells[4,ii])+'" />');
             end
            else begin
             addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+'1',trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[12,ii]),trim(StringGrid1.Cells[8,ii]),trim(StringGrid1.Cells[2,ii]));
             lists.Add('<Bottle barcode="'+trim(StringGrid1.Cells[8,ii])+'" ean="'+trim(StringGrid1.Cells[6,ii])+'" price="'+flcount+trim(StringGrid1.Cells[3,ii])+'" volume="'+trim(StringGrid1.Cells[9,ii])+'"  />');
            end;
           end else
             addtrans(formStart.prefixClient,strNumCheck,fltranst,trim(StringGrid1.Cells[1,ii]),flcount+trim(StringGrid1.Cells[4,ii]),trim(StringGrid1.Cells[3,ii]),trim(StringGrid1.Cells[5,ii]),trim(StringGrid1.Cells[6,ii]),trim(StringGrid1.Cells[1,ii]),'',trim(StringGrid1.Cells[2,ii]));

        lists.Add('</Cheque>');
        if formStart.flDemoMode  then
         begin
          url:='http://egais.retailika.ru/';
          sign:='HTTP://EGAIS.RETAILIKA.RU/0123456789EGAISRETAILIKARU0123456789EGAISRETAILIKARU'+
                '0123456789EGAISRETAILIKARU0123456789EGAISRETAILIKARU0123456789';

         end
        else
         begin
            url:='';
            sign:='';
            strerror:='';
            if EGAISEnabled then begin
              aStr:= formStart.SaveToServerPOST('xml',lists.Text) ;  // отправляем в егаис и ждем ответа
              // Проверяем тип ответа правильный ответ должен содержать url все остальное ошибка
              //lists.add(aStr);
              url:='';
              sign:='';
              strerror:='';
              if length(aStr)<>0 then // == получен ответ от егаис =====
              begin
                S:= TStringStream.Create(aStr);
                Try
                  S.Position:=0;
                // Обрабатываем полученный файл
                  XML:=Nil;
                  ReadXMLFile(XML,S); // XML документ целиком
                Finally
                  S.Free;
                end;
                Child :=XML.DocumentElement.FirstChild;
                while Assigned(Child) do begin

                  if Child.NodeName = 'url' then begin
                     url:=Child.FirstChild.NodeValue;
                  end;
                  if Child.NodeName = 'sign' then begin
                     sign:=Child.FirstChild.NodeValue;
                  end;
                   if Child.NodeName = 'error' then begin
                     strerror:=Child.FirstChild.NodeValue;
                  end;
                  Child:=Child.NextSibling;
                end;
              end;

            end ;
         end;


        // ====== тестовое сообщение ========
       // если в ответе нет ссылки то url будет пуст
        if url<>'' then  begin  // пришел URL обрабатывае как положено
            addtrans(formStart.prefixClient,strNumCheck,'40','0','1',floattostr(flallsumma),floattostr(flallsumma),'',sign,url);
            formStart.SetConstant('LastNumCheck',strNumCheck);
            if not printURL(url,sign) then begin
               showmessage('Товар зафиксироват в системе ЕГАИС! Но невозможно распечатать ссылку!');
               lists.free;
               FormShowStatus.Hide;
               exit;
              end;

            if not closecheck() then begin
               showmessage('Товар зафиксироват в системе ЕГАИС! Но невозможно закрыть кассовый чек!');
               lists.free;
               FormShowStatus.Hide;
               exit;
              end;
         end else begin  // == иначе фиксируем ошибку в журнале
           if EGAISEnabled then begin
             // ====== не удаляем товар пока не будет ясно что с ним!!! =====
            addtrans(formStart.prefixClient,strnumber,'240','0','1','0','0','',sign,aStr);
            formStart.SetConstant('LastNumCheck',strNumCheck);
            ShowMessage('Ошибка при передаче данных в ЕГАИС! Отложите товар до разбирательств!');
           end else
            begin  // ==== Это обычный товар =====

             addtrans(formStart.prefixClient,strNumCheck,'40','0','1',floattostr(flallsumma),floattostr(flallsumma),'',sign,url);
             closecheck();
             formStart.SetConstant('LastNumCheck',strNumCheck);

            end;
        end;
    end;
   inc(flNumCheck); // увеличиваем счетчик чеков и формируем запрос на сайт егаис
   FormShowStatus.Hide;
   lists.free;
end;

function TFormSalesBeer.addtrans(aKassaHW,aNumCheck,aTrans,aPLU,aCount,aPrice,aSumm,aBarCode,alccode,aPDF417:String; aName:string = ''):boolean;
var
  Query:String;
begin
  query:='INSERT INTO `doccash` (`numtrans`,`datetrans`,`numcheck`,`kassir`,`typetrans`,`plu`,`price`,`quantity`,`summ`,`urlegais`,`alccode`,`numdoc`,`datedoc`,`eanbc`,`name`)'+
         ' VALUES (1,now(),'+aNumCheck+','+aKassaHW+','+aTrans+','+aPLU+','+aPrice+','+aCount+','+aSumm+','''+aPDF417+''','''+alccode+''','''+inttostr(flNumCheck)+''','''+FormatDateTime('YYYY-MM-DD',now())+''','''+aBarCode+''','''+ansitoutf8(replaceStr(utf8toansi(aName)))+''') ;';
  formStart.DB_Query(Query);
  result:=true;
end;

function TFormSalesBeer.getvolumebc(abc:string):string;

begin
  result:='';

  FormStart.rowbuf:=  FormStart.DB_Next(FormStart.DB_Query('SELECT `AlcVolume` FROM `spproduct` WHERE `AlcCode`="'+abc+'" ;')) ;
  if FormStart.rowbuf<>nil then
    result:=FormStart.rowbuf[0]
   else
    showMessage('Нет данных о товаре, пожалуйста получите сведения из системы ЕГАИС!');

end;

function TFormSalesBeer.controlpdf417(aPDF417:string):boolean;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
begin
  result:=false;
  for ares:=1 to StringGrid1.RowCount-1 do
     if trim(StringGrid1.Cells[8,ares])=aPDF417 then
     begin
       result:=true;
       exit;
     end;

end;

procedure TFormSalesBeer.BitBtn2Click(Sender: TObject);
begin
 {if not printcheck() then
 begin
      showmessage('Ошибка печати чека!');
      lists.free;
      FormShowStatus.Hide;
      exit;
 end; }
 FrReport1.Clear;
 FrReport1.LoadFromFile('report\tovcheck.lrf');
 indCheck:=1;
 frReport1.ShowReport;
//  if (FlgLoadLibFR) then
//   OleFR.PrintCliche();
//  printcheck();
end;

procedure TFormSalesBeer.BitBtn1Click(Sender: TObject);
begin
  //printcheck();

  addPositionEGAIS(nil);
  clearcheck();
end;

procedure TFormSalesBeer.bbBlockScreenClick(Sender: TObject);
begin
 if formunlockscreen.ShowModal = 1377 then ;

end;

procedure TFormSalesBeer.bbViplataClick(Sender: TObject);
begin
  CashOutcome();
end;

procedure TFormSalesBeer.bbVnestiClick(Sender: TObject);
begin
  CashIncome();
end;

procedure TFormSalesBeer.BitBtn3Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn3.ClientOrigin;
//  r.Top:=;
  PopupMenu1.PopUp(r.x,r.y+BitBtn3.Height+1);
  //  if formloginadmin.showmodal=1377 then
//     self.PrintZReport();
end;

procedure TFormSalesBeer.BitBtn4Click(Sender: TObject);
begin
//  if formloginadmin.showmodal=1377 then
//    self.PrintXReport();
 addtrans(formStart.prefixClient,inttostr(flNumCheck),'155','0','1','0','0','','','');
 OleFR.OpenDrawer();
end;

procedure TFormSalesBeer.BitBtn5Click(Sender: TObject);
begin
  if formloginadmin.showmodal=1377 then
    clearcheck();
end;

procedure TFormSalesBeer.BitBtn6Click(Sender: TObject);
begin
 if flOpenDoc then
   begin
     ShowMessage('Документ уже открыть, сменить тип документа невозможно!');
     exit;
   end;
  flCheckSales:=false;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  if flCheckSales then
    stTypeDoc.Caption:='ПРОДАЖА'
  else
    stTypeDoc.Caption:='ВОЗВРАТ';
end;

procedure TFormSalesBeer.BitBtn7Click(Sender: TObject);
var
  ii:integer;
begin
  if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
    curLine:= curLine-1;
    stringgrid1.DeleteRow(flSelRow);
    end;

  if (flSelRow>= stringgrid1.RowCount)  then  begin
   flSelRow:= stringgrid1.RowCount -1;
   curLine:=flSelRow;

   end;
  for ii:=1 to curline do
     stringgrid1.Cells[0,ii]:=inttostr(ii);
  // ========== пересчитываем сумму =======================
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
   stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end;
  flAllSumma:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
     flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
  end;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  if flCheckSales then
    stTypeDoc.Caption:='ПРОДАЖА'
   else
    stTypeDoc.Caption:='ВОЗВРАТ';
end;

procedure TFormSalesBeer.BitBtn8Click(Sender: TObject);
var
  ii:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  // === изменим кол-во товара без акцизы
 if flNumber = '' then begin
     showmessage('Введите количество!');
     exit;
  end;
 ii:=pos('.',flNumber);
 if ii<>0 then  begin
      xrecbuf:=formstart.db_query('SELECT * FROM `sprgoods` WHERE `weightgood`=''+'' AND `barcodes`='''+StringGrid1.Cells[6,flSelRow]+''';');
    xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf = nil then
        begin
          showmessage('Этот товар дробить нельзя!');
          flNumber:='';
          stNumber.Caption:='0';
          exit;
        end;
 end;

 if flSelRow<=0 then
   exit;
 if ((StringGrid1.Cells[8,flSelRow] ='') AND (StringGrid1.Cells[10,flSelRow]='0')) then  begin

   end else begin
     if thisBeer(StringGrid1.Cells[10,flSelRow]) then
       else begin
         showmessage('Изменить количество можно только для пива и пивных напитков!');
         flNumber:='';
         exit;

       end;
   end;

 if flselrow>0 then begin
  StringGrid1.Cells[4,flSelRow]:=flNumber;
  StringGrid1.Cells[5,flSelRow] := Floattostr(StrToFloat(StringGrid1.Cells[4,flSelRow]) * StrToFloat(StringGrid1.Cells[3,flSelRow]));
  stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
  stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
  stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
  stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
 end;
 flAllSumma:=0;
 for ii:=1 to StringGrid1.RowCount-1 do begin
    flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
 end;
 stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
 if flCheckSales then
   stTypeDoc.Caption:='ПРОДАЖА'
  else
   stTypeDoc.Caption:='ВОЗВРАТ';
  flNumber:='';
end;

procedure TFormSalesBeer.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if flOpenDoc then
   if flTypeKKM=1 then
    OleFR.CancelCheck () ;
  CloseAction:=caHide;
end;

procedure TFormSalesBeer.FormCreate(Sender: TObject);
{var
  str1:string; }
begin
{  FlgLoadLibFR :=false;
    str1:=FormStart.GetConstant('TypeKKM');
  if str1='' then
      flTypeKKM:=0
    else
      flTypeKKM:=StrToInt(str1);
  SizeStrFr:=48; // -- Количество символов в строке FR
  if not formstart.flkkmenabled then
    exit;
  try
   case flTypeKKM of
    0: OleFR:= CreateOleObject('Addin.DRvFR') ;
    1: OleFR:= CreateOleObject('Addin.FprnM45') ;
    else
      OleFR:= CreateOleObject('Addin.DRvFR')
    end;
    FlgLoadLibFR:=true;
  except
    showmessage('Ошибка драйвера ККМ/АСПД!');
    FlgLoadLibFR:=false;
  end;
  if FormStart.flKKMSberbank then begin
    try
      OleSBR:= CreateOleObject('SBRFSRV.Server');
      FlgLoadLibSB:=true;
    except
      showmessage('Ошибка драйвера Сбербанк!');
      FlgLoadLibSB:=false;
    end;
  end;
  if FlgLoadLibFR then
   begin
     if GetStatusFR(false)=-1 then
       FlgLoadLibFR:=false;
   end;
         }

end;

procedure TFormSalesBeer.FormKeyPress(Sender: TObject; var Key: char);
var
  ii:integer;
  bres:boolean;
begin
  if key in ['0'..'9','.',','] then begin
    if key=',' then
     key:='.';

    flNumber:=flNumber+key;

     key:=#0  ;
  end;
  if key = #8 then begin
    if length(flNumber)>1 then
       flNumber:=copy(flNumber,1,length(flnumber)-1)
     else
       flNumber:='';
  end;
  if key='-' then
   begin
     if (flSelRow< stringgrid1.RowCount)and (flSelRow<>0)  then  begin
       curLine:= curLine-1;
       stringgrid1.DeleteRow(flSelRow);
       end;

     if (flSelRow>= stringgrid1.RowCount)  then  begin
      flSelRow:= stringgrid1.RowCount -1;
      curLine:=flSelRow;

      end;
     for ii:=1 to curline do
        stringgrid1.Cells[0,ii]:=inttostr(ii);
   end;
  if key = '+' then begin
   // ======= считаем что это оплата ====
 //   addPositionEGAIS(nil);


   end;
  if key = #13 then
  begin
    key:=#0;
    if ((Length(flNumber)=13)or((Length(flNumber)=12)or(Length(flNumber)=8)))and(pos('.',flNumber)=0) then
    begin
      // ====считаем что это штрихкод =====
      if (Length(flNumber)=12)and(formStart.GetConstant('AddBarCodeEAN13')='1') then begin
          flNumber:='0'+flNumber;
        end;
      if (Length(flNumber)=13) then begin
        if ((flNumber[1]+flNumber[2]) = flPrefixVes)AND(flPrefixVes<>'') then  // ==== это весовой товар ===
        begin
          addPLUcode(flNumber[3]+flNumber[4]+flNumber[5]+flNumber[6]+flNumber[7],flNumber[8]+flNumber[9]+flNumber[10]+flNumber[11]+flNumber[12]);
        end;
        if ((flNumber[1]+flNumber[2]) = flPrefixCard)and(flPrefixCard<>'') then  // ==== это дисконтная карта ===
        begin
          flIdCard:= '';
          flProcentCard:='';
          flProcentSkid:=0;;
        end;
      end;
      bres:=addBarcode(flNumber);
      flNumber:='';
      stSumma.Caption:='0';
    end else
    begin
      showmessage('Не верный штрихкод:'+flNumber);
      flNumber:='';
      stSumma.Caption:='0';
       // ======= считаем что это оплата ====
   //    addPositionEGAIS(nil);
     //  BitBtn1Click(nil);
    end;
  end;

  if flNumber<>'' then stNumber.Caption:=flNumber
                  else stNumber.Caption:='0';

  // ========== пересчитываем сумму =======================
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
   stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end;
  flAllSumma:=0;
  for ii:=1 to StringGrid1.RowCount-1 do begin
     flAllSumma:=flAllSumma+ StrToFloat(trim(StringGrid1.Cells[5,ii])) ;
  end;
  stSumma.Caption:=format('СУММА: %8.2f',[flallsumma]);
  if flCheckSales then stTypeDoc.Caption:='ПРОДАЖА' else stTypeDoc.Caption:='ВОЗВРАТ';
end;

procedure TFormSalesBeer.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if hi(key) = 0 then begin
  if (char(lo(key)) in ['0'..'9',',','.']) then
    exit;
 end;
 if  (key=117 )and(shift = []) then begin
    BitBtn2Click(nil);
    key:=0;
    exit;
  end;
 if  (key=116 )and(shift = []) then begin
    BitBtn8Click(nil);
    key:=0;
    exit;
  end;
 if  (key=113 )and(shift = []) then begin
    BitBtn6Click(nil);
    key:=0;
    exit;
  end;
 if (key=112 )and(shift = []) then begin
    BitBtn3Click(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
 if (key=119 )and(shift = []) then begin
    BitBtn4Click(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
  if (key=120 )and(shift = []) then begin
    bbVnestiClick(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
   if (key=121 )and(shift = []) then begin
    bbViplataClick(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
 if (key=122 )and(shift = []) then begin
    if formloginadmin.showmodal=1377 then
      clearcheck();
    //showmessage('F1')
    key:=0;
    exit;
  end;
 if (key=107) OR (key=187) then begin
   BitBtn1Click(nil);
    key:=0;
    exit;
 end;
 if (key=123 )and(shift = []) then begin
    bbblockscreenclick(nil);
    //showmessage('F1')
    key:=0;
    exit;
    end;
 //showmessage('key='+inttostr(key));
 key:=0;
end;

procedure TFormSalesBeer.FormResize(Sender: TObject);
begin
  FormSalesBeer.WindowState:=wsMaximized
end;

procedure TFormSalesBeer.FormShow(Sender: TObject);
var
  str1:string;
begin
   str1:=formStart.GetConstant('LastNumCheck');
   if str1='' then
    str1:='0';
  flNumCheck:=strtoint(str1)+1;
  if not formStart.flDemoMode then begin
    str1:=formStart.SaveToServerGET('','');
    if str1='' then
      begin
        showmessage('Нет связи с УТМ!');
        exit;
      end;
  end;
  str1:=FormStart.GetConstant('TypeKKM');
  if str1='' then
      flTypeKKM:=0
    else
      flTypeKKM:=StrToInt(str1);
  GetStatusFR(false);

  if flTypeKKM =1 then
    OleFR.OpenCheck () ;
  clearcheck();
end;

procedure TFormSalesBeer.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
 ParValue:='';
 if ParName='num' then begin
    ParValue:=inttostr(indCheck);
 end;
 if ParName='name' then
     ParValue:=Stringgrid1.Cells[2,indCheck];
if ParName='price' then
     ParValue:=Stringgrid1.Cells[3,indCheck];
if ParName='count' then
     ParValue:=Stringgrid1.Cells[4,indCheck];
 if ParName='summ' then
     ParValue:=Stringgrid1.Cells[5,indCheck];
{ if ParName='date' then
     ParValue:=rowbuf[5];    }

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
 if ParName='numdoc' then
      ParValue:=inttostr(flNumCheck)+' '+FormatDateTime('DD.MM.YYYY',now());
 if ParName='summtitle' then
      ParValue:=SummTitle(flallsumma);
 if ParName='firmname' then
      ParValue:=formstart.FirmFullName;
 if ParName='firmname' then
      ParValue:=formstart.FirmFullName;
 if ParName='innkpp' then
      ParValue:=formstart.FirmINN+'/'+formStart.firmkpp;
   if ParName='address' then
      ParValue:=formstart.FirmAddress;
end;

procedure TFormSalesBeer.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
   if indCheck>=Stringgrid1.RowCount then
      eof:=true
      else eof:=false;
end;

procedure TFormSalesBeer.frUserDataset1Next(Sender: TObject);
begin
  indCheck:=indCheck+1;
end;

procedure TFormSalesBeer.MenuItem1Click(Sender: TObject);
begin
  CloseDaySB();
end;

procedure TFormSalesBeer.MenuItem2Click(Sender: TObject);
begin
  GetReport();
end;

procedure TFormSalesBeer.MenuItem3Click(Sender: TObject);
begin

end;

procedure TFormSalesBeer.miXReportClick(Sender: TObject);
begin
  if formloginadmin.showmodal=1377 then begin
    addtrans(formStart.prefixClient,inttostr(flNumCheck),'60','0','1','0','0','','','');
    self.PrintXReport();
    GetReport();
    GetStatusFR(true);
  end;
end;

procedure TFormSalesBeer.miZReportClick(Sender: TObject);
begin
  if formloginadmin.showmodal=1377 then begin
    addtrans(formStart.prefixClient,inttostr(flNumCheck),'61','0','1','0','0','','','');
     self.PrintZReport();
  end;
end;

procedure TFormSalesBeer.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efefff, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin


    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[aRow mod 2];
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 2];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);

end;

procedure TFormSalesBeer.StringGrid1Resize(Sender: TObject);
var
   namesize:integer;
   i:integer;
begin
  namesize:=StringGrid1.Width;
  for i:=0 to Stringgrid1.Columns.Count-1 do
   if i<>1 then
    namesize:=namesize - StringGrid1.Columns.Items[i].Width;
  namesize:=namesize-3;
  StringGrid1.Columns.Items[1].Width:=namesize;

end;

procedure TFormSalesBeer.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
   if arow>0 then
     flSelRow:=aRow;
  if flselrow>0 then begin
   stBarcode.Caption:=StringGrid1.Cells[6,flSelRow];
   stPDF417.Caption:=StringGrid1.Cells[2,flSelRow];
   stLitr.Caption:=StringGrid1.Cells[9,flSelRow];
   stAlcValue.Caption:= StringGrid1.Cells[11,flSelRow];
  end else
  begin
   stBarcode.Caption:='';
   stPDF417.Caption:='';
   stLitr.Caption:='';
   stAlcValue.Caption:= '';
  end;
end;

// ========  минимальные функции для ККМ =======================================
function TFormSalesBeer.PrintLineStringAnsi(const aStr: ansiString): integer;
var
  i:byte;
  str1:WideString;
  str2:string;
begin
  str1:=aStr;
  if (FlgLoadLibFR) then
   begin                     //12345678901234567890123456789012345678901234567890
     try
      case fltypeKKM of
       0:begin OleFR.StringForPrinting:= str1;
               OleFR.PrintString();
         end;
       1:begin
         OleFR.Caption:=Str1;
         OleFR.PrintString();
       end;
      end;
     except
       result:=-1;
       exit;
     end;
   end
  else
  result:=0;
end;

procedure TFormSalesBeer.ShowKKMOption;
begin
  // Отображает параметры ККМ
  if FlgLoadLibFR then
     OleFR.ShowProperties();
end;

procedure TFormSalesBeer.PrintZReport;
var
  res:integer;

begin
  // Отчет без гашения ККМ
  if FlgLoadLibFR then begin
     case flTypeKKM of
       0: begin
         OleFR.PrintReportWithoutCleaning();
         res:= OleFR.ECRAdvancedMode;
         if res = 5 then begin
            showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                      ' вставьте новый рулон и нажмите "Ок".' );
            OleFR.Password:=30;
            OleFR.InterruptFullReport();
            res:= OleFR.ECRAdvancedMode;
          end;
         end;
       1:begin
         OleFR.Mode := 2;   // Режим отчетов без гашения
         OleFR.Password := 30;  // Пароль системного администратора
         OleFR.SetMode();
         OleFR.ReportType :=2;
         OleFR.Report();
       end;

     end;
  end;
end;

procedure TFormSalesBeer.PrintXReport;
var
  res:integer;
begin
  // Отчет с гашением ККМ
  if FlgLoadLibFR then
  case flTypeKKM of
    0:begin
      OleFR.PrintReportWithCleaning();
      res:= OleFR.ECRAdvancedMode;
      if res = 5 then begin
         showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                     'вставьте новый рулон и нажмите "Ок".' );
         OleFR.Password:=30;
         OleFR.InterruptFullReport();
         res:= OleFR.ECRAdvancedMode;
       end;

    end;
    1:begin
      OleFR.Mode := 3;   // Режим отчетов без гашения
      OleFR.Password := 30;  // Пароль системного администратора
      OleFR.SetMode();
      OleFR.ReportType :=1;
      OleFR.Report();
    end;

  end;

end;

procedure TFormSalesBeer.PrintBankReport;
begin
  // Отчет По банку
//  if FlgLoadLibSB then
//   CloseDaySB();
//     OleFR.PrintReportWithCleaning();
end;

procedure TFormSalesBeer.PrintInkass;
begin
  // Отчет Инкассация
  if FlgLoadLibFR then
//     OleFR.PrintReportWithCleaning();
end;

procedure TFormSalesBeer.PrintDepReport;
begin
  // Отчет по отделам
  if FlgLoadLibFR then
     OleFR.PrintDepartmentReport();

end;

function TFormSalesBeer.GetStatusFR(Messages: boolean): Integer;
var
  OldstatusFR:integer;
begin
 result:=0;
 if fltypekkm=0 then
  begin
     // ******* обработка состояния ккм **************
     OldStatusFR:=OleFR.ResultCode;
     //OleFR.DeviceEnabled := 1;
     OleFR.Password:=30;
     OleFR.GetECRStatus();
     //showmessage('Статус ККТ:'+inttostr(OleFR.ResultCode));
     if OleFR.ResultCode <> 0 then begin
       case OleFR.ResultCode of
         100:showmessage('Ошибка ФП!');
         113:begin
            showmessage(
            'Ошибка отрезчика!'+#13#10+
            ' Попробуйте выключить аппарат, открыть крышку.'+#13#10+
            ' Удалить бумагу, вернуть нож отрезчика наместо и  включить устройство.'+#13#10+
            'Как просигналит аппарат нажмите кнопку "Ок"');
            result:=GetStatusFR(Messages);
            if result>=0 then
              exit;
         end;
         78: Showmessage('Не закрыта предыдущая смена!');
         116: Showmessage('Ошибка ОЗУ, требуется тех. обнуление.');
         else
           showmessage('Ошибка ККМ:'+inttostr(OleFR.ResultCode));
       end;
       result:=-1;
       exit;
     end;

     result:=OleFR.ECRMode;
     if result in [0,2,3,4] then begin
       if result = 3 then // принудительно закрываем смену.
          PrintXReport();
       result:=0 ;
       exit;
     end;
     result:= OleFR.ECRAdvancedMode;
     if result = 1 then begin
         showmessage('Вставьте бумага в ККМ и нажмите "Ок".' );
         OleFR.Password:=30;
         OleFR.GetECRStatus();
         result:= OleFR.ECRAdvancedMode;
         if result<>0 then
           begin
             result:=-1;
             exit;
           end;
       end;
      if result = 3 then begin
          OleFR.Password:=30;
          OleFR.ContinuePrint ();
          result:= OleFR.ECRAdvancedMode;
          if result<>0 then
            begin
              result:=-1;
              exit;
            end;
        end;
  {    if result = 5 then begin
          showmessage('Во время печати отчета с гашением закончилась бумага,'+#13#10+
                      ' вставьте новый рулон и нажмите "Ок".' );
          OleFR.Password:=30;
          OleFR.InterruptFullReport();
          result:= OleFR.ECRAdvancedMode;
          if result<>0 then
            begin
              result:=-1;
              exit;
            end;
        end;     }
     if result = 8 then begin
       if messages then
        showmessage('Будет отменен предыдущий чек!' );
        OleFR.Password:=30;
        OleFR.CancelCheck();
        result:=-1;
       end;

    // result:=OleFR.GetStatus() ;

  end;
  if fltypekkm=1 then
  begin
   OleFR.DeviceEnabled := 1;
   result:= OleFR.ResultCode ;
  end;

end;

function TFormSalesBeer.GetNumberCheck: Integer;
begin

end;

function TFormSalesBeer.PrintLineGood(aname: String; count: String): integer;
var
  sz1:integer;
  str0,
  str1:ansistring;
  str2:ansiString;
  SpaceStr1:ansiString;
begin
  str0:='';
  str1:=Utf8ToAnsi(aname);
  if length(str1)> (SizeStrFr-12) then begin
   str0:=copy(str1,1,SizeStrFr-5);
   str1:=copy(str1,SizeStrFr-4,SizeStrFr-12);
  end;


  str2:=Utf8ToAnsi(count);
  SpaceStr1:='';
  for sz1:=(Length(str1)+Length(str2)) to SizeStrFr do
    SpaceStr1:=SpaceStr1+'.';

  if FlgLoadLibFR then
   begin
    if str0<>'' then
    PrintLineStringAnsi(str0);
    PrintLineStringAnsi(str1+SpaceStr1+str2);
    PrintLineStringAnsi(' ');
   end;
  result:=0;
end;

function TFormSalesBeer.PrintLineString(const aStr: String): integer;
begin
  result:=PrintLineStringAnsi(Utf8ToAnsi(astr));
end;

function TFormSalesBeer.StrCenter(const aStr: String): String;
begin

end;

function TFormSalesBeer.OrderSale(aOperBank:boolean):integer;
var
  resFR:integer;
  NumberCheck,
  ii:INTEGER;
  i:integer;
  curDep:integer;
  summdep:real;
  summall:real;
  depSumm:array[0..15] of real;
  IndTr:Integer;
  strw:widestring;
  strw1:widestring;
begin
  strw1:='ПРОДАЖА';
  // -- Здесь проверить наличные с суммой чека!!!
  if flAllSumma> flInpSumm then
    flInpSumm:=flAllSumma;
  // ---------------------------------------------
  case flTypeKKM of
  0:begin
    OleFR.Password:=30;
    OleFR.GetECRStatus();
    OleFR.RegisterNumber:=148;
    OleFR.GetOperationReg();
    NumberCheck:=OleFR.ContentsOfOperationRegister;
    ItogSumm:=flAllSumma;
    curDep:=0;
    summall:=0;
    // -- перебираем подразделения --
    curdep:=0;
    result:=-1;

   //  SummRep:=0;
   //   if depSumm[curdep] > 0 then begin
    for ii:=1 to StringGrid1.RowCount-1 do begin
       strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
       OleFR.Password:=30;
       OleFR.Quantity:=formstart.StrToFloat(StringGrid1.Cells[4,ii]);
       OleFR.Price:= formstart.StrToFloat(StringGrid1.Cells[3,ii]);
       OleFR.Department:= 0;
       OleFR.Tax1:=0;
       OleFR.Tax2:=0;
       OleFR.Tax3:=0;
       OleFR.Tax4:=0;
       OleFR.StringForPrinting:=strw;
       OleFR.sale();
       end;
   ii:=1;
       // .... строка чека
  //    end;
    IF  (flAllSumma>0) and FlgLoadLibFR then begin
       OleFR.Password:=30;
       OleFR.Quantity:=1;
       if  aOperBank then begin
        OleFR.Summ1:= 0;
        OleFR.Summ4:= flAllSumma;
       end else
       begin
        OleFR.Summ1:= flAllSumma;
        OleFR.Summ4:= 0;
       end;
       OleFR.Summ2:= 0;
       OleFR.Summ3:= 0;
       //OleFR.Summ4:= 0;
       OleFR.Tax1:=0;
       OleFR.Tax2:=0;
       OleFR.Tax3:=0;
       OleFR.Tax4:=0;
       OleFR.StringForPrinting:=strw1;
       result:=OleFR.CloseCheck();
    end;
    resFR:= OleFR.ResultCode;
    if resFR <> 0 then begin
        case resFR of
        68: begin
             OleFR.Password:=30;
             OleFR.Quantity:=1;
             if  aOperBank then begin
             OleFR.Summ1:= 10000;
             OleFR.Summ4:= flAllSumma;
             end else
             begin
              OleFR.Summ1:= flAllSumma;
              OleFR.Summ4:= 0;
             end;
             OleFR.Summ2:= 0;
             OleFR.Summ3:= 0;
             //OleFR.Summ4:= 0;
             OleFR.Tax1:=0;
             OleFR.Tax2:=0;
             OleFR.Tax3:=0;
             OleFR.Tax4:=0;
             OleFR.StringForPrinting:='';
             result:=OleFR.CloseCheck();
             resFR:= OleFR.ResultCode;
        end;
        116: Showmessage('Ошибка ОЗУ, требуется тех. обнуление.');
        100:showmessage('Ошибка ФП!');
        113:begin
           showmessage(
           'Ошибка отрезчика!');
        end;
       end;
     end;
     OleFR.OpenDrawer();
     // ******* обработка состояния ккм **************
     result:=OleFR.ResultCode;
     //OleFR.DeviceEnabled := 1;

    end;
  1:begin
      OleFR.Mode := 1;
      OleFR.SetMode();
      // ==== строка чека
      for ii:=1 to StringGrid1.RowCount-1 do begin
        strw:=StrToWide(utf8toansi(StringGrid1.Cells[2,ii]));
        OleFR.Name := strw;
        OleFR.Price := formstart.StrToFloat(StringGrid1.Cells[3,ii]);
        OleFR.Quantity := formstart.StrToFloat(StringGrid1.Cells[4,ii]); ;
        OleFR.Department := 0;
        OleFR.Registration() ;
      end;
      //.. строка чека
      OleFR.Summ := flInpSumm;  // Сумма оплаты
      if  aOperBank then
      OleFR.TypeClose := 4
      else
      OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
      OleFR.Payment();
//      Драйвер.Summ = 10.00;  // Сумма оплаты
//      Драйвер.TypeClose = 1;  // Тип оплаты 1
//      Драйвер.Payment();
      OleFR.TypeClose := 0;
      OleFR.CloseCheck() ;
    end;
  end;

  GetStatusFR(true);
  addtrans(formStart.prefixClient,inttostr(flNumCheck),'55','0','1',floattostr(flallsumma),floattostr(flInpSumm),'','','');
  stNumber.Caption:='СДАЧА:'+floattostr(flInpSumm-flallsumma);
end;

function TFormSalesBeer.OrderReturn(aOperBank:boolean): integer;
var
  NumberCheck,
  ii:INTEGER;
  i:integer;
  curDep:integer;
  summdep:real;
  summall:real;
  depSumm:array[0..15] of real;
  IndTr:Integer;
begin
  // -- Здесь проверить наличные с суммой чека!!!

  // ---------------------------------------------
 case flTypeKKM of
 0:begin
  OleFR.Password:=30;
  OleFR.GetECRStatus();
  OleFR.RegisterNumber:=148;
  OleFR.GetOperationReg();
  NumberCheck:=OleFR.ContentsOfOperationRegister;
  ItogSumm:=flAllSumma;
  curDep:=0;
  summall:=0;
  // -- перебираем подразделения --
  curdep:=0;
  ii:=1;
  result:=-1;
 //  SummRep:=0;
 //   if depSumm[curdep] > 0 then begin
     OleFR.Password:=30;
     OleFR.Quantity:=1;
     OleFR.Price:= flAllSumma;
     OleFR.Department:= 0;
     OleFR.Tax1:=0;
     OleFR.Tax2:=0;
     OleFR.Tax3:=0;
     OleFR.Tax4:=0;
     OleFR.StringForPrinting:='';
     OleFR.ReturnSale();
//    end;
  IF  (flAllSumma>0) and FlgLoadLibFR then begin
     OleFR.Password:=30;
     OleFR.Quantity:=1;
     if  aOperBank then begin
     OleFR.Summ1:= 0;
     OleFR.Summ4:= flAllSumma;
     end else
     begin
      OleFR.Summ1:= flAllSumma;
      OleFR.Summ4:= 0;
     end;
     OleFR.Summ2:= 0;
     OleFR.Summ3:= 0;
     //OleFR.Summ4:= 0;
     OleFR.Tax1:=0;
     OleFR.Tax2:=0;
     OleFR.Tax3:=0;
     OleFR.Tax4:=0;
     OleFR.StringForPrinting:='';
     result:=OleFR.CloseCheck();
  end;
  OleFR.OpenDrawer();
  end;
    1:begin
      OleFR.Mode := 1;
      OleFR.SetMode();
      OleFR.Name := WIDESTring('ВОЗВРАТ');
      OleFR.Price := flAllSumma;
      OleFR.Quantity := 1;
      OleFR.Department := 0;
      OleFR.Return() ;
      OleFR.Summ := flAllSumma;  // Сумма оплаты
     if  aOperBank then
     OleFR.TypeClose := 4
     else
     OleFR.TypeClose := 0;  // Тип оплаты «НАЛИЧНЫМИ»
      OleFR.Payment();
//      Драйвер.Summ = 10.00;  // Сумма оплаты
//      Драйвер.TypeClose = 1;  // Тип оплаты 1
//      Драйвер.Payment();
      OleFR.TypeClose := 0;
      OleFR.CloseCheck() ;
    end;
   end;
 addtrans(formStart.prefixClient,inttostr(flNumCheck),'55','0','1',floattostr(flallsumma),floattostr(flInpSumm),'','','');
end;
// ===============================   C<TH<FYR ==================================
function TFormSalesBeer.CloseDaySB():integer;
begin
  if not FlgLoadLibSB then begin
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  // --- Вызываем функцию ----
  if OleSBR.NFun(6000) = 0 then
        result:=PrintSlipSB()
  else
    result:=-1;
end;

function TFormSalesBeer.PrintSlipSB(aCountSlip:integer=1):integer;
//  FlgLoadLibSB
var
  StrSlip:WideString;
  ListStr:TStringList;
  i:integer;
  ind:integer;
  res:integer;
begin
  if not FlgLoadLibSB then begin
   result:=-1;
   exit;
  End;
   result:=0;
  ListStr:= TStringList.Create;

  StrSlip:=OleSBR.GParamString ('Cheque');
  ListStr.Text:=AnsiTOUtf8(StrSlip);
  for ind:=1 to aCountSlip do begin
    for i:=0 to ListStr.Count-1 do begin
        PrintLineString(ListStr.Strings[i]);
        if pos('==========',ListStr.Strings[i])<>0 then begin
          if FlgLoadLibFR then begin
           if flTypeKKM=0 then begin
            OleFR.Password :=30;
            OleFR.StringQuantity:=7;
            OleFR.UseSlipDocument:=false;
            OleFR.UseReceiptRibbon:=true;
            OleFR.UseJournalRibbon:=false;
            OleFR.FeedDocument();
            OleFR.Password :=30;
            OleFR.FeedAfterCut:=true;
            OleFR.CutType:=true;
            OleFR.CutCheck();
            if flTypeKKM = 0 then begin
              res:=OleFR.ResultCode;
              if res <>0 then begin
                FormShowStatus.Hide;
                addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа','ERROR');
                showmessage('Ошибка ККМ "'+OleFR.ResultCodeDescription+'", устраните ее и нажмите "ОК".');
                addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа (ОК):','ERROR');
                FormShowStatus.Show;
              end;
            end;
           end;
          end;
        end;
    end;
    if FlgLoadLibFR then begin
      OleFR.Password :=30;
      OleFR.FeedAfterCut:=true;
      OleFR.CutType:=true;
      OleFR.CutCheck();
      if flTypeKKM = 0 then begin
        res:=OleFR.ResultCode;
        if res <>0 then begin
         FormShowStatus.Hide;
         addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа','ERROR');
         showmessage('Ошибка ККМ "'+OleFR.ResultCodeDescription+'", устраните ее и нажмите "ОК".');
         addtrans(formStart.prefixClient,inttostr(flNumCheck),'999','0','1','0','0','','Ошибка при отрезке слипа (ОК):','ERROR');
         FormShowStatus.Show;
        end;
      end;

    end;

  end;
  result:=0;

  ListStr.Destroy;
end;

function TFormSalesBeer.SalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
begin
  if not FlgLoadLibSB then begin
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  summ := Round(aSumm*100);
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  OleSBR.SParam('Department',aDepart) ;
  if OleSBR.NFun(4000) = 0 then begin
  	result:=PrintSlipSB(formstart.flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'140','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);
  end else result:=-1;

end;


function TFormSalesBeer.CancelSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
  Str1:WideString;
begin
  if not FlgLoadLibSB then begin
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  Str1:=CodeRRN;
  summ := Round(aSumm*100);
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  OleSBR.SParam('Department',aDepart) ;
  OleSBR.SParam('RNN',Str1) ;
  if OleSBR.NFun(4003) = 0 then begin
  	result:=PrintSlipSB(formstart.flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'141','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);

  end else result:=-1;

end;

function TFormSalesBeer.ReturnSalesCardSB( aDepart:integer; aSumm:real;var CodeRRN:string;var CodeAuth:String):integer;
var
  Summ:Int64;
  Str1:WideString;
begin
  if not FlgLoadLibSB then begin
   result:=-1;
   exit;
  End;
  // --- Очищаем все значениЯ переменных ---
  OleSBR.Clear();
  Str1:= CodeRRN;
  summ := Round(aSumm*100);
  OleSBR.SParam('RNN',Str1) ;
  // --- Вызываем функцию ----
  OleSBR.SParam('Amount',Summ) ;
  OleSBR.SParam('Department',aDepart) ;
  if OleSBR.NFun(4002) = 0 then begin
  	result:=PrintSlipSB(formstart.flCountSlip);
  	CodeRRN := OleSBR.GParamString ('RRN');
  	CodeAuth := OleSBR.GParamString ('AuthCode');
        addtrans(formStart.prefixClient,inttostr(flNumCheck),'144','0','1',floattostr(aSumm),floattostr(aSumm),'',CodeRRN,CodeAuth);

  end else result:=-1;

end;

procedure TFormSalesBeer.CashIncome;
var
  ind:integer;
  comment:string;
begin
 if flNumber = '' then
 begin
   showmessage('Не введена сумма!');
   exit;
 end;
 comment:='';
 if formcomment.ShowModal=1377 then
   comment:=formcomment.Memo1.Text;
 if FlgLoadLibFR then
   if flTypeKKM=0 then begin
      OleFR.Password:=30;
      OleFR.Summ1:=strtofloat(flNumber);
      OleFR.CashIncome();
      ind:=OleFR.OpenDocumentNumber;
      addtrans(formStart.prefixClient,inttostr(ind),'50','0','1',flNumber,flNumber,comment,comment,'');
      flNumber:='';
      stNumber.Caption:='0';
      clearcheck();
    end;
end;

procedure TFormSalesBeer.CashOutcome;
var
  ind:integer;
  comment:string;
begin
if flNumber = '' then
 begin
   showmessage('Не введена сумма!');
   exit;
 end;
comment:='';
if formcomment.ShowModal=1377 then
  comment:=formcomment.Memo1.Text;
 if FlgLoadLibFR then
   if flTypeKKM=0 then begin
      OleFR.Password:=30;
      OleFR.Summ1:=strtofloat(flNumber);
      OleFR.CashOutcome();
      ind:=OleFR.OpenDocumentNumber;
      addtrans(formStart.prefixClient,inttostr(ind),'51','0','1',flNumber,flNumber,comment,comment,'');
      flNumber:='';
      stNumber.Caption:='0';
      clearcheck();
    end;

end;

function TFormSalesBeer.summTitle(aSumm: real): string;
var
  st:string;
  n,i:integer;
  c:array[1..4]of integer;
  s:array[1..4,1..3]of string;
  cel1,drob1:string;
begin
 st:=format('%8.0f',[ aSumm]);
 n :=strtoint(st);
 drob1:=format('%2.2f',[ aSumm]);
 drob1:=copy(drob1,2,4);
s[1,1]:='миллиард';
s[1,2]:='миллиарда';
s[1,3]:='миллиардов';
s[2,1]:='миллион';
s[2,2]:='миллиона';
s[2,3]:='миллионов';
s[3,1]:='тысяча';
s[3,2]:='тысячи';
s[3,3]:='тысяч';
s[4,1]:='';
s[4,2]:='';
s[4,3]:='';


st:='';
c[1]:=n div 1000000000;
c[2]:=(n mod 1000000000) div 1000000;
c[3]:=(n mod 1000000) div 1000;
c[4]:=n mod 1000;
for i:=1 to 4 do
if c[i]<>0 then
 begin
  if c[i] div 100<>0 then
  case c[i] div 100 of
  1:st:=st+'сто';
  2:st:=st+'двести';
  3:st:=st+'триста';
  4:st:=st+'четыреста';
  5:st:=st+'пятьсот';
  6:st:=st+'шестьсот';
  7:st:=st+'семьсот';
  8:st:=st+'восемьсот';
  9:st:=st+'девятьсот';
  end;
  if (c[i] mod 100) div 10<>1 then
   begin
    case (c[i] mod 100) div 10 of
    2:st:=st+' двадцать';
    3:st:=st+' тридцать';
    4:st:=st+' сорок';
    5:st:=st+' пятьдесят';
    6:st:=st+' шестьдесят';
    7:st:=st+' семьдесят';
    8:st:=st+' восемьдесят';
    9:st:=st+' девяносто';
    end;
    case c[i] mod 10 of
    1:if i=3 then st:=st+' одна' else st:=st+' один';
    2:if i=3 then st:=st+' две' else st:=st+' два';
    3:st:=st+' три';
    4:st:=st+' четыре';
    5:st:=st+' пять';
    6:st:=st+' шесть';
    7:st:=st+' семь';
    8:st:=st+' восемь';
    9:st:=st+' девять';
    end;
   end
  else
   case (c[i] mod 100) of
   10:st:=st+' десять';
   11:st:=st+' одиннадцать';
   12:st:=st+' двенадцать';
   13:st:=st+' тринадцать';
   14:st:=st+' четырнадцать';
   15:st:=st+' пятндцать';
   16:st:=st+' шестнадцать';
   17:st:=st+' семнадцать';
   18:st:=st+' восемнадцать';
   19:st:=st+' девятнадцать';
   end;
   if (c[i] mod 100>=10) and (c[i] mod 100<=19) then st:=st+' '+s[i,3]+' '
   else
   case c[i] mod 10 of
   1:st:=st+' '+s[i,1]+' ';
   2..4:st:=st+' '+s[i,2]+' ';
   5..9,0:st:=st+' '+s[i,3]+' ';
   end;
 end;

 result:=st+' рублей '+drob1+' коп.';
end;

function TFormSalesBeer.InitDevice: boolean;
var
  str1:string;
begin
  FlgLoadLibFR :=false;
    str1:=FormStart.GetConstant('TypeKKM');
  if str1='' then
      flTypeKKM:=0
    else
      flTypeKKM:=StrToInt(str1);
  SizeStrFr:=48; // -- Количество символов в строке FR
  if not formstart.flkkmenabled then
    exit;
  try
   case flTypeKKM of
    0: OleFR:= CreateOleObject('Addin.DRvFR') ;
    1: OleFR:= CreateOleObject('Addin.FprnM45') ;
    else
      OleFR:= CreateOleObject('Addin.DRvFR')
    end;
    FlgLoadLibFR:=true;
  except
    showmessage('Ошибка драйвера ККМ/АСПД!');
    FlgLoadLibFR:=false;
  end;
  if FormStart.flKKMSberbank then begin
    try
      OleSBR:= CreateOleObject('SBRFSRV.Server');
      FlgLoadLibSB:=true;
    except
      showmessage('Ошибка драйвера Сбербанк!');
      FlgLoadLibSB:=false;
    end;
  end;
  if FlgLoadLibFR then
   begin
     if GetStatusFR(false)=-1 then
       FlgLoadLibFR:=false;
   end;



end;

// =============================================================================
procedure TFormSalesBeer.GetReport();
var
  RStr:TStringList;
begin
 if formStart.flRMKOffline then begin
    // flRMKFileLoad:string;
   rStr:=TStringList.Create;
   if FormStart.flRMKFolderLoad[length(FormStart.flRMKFolderLoad)] <>'\' then
     FormStart.flRMKFolderLoad:=FormStart.flRMKFolderLoad+'\';
   if FileExists(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport)) then begin
        if formStart.GetConstant('AddReportFileZ')='1' then begin
         rStr.LoadFromFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
         if rStr.Strings[0] <> '#' then
           rStr.Clear;

        end
        else
         DeleteFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
   end;

   rStr.add(formStart.SaveShtrihMFile(now(),now()));
   rStr.SaveToFile(utf8toAnsi(FormStart.flRMKFolderLoad+FormStart.flRMKFileReport));
   rStr.free;
   showmessage('Отчет выгружен.');
 end;

end;

end.

