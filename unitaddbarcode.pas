unit unitaddbarcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls;

type

  { TFormAddBarcode }

  TFormAddBarcode = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    stMessage: TStaticText;
    stBarcode: TStaticText;
    stEgais: TStaticText;
    stOstatok: TStaticText;
    StaticText4: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flAlcCode:String;
    flBuffer:string;
    flBarCode:string;
    flName:string;
    flCurrentPrice:string;
    function AddBarCode(abC:String):boolean;
  end;

var
  FormAddBarcode: TFormAddBarcode;

implementation

{$R *.lfm}

uses unitstart, unitselectproduct;

procedure TFormAddBarcode.FormKeyPress(Sender: TObject; var Key: char);
var
  tflAclCOde:string;
  str1,
  p,s:string;
  intPLU:integer;
  tmpPLU:String;
begin
  if key=#13 then begin

    if (length(flBuffer)=68)or(length(flBuffer)=150) then
     begin
       tflAclCOde:=UPCASE(flAlcCode);
       formstart.DecodeEGAISPlomb(UPCASE(flBuffer),flAlcCode,p,s);
       formstart.recbuf:= formstart.DB_query('SELECT `name`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`spproduct`.`alccode`) AS `barcode`,( SELECT SUM(`Quantity`) FROM `regrestsproduct` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countitem`  FROM `spproduct` WHERE `AlcCode`="'+flAlcCode+'";');
       formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
       if formstart.rowbuf<> nil then begin
         flName:= formstart.rowbuf[0];
         stEGAIS.Caption:='Выбран '+formstart.rowbuf[0]+' для подтверждения нажмите кнопку "Применить"';
         stOstatok.Caption:='Остаток по ЕГАИС:'+formstart.rowbuf[2];
         if flBarCode='' then
            flBarCode:=formstart.rowbuf[1];
         stBarCode.Caption:='Штрихкод:'+flBarCode;
         Edit1.Text:=flCurrentPrice;
         edit1.SelectAll;
         edit1.SetFocus;
       end else
        ShowMessage('Не найден алкогольная продукция с кодом:'+flAlcCode);
       flBuffer:='';
     end
    else begin

      if flAlcCode='' then begin
        stEGAIS.Caption:='Неверный формат отсканируйте еще раз!';
      end else begin
       tmpPLU:=formStart.GetConstant('NumberSKU');
       if (tmpPLU = '' )or (tmpPLU='0') then
           intPLU:=1
         else
           intPLU:=strtoint(tmpPLU)+1;
       tmpPLU:=inttostr( intPLU);
       formStart.recbuf := formStart.DB_query('SELECT `barcodes` FROM `sprgoods` WHERE `barcodes`="'+trim(flbarcode)+'" AND `extcode`="'+flAlcCode+'";');
       if  formStart.DB_Next(formStart.recbuf)<> nil then
       // === сопоставляем товар с баркодом
         formStart.DB_query('UPDATE  `sprgoods` SET `currentprice`="'+trim(edit1.Text)+'",`updating`="+",`alcgoods`="+",`barcodes`="'+flBarCode+'" WHERE `extcode`="'+trim(flAlcCode)+'";')
         else begin
           formStart.recbuf := formStart.DB_query('SELECT `barcodes` FROM `sprgoods` WHERE `barcodes`="'+trim(flbarcode)+'" AND `extcode`="";');
           if  formStart.DB_Next(formStart.recbuf)<> nil then
             // === сопоставляем товар с баркодом
              formStart.DB_query('UPDATE  `sprgoods` SET `currentprice`="'+trim(edit1.Text)+'",`updating`="+",`alcgoods`="+",`extcode`="'+trim(flAlcCode)+'" WHERE `barcodes`="'+flBarCode+'";')
             else begin
              str1:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`plu`)VALUE ('''+trim(flbarcode)+''','''+trim(flAlccode)+''',''+'',''+'','''+trim(flname)+''','''+trim(flname)+''','''+trim(edit1.text)+''','''+tmpPLU+''');';
              formStart.DB_query(str1);
              formStart.SetConstant('NumberSKU',tmpPLU);
             end;
          end;
        modalresult:=1377;
      end;

    end;
    key:=#0;
  end
  else
    flbuffer:=flbuffer+key;

end;

procedure TFormAddBarcode.FormShow(Sender: TObject);
begin
  stEgais.Caption:='';
end;

