unit unitwaybillv2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, Grids, Buttons, StdCtrls;

type

  { TFormWayBillv2 }

  TFormWayBillv2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    bbSelectClient: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    stDescription: TStaticText;
    stNameClient: TStaticText;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure bbSelectClientClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flOkegais:boolean;
    flReadOnly:boolean;
    flEditing:boolean;
    flNow:boolean;
    flPDF417:String;
    flMove:boolean;
    flClient:String;
    function DateDoc():String;
    procedure NowDocument;
    procedure OpenDocument(aNumDoc,aDateDoc:String);
  end;

var
  FormWayBillv2: TFormWayBillv2;

implementation
uses unitstart, mysql50, unitaddformbv2,unitspproducer,unitSelectTov
  , unitcommon;
{$R *.lfm}

{ TFormWayBillv2 }

procedure TFormWayBillv2.FormShow(Sender: TObject);

begin

end;


function TFormWayBillv2.DateDoc: String;
begin
  result:=FormatDateTime('YYYY-MM-DD',dpDateDoc.date)
end;

procedure TFormWayBillv2.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  res:integer;
  Query:String;
begin
  //FormStart.ConnectDB();
  Query:='UPDATE `docjurnale` SET block="" WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'") ;';
  formStart.DB_query(Query);
  if not flReadOnly then begin
  res:=MessageDlg('Сохранить изменения ?',mtWarning,[ mbYes, mbNo],0);
  if 6 = res then
      BitBtn2Click(nil);
  end;
  CloseAction:=caHide;

end;

procedure TFormWayBillv2.FormKeyPress(Sender: TObject; var Key: char);
var
  con1:integer;
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  formB:string;
  ii,
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
    con1:=0;
    if (con1>0) then begin
          showmessage('Товар с такой акцизной маркой уже продавался или добавлен в инвентаризацию, отложите ее для разбирательст!');
          flPDF417:='';
          key:=#0;
    end else begin
        AlcCode1:='';
        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
        key:=#0;
        formb:=formAddFormBv2.AddFormBOnTransfer(alccode1);
        if formb = '' then begin
          showmessage('Невозможно добавить!');
          flPDF417:='';
          key:=#0;
        end;

        xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+AlcCode1+'" '  );
        xrowbuf:=formStart.DB_Next(xrecbuf);
        if xrowbuf<>nil then begin
          for ii:=0 to formAddFormBv2.CountFormB -1  do begin

          i:=StringGrid1.RowCount;
          StringGrid1.RowCount:=i+1;
          StringGrid1.Cells[1,i]:=alccode1;
          StringGrid1.Cells[2,i]:=xrowbuf[0];
          StringGrid1.Cells[4,i]:=formAddFormBv2.ArrFormB[ii];
          StringGrid1.Cells[5,i]:=formAddFormBv2.flCrDate;
          StringGrid1.Cells[6,i]:='0';
          StringGrid1.Cells[7,i]:=formAddFormBv2.ArrQuality[ii];
          StringGrid1.Cells[3,i]:=formAddFormBv2.flFormA;
          StringGrid1.Col:=3;
          StringGrid1.Row:=i;

          end;
        end else begin
            showmessage('Нет данных по данному товару!');
        end;
        flPDF417:='';
    end;
  end;

end;

procedure TFormWayBillv2.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key<96) and (key>32) then  begin
   flPDF417:=flPDF417+char(lo(key));
   key:=0;
 end;
 if (key=46)AND(StringGrid1.Row>0) then begin
    StringGrid1.DeleteRow(StringGrid1.Row);
 end;
end;

