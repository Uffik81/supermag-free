{ ****************************************************
  *   ФОРМА Оптовая продажа через ЕГАИС              *

}
unit unitrealttn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, StdCtrls, ExtCtrls, Menus, mysql50;

type

  { TFormRealTTN }

  TFormRealTTN = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    ListView1: TListView;
    ListView2: TListView;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    stNumDoc: TStaticText;
    stClientId: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure ListView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView2KeyPress(Sender: TObject; var Key: char);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private
    { private declarations }
    lastkeypress:DWord;
    wordbuffer:String;
  public
    { public declarations }
    DocNumber:String;
    DocDate:String;
    DocKontr:String;
    flOk:boolean;
    flOkegais:boolean;
    flReadOnly:boolean;
    flEditing:boolean;  // === <sk jnhtlfrnbhjdfy
  end;

var
  FormRealTTN: TFormRealTTN;

implementation

{$R *.lfm}
uses DOM, XMLRead, typinfo, unitStart, LCLIntf, unitSelItem, unitaddformB;
{ TFormRealTTN }

procedure TFormRealTTN.FormKeyPress(Sender: TObject; var Key: char);
var
  i:DWord;
  ind:integer;
  s1:string;
  alccode,
  Query:string;
//  import:String;
  flAdd:boolean;
  res1:boolean;
  aCodeAlc,apart,asrl:String;
