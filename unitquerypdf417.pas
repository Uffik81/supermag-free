unit unitquerypdf417;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TFormQueryPDF417 }

  TFormQueryPDF417 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    edSerial: TEdit;
    edNumber: TEdit;
    EdResult: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormQueryPDF417: TFormQueryPDF417;

implementation
uses unitstart,unitPrintPDF417;
{$R *.lfm}

{ TFormQueryPDF417 }

const
// Список кодов типов ФСМ/АМ
 ArCodeFMS:array[0..125,0..1] of string =
   (('000','---- Выбрать тип марки ------'),
   ('001','ФСМ. Алкогольная продукция свыше 9 до 25%'),
   ('002','ФСМ. Алкогольная продукция свыше 25%. До 0.1 л'),
   ('003','ФСМ. Алкогольная продукция свыше 25%. До 0.25 л'),
   ('004','ФСМ. Алкогольная продукция свыше 25%. До 0.5 л'),
   ('005','ФСМ. Алкогольная продукция свыше 25%. До 0.75 л'),
   ('006','ФСМ. Алкогольная продукция свыше 25%. До 1 л'),
   ('007','ФСМ. Алкогольная продукция свыше 25%. Свыше 1 л'),
   ('008','ФСМ. Вина'),
   ('009','ФСМ. Вина шампанские и игристые'),
   ('010','ФСМ. Вина натуральные'),
   ('020','АМ. Алкогольная продукция свыше 9 до 25%'),
   ('021','АМ. Алкогольная продукция свыше 25%. До 0.1 л'),
   ('022','АМ. Алкогольная продукция свыше 25%. До 0.25 л'),
   ('023','АМ. Алкогольная продукция свыше 25%. До 0.5 л'),
   ('024','АМ. Алкогольная продукция свыше 25%. До 0.75 л'),
   ('025','АМ. Алкогольная продукция свыше 25%. До 1 л'),
   ('026','АМ. Алкогольная продукция свыше 25%. Свыше 1 л'),
   ('027','АМ. Вина'),
   ('028','АМ. Вина шампанские и игристые'),
   ('029','АМ. Вина натуральные'),
   ('031','АМ. Алкогольная продукция до 9 % включительно'),
   ('101','ФСМ. Спиртные напитки до 9 %'),
   ('102','ФСМ. Спиртные напитки свыше 9 до 25 %'),
   ('103','ФСМ. Крепкие спиртные напитки до 0,5 л'),
   ('104','ФСМ. Крепкие спиртные напитки до 0,75 л'),
   ('105','ФСМ. Крепкие спиртные напитки до 1 л'),
   ('106','ФСМ. Крепкие спиртные напитки свыше 1 л'),
   ('107','ФСМ. Водка до 0,5 л'),
   ('108','ФСМ. Водка до 0,75 л'),
   ('109','ФСМ. Водка до 1 л'),
   ('110','ФСМ. Водка свыше 1 л.'),
   ('111','ФСМ. Вина игристые(шампанские) до 0,375 л.'),  // === N32
   ('112','ФСМ. Вина игристые(шампанские) до 0,75 л.'),
   ('113','ФСМ. Вина игристые(шампанские) до 1,5 л.'),
   ('114','ФСМ. Вина игристые(шампанские) свыше 1,5 л.'),
   ('115','ФСМ. Вина виноградные до 0,375 л.'),
   ('116','ФСМ. Вина виноградные до 0,75 л.'),
   ('117','ФСМ. Вина виноградные до 1,5 л.'),
   ('118','ФСМ. Вина виноградные свыше 1,5 л.'),
   ('119','ФСМ. Вина ликерные до 0,375 л.'),
   ('120','ФСМ. Вина ликерные до 0,75 л.'),
   ('121','ФСМ. Вина ликерные до 1,5 л.'),
   ('122','ФСМ. Вина ликерные свыше 1,5 л.'),
   ('123','ФСМ. Вина фруктовые до 0,375 л.'),
   ('124','ФСМ. Вина фруктовые до 0,75 л.'),
   ('125','ФСМ. Вина фруктовые до 1,5 л.'),
   ('126','ФСМ. Вина фруктовые свыше 1,5 л.'),
   ('127','ФСМ. Винные напитки до 0,375 л.'),
   ('128','ФСМ. Винные напитки до 0,75 л.'),
   ('129','ФСМ. Винные напитки до 1,5 л.'),
   ('130','ФСМ. Винные напитки свыше 1,5 л.'),
   ('131','ФСМ. Крепкие спиртные напитки до 0,1 л'),
   ('132','ФСМ. Крепкие спиртные напитки 0,25 л'),
   ('133','ФСМ. Водка до 0,1 л'),
   ('134','ФСМ. Водка 0,25 л'),
   ('135','ФСМ. Водка 0,375 л'),
   ('136','ФСМ. Водка 0,5 л'),
   ('137','ФСМ. Винные напитки (без этилового спирта) до 0,375 л.'),
   ('138','ФСМ. Винные напитки (без этилового спирта) до 0,75 л.'),
   ('139','ФСМ. Винные напитки (без этилового спирта) до 1,5 л.'),
   ('140','ФСМ. Винные напитки (без этилового спирта) свыше 1,5 л.'),
   ('141','ФСМ. Винные напитки (с этиловым спиртом) до 0,375 л.'),
   ('142','ФСМ. Винные напитки (с этиловым спиртом) до 0,75 л.'),
   ('143','ФСМ. Винные напитки (с этиловым спиртом) до 1,5 л.'),
   ('144','ФСМ. Винные напитки (с этиловым спиртом) свыше 1,5 л.'),
   ('145','ФСМ. Коньяк. До 0,1 л'),
   ('146','ФСМ. Коньяк. 0,25 л'),
   ('147','ФСМ. Коньяк. До 0,5 л'),
   ('148','ФСМ. Коньяк. До 0,75 л'),
   ('149','ФСМ. Коньяк. До 1 л.'),
   ('150','ФСМ. Коньяк. Свыше 1 л'),
   ('151','ФСМ. Коньяк (особый). До 0,1 л'),
   ('152','ФСМ. Коньяк (особый). 0,25 л'),
   ('153','ФСМ. Коньяк (особый). До 0,5 л'),
   ('154','ФСМ. Коньяк (особый). До 0,75 л'),
   ('155','ФСМ. Коньяк (особый). До 1 л'),
   ('156','ФСМ. Коньяк (особый). Свыше 1 л'),
   ('157','ФСМ. Вина виноградные (особые). До 1 л.'),
   ('158','ФСМ. Вина виноградные (особые). Свыше 1 л.'),
   ('159','ФСМ. Вина ликерные (особые). До 1 л.'),
   ('160','ФСМ. Вина ликерные (особые). Свыше 1 л.'),
   ('161','ФСМ. Вина игристые (особые). До 0,375 л.'),
   ('162','ФСМ. Вина игристые (особые). До 1 л.'),
   ('163','ФСМ. Вина игристые (особые). Свыше 1 л.'),
   ('164','ФСМ. Спиртные напитки (особые). До 0,1 л.'),
   ('165','ФСМ. Спиртные напитки (особые). 0,25 л.'),
   ('166','ФСМ. Спиртные напитки (особые). До 0,5 л.'),
   ('167','ФСМ. Спиртные напитки (особые). До 0,75 л.'),
   ('168','ФСМ. Спиртные напитки (особые). До 1 л.'),
   ('169','ФСМ. Спиртные напитки (особые). Свыше 1 л.'),    // 90

   ('200','Reserv'),
   ('202','АМ. Спиртные напитки свыше 9 до 25 %'),
   ('203','АМ. Крепкие спиртные напитки до 0,5 л.'),
   ('204','АМ. Крепкие спиртные напитки до 0,75 л.'),
   ('205','АМ. Крепкие спиртные напитки до 1 л.'),
   ('206','АМ. Крепкие спиртные напитки свыше 1 л.'),
   ('207','АМ. Водка до 0,5 л.'),
   ('208','АМ. Водка до 0,75 л.'),
   ('209','АМ. Водка до 1 л.'),
   ('210','АМ. Водка свыше 1 л.'),
   ('211','АМ. Вина игристые (шампанские) до 0,375 л.'),
   ('212','АМ. Вина игристые (шампанские) до 0,75 л.'),
   ('213','АМ. Вина игристые (шампанские) до 1,5 л.'),
   ('214','АМ. Вина игристые (шампанские) свыше 1,5 л.'),
   ('215','АМ. Вина виноградные до 0,375 л.'),
   ('216','АМ. Вина виноградные до 0,75 л.'),
   ('217','АМ. Вина виноградные до 1,5 л.'),
   ('218','АМ. Вина виноградные свыше 1,5 л.'),
   ('219','АМ. Вина ликерные до 0,375 л.'),
   ('220','АМ. Вина ликерные до 0,75 л.'),
   ('221','АМ. Вина ликерные до 1,5 л.'),
   ('222','АМ. Вина ликерные свыше 1,5 л.'),
   ('223','АМ. Вина фруктовые до 0,375 л.'),
   ('224','АМ. Вина фруктовые до 0,75 л.'),
   ('225','АМ. Вина фруктовые до 1,5 л.'),
   ('226','АМ. Вина фруктовые свыше 1,5 л.'),
   ('227','АМ. Винные напитки до 0,375 л.'),
   ('228','АМ. Винные напитки до 0,75 л.'),
   ('229','АМ. Винные напитки до 1,5 л.'),
   ('230','АМ. Винные напитки свыше 1,5 л.'),
   ('231','АМ. Спиртные напитки до 9 %'),
   ('232','АМ. Крепкие спиртные напитки до 0,1 л.'),
   ('233','АМ. Крепкие спиртные напитки до 0,25 л.'),
   ('234','АМ. Водка до 0,1 л.'),
   ('235','АМ. Водка до 0,25 л.')     // 125

   );

