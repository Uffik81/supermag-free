unit uniteditproducer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ExtCtrls, StdCtrls, Grids;

type

  { TFormEditProducer }

  TFormEditProducer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    cbProducerOpt: TComboBox;
    edClientRegId: TEdit;
    edFullName: TEdit;
    edINN: TEdit;
    edCountry: TEdit;
    edArea: TEdit;
    edHome: TEdit;
    edHomeCorpus: TEdit;
    edemail: TEdit;
    edRoom: TEdit;
    edLitter: TEdit;
    edStreet: TEdit;
    edlocality: TEdit;
    edSity: TEdit;
    edRegion: TEdit;
    edZIP: TEdit;
    edKPP: TEdit;
    edName: TEdit;
    mmDescription: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure cbProducerOptChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flEditINN:boolean;
    flClientRegId:string;
  end;

var
  FormEditProducer: TFormEditProducer;

implementation
uses unitstart;
{$R *.lfm}

{ TFormEditProducer }

procedure TFormEditProducer.FormShow(Sender: TObject);
var
  query:string;
  i:integer;
  ii:integer;
  strl1:TStringList;
  str1 :string;
  plu1:string;
begin
    edCountry.text:='643';
    edZIP.text:='';
    edRegion.text:='';
    edArea.text:='';
    edSity.text:='';
    edLocality.text:='';
    edStreet.text:='';
    edHome.text:='';
    edHomeCorpus.text:='';
    edRoom.text:='';
  cbProducerOpt.Text:='06 – Розничная продажа алкогольной продукции';
  edClientRegId.Text:=flClientRegId;
  query:='SELECT `shortname`,`fullname`,`inn`,`kpp`,`description`,`addressimns`,`liter`,`typeproducer` FROM `spproducer` WHERE `clientregid`="'+flclientregid+'";';
  formStart.recbuf:= formStart.DB_query(Query);
  formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  while  formStart.rowbuf<>nil do begin
     edName.Text:= formStart.rowbuf[0];
     edFullName.Text:= formStart.rowbuf[1];

     edINN.text:= formStart.rowbuf[2];
     if length(edINN.text)<10 then begin
         edINN.ReadOnly:=false;
         edINN.Color:=clGreen;
         flEditINN:=true;
       end else
       begin
          flEditINN:=false;
         edINN.ReadOnly:=true;
         edINN.Color:=clDefault;
       end;
     edKPP.Text:=formStart.rowbuf[3];
     mmDescription.lines.text:=formStart.rowbuf[4];
     //if formStart.rowbuf[5]='' then

     str1:=formStart.rowbuf[5];
     edLitter.text:=formStart.rowbuf[6];
     if formStart.rowbuf[7]<>'' then
       cbProducerOpt.Text:=cbProducerOpt.Items.Strings[strtoint(formStart.rowbuf[7])];
     formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  end;
  query:='SELECT `imns`,`startdatelic`,`enddatelic`,`serlic`,`numlic`,`deplic` FROM `splicproducer` WHERE `ClientRegId`="'+flclientregid+'";';
  formStart.recbuf:= formStart.DB_query(Query);
  formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  stringgrid1.Clean;
  i:=1;
  stringgrid1.RowCount:=1;
  while  formStart.rowbuf<>nil do begin
     stringgrid1.RowCount:=i+1;
     stringgrid1.Cells[1,i]:= formStart.rowbuf[0];
     stringgrid1.Cells[2,i]:= formStart.rowbuf[1];
     stringgrid1.Cells[3,i]:= formStart.rowbuf[2];
     stringgrid1.Cells[4,i]:= formStart.rowbuf[3];
     stringgrid1.Cells[5,i]:= formStart.rowbuf[4];
     stringgrid1.Cells[6,i]:= formStart.rowbuf[5];
     i:=i+1;
     formStart.rowbuf:= formStart.DB_Next(formStart.recbuf);
  end;

  strl1:=TStringList.create();
  ii:=pos(',',str1);
  strl1.Text:='';
   while (ii>0) AND(str1<>'') do begin
         plu1:=copy(str1,1,ii-1);
         str1:=copy(str1,ii+1,length(str1));
         ii:=pos(',',str1);
         strl1.add(plu1);
       end;
   if strl1.Count>1 then begin
     if length(strl1.Strings[0])<5 then begin
       if strl1.Count>1 then
         edCountry.text:=strl1.Strings[0];
        if strl1.Count>2 then
         edZIP.text:=strl1.Strings[1];
        if strl1.Count>3 then
          edRegion.text:=strl1.Strings[2];
        if strl1.Count>4 then
          edArea.text:=strl1.Strings[3];
        if strl1.Count>5 then
          edSity.text:=strl1.Strings[4];
        if strl1.Count>6 then
          edLocality.text:=strl1.Strings[5];
        if strl1.Count>7 then
          edStreet.text:=strl1.Strings[6];
        if strl1.Count>8 then
          edHome.text:=strl1.Strings[7];
        if strl1.Count>9 then
          edHomeCorpus.text:=strl1.Strings[8];
        if strl1.Count>9 then
          edRoom.text:=strl1.Strings[9];

     end else begin
        if strl1.Count>1 then
          edCountry.text:='643';
         if strl1.Count>2 then
          edZIP.text:=strl1.Strings[0];
         if strl1.Count>3 then
           edRegion.text:='';
         if strl1.Count>4 then
           edArea.text:=strl1.Strings[2];
         if strl1.Count>5 then
           edSity.text:=strl1.Strings[3];
         if strl1.Count>6 then
           edLocality.text:=strl1.Strings[4];
         if strl1.Count>7 then
           edStreet.text:=strl1.Strings[5];
         if strl1.Count>8 then
           edHome.text:=strl1.Strings[6];
         if strl1.Count>9 then
           edHomeCorpus.text:=strl1.Strings[7];
         if strl1.Count>9 then
           edRoom.text:=strl1.Strings[8];

     end;

   end;

