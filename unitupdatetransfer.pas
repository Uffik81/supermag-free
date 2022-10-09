unit unitupdatetransfer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DOM, XMLRead, mysql50;

type

  { TFormUpdateTransfer }

  TFormUpdateTransfer = class(TForm)
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    idReply:string;
    countcycle:integer;
  public
    function UpdateBalance:boolean;
    function LoadRest:string;
  end;

var
  FormUpdateTransfer: TFormUpdateTransfer;

implementation

{$R *.lfm}
uses unitstart,lazutf8;

{ TFormUpdateTransfer }
function TFormUpdateTransfer.LoadRest:string;
procedure StatusUpd(st1:string);
begin
     Application.ProcessMessages;
end;

var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  ii,i:Integer;
  s2,S1:String;
  S : TStringStream;
 SLine:TStringList;
 tempurl:String;
  uid:String;
  eStatus:String;
  Query:String;
  fl1:boolean;
  indL:Integer;
  Hs1:String;
  blobxml:cardinal;
  spchar2,
  spchar:pchar;
  strhex:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  StatusUpd('L:0');


   if  (formstart.GetConstant('flagUpdate')<>'1') then
        formstart.SetConstant('flagUpdate','1')
      else begin
          showmessage('Обновление уже запущено!');
          exit;
      end;


  StatusUpd('Получаем список документов');
  SLine:= TStringList.Create;
  SLine.Clear;
  s1:=formstart.SaveToServerGET('opt/out',S1);
  if s1='' then begin
    showmessage('Ошибка подключения к УТМ!');
    formstart.SetConstant('flagUpdate','0');
    exit;
    end;
  Try
   S:= TStringStream.Create(s1);
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
  except
   showmessage('Ошибка:'+sline.text);
   S.Free;
   formstart.SetConstant('flagUpdate','0');
   exit;
  end;
  S.Free;
  indL:=0;
 StatusUpd('L:0');

 try

  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    if Child.NodeName = 'url' then begin
       s1:=Child.FirstChild.NodeValue;
       s2:=s1;
       i:=pos('/',s2);
       tempurl:='';
       while i<>0 do begin
           s2:=copy(s2,i+1,Length(s2)-i);
           if (pos(':',s2)=0)and(tempurl = '') then tempurl:=s2;
           i:=pos('/',s2);
       end;
       Hs1:=s1;
       xrecbuf :=formstart.DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
       xrowbuf:=formstart.DB_Next(xrecbuf);
       if xrowbuf<>nil then begin
         // ==============
       end
       else begin
         Application.ProcessMessages;
         if ((pos('opt/out/ReplyRestsShop_v2/',s1)<>0)or
            (pos('opt/out/REPLYRESTSSHOP_V2/',s1)<>0))or
            ((pos('opt/out/Ticket/',s1)<>0)or
            (pos('opt/out/TICKET/',s1)<>0)) then begin
           if child.Attributes.Length > 0 then uid:= child.Attributes.GetNamedItem('replyId').NodeValue
             else   uid:='';
           if idReply = uid then begin  // дождались ответа!!!
              SLine.Text:=formstart.SaveToServerGET(tempurl,'');
                if  SLine.Text<>'' then begin
                  if SLine.Strings[0]='' then
                        SLine.Delete(0);

                end;
              result:=uid;
                  if (pos('out/ReplyRests/',s1)<>0)or(pos('out/ReplyAP/',s1)<>0) then
                  begin
                    strhex:='';
                    Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'","");';
                    xrecbuf :=formstart.DB_Query(query);
                  end
                  else begin
                    strhex:='';
                    strhex:=StringToHex(SLine.Text);
                    Query:='INSERT INTO `egaisfiles` (`url`,`typefile`,`replyId`,`xmlfile`) VALUES ("'+tempurl+'","xml","'+uid+'",0x'+strhex+');';
                    xrecbuf :=formstart.DB_Query(query);
                  end;
                  if (pos('opt/out/ReplyRestsShop_v2/',s1)<>0)or(pos('opt/out/REPLYRESTSSHOP_V2/',s1)<>0) then begin
                    SLine.Clear;
                    SLine.Text:=formstart.SaveToServerPOST(tempurl,S1);
                   // if SLine.Count>1 then
                    begin
                      formstart.loadFromEGAISRestsShop_v2(SLine.Text);
                    End;

                 end;
                  if (pos('opt/out/Ticket/',s1)<>0)or(pos('opt/out/TICKET/',s1)<>0) then begin
                         //SLine.SaveToFile(PathDir+'\out\Ticket_'+uid+'.xml');
                        formstart.LoadTicketEGAIS(SLine.Text, uid);
                        if pos('>Accepted</',SLine.Text)<>0  then begin
                          if formstart.connectDB() then begin
                            Query:='SELECT * FROM `docjurnale` WHERE `uid`="'+uid+'";';
                            xrecbuf :=formstart.DB_query(Query);
                            xrowbuf:=formstart.DB_Next(xrecbuf);
                            if xrowbuf<>Nil then begin
                             Query:='UPDATE `docjurnale` SET `status`="+++" WHERE `uid`="'+uid+'";';
                             formstart.DB_query(Query);
                            end;

                          end;
                        end;
                      end;
           end;
          end;
              // ===================   LoadQueryHistoryFormB
             end;
          end;
        indL:=indL+1;
        Child := Child.NextSibling ;
     end;  // end while

 except
   // ==== Снимаем семафор обновления =====
   ShowMessage('При обновлении произошла ошибка!'+#13#10+s1);
   formstart.SetConstant('flagUpdate','0');
 end;
  SLine.Free;
   // ==== Снимаем семафор обновления =====
  formstart.SetConstant('flagUpdate','0');

end;

procedure TFormUpdateTransfer.Timer1Timer(Sender: TObject);

begin
  countcycle:=countcycle+1;
  if countcycle>20 then
   begin
     modalresult:=0;
   end;
  if LoadRest<>'' then
   modalresult:=1377;
end;

function TFormUpdateTransfer.UpdateBalance: boolean;
var
  t1, t2:boolean;
begin
  t1:= formstart.Timer1.Enabled;
  formstart.Timer1.Enabled:=false;
  t2:=formstart.TimerRests.Enabled;
  countcycle:=0;
  // === проверяем остаток ====
  timer1.Enabled:=true;
  formStart.SendQueryRestsShopv2();
  idReply:=formstart.GetConstant('uidrestshop');
  if showmodal = 1377 then
  begin

  end;
  timer1.enabled:=false;
  formstart.Timer1.Enabled:=t1;
  formstart.TimerRests.Enabled:=t2;
end;

end.

