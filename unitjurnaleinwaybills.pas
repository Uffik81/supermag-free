unit unitJurnaleInWayBills;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  Grids, Menus, mysql50;

type

  { TFormJurnaleInWayBills }

  TFormJurnaleInWayBills = class(TForm)
    BitBtn12: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    MenuItem35: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem62: TMenuItem;
    miQueryListDocs: TMenuItem;
    miQueryTTN: TMenuItem;
    miReturnTTN: TMenuItem;
    miTransferShop: TMenuItem;
    mpQueryTTN: TPopupMenu;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    ToolBar2: TToolBar;
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure miQueryListDocsClick(Sender: TObject);
    procedure miQueryTTNClick(Sender: TObject);
    procedure miReturnTTNClick(Sender: TObject);
    procedure miTransferShopClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public
    startDateInTTN,
    endDateInTTN:TdateTime;
    procedure refreshJurnaleIn();
  end;

var
  FormJurnaleInWayBills: TFormJurnaleInWayBills;

implementation

{$R *.lfm}
uses
  unitfilter
  ,unitstart,
  unitexportdecalc,
  unitjurnale
  ,unitBuyTTH
  ,unitticket
  ,unitreturnttn
  ,unittransfercash
  ,unitResendDoc;

{ TFormJurnaleInWayBills }

procedure TFormJurnaleInWayBills.FormShow(Sender: TObject);
begin
  refreshJurnaleIn();
end;

procedure TFormJurnaleInWayBills.MenuItem35Click(Sender: TObject);
var
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  query:string;
  accept:string;
  i1:integer;
begin
  // === Пометить на удаление исходящие документы ===
  if StringGrid1.Row>0 then begin
     //isDelete
   accept:='';
   Query:='SELECT `ClientAccept`, `status` FROM `docjurnale` WHERE (`numdoc`="'+StringGrid1.Cells[1,StringGrid1.Row]+'")AND(`datedoc`="'+StringGrid1.Cells[2,StringGrid1.Row]+'" AND `DocId`="'+StringGrid1.Cells[7,StringGrid1.Row]+'");';
   xrecbuf := formStart.DB_query(Query);
   xrowbuf := formStart.DB_Next(xrecbuf);
   if xrowbuf<>nil then
     accept:=xrowbuf[0];
   if accept='+' then
    begin
     showmessage('Нельзя удалить принятый клиентом документ!');
     exit;
     end ;
  i1:=MessageDlg('Уверены что хотите пометить на удаление?',mtConfirmation,mbYesNo,0);
  if i1 = 6 then
  begin
     Query:='UPDATE `docjurnale` SET `isdelete`="+" WHERE (`numdoc`="'+StringGrid1.Cells[1,StringGrid1.Row]+'")AND(`datedoc`="'+StringGrid1.Cells[2,StringGrid1.Row]+'" AND `DocId`="'+StringGrid1.Cells[7,StringGrid1.Row]+'");';
     xrecbuf := formStart.DB_query(Query);
    end;
  end;

end;

procedure TFormJurnaleInWayBills.MenuItem39Click(Sender: TObject);
var
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  query:string;
begin
  // ==== как принятый ===
  if StringGrid1.Row>0 then begin
     Query:='UPDATE `docjurnale` SET `status`="+++" WHERE (`numdoc`="'+StringGrid1.Cells[1,StringGrid1.Row]+'")AND(`datedoc`="'+StringGrid1.Cells[2,StringGrid1.Row]+'");';
     xrecbuf := formStart.DB_query(Query);
   end;


end;

procedure TFormJurnaleInWayBills.MenuItem4Click(Sender: TObject);
begin
  StringGrid1DblClick(Sender);
end;

procedure TFormJurnaleInWayBills.MenuItem5Click(Sender: TObject);
var
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  Query,
  uid:String;
begin
    // Обработка Сообщений ЕГАИС
  if StringGrid1.Row>0 then begin
     Query:='SELECT WBregId FROM `docjurnale` WHERE (`numdoc`="'+StringGrid1.Cells[1,StringGrid1.Row]+'")AND(`datedoc`="'+StringGrid1.Cells[2,StringGrid1.Row]+'");';
     xrecbuf := formStart.DB_query(Query);
     xrowbuf := formStart.DB_Next(xrecbuf);
     if xrowbuf<>nil then
       uid:=xrowbuf[0];
     formticket.DocNum:=StringGrid1.Cells[1,StringGrid1.Row];
     formticket.DocDate:=StringGrid1.Cells[2,StringGrid1.Row];
     if uid<>'' then begin
       formTicket.WBRegID:= uid;
       formTicket.uid:= uid;
       formTicket.ShowModal;
     end;
  end;