end;

procedure TFormEditProducer.BitBtn2Click(Sender: TObject);
var
  addrimns:string;
  tprd:string;
  query:string;
  i:integer;
begin

  formStart.DB_checkCol('spproducer','email','varchar(64)','');

  tprd:= IntToStr(cbProducerOpt.Items.IndexOf(cbProducerOpt.text));

  if length( tprd)<2 then
   tprd:='0'+tprd;
  if tprd = '00' then
    tprd:='';


  addrimns:=edCountry.text+','+edZIP.text+','+edRegion.text+','+edArea.text+','+edSity.text+','+edLocality.text+','+edStreet.text+','+edHome.text+','+edHomeCOrpus.text+',';
  formStart.DB_Query('UPDATE `spproducer` SET `addressimns`='''+addrimns+''', `liter`='''+edlitter.text+''',`typeproducer`='''+tprd+''', `email`='''+edemail.text+''' WHERE `clientregid`='''+flClientRegId+''';' );
  query:='DELETE FROM `splicproducer` WHERE `ClientRegId`="'+flclientregid+'";';
  formStart.DB_query(Query);
//  query:='delete FROM `splicproducer` WHERE `ClientRegId`="'+flclientregid+'";';
  for i:=1 to Stringgrid1.RowCount-1 do begin
    query:='INSERT INTO `splicproducer` (`ClientRegId`,`imns`,`startdatelic`,`enddatelic`,`serlic`,`numlic`,`deplic`) VALUES ('+
        '"'+flclientregid+'","'+stringgrid1.Cells[1,i]+'","'+stringgrid1.Cells[2,i]+'","'+stringgrid1.Cells[3,i]+'","'+stringgrid1.Cells[4,i]+'","'+stringgrid1.Cells[5,i]+'","'+stringgrid1.Cells[6,i]+'");';
    formStart.DB_query(Query);

  end;
  if flEditINN then
   formStart.DB_Query('UPDATE `spproducer` SET `inn`='''+edINN.text+''', `email`='''+edemail.text+''' WHERE `clientregid`='''+flClientRegId+''';' );

end;

procedure TFormEditProducer.BitBtn1Click(Sender: TObject);
begin
  Close();
end;

procedure TFormEditProducer.BitBtn3Click(Sender: TObject);
begin
  Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
end;

procedure TFormEditProducer.BitBtn4Click(Sender: TObject);
begin
  StringGrid1.DeleteRow(Stringgrid1.Row);
end;

procedure TFormEditProducer.cbProducerOptChange(Sender: TObject);
begin

end;

procedure TFormEditProducer.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormEditProducer.FormHide(Sender: TObject);
begin

end;

procedure TFormEditProducer.PageControl1Change(Sender: TObject);
begin

end;

end.

