unit unitSupportUTM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, mysql50;

type

  { TFormSupportUTM }

  TFormSupportUTM = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSupportUTM: TFormSupportUTM;

implementation

{$R *.lfm}
uses unitStart, DOM, XMLRead;

{ TFormSupportUTM }

procedure TFormSupportUTM.Button1Click(Sender: TObject);
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
begin
//  if flUpdateAdmin AND ( not flAsAdmin ) then
//    exit;
//  if GetConstant('flagUpdate')<>'1' then
//      SetConstant('flagUpdate','1')
//    else begin
//        showmessage('Обновление уже запущено!');
//        exit;
//    end;
  SLine:= TStringList.Create;
  SLine.Clear;
  SLine.Text:=formStart.SaveToServerGET('opt/out',S1);
  Try
   S:= TStringStream.Create(SLine.Text);
   S.Position:=0;
 // Обрабатываем полученный файл
   XML:=Nil;
   ReadXMLFile(XML,S); // XML документ целиком
  except
   showmessage('Ошибка:'+sline.text);
   S.Free;
   formStart.SetConstant('flagUpdate','0');
   exit;
  end;
  S.Free;
  indL:=0;
  //formJurnale.StatusBar1.Panels.Items[0].Text:='L:0';
  // 4. Этап загрузки Прочее =====
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
            // ============ Если не грузили то сначало Сохраним в БД ====
            //  mysql_real_escape_string()


          Hs1:=s1;
          formstart.recbuf :=formstart.DB_Query('SELECT `url` FROM `egaisfiles` WHERE `url`="'+tempurl+'";');
          formstart.rowbuf:=formstart.DB_Next(formstart.recbuf);
          if formstart.rowbuf<>nil then
            begin
               Application.ProcessMessages;
               if child.Attributes.Length > 0 then
                 uid:= child.Attributes.GetNamedItem('replyId').NodeValue
               else
                 uid:='';

               // === сохраняем в журнал БД ===
               if (pos('out/ReplyRests/',s1)<>0)or(pos('out/ReplyAP/',s1)<>0) then
               begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;

               // ==============  Загрузка формы ===============
               if pos('opt/out/ReplyAP/',s1)<>0 then begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;

               if pos('opt/out/ReplyPartner/',s1)<>0 then begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;
              if (pos('opt/out/Ticket/',s1)<>0)or(pos('opt/out/TICKET/',s1)<>0) then begin
                        Query:='SELECT * FROM `docjurnale` WHERE `uid`="'+uid+' and `clientaccept`="+";";';
                        formstart.recbuf :=formstart.DB_query(Query);
                        if formstart.db_next(formstart.recbuf)<>Nil then begin
                         formstart.SaveToServerDELETE(tempurl,'');
                        end;
               end;
               if (pos('opt/out/FORMBREGINFO/',Hs1)<>0)or(pos('opt/out/FORMBREGINFO/',s1)<>0) then begin
                                Query:='SELECT * FROM `docjurnale` WHERE `uid`="'+uid+' and `clientaccept`="+";";';
                                formstart.recbuf :=formstart.DB_query(Query);
                                if formstart.db_next(formstart.recbuf)<>Nil then begin
                                 formstart.SaveToServerDELETE(tempurl,'');
                                end;
               end;
  {           if (pos('opt/out/InventoryRegInfo/',s1)<>0)or(pos('opt/out/INVENTORYREGINFO/',s1)<>0) then begin
                  SLine.SaveToFile(PathDir+'\out\InventoryRegInfo_'+uid+'.xml');
                  LoadActInventoryInformBReg(SLine.Text, uid);
             end; }
             // Остаток Товара из ЕГАИС
               if pos('out/ReplyRests/',s1)<>0 then begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;

    {         if (pos('opt/out/WAYBILLACT/',Hs1)<>0)or(pos('opt/out/WayBillAct/',s1)<>0) then begin
                 SLine.SaveToFile(PathDir+'\in\WayBill\WayBillAct_'+s2+'.xml');
                 if loadWayBillAct(SLine.Text) then
                    SaveToServerPOST(tempurl,'');

             end;            }
               if (pos('opt/out/ReplyFormA/',s1)<>0)or(pos('opt/out/REPLYFORMA/',s1)<>0) then begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;
               if (pos('opt/out/ReplyFormB/',s1)<>0)or(pos('opt/out/REPLYFORMB/',s1)<>0) then begin
                 formstart.SaveToServerDELETE(tempurl,'');
               end;

               // ===================
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

end.

