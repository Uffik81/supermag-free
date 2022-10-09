unit unitActChargeOnShop;
{Оприходование в розничном складе алкогольной продукции}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, Grids, ExtCtrls, Buttons, StdCtrls, ComCtrls;

const
  DBNameDoc = 'doc26';
  DBNameDocX = 'docx26' ;
  NameTypeDoc = 'ActChargeOnShop';

type

  { TFormActChargeOnShop }

  TFormActChargeOnShop = class(TForm)
    bbSave: TBitBtn;
    bbSubmit: TBitBtn;
    BitBtn1: TBitBtn;
    Button1: TButton;
    dpDateDoc: TDateTimePicker;
    Edit1: TEdit;
    edNumDoc: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure bbSaveClick(Sender: TObject);
    procedure bbSubmitClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    flEditing:boolean;
    flNew:boolean;
    flReadOnly:boolean;
    NumDoc:string;
    DateDoc:String;
    selectrow:integer;
    flSelIdProvider:String;
    procedure NewDocument();
    procedure SendToEGAIS;
  end;

var
  FormActChargeOnShop: TFormActChargeOnShop;

implementation
uses unitstart, mysql50, unitspproducer,unitspproduct;
{$R *.lfm}

{ TFormActChargeOnShop }

procedure TFormActChargeOnShop.bbSaveClick(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  datedoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.date) ;
  numdoc:=edNumDoc.text;
  if numdoc='' then begin
         showmessage('Укажите номер документа');
         exit;
       end;
  flEditing:=false;
  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
    xrecbuf:=formstart.DB_query('SELECT `count` FROM `doc26` WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      flEditing:=true;
      formstart.DB_query('UPDATE `doc26` SET `count`="'+StringGrid1.Cells[3,i]+'",`count`="'+StringGrid1.Cells[3,i]+'" WHERE `alccode`="'+StringGrid1.Cells[2,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc26` (`numdoc`,`datedoc`,`alccode`,`count`,`crdate`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[2,i]+'","'+StringGrid1.Cells[3,i]+'","'+StringGrid1.Cells[4,i]+'");');
    end;
  end;
  if flEditing then begin
    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActChargeOnShop";');
    xrowbuf:=formStart.DB_Next(xrecbuf);

    if xrowbuf<>nil then
             formstart.DB_query('UPDATE SET `status`="---" FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActChargeOnShop";')
        else
     formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActChargeOnShop","---");');
  end else
  begin
    formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActChargeOnShop","---");');

  end;
  xrecbuf:=formstart.DB_query('SELECT `clientprovider` FROM `docx26` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
     flEditing:=true;
     formstart.DB_query('UPDATE `docx26` SET `clientprovider`="'+flSelIdProvider+'" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
   end else begin
     formstart.DB_query('INSERT INTO `docx26` (`numdoc`,`datedoc`,`clientprovider`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+flSelIdProvider+'");');
   end;

end;

procedure TFormActChargeOnShop.bbSubmitClick(Sender: TObject);
begin
  bbSaveClick(nil);
  formstart.ActChargeOnShopv2(numdoc,datedoc);
end;

procedure TFormActChargeOnShop.BitBtn1Click(Sender: TObject);
var
  AlcCode1,
  mark,ser:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
begin
  if formspproduct.showmodal = 1377 then begin
    for i:=1 to Stringgrid1.RowCount-1 do begin
      if formspproduct.sAlcCode= stringgrid1.Cells[1,i] then
        begin
          Stringgrid1.row:=i;
          exit;
        end;
    end;
   // Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
    xrecbuf:=FormStart.DB_Query('SELECT `name` FROM `spproduct` WHERE `alccode`="'+formspproduct.sAlcCode+'" '  );
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      i:=StringGrid1.RowCount;
      StringGrid1.RowCount:=i+1;
      StringGrid1.Cells[4,i]:='0000-00-00';
      StringGrid1.Cells[3,i]:='0';
      StringGrid1.Cells[1,i]:=xrowbuf[0];
      StringGrid1.Cells[2,i]:=formspproduct.sAlcCode;
      StringGrid1.Col:=3;
      StringGrid1.Row:=i;
    end else begin
        showmessage('Нет данных по данному товару!');
    end;
  end;

end;

procedure TFormActChargeOnShop.Button1Click(Sender: TObject);
var
  i:integer;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  if formspproducer.ShowModal = 1377 then
  flSelIdProvider:=formspproducer.SelProducer;
  if flselIdProvider<>'' then begin
    edit1.Text:=flselIdProvider;
    query:='SELECT `fullname` FROM `spproducer` WHERE `clientregid`= "'+flselIdProvider+'" LIMIT 1;';
    xrecbuf:=FormStart.DB_Query(query);
    xrowbuf:=FormStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then
        edit1.Text:=xrowbuf[0];
  end;
end;

procedure TFormActChargeOnShop.FormCreate(Sender: TObject);
begin


end;

procedure TFormActChargeOnShop.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  aRes:integer;
begin
  // =====  ActChargeOnShop ==== Оприходование в розницу
  FormStart.DB_checkCol('doc26','numdoc','varchar(20)','');
  FormStart.DB_checkCol('doc26','datedoc','DATE','');
  FormStart.DB_checkCol('doc26','count','int(10)','');
  FormStart.DB_checkCol('doc26','alccode','varchar(20)','');
  FormStart.DB_checkCol('doc26','crdate','DATE','');
  FormStart.DB_checkCol('doc26','restcount','int(10)','');
  FormStart.DB_checkCol('doc26','storepoint','varchar(32)','');

  if ( NumDoc<>'' )and( DateDoc<>'' ) then begin    //,(SELECT `InformARegId` FROM `regrestsproduct` WHERE `alccode`=`doc25`.`alccode` AND `crdate`=`doc25`.`crdate` LIMIT 1) AS `forma`
    StringGrid1.Clear;
    StringGrid1.RowCount:=1;
    Query:='SELECT (SELECT `name` FROM `spproduct` WHERE `alccode`=`doc26`.`alccode` LIMIT 1) AS `name`,`alccode`,`count`,`restcount` FROM `doc26` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
    xrecbuf:=FormStart.DB_Query(Query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
      i:=1;
      StringGrid1.Clear;
      StringGrid1.RowCount:=2;
      while xrowbuf<>nil do begin
        StringGrid1.RowCount:=i+1;
        StringGrid1.Cells[1,i]:=xrowbuf[0];
        StringGrid1.Cells[2,i]:=xrowbuf[1];
        StringGrid1.Cells[3,i]:=xrowbuf[2];
        //    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
        i:=i+1;
        Stringgrid1.Row:=i;
        flNew:=false;
        xrowbuf:= formStart.DB_Next(xrecbuf);
      end;
      edNumDoc.Text:=NumDoc;
      dpDateDoc.date:=formstart.Str1ToDate(DateDoc);
      Query:='SELECT `clientprovider` FROM `docx26` WHERE `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";';
      xrecbuf:=FormStart.DB_Query(Query);
      xrowbuf:=formStart.DB_Next(xrecbuf);
      if xrowbuf<>nil then
        flSelIdProvider:=xrowbuf[0]
        else
         flSelIdProvider:='';
      if flselIdProvider<>'' then begin
        edit1.Text:=flselIdProvider;
        query:='SELECT `fullname` FROM `spproducer` WHERE `clientregid`= "'+flselIdProvider+'" LIMIT 1;';
        xrecbuf:=FormStart.DB_Query(query);
        xrowbuf:=FormStart.DB_Next(xrecbuf);
        if xrowbuf<>nil then
            edit1.Text:=xrowbuf[0];
      end;
  end else begin
     dpDateDoc.date:=now();
  end;

  edNumDoc.ReadOnly:=not flNew;
  dpDateDoc.ReadOnly:=not flNew;
end;

procedure TFormActChargeOnShop.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=46)AND(StringGrid1.Row>0) then begin
     StringGrid1.DeleteRow(StringGrid1.Row);
  end;
end;

procedure TFormActChargeOnShop.NewDocument();
begin
  FormStart.DB_checkCol('doc26','numdoc','varchar(20)','');
  FormStart.DB_checkCol('doc26','datedoc','DATE','');
  FormStart.DB_checkCol('doc26','count','int(10)','');
  FormStart.DB_checkCol('doc26','alccode','varchar(20)','');
  FormStart.DB_checkCol('doc26','crdate','DATE','');
  FormStart.DB_checkCol('doc26','restcount','int(10)','');
  FormStart.DB_checkCol('doc26','storepoint','varchar(32)','');

  flNew:=true;
  StringGrid1.Clear;
  StringGrid1.RowCount:=1;
  NumDoc:='';
  DateDoc:=FormatDateTime('YYYY-MM-DD',now()) ;
  dpDateDoc.date:=now(); //datedoc:=FormatDateTime('YYYY-MM-DD',) ;
  showmodal;
end;

procedure TFormActChargeOnShop.SendToEGAIS;
begin

end;

end.

