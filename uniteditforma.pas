unit unitEditFormA;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, mysql50;

type

  { TFormEditFormA }

  TFormEditFormA = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    fEGAISFormA:String;
    fEGAISFormB:String;
    fAlcCode:String;
    fName:String;
    fDocNum:String;
  end;

var
  FormEditFormA: TFormEditFormA;

implementation

{$R *.lfm}
uses unitStart;
{ TFormEditFormA }

procedure TFormEditFormA.FormShow(Sender: TObject);
var
  Query:String;
begin
  StaticText1.Caption:=fName;
  StaticText2.Caption:=fAlcCode;
  Caption:='Справка А ['+fEGAISFormA+']';
  Edit1.text:= '';
  Edit2.Text:= '';
  Edit3.Text:= '';
  Edit4.Text:= '';
  if formStart.ConnectDB() then begin
    Query:='SELECT `forma`,`numfix`,`datefix`,`crdate`,`nummark`,`ttnnumber`,`ttndate` FROM `spformfix` WHERE (`forma`='''+fEGAISFormA+''')AND(`AlcItem`='''+fAlcCode+''');';
    formStart.recbuf := formStart.DB_Query(Query);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    if formStart.rowbuf<>nil then
     begin
       Edit1.text:= formStart.rowbuf[1];
       Edit2.Text:= formStart.rowbuf[2];
       Edit3.Text:= formStart.rowbuf[3];
       Edit4.Text:= formStart.rowbuf[4];
       Edit5.Text:= formStart.rowbuf[5];
       Edit6.Text:= formStart.rowbuf[6];
     end;
    formStart.disconnectDB();
  end;
  //BitBtn1.Enabled:=formStart.flOptMode;
  //BitBtn2.Enabled:=formStart.flOptMode;
  BitBtn3.Enabled:=formStart.flOptMode;
  Edit1.ReadOnly:=not formStart.flOptMode;
  Edit2.ReadOnly:=not formStart.flOptMode;
  //Edit3.ReadOnly:=not formStart.flOptMode;
  Edit4.ReadOnly:=not formStart.flOptMode;
end;

procedure TFormEditFormA.BitBtn1Click(Sender: TObject);
var
  Query:String;
  i1,i2,
  i:integer;
  s2,s3,s4,s5,
  s1:String;
begin
  // ================ Save ============\
  Query:='SELECT `forma` FROM `spformfix` WHERE (`forma`='''+fEGAISFormA+''')AND(`AlcItem`='''+fAlcCode+''');';
  formStart.recbuf:=formstart.DB_query(Query);
  formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
  if formStart.rowbuf<>nil then
   begin
     Query:='UPDATE `spformfix` SET `numfix`='''+Edit1.text+''',`datefix`='''+Edit2.text+''',`crdate`='''+Edit3.text+''',`nummark`='''+Edit4.text+''' WHERE (`forma`='''+fEGAISFormA+''');';
     formStart.recbuf:=formstart.DB_query(Query);
   end
   else begin
     Query:='INSERT INTO  `spformfix` (`AlcItem`,`forma`,`numfix`,`datefix`,`crdate`,`nummark`)'+
     ' VALUE ('''+fAlcCode+''','''+fEGAISFormA+''','''+Edit1.text+''','''+Edit2.text+''','''+Edit3.text+''','''+Edit4.text+''');';
     formStart.recbuf:=formstart.DB_query(Query);
   end;

  // ================ Сохраняем марки ===============
  s1:= Edit4.Text;
  i:=pos(',',s1);
  while i>0 do begin
       s2:=copy(s1,1,i-1);
       s1:=copy(s1,i+1,length(s1)-i);
  if length(s2)>7 then begin
    i1:=pos('(',s2);
    i2:=pos(')',s2);
    s3:=s2[2]+s2[3]+s2[4];
    s2:=copy(s2,6,length(s2)-5);
    i1:=pos('-',s2);
    s4:=copy(s2,1,i1-1);
    s5:=copy(s2,i1+1,length(s2)-i1);        // minNumMark maxNumMark
    Query:='SELECT `forma` FROM `alcformab` WHERE (`partmark`='''+s3+''')AND(`alcitem`='''+fAlcCode+''')AND(`minNumMark`='''+s4+''');';
    formStart.recbuf:=formstart.DB_query(Query);
    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
    if formStart.rowbuf<>nil then
     begin
       Query:='UPDATE `alcformab` SET `forma`='''+fEGAISFormA+''',`formb`='''+fEGAISFormB+''' WHERE (`partmark`='''+s3+''')AND(`alcitem`='''+fAlcCode+''')AND(`minNumMark`='''+s4+''');';
       formStart.recbuf:=formstart.DB_query(Query);
     end
     else begin

       Query:='INSERT INTO `alcformab` (`nummark`, `partmark`, `formA`, `formB`, `OldFormB`, `AlcItem`, `minNumMark`, `maxNumMark`, `AlcRegId`, `marknum`) '+
              'VALUES ('''', '''+s3+''', '''+fEGAISFormA+''', '''+fEGAISFormB+''', '''+fEGAISFormB+''', '''+fAlcCode+''', '''+s4+''', '''+s5+''', '''', '''');';

       //'INSERT INTO  `alcformab` (`AlcCode`,`forma`,`numfix`,`datefix`,`crdate`,`nummark`) VALUE ('''+fAlcCode+''','''+Edit1.text+''','''+Edit2.text+''','''+Edit3.text+''','''+Edit4.text+''');';
       formStart.recbuf:=formstart.DB_query(Query);
     end;
   end;

   i:=pos(',',s1);
  end;
  // ======================================
  s2:=s1;
  if length(s2)>7 then begin
    i1:=pos('(',s2);
    i2:=pos(')',s2);
    s3:=s2[2]+s2[3]+s2[4];
    s2:=copy(s2,6,length(s2)-5);
    i1:=pos('-',s2);
    s4:=copy(s2,1,i1-1);
    s5:=copy(s2,i1+1,length(s2)-i1);        // minNumMark maxNumMark
    Query:='SELECT `forma` FROM `alcformab` WHERE (`partmark`='''+s3+''')AND(`alcitem`='''+fAlcCode+''')AND(`minNumMark`='''+s4+''');';
    formStart.recbuf:=formstart.DB_query(Query);
    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
    if formStart.rowbuf<>nil then
     begin
       Query:='UPDATE `alcformab` SET `forma`='''+fEGAISFormA+''',`formb`='''+fEGAISFormB+''' WHERE (`partmark`='''+s3+''')AND(`alcitem`='''+fAlcCode+''')AND(`minNumMark`='''+s4+''');';
       formStart.recbuf:=formstart.DB_query(Query);
     end
     else begin

       Query:='INSERT INTO `alcformab` (`nummark`, `partmark`, `formA`, `formB`, `OldFormB`, `AlcItem`, `minNumMark`, `maxNumMark`, `AlcRegId`, `marknum`) '+
              'VALUES ('''', '''+s3+''', '''+fEGAISFormA+''', '''+fEGAISFormB+''', '''+fEGAISFormB+''', '''+fAlcCode+''', '''+s4+''', '''+s5+''', '''', '''');';

       //'INSERT INTO  `alcformab` (`AlcCode`,`forma`,`numfix`,`datefix`,`crdate`,`nummark`) VALUE ('''+fAlcCode+''','''+Edit1.text+''','''+Edit2.text+''','''+Edit3.text+''','''+Edit4.text+''');';
       formStart.recbuf:=formstart.DB_query(Query);
     end;
   end;



end;

procedure TFormEditFormA.BitBtn3Click(Sender: TObject);
var
  Query:String;
  flOk:boolean;
  i:integer;
begin
  if pos('?',edit4.text) >0 then edit4.text:='';
  Query:='SELECT `forma`,`periodmark` FROM `docformab` WHERE (`forma`='''+fEGAISFormA+''');';
  formStart.recbuf:=formstart.DB_query(Query);
  formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
  flOk:=true;
  while formStart.rowbuf<>nil do
   begin
     Edit4.Text:= Edit4.Text+formStart.rowbuf[1];
     flOk:=false;
     formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
   end;
  if flOk then begin
    Query:='SELECT `forma`,`periodmark` FROM `docformab` WHERE (`forma`='''+fDocNum+''')AND(`AlcItem`='''+falccode+''');';
    formStart.recbuf:=formstart.DB_query(Query);
    formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
    flOk:=true;

    while formStart.rowbuf<>nil do
     begin
       Edit4.Text:= Edit4.Text+','+formStart.rowbuf[1];
       flOk:=false;
       formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
     end;
  end;
  if flOk then begin
    Query:='SELECT * FROM `regrestsproduct` WHERE (`AlcCode`='''+falccode+''') GROUP BY `forma`;';
     formStart.recbuf:=formstart.DB_query(Query);
     formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
     i:=0;
     while formStart.rowbuf<>nil do
      begin
        i:=i+1;
        formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
      end;
     if i=1 then begin
        Query:='SELECT `forma`,`periodmark` FROM `docformab` WHERE (`AlcItem`='''+falccode+''');';
        formStart.recbuf:=formstart.DB_query(Query);
        formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
        flOk:=true;
        while formStart.rowbuf<>nil do
         begin
           Edit4.Text:= Edit4.Text+','+formStart.rowbuf[1];
           flOk:=false;
           formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
         end;
     end;
  end;
  if flOk then begin
        Query:='SELECT `forma`,`periodmark` FROM `docformab` WHERE (`forma`='''+edit1.text+''')AND(`AlcItem`='''+falccode+''');';
        formStart.recbuf:=formstart.DB_query(Query);
        formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
        flOk:=true;
        while formStart.rowbuf<>nil do
         begin
           Edit4.Text:= Edit4.Text+','+formStart.rowbuf[1];
           flOk:=false;
           formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
         end;
  end;
   if flOk then begin
      Query:='SELECT `forma`, COUNT(`forma`) res FROM `docformab` WHERE (`AlcItem`='''+falccode+''') GROUP BY `forma`;';
      formStart.recbuf:=formstart.DB_query(Query);
      formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
      flOk:=true;
      while formStart.rowbuf<>nil do
       begin
      //   Edit4.Text:= Edit4.Text+','+formStart.rowbuf[1];
         flOk:=false;
         formStart.rowbuf:=formStart.DB_Next(formStart.recbuf);
       end;
      // Edit4.Text:='';
   end;
end;

end.