procedure TFormAddBarcode.BitBtn2Click(Sender: TObject);
begin
  if FormSelectProduct.ShowModal=1377 then begin
    flAlcCode:=FormSelectProduct.selAlcCode;
    formstart.recbuf:= formstart.DB_query('SELECT `name`,(SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`spproduct`.`alccode`) AS `barcode`,( SELECT SUM(`Quantity`) FROM `regrestsproduct` WHERE `AlcCode`=`spproduct`.`AlcCode` GROUP BY `AlcCode`) as `countitem`,( SELECT `Quantity` FROM `doccash` WHERE `AlcCode`=`spproduct`.`AlcCode` AND `datedoc`>="'+FormStart.GetConstant('finupdaterestshop')+'" LIMIT 1) as `countitem`   FROM `spproduct` WHERE `AlcCode`="'+flAlcCode+'";');
    formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
    if formstart.rowbuf<> nil then begin
      flName:= formstart.rowbuf[0];
      stEGAIS.Caption:='Выбран '+formstart.rowbuf[0]+' ';
      stOstatok.Caption:='Остаток по ЕГАИС:'+formstart.rowbuf[2];
      stMessage.Caption:='Откорректируйте цену и подтвердите.';
      if flBarCode='' then
         flBarCode:=formstart.rowbuf[1];
      stBarCode.Caption:='Штрихкод:'+flBarCode;

      Edit1.Text:=flCurrentPrice;
      edit1.SetFocus;
      edit1.SelectAll;
    end;

      flBuffer:='';
  end;
end;

procedure TFormAddBarcode.BitBtn1Click(Sender: TObject);
var
  str1:string;
begin
     if strtofloat(Edit1.Text) = 0 then begin
       showmessage('Цена не должна быть нулевой!' );
       exit;
     end;

     formStart.recbuf := formStart.DB_query('SELECT `barcodes`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+trim(flbarcode)+'";');
     formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
     if  formStart.rowbuf<> nil then begin
     // === сопоставляем товар с баркодом
       if formStart.rowbuf[1] = '' then
          formStart.DB_query('UPDATE  `sprgoods` SET `currentprice`="'+trim(edit1.Text)+'",`updating`="+",`alcgoods`="+",`extcode`="'+trim(flAlcCode)+'" WHERE `barcodes`="'+flBarCode+'" AND `extcode`="";')
        else begin
 //         formStart.DB_query('UPDATE  `sprgoods` SET `currentprice`="'+trim(edit1.Text)+'",`updating`="+",`alcgoods`="+",`barcodes`="'+flBarCode+'" WHERE `extcode`="'+trim(flAlcCode)+'";');
            str1:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+trim(flbarcode)+''','''+trim(flAlccode)+''',''+'',''+'','''+trim(replacestr(flname))+''','''+trim(replacestr(flname))+''','''+trim(edit1.text)+''');';
            formStart.DB_query(str1);

        end;
       end else begin
              str1:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`)VALUE ('''+trim(flbarcode)+''','''+trim(flAlccode)+''',''+'',''+'','''+trim(replacestr(flname))+''','''+trim(replacestr(flname))+''','''+trim(edit1.text)+''');';
              formStart.DB_query(str1);
             end;


     modalresult:=1377;

end;

procedure TFormAddBarcode.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  key1:word;
begin
 if hi(key) = 0 then begin
   if ((char(lo(key)) in ['0'..'9',',','.']))or(key=13) then
     exit;
   end else begin
      key1:= lo(key);
      if (key1<96) and (key1>32) then  begin
//        flBuffer :=flbuffer+char(lo(key1));
        key:=key1;
        exit;
      end;
    end;

 if  (key=113 )and(shift = []) then begin
    BitBtn2Click(nil);
    key:=0;
    exit;
  end;
 if  (key=27 )and(shift = []) then begin
    modalresult:=0;
    key:=0;
    close();
    exit;
  end;

 //showmessage('key='+inttostr(key));
end;

function TFormAddBarcode.AddBarCode(abC:String):boolean;
begin
  result:=false;
  flBuffer:='';
  flAlcCode:='';
  flCurrentPrice:='0.00';
  Edit1.ReadOnly:=false;
  formstart.recbuf:= formstart.DB_query('SELECT `currentprice` FROM `sprgoods` WHERE  `barcodes`="'+aBC+'" LIMIT 1;');
  formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
  if formstart.rowbuf<> nil then begin
    flCurrentPrice:=formstart.rowbuf[0];
    Edit1.ReadOnly:=true;
  end;

  flBarCode:=aBC;
  stBarCode.Caption:='Для штрихкода '+abc+' не найден товар! ';
  stMessage.Caption:='Отсканируйте Акцизную марку.';
  edit1.Text:=flCurrentPrice;
  stEGAIS.Caption:='';
  stOstatok.Caption:='';
  if showmodal = 1377 then
   result:=true;
end;

end.