end;

procedure TFormJurnaleInWayBills.miQueryListDocsClick(Sender: TObject);
var
  i:integer;
    status1:String;
    query:string;
        sLine:TStringList;
begin
  i:=1;
   sLine:=TStringList.Create();
       sLine.Clear;
       sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
       sLine.Add('<ns:Documents Version="1.0"');
       sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
       sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
       sLine.Add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
       sLine.Add('<ns:Owner>');
       sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
       sLine.Add('</ns:Owner>');
       sLine.Add('<ns:Document>');
       sLine.Add('<ns:QueryNATTN> ');
       sLine.Add('<qp:Parameters>');
       sLine.Add('<qp:Parameter>');
       sLine.Add('<qp:Name>КОД</qp:Name>');
       sLine.Add('<qp:Value>'+FormStart.EgaisKod+'</qp:Value>');
       sLine.Add('</qp:Parameter>');
       sLine.Add('</qp:Parameters>');
       sLine.Add('</ns:QueryNATTN> ');
       sLine.Add('</ns:Document>');
       sLine.Add('</ns:Documents>');
       status1:=formStart.SaveToServerPOST('opt/in/QueryNATTN',SLine.text);
       status1:=formStart.getXMLtoURL(status1);
       if status1<>'' then
        ShowMessage('Запрос отправлен!')
        else
          ShowMessage('При отправке запроса возникла ошибка!');
  sLine.Free;


end;

procedure TFormJurnaleInWayBills.miQueryTTNClick(Sender: TObject);
begin
    formResendDoc.ShowModal;
end;

procedure TFormJurnaleInWayBills.miReturnTTNClick(Sender: TObject);
begin
  // ===== возврат поставщику =====
  if StringGrid1.Row>0 then begin
    formreturnTTN.inDocNumber:=StringGrid1.Cells[1,StringGrid1.Row];
    formreturnTTN.inDocDate:=StringGrid1.Cells[2,StringGrid1.Row];
    formreturnTTN.Docid:= StringGrid1.Cells[7,StringGrid1.Row];
    formreturnTTN.CreateDoc(nil);
    formreturnTTN.ShowModal;
  end;
end;

procedure TFormJurnaleInWayBills.miTransferShopClick(Sender: TObject);
begin
  if StringGrid1.Row>0 then begin
    FormTransferCash.wbnumDoc:=StringGrid1.Cells[1,StringGrid1.Row];
    FormTransferCash.wbDateDoc:=StringGrid1.Cells[2,StringGrid1.Row];
    FormTransferCash.wbDocid:=StringGrid1.Cells[7,StringGrid1.Row];
    FormTransferCash.showmodal;
  end;
end;

procedure TFormJurnaleInWayBills.StringGrid1DblClick(Sender: TObject);
begin
    // ==== выбрали приход ====
  if StringGrid1.Row>0 then begin
    formBuyTTH.DocNumber:= StringGrid1.Cells[1,StringGrid1.Row];
    formBuyTTH.DocDate:= StringGrid1.Cells[2,StringGrid1.Row];
    formBuyTTH.DocKontr:= StringGrid1.Cells[4,StringGrid1.Row];
    formBuyTTH.Docid:= StringGrid1.Cells[7,StringGrid1.Row];
    formBuyTTH.ShowModal;
  end;
end;

procedure TFormJurnaleInWayBills.BitBtn1Click(Sender: TObject);
begin
  Cursor:=crSQLWait;
  if formStart.flUpdateAdmin then begin
   if not formStart.flAsAdmin then
     exit;
  end;
  if formStart.flOptMode then begin
    formStart.loadFromFileTTN();
  end;
  FormStart.refreshEGAIS();
  FormJurnale.StatusBar1.Panels.Items[0].Text:='Обновили!';
  refreshJurnaleIn();
  Cursor:=crDefault;
end;

procedure TFormJurnaleInWayBills.BitBtn14Click(Sender: TObject);
// ==== повторный запрос ТТН 2.0.2 УТМ
var
  r:TPoint;
begin
  r:=BitBtn14.ClientOrigin;
  mpQueryTTN.PopUp(r.x,r.y+BitBtn14.Height);

end;

procedure TFormJurnaleInWayBills.BitBtn24Click(Sender: TObject);
var
  i:integer;
    status1:String;
    query:string;
        sLine:TStringList;
