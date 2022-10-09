unit unitaddformbv2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtDlgs, ComCtrls, Buttons;

type

  { TFormAddFormBv2 }

  TFormAddFormBv2 = class(TForm)
    bbAddItem: TBitBtn;
    BitBtn2: TBitBtn;
    dpCrDate: TDateTimePicker;
    edQuality: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    stCheckDate: TStaticText;
    stName: TStaticText;
    ToolBar1: TToolBar;
    procedure bbAddItemClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure edQualityKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
    // ===== если множество справо Б =====
    CountFormB:integer;
    ArrFormB:array[0..20] of string;
    ArrQuality:Array[0..20] of String;
    // ===================================
    flShop:boolean;
    flAlcCode:String;
    fl_FormB:String;
    flFormA:String;
    flCrDate:string;
    flQuality:string;
    function AddFormBOnShop(AlcCode:string):String;
    function AddFormBOnTransfer(AlcCode:string):String;
  end;

var
  FormAddFormBv2: TFormAddFormBv2;

implementation
uses unitstart,mysql50;
{$R *.lfm}

{ TFormAddFormBv2 }

procedure TFormAddFormBv2.BitBtn2Click(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  query:= 'SELECT `forma` FROM `spformfix` WHERE `crdate`="'+FormatDateTime('YYYY-MM-DD',dpCrDate.date)+'" AND `alcitem`="'+flAlcCode+'";';
  formStart.recbuf:= formStart.DB_query(query);
  formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
  if formstart.rowbuf<>nil then begin
      stCheckDate.Caption:='Дата найдена!';
      bbAddItem.Enabled:=true;
      flFormA:=formStart.rowbuf[0];
      flCrDate:=FormatDateTime('YYYY-MM-DD',dpCrDate.date);
  end else
    stCheckDate.Caption:='Даты розлива такой нет!';

end;

procedure TFormAddFormBv2.edQualityKeyPress(Sender: TObject; var Key: char);
begin
  if key in ['0'..'9'] then
    exit;
  if ord(key)<ord(' ') then
    exit;
  key:=#0;
end;

procedure TFormAddFormBv2.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormAddFormBv2.bbAddItemClick(Sender: TObject);
var
  countd:integer;
  countc:integer;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  CountFormB:=0;
  flQuality:= edQuality.Text;
  countd:= strtoint(flQuality);
  if FlShop then
    formStart.recbuf:= formStart.DB_query('SELECT `form2`, `count` FROM `doc27` WHERE `crdate`='''+FormatDateTime('YYYY-MM-DD',dpCrDate.date)+''' AND `alccode`='''+flAlcCode+'''  ORDER BY `count` DESC ;')
  else
    formStart.recbuf:= formStart.DB_query('SELECT `InformBRegId`, `quantity` FROM `regrestsproduct` WHERE `InformARegId`='''+flforma+''' AND `alccode`='''+flAlcCode+'''  ORDER BY `quantity` DESC ;');

  formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
  if formstart.rowbuf<>nil then begin
      while (formstart.rowbuf<>nil) and (countd>0) do begin
        ArrFormB[CountFormB]:=formStart.rowbuf[0];
        countc:=strtoint(formStart.rowbuf[1]);
        if countc>countd then
          begin
              ArrQuality[CountFormB]:= inttostr(countd);
              countd:=0;
          end else begin
            ArrQuality[CountFormB]:=inttostr(countc);
            countd:=countd-countc;

          end;
        CountFormB:=CountFormB+1;
        fl_FormB:=formStart.rowbuf[0];
        formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
      end;
      modalresult:=1377;
  end else
   begin
     if FlShop then  begin
       formStart.recbuf:= formStart.DB_query('SELECT `form2`, `count` FROM `doc27` WHERE `crdate`=''0000-00-00'' AND `alccode`='''+flAlcCode+'''  ORDER BY `count` DESC ;');
       formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
       if formstart.rowbuf<>nil then begin
           while (formstart.rowbuf<>nil) and (countd>0) do begin
             ArrFormB[CountFormB]:=formStart.rowbuf[0];
             countc:=strtoint(formStart.rowbuf[1]);
             if countc>countd then
               begin
                   ArrQuality[CountFormB]:= inttostr(countd);
                   countd:=0;
               end else begin
                 ArrQuality[CountFormB]:=inttostr(countc);
                 countd:=countd-countc;

               end;
             CountFormB:=CountFormB+1;
             fl_FormB:=formStart.rowbuf[0];
             formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
           end;
           modalresult:=1377;
       end else begin
               formStart.recbuf:= formStart.DB_query('SELECT `form2`, `count` FROM `doc27` WHERE  `alccode`='''+flAlcCode+'''  ORDER BY `count` DESC ;');
       formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
       if formstart.rowbuf<>nil then begin
           while (formstart.rowbuf<>nil) and (countd>0) do begin
             ArrFormB[CountFormB]:=formStart.rowbuf[0];
             countc:=strtoint(formStart.rowbuf[1]);
             if countc>countd then
               begin
                   ArrQuality[CountFormB]:= inttostr(countd);
                   countd:=0;
               end else begin
                 ArrQuality[CountFormB]:=inttostr(countc);
                 countd:=countd-countc;

               end;
             CountFormB:=CountFormB+1;
             fl_FormB:=formStart.rowbuf[0];
             formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
           end;
           modalresult:=1377;
       end else
            ShowMessage('Данный товар вообще не перемещался из основного склада, его вернуть нельзя!');
       end;
     end
     else
       ShowMessage('Данный товар отсутствует на основном складе, добавить в перемещение невозможно!');
   end;
end;

function TFormAddFormBv2.AddFormBOnShop(AlcCode: string): String;
var
  query:string;
    xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  //result:='';
  fl_FormB:='';
  flFormA:='';
  flCrDate:='';
  CountFormB:=0;
  flShop:=true;
  flAlcCode:=AlcCode;
  formStart.ConnectDB();
  dpCrDate.Date:=now();
  query:='SELECT `name` FROM `spproduct` WHERE `alccode`="'+flAlcCode+'";';
  xrecbuf:=formStart.DB_query(query);
  stName.caption:='Товар не найден! обновите остатки и справочные данные!';
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if  xrowbuf <> nil then begin
      stName.Caption:= xrowbuf[0];
  end;

  if showmodal = 1377 then begin
      result:=fl_FormB;
  end;
end;

function TFormAddFormBv2.AddFormBOnTransfer(AlcCode: string): String;
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  result:='';
  fl_FormB:='';
  flFormA:='';
  flCrDate:='';
  CountFormB:=0;
  flShop:=false;
  flAlcCode:=AlcCode;
  dpCrDate.Date:=now();
  xrecbuf:=formStart.DB_query('SELECT `name` FROM `spproduct` WHERE `alccode`='''+flAlcCode+''';');
  stName.caption:='Товар не найден! обновите остатки и справочные данные!';
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if  xrowbuf <> nil then begin
      stName.Caption:= xrowbuf[0];
  end;

  if showmodal = 1377 then begin
      result:=fl_FormB;
  end;
end;

end.

