
unit unitActWriteOff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, mysql50, LCLType;

const
  DBNameDoc = 'doc23';
  DBNameDocX = 'docx23' ;
  NameTypeDoc = 'ActWriteOff';

type

  { TFormActWriteOff }

  TFormActWriteOff = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListView1: TListView;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure ListView1Edited(Sender: TObject; Item: TListItem;
      var AValue: string);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure ListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    { private declarations }
  public
    { public declarations }
    numdoc,
    datedoc:string;
    flReadOnly:boolean;
    flWBregId:string;
    flVersionType:integer;
    procedure GetActWriteoff();
    procedure add_fixmark_to_listview(fix_mark:string);
  end;

var
  FormActWriteOff: TFormActWriteOff;

implementation

{$R *.lfm}
 uses DOM, XMLRead, typinfo,
  sockets,
  comobj,  variants,
  unitStart,
  unitAddformB,
  unitspproduct,
  unitFilter,
  unitcashfilter,
  unitcommon;

procedure TFormActWriteOff.ComboBox1Change(Sender: TObject);
begin
  if comboBox1.Text = 'Реализация' then begin
     BitBtn5.Visible:= true;
     BitBtn6.Visible:=true;
     ListView1.Column[3].Visible:=true;
  end else begin
     BitBtn6.Visible:=false;
     BitBtn5.Visible:= False;
     ListView1.Column[3].Visible:= False;
  end;
end;

procedure TFormActWriteOff.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  closeaction :=caHide;
  flReadOnly:=false;
end;

procedure TFormActWriteOff.FormCreate(Sender: TObject);
begin
  flreadonly:=false;
  flVersionType:=1;
end;

procedure TFormActWriteOff.FormKeyPress(Sender: TObject; var Key: char);
begin
  //showmessage('Key^'+inttostr(ord(key)));
end;

procedure TFormActWriteOff.FormShow(Sender: TObject);
var
query:string;
begin
  // ==== списание доп значения журнала
  formstart.DB_checkCol('docx23','docid','varchar(48)','');
  formstart.DB_checkCol('docx23','numdoc','varchar(20)','');
  formstart.DB_checkCol('docx23','datedoc','DATE','');
  formstart.DB_checkCol('docx23','status','varchar(1)','');
  formstart.DB_checkCol('docx23','statusname','varchar(64)','');
  formstart.DB_checkCol('docx23','statusname','varchar(512)','');
  formstart.DB_checkCol('docx23','storepoint','varchar(20)','');
  formstart.DB_checkCol('doc23','docid','varchar(48)','');
  formstart.DB_checkCol('doc23','numdoc','varchar(20)','');
  formstart.DB_checkCol('doc23','datedoc','DATE','');
  formstart.DB_checkCol('doc23','alccode','varchar(20)','');
  formstart.DB_checkCol('doc23','markplomb','varchar(200)','');
  formstart.DB_checkCol('doc23','forma','varchar(32)','');
  formstart.DB_checkCol('doc23','formb','varchar(32)','');
  formstart.DB_checkCol('doc23','count','int(10)','');
  //formstart.DB_checkCol('doc23','price','float','');
  formstart.DB_checkCol('doc23','numfix','varchar(20)','');
  formstart.DB_checkCol('doc23','datefix','DATE','');
  formstart.DB_checkCol('doc23','import','varchar(1)','');
  formstart.DB_checkCol('doc23','crdate','DATE','');
  formstart.DB_checkCol('doc23','storepoint','varchar(20)','');
  formstart.DB_Query('ALTER TABLE `doc23` DROP INDEX `docid`;');

  if edit1.text='' then
    listview1.Items.Clear;
  bitbtn1.Enabled:=not flreadonly;
  bitbtn4.Enabled:=not flreadonly;
  bitbtn3.Enabled:=not flreadonly;
  if flreadonly then  begin
     caption:='Списание [только чтение]' ;
     formstart.recbuf:=formstart.DB_query('SELECT `status`,`statusname` FROM `docx23` WHERE `numdoc`="'+Edit1.Text+'" `datedoc`="'+FormatDateTime('YYYY-MM-DD',datetimePicker1.Date)+'";');
     formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
     if formstart.rowbuf<> nil then
       begin
          if formstart.rowbuf[0]<>'' then
          combobox1.Caption:=combobox1.Items.Strings[strtoint(formstart.rowbuf[0])];//trim(formstart.rowbuf[1]);
       end;
  end
   else caption:='Списание';
  if (numdoc<>'') and (datedoc<>'') then
    begin
       caption:='Списание [только чтение]' ;
       query:='SELECT `comment`,`wbregid` FROM `docjurnale` WHERE `numdoc`="'+Edit1.Text+'" AND `datedoc`="'+datedoc+'" AND `type`="ActWriteOff" ;';
       formstart.recbuf:=formstart.DB_query(query);
       formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
       if formstart.rowbuf<> nil then
         begin
            if formstart.rowbuf[0]<>'' then
              memo1.Lines.Text:=formstart.rowbuf[0];
            flWBregId:=formstart.rowbuf[1];
            //combobox1.Caption:=combobox1.Items.Strings[strtoint(formstart.rowbuf[0])];//trim(formstart.rowbuf[1]);
         end;
    end;
  ComboBox1Change(sender);