begin
  i:=1;
   sLine:=TStringList.Create();
       sLine.Clear;
       sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
       sLine.Add('<ns:Documents Version="1.0"');
       sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
       sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
       sLine.Add(' xmlns:qp="http://fsrar.ru/WEGAIS/QueryParameters">');
       sLine.Add('<ns:Owner>');
       sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
       sLine.Add('</ns:Owner>');
       sLine.Add('<ns:Document>');
       sLine.Add('<ns:QueryNATTN> ');
       sLine.Add('<qp:Parameters>');
       sLine.Add('<qp:Parameter>');
       sLine.Add('<qp:Name>КОД</qp:Name>');
       sLine.Add('<qp:Value>'+FormStart.EgaisKod+'</qp:Value>');
       sLine.Add('</qp:Parameter>');
       sLine.Add('</qp:Parameters>');
       sLine.Add('</ns:QueryNATTN> ');
       sLine.Add('</ns:Document>');
       sLine.Add('</ns:Documents>');
       status1:=formStart.SaveToServerPOST('opt/in/QueryNATTN',SLine.text);
       status1:=formStart.getXMLtoURL(status1);
       if status1<>'' then
        ShowMessage('Запрос отправлен!')
        else
          ShowMessage('При отправке запроса возникла ошибка!');
  sLine.Free;


end;

procedure TFormJurnaleInWayBills.BitBtn7Click(Sender: TObject);
begin
  if FormFilter.ShowModal = 1377 then begin
    startDateInTTN:= FormFilter.StartDate;
    endDateInTTN  := FormFilter.EndDate;

    BitBtn7.Hint:='Фильтр по дате:'+FormatDateTime('DD-MM-YYYY',StartDateInTTN)+' - '+FormatDateTime('DD-MM-YYYY',endDateInTTN)+'';
    refreshJurnaleIn();
  end;
end;

procedure TFormJurnaleInWayBills.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    CloseAction:=caHide;
end;

procedure TFormJurnaleInWayBills.FormCreate(Sender: TObject);
begin
  endDateInTTN:=now();
  StartDateInTTN:=now();

end;

procedure TFormJurnaleInWayBills.refreshJurnaleIn();
var
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  status1:string;
  Reg:string;
  CurDate:TDateTime;
  sDate:String;
  Query:String;
  ind:integer;
begin
  StringGrid1.RowCount:=1;
  Query:='SELECT `dateDoc`,`type`,`numdoc`,`summa`,`ClientName`,`status`,`docid`,`WBregID`,`utmv2`'+
        ' FROM `docjurnale` WHERE ((`type`="WayBill" )OR (`type`="RetWayBill")) AND (`registry`="+")'+
        'AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateInTTN)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateInTTN)+''') ORDER BY `datedoc` ASC ;';
  xrecbuf :=formStart.DB_query(Query) ;
  xrowbuf := formStart.DB_next(xrecbuf);
  while xrowbuf<>nil do
   begin
   //  sDate:=DefaultFormatSettings.ShortDateFormat;
     sDate := xrowbuf[0];
     sDate:= sDate[9]+sDate[10]+'.'+sDate[6]+sDate[7]+'.'+sDate[1]+sDate[2]+sDate[3]+sDate[4] ;
     CurDate:=StrToDate(sDate);
     if (startDateInTTN<=Curdate)and(curdate<=endDateInTTN) then  begin
       reg:=xrowbuf[1];
       ind:=StringGrid1.RowCount;
       StringGrid1.RowCount:=ind+1;
         StringGrid1.Cells[1,ind]:= xrowbuf[2];
         StringGrid1.Cells[2,ind]:= xrowbuf[0];         //3
         StringGrid1.Cells[3,ind]:= xrowbuf[3];
         StringGrid1.Cells[4,ind]:= xrowbuf[4];         //4
         status1:= xrowbuf[5];
          if status1[1] = '0' then
            StringGrid1.Cells[5,ind]:= 'Ошибка при отправке';
         if status1[1] = '-' then
            StringGrid1.Cells[5,ind]:='Новый';
         if status1[2] = '+' then
            StringGrid1.Cells[5,ind]:='Отправлен в ЕГАИС';
         case status1[3] of
         '1':StringGrid1.Cells[6,ind]:='Отказ в ЕГАИС';
         '2':StringGrid1.Cells[6,ind]:='Отказ в ЕГАИС';
         '+':StringGrid1.Cells[6,ind]:='Принят в ЕГАИС'
            else
            StringGrid1.Cells[6,ind]:='';
         end;

         StringGrid1.Cells[7,ind]:=xrowbuf[6];
         if xrowbuf[1]='RetWayBill' then StringGrid1.Cells[8,ind]:='Возврат'
                                    else StringGrid1.Cells[8,ind]:='Поступление';
         StringGrid1.Cells[9,ind]:= xrowbuf[8];

       end;
     xrowbuf := formStart.DB_next(xrecbuf);
   end ;
end;

end.