procedure TFormQueryPDF417.BitBtn1Click(Sender: TObject);
var
  str1:string;
  url1:string;
  SLine:tstringlist;
begin
  if ((combobox1.Caption = '')or(edSerial.text=''))or(edNumber.text='') then
  begin
    showmessage('Не все поля заполнены!');
    exit;
  end;
  str1:=ArCodeFMS[combobox1.Items.IndexOf(combobox1.Caption),0];
  SLine:=tstringlist.Create();
  SLine.Clear;
  SLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  SLine.Add('<ns:Documents Version="1.0"');
  SLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.Add('xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.Add('xmlns:bk="http://fsrar.ru/WEGAIS/QueryBarcode"');
  SLine.Add('xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"');
  SLine.Add('> ');
  SLine.Add('<ns:Owner>');
  SLine.Add(' <ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner>');
  SLine.Add(' <ns:Document>');
  SLine.Add('<ns:QueryBarcode>');
  SLine.Add('<bk:QueryNumber>01-'+FormatDateTime('DDMMYYYY',now())+'</bk:QueryNumber>');
  SLine.Add('<bk:Date>'+FormatDateTime('YYYY-MM-DD',now())+'T12:00:00</bk:Date> ');
  SLine.Add('<bk:Marks>');
  SLine.Add('<bk:Mark>');
  SLine.Add('<bk:Identity>1</bk:Identity>');
  SLine.Add('<bk:Type>'+str1+'</bk:Type>');
  SLine.Add('<bk:Rank>'+edSerial.text+'</bk:Rank>');
  SLine.Add('<bk:Number>'+edNumber.text+'</bk:Number>');
  SLine.Add('</bk:Mark>');
  SLine.Add('</bk:Marks>');
  SLine.Add('</ns:QueryBarcode>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>');
  url1:=formstart.SaveToServerPOST('opt/in/QueryBarcode',sline.Text);
  url1:=formstart.getXMLtoURL(url1);
  if url1<>'' then begin
    formStart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`uid`,`docid`,`type`,`status`) VALUES ("01-'+FormatDateTime('DDMMYYYY',now())+'","'+FormatDateTime('YYYY-MM-DD',now())+'","'+url1+'","'+url1+'","QueryPDF417","---");');
    formStart.DB_query('INSERT INTO `doc30` (`numdoc`,`datedoc`,`marktype`,`markserial`,`marknumber`,`pdf417`) VALUES ("01-'+FormatDateTime('DDMMYYYY',now())+'","'+FormatDateTime('YYYY-MM-DD',now())+'","'+str1+'","'+edSerial.text+'","'+edNumber.text+'","");');


  end else
    ShowMessage('Ошибка при отправке данных!');
  //setConstant('uidrestshop',sURL);

  // `type` ="QueryPDF417"