end;

procedure TFormActWriteOff.FormUTF8KeyPress(Sender: TObject;
  var UTF8Key: TUTF8Char);
begin

end;

procedure TFormActWriteOff.ListView1Edited(Sender: TObject; Item: TListItem;
  var AValue: string);
begin

end;

procedure TFormActWriteOff.ListView1KeyPress(Sender: TObject; var Key: char);
begin
  //showmessage('Rtq^'+inttostr(ord(key)));
end;

procedure TFormActWriteOff.ListView1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=46)AND(ListView1.Selected<>nil) then begin
     ListView1.Items.Delete(ListView1.Selected.Index);
  end;
end;

procedure TFormActWriteOff.BitBtn1Click(Sender: TObject);
type
  rec_1 = record
    form_b:string;
    count_b:integer;
    summsale:real;
  end;

var
  ind:integer;
  lastname:string;
  fullname:string;
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  i:Integer;
  WBRegID,
  S1:String;
  SLine:TStringList;
  Query:String;
  aAction,aDel,aegais:boolean;
  ListFormB:TStringList; // группа справо Б
  ii:integer;
  form_b:string;
  not_find_form_b:boolean;
  FormB:array[0..2000] of rec_1;
  Quantity_prod:string;
  count_form_b:integer;
  iii:integer;
