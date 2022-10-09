unit unitJurnaleStocks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, Buttons,
  ComCtrls, Grids, StdCtrls, ExtCtrls, IpHtml, Types,mysql50, LCLType;

type

  { TFormJurnaleStocks }

  TFormJurnaleStocks = class(TForm)
    BitBtn10: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    ilDocIcons: TImageList;
    MenuAddGoods: TMenuItem;
    miShowFromTransfer: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuSubGoods: TMenuItem;
    miExportXLS: TMenuItem;
    miFullReportRest: TMenuItem;
    miInventShop: TMenuItem;
    miQueryRest1: TMenuItem;
    miQueryShopRest1: TMenuItem;
    miShowRest1: TMenuItem;
    miSmallReportRest: TMenuItem;
    miWriteOffShop: TMenuItem;
    miWriteOnShop: TMenuItem;
    pmRestOwner1: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    sgShopRest: TStringGrid;
    ToolBar3: TToolBar;
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MenuAddGoodsClick(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem63Click(Sender: TObject);
    procedure MenuItem64Click(Sender: TObject);
    procedure MenuItem65Click(Sender: TObject);
    procedure MenuItem66Click(Sender: TObject);
    procedure MenuSubGoodsClick(Sender: TObject);
    procedure miExportXLSClick(Sender: TObject);
    procedure miFullReportRestClick(Sender: TObject);
    procedure miInventShopClick(Sender: TObject);
    procedure miQueryRest1Click(Sender: TObject);
    procedure miQueryShopRest1Click(Sender: TObject);
    procedure miShowRest1Click(Sender: TObject);
    procedure miShowFromTransferClick(Sender: TObject);
    procedure miSmallReportRestClick(Sender: TObject);
    procedure miWriteOffShopClick(Sender: TObject);
    procedure miWriteOnShopClick(Sender: TObject);
    procedure sgShopRestClick(Sender: TObject);
    procedure sgShopRestDblClick(Sender: TObject);
    procedure sgShopRestDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);

  private

  public
    startdateStock:TdateTime;  // начальный период складских документов
    endDateStock:TdateTime;

    procedure refreshStock();
  end;

var
  FormJurnaleStocks: TFormJurnaleStocks;

implementation

{$R *.lfm}
uses unitStart
  ,unitreportoborot
  ,unitUpdateTransfer
  ,unitActChargeOnShop
  ,unitActWriteOffShop
  ,unitActWriteOff
  ,unitInv2
  ,unitshoptotransfer
  ,unitInventShop
  ,unitWayBillv2
  ,unittransfertoshop
  ,unitFilter
  ,unitInvent
  ,unitTicket
  ,unitOstatok;
{ TFormJurnaleStocks }

procedure TFormJurnaleStocks.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormJurnaleStocks.MenuAddGoodsClick(Sender: TObject);
begin
  FormInvent.ShowModal;
  refreshStock();
end;

procedure TFormJurnaleStocks.MenuItem15Click(Sender: TObject);
var
  s1:string;
begin
  if sgShopRest.Row>0 then begin
   s1:=sgShopRest.Cells[5,sgShopRest.Row];
   formTicket.uid:=s1;
   formTicket.WBRegID:=s1;
   formTicket.DocDate:=sgShopRest.Cells[2,sgShopRest.Row];
   formTicket.DocNum:=sgShopRest.Cells[7,sgShopRest.Row];
   formTicket.ShowModal;
  end;

end;

procedure TFormJurnaleStocks.MenuItem18Click(Sender: TObject);
begin
  // === Инвентаризация ===
  formInv2.flNew:=true;
  FormInv2.NumDoc:='';
  formInv2.ShowModal;
  refreshStock();
end;

procedure TFormJurnaleStocks.MenuItem63Click(Sender: TObject);
begin
  formshoptotransfer.NowDocument();
end;

procedure TFormJurnaleStocks.MenuItem64Click(Sender: TObject);
begin
  formInventShop.NewDocAP();
  refreshStock();
end;

procedure TFormJurnaleStocks.MenuItem65Click(Sender: TObject);
begin
  formInventShop.NewDocBeer();
end;

procedure TFormJurnaleStocks.MenuItem66Click(Sender: TObject);
begin

