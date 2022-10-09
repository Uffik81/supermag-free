unit unitshoptotransfer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ComCtrls, Grids, Buttons, StdCtrls;
// ===== ActShopToTransfer ====
const
  DBNameDoc = 'doc31';
  DBNameDocX = 'docx31' ;
  NameTypeDoc = 'ActShopFromTransfer';

type

  { TFormShopToTransfer }

  TFormShopToTransfer = class(TForm)
    BitBtn1: TBitBtn;
    bbSave: TBitBtn;
    bbRefreshDate: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    dpDateDoc: TDateTimePicker;
    edNumDoc: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    stQuantityAll: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure bbRefreshDateClick(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { private declarations }
    _uuid:string;
    procedure CreateUUID();
    procedure SetUUID(uuid:String);
  public
    { public declarations }
    flEditing:boolean;
    flNow:boolean;
    flPDF417:string;
    function controlpdf417(aPDF417:string):integer;
    procedure NowDocument();
    procedure OpenDocument(aNumDoc,aDateDoc:String);
    function datedoc:string;
    procedure refreshQuantityAll;
    procedure CreateOnOwner(object_reference:String);
  end;

var
  FormShopToTransfer: TFormShopToTransfer;

implementation

uses unitstart, mysql50, unitaddformbv2, unitspproduct,unitshoprest;
{$R *.lfm}

{ TFormShopToTransfer }

procedure TFormShopToTransfer.Panel1Click(Sender: TObject);
begin

end;

procedure TFormShopToTransfer.CreateUUID();
begin
    self._uuid:= 'doc31:'+formstart.NewGUID();
end;

procedure TFormShopToTransfer.SetUUID(uuid: String);
begin
    self._uuid:= uuid;
end;

function TFormShopToTransfer.controlpdf417(aPDF417: string): integer;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  aRes:integer;
  i:integer;
begin  // === если продовался или уже добавлялся этот код то откидываем
  Query:='SELECT `quantity` from `doccash` WHERE `urlegais`="'+aPDF417+'";';
  xrecbuf:=FormStart.DB_Query(Query);
  ares:=0;
  result:=0;
  xrowbuf:=FormStart.db_next(xrecbuf);
  while xrowbuf<>nil do begin
     if xrowbuf[0]='1' then ares:=ares+1;
     if xrowbuf[0]='-1' then ares:=ares-1;
     xrowbuf:=FormStart.db_next(xrecbuf);
  end;
  result:=ares;


end;

procedure TFormShopToTransfer.NowDocument();
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  flEditing:=true;
  flNow:=true;
  self.CreateUUID();
  xrecbuf:=FormStart.DB_Query('SELECT (COUNT(*)+1) AS `nnumdoc` FROM `docjurnale` WHERE `type`="ActShopFromTransfer" '  );
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<> nil then begin
     edNumDoc.Text:=xrowbuf[0];
    end
    else
      edNumDoc.Text:='1';
  dpDateDoc.Date:=now();
  StringGrid1.RowCount:=1;
  showmodal;
end;

procedure TFormShopToTransfer.OpenDocument(aNumDoc, aDateDoc: String);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
  i:integer;
begin
  edNumDoc.Text:=aNumDoc;
  dpDateDoc.Date:=formStart.Str1ToDate(aDateDoc);
  flnow:=false;
  flEditing:=true;
  stringgrid1.RowCount:=1;
  Query:='SELECT  (SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode`=`doc31`.`alccode` LIMIT 1) AS `tovar`,'+
  '`alccode`, SUM(`quality`) AS `summa1`,`form1`,`form2`,`crdate`,"0" FROM `doc31` WHERE (`datedoc`="'+DateDoc+'")AND(`numdoc`="'+edNumDoc.Text+'") GROUP BY `form2` ;';
  xrecbuf:=FormStart.DB_Query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    i:=StringGrid1.RowCount;
    StringGrid1.RowCount:=i+1;
    StringGrid1.Cells[1,i]:=xrowbuf[1];
    StringGrid1.Cells[2,i]:=xrowbuf[0];
    StringGrid1.Cells[3,i]:=xrowbuf[4];
    StringGrid1.Cells[4,i]:=xrowbuf[5];
    StringGrid1.Cells[5,i]:=xrowbuf[6];
    StringGrid1.Cells[6,i]:=xrowbuf[2];
    StringGrid1.Cells[7,i]:=xrowbuf[3];
    StringGrid1.Col:=3;
    StringGrid1.Row:=i;
    xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  showmodal;

end;

function TFormShopToTransfer.datedoc: string;
begin
  result:=FormatDateTime('YYYY-MM-DD',dpDateDoc.DateTime);
end;

procedure TFormShopToTransfer.refreshQuantityAll;
var
  allSumm:integer;
  i:integer;
begin
  allsumm:=0;
  for i:=1 to Stringgrid1.RowCount-1 do begin
    allsumm:=allsumm+strtoint(Stringgrid1.Cells[6,i]);
  end;
  stQuantityAll.Caption:=inttostr(allsumm);
end;

{Создает документ на основание другого документа

object_reference - <doc31>:<id+date>
}
procedure TFormShopToTransfer.CreateOnOwner(object_reference: String);
var
  i:integer;
  type_object:string;
begin
    // Надо определить тип объекта
    i:=pos(':',object_reference);
    if i = 0 then
        exit;
    type_object:=Copy(object_reference,1,i-1 );
    if  type_object = 'doc27' then begin  // Копируем данные из докум

    end;
end;

procedure TFormShopToTransfer.BitBtn1Click(Sender: TObject);
var
  sLine:TStringList;
  query:string;
  i:integer;
  url:string;
  uid:string;
begin
  if flEditing then
    bbSaveClick(nil);
  sLine:=TStringList.Create();
  uid:=formstart.NewGUID();
  sLine.Add('<?xml version="1.0" encoding="utf-8"?>');
  sLine.Add('<ns:Documents Version="1.0"');
  sLine.Add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  sLine.Add('xmlns:xs="http://www.w3.org/2001/XMLSchema"');
  sLine.Add('xmlns:c="http://fsrar.ru/WEGAIS/Common"');
  sLine.Add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"');
  sLine.Add('xmlns:tfs="http://fsrar.ru/WEGAIS/TransferFromShop"');
  sLine.Add('>');
  sLine.Add('<ns:Owner>');
  sLine.Add('<ns:FSRAR_ID>'+formStart.EgaisKod+'</ns:FSRAR_ID>');
  sLine.Add('</ns:Owner>');
  sLine.Add('<ns:Document>');
  sLine.Add('<ns:TransferFromShop>');
  sLine.Add('<tfs:Identity>'+uid+'</tfs:Identity>');
  sLine.Add('<tfs:Header>');
  sLine.Add('<tfs:TransferNumber>'+edNumDoc.Text+'</tfs:TransferNumber>');
  sLine.Add('<tfs:TransferDate>'+FormatDateTime('YYYY-MM-DD',dpDateDoc.date)+'</tfs:TransferDate>');
  sLine.Add('</tfs:Header>');
  sLine.Add('<tfs:Content>');
  for i:=1 to StringGrid1.RowCount-1 do begin
    sLine.Add('<tfs:Position>');
    sLine.Add('<tfs:Identity>'+inttostr(i)+'</tfs:Identity>');
    sLine.Add('<tfs:ProductCode>'+StringGrid1.Cells[1,i]+'</tfs:ProductCode>');
    sLine.Add('<tfs:Quantity>'+StringGrid1.Cells[6,i]+'</tfs:Quantity>');
    sLine.Add('<tfs:InformF2>');
     sLine.Add('<pref:F2RegId>'+StringGrid1.Cells[3,i]+'</pref:F2RegId>');
    sLine.Add('</tfs:InformF2>');
    sLine.Add('</tfs:Position>');
  end;
  sLine.Add('</tfs:Content>');
  sLine.Add('</ns:TransferFromShop>');
  sLine.Add('</ns:Document>');
  sLine.Add('</ns:Documents>');
  SLine.Text:=formStart.SaveToServerPOST('opt/in/TransferFromShop',sLine.Text);

  url:=formStart.getXMLtoURL(sline.Text);
  if url<>'' then begin
    query:='UPDATE `docjurnale` SET `status`="+++", `uid`="'+url+'", `docid`="'+uid+'" WHERE  `numdoc`="'+edNumDoc.text+'" AND `datedoc`="'+FormatDateTime('YYYY-MM-DD',dpDateDoc.date)+'" AND `type`="ActShopFromTransfer";';
    formstart.DB_query(query);
    end;
  sLine.Free;

end;

procedure TFormShopToTransfer.BitBtn2Click(Sender: TObject);
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
  formspproduct.flSelected:=true;
  if formspproduct.ShowModal=1377 then begin
        AlcCode1:=formspproduct.sAlcCode;
//        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
//        key:=#0;
        formb:=formAddFormBv2.AddFormBOnShop(alccode1);
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
          StringGrid1.Cells[3,i]:=formAddFormBv2.ArrFormB[ii];
          StringGrid1.Cells[4,i]:=formAddFormBv2.flCrDate;
          StringGrid1.Cells[5,i]:='0';
          StringGrid1.Cells[6,i]:=formAddFormBv2.ArrQuality[ii];
          StringGrid1.Cells[7,i]:=formAddFormBv2.flFormA;
          StringGrid1.Col:=3;
          StringGrid1.Row:=i;

          end;
        end else begin
            showmessage('Нет данных по данному товару!');
        end;
        flPDF417:='';
    end;

   formspproduct.flSelected:=false;
end;

procedure TFormShopToTransfer.BitBtn3Click(Sender: TObject);
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
  FormShopRest.flSelectMode:=true;
  if FormShopRest.ShowModal=1377 then begin

        AlcCode1:=FormShopRest.flAlcCode;
    //        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
    //        key:=#0;
    if  AlcCode1='' then begin
      showmessage('Не выбран товар!');
      exit;
      end;
        formb:=formAddFormBv2.AddFormBOnShop(alccode1);
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
          StringGrid1.Cells[3,i]:=formAddFormBv2.ArrFormB[ii];
          StringGrid1.Cells[4,i]:=formAddFormBv2.flCrDate;
          StringGrid1.Cells[5,i]:='0';
          StringGrid1.Cells[6,i]:=formAddFormBv2.ArrQuality[ii];
          StringGrid1.Cells[7,i]:=formAddFormBv2.flFormA;
          StringGrid1.Col:=3;
          StringGrid1.Row:=i;

          end;
        end else begin
            showmessage('Нет данных по данному товару!');
        end;
        flPDF417:='';
    end;

  FormShopRest.flSelectMode:=false;

end;

procedure TFormShopToTransfer.FormCreate(Sender: TObject);
begin
  flEditing:=true;
end;

procedure TFormShopToTransfer.FormKeyPress(Sender: TObject; var Key: char);
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
    con1:=controlpdf417(flPDF417);
    if (con1>0) then begin
          showmessage('Товар с такой акцизной маркой уже продавался или добавлен в инвентаризацию, отложите ее для разбирательст!');
          flPDF417:='';
          key:=#0;
    end else begin
        AlcCode1:='';
        formstart.DecodeEGAISPlomb(flPDF417,AlcCode1,mark,ser);
        key:=#0;
        formb:=formAddFormBv2.AddFormBOnShop(alccode1);
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
          StringGrid1.Cells[3,i]:=formAddFormBv2.ArrFormB[ii];
          StringGrid1.Cells[4,i]:=formAddFormBv2.flCrDate;
          StringGrid1.Cells[5,i]:='0';
          StringGrid1.Cells[6,i]:=formAddFormBv2.ArrQuality[ii];
          StringGrid1.Cells[7,i]:=formAddFormBv2.flFormA;
          StringGrid1.Col:=3;
          StringGrid1.Row:=i;

          end;
        end else begin
            showmessage('Нет данных по данному товару!');
        end;
        flPDF417:='';
    end;
  end;

  refreshQuantityAll;
end;

procedure TFormShopToTransfer.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key<96) and (key>32) then  begin
    flPDF417:=flPDF417+char(lo(key));
    key:=0;
  end;
  if ((key=46)or(chr(lo(key))='-'))AND(StringGrid1.Row>0) then begin
     StringGrid1.DeleteRow(StringGrid1.Row);
     key:=0;
  end;
