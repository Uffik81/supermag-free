{
  *** Акт подтверждения или отказа Разногласия ***
}

unit unitWayBillAct;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, Buttons, StdCtrls, mysql50;

type

  { TFormWayBillAct }

  TFormWayBillAct = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    stStatus: TStaticText;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    rowbuf : MYSQL_ROW;
    recbuf : PMYSQL_RES;
  public
    { public declarations }
    flReadOnly:boolean;
    DocNumber:string;
    docDate:string;
  end;

var
  FormWayBillAct: TFormWayBillAct;

implementation

{$R *.lfm}
uses DOM, XMLRead, typinfo, unitStart, LCLIntf, unitSelItem, unitaddformB;
{ TFormWayBillAct }

const
  FormName='Акт расхожения';

procedure TFormWayBillAct.FormShow(Sender: TObject);
var
  Query:String;
  i:integer;
begin
  Query:='SELECT `status`,`issueclient` FROM `docjurnale` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'")AND (`type`="WayBill");';
  recbuf:=formstart.DB_query(Query);
  rowbuf:=formStart.DB_Next(recbuf);
  if rowbuf<>nil then
    begin
      if rowbuf[1] = '1' then begin
      stStatus.Caption:='Акт уже отправлен!';
      stStatus.Font.Color:=$00FF0000;
      flReadOnly:=true;

      end
       else begin
          stStatus.Caption:='';
          stStatus.Font.Color:=$00000000;
          flReadOnly:=false;
       end;
    end;

   bitbtn1.Enabled:=not flreadonly;
   bitbtn2.Enabled:=not flreadonly;
    //datetimePicker1.Date:=formstart.DB_StrToDate(trim(docDate));
    Query:='SELECT `tovar`,`price`,`valuetov`,`forma`,`formb`,`AlcItem`,`partplomb`,`numplomb`,`crdate`,`factcount` FROM `doc21` WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;';

    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then
      exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    i:=1;
    while formStart.rowbuf<>nil do begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
     with StringGrid1.rows[i] do begin
      Add('');
      ADD(IntToStr(i));
      Add(trim(formStart.rowbuf[0]));         //0
      Add(trim(formStart.rowbuf[1]));         //1
      Add(trim(formStart.rowbuf[2]));         //2
      Add(trim(formStart.rowbuf[9]));         //6
      Add(trim(formStart.rowbuf[4]));         //7
      Add(trim(formStart.rowbuf[5]));         //5
      Add('x');         // флаг - загружен из субд
      Add(trim(formStart.rowbuf[6]));         //7
      Add(trim(formStart.rowbuf[7]));         //5
      Add(trim(formStart.rowbuf[8]));
    end;
    i:=i+1;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   End;

  Statictext1.Caption:=DocNumber;
  Statictext2.Caption:=docdate;
end;

procedure TFormWayBillAct.BitBtn1Click(Sender: TObject);
var
  query:string;
begin
  formstart.DB_query('UPDATE `docjurnale` SET `block`="+", `issueclient`="+" WHERE (datedoc="'+docDate+'")AND(numdoc="'+DocNumber+'") ;');
  FormStart.FromSaleActTTH( DocNumber, DocDate,true);

end;

procedure TFormWayBillAct.BitBtn2Click(Sender: TObject);
begin
  FormStart.FromSaleActTTH(  DocNumber, DocDate,false);
end;

procedure TFormWayBillAct.BitBtn3Click(Sender: TObject);
begin
  close;
end;

end.