end;

procedure TFormJurnaleStocks.MenuSubGoodsClick(Sender: TObject);
begin
  //hide;
  formActWriteOff.Edit1.Text:='';
  formActWriteOff.DateTimePicker1.Date:=now();
  formActWriteOff.ShowModal;
  //show;
  refreshStock();
end;

procedure TFormJurnaleStocks.miExportXLSClick(Sender: TObject);
begin
  FormReprotOborot.BitBtn5Click(Sender);
end;

procedure TFormJurnaleStocks.miFullReportRestClick(Sender: TObject);
begin
    FormReprotOborot.BitBtn2Click(Sender);
end;

procedure TFormJurnaleStocks.miInventShopClick(Sender: TObject);
begin
  formInventShop.NewDoc();
  refreshStock();
end;

procedure TFormJurnaleStocks.miQueryRest1Click(Sender: TObject);
begin
FormStart.readOstatok();
FormStart.fshowMessage('Запрос отправлен в ЕГАИС');
end;

procedure TFormJurnaleStocks.miQueryShopRest1Click(Sender: TObject);
begin
  FormUpdateTransfer.UpdateBalance
end;

procedure TFormJurnaleStocks.miShowRest1Click(Sender: TObject);
begin
  formOstatok.ShowModal;
end;

procedure TFormJurnaleStocks.miShowFromTransferClick(Sender: TObject);
begin

end;

procedure TFormJurnaleStocks.miSmallReportRestClick(Sender: TObject);
begin
    FormReprotOborot.BitBtn1Click(Sender);
end;

procedure TFormJurnaleStocks.miWriteOffShopClick(Sender: TObject);
begin
    //hide;
    FormActWriteOffShop.DateDoc:='';
    FormActWriteOffShop.NumDoc:='';
    FormActWriteOffShop.flNew:=true;
    FormActWriteOffShop.ShowModal;
    refreshStock();
    //show;
end;

procedure TFormJurnaleStocks.miWriteOnShopClick(Sender: TObject);
begin
    // ==== $$$$ Оприходование в торговый зал =====
    FormActChargeOnShop.NewDocument();;
    refreshStock();
end;



procedure TFormJurnaleStocks.sgShopRestClick(Sender: TObject);
begin
    if sgSHopRest.Cells[8,sgSHopRest.row]='ActTransferOnShop' then begin
        miShowFromTransfer.Enabled:=true;
    end
    else
        miShowFromTransfer.Enabled:=False;
end;

procedure TFormJurnaleStocks.BitBtn3Click(Sender: TObject);
begin
  refreshStock();
end;

procedure TFormJurnaleStocks.BitBtn13Click(Sender: TObject);
begin
    formstart.AutotransferToShop;
end;

procedure TFormJurnaleStocks.BitBtn18Click(Sender: TObject);
begin
if FormFilter.ShowModal = 1377 then begin
  startDateStock:= FormFilter.StartDate;
  endDateStock  := FormFilter.EndDate;
 // tsSprGoods.Caption:='Главный склад ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
  //tsAlcDecl.Caption:='Торговый зал ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
  refreshStock();

end;
end;

procedure TFormJurnaleStocks.BitBtn27Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn27.ClientOrigin;
  pmrestOwner1.PopUp(r.x,r.y+BitBtn27.Height);

end;

procedure TFormJurnaleStocks.BitBtn4Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn4.ClientOrigin;
  PopupMenu5.PopUp(r.x,r.y+BitBtn4.Height);
end;

procedure TFormJurnaleStocks.sgShopRestDblClick(Sender: TObject);
var
  query:string;
  xrowbuf2 : MYSQL_ROW;
  xrecbuf2 : PMYSQL_RES;
  query1:string;
  xrowbuf1 : MYSQL_ROW;
  xrecbuf1 : PMYSQL_RES;
  i:integer;
