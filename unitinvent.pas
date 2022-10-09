unit unitInvent;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Buttons, StdCtrls, mysql50;

type

  { TFormInvent }

  TFormInvent = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListView1: TListView;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    DocNum:String;
    DocDate:String;
    AlcCode:String;
    wordbuffer:String;
    idInvent:Integer;
    flNew:boolean;
    flImport:string;
  end;

var
  FormInvent: TFormInvent;

implementation

{$R *.lfm}
uses lazutf8,DOM, XMLRead, typinfo,unitStart,lclproc, unitselectprod, unitspproduct;
{
Произведено в россии
<?xml version="1.0" encoding="UTF-8"?>
<ns:Documents Version="1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
           xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"
           xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"
           xmlns:iab="http://fsrar.ru/WEGAIS/ActInventoryABInfo"
           xmlns:ainp="http://fsrar.ru/WEGAIS/ActChargeOn"
>
  <!--Кто подает документы-->
  <ns:Owner>
    <!--Идентификатор организации в ФС РАР-->
    <ns:FSRAR_ID>010000000000</ns:FSRAR_ID>
  </ns:Owner>
  <!--Акт инвентаризации продукции-->
  <ns:Document>
    <ns:ActChargeOn>
      <ainp:Header>
        <!--Номер документа-->
        <ainp:Number>1</ainp:Number>
        <!--Дата основания проведения инвентаризации-->
        <ainp:ActDate>2015-11-16</ainp:ActDate>
        <!--Примечание-->
        <ainp:Note>Найдена не учтенная продукция</ainp:Note>
      </ainp:Header>
      <!--Содержимое акта-->
      <ainp:Content>
        <ainp:Position>
          <!--уникальная строка в пределах ТТН для точного указания ошибок в случае наличия таковых -->
          <ainp:Identity>1</ainp:Identity>
          <!--Информация о продукции-->
          <ainp:Product>
            <pref:Type>АП</pref:Type>
            <pref:FullName>Водка особая "Зелёная марка кедровая"</pref:FullName>
            <pref:ShortName />
            <pref:AlcCode>0150325000001194943</pref:AlcCode>
            <pref:Capacity>0.500</pref:Capacity>
            <pref:ProductVCode>200</pref:ProductVCode>
            <pref:Producer>
              <oref:INN>5038002790</oref:INN>
              <oref:KPP>503801001</oref:KPP>
              <oref:ClientRegId>010000000467</oref:ClientRegId>
              <oref:FullName>Закрытое акционерное общество "Ликеро-водочный завод "Топаз"</oref:FullName>
              <oref:ShortName>ЗАО "ЛВЗ "Топаз"</oref:ShortName>
              <oref:address>
                <oref:Country>643</oref:Country>
                <oref:description>РОССИЯ,,МОСКОВСКАЯ ОБЛ,Пушкинский р-н,Пушкино г,,Октябрьская ул,46,(за исключением литера Б17, 1 этаж, № на плане 6, литера Б, 1 этаж, № на плане 8),</oref:description>
              </oref:address>
            </pref:Producer>
          </ainp:Product>
          <!--Количество - шт для фасованной, Дал для нефасованной-->
          <ainp:Quantity>1</ainp:Quantity>
          <ainp:InformAB>
            <ainp:InformABReg>
              <ainp:InformA>
                <iab:Quantity>1</iab:Quantity>
                <iab:BottlingDate>2014-11-18</iab:BottlingDate>
                <iab:TTNNumber>Т-000429</iab:TTNNumber>
                <iab:TTNDate>2015-04-06</iab:TTNDate>
				<!--номер фиксации и дата фиксации из справки А не указывается-->
              </ainp:InformA>
            </ainp:InformABReg>
          </ainp:InformAB>

        <ainp:MarkCodeInfo>
            <ainp:MarkCode>22N00001545RJN0891B37ZP41105005070468KTL2CMG4LPCZRJU3K4XIBTU7BUXXUPJ</ainp:MarkCode>
          </ainp:MarkCodeInfo>

        </ainp:Position>
      </ainp:Content>
    </ns:ActChargeOn>
  </ns:Document>
</ns:Documents>
Импорт
<?xml version="1.0" encoding="UTF-8"?>
<ns:Documents Version="1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
           xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"
           xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"
           xmlns:iab="http://fsrar.ru/WEGAIS/ActInventoryABInfo"
           xmlns:ainp="http://fsrar.ru/WEGAIS/ActChargeOn"
>
  <!--Кто подает документы-->
  <ns:Owner>
    <!--Идентификатор организации в ФС РАР-->
    <ns:FSRAR_ID>010000000237</ns:FSRAR_ID>
  </ns:Owner>
  <!--Акт инвентаризации продукции-->
  <ns:Document>
    <ns:ActChargeOn>
      <ainp:Header>
        <!--Номер документа-->
        <ainp:Number>12</ainp:Number>
        <!--Дата основания проведения инвентаризации-->
        <ainp:ActDate>2015-11-12</ainp:ActDate>
        <!--Примечание-->
        <ainp:Note>Найдена не учтенная продукция</ainp:Note>
      </ainp:Header>
      <!--Содержимое акта-->
      <ainp:Content>
        <ainp:Position>
          <!--уникальная строка в пределах ТТН для точного указания ошибок в случае наличия таковых -->
          <ainp:Identity>1</ainp:Identity>
          <!--Информация о продукции-->
          <ainp:Product>
            <pref:Type>АП</pref:Type>
            <pref:FullName>Вино столовое сухое белое "Каса"</pref:FullName>
            <pref:AlcCode>0177103000001215144</pref:AlcCode>
            <pref:Capacity>1.000</pref:Capacity>
            <pref:ProductVCode>400</pref:ProductVCode>

            <pref:Producer>
              <oref:ClientRegId>050000007241</oref:ClientRegId>
              <oref:FullName>"Х. Гарсия Карьон, С.А."</oref:FullName>
              <oref:ShortName>Гарсия Карьон</oref:ShortName>
              <oref:address>
                <oref:Country>724</oref:Country>
                <oref:description>к/Гуарнисьонеро, с/н (Пол. Инд)13250 Даимьель,Сьюдад Реаль, Испания</oref:description>
              </oref:address>
            </pref:Producer>

			<pref:Importer>
			  <oref:INN>7705444495</oref:INN>
              <oref:KPP>772901001</oref:KPP>
              <oref:ClientRegId>010000003481</oref:ClientRegId>
              <oref:FullName>Общество с ограниченной ответственностью "ЛУДИНГ - ТРЕЙД"</oref:FullName>
              <oref:ShortName>ООО "ЛУДИНГ - ТРЕЙД"</oref:ShortName>
              <oref:address>
                <oref:Country>643</oref:Country>
                <oref:description>121471 Г.МОСКВА, УЛ.РЯБИНОВАЯ, Д.55, СТР.1</oref:description>
              </oref:address>
            </pref:Importer>
			</ainp:Product>

			<ainp:Quantity>1</ainp:Quantity>

            <ainp:InformAB>
            <ainp:InformABReg>
              <ainp:InformA>
             	<iab:Quantity>1</iab:Quantity>
				<!--дата ГТД-->
                <iab:BottlingDate>2015-09-16</iab:BottlingDate>
				<!--номер ГТД-->
                <iab:TTNNumber>1169456/112455</iab:TTNNumber>
				<!--дата ГТД-->
                <iab:TTNDate>2015-09-30</iab:TTNDate>
                </ainp:InformA>
            </ainp:InformABReg>
          </ainp:InformAB>

		  <ainp:MarkCodeInfo>
            <ainp:MarkCode>22N00001545RJN0891B37ZP41105005070468KTL2CMG4LPCZRJU3K4XIBTU7BUXXUPJ</ainp:MarkCode>
          </ainp:MarkCodeInfo>

        </ainp:Position>
      </ainp:Content>
    </ns:ActChargeOn>
  </ns:Document>
</ns:Documents>

// =============нов============
<?xml version="1.0" encoding="UTF-8"?>
<ns:Documents Version="1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"
           xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"
           xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"
           xmlns:iab="http://fsrar.ru/WEGAIS/ActInventoryABInfo"
           xmlns:ainp="http://fsrar.ru/WEGAIS/ActChargeOn"
>
  <!--Кто подает документы-->
  <ns:Owner>
    <!--Идентификатор организации в ФС РАР-->
    <ns:FSRAR_ID>010000000000</ns:FSRAR_ID>
  </ns:Owner>
  <!--Акт инвентаризации продукции-->
  <ns:Document>
    <ns:ActChargeOn>
      <ainp:Header>
        <!--Номер документа-->
        <ainp:Number>1</ainp:Number>
        <!--Дата основания проведения инвентаризации-->
        <ainp:ActDate>2015-11-16</ainp:ActDate>
        <!--Примечание-->
        <ainp:Note>Найдена не учтенная продукция</ainp:Note>
      </ainp:Header>
      <!--Содержимое акта-->
      <ainp:Content>
        <ainp:Position>
          <!--уникальная строка в пределах ТТН для точного указания ошибок в случае наличия таковых -->
          <ainp:Identity>1</ainp:Identity>
          <!--Информация о продукции-->
          <ainp:Product>
            <pref:Type>АП</pref:Type>
            <pref:FullName>Водка особая "Зелёная марка кедровая"</pref:FullName>
            <pref:ShortName />
            <pref:AlcCode>0150325000001194943</pref:AlcCode>
            <pref:Capacity>0.500</pref:Capacity>
            <pref:ProductVCode>200</pref:ProductVCode>
            <pref:Producer>
              <oref:INN>5038002790</oref:INN>
              <oref:KPP>503801001</oref:KPP>
              <oref:ClientRegId>010000000467</oref:ClientRegId>
              <oref:FullName>Закрытое акционерное общество "Ликеро-водочный завод "Топаз"</oref:FullName>
              <oref:ShortName>ЗАО "ЛВЗ "Топаз"</oref:ShortName>
              <oref:address>
                <oref:Country>643</oref:Country>
                <oref:description>РОССИЯ,,МОСКОВСКАЯ ОБЛ,Пушкинский р-н,Пушкино г,,Октябрьская ул,46,(за исключением литера Б17, 1 этаж, № на плане 6, литера Б, 1 этаж, № на плане 8),</oref:description>
              </oref:address>
            </pref:Producer>
          </ainp:Product>
          <!--Количество - шт для фасованной, Дал для нефасованной-->
          <ainp:Quantity>1</ainp:Quantity>
          <ainp:InformAB>
            <ainp:InformABReg>
              <ainp:InformA>
                <iab:Quantity>1</iab:Quantity>
                <iab:BottlingDate>2014-11-18</iab:BottlingDate>
                <iab:TTNNumber>Т-000429</iab:TTNNumber>
                <iab:TTNDate>2015-04-06</iab:TTNDate>
				<!--номер фиксации и дата фиксации из справки А-->
                <iab:EGAISFixNumber>91000000000000</iab:EGAISFixNumber>
                <iab:EGAISFixDate>2015-04-06</iab:EGAISFixDate>
              </ainp:InformA>
            </ainp:InformABReg>
          </ainp:InformAB>

        <ainp:MarkCodeInfo>
            <ainp:MarkCode>22N00001545RJN0891B37ZP41105005070468KTL2CMG4LPCZRJU3K4XIBTU7BUXXUPJ</ainp:MarkCode>
          </ainp:MarkCodeInfo>

        </ainp:Position>
      </ainp:Content>
    </ns:ActChargeOn>
  </ns:Document>
</ns:Documents>
//=========================

}

