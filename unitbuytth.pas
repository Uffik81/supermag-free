unit unitBuyTTH;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, StdCtrls, ExtCtrls, Menus, Grids, mysql50;

type

  { TFormBuyTTH }

  TFormBuyTTH = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Edit1: TEdit;
    edINN: TEdit;
    edKPP: TEdit;
    edEGAIS: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    ListView1: TListView;
    mmAddress: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText6: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    stLoadPoint: TStaticText;
    stClientAddress: TStaticText;
    StringGrid1: TStringGrid;
    stUpLoadPoint: TStaticText;
    stNameFirmIn: TStaticText;
    StaticText5: TStaticText;
    StaticText7: TStaticText;
    stFormA: TStaticText;
    stFormB: TStaticText;
    stSumma: TStaticText;
    stSummaFact: TStaticText;
    stTovar: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure ListView1AdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure ListView1MouseEnter(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    DocNumber:String;
    DocDate:String;
    DocKontr:String;
    DocId:String;
    flEdit:boolean; // Открыт для редактирования
    EditIndex:integer;
    flUTMVer:string;

    WBregID:string;
  end;

var
  FormBuyTTH: TFormBuyTTH;

implementation

{$R *.lfm}
uses unitstart,uniteditforma, unitviewreport, unitpdf417;
{ TFormBuyTTH }



procedure TFormBuyTTH.BitBtn2Click(Sender: TObject);
var
  res:longint;
  i:integer;
  fllost:boolean;
begin
  // Отправить подтверждение/недовоз/Возврат
  BitBtn1Click(nil);
  flLost:=false;
  for i:=0 to listview1.Items.Count-1 do begin
    if formStart.StrToFloat(ListView1.Items.Item[i].SubItems.Strings[2])<
       formStart.StrToFloat(ListView1.Items.Item[i].SubItems.Strings[1])
    then
      flLost:=true;
  end;
  if flLost then
    res:=MessageDlg('Отправить Акт расхождения/отказ в систему ЕГАИС.',mtWarning,[ mbYes, mbNo],0)
  else
    res:=MessageDlg('Отправить подтверждение в систему ЕГАИС.',mtWarning,[ mbYes, mbNo],0);
  if 6 = res then begin
    if not formStart.flDemoMode then
      FormStart.FromEGAISofActTTH(DocNumber,DocDate,docid,flutmver)
    else
      ShowMessage('Акт отправлен успешно!');
  end;
end;

procedure TFormBuyTTH.BitBtn1Click(Sender: TObject);
var
  i:integer;
  Query:String;
begin
  for i:=0 to listview1.Items.Count-1 do begin
    Query:='UPDATE `doc221` SET `factcount`='''+ListView1.Items.Item[i].SubItems.Strings[2]+''' WHERE'+
    ' (datedoc="'+docDate+'")AND (numdoc="'+DocNumber+'")AND (`numposit`="'+ListView1.Items.Item[i].Caption+'")AND(docid="'+Docid+'") ;';
    formstart.DB_Query(query);
  end;

end;

procedure TFormBuyTTH.BitBtn3Click(Sender: TObject);
var
  sLine1:TStringList;
  Query,
  sURL,
  S1:String;
begin
 // === отмена проводки через ЕГАИС !!!
  SLine1:=TStringList.create();
  sLine1.Add('<?xml version="1.0" encoding="UTF-8"?>');
  sLine1.Add('<ns:Documents Version="1.0"');
  sLine1.Add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  sLine1.Add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  sLine1.Add('xmlns:qp="http://fsrar.ru/WEGAIS/RequestRepealWB">');
  sLine1.Add('<ns:Owner>');
  sLine1.Add('<ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  sLine1.Add('</ns:Owner>');
  sLine1.Add('<ns:Document>');
  sLine1.Add('<ns:RequestRepealWB>');
  sLine1.Add('<qp:ClientId>'+formStart.EgaisKod+'</qp:ClientId>');
  sLine1.Add('<qp:RequestNumber>'+DocNumber+'</qp:RequestNumber>');
  sLine1.Add('<qp:RequestDate>'+FormatDateTime('YYYY-MM-DD',now())+'T'+FormatDateTime('hh:mm:ss',now())+'</qp:RequestDate>');
  sLine1.Add('<qp:WBRegId>'+WBregID+'</qp:WBRegId>');
  sLine1.Add('</ns:RequestRepealWB>');
  sLine1.Add('</ns:Document>');
  sLine1.Add('</ns:Documents>');
  S1:= FormStart.SaveToServerPOST('opt/in/RequestRepealWB',SLine1.text);
  sURL := formstart.getXMLtoURL(S1);
  Query :=
    'INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES' + ' (''' + sURL + ''',''' + DocID + ''',''' + WBRegID + ''',''' + sURL + ''',''Accept'',''Отмена проведения акта'',''WayBill'',''Operator'',''Operator'',''' + docdate + ''',''' + DocNumber + ''');';

  formstart.DB_query(Query);
end;

procedure TFormBuyTTH.BitBtn4Click(Sender: TObject);
begin
  formviewreport.ShowModal;
end;

procedure TFormBuyTTH.BitBtn5Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to listview1.Items.Count-1 do
    FormStart.QueryFormA(listview1.Items.Item[i].SubItems.Strings[6]);
  showmessage('Запрос Справок А отправлен!');
end;

procedure TFormBuyTTH.BitBtn6Click(Sender: TObject);
var
  fixcode:string;
  i:integer;
begin
  fixcode:=formgetpdf417.GetProducer();
  for i:= 1 to StringGrid1.RowCount-1 do begin
    if StringGrid1.Cells[6,i]= fixcode then begin
     StringGrid1.Row:=i;
     StringGrid1.Cells[0,i]:='+';
     FormStart.DB_query('UPDATE `doc221fix` SET `accept`="+" WHERE `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'" AND `docid`="'+DocId+'" AND `fixmark`="'+StringGrid1.Cells[5,i]+'";');
    end;
  end;
end;

procedure TFormBuyTTH.Edit1KeyPress(Sender: TObject; var Key: char);
var
  i:integer;
  allsummfact:real;
begin
  if key=#13 then begin
    ListView1.Selected.SubItems.Strings[2]:=EDIT1.Text;
    listView1.Selected.SubItems.Strings[5]:=FloatTostr(
      formStart.StrToFloat(EDIT1.Text)*formStart.StrToFloat(listView1.Selected.SubItems.Strings[3]));
    EDIT1.visible:=false;
    flEdit:=false;
    allsummfact:=0;
    for i:=0 to ListView1.Items.Count-1 do
       allsummfact:=allsummfact+formStart.StrToFloat(listView1.Items.item[i].SubItems.Strings[5]);
    stSummaFact.Caption:=Format('%8.2f',[allsummFact]);
  end;
  if key=#27 then begin
    EDIT1.visible:=false;
    flEdit:=false;
  end;
end;

procedure TFormBuyTTH.FormShow(Sender: TObject);
var
  i:integer;
  price,count,
  factcount,
  allsummfact,
  allsumm:real;
  Query:String;
//  WBregID:String;
  addresstt:string;
  aClientRegid:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  stUpLoadPoint.Caption:='';
  // === подготавливаем документ для работы ===
  ListView1.Items.Clear;
  WBregID:='';
  addresstt:='';
  Query:='SELECT `WBregID`,`addressclient`,`ClientName`,`ClientRegId`,`utmv2` FROM `docjurnale` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND(docid="'+Docid+'") ;';
  // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")
  formStart.recbuf:=FormStart.DB_query(Query);
  formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
  if formStart.rowbuf<>nil then begin
      WBregID:=formStart.rowbuf[0];
      addresstt:=formStart.rowbuf[1];
      stClientAddress.Caption:=formStart.rowbuf[1];
      stNameFirmIn.Caption:=formStart.rowbuf[2];
      aClientRegid:=formStart.rowbuf[3];
      flutmver:=formStart.rowbuf[4];
      edEGAIS.Text:=aClientRegid;
      edINN.Text:='';
      edKPP.Text:='';
      mmAddress.Clear;
      Query:='SELECT `inn`,`kpp`,`description` FROM `spproducer` WHERE `ClientRegId`="'+aClientRegid+'" ;';
      // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")
      formStart.recbuf:=FormStart.DB_query(Query);
      formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
      if formStart.rowbuf<>nil then begin
         edINN.Text:=formStart.rowbuf[0];
         edKPP.Text:=formStart.rowbuf[1];
         mmAddress.Text:=formStart.rowbuf[2];
      end;
  end;

  Query:='SELECT UNLOADPOINT,LOADPOINT FROM `doctransp` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;';
  // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'")
  formStart.recbuf:=FormStart.DB_query(Query);
  formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
  if formStart.rowbuf<>nil then begin
      //WBregID:=formStart.rowbuf[0];
      stUpLoadPoint.Caption:=formStart.rowbuf[0];
      stLoadPoint.Caption:=formStart.rowbuf[1];
  end;


  allsumm:=0;
  allSummFact:=0;
  StaticText1.Caption:='Документ '+DocNumber+' от '+docDate+'  '+docKontr;
  StaticText2.Caption:='Номер по ЕГАИС:'+DocID+#13#10+'Докумен по ЕГАИС:'+WBregID;
//  if not formStart.ConnectDB() then
//    exit;
  Query:='SELECT numposit,tovar,count,factcount,price,formA,formB,AlcItem, (SELECT `crdate` FROM `spformfix` WHERE `spformfix`.`forma`=`doc221`.`forma` LIMIT 1) AS `crdate`,(SELECT `clientregid` FROM `spproduct` WHERE `spproduct`.`alccode`=`doc221`.`alcitem` LIMIT 1) AS `manuf` FROM `doc221` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND(docid="'+Docid+'") ;';
  // WHERE ( `numdoc` LIKE "'+DocNumber+'")AND( `datedoc` LIKE "'+docDate+'") (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND
  formStart.recbuf:=FormStart.DB_query(Query) ;
  if formStart.recbuf=Nil then
    exit;
  formStart.rowbuf := formStart.DB_NEXT(formStart.recbuf);
  while formStart.rowbuf<>nil do
    begin
      with ListView1.Items.Add do begin
           caption:= formStart.rowbuf[0];
           subitems.Add(formStart.rowbuf[1]);//3
           subitems.Add(formStart.rowbuf[2]);//4
           subitems.Add(formStart.rowbuf[3]);//4
           price:=formStart.StrToFloat(formStart.rowbuf[4]);
           count:=formStart.StrToFloat(formStart.rowbuf[2]);
           factcount:= formStart.StrToFloat(formStart.rowbuf[3]);
           subitems.Add(Format('%8.2f',[price]));//4
           subitems.Add(Format('%8.2f',[price*count]));//4
           subitems.Add(Format('%8.2f',[price*factcount]));//4
           subitems.Add(formStart.rowbuf[5]);//4
           subitems.Add(formStart.rowbuf[6]);//4
           subitems.Add(formStart.rowbuf[7]);//4
           subitems.Add(formStart.rowbuf[8]);//4
           subitems.Add(formStart.rowbuf[9]);//4
         end;
     //      price:=   formStart.SQLQuery1.FieldByName('price').AsFloat
     allSumm:=          allSumm+ price*count ;
     allSummfact:=      allSummfact+price*factcount ;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end ;
  formStart.disconnectDB();

  stSumma.Caption:=Format('%8.2f',[allsumm]);
  stSummaFact.Caption:=Format('%8.2f',[allsummFact]);
  if (flutmver='+') or (flUTMVer ='1') then caption:='Поступление UTM v2'
  else begin
    if (flUTMVer='3') then
       Caption:='Поступление версия 3'
      else
       caption:='Поступление ';

  end;
  StringGrid1.Clear;
  StringGrid1.RowCount:=1;
  xrecbuf:=formStart.DB_query('SELECT `alccode` ,'+
  ' (SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode` = `alccode` LIMIT 1 ) AS `name`,'+
  '`forma` ,`formb`, `packet`,'+
  '`fixmark`,`accept` FROM `doc221fix` WHERE `numdoc`="'+DocNumber+'" AND `datedoc`="'+DocDate+'" AND `docid`="'+Docid+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=i+1;
    StringGrid1.Cells[1,i]:=xRowBuf[0];
    StringGrid1.Cells[2,i]:=xRowBuf[1];
    StringGrid1.Cells[3,i]:=xRowBuf[2];
    StringGrid1.Cells[4,i]:=xRowBuf[3];
    StringGrid1.Cells[5,i]:=xRowBuf[4];
    StringGrid1.Cells[6,i]:=xRowBuf[5];
    StringGrid1.Cells[0,i]:=xRowBuf[6];
    xrowbuf:= formStart.DB_Next(xrecbuf);
  end;
end;

procedure TFormBuyTTH.ListView1AdvancedCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  r2,r:tRect;
  i:integer;
begin
  if ((Listview1.Selected = item)And(fledit))and(SubItem=3) then
  begin
    r:=item.DisplayRectSubItem(SubItem,drBounds);
    r2:=listview1.ReadBounds;
    Edit1.SetBounds(r2.Left+r.Left,r2.Top+r.Top,r.Right-r.Left+2,r.Bottom-r.Top);
    Edit1.Text:=item.SubItems.strings[SubItem-1];
    Edit1.visible :=fledit;
    DefaultDraw:= not fledit;
    self.ActiveControl:=TWinControl(Edit1);
  end;
end;

procedure TFormBuyTTH.ListView1Click(Sender: TObject);
begin
  fledit:=false;
  Edit1.visible :=fledit;
end;

procedure TFormBuyTTH.ListView1DblClick(Sender: TObject);
var
  r2,r:tRect;
  i:integer;

begin
    if Listview1.Selected = nil then
      exit;
    fledit:=true;
    r:=Listview1.Selected.DisplayRectSubItem(5,drBounds);
    r2:=listview1.ReadBounds;
    Edit1.SetBounds(r2.Left+r.Left,r2.Top+r.Top,r.Right-r.Left+2,r.Bottom-r.Top);
    Edit1.Text:=Listview1.Selected.SubItems.strings[2];
    Edit1.visible :=fledit;
    self.ActiveControl:=TWinControl(Edit1);
end;

procedure TFormBuyTTH.ListView1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    // ==== Вход в редактирование ====
    ListView1DblClick(nil);
  end;

end;

procedure TFormBuyTTH.ListView1MouseEnter(Sender: TObject);
begin

end;

procedure TFormBuyTTH.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    begin
      stTovar.Caption:=item.SubItems.strings[0];
      stFormA.Caption:=item.SubItems.strings[6];
      stFormB.Caption:=item.SubItems.strings[7];
    end;
end;

procedure TFormBuyTTH.MenuItem1Click(Sender: TObject);
begin
   // === Вызов Справки А  ====
  if listview1.Selected<>nil then begin
    formeditforma.fAlcCode   :=listview1.Selected.SubItems.Strings[8];
    formeditforma.fName      :=listview1.Selected.SubItems.Strings[0];
    formeditforma.fEGAISFormA:=listview1.Selected.SubItems.Strings[6];
    formeditforma.fEGAISFormB:=listview1.Selected.SubItems.Strings[7];
    formeditforma.fDocNum    :=DocNumber;
    formeditforma.ShowModal;
  end;
end;

procedure TFormBuyTTH.MenuItem2Click(Sender: TObject);
begin
  if listview1.Selected<>nil then begin
    FormStart.QueryFormA(listview1.Selected.SubItems.Strings[6]);
    showmessage('Запрос Справки А отправлен!');
  end;
end;

procedure TFormBuyTTH.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin

end;

end.