procedure TFormWayBillv2.BitBtn2Click(Sender: TObject);
var
  ind,
  i:integer;
  mass:array[0..1000] of real;
  s2,s1:String;
  Query:String;
  SummCount:Double;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  if flReadOnly then begin
    ShowMessage('Открыт только для чтения!');
    exit;
  end;
  SummCount:=0;
  formStart.ConnectDB();
  if flnow then begin
    xrecbuf:=formStart.DB_query('SELECT `ClientRegId` FROM `docjurnale` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'") AND `type`="MoveWayBill";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf=nil then
      begin
        Query:='INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`status`,`summa`,`registry`,`type`,`docid`) VALUES '+
               ' ("'+edNumDoc.Text+'","'+DateDoc+'","'+flClient+'","'+stNameClient.Caption+'","---","0","-","MoveWayBill","");';

        formStart.DB_Query(Query);
      end;
  end;
//    else
//      formStart.DB_query('SELECT `ClientRegId` FROM `docjurnale` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'");');
  flEditing:=true;

  if flEditing then begin
     Query:='DELETE FROM `doc21` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'");';
     mysql_query(formStart.sockMySQL,PChar(Query)) ;
     Query:='DELETE FROM `doc211` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'");';
     mysql_query(formStart.sockMySQL,PChar(Query)) ;
    end;
  for i:=1 to StringGrid1.RowCount-1 do
   begin
    Query:='INSERT INTO `doc21` (`datedoc`,`numdoc`,`tovar`,`price`,`alcitem`,`valuetov`,`forma`,`formb`,`partplomb`,`numplomb`,`posit`,`crdate`) VALUES '+
       '('''+
       DateDoc+''','''+
       edNumDoc.Text+''','''+
       replaceStr(StringGrid1.Cells[2,i])+''','''+
       StringGrid1.Cells[6,i]+''','''+
       StringGrid1.Cells[1,i]+''','''+
       StringGrid1.Cells[7,i]+''','''+
       StringGrid1.Cells[3,i]+''','''+
       StringGrid1.Cells[4,i]+''','''','''','''+
       inttostr(i)+''','''+
       StringGrid1.Cells[5,i]+''') ;';
     FormStart.DB_Query(Query);

       Query:='INSERT INTO `doc211` (`numdoc`,`datedoc`,`clientregid`,`ClientName`,`numposit`,`tovar`,`listean13`,`alcitem`,`Count`,`Price`,`import`,`forma`,`formb`) VALUES '+
       '('''+edNumDoc.Text+''','''+DateDoc+''','''+flClient+''','''+stNameClient.Caption+''','''+inttostr(i)+
       ''','''+replaceStr(StringGrid1.Cells[2,i])+''','''','''+
       StringGrid1.Cells[1,i]+''','''+StringGrid1.Cells[7,i]+''','''
       +'0'','''','''+
       StringGrid1.Cells[3,i]+''','''+
       StringGrid1.Cells[4,i]+''');';

       FormStart.DB_Query(Query);
     // == исправление

   end;
  // ===== Здесь надо проверить совпадает или нет количество позиций =====

  if flOkegais then begin
    Query:='UPDATE `docjurnale` SET `status`="1--" WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'")AND `type`="MoveWayBill" ;';
    FormStart.DB_query(Query);
  end;
// =====================================================================
  FormStart.DisconnectDB();
  flEditing:=false;
  showmessage('Сохранили!');
end;

procedure TFormWayBillv2.BitBtn4Click(Sender: TObject);
var
  alccode1:string;
  formb:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  ii:integer;
  i:integer;
begin
  FormSelectTov.selitem:='';
  if FormSelectTov.ShowModal <> 1377 then exit;
  AlcCode1:=FormSelectTov.selitem;
  formb:=formAddFormBv2.AddFormBOnTransfer(alccode1);
  if formb = '' then begin
    showmessage('Невозможно добавить!');
    flPDF417:='';

  end;

  xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+AlcCode1+'" '  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
    for ii:=0 to formAddFormBv2.CountFormB -1  do begin

    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=i+1;
    StringGrid1.Cells[1,i]:=alccode1;
    StringGrid1.Cells[2,i]:=xrowbuf[0];
    StringGrid1.Cells[4,i]:=formAddFormBv2.ArrFormB[ii];
    StringGrid1.Cells[5,i]:=formAddFormBv2.flCrDate;
    StringGrid1.Cells[6,i]:='0';
    StringGrid1.Cells[7,i]:=formAddFormBv2.ArrQuality[ii];
    StringGrid1.Cells[3,i]:=formAddFormBv2.flFormA;
    StringGrid1.Col:=3;
    StringGrid1.Row:=i;

    end;
  end else begin
      showmessage('Нет данных по данному товару!');
  end;
  flPDF417:='';
end;

procedure TFormWayBillv2.BitBtn5Click(Sender: TObject);
begin
  stringgrid1.DeleteRow(stringgrid1.Row);
end;

procedure TFormWayBillv2.BitBtn1Click(Sender: TObject);
begin
  // ==== Сохраним документ =====
  flOkegais:=true;
  BitBtn2Click(nil);
  // ==== Проведе через ЕГАИС ===
  if flOkegais then
      formStart.GetTTNfromEGAIS(edNumDoc.Text,DateDoc,true)
    else
      ShowMessage('Не полностью заполнен документ. Отправить не возможно!');
end;

procedure TFormWayBillv2.bbSelectClientClick(Sender: TObject);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  if flMove then begin
    flClient:= formSpProducer.SelectClientToMove;
    if flClient<>'' then begin
      xrecbuf:=FormStart.DB_Query('SELECT `fullname`,`inn`,`kpp`,`description` FROM `spproducer` WHERE `clientregid`="'+flClient+'";'  );
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if xrowbuf<> nil then begin
         stNameClient.Caption:=xrowbuf[0];
         stDescription.Caption:=xrowbuf[3];
        end

    end;
  end;
end;

procedure TFormWayBillv2.NowDocument;
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  flEditing:=true;
  flNow:=true;
  flMove:=true;
  stNameClient.Caption:='';
  stDescription.Caption:='';
  xrecbuf:=FormStart.DB_Query('SELECT (COUNT(*)+1) AS `nnumdoc` FROM `docjurnale` WHERE `type`="MoveWayBill" AND `registry`="-" '  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<> nil then begin
     edNumDoc.Text:=xrowbuf[0];
    end
    else
      edNumDoc.Text:='1';
  stringgrid1.RowCount:=1;
  dpDateDoc.Date:=now();
  showmodal;

end;

procedure TFormWayBillv2.OpenDocument(aNumDoc, aDateDoc: String);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
  i:integer;
begin
  edNumDoc.Text:=aNumDoc;
  dpDateDoc.Date:=formStart.Str1ToDate(aDateDoc);
  flnow:=false;
  flMove:=true;
  flEditing:=true;
  flClient:='';
  stringgrid1.RowCount:=1;
  xrecbuf:=FormStart.DB_Query('SELECT `ClientRegId` FROM `docjurnale` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'") AND `type`="MoveWayBill";'  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<> nil then begin
     flClient:=xrowbuf[0];
    end ;
  xrecbuf:=FormStart.DB_Query('SELECT `fullname`,`inn`,`kpp`,`description` FROM `spproducer` WHERE `clientregid`="'+flClient+'";'  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<> nil then begin
     stNameClient.Caption:=xrowbuf[0];
     stDescription.Caption:=xrowbuf[3];
    end ;
  Query:='SELECT `tovar`,`price`,`alcitem`,`count`,`forma`,`formb`,(SELECT `crdate` FROM `spformfix` WHERE `alcitem`=`doc211`.`alcitem` AND `forma`=`doc211`.`forma` limit 1) AS `crdate` FROM `doc211` WHERE (`datedoc`="'+aDateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'") ;';
  xrecbuf:=FormStart.DB_Query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=i+1;
    StringGrid1.Cells[1,i]:=xrowbuf[2];
    StringGrid1.Cells[2,i]:=xrowbuf[0];
    StringGrid1.Cells[3,i]:=xrowbuf[4];
    StringGrid1.Cells[4,i]:=xrowbuf[5];
    StringGrid1.Cells[5,i]:=xrowbuf[6];
    StringGrid1.Cells[6,i]:=xrowbuf[1];
    StringGrid1.Cells[7,i]:=xrowbuf[3];
    StringGrid1.Col:=3;
    StringGrid1.Row:=i;
    xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  showmodal;
end;

end.