end;

procedure TFormQueryPDF417.BitBtn2Click(Sender: TObject);
begin
  formPrintPDF417.Edit1.Text:=EdResult.Text;
  formPrintPDF417.ShowModal;
end;

procedure TFormQueryPDF417.FormCreate(Sender: TObject);
var
  ind:integer;
begin
  combobox1.Clear;
  for ind:=0 to 125 do
   combobox1.Items.AddText(arCodeFMS[ind,1]);

end;

{
======================= Запрос =============================
<?xml version="1.0"
encoding="UTF
-
8"?>
<ns:Documents
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:bk="http://fsrar.ru/WEGAIS/QueryBarcode"
xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"
Version="1.0">
<ns:Owner>
<ns:FSRAR_ID>010000000577</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:QueryBarcode>
<bk:QueryNumber>01-29062016</bk:QueryNumber>
<bk:Date>2016-06-29T12:00:00</bk:Date>
<bk:Marks>
<bk:Mark>
<bk:Identity>1</bk:Identity>
<bk:Type>022</bk:Type>
<bk:Rank>500</bk:Rank>
<bk:Number>00524087</bk:Number>
</bk:Mark>
</bk:Marks>
</ns:QueryBarcode>
</ns:Document>
</ns:Documents>

 ================================= ответ =========================
<?
xml
version
="1.0"
encoding
="
UTF
-
8"?>
<ns:Documents
xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
xmlns:bk="http://fsrar.ru/WEGAIS/ReplyBarcode"
xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema
-
instance"
xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"
Version="1.0">
<ns:Owner>
<ns:FSRAR_ID>
3463047
</ns:FSRAR_ID>
</ns:Owner>
<ns:Document>
<ns:ReplyBarcode>
<bk:QueryNumber>01</bk:QueryNumber>
<bk:Date>2016-05-06T16:00:00</bk:Date>
<bk:Marks>
(1.25.3)
<bk:Mark>
<bk:Identity>1</bk:Identity>
<bk:Type>103</bk:Type>
<bk:Rank>010</bk:Rank>
<bk:Number>001002003</bk:Number>
<bk:Barcode>22N00002V5ORQU6VW0L830Q60127006018620RJHMTLQQIIG5WIC69SNVVSSPHDMB8LL</bk:Barcode>
</bk:Mark>
<bk:Mark>
<bk:Identity>2</bk:Identity>
<bk:Type>203</bk:Type>
<bk:Rank>001</bk:Rank>
<bk:Number>003002001</bk:Number>
<bk:Barcode>22N00002V5ORQU6VW0L830Q60127006018617EGAL9E0LAWPCI8BJJTZDU183ARA11V9</bk:Barcode>
</bk:Mark>
</bk:Marks>
</ns:ReplyBarcode>
</ns:Document>
</ns:Documents>
}


end.