{ TFormInvent }

function replaceStr1(aStr:string):String;
var
  i:integer;
begin
  result:='';
  for i:=1 to length(aStr) do
    case aStr[i] OF
     '&': result:=result+'&amp;'
     else
        result:=result+aStr[i];
    end;

//  i:=pos('"',astr);
//  while i<>0 do begin
//        aStr[i]:='''';
//        i:=pos('"',astr);
//  end;
//
//  result:=astr;
end;

procedure TFormInvent.BitBtn1Click(Sender: TObject);
var
   ind:integer;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  WBRegID,
  S1:String;
  sLine:TStringList;
  idLine:Integer;
  EgaisName,
  curdate:String;
  uid:String;
  NumDocID:String;
  iKodImporter:String;

  land:string;
  Query:String;
begin
 Query:= 'SELECT  `value`  FROM `const` WHERE (`name`=''ActChargeOn'');';
 if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
 formStart.recbuf := mysql_store_result(formStart.sockMySQL);
 if formStart.recbuf=Nil then begin
    ShowMessage('Error SUDB!');
//    formStart.disconnectDB();
    exit;
 end;
 formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
 if formStart.rowbuf<>nil then begin
    NumDocID:= formStart.rowbuf[0];
    NumDocID:=IntToStr(StrToInt(NumDocID)+1);
    Query:= 'SELECT *  FROM `docjurnale` WHERE (`type`=''ActChargeOn'')AND(`numdoc`=''INV-'+NumDocID+''');';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf<>Nil then
      NumDocID:=IntToStr(StrToInt(NumDocID)+2);

    Query:= 'UPDATE `const` SET  `value`='''+NumDocID+''' WHERE (`name`=''ActChargeOn'');';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
      exit;
    NumDocID:=IntToStr(StrToInt(NumDocID)+2);
    NumDocID:='INV-'+formStart.prefixClient+NumDocID;
 end ;
  sLine:=TStringList.Create;
  curdate:=FormatDateTime('yyyy-mm-dd',now());

  SLine.Add('<?xml version="1.0" encoding="UTF-8"?>  ');
  SLine.Add('<ns:Documents Version="1.0" ');
           SLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
           SLine.Add(' xmlns:ns=  "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
           SLine.Add(' xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"     ');
           SLine.Add(' xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"   ');
           SLine.Add(' xmlns:iab="http://fsrar.ru/WEGAIS/ActInventoryABInfo" ');
           SLine.Add(' xmlns:ainp="http://fsrar.ru/WEGAIS/ActChargeOn"');
  SLine.Add('> ');
  SLine.Add(' <ns:Owner>');
    SLine.Add(' <ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.Add('</ns:Owner> ');
  SLine.Add('<ns:Document>');
   SLine.Add(' <ns:ActChargeOn>');
     SLine.Add(' <ainp:Header>');
       SLine.Add(' <ainp:Number>'+NumDocID+'</ainp:Number>');
       SLine.Add(' <ainp:ActDate>'+curdate+'</ainp:ActDate>');
       SLine.Add(' <ainp:Note>Найдена не учтенная продукция</ainp:Note>');
     SLine.Add(' </ainp:Header>');
      SLine.Add('<ainp:Content>');

     // FOR idLine:=1 to 1 do begin
// ======================

  Query:= 'SELECT `spproduct`.`egaisname`, spproduct.import,spproduct.Capacity,spproduct.AlcVolume, spproduct.ProductVCode,spproducer.inn, spproducer.kpp, spproducer.ClientRegId ,spproducer.FullName,spproducer.country,spproducer.description,spproduct.IClientRegId  FROM `spproduct` ,`spproducer`WHERE '+
                     '(`spproduct`.`AlcCode`='''+AlcCode+''')AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`);';
 idLine:=1;
 if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
 if formStart.recbuf=Nil then begin
    ShowMessage('Error SUDB!');
        exit;
 end;
 formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
 if formStart.rowbuf<>nil then begin
  EgaisName:=formStart.rowbuf[0];
  flImport:= formStart.rowbuf[1];
  SLine.Add(' <ainp:Position>');
  SLine.Add(' <ainp:Identity>'+intToStr(idLine)+'</ainp:Identity>');
  SLine.Add(' <ainp:Product>');
  SLine.Add('   <pref:Identity>'+inttostr(idLine)+'</pref:Identity> ');
  SLine.Add('    <pref:Type>АП</pref:Type>');
  SLine.Add('      <pref:FullName>'+replaceStr1(EgaisName)+'</pref:FullName>  ');
  SLine.Add('      <pref:ShortName>'+UTF8Copy(replaceStr1(EgaisName),1,64)+'</pref:ShortName>     ');
  SLine.Add('      <pref:AlcCode>'+AlcCode+'</pref:AlcCode>                                 ');
  SLine.Add('      <pref:Capacity>'+formStart.rowbuf[2]+'</pref:Capacity>           ');
  SLine.Add('      <pref:AlcVolume>'+formStart.rowbuf[3]+'</pref:AlcVolume>        ');
  SLine.Add('      <pref:ProductVCode>'+formStart.rowbuf[4]+'</pref:ProductVCode>     ');

  SLine.Add('      <pref:Producer > ');
  SLine.Add('       <oref:Identity>1</oref:Identity>');
  if flImport = '0' then  begin
  SLine.Add('       <oref:INN>'+formStart.rowbuf[5]+'</oref:INN>               ');
  SLine.Add('       <oref:KPP>'+formStart.rowbuf[6]+'</oref:KPP>                ');
  end;
  SLine.Add('       <oref:ClientRegId>'+formStart.rowbuf[7]+'</oref:ClientRegId>  ');
  SLine.Add('       <oref:FullName>'+replaceStr1(formStart.rowbuf[8])+'</oref:FullName>  ');
//   SLine.Add('       <oref:ShortName></oref:ShortName> ');
  SLine.Add('       <oref:address >');
  land:=formStart.rowbuf[9];
  if land = '' then land:='463';
  SLine.Add('        <oref:Country>'+land+'</oref:Country>              ');
  SLine.Add('        <oref:description>'+formStart.rowbuf[10]+'</oref:description>  ');
  SLine.Add('       </oref:address>                               ');
  SLine.Add('      </pref:Producer>                               ');
  if flImport = '1' then  begin
    iKodImporter:= formStart.rowbuf[11];
    EgaisName:=formStart.rowbuf[0];
    Query:= 'SELECT inn,kpp,FullName,description  FROM `spproducer` WHERE '+
                         '(`spproducer`.`ClientRegId`='''+iKodImporter+''');';
   if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
   if formStart.recbuf=Nil then
      ShowMessage('Error SUDB!');
   formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    if formStart.rowbuf<>nil then begin
     SLine.Add('      <pref:Importer>');
     SLine.Add('      <oref:INN>'+formStart.rowbuf[0]+'</oref:INN>');
     SLine.Add('      <oref:KPP>'+formStart.rowbuf[1]+'</oref:KPP>');
     SLine.Add('      <oref:ClientRegId>'+iKodImporter+'</oref:ClientRegId>');
     SLine.Add('      <oref:FullName>'+replaceStr1(formStart.rowbuf[2])+'</oref:FullName>');
   //  SLine.Add('      <oref:ShortName>ООО "ЛУДИНГ - ТРЕЙД"</oref:ShortName>');
     SLine.Add('      <oref:address>');
     SLine.Add('      <oref:Country>643</oref:Country>');
     SLine.Add('      <oref:description>'+formStart.rowbuf[3]+'</oref:description>');
     SLine.Add('      </oref:address>');
     SLine.Add('      </pref:Importer>');
   end;
  end;
  SLine.Add('</ainp:Product>');
  if (Edit7.Text='') or (edit7.Text='0') then
    SLine.Add('<ainp:Quantity>'+IntToStr(ListView1.Items.Count)+'</ainp:Quantity>')
  else
    SLine.Add('<ainp:Quantity>'+Edit7.Text+'</ainp:Quantity>');

  SLine.Add('<ainp:InformAB>');
  SLine.Add('  <ainp:InformABReg>');
  SLine.Add('    <ainp:InformA>');
  SLine.Add('      <iab:Quantity>'+Edit6.Text+'</iab:Quantity>');
  SLine.Add('      <iab:BottlingDate>'+Edit3.Text+'</iab:BottlingDate>');
  SLine.Add('      <iab:TTNNumber>'+Edit1.Text+'</iab:TTNNumber>');
  SLine.Add('      <iab:TTNDate>'+Edit2.Text+'</iab:TTNDate>');
  // ==============Добавляем строчки для новой инвентаризации==================
  if Edit4.Text <> '' then begin
    SLine.Add('<iab:EGAISFixNumber>'+edit4.Text+'</iab:EGAISFixNumber>');
    SLine.Add('<iab:EGAISFixDate>'+edit5.text+'</iab:EGAISFixDate>');
  end;
  // ================================
  SLine.Add('    </ainp:InformA>');
  SLine.Add('  </ainp:InformABReg>');
  SLine.Add('</ainp:InformAB>');
  // ========================
    if ListView1.Items.Count>0 then begin
       SLine.Add('<ainp:MarkCodeInfo>');
       for ind:=0 to ListView1.Items.Count-1 do begin
          SLine.Add('    <ainp:MarkCode>'+ListView1.Items.Item[ind].SubItems.Strings[0]+'</ainp:MarkCode>');
       end;
       SLine.Add('  </ainp:MarkCodeInfo>');
    end;
    SLine.Add('</ainp:Position>');
    idLine:=idLine+1;
  end;        // end;
  SLine.Add('</ainp:Content>');
  SLine.Add('</ns:ActChargeOn>');
  SLine.Add('</ns:Document>');
  SLine.Add('</ns:Documents>    ');
  SLine.Text:=formStart.SaveToServerPOST('opt/in/ActChargeOn',sLine.Text);

S:= TStringStream.Create(SLine.text);
Try
  S.Position:=0;
  XML:=Nil;
  ReadXMLFile(XML,S); // XML документ целиком
  // Альтернативно:
//    ReadXMLFragment(AParentNode,S); // Читаем только XML фрагмент.


Finally
  S.Free;
end;
Child :=XML.DocumentElement.FirstChild;
i:=1;
if Assigned(Child) then
begin
  if Child.NodeName = 'url' then begin
    s1:=Child.FirstChild.NodeValue; // Child.Attributes.GetNamedItem('replyId').NodeValue;
    curdate:=FormatDateTime('yyyy-mm-dd',now());
    if flNew then begin
      Query:='INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`,`comment`,`Summa`) VALUES ('''+s1+''','''+s1+''','''+NumDocID+''','''+curdate+''',''ActChargeOn'',''+--'','''+UTF8Copy(replaceStr(EgaisName),1,50)+''','''+inttostr(ListView1.Items.Count)+''');';
     if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
        ShowMessage('Инвентаризация отправлена!');
     if  ListView1.Items.Count>0 then
       for ind:=0 to ListView1.Items.Count-1 do begin
 //   SLine.Add('    <ainp:MarkCode>'+ListView1.Items.Item[ind].SubItems.Strings[0]+'</ainp:MarkCode>');

         Query:='INSERT INTO `doc23` (`docid`, `numdoc`, `datedoc`, `alccode`, `markplomb`, `forma`, `formb`, `numfix`, `datefix`, `import`, `crdate`,`count`) VALUES'+
                 ' ('''+s1+''', '''+NumDocID+''',NOW(), '''+AlcCode+''', '''+ListView1.Items.Item[ind].SubItems.Strings[0]+''', '''', '''', '''+edit4.text+''', '''+edit5.text+''', ''0'', '''+Edit3.Text+''',''1'');';
         formStart.DB_query(Query) ;
         end
              else begin
          Query:='INSERT INTO `doc23` (`docid`, `numdoc`, `datedoc`, `alccode`, `markplomb`, `forma`, `formb`, `numfix`, `datefix`, `import`, `crdate`,`count`) VALUES'+
                 ' ('''+s1+''', '''+NumDocID+''',NOW(), '''+AlcCode+''', '''', '''', '''', '''+edit4.text+''', '''+edit5.text+''', ''0'', '''+Edit3.Text+''','''+Edit7.Text+''');';
         formStart.DB_query(Query) ;
       end;
       end;
    end;
  end else
  begin
    ShowMessage(Child.FirstChild.NodeValue);
    s1:=NumDocID;
    if flNew then begin
      Query:='INSERT INTO `docjurnale` (`uid`,`docid`,`numdoc`,`dateDoc`,`type`,`status`,`comment`,`Summa`) VALUES ('''+s1+''','''+s1+''','''+NumDocID+''','''+curdate+''',''ActChargeOn'',''+--'','''+UTF8Copy(replaceStr(EgaisName),1,50)+''',''1'');';
     if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
       ShowMessage('Инвентаризация отправлена!');
     if  ListView1.Items.Count>0 then
       for ind:=0 to ListView1.Items.Count-1 do begin
         Query:='INSERT INTO `doc23` (`docid`, `numdoc`, `datedoc`, `alccode`, `markplomb`, `forma`, `formb`, `numfix`, `datefix`, `import`, `crdate`,`count`) VALUES'+
                 ' ('''+s1+''', '''+NumDocID+''',NOW(), '''+AlcCode+''', '''+ListView1.Items.Item[ind].SubItems.Strings[0]+''', '''', '''', '''+edit4.text+''', '''+edit5.text+''', ''0'', '''+Edit3.Text+''','''+inttostr(ListView1.Items.Count)+''');';
         formStart.DB_query(Query) ;
         end
       else begin
          Query:='INSERT INTO `doc23` (`docid`, `numdoc`, `datedoc`, `alccode`, `markplomb`, `forma`, `formb`, `numfix`, `datefix`, `import`, `crdate`,`count`) VALUES'+
                 ' ('''+s1+''', '''+NumDocID+''',NOW(), '''+AlcCode+''', '''', '''', '''', '''+edit4.text+''', '''+edit5.text+''', ''0'', '''+Edit3.Text+''','''+Edit7.Text+''');';
         formStart.DB_query(Query) ;
       end;

     end;
  end;
  SLine.Free;
 // formStart.disconnectDB();
  ShowMessage('Инвентаризация с номером:'+NumDocID);

  close;
end;

procedure TFormInvent.BitBtn3Click(Sender: TObject);
begin

end;

procedure TFormInvent.Button1Click(Sender: TObject);
var
  Query:string;
begin
  if formspproduct.ShowModal=1377 then
  begin
   alccode:=formspproduct.sAlcCode;
   if alccode='' then begin
     ShowMessage('Не найден товар! Следует получить справочник из ЕГАИС, по производителю!');
     exit;
     end;
   //ShowMessage('Code:'+aCodeAlc);
   // ==============

   Query:= 'SELECT `AlcCode`,`name`,`import`  FROM `spproduct` WHERE `AlcCode` LIKE '''+AlcCode+''';';
   formStart.recbuf := FormStart.DB_Query(Query);
   if formStart.recbuf=Nil then
     exit;
   formStart.rowbuf := FormStart.DB_Next(formStart.recbuf);
   if formStart.rowbuf<>nil then begin
       memo1.Lines.Clear;
       AlcCode:=formStart.rowbuf[0];
       memo1.lines.add(UTF8Copy(formStart.rowbuf[1],1,50));
          memo1.lines.add(UTF8Copy(formStart.rowbuf[1],50,
               Length(formStart.rowbuf[1])-50));
          if formStart.rowbuf[2] = '1' then
             StaticText3.caption:='Импорт'
           else
             StaticText3.Caption:='';
      end;

  end;
  StaticText1.Caption:=AlcCode;
  self.ActiveControl:=TWinControl(memo1);
end;

procedure TFormInvent.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  formStart.disconnectDB();
end;

procedure TFormInvent.FormKeyPress(Sender: TObject; var Key: char);
var
  i:DWord;
  ind:integer;
  Query,
  s1:string;
  import:String;
  flAdd:boolean;
  res1:boolean;
  aCodeAlc,apart,asrl:String;
begin
   if ((edit1.Focused or edit2.Focused) or edit3.Focused)AND(key<>#13) then
      exit;
   if ((edit5.Focused or edit4.Focused) or edit3.Focused)AND(key<>#13) then
      exit;
   if ((edit5.Focused or edit6.Focused) or edit7.Focused)AND(key<>#13) then
      exit;
 //  caption:=inttostr(i-lastkeypress);
 if key in ['0'..'9','-',#13,'A'..'Z'] then begin
    if key = #13 then begin
      StaticText3.Caption:='';

      if length(wordbuffer)> 13 then begin
        flAdd:=true;
        if ListView1.items.Count>0 then
        for i:=0 to (ListView1.items.Count-1) do
          if wordbuffer = ListView1.items.Item[i].SubItems.Strings[0] then
           flAdd:=false;
        if flAdd then with ListView1.Items.add  do
             begin
               caption:=IntToStr(Listview1.Items.Count);
               SubItems.add(wordbuffer)
             end;

            res1:=FormStart.DecodeEGAISPlomb(wordbuffer,AlcCode,apart,asrl);
            StaticText1.Caption:=AlcCode;
            if alccode='' then begin
              ShowMessage('Не найден товар! Следует получить справочник из ЕГАИС, по производителю!');
              wordbuffer:='';
              key:=#0;
              exit;
              end;
            //ShowMessage('Code:'+aCodeAlc);
            // ==============

            Query:= 'SELECT `AlcCode`,`name`,`import`  FROM `spproduct` WHERE `AlcCode` LIKE '''+AlcCode+''';';
            if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
             exit;
            formStart.recbuf := mysql_store_result(formStart.sockMySQL);
            if formStart.recbuf=Nil then
              exit;
            formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
            if formStart.rowbuf<>nil then begin
                memo1.Lines.Clear;
                AlcCode:=formStart.rowbuf[0];
                memo1.lines.add(UTF8Copy(formStart.rowbuf[1],1,50));
                   memo1.lines.add(UTF8Copy(formStart.rowbuf[1],50,
                        Length(formStart.rowbuf[1])-50));
                   if formStart.rowbuf[2] = '1' then
                      StaticText3.caption:='Импорт'
                    else
                      StaticText3.Caption:='';
               end;
            //formStart.disconnectDB();
               // ===================
        end
        else
        begin
                // штрихкод  22N00001545RJN0891B37ZP41105005070468KTL2CMG4LPCZRJU3K4XIBTU7BUXXUP

              Query:= 'SELECT `AlcCode`,`name`,`import`  FROM `spproduct` WHERE `listbarcode` LIKE ''%,'+wordbuffer+'%''\;';
              if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
               exit;
              formStart.recbuf := mysql_store_result(formStart.sockMySQL);
              if formStart.recbuf=Nil then
                exit;
              formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
              if formStart.rowbuf<>nil then begin

                   memo1.Lines.Clear;
                   AlcCode:=formStart.rowbuf[0];
                   memo1.lines.add(UTF8Copy(formStart.rowbuf[1],1,50));
                   memo1.lines.add(UTF8Copy(formStart.rowbuf[1],50,
                        Length(formStart.rowbuf[1])-50));
                   if formStart.rowbuf[2] = '1' then
                      StaticText3.caption:='Импорт'
                    else
                      StaticText3.Caption:='';
                  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
                  if formStart.rowbuf<>nil then begin
                    formselectprod.sBarCode:=wordbuffer;
                    if formselectprod.ShowModal = 1377 then begin
                      AlcCode:=formselectprod.sAlcCode;
                      memo1.Lines.Clear;
                      memo1.lines.add(UTF8Copy(formselectprod.sname,1,50));
                      memo1.lines.add(UTF8Copy(formselectprod.sname,50,
                           Length(formselectprod.sname)-50));
                    end
                  end;

                end else
                 showmessage('Не найден товар для ШтрихКода:'+wordbuffer);
                //edit1.Text:=wordbuffer;
        StaticText1.Caption:=AlcCode;
        end;
        wordbuffer:='';
      end else
        wordbuffer:=wordbuffer+key;
      key:=#0;
      self.ActiveControl:=TWinControl(memo1);
    end;


end;

procedure TFormInvent.FormShow(Sender: TObject);
begin
 memo1.lines.text:='';
 Edit1.Clear;
 Edit2.Clear;
 Edit3.Clear;
 edit4.Clear;
 edit5.Clear;
 edit6.Clear;
 ListView1.Items.Clear;
 flNew:=true;
 formStart.ConnectDB();
end;

end.

