unit unitTicket;
{Форма отображает историю сообщений от ЭДО(ЕГАИС)
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, PairSplitter, ComCtrls, mysql50;

type

  { TFormTicket }

  TFormTicket = class(TForm)
    ListView1: TListView;
    Memo1: TMemo;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    DocNum:String;
    DocDate:String;
    uid:string;
    flFindDoc:boolean;
    WBRegID:String;
  end;

var
  FormTicket: TFormTicket;

implementation

{$R *.lfm}
uses UnitStart,lclproc;
{ TFormTicket }

procedure TFormTicket.FormShow(Sender: TObject);
var
  i:integer;
  status1:String;
  Query:String;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  flShowTiket:boolean;
  sListReply:TStringList;
begin
  i:=1;
  formstart.RecoveryTable('ticket');
  memo1.Lines.Clear;
  Listview1.items.Clear;
  sListReply:= TStringList.Create;
  sListReply.clear;
  flShowTiket:=false;
  Query:='SELECT `egaisid` FROM `replyid`  WHERE `numdoc`="'+DocNum+'" AND `datedoc`="'+DocDate+'";';
  xrecbuf :=formStart.DB_query(Query);
  xrowbuf := formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
   begin
     //status1:=
     sListReply.Add(xrowbuf[0]);         //3
     xrowbuf :=formStart.DB_Next(xrecbuf);
   end;

  for i:=0 to sListReply.Count-1 do begin

      Query:='SELECT `RegID`,`accept`,`comment`,`numdoc`,`datedoc`,`datestamp` FROM `ticket` '+
      ' WHERE ((`uid`='''+sListReply.Strings[i]+''')OR(`docid`='''+sListReply.Strings[i]+''')OR(`RegID`='''+sListReply.Strings[i]+''') ) ORDER BY `datestamp` ASC;';

    xrecbuf :=formStart.DB_query(Query,'ticket');
    xrowbuf := formStart.DB_Next(xrecbuf);
    while xrowbuf<>nil do
     begin
       flShowTiket:=true;
       with ListView1.Items.Add do begin
         caption:= xrowbuf[3]+'  '+xrowbuf[4];//xrowbuf[5];
         subitems.Add(xrowbuf[0]);         //3
         Status1:=xrowbuf[1];
         case status1 of
         'Accepted': subitems.Add('Принято');
         'Rejected': subitems.Add('Отказано');
         else
         subitems.Add(status1);
         end;
         subitems.Add(xrowbuf[2]);
       end;
       xrowbuf :=formStart.DB_Next(xrecbuf);
    end;
  end;

  if not flShowTiket then begin
    if WBRegID<>'' then
      Query:='SELECT `RegID`,`accept`,`comment`,`numdoc`,`datedoc`,`datestamp` FROM `ticket` '+
      'WHERE ((`uid`='''+uid+''')OR(`docid`='''+uid+''')OR(`RegID`='''+WBRegID+'''))AND(`numdoc`='''') '+
      'OR((`numdoc`='''+DocNum+''')AND(`datedoc`='''+DocDate+'''))'+
      ' ORDER BY `datestamp` ASC;'
    else begin

      Query:='SELECT `RegID`,`accept`,`comment`,`numdoc`,`datedoc`,`datestamp` FROM `ticket` '+
      ' WHERE ((`uid`='''+uid+''')OR(`docid`='''+uid+''')OR(`RegID`='''+uid+''') )AND(`numdoc`='''') '+
      'OR((`numdoc`='''+DocNum+''')AND(`datedoc`='''+DocDate+'''))'+
      ' ORDER BY `datestamp` ASC;';
    end;

    xrecbuf :=formStart.DB_query(Query,'ticket');
    xrowbuf := formStart.DB_Next(xrecbuf);
    while xrowbuf<>nil do
     begin
       with ListView1.Items.Add do begin

         caption:= xrowbuf[3]+'  '+xrowbuf[4];//xrowbuf[5];
         subitems.Add(xrowbuf[0]);         //3
         Status1:=xrowbuf[1];
         case status1 of
         'Accepted': subitems.Add('Принято');
         'Rejected': subitems.Add('Отказано');
         else
         subitems.Add(status1);
         end;
         subitems.Add(xrowbuf[2]);
       end;
       i:=i+1;
       xrowbuf :=formStart.DB_Next(xrecbuf);
     end  ;
  end;
  sListReply.Free;
  formStart.disconnectDB();
  Caption:='Сообщения из ЕГАИС ['+DocNum+' от '+DocDate+']';
end;

procedure TFormTicket.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DocNum:='';
  WBRegID:='';
  uid:='';
  DocDate:='';
end;

procedure TFormTicket.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if selected then begin
    //formstart.fshowmessage(Item.SubItems.Strings[2]);
    memo1.Lines.Text:=Item.SubItems.Strings[2];

  end;
end;

end.

