unit unitSelItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, mysql50;

type

  { TFormSelItem }

  TFormSelItem = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    { private declarations }
    wordbuffer:String;
    lastkeypress:DWord;
    triggerBC:boolean;
  public
    { public declarations }
    flInv2:boolean;
    idproduct:string;
    numposit:integer;
    import:String;
    KodEgaisItem:String;
  end;

var
  FormSelItem: TFormSelItem;

implementation

{$R *.lfm}
uses LCLIntf,lclproc, Unitrealttn,UnitSTART;
{ TFormSelItem }

procedure TFormSelItem.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormSelItem.BitBtn1Click(Sender: TObject);
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
begin
  self.ActiveControl:=TWinControl(Edit1);
  if ((numposit < 0)or(Edit5.Text=''))or((edit3.Text='')or(edit3.Text='')) then
   exit;
  if StrToFloat(Edit5.Text) = 0 then
   exit;
  if Edit3.text = '' then
     nummark:=0
   else
     nummark:=StrToInt(Edit3.text);
  // ==== проверка формата даты =====
  if (formstart.GetConstant('AlcDateControl')='1')AND((edit6.text<>'')) then  begin
    edit6.text:=trim(edit6.text);
     if length(edit6.text)<>10 then
      begin
         showmessage('Неверный формат даты (0000-00-00)');
         exit;
      end;
     if (edit6.text[5]<>'-' ) and(edit6.text[8]<>'-' ) then
      begin
        showmessage('Неверный формат даты (0000-00-00)');
        exit;
      end;
     Query:='SELECT * FROM `spformfix` WHERE (`AlcItem`="'+idproduct+'") AND (`crdate`="'+edit6.text+'");';
     formStart.recbuf := formStart.DB_Query(Query);
     formStart.rowbuf := formStart.DB_next(formStart.recbuf);
     if formStart.rowbuf=nil then begin
       showmessage('Нет такой даты розлива!');
       exit;
     end;
  end;
  // =============== поиск по форме А =====================
  formA:='';
  Formb:='';
  // ==== Ищем марку пломб ====
  if FormSTART.ConnectDB() then begin
    //KodEgaisItem := formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[5];
    if edit6.text='' then begin // === Не указана дата розлива, ищем по пломбе ====
      Query:='SELECT `minNumMark`,`maxNumMark`,`FormA`,`FormB` FROM `alcformab` WHERE (`AlcItem`="'+idproduct+'") AND (`partmark`="'+edit2.text+'")AND ((`minNumMark`<="'+Edit3.text+'")AND(`maxNumMark`>="'+Edit3.text+'"));';
      formStart.recbuf := formStart.DB_Query(Query);
      formStart.rowbuf := formStart.DB_next(formStart.recbuf);
      while formStart.rowbuf<>nil  do  begin
        MinNum:=StrToInt(formStart.rowbuf[0]);         //3
        maxnum:=StrToInt(formStart.rowbuf[1]);         //4
        if ((nummark>minnum)and(nummark<maxnum)) then begin
          FormA:=formStart.rowbuf[2];         //3
          FormB:=formStart.rowbuf[3];         //4
        end;
        formStart.rowbuf := formStart.DB_next(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
      end;
    end;
    if (FormA='')or(FormB='') then begin
      if edit6.text='' then begin
        showMessage('Немогу найти диапазон марок!');
        exit;
      end;
      Query:='SELECT Quantity,InformARegId,InformBRegId FROM `regrestsproduct`,`spformfix` WHERE (`spformfix`.`AlcItem`='''+idproduct+''') AND (`spformfix`.`crdate`='''+edit6.text+''') AND (`regrestsproduct`.`InformARegId` = `spformfix`.`forma`) GROUP BY `InformBRegId`;';
      formStart.recbuf := formStart.DB_Query(Query);
      formStart.rowbuf := formStart.DB_next(formStart.recbuf);
      maxnum:=0;
      while formStart.rowbuf<>nil  do  begin
        if maxnum < StrToInt(formStart.rowbuf[0]) then
          begin
            FormA:=formStart.rowbuf[1];         //3
            FormB:=formStart.rowbuf[2];         //4
            maxnum:=StrToInt(formStart.rowbuf[0]) ;
          end;
        formStart.rowbuf := formStart.DB_next(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
      end;
    end;
    if (FormA='')or(FormB='') then begin  // ===== выбираем по максимуму =====
      Query:='SELECT `Quantity`,`InformARegId`,`InformBRegId` FROM `regrestsproduct` WHERE (`AlcCode`="'+idproduct+'") ;';
      formStart.recbuf := formStart.DB_Query(Query);
      formStart.rowbuf := formStart.DB_next(formStart.recbuf);
      maxnum:=0;
      while formStart.rowbuf<>nil  do  begin
        if maxnum < StrToInt(formStart.rowbuf[0]) then
          begin
            FormA:=formStart.rowbuf[1];         //3
            FormB:=formStart.rowbuf[2];         //4
            maxnum:=StrToInt(formStart.rowbuf[0]) ;
          end;
        formStart.rowbuf := formStart.DB_next(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
      end;
    end
    else begin  // ==== пробный вариант =====
      Query:='SELECT `Quantity`,`InformARegId`,`InformBRegId` FROM `regrestsproduct` WHERE (`AlcCode`="'+idproduct+'") AND (`InformARegId`="'+FormA+'") ;';
      formStart.recbuf := formStart.DB_Query(Query);
      formStart.rowbuf := formStart.DB_next(formStart.recbuf);
      maxnum:=0;
      while formStart.rowbuf<>nil  do  begin
        if maxnum < StrToInt(formStart.rowbuf[0]) then
          begin
            FormA:=formStart.rowbuf[1];         //3
            FormB:=formStart.rowbuf[2];         //4
            maxnum:=StrToInt(formStart.rowbuf[0]) ;
          end;
        formStart.rowbuf := formStart.DB_next(formStart.recbuf);    // Косяк был здесь - надо всегда перебирать
      end;
    end;


    formStart.DisconnectDB();
   end;
  // ===== END ====================

 //     form1.SQLQuery1.Close;
  flfind:=false;
  // ============= Ищем совпадения ==============
  if  flInv2 then begin

    end
  else begin
    for i:=0 to formREALTTN.ListView2.Items.Count-1 do begin
      if ((formREALTTN.ListView2.Items.item[i].subitems.Strings[3]=formA)
        and(formREALTTN.ListView2.Items.item[i].subitems.Strings[4]=formB))
        AND(formREALTTN.ListView2.Items.item[i].subitems.Strings[5]=
        idproduct)
        then begin
          flFind:=true;
          formREALTTN.ListView2.Items.item[i].subitems.Strings[2]:= IntToStr(
             StrToInt(formREALTTN.ListView2.Items.item[i].subitems.Strings[2])+
             StrToInt(edit5.text));
        end;
    end;

    if not flfind then
    with formREALTTN.ListView2.Items.Add do begin
     caption:= IntToStr(formREALTTN.ListView2.Items.count+1);
     subitems.Add(formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[0]);  //0
     subitems.Add(formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[1]);  //1
     subitems.Add(edit5.text); // сколько пропикано                           //2
     subitems.Add(FormA); // сколько пропикано                           //2
     subitems.Add(FormB); // сколько пропикано                           //2

     subitems.Add(formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[5]);   //5  Код ЕГАИС
     subitems.Add('');  // Новая позиция
     subitems.Add(edit2.text); // Серия пломбы
     subitems.Add(edit3.text); // Номер
     subitems.Add(edit6.text); // Дата розлива
    end;
    if formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[6]<>'' then begin
      CountTov:=StrToInt(formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[6]);
      CountTov:=CountTov-StrToInt(edit5.text);
      formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[6]:=IntToStr(CountTov);
    end;
  end;
  lastkeypress:=GetTickCount;
  triggerbc:=false;
  edit3.Text:='';
//  edit1.Text:='';
  edit2.Text:='';
  edit4.Text:='0';
  Edit5.Text:=IntToStr(CountTov);
  Edit6.Text:='';
//  numposit:=-1;
//  close;

end;

procedure TFormSelItem.Edit3Change(Sender: TObject);
begin

end;

procedure TFormSelItem.Edit6Change(Sender: TObject);

begin

end;

procedure TFormSelItem.FormKeyPress(Sender: TObject; var Key: char);
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
  if ((edit5.Focused or edit3.Focused) or edit2.Focused)AND(key<>#13) then
      exit;
    if ((edit5.Focused or edit3.Focused) or edit6.Focused)AND(key<>#13) then
      exit;
   i:= GetTickCount;
 //  caption:=inttostr(i-lastkeypress);
 if key in ['0'..'9','-',#13,'A'..'Z'] then begin
    if key = #13 then begin
      if length(wordbuffer)> 12 then
          begin
            if (wordbuffer[4] = '-')and(length(wordbuffer)>=15) then begin
              edit2.Text:=wordbuffer[5]+wordbuffer[6]+wordbuffer[7];
              edit3.Text:='';
              // >>> Импорт = '1'
              if import <> '1' then
                  for ind:=8 to 16 do
                     edit3.Text:=edit3.Text+wordbuffer[ind]
                else
                  for ind:=8 to 15 do
                     edit3.Text:=edit3.Text+wordbuffer[ind];
            end
            else begin
                if length(wordbuffer)> 60 then begin
                  // ====== Получим товар по коду ====
                  res1:=FormStart.DecodeEGAISPlomb(wordbuffer,idproduct,apart,asrl);
                  //StaticText1.Caption:=AlcCode;
                  if idproduct='' then begin
                    ShowMessage('Не найден товар! Следует получить справочник из ЕГАИС, по производителю!');
                    wordbuffer:='';
                    key:=#0;
                    exit;
                    end;
                  Query:= 'SELECT `AlcCode`,`name`,`import`  FROM `spproduct` WHERE `AlcCode`='''+idproduct+''';';
                  formStart.recbuf := formStart.DB_query(Query);
                  if formStart.recbuf=Nil then
                    exit;
                  formStart.rowbuf := formStart.DB_next(formStart.recbuf);
                  if formStart.rowbuf<>nil then begin
                      KodEgaisItem:=formStart.rowbuf[0];
                      Edit1.Text:= formStart.rowbuf[1];
                      import:= formStart.rowbuf[2]; // === добавлено 2017-01-12
                      for ind:=0 to FormRealTTN.listview1.Items.Count-1 do  begin
                         s1:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[5];
                         if (pos(KodEgaisItem,s1)<>0)and(FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6]<>'0') then begin
                             edit1.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[0];
                             numposit:=ind;
                             //idproduct:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[5];
                             Edit4.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                             Edit5.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                           end;

                      end;
                     end;
                end
                else
                begin
                  // штрихкод
                  for ind:=0 to FormRealTTN.listview1.Items.Count-1 do  begin
                     s1:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[4];
                     if (pos(','+wordbuffer+',',s1)<>0)and(FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6]<>'0') then begin
                         edit1.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[0];
                         numposit:=ind;
                         idproduct:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[5];
                         Edit4.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                         Edit5.Text:=FormRealTTN.ListView1.Items.Item[ind].SubItems.Strings[6];
                       end;

                  end;
                  //edit1.Text:=wordbuffer;
                end;
              end;
             end;
        wordbuffer:='';
      end else
        wordbuffer:=wordbuffer+key;
      key:=#0;
      self.ActiveControl:=TWinControl(Edit1);
    end;
    StaticText1.Caption:=idproduct;
end;

procedure TFormSelItem.FormShow(Sender: TObject);
begin
  //idproduct := formREALTTN.ListView1.Items.Item[numposit].SubItems.Strings[5];
  StaticText1.Caption:=idproduct;
end;


end.