begin
  formSelItem.flInv2:=false;
  i:= GetTickCount;
  if (key in['0'..'9'])or (key = #13) then begin
    if key <> #13 then
      wordbuffer:=wordbuffer+key;
    if key=#13 then
        begin
           // ==========================
          if Length(wordbuffer)>13 then begin
            // ==============================
            // ====== Получим товар по коду ====
                res1:=FormStart.DecodeEGAISPlomb(wordbuffer,formSelItem.idproduct,apart,asrl);
                //StaticText1.Caption:=AlcCode;
                if formSelItem.idproduct='' then begin
                  ShowMessage('Не найден товар! Следует получить справочник из ЕГАИС, по производителю!');
                  wordbuffer:='';
                  key:=#0;
                  exit;
                  end;
                Query:= 'SELECT `AlcCode`,`name`,`import`  FROM `spproduct` WHERE `AlcCode` LIKE '''+formSelItem.idproduct+''';';
                formStart.recbuf := formStart.DB_query(Query);
                if formStart.recbuf=Nil then
                  exit;
                formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
                if formStart.rowbuf<>nil then begin
                    //formSelItem.idproduct:=formStart.rowbuf[0];
                    formSelItem.Edit1.Text:= formStart.rowbuf[1];
                    for ind:=0 to FormRealTTN.listview1.Items.Count-1 do  begin
                       s1:=ListView1.Items.Item[ind].SubItems.Strings[5];
                       if pos(formSelItem.idproduct,s1)<>0 then begin
                           formSelItem.edit1.Text:=ListView1.Items.Item[ind].SubItems.Strings[0];
                           formSelItem.numposit:=ind;
                           //idproduct:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[5];
                           formSelItem.Edit4.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                           formSelItem.Edit5.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                         end;

                    end;

                   end;
                  key:=#0;
                  wordbuffer:='';
 //                 formSelItem.Edit1.Focused;
                  formSelItem.ShowModal;

                  exit;
            // ==============================
            end else
                    // штрихкод
           for ind:=0 to listview1.Items.Count-1 do begin
              s1:=ListView1.Items.Item[ind].SubItems.Strings[4];
              if pos(','+wordbuffer+',',s1)>0
                then begin
                  formSelItem.edit1.Text:=ListView1.Items.Item[ind].SubItems.Strings[0];
                  formSelItem.numposit:=ind;
                  formSelItem.idproduct:=ListView1.Items.Item[ind].SubItems.Strings[5];
                  formSelItem.Edit4.Text:=ListView1.Items.Item[ind].SubItems.Strings[6];
                  formSelItem.Edit5.Text:=ListView1.Items.Item[ind].SubItems.Strings[6];
                  formSelItem.import:=ListView1.Items.Item[ind].SubItems.Strings[7];
                  key:=#0;
                  wordbuffer:='';
 //                 formSelItem.Edit1.Focused;
                  formSelItem.ShowModal;

                  exit;
                end;
           end;
           //edit1.Text:=wordbuffer;
           ShowMessage('Не найден ШтрихКод:'+wordbuffer+'.');
           wordbuffer:='';
          end;
          // ===========================

           key:=#0;
  end
  else
  begin


  end;
  lastkeypress:=i;


end;

procedure TFormRealTTN.FormShow(Sender: TObject);
var
  i:integer;
  Query:String;
//  flOk:boolean;
  NameTovar:String;
  alcCodeErr:String;
begin
  flOk:=false;
  flEditing:=false;
  flOkEgais:=false;
  formSelItem.flInv2:=false;
  stNumDoc.Caption:=DocNumber+' от '+docDate;
  if not formStart.ConnectDB() then
    exit;
  Query:='SELECT `ClientRegId`,`ClientName`,`block`,`status`,`ClientAccept` FROM `docjurnale` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")';
  formStart.recbuf:=FormStart.DB_query(Query);
  formStart.RowBuf:=FormStart.DB_Next(formStart.recbuf);
  if formStart.RowBuf<> nil then
  begin
      stClientId.Caption:=formStart.RowBuf[0];
      stNumDoc.Caption:=DocNumber+' от '+docDate+#13#10+formStart.RowBuf[1];
      if formStart.RowBuf[4]='+' then
        flReadOnly:=true;
  end;
  // === подготавливаем документ для работы ===
  ListView1.Items.Clear;
  ListView2.Items.Clear;


  Query:='SELECT numposit,tovar,price,count,ListEAN13,AlcItem,import FROM `doc211` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    while formStart.rowbuf<>nil do begin
         with ListView1.Items.Add do begin
           caption:= formStart.rowbuf[0];
           subitems.Add(formStart.rowbuf[1]);         //0
           subitems.Add(formStart.rowbuf[2]);         //1
           subitems.Add(formStart.rowbuf[3]);         //2
           subitems.Add(FloatToStr(
           StrToFloat(formStart.rowbuf[2])*StrToFloat(formStart.rowbuf[3])));         //3
           subitems.Add(','+formStart.rowbuf[4]+',');         //4
           subitems.Add(formStart.rowbuf[5]);         //5
           subitems.Add(formStart.rowbuf[3]);         //6
           subitems.Add(formStart.rowbuf[6]);         //7
         end;
         formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    End;
  // ===== Проверяем на остатки позиции ====  `Quantity` FROM `regrestsproduct`
  flOK:=true;
  for i:=0 to listview1.Items.Count-1  do begin

    Query:='SELECT SUM(`Quantity`) sumcount FROM `regrestsproduct` WHERE AlcCode="'+listview1.Items.Item[i].SubItems.Strings[5]+'" ;';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    if formStart.rowbuf=nil then begin
         flOK :=false;
         NameTovar:=listview1.Items.Item[i].SubItems.Strings[0];
         alcCodeErr:=listview1.Items.Item[i].SubItems.Strings[5];
        end
    else
    while formStart.rowbuf<>nil do begin
      if formStart.rowbuf[0]<>'' then begin
       if strToFloat(formStart.rowbuf[0])<strToFloat(listview1.Items.Item[i].SubItems.Strings[2]) then begin
         flOK :=false;
         alcCodeErr:=listview1.Items.Item[i].SubItems.Strings[5];
         NameTovar:=listview1.Items.Item[i].SubItems.Strings[0];
       end;
      end
      else begin
        flOK :=false;
        alcCodeErr:=listview1.Items.Item[i].SubItems.Strings[5];
        NameTovar:=listview1.Items.Item[i].SubItems.Strings[0];
        end;
       formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    end;
  end;
  if (not flOK)and (not flReadOnly) then begin
       showMessage('Не достаточно остатка по товару:'+nameTovar+' ['+alcCodeErr+']');
       close;
       exit;
    end;
//  flOK:=true;
  for i:=0 to listview1.Items.Count-1  do begin

    Query:='SELECT `inn`,`kpp`,`fullname` FROM `spproduct`,`spproducer` WHERE (`spproduct`.`AlcCode`="'+listview1.Items.Item[i].SubItems.Strings[5]+'")AND(`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) ;';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    if formStart.rowbuf=nil then begin
       flOK :=false;
       NameTovar:=listview1.Items.Item[i].SubItems.Strings[0];
       alcCodeErr:=listview1.Items.Item[i].SubItems.Strings[5];
       formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    end;
  end;

  if (not flOK)and (not flReadOnly) then begin
     showMessage('Не достаточно сведение по товару:'+nameTovar+' ['+alcCodeErr+']');
     close;
     exit;
  end;

  // ==============

  Query:='SELECT `tovar`,`price`,`valuetov`,`forma`,`formb`,`AlcItem`,`partplomb`,`numplomb`,`crdate` FROM `doc21` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    i:=1;
    while formStart.rowbuf<>nil do begin
    with ListView2.Items.Add do begin
      caption:= IntToStr(i);
      subitems.Add(trim(formStart.rowbuf[0]));         //0
      subitems.Add(trim(formStart.rowbuf[1]));         //1
      subitems.Add(trim(formStart.rowbuf[2]));         //2
      subitems.Add(trim(formStart.rowbuf[3]));         //6
      subitems.Add(trim(formStart.rowbuf[4]));         //7
      subitems.Add(trim(formStart.rowbuf[5]));         //5
      subitems.Add('x');         // флаг - загружен из субд
      subitems.Add(trim(formStart.rowbuf[6]));         //7
      subitems.Add(trim(formStart.rowbuf[7]));         //5
      subitems.Add(trim(formStart.rowbuf[8]));
    end;
    i:=i+1;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   End;
  if not flReadOnly then begin
     Query:='UPDATE `docjurnale` SET block="+" WHERE (`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'") ;'; // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")
     FormStart.DB_Query(Query);
  end;
  // ===== Проверяем на остатки позиции ====
  FormStart.DisconnectDB();
  if flreadOnly then
   caption:='Товарно-транспортная накладная (только просмотр)'
  else
    caption:='Товарно-транспортная накладная ' ;
end;

procedure TFormRealTTN.ListView2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ind:integer;
  i:integer;
begin
  if key = 46 then
    begin
      ind:=ListView2.Selected.Index;

      Listview2.Items.Delete(ind);
      for i:=0 to listview2.Items.Count-1 do
        listview2.items.Item[i].Caption:=inttostr(i+1);
      flEditing:=true;
    end;
end;

procedure TFormRealTTN.ListView2KeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TFormRealTTN.MenuItem1Click(Sender: TObject);
begin
  // Изменить справку б
  if ListView2.Selected<>nil then begin
    FormAddFormB.selAlcCode:=ListView2.Selected.SubItems.Strings[5];
    FormAddFormB.selCount:=ListView2.Selected.SubItems.Strings[2];
    if FormAddFormB.ShowModal =1377 then begin
      ListView2.Selected.SubItems.Strings[3]:= FormAddFormB.selFormA;
      ListView2.Selected.SubItems.Strings[4]:= FormAddFormB.selFormB;
      ListView2.Selected.SubItems.Strings[2]:= FormAddFormB.selCount;
    end;

  end;
end;

procedure TFormRealTTN.MenuItem2Click(Sender: TObject);
var
  ind:integer;
begin
  // === Добавляем позицию ====
  if  (ListView1.Selected<>nil)and(not flreadOnly) then begin
    ind:=ListView1.Selected.Index;
  formSelItem.edit1.Text:=ListView1.Items.Item[ind].SubItems.Strings[0];
  formSelItem.numposit:=ind;
  formSelItem.idproduct:=ListView1.Items.Item[ind].SubItems.Strings[5];
  formSelItem.Edit4.Text:=ListView1.Items.Item[ind].SubItems.Strings[6];
  formSelItem.Edit5.Text:=ListView1.Items.Item[ind].SubItems.Strings[6];
  formSelItem.import:=ListView1.Items.Item[ind].SubItems.Strings[7];
  wordbuffer:='';
//                 formSelItem.Edit1.Focused;
  formSelItem.ShowModal;
  end
end;

procedure TFormRealTTN.MenuItem3Click(Sender: TObject);
begin
  if ListView2.Selected<>nil then
   formStart.SendQueryHistoryFormB(ListView2.Selected.SubItems.Strings[4]);
end;

procedure TFormRealTTN.FormClose(Sender: TObject; var CloseAction: TCloseAction );

var
  res:integer;
  Query:String;
begin
  //FormStart.ConnectDB();
  Query:='UPDATE `docjurnale` SET block="" WHERE (`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'") ;';
  formStart.DB_query(Query);
  if not flReadOnly then begin
  res:=MessageDlg('Сохранить изменения ?',mtWarning,[ mbYes, mbNo],0);
  if 6 = res then
      BitBtn2Click(nil);
  end;
  CloseAction:=caHide;
end;

procedure TFormRealTTN.FormCreate(Sender: TObject);
begin
  //flReadOnly:=false;
end;

procedure TFormRealTTN.BitBtn2Click(Sender: TObject);
var
  ind,
  i:integer;
  mass:array[0..1000] of real;
  s2,s1:String;
  Query:String;
  SummCount:Double;
begin
  if flReadOnly then begin
    ShowMessage('Открыт только для чтения!');
    exit;
  end;
  SummCount:=0;
  for i:=0 to ListView1.Items.Count-1 do begin
      mass[i]:=strtofloat(ListView1.Items.Item[i].SubItems.Strings[2]);
      SummCount:=SummCount+strTOFloat(ListView1.Items.item[i].SubItems.Strings[2]);
  end;
  formStart.ConnectDB();
  flEditing:=true;
  if flEditing then begin
     Query:='DELETE FROM `doc21` WHERE (`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'");';
     mysql_query(formStart.sockMySQL,PChar(Query)) ;

    end;
  for i:=0 to ListView2.Items.Count-1 do
  if (ListView2.Items.item[i].SubItems.Strings[6]<>'x')OR( flEditing) then
   begin
    Query:='INSERT INTO `doc21` (`datedoc`,`numdoc`,`tovar`,`price`,`alcitem`,`valuetov`,`forma`,`formb`,`partplomb`,`numplomb`,`posit`,`crdate`) VALUES '+
       '("'+
       docDate+'","'+
       DocNumber+'","'+
       ListView2.Items.item[i].SubItems.Strings[0]+'","'+
       ListView2.Items.item[i].SubItems.Strings[1]+'","'+
       ListView2.Items.item[i].SubItems.Strings[5]+'","'+
       ListView2.Items.item[i].SubItems.Strings[2]+'","'+
       ListView2.Items.item[i].SubItems.Strings[3]+'","'+
       ListView2.Items.item[i].SubItems.Strings[4]+'","'+
       ListView2.Items.item[i].SubItems.Strings[7]+'","'+
       ListView2.Items.item[i].SubItems.Strings[8]+'","'+
       ListView2.Items.item[i].caption+'","'+
       ListView2.Items.item[i].SubItems.Strings[9]+'") ;';
       formStart.recbuf:= FormStart.DB_Query(Query);

     ListView2.Items.item[i].SubItems.Strings[6]:='x';
     ind:=0;
     // == исправление
     while (ListView1.Items.item[ind].SubItems.Strings[5] <>
        ListView2.Items.item[i].SubItems.Strings[5])
        and((ListView1.Items.Count-1)>ind)
           do  ind:=ind+1;
     if ind >= ListView1.Items.Count then
        flOkegais:=false;
    mass[ind]:=mass[ind] - strTOFloat(ListView2.Items.item[i].SubItems.Strings[2]);
   end
  else begin
    ind:=0;
    s1:=ListView1.Items.item[ind].SubItems.Strings[5];
    s2:=ListView2.Items.item[i].SubItems.Strings[5];
    while (s1 <> s2)and(ListView1.Items.Count>ind) do begin
     s1:=ListView1.Items.item[ind].SubItems.Strings[5];
     s2:=ListView2.Items.item[i].SubItems.Strings[5];
     ind:=ind+1;
    end;
    mass[ind]:=mass[ind] - strTOFloat(ListView2.Items.item[i].SubItems.Strings[2]);
    Query:='UPDATE `doc21` SET `forma`="'+ListView2.Items.item[i].SubItems.Strings[3]+'",`formb`="'+ListView2.Items.item[i].SubItems.Strings[4]+'",`valuetov`="'+ListView2.Items.item[i].SubItems.Strings[2]+'"  WHERE (`datedoc`="'+docDate+'")AND'
          +'(`numdoc`="'+DocNumber+'")AND(`alcitem`="'+ListView2.Items.item[i].SubItems.Strings[5]+'")AND(`numplomb`="'+ListView2.Items.item[i].SubItems.Strings[8]+'");';
    formStart.Db_Query(Query);
    SummCount:=SummCount+strTOFloat(ListView2.Items.item[i].SubItems.Strings[2]);
  end;
// ===== Здесь надо проверить совпадает или нет количество позиций =====
  flOkegais:=true;

  for i:=0 to ListView2.Items.Count-1 do
     summCount := SummCount - StrToFloat(ListView2.Items.item[i].SubItems.Strings[2]);
  if summCount <> 0 then
     flOkegais:=false;

  if flOkegais then begin
    Query:='UPDATE `docjurnale` SET `status`="1--" WHERE (`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'") ;';
    FormStart.DB_query(Query);
  end;
// =====================================================================
  FormStart.DisconnectDB();
  wordbuffer:='';
  flEditing:=false;
end;
// === Проверка справки Б ====
procedure TFormRealTTN.BitBtn4Click(Sender: TObject);
var
  countTov:integer;
//  KodEgaisItem:String;
  MaxNum,MinNum:int64;
  nummark:int64;
  FormA,FormB:String;
  Query,
  s1:string;
  i:integer;
  flFind:boolean;
  ind:Integer;
  fullcount:boolean;
begin
  if FormSTART.ConnectDB() then begin
  for ind:=0 to ListView2.Items.Count-1 do begin
  if ListView2.Items.Item[ind].SubItems.Count<6 then begin
     ListView2.Items.Item[ind].SubItems.add('');
     ListView2.Items.Item[ind].SubItems.add('');

     end;
  nummark:=StrToInt(ListView2.Items.Item[ind].SubItems.Strings[8]);
  formA:='';
  Formb:='';

  // ==== Ищем марку пломб ====

    //KodEgaisItem := formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[5];

    FormA:= ListView2.Items.Item[ind].subitems.Strings[3];
    FormB:=ListView2.Items.Item[ind].subitems.Strings[4];

    Query:='SELECT `Quantity` FROM `regrestsproduct` WHERE InformARegId="'+FormA+'" AND InformBRegId="'+FormB+'" ;';
    formStart.recbuf :=FormStart.DB_query(Query);
    formStart.rowbuf :=FormStart.DB_Next(  formStart.recbuf);
    if formStart.rowbuf = nil then begin
      formB:='';
    end;
     if ((formB='')OR(pos('FA-',formB)<>0)) then begin
   {
   SELECT InformARegId,InformBRegId,Quantity,nummark FROM `regrestsproduct`,`spformfix` WHERE (`regrestsproduct`.`Alccode`='0016112000001738782')AND (`spformfix`.`alcitem`=`regrestsproduct`.`alccode`)and(`spformfix`.`forma`=`regrestsproduct`.`InformARegId`)
   }

       Query:='SELECT InformARegId,InformBRegId,Quantity FROM `regrestsproduct`,`spformfix` WHERE (`InformARegId`="'
       +ListView2.Items.item[ind].subitems.Strings[3]+'")AND (`Quantity`>='+ListView2.Items.item[ind].subitems.Strings[2]+')  ;';
       if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
        exit;
       formStart.recbuf := mysql_store_result(formStart.sockMySQL);
       if formStart.recbuf=Nil then
         exit;
       formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
       flFind:=false;
       maxnum:=0;
       while (formStart.rowbuf<>nil)AND(not flFind)  do  begin
   //      s1:= formStart.rowbuf[3];
   //      if (s1='')or (s1=',') then begin
           MinNum:=StrToInt(formStart.rowbuf[2]);         //3
           if minNum>=maxNum then begin
             maxnum:=MinNum;
             FormA:=formStart.rowbuf[0];         //3
             FormB:=formStart.rowbuf[1];         //4
             flFind:=true;
           end;
   //      end;
         formStart.rowbuf := mysql_fetch_row(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
       end;
    end;
   if ((formA='')OR(pos('FA-',formA)=0))OR((formB='')OR(pos('FB-',formB)=0)) then begin
 {
 SELECT InformARegId,InformBRegId,Quantity,nummark FROM `regrestsproduct`,`spformfix` WHERE (`regrestsproduct`.`Alccode`='0016112000001738782')AND (`spformfix`.`alcitem`=`regrestsproduct`.`alccode`)and(`spformfix`.`forma`=`regrestsproduct`.`InformARegId`)
 }
        Query:='SELECT `forma` FROM `alcformab` WHERE `alcitem`="'
     +ListView2.Items.item[ind].subitems.Strings[5]+'"  GROUP BY `forma`;';

  //    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
  //    exit;
     formStart.recbuf := formStart.DB_query(Query);
     if formStart.recbuf=Nil then
       exit;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
     s1:='';
    while formStart.rowbuf<>nil  do  begin
       s1:= s1+'AND (`InformARegId` NOT LIKE '''+formStart.rowbuf[0]+''') ';
       formStart.rowbuf := mysql_fetch_row(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
     end;
     Query:='SELECT InformARegId,InformBRegId,Quantity FROM `regrestsproduct`,`spformfix` WHERE (`Alccode`="'
     +ListView2.Items.item[ind].subitems.Strings[5]+'")AND (`Quantity`>='+ListView2.Items.item[ind].subitems.Strings[2]+')  ;';
     if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
      exit;
     formStart.recbuf := mysql_store_result(formStart.sockMySQL);
     if formStart.recbuf=Nil then
       exit;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
     flFind:=false;
     maxnum:=0;
     while formStart.rowbuf<>nil  do  begin
 //      s1:= formStart.rowbuf[3];
 //      if (s1='')or (s1=',') then begin
         MinNum:=StrToInt(formStart.rowbuf[2]);         //3
         if minNum>=maxNum then begin
           maxnum:=MinNum;
           FormA:=formStart.rowbuf[0];         //3
           FormB:=formStart.rowbuf[1];         //4
         end;
 //      end;
       formStart.rowbuf := mysql_fetch_row(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
     end;

   end;
   Query:='SELECT InformARegId,InformBRegId,Quantity FROM `regrestsproduct`,`spformfix` WHERE (`Alccode`="'
   +ListView2.Items.item[ind].subitems.Strings[5]+'")AND (`InformBRegId`="'+FormB+'")  ;';
   if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
    exit;
   formStart.recbuf := mysql_store_result(formStart.sockMySQL);
   if formStart.recbuf=Nil then
     exit;
   formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   flFind:=false;
   maxnum:=StrToInt(ListView2.Items.item[ind].subitems.Strings[2]);
   if formStart.rowbuf<>nil  then  begin
     MinNum:=StrToInt(formStart.rowbuf[2]);         //3
     if minNum<maxNum then begin
       with ListView2.Items.Add do begin
         caption:= IntToStr(ListView2.Items.Count);
         subitems.Text:= ListView2.Items.item[ind].SubItems.text;         //0
       end;
       ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[2]:= IntToStr(maxNum-minNum);
       ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[3]:='';
       ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[4]:='';
       ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[6]:='';
       ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[8]:=
          ListView2.Items.Item[ListView2.Items.Count-1].subitems.Strings[8]+'1';
       ListView2.Items.Item[ind].subitems.Strings[2]:=formStart.rowbuf[2];
     end;

   end;
   ListView2.Items.Item[ind].subitems.Strings[3]:=FormA; // сколько пропикано                           //3
   ListView2.Items.Item[ind].subitems.Strings[4]:=FormB; // сколько пропикано                           //4

  end;
  formStart.DisconnectDB();
  end;

end;

procedure TFormRealTTN.BitBtn1Click(Sender: TObject);
begin
  // ==== Сохраним документ =====
  BitBtn2Click(nil);
  // ==== Проведе через ЕГАИС ===
  if flOkegais then
      formStart.GetTTNfromEGAIS(DocNumber,DocDate)
    else
      ShowMessage('Не полностью заполнен документ. Отправить не возможно!');
end;

end.