end;

procedure TFormShopToTransfer.FormShow(Sender: TObject);
begin
  // =====  shoptotransfer ==== перемещение в розницу

  formstart.DB_checkCol('doc31','numdoc','varchar(20)','');
  formstart.DB_checkCol('doc31','datedoc','DATE','');
  formstart.DB_checkCol('doc31','uuid','varchar(100)',''); // универсальный идентификатор элемента
  formstart.DB_checkCol('doc31','quality','int(10)','');
  formstart.DB_checkCol('doc31','alccode','varchar(20)','');
  formstart.DB_checkCol('doc31','form1','varchar(20)','');
  formstart.DB_checkCol('doc31','form2','varchar(20)','');
  formstart.DB_checkCol('doc31','crdate','DATE','');
  Application.ProcessMessages;
  formstart.DB_checkCol('docx31','uuid','varchar(100)',''); // универсальный идентификатор элемента
  formstart.DB_checkCol('docx31','numdoc','varchar(20)','');
  formstart.DB_checkCol('docx31','datedoc','DATE','');
  formstart.DB_checkCol('docx31','ownernumdoc','varchar(20)','');
  formstart.DB_checkCol('docx31','ownerdatedoc','DATE','');
  Application.ProcessMessages;
  refreshQuantityAll;

end;

