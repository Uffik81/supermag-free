unit unitreturnttn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, ComCtrls, Grids, StdCtrls, mysql50;


type

  { TFormReturnTTN }

  TFormReturnTTN = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    stAccepted: TStaticText;
    stClientId: TStaticText;
    stNumDoc: TStaticText;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1ChangeBounds(Sender: TObject);
    procedure StringGrid1EditButtonClick(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    { private declarations }

    flEditing:boolean;
    idRowSelect:integer;
  public
    { public declarations }
    flNewDoc:boolean;
    flReadOnly:boolean;
    inDocNumber:string;
    inDocDate:string;
    docDate:String;
    docNumber:String;
    Docid:string;
    SummaDoc:Real;
    ConsigneeClientAddress:String;
    ClientName:String;
    ClientId:string;
    procedure CreateDoc(Sender: TObject);
    function ShowReadOnly():integer;
  end;

var
  FormReturnTTN: TFormReturnTTN;

implementation

{$R *.lfm}
uses unitstart;
{ TFormReturnTTN }

const
  FormName = 'Возвратная накладная';

function TFormReturnTTN.ShowReadOnly():integer;
begin
  flReadOnly:=true;
  result:=showmodal();
end;


procedure TFormReturnTTN.StringGrid1EditingDone(Sender: TObject);
var
  edSumm:Real;
  ind:integer;
begin
  flEditing:=true;
  edSumm:=formStart.StrToFloat(StringGrid1.Cells[2,idRowSelect]);
  edSumm:=edsumm *formStart.StrToFloat(StringGrid1.Cells[3,idRowSelect]);
  StringGrid1.Cells[4,idRowSelect]:=Format('%8.2f',[edSumm]);
  SummaDoc:=0;
  for ind:=1 to StringGrid1.RowCount-1 do
    SummaDoc:=summadoc+formstart.StrToFloat(StringGrid1.Cells[4,ind]);
end;

procedure TFormReturnTTN.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
begin
  //showmessage(value);
end;

procedure TFormReturnTTN.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  //showmessage('='+inttostr(ord(key)));
end;

procedure TFormReturnTTN.StringGrid1SelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin
  //showmessage('1');
end;

procedure TFormReturnTTN.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
  idRowSelect:=arow;
  caption:=FormName+' ['+DocNumber+' от '+DocDate+'] ';
  if flEditing then
    caption:=caption+'*';
end;

procedure TFormReturnTTN.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin

//  showmessage(value);

end;

procedure TFormReturnTTN.FormShow(Sender: TObject);
var
  Query:String;
  i:integer;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  if not flNewDoc then begin
  //stUpLoadPoint.Caption:='';
  // === подготавливаем документ для работы ===
    SummaDoc:=0;
    edit2.Text:=docnumber;
    datetimePicker1.Date:=formstart.DB_StrToDate(trim(docDate));
    Query:='SELECT `clientregid`,`ClientName`,`summa`  FROM `docjurnale` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'");';
    formStart.recbuf:=FormStart.DB_query(Query) ;
    formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
    if formStart.rowbuf<>nil then begin
       ClientName:= formStart.rowbuf[1];
       Clientid:= formStart.rowbuf[0];
       SummaDoc:= formStart.strtofloat(formStart.rowbuf[2]);
     end;
    Query:='SELECT `basenumdoc`,`basedatedoc`, `Accepted`  FROM `docx24` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'");';
    formStart.recbuf:=FormStart.DB_query(Query) ;
    formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
    if formStart.rowbuf<>nil then begin
       indocdate:= formStart.rowbuf[1];
       indocnumber:= formStart.rowbuf[0];
       if formStart.rowbuf[2] = '1' then
         stAccepted.Caption:='Акт подтвердили!';
       if formStart.rowbuf[2] = '0' then
         stAccepted.Caption:='Акт отказали!';

   //    SummaDoc:= strtofloat(formStart.rowbuf[2]);
     end;
    SummaDoc:=0;
    stClientid.Caption:=clientid;
    stnumdoc.Caption:=docnumber;
    Query:='SELECT numposit,tovar,count,price,formA,formB,alccode, (SELECT `crdate` FROM `spformfix` WHERE `spformfix`.`forma`=`doc24`.`forma`) AS `crdate` FROM `doc24` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND(docid="'+Docid+'") ;';
    formStart.recbuf:=FormStart.DB_query(Query) ;
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
    i:=1;
    while formStart.rowbuf<>nil do begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
     with StringGrid1.rows[i] do begin
     // Add('');
  //    ADD(IntToStr(i));
      Add(trim(formStart.rowbuf[0]));         //0
      Add(trim(formStart.rowbuf[1]));         //1
      Add(trim(formStart.rowbuf[3]));         //2
      Add(trim(formStart.rowbuf[2]));         //2
      Add(trim(formStart.rowbuf[3]));         //6
       SummaDoc:= SummaDoc+formStart.strtofloat(formStart.rowbuf[3]);
      Add(trim(formStart.rowbuf[4]));         //7
      Add(trim(formStart.rowbuf[5]));         //5
      Add(trim(formStart.rowbuf[7]));         //7
      Add(trim(formStart.rowbuf[6]));         //5
    end;
    i:=i+1;
    formStart.rowbuf := formstart.DB_Next(formStart.recbuf);
   End;

 end;
  caption:=FormName+' ['+DocNumber+' от '+DocDate+'] ';
  if flEditing then
    caption:=caption+'*';
end;

procedure TFormReturnTTN.FormKeyPress(Sender: TObject; var Key: char);
begin
 // showmessage('='+inttostr(ord(key)));
end;

procedure TFormReturnTTN.BitBtn2Click(Sender: TObject);
begin
  BitBtn1Click(nil);
  formstart.GetRetTTNfromEGAIS(docNumber,docDate);
end;

procedure TFormReturnTTN.BitBtn3Click(Sender: TObject);
begin
  close();
end;

procedure TFormReturnTTN.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  flEditing:=false;
  closeaction:=caHide;
end;

procedure TFormReturnTTN.FormCreate(Sender: TObject);
begin
  flReadOnly:=false;
  flEditing:=false;
  caption:=FormName;
end;

procedure TFormReturnTTN.BitBtn1Click(Sender: TObject);
var
    xrowbuf:MYSQL_ROW;
    xrecbuf:PMYSQL_RES;
  query:String;
  i:integer;
begin
  if flReadOnly then
    exit;

  if MessageDlg('Сохранить изменения ?',mtWarning,[ mbYes, mbNo],0)  <>6 then  exit;

  DocNumber:=edit2.Text;
  DocDate:=FormatDateTime('YYYY-MM-DD',datetimePicker1.Date);
  if flNewDoc then begin
     Query:='INSERT INTO `docjurnale` (`DocId`,`numdoc`,`datedoc`,`clientregid`,`ClientName`,`status`,`summa`,`registry`,`type`,`addressclient`) VALUES'+
         ' ('''+Docid+''','''+DocNumber+''','''+DocDate+''','''+stClientId.Caption+''','''+ClientName+''',''---'','''+FloatToStr(SummaDoc)+''',''-'',''RetWayBill'','''+ConsigneeClientAddress+''');';
     formStart.DB_query(query);

  end else
  begin
     Query:='UPDATE `docjurnale` SET `summa`="'+format('%8.2f',[SummaDoc])+'" WHERE  `numdoc`='''+DocNumber+''' AND `datedoc`='''+DocDate+''' AND `type`=''RetWayBill'' ;';
     formStart.DB_query(query);
  end;

  if flEditing then begin
     Query:='DELETE FROM `doc24` WHERE (`datedoc`="'+docDate+'")AND(`numdoc`="'+DocNumber+'");';
     formStart.DB_Query(Query) ;


  for i:=1 to stringgrid1.RowCount-1 do
  if (stringgrid1.Cells[1,i]<>'')OR( flEditing) then
   begin
    Query:='INSERT INTO `doc24` (`datedoc`,`numdoc`,`tovar`,`price`,`alccode`,`count`,`forma`,`formb`,`numposit`) VALUES '+
       '('''+
       docDate+''','''+
       DocNumber+''','''+
       stringgrid1.Cells[1,i]+''','''+
       stringgrid1.Cells[2,i]+''','''+
       stringgrid1.Cells[8,i]+''','''+
       stringgrid1.Cells[3,i]+''','''+
       stringgrid1.Cells[5,i]+''','''+
       stringgrid1.Cells[6,i]+''','''+
       inttostr(i)+''') ;';
       formStart.recbuf:= FormStart.DB_Query(Query);

   end;
    end;
  flEditing:=false;
  flNewDoc:=false;
  caption:=FormName+' ['+DocNumber+' от '+DocDate+'] ';
  if flEditing then
    caption:=caption+'*';
end;

procedure TFormReturnTTN.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ind:integer;
  subcount:integer;
begin
  if flreadonly then exit;
  //showmessage('='+inttostr(key));
  if  key = 0045 then  ;// === ins ====
  if  key = 0046 then
  begin
      key:=0;
      if idRowSelect>=1 then
      begin
        if idRowSelect>=stringgrid1.RowCount then
           idRowSelect:=stringgrid1.RowCount-1;
        stringgrid1.DeleteRow(idRowSelect);
        subcount:=stringgrid1.RowCount;
        ind:=1;
        while (stringgrid1.RowCount>ind) do begin
          if (stringgrid1.Cells[0,ind]<>'') then
            stringgrid1.Cells[0,ind]:=inttostr(ind);
          ind:=ind+1;
        end;
      end;
  end
  else
  begin
    //showmessage('='+inttostr(key));
  end;
end;

procedure TFormReturnTTN.FormPaint(Sender: TObject);
begin

end;

procedure TFormReturnTTN.StringGrid1ChangeBounds(Sender: TObject);
begin

end;

procedure TFormReturnTTN.StringGrid1EditButtonClick(Sender: TObject);
begin

end;

procedure TFormReturnTTN.CreateDoc(Sender: TObject);
var
    xrowbuf:MYSQL_ROW;
    xrecbuf:PMYSQL_RES;
    Query:String;
    i:integer;
begin
  Query:='SELECT numposit,tovar,factcount,price,formA,(SELECT `formb` FROM `docformab` WHERE (`docformab`.`numposition`=`doc221`.`numposit`)AND(`docformab`.`docid`="'+Docid+'")) AS  formB,AlcItem, (SELECT `crdate` FROM `spformfix` WHERE `spformfix`.`forma`=`doc221`.`forma`) AS `crdate` FROM `doc221` WHERE (datedoc="'+indocDate+'")AND(numdoc="'+inDocNumber+'")AND(docid="'+Docid+'") ;';
  // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'") (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND
  xrecbuf:=FormStart.DB_query(Query) ;
  if xrecbuf=Nil then
    exit;
  xrowbuf := formStart.DB_NEXT(xrecbuf);
  i:=1;
  while xrowbuf<>nil do begin
          StringGrid1.RowCount:=i+1;
          StringGrid1.Rows[i].Clear;
   with StringGrid1.rows[i] do begin
//    Add('');
//    ADD(IntToStr(i));
    Add(trim(xrowbuf[0]));         //0
    Add(trim(xrowbuf[1]));         //1
    Add(trim(xrowbuf[3]));         //2
    Add(trim(xrowbuf[2]));         //6
    Add(trim(xrowbuf[3]));         //7
    Add(trim(xrowbuf[4]));         //5
//    Add('x');         // флаг - загружен из субд
    Add(trim(xrowbuf[5]));         //7
    Add(trim(xrowbuf[7]));         //5
    Add(trim(xrowbuf[6]));
  end;
  i:=i+1;
  xrowbuf := mysql_fetch_row(xrecbuf);
 End;
  Query:='SELECT `ClientRegId`,`ClientName`,`block`,`status`,`ClientAccept` FROM `docjurnale` WHERE (datedoc="'+indocDate+'")AND(numdoc="'+inDocNumber+'")';
  xrecbuf:=FormStart.DB_query(Query);
  xRowBuf:=FormStart.DB_Next(xrecbuf);
  if xRowBuf<> nil then
  begin
      stClientId.Caption:=xRowBuf[0];
      stNumDoc.Caption:=inDocNumber+' от '+indocDate+#13#10+xRowBuf[1];
      ClientName:= xRowBuf[1];
      if xRowBuf[4]='+' then
        flReadOnly:=true;
  end;
  flNewDoc:=true;
  flReadOnly:=false;
  flEditing:=true;
  idRowSelect:=-1;
end;

end.