begin
  if sgSHopRest.Cells[8,sgSHopRest.row]='ActShopFromTransfer' then begin
     formshoptotransfer.OpenDocument(sgSHopRest.Cells[7,sgSHopRest.row],sgSHopRest.Cells[2,sgSHopRest.row]);
  end;
  if sgSHopRest.Cells[8,sgSHopRest.row]='ActChargeOnShop' then begin
   FormActChargeOnShop.flNew:=false;
   FormActChargeOnShop.NumDoc:=sgSHopRest.Cells[7,sgSHopRest.row];
   FormActChargeOnShop.DateDoc:=sgSHopRest.Cells[2,sgSHopRest.row];
   FormActChargeOnShop.ShowModal;
  end;
  if sgSHopRest.Cells[8,sgSHopRest.row]='ActWriteOffShop' then begin
    FormActWriteOffShop.flEditing:=false;
    FormActWriteOffShop.flNew:=false;
    FormActWriteOffShop.edNumDoc.Text:=sgSHopRest.Cells[7,sgSHopRest.row];
    FormActWriteOffShop.dpDateDoc.Date:=formstart.Str1ToDate(sgSHopRest.Cells[2,sgSHopRest.row]);
    FormActWriteOffShop.NumDoc:=sgSHopRest.Cells[7,sgSHopRest.row];
    FormActWriteOffShop.DateDoc:=sgSHopRest.Cells[2,sgSHopRest.row];
    hide;
    FormActWriteOffShop.showmodal;
    show;
    exit;
  end;
  if sgSHopRest.Cells[8,sgSHopRest.row]='InventShop' then begin
     FormInventShop.opendoc(sgSHopRest.Cells[7,sgSHopRest.row],sgSHopRest.Cells[2,sgSHopRest.row]);
  end;

  if sgSHopRest.Cells[8,sgSHopRest.row] = 'ActWriteOff' then
  begin
    formActWriteOff.DateTimePicker1.Date:=formstart.Str1ToDate(sgSHopRest.Cells[2,sgSHopRest.row]);
    formActWriteOff.Edit1.Text:=sgSHopRest.Cells[7,sgSHopRest.row];
    formActWriteOff.numdoc:=sgSHopRest.Cells[7,sgSHopRest.row];
    formActWriteOff.datedoc:=sgSHopRest.Cells[2,sgSHopRest.row];
    formActWriteOff.ListView1.Clear;
    Query:='SELECT `doc23`.`markplomb`,(SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode` = `doc23`.`alccode` LIMIT 1 ) AS `name`,'+
    '`doc23`.`alccode`,`doc23`.`formb`,`doc23`.`forma` , `doccash`.`numcheck`,`doccash`.`price`  FROM `doc23`, `doccash`  WHERE '+
    '`doc23`.`numdoc`="'+sgSHopRest.Cells[7,sgSHopRest.row]+'" AND `doc23`.`datedoc`="'+sgSHopRest.Cells[2,sgSHopRest.row]+'" '+
    'And `doccash`.`urlegais`=`doc23`.`markplomb` and `doccash`.`typetrans`="11";';
    xrecbuf2 := formStart.DB_query(Query);
    xrowbuf2 := formStart.DB_Next(xrecbuf2);
    i:=0;
    while xrowbuf2<>nil do begin
     // formActWriteOff.ListView1.Add(formStart.rowbuf[0]);
       //formActWriteOff.add_fixmark_to_listview(xrowbuf2[0]);
       with formActWriteOff.listview1.Items.Add do begin
           caption:=InTToStr(formActWriteOff.ListView1.items.count);
           subitems.Add(xrowbuf2[1]);
           subitems.Add(xrowbuf2[3]);
           subitems.Add(xrowbuf2[0]);
           subitems.Add('1');
           subitems.Add('0');
           subitems.Add('0');
           subitems.Add(xrowbuf2[5]);
           subitems.Add(xrowbuf2[2]);
           subitems.Add(xrowbuf2[4]);
           subitems.Add(xrowbuf2[6]);
       end;
       xrowbuf2 := formStart.DB_Next(xrecbuf2);
       inc(i);
    end;
    Query:='SELECT `status` FROM `docx23` WHERE `numdoc` like "'+sgSHopRest.Cells[7,sgSHopRest.row]+'" AND `datedoc`="'+sgSHopRest.Cells[2,sgSHopRest.row]+'";';
    formStart.recbuf := formStart.DB_query(Query);
    formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
    if formStart.rowbuf<>nil then begin
     formActWriteOff.ComboBox1.Text:=formActWriteOff.ComboBox1.Items.Strings[strtoint(formStart.rowbuf[0])];
    end;
    formActWriteOff.ShowModal;
    formActWriteOff.flReadOnly:=false;
    exit;
  end;
 if sgSHopRest.Cells[8,sgSHopRest.row] = 'InventRest' then   begin
     formInv2.flNew:=false;
     FormInv2.NumDoc:=sgSHopRest.Cells[7,sgSHopRest.row];
     FormInv2.DateDoc:= sgSHopRest.Cells[2,sgSHopRest.row];
     formInv2.ShowModal;
     formInv2.flReadOnly:=false;
     exit;
 end;
 if sgSHopRest.Cells[8,sgSHopRest.row] = 'ActChargeOnShop' then   begin
     FormActChargeOnShop.flNew:=false;
     FormActChargeOnShop.NumDoc:= sgSHopRest.Cells[7,sgSHopRest.row];
     FormActChargeOnShop.DateDoc:= sgSHopRest.Cells[2,sgSHopRest.row] ;
     FormActChargeOnShop.edNumDoc.text:=sgSHopRest.Cells[7,sgSHopRest.row];
     FormActChargeOnShop.dpDateDoc.Date:=formstart.Str1ToDate( sgSHopRest.Cells[2,sgSHopRest.row]);
     FormActChargeOnShop.ShowModal;
     exit;
 end;
 if sgSHopRest.Cells[8,sgSHopRest.row] = 'MoveWayBill' then   begin
     FormWayBillv2.OpenDocument(sgSHopRest.Cells[7,sgSHopRest.row],sgSHopRest.Cells[2,sgSHopRest.row]);
   End;
 if sgSHopRest.Cells[8,sgSHopRest.row] = 'ActTransferOnShop' then   begin
   // =====
   i:=1;
   formtransfertoshop.edNumDoc.text:= sgSHopRest.Cells[7,sgSHopRest.row];
   formtransfertoshop.dpDateDoc.date:= formstart.Str1ToDate(sgSHopRest.Cells[2,sgSHopRest.row]);
   Query:='SELECT `alccode`,(SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode`=`doc27`.`alccode` LIMIT 1)AS `name`,`form2`,`count`,`crdate` FROM `doc27` WHERE `numdoc`="'+sgSHopRest.Cells[7,sgSHopRest.row]+'" AND `datedoc`="'+sgSHopRest.Cells[2,sgSHopRest.row]+'";';
     formtransfertoshop.StringGrid1.Clean;
     formtransfertoshop.StringGrid1.RowCount:=1;
     formStart.recbuf := formStart.DB_query(Query);
   formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
   while formStart.rowbuf<>nil do begin
     i:=formtransfertoshop.StringGrid1.RowCount;
     formtransfertoshop.StringGrid1.RowCount:=i+1;
     formtransfertoshop.StringGrid1.Cells[1,i]:=formStart.rowbuf[1];
     formtransfertoshop.StringGrid1.Cells[2,i]:=formStart.rowbuf[0];
     formtransfertoshop.StringGrid1.Cells[3,i]:=formStart.rowbuf[2];
     formtransfertoshop.StringGrid1.Cells[4,i]:=formStart.rowbuf[3];
     formtransfertoshop.StringGrid1.Cells[5,i]:=formStart.rowbuf[4];
     formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     i:=i+1;
   end;
   formtransfertoshop.flEditing:=false;
     formtransfertoshop.showmodal;
 end;