begin
  ListFormB := TStringList.Create;
  count_form_b:=0;
  form_b := '';
  for i:=0 to ListView1.Items.Count-1 do begin
      not_find_form_b := True;
      form_b:= ListView1.Items.Item[i].SubItems.Strings[1];
      for ii:=0 to count_form_b-1 do begin
          if  FormB[ii].form_b =  form_b then begin
            not_find_form_b:=False;
          end;
      end;
      if not_find_form_b then begin
          FormB[count_form_b].form_b := form_b;
          FormB[count_form_b].count_b:=0;
          FormB[count_form_b].summsale:=0;
          for iii:=0 to ListView1.Items.Count-1 do begin
              if ListView1.Items.Item[iii].SubItems.Strings[1] =  form_b then begin
                  FormB[count_form_b].count_b:= FormB[count_form_b].count_b +1;
                  FormB[count_form_b].summsale := FormB[count_form_b].summsale + strToFloat(ListView1.Items.Item[iii].SubItems.Strings[9])
              end;
          end;
          count_form_b:= count_form_b +1;
      end;
  end;

  s1:='';
  if Edit1.Text='' then begin
      showMessage('Укажите номер документа!');
      exit;
  end;
  if formstart.GetStatusDoc( Edit1.Text,FormatDateTime('YYYY-MM-DD',datetimePicker1.Date),'', 'ActWriteOff',aAction,aDel,aegais)  then begin
     flreadonly:=true;
     Query:='DELETE FROM `doc23` WHERE `numdoc`='''+Edit1.Text+''' AND `datedoc`='''+FormatDateTime('yyyy-mm-dd',DateTimePicker1.Date)+''' ;';
     formStart.recbuf:=formStart.DB_query(Query) ;
  end else begin
     Query:='INSERT INTO `docjurnale` (`numdoc`,`dateDoc`,`type`,`status`,`comment`) VALUES ("'+Edit1.Text+'","'+FormatDateTime('YYYY-MM-DD',datetimePicker1.Date)+'","ActWriteOff","---","'+memo1.Text+'");';
     formStart.DB_Query(Query);
     Query:='INSERT INTO `docx23` (`numdoc`,`dateDoc`,`status`,`statusname`) VALUES ("'+Edit1.Text+'","'+FormatDateTime('YYYY-MM-DD',datetimePicker1.Date)+'","'+inttostr(combobox1.Items.IndexOf(combobox1.Caption))+'","'+combobox1.Caption+'");';
     formStart.DB_Query(Query);
  end;
     for i:=0 to ListView1.Items.Count-1 do begin
       Query:='SELECT `count` FROM `doc23` WHERE `numdoc`='''+Edit1.Text+''' AND `datedoc`='''+FormatDateTime('yyyy-mm-dd',DateTimePicker1.Date)+''' AND `alccode`='''+formStart.GetAlcCodeFormB(ListView1.Items.Item[i].SubItems.Strings[1])+''' AND `formb`='''+ListView1.Items.Item[i].SubItems.Strings[1]+''' and `markplomb`='''+ListView1.Items.Item[i].SubItems.Strings[2]+''' ;';
       formStart.recbuf:=formStart.DB_query(Query) ;
       formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
       if formstart.rowbuf <> nil then begin
           Query:='UPDATE `doc23` SET `count`='''+ListView1.Items.Item[i].SubItems.Strings[3]+''' WHERE `numdoc`='''+Edit1.Text+''' AND `datedoc`='''+FormatDateTime('yyyy-mm-dd',DateTimePicker1.Date)+''' AND `alccode`='''+formStart.GetAlcCodeFormB(ListView1.Items.Item[i].SubItems.Strings[1])+''' AND `formb`='''+ListView1.Items.Item[i].SubItems.Strings[1]+'''; ';
           formStart.recbuf:=formStart.DB_query(Query) ;
         end else
         begin
           Query:='INSERT INTO `doc23` ( `numdoc`,'+
                  '`datedoc`,'+
                  '`alccode`,'+
                  '`markplomb`,'+
                  '`forma`,'+
                  '`formb`,'+
                  '`numfix`,'+
                  '`datefix`,'+
                  '`import`,'+
                  '`crdate`,'+
                  '`count`) VALUES'+
                   ' ('''+Edit1.Text+''','+
                   ''''+FormatDateTime('yyyy-mm-dd',DateTimePicker1.Date)+''','+
                   ' '''+ListView1.Items.Item[i].SubItems.Strings[7]+''','+
                   ' '''+ListView1.Items.Item[i].SubItems.Strings[2]+''','+
                   ' '''+ListView1.Items.Item[i].SubItems.Strings[8]+''','+
                   ' '''+ListView1.Items.Item[i].SubItems.Strings[1]+''','+
                   ' '''','+
                   ' '''','+
                   ' ''0'','+
                   ' '''','+
                   ''''+ListView1.Items.Item[i].SubItems.Strings[3]+''');';
           formStart.DB_query(Query) ;
         end;
     end;



  //showmessage('Сохранили в БД');
  // ====== Отправка акта списания ========
  sLine:=TStringList.Create;
  sLine.clear;

  sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
  sLine.Add('<ns:Documents Version="1.0" ');

  {sLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ');
  sLine.Add('xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
  sLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" ');
  sLine.Add(' xmlns:awr="http://fsrar.ru/WEGAIS/ActWriteOff" '); }

  sLine.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ');
  sLine.Add('xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
  sLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2" ');
  sLine.Add(' xmlns:awr="http://fsrar.ru/WEGAIS/ActWriteOff_v3" ');
  sLine.Add(' xmlns:ce="http://fsrar.ru/WEGAIS/CommonV3" ');
  sLine.Add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:ActWriteOff_v3>');
  SLine.add('<awr:Identity>'+Edit1.Text+'</awr:Identity> ');
  SLine.add('<awr:Header>');
  //<!--номер акта--> (1.16.1)
  SLine.add('<awr:ActNumber>'+Edit1.Text+'</awr:ActNumber>');
  //<!--дата акта-->
  SLine.add('<awr:ActDate>'+FormatDateTime('YYYY-MM-DD',DateTimePicker1.Date)+'</awr:ActDate>');
  SLine.add('<awr:TypeWriteOff>'+Combobox1.Caption+'</awr:TypeWriteOff>');
  SLine.add('<awr:Note>'+memo1.Text+'</awr:Note>');
  SLine.add('</awr:Header>');
  // Перечень марок сгруппированных по справкам Б
  SLine.add('<awr:Content>');
  for ii:=0 to count_form_b-1 do begin
     SLine.add('<awr:Position>');
     SLine.add('  <awr:Identity>'+IntToStr(ii+1)+'</awr:Identity>');
     SLine.add('  <awr:SumSale>'+floattostr(FormB[ii].summsale)+'</awr:SumSale>');
     SLine.add('  <awr:Quantity>'+inttostr(FormB[ii].count_b)+'</awr:Quantity>');
     SLine.add('  <awr:InformF1F2>');
     SLine.add('  <awr:InformF2>');
     SLine.add('    <pref:F2RegId>'+FormB[ii].form_b+'</pref:F2RegId>');
     SLine.add('  </awr:InformF2>');
     SLine.add('  </awr:InformF1F2>');

     SLine.add('  <awr:MarkCodeInfo>');
     for i:=0 to listView1.Items.Count-1 do begin
         if listView1.Items.Item[i].SubItems.Strings[1] = FormB[ii].form_b then
             SLine.add('  <ce:amc>'+listView1.Items.Item[i].SubItems.Strings[2]+'</ce:amc>');
     end;
     SLine.add('  </awr:MarkCodeInfo>');
    SLine.add('</awr:Position>');
  end;

  SLine.add('</awr:Content>');

  SLine.add('</ns:ActWriteOff_v3>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  //showmessage('Отправляем в егаис');
  // Тип Списания V1, V2,V3

  SLine.Text:=formStart.SaveToServerPOST('opt/in/ActWriteOff_v3',SLine.Text);

  s1:=formStart.getXMLtoURL( SLine.Text);
  if s1 = '' then begin
    Showmessage('Сообщение при отправке:'+formStart.flErrorEGAIS);
  end else
   begin

     Showmessage('Документ отправлен в ЕГАИС');
     Query:='UPDATE `docjurnale` SET `uid`="'+s1+'", `status`="1--" WHERE `numdoc`="'+Edit1.Text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',datetimePicker1.Date)+'" AND `type`="ActWriteOff";';
     formStart.DB_Query(Query);

   end;

   Query:='UPDATE `docx23` SET `docid`="'+s1+'" WHERE `numdoc`="'+Edit1.Text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',datetimePicker1.Date)+'" AND `type`="ActWriteOff";';
   formStart.DB_Query(Query);

  SLine.Free;

end;

procedure TFormActWriteOff.BitBtn2Click(Sender: TObject);
var
  str,url:string;
  SLine:TStringList;
begin
  sLine:= TStringList.Create;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="1.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:qp="http://fsrar.ru/WEGAIS/RequestRepealAWO"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+formstart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:RequestRepealAWO>');
  SLine.add('<qp:ClientId>'+formstart.EgaisKod+'</qp:ClientId>');
  SLine.add('<qp:RequestNumber>'+numdoc+'</qp:RequestNumber>');
  SLine.add('<qp:RequestDate>'+FormatDateTime('YYYY-MM-DD',now())+'T00:00:00</qp:RequestDate>');
  SLine.add('<qp:AWORegId>'+flWBregId+'</qp:AWORegId>');
  SLine.add('</ns:RequestRepealAWO>');
  SLine.add('</ns:Document>');
  SLine.add('</ns:Documents>');
  str:=formStart.savetoserverpost('opt/in/RequestRepealAWO',Sline.text) ;
  url:=formStart.getXMLtoURL(str);
  showmessage(str);
  Sline.free;

end;

procedure TFormActWriteOff.BitBtn3Click(Sender: TObject);
var
  selAlcCode:string;
begin
    if formspproduct.ShowModal=1377 then begin
        selAlcCode:=formspproduct.sAlcCode;
        if selAlcCode='' then begin
           ShowMessage('Не найден товар! Следует получить справочник из ЕГАИС, по производителю!');
           exit;
        end;
        FormAddFormB.selAlcCode:=selAlcCode;
        if FormAddFormB.ShowModal =1377 then begin
            with listview1.Items.Add do begin
                caption:=InTToStr(ListView1.items.count);
                subitems.Add(FormAddFormB.selTovar);
                subitems.Add(FormAddFormB.selFormB);
                subitems.Add('');
                subitems.Add(FormAddFormB.selCount);
            end;
        end;
    End;
end;

procedure TFormActWriteOff.BitBtn4Click(Sender: TObject);
var
  XML: TXMLDocument;
  Child2, Child1, Child: TDOMNode;
  S : TStringStream;
  ii,i:Integer;
  S1:String;
  fs : TSearchRec;
  dir:string;
  StrCount:String;
  summaDoc:real;
  stopsearch:boolean;
  docNumber,DocDate,ClientKodEgais,ClientINN,ClientKPP,ClientAddress,ClientName:String;
  Query:String;
begin
if OpenDialog1.Execute then begin
 formStart.ConnectDB();
  dir := formStart.pathDir;
 // findfirst(dir + '\*.xml',faAnyFile,fs);
  // ==== получить из файла ====
  XML:=Nil;
  dir:=OpenDialog1.FileName;
  ReadXMLFile(XML,dir); // XML документ целиком
  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do
  begin
      summaDoc:=0;
     if Child.NodeName = 'document' then begin
        DocDate  := Child.Attributes.GetNamedItem('date').NodeValue;
        child1:=Child.FirstChild;
        while Assigned(Child1) do begin
           if Child1.NodeName = 'items' then begin
              Child2:= Child1.FirstChild;
              While Assigned(Child2) do begin
                 if Child2.NodeName = 'item' then begin
                    Query:='SELECT `Quantity` FROM `regrestsproduct` WHERE `InformBRegId`='''+AnsiToUtf8(Child2.Attributes.GetNamedItem('FormB').NodeValue)+''';' ;
                    FormStart.recbuf:=FormStart.DB_query(Query);
                    FormStart.rowbuf:=FormStart.DB_Next(FormStart.recbuf);
                    StrCount:='0';
                    if FormStart.rowbuf<>nil then
                       StrCount:=FormStart.rowbuf[0];
                    with Listview1.Items.Add do begin
                       Caption:= IntToStr(Listview1.Items.Count+1);
                       SubItems.Add(AnsiToUtf8(Child2.Attributes.GetNamedItem('name').NodeValue));
                       SubItems.Add(AnsiToUtf8(Child2.Attributes.GetNamedItem('FormB').NodeValue));

                       SubItems.Add(AnsiToUtf8(Child2.Attributes.GetNamedItem('SubCount').NodeValue));
                       SubItems.Add(StrCount);
                       SubItems.Add(AnsiToUtf8(Child2.Attributes.GetNamedItem('count').NodeValue));

                    end;

                 end;

                 Child2:= Child2.NextSibling;
              end;
           end;
           Child1 := Child1.NextSibling;
        end;

          //====================================

          //====================================
    {      Child2 := Child1.FirstChild;
          i:=1;
         while Assigned(Child2) do
            begin

              Query:='INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`) VALUES'
                   +'("'+DocNumber+'","'+DocDate+'","'+ClientKodEgais+'","'+ClientName+'",'+inttostr(i)+
              ',"'+AnsiToUtf8(Child2.Attributes.GetNamedItem('name').NodeValue)+'","'+Child2.Attributes.GetNamedItem('barcode').NodeValue+'","'+
              Child2.Attributes.GetNamedItem('IdEgais').NodeValue+'",'+Child2.Attributes.GetNamedItem('count').NodeValue+','+
              Child2.Attributes.GetNamedItem('price').NodeValue+',"'+Child2.Attributes.GetNamedItem('import').NodeValue+'");';
              StrPrice:= Child2.Attributes.GetNamedItem('price').NodeValue;
              SummaDoc:=SummaDoc+(StrToFloat(STRPrice)*StrToFloat(Child2.Attributes.GetNamedItem('count').NodeValue));
              if (mysql_query(sockMySQL,PChar(Query)) < 0) then
                exit;
              i:=i+1;
              Child2 := Child2.NextSibling;

           end;

             }
      end;
      Child := Child.NextSibling;
  end;
end;
FormStart.disconnectDB();
end;

procedure TFormActWriteOff.BitBtn5Click(Sender: TObject);
var
  // для запросов

  Query2:string;
  xrowbuf2 : MYSQL_ROW;
  xrecbuf2 : PMYSQL_RES;
  //
  num_check:string;
  fix_mark:string;
  prod:T_product;
  ProductVCode:string;
  prod_price:string;
  StartDate:string;
  EndDate:string;
  //list_checks:TStringList;
begin
    if FormcashFilter.ShowModal = 1377 then begin
        StartDate:= FormatDateTime('YYYY-MM-DD 00:00:00',FormFilter.StartDate);
        EndDate  := FormatDateTime('YYYY-MM-DD 23:59:59',FormFilter.EndDate);
        ProductVCode:= FormcashFilter.ProductVCode;
        memo1.Text:='Розничная реализация продукции, не подлежащая фиксации в ЕГАИС.';
    end else
        exit;
    listview1.Items.Clear;
    // Найдем все не закрытые чеки
    query2:='SELECT `urlegais`,`alccode`,`numcheck`,`datedoc`,`price`, ( SELECT `spproduct`.`productVCode` FROM `spproduct` WHERE `spproduct`.`AlcCode` = `doccash`.`alccode` LIMIT 1 ) AS `productVCode` FROM `doccash` WHERE `typetrans` = "11" AND  `noclosecheck`<>"-" AND `urlegais`<>"" and `datetrans`>= "'+StartDate+'" AND `datetrans`<= "'+EndDate+'" ORDER BY `numcheck` ASC ;';
    xrecbuf2:=formstart.DB_query(Query2);
    xrowbuf2:= formstart.DB_Next(xrecbuf2);
    while xrowbuf2<>nil do begin
        if (ProductVCode = '') or (ProductVCode = xrowbuf2[5]) then begin
          fix_mark:= xrowbuf2[0];
          num_check := xrowbuf2[2];
          prod_price:= xrowbuf2[4];
          if formstart.get_product_to_fix_mark(fix_mark,prod) then
              with listview1.Items.Add do begin
                  caption:=InTToStr(ListView1.items.count);
                  subitems.Add(prod.name_product);
                  subitems.Add(prod.form_f2);
                  subitems.Add(prod.fix_mark);
                  subitems.Add('1');
                  subitems.Add('0');
                  subitems.Add('0');
                  subitems.Add(num_check);
                  subitems.Add(prod.alc_code);
                  subitems.Add(prod.form_f1);
                  subitems.Add(prod_price);
              end;
        end;
        xrowbuf2:= formstart.DB_Next(xrecbuf2);
    end;
    xrecbuf2 :=nil;

end;

procedure TFormActWriteOff.BitBtn6Click(Sender: TObject);
var
    Query2:string;
    i:integer;
begin
    for i:=0 to Listview1.Items.count -1 do begin

        query2:='UPDATE `doccash` SET `noclosecheck`="-" WHERE '+
          ' `typetrans` = "11" '+
          'AND `urlegais`="'+Listview1.Items.item[i].SubItems.Strings[2]+'" '+
          'AND `numcheck`="'+Listview1.Items.item[i].SubItems.Strings[6]+'" ;';
        formstart.DB_query(Query2);

    end;


end;

procedure TFormActWriteOff.GetActWriteoff();
begin

end;

procedure TFormActWriteOff.add_fixmark_to_listview(fix_mark:string);
var
  // для запросов

  Query2:string;
  xrowbuf2 : MYSQL_ROW;
  xrecbuf2 : PMYSQL_RES;
  //
  num_check:string;
  prod:T_product;
  prod_price:string;
  StartDate:string;
  EndDate:string;
  //list_checks:TStringList;
begin


    // Найдем все не закрытые чеки
    query2:='SELECT `urlegais`,`alccode`,`numcheck`,`datedoc`,`price` FROM `doccash` WHERE `typetrans` = "11" AND `urlegais`="'+fix_mark+'";';
    xrecbuf2:=formstart.DB_query(Query2);
    xrowbuf2:= formstart.DB_Next(xrecbuf2);
    while xrowbuf2<>nil do begin

        fix_mark:= xrowbuf2[0];
        num_check := xrowbuf2[2];
        prod_price:= xrowbuf2[4];
        if formstart.get_product_to_fix_mark(fix_mark,prod) then
            with listview1.Items.Add do begin
                caption:=InTToStr(ListView1.items.count);
                subitems.Add(prod.name_product);
                subitems.Add(prod.form_f2);
                subitems.Add(prod.fix_mark);
                subitems.Add('1');
                subitems.Add('0');
                subitems.Add('0');
                subitems.Add(num_check);
                subitems.Add(prod.alc_code);
                subitems.Add(prod.form_f1);
                subitems.Add(prod_price);
            end;
        xrowbuf2:= formstart.DB_Next(xrecbuf2);
    end;
    xrecbuf2 :=nil;


end;

end.