procedure TFormShopToTransfer.bbSaveClick(Sender: TObject);
var

  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  numdoc:string;
  sDate:string;
begin
  if DateDoc = '' then
    sDate:=FormatDateTime('YYYY-MM-DD',dpDateDoc.DateTime);
    //DateDoc:=FormatDateTime('YYYY-MM-DD',dpDateDoc.DateTime) ;
  numdoc:=edNumDoc.text;
  if numdoc='' then begin
         showmessage('Укажите номер документа');
         exit;
       end;
  flEditing:=false;
  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
    xrecbuf:=formstart.DB_query('SELECT `quality` FROM `doc31` WHERE `alccode`="'+StringGrid1.Cells[1,i]+'" AND `form2`="'+StringGrid1.Cells[3,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin   // `count`="'+StringGrid1.Cells[3,i]+'",
      flEditing:=true;
      formstart.DB_query('UPDATE `doc31` SET `quality`="'+StringGrid1.Cells[6,i]+'" WHERE `alccode`="'+StringGrid1.Cells[1,i]+'" AND `form2`="'+StringGrid1.Cells[3,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc31` (`uuid`,`numdoc`,`datedoc`,`alccode`,`quality`,`crdate`,`form2`,`form1`)'+
        ' VALUES ("'+self._uuid+'","'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[1,i]+'","'+StringGrid1.Cells[6,i]+'","'+StringGrid1.Cells[4,i]+'","'+StringGrid1.Cells[3,i]+'","'+StringGrid1.Cells[7,i]+'");');
    end;
  end;
  if flEditing then begin
    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActShopFromTransfer";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then
     formstart.DB_query('UPDATE `docjurnale` SET `status`="---" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActShopFromTransfer" ;')
    else
     formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActShopFromTransfer","---");');
  end else
  begin
    formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`,`docid`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActShopFromTransfer","---","");');

  end;
  xrecbuf:=formstart.DB_query('SELECT `ownernumdoc` FROM `docx31` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
     flEditing:=true;
     formstart.DB_query('UPDATE `docx31` SET `ownernumdoc`="",`ownerdatedoc`="" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
   end else begin
     formstart.DB_query('INSERT INTO `docx31` (`uuid`,`numdoc`,`datedoc`,`ownernumdoc`,`ownerdatedoc`) VALUES ("'+self._uuid+'","'+NumDoc+'","'+DateDoc+'","","");');
   end;


end;

procedure TFormShopToTransfer.bbRefreshDateClick(Sender: TObject);
var
  i:integer;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  for i:=1 to Stringgrid1.RowCount-1 do begin
     query:='SELECT `crdate`,(SELECT `forma` from `spformfix` where `spformfix`.`alcitem`=`doc27`.`alccode` and `spformfix`.`crdate`=`doc27`.`crdate` limit 1) AS `crdate1` FROM `doc27` WHERE `form2`="'+StringGrid1.Cells[3,i]+'" AND `alccode`="'+StringGrid1.Cells[1,i]+'";';
     xrecbuf:=formstart.DB_query(query);
     xrowbuf:=formStart.DB_Next(xrecbuf);
     if xrowbuf<>nil then  begin
       StringGrid1.Cells[4,i]:=xrowbuf[0];
       StringGrid1.Cells[7,i]:=xrowbuf[1];
     end;

  end;

end;

end.