end;

procedure TFormJurnaleStocks.sgShopRestDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if aCol=0 then
     ilDocIcons.Draw(sgShopRest.Canvas,aRect.Left+(aRect.Right-aRect.Left-20) div 2,aRect.Top+(aRect.Bottom-aRect.Top-20) div 2,0);

end;

procedure TFormJurnaleStocks.refreshStock();
// ==== журнал Торгового склада ====
var
i:integer;
  status1:String;
Query:String ;
comment1:string;
DocType:string;
xrowbuf:MYSQL_ROW;
xrecbuf:PMYSQL_RES;
begin
i:=1;
SgShoprest.RowCount:=1;
if not formStart.ConnectDB() then
  exit;
// if ToggleBox1.Checked then                                                                                                           (`type`=''ActTransferOnShop'')OR(`type`=''InventRest'')OR      OR(`type`=''ActTransferOnShop'')
Query:='SELECT `type`,`numdoc`,`dateDoc`,`status`,`uid`,`comment`,`type` FROM `docjurnale` WHERE ((`type`=''ActWriteOffShop'')OR(`type`=''ActChargeOnShop'')OR(`type`="ActChargeOn")OR(`type`="ActTransferOnShop")OR(`type`="ActWriteOff")OR(`type`="QueryHistoryFormB")OR(`type`="InventRest")OR(`type`="InventShop")OR(`type`="ActShopFromTransfer")OR(`type`="MoveWayBill"))AND'+
'(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateStock)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateStock)+''') ORDER BY `dateDoc` ASC;';
xrecbuf := formstart.DB_Query(Query);
xrowbuf := formstart.DB_Next(xrecbuf);
while xrowbuf<>nil do
 begin
   comment1:='';
   SgShoprest.RowCount:=i+1;
   //     with SgShoprest.Rows[i] do begin
   //       add('');
   DocType:= xrowbuf[0];
   case DocType of
     'ActTransferOnShop': begin
         comment1:= 'Главный склад';
         SgShoprest.Cells[1,i]:='Перемещение в торговый зал '+xrowbuf[1];
      end;
    'QueryHistoryFormB':
              SgShoprest.Cells[1,i]:='Оборот по FB-'+xrowbuf[1];
    'ActWriteOffShop': begin
                  comment1:= 'Торговый зал';
                  SgShoprest.Cells[1,i]:='Списание '+xrowbuf[1];
      end;
    'InventRest': begin
                     comment1:= 'Главный склад';
                     SgShoprest.Cells[1,i]:='Инвентаризация '+xrowbuf[1];
      end;
    'InventShop': begin
                     comment1:= 'Торговый зал';
                     SgShoprest.Cells[1,i]:='Инвентаризация '+xrowbuf[1];
      end;
    'ActChargeOn': begin
                       comment1:= 'Главный склад';
                      SgShoprest.Cells[1,i]:='Оприходование  '+xrowbuf[1];
      end;
    'ActWriteOff': begin
         comment1:= 'Главный склад';
                           SgShoprest.Cells[1,i]:='Списание  '+xrowbuf[1];
      end;
    'ActChargeOnShop':begin
                            comment1:= 'Торговый зал';
                            SgShoprest.Cells[1,i]:='Оприходование '+xrowbuf[1];

      end;
    'ActShopFromTransfer': begin
                            comment1:= 'Торговый зал';
                            SgShoprest.Cells[1,i]:='Перемещение '+xrowbuf[1];
      end;
    'MoveWayBill': begin
        comment1:= 'Главный склад';
        SgShoprest.Cells[1,i]:='Перемещение '+xrowbuf[1];
     end;
    else
    end;
    SgShoprest.Cells[2,i]:=xrowbuf[2];         //3
          status1:= xrowbuf[3];
          SgShoprest.Cells[4,i]:='';
          case status1[1] of
          '0': begin
                SgShoprest.Cells[3,i]:='Ошибка при отправке';

               end;
          '-': begin
              SgShoprest.Cells[3,i]:='Новый'; end;
          '1': begin SgShoprest.Cells[3,i]:='Готов к отправке!'; end;
          '+': begin
            SgShoprest.Cells[3,i]:='Отправлен в ЕГАИС';
            if status1[3] = '+' then
                 SgShoprest.Cells[4,i]:='Принят в ЕГАИС';
            //subitems.Add('');
          end
          else
            SgShoprest.Cells[3,i]:=''
          end;
    //      subitems.Add('');
          SgShoprest.Cells[5,i]:=xrowbuf[4];
          SgShoprest.Cells[6,i]:=comment1;//formStart.rowbuf[5];
          SgShoprest.Cells[7,i]:=xrowbuf[1];
          SgShoprest.Cells[8,i]:=xrowbuf[6];
         i:=i+1;
       // end;
   xrowbuf := formstart.DB_Next(xrecbuf);
 end ;

end;

end.

