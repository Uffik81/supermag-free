unit unitJurnaleReturnWaybill;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ComCtrls,
    Buttons, mysql50;

type

    { TFormJurnaleReturnWaybill }

    TFormJurnaleReturnWaybill = class(TForm)
        BitBtn18: TBitBtn;
        BitBtn27: TBitBtn;
        BitBtn3: TBitBtn;
        BitBtn4: TBitBtn;
        StringGrid1: TStringGrid;
        ToolBar3: TToolBar;
        procedure BitBtn18Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
        procedure FormShow(Sender: TObject);
        procedure StringGrid1DblClick(Sender: TObject);
    private
        startDateInTTN:TDateTime;
        EndDateInTTN:TDateTime;
    public

    end;

var
    FormJurnaleReturnWaybill: TFormJurnaleReturnWaybill;

implementation

{$R *.lfm}
uses

    unitstart,
    unitTicket,
    unitFilter,
    unitreturnttn;

{ TFormJurnaleReturnWaybill }

procedure TFormJurnaleReturnWaybill.FormClose(Sender: TObject;
    var CloseAction: TCloseAction);
begin
    CloseAction:=caHide;
end;

procedure TFormJurnaleReturnWaybill.BitBtn18Click(Sender: TObject);
begin
    if FormFilter.ShowModal = 1377 then begin
        startDateInTTN:= FormFilter.StartDate;
        EndDateInTTN  := FormFilter.EndDate;
        // tsSprGoods.Caption:='Главный склад ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
        //tsAlcDecl.Caption:='Торговый зал ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
        FormShow(nil);

    end;
end;

procedure TFormJurnaleReturnWaybill.FormShow(Sender: TObject);
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
        ' FROM `docjurnale` WHERE ((`type`="WayBill" )OR (`type`="RetWayBill")) AND (`registry`="-")'+
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

procedure TFormJurnaleReturnWaybill.StringGrid1DblClick(Sender: TObject);
begin
        // ==== выбрали приход ====
  if StringGrid1.Row>0 then begin
    FormReturnTTN.DocNumber:= StringGrid1.Cells[1,StringGrid1.Row];
    FormReturnTTN.DocDate:= StringGrid1.Cells[2,StringGrid1.Row];
    //FormReturnTTN.DocKontr:= StringGrid1.Cells[4,StringGrid1.Row];
    //FormReturnTTN.Docid:= StringGrid1.Cells[7,StringGrid1.Row];
    FormReturnTTN.ShowModal;
  end;
end;

end.

