unit unitexportform5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, Grids, mysql50;

type

  { TFormExportForm5 }

  TFormExportForm5 = class(TForm)
    bbFormRefresh: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    bbOldForm5: TBitBtn;
    bbEmailClients: TBitBtn;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    sdd1: TSelectDirectoryDialog;
    sgBuy7ret: TStringGrid;
    sgSales6ret: TStringGrid;
    sgBuy7: TStringGrid;
    sgForm5: TStringGrid;
    sgSales6: TStringGrid;
    sgProducer: TStringGrid;
    sgClients: TStringGrid;
    sgLicensing: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure bbEmailClientsClick(Sender: TObject);
    procedure bbFormRefreshClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure bbOldForm5Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure sgClientsDblClick(Sender: TObject);
    procedure sgClientsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgForm5DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgSales6DblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flTransferToShop:boolean;
    flProducerEn:boolean;
    flStartDate, flEndDate:tdatetime;
    procedure TrunForm5();
    procedure LoadOldForm5(const aStr:string);
    function GetLicToXML(const vClientRegId:string):string;
  end;

var
  FormExportForm5: TFormExportForm5;

implementation
uses unitstart,uniteditproducer,  comobj,
  variants,
  LCLIntf,
  base64,
  lconvencoding,lclproc,
  DOM,
  XMLRead
  ,unitsendemails,
  unitShowStatus;
{$R *.lfm}

function replaceStr5(aStr:string; fl1:boolean=true):String;
// mysql_real_escape_string
var
  i:integer;
begin
  result:='';
  for i:=1 to length(aStr) do
    case aStr[i] OF
     '&': result:=result+'&amp;';
     '''': result:=result+'&apos;';
     '\': result:=result+'';
     ':': result:=result+'';
     '"': result:=result+'&quot;';
     else
        result:=result+aStr[i];
    end;
end;

function CheckedAddress(const vAddr:string):boolean;
function checkedInt(const aStr:string):boolean;
var
  i:integer;
begin
  result:=true;
  for i:=1 to length(aStr) -1 do
  if aStr[i] in ['0'..'9','/','\'] then
    else
     result:=false;
end;

var
  ii:integer;
  strl1:TStringList;
  str1 :string;
  plu1:string;

begin
  if vAddr = '' then
    result:=false
    else begin
    str1:=vAddr;
    strl1:=TStringList.create();
    result:=true;
    strl1.Text:='';
    ii:=pos(',',str1);
     while (ii>0) AND(str1<>'') do begin
           plu1:=copy(str1,1,ii-1);
           str1:=copy(str1,ii+1,length(str1));
           ii:=pos(',',str1);
           strl1.add(plu1);
         end;
     if strl1.Count>8 then begin
       if length(strl1.Strings[1])> 6 then
         result:=false;
       if not checkedInt( strl1.Strings[1]) then
         result:=false;
       if not checkedInt( strl1.Strings[7]) then
         result:=false;
     end else
     begin
        if length(strl1.Strings[0])> 6 then
          result:=false;
        if not checkedInt( strl1.Strings[0]) then
          result:=false;
        if not checkedInt( strl1.Strings[6]) then
          result:=false;
     end;

    end;
end;

function GetIMNStoXML(const vAddr:string; aReg:string):String;
var
  ii:integer;
  strl1:TStringList;
  str1 :string;
  plu1:string;
  res1:TStringList;
begin
  str1:=vAddr;
  strl1:=TStringList.create();
  res1:=TStringList.create();
  strl1.Text:='';
  ii:=pos(',',str1);
   while (ii>0) AND(str1<>'') do begin
         plu1:=copy(str1,1,ii-1);
         str1:=copy(str1,ii+1,length(str1));
         ii:=pos(',',str1);
         strl1.add(plu1);
       end;
   res1.text:='';
   if strl1.Count>8 then begin
    if aReg='' then
       aReg:=strl1.Strings[2];
    if strl1.Strings[0]='643' then begin
     if (strl1.Count>9) then begin
       res1.Add('<КодСтраны>'+strl1.Strings[0]+'</КодСтраны>');
       res1.Add('<Индекс>'+strl1.Strings[1]+'</Индекс>');
       res1.Add('<КодРегион>'+aReg+'</КодРегион>');
       res1.Add('<Район>'+strl1.Strings[3]+'</Район>');
       res1.Add('<Город>'+strl1.Strings[4]+'</Город>');
       res1.Add('<НаселПункт>'+strl1.Strings[5]+'</НаселПункт>');
       res1.Add('<Улица>'+strl1.Strings[6]+'</Улица>');
       res1.Add('<Дом>'+strl1.Strings[7]+'</Дом>');
       res1.Add('<Корпус>'+strl1.Strings[8]+'</Корпус>');
       res1.Add('<Кварт>'+strl1.Strings[9]+'</Кварт>');

     end else begin
     res1.Add('<КодСтраны>'+strl1.Strings[0]+'</КодСтраны>');
     res1.Add('<Индекс>'+strl1.Strings[1]+'</Индекс>');
     res1.Add('<КодРегион>'+aReg+'</КодРегион>');
     res1.Add('<Район>'+strl1.Strings[3]+'</Район>');
     res1.Add('<Город>'+strl1.Strings[4]+'</Город>');
     res1.Add('<НаселПункт>'+strl1.Strings[5]+'</НаселПункт>');
     res1.Add('<Улица>'+strl1.Strings[6]+'</Улица>');
     res1.Add('<Дом>'+strl1.Strings[7]+'</Дом>');
     res1.Add('<Корпус>'+strl1.Strings[8]+'</Корпус>');
     res1.Add('<Кварт>'+'</Кварт>');

     end;
    end
    else begin
     if (length(strl1.Strings[0])<5)and(strl1.Count>9) then begin
       res1.Add('<КодСтраны>'+strl1.Strings[0]+'</КодСтраны>');
       res1.Add('<Индекс>'+strl1.Strings[1]+'</Индекс>');
       res1.Add('<КодРегион>'+aReg+'</КодРегион>');
       res1.Add('<Район>'+strl1.Strings[3]+'</Район>');
       res1.Add('<Город>'+strl1.Strings[4]+'</Город>');
       res1.Add('<НаселПункт>'+strl1.Strings[5]+'</НаселПункт>');
       res1.Add('<Улица>'+strl1.Strings[6]+'</Улица>');
       res1.Add('<Дом>'+strl1.Strings[7]+'</Дом>');
       res1.Add('<Корпус>'+strl1.Strings[8]+'</Корпус>');
       res1.Add('<Кварт>'+strl1.Strings[9]+'</Кварт>');

     end else begin
        res1.Add('<КодСтраны>643</КодСтраны>');
        res1.Add('<Индекс>'+strl1.Strings[0]+'</Индекс>');
        res1.Add('<КодРегион>'+aReg+'</КодРегион>');
        res1.Add('<Район>'+strl1.Strings[2]+'</Район>');
        res1.Add('<Город>'+strl1.Strings[3]+'</Город>');
        res1.Add('<НаселПункт>'+strl1.Strings[4]+'</НаселПункт>');
        res1.Add('<Улица>'+strl1.Strings[5]+'</Улица>');
        res1.Add('<Дом>'+strl1.Strings[6]+'</Дом>');
        res1.Add('<Корпус>'+strl1.Strings[7]+'</Корпус>');
        res1.Add('<Кварт>'+strl1.Strings[8]+'</Кварт>');

     end;
    end;

   end;
  strl1.free();
  result :=res1.text;
  res1.free();

end;

{ TFormExportForm5 }
procedure TFormExportForm5.LoadOldForm5(const aStr:string);
var
  i:integer;
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  S1:String;
  S : TStringStream;
  CodeIMNS:String;
  vName,
  vINN,vkpp,vP24:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  NodeName1:string;
begin
  S:= TStringStream.Create(aStr);
  Try
    S.Position:=0;
    // Обрабатываем полученный файл
    XML:=Nil;
    ReadXMLFile(XML,S); // XML документ целиком
  Finally
    S.Free;
  end;
  i:=sgForm5.RowCount-1;
  if sgForm5.Cells[0,i]='1' then
    sgForm5.DeleteRow(i);
  i:=0;
  Child :=XML.DocumentElement.FirstChild;
  while Assigned(Child) do begin
    NodeName1:=AnsiToUtf8(Child.NodeName);
    if NodeName1 = 'Документ' then begin
       Child1:=child.FirstChild;
       while Assigned(Child1) do begin
         NodeName1:=AnsiToUtf8(Child1.NodeName);
          if NodeName1 = 'ОбъемОборота' then begin
            Child2:=child1.FirstChild;
            while Assigned(Child2) do begin
              NodeName1:=AnsiToUtf8(Child2.NodeName);
              if NodeName1 = 'Оборот' then begin
                 // П000000000003

                CodeIMNS:=Child2.Attributes.item[1].NodeValue;
                Child3:=child2.FirstChild;
                while Assigned(Child3) do begin
                  NodeName1:=AnsiToUtf8(Child3.NodeName);
                  if NodeName1 = 'СведПроизвИмпорт' then begin
                     vName:=AnsiToUTF8(Child3.Attributes.item[1].NodeValue);
                     vINN:=Child3.Attributes.item[2].NodeValue;
                     vKPP:=Child3.Attributes.item[3].NodeValue;
                     if pos('.',vkpp)<> 0 then begin
                        vkpp:='';
                     //   vP24:=Child3.Attributes.item[Child3.Attributes.Length-2].NodeValue;
                     end;
                     if length(vINN)<9 then begin
                       end;
                     vP24:=Child3.Attributes.item[Child3.Attributes.Length-2].NodeValue;

                     xrecbuf:=formstart.DB_query('SELECT `ClientRegId`,`fullname`,`inn`,`kpp` FROM `spproducer` WHERE `inn`="'+vINN+'" AND `kpp`="'+vKPP+'" LIMIT 1;');
                     xrowbuf:=formStart.DB_Next(xrecbuf);
                     if (xrowbuf<>nil)and(vP24<>'0') then begin
                      i:=sgForm5.RowCount;
                      sgForm5.RowCount:=i+1;

                      sgForm5.Cells[1,i]:=CodeIMNS; // ИМНС
                      sgForm5.Cells[2,i]:=xrowbuf[0];
                      sgForm5.Cells[3,i]:=xrowbuf[1];
                      sgForm5.Cells[4,i]:=xrowbuf[2];
                      sgForm5.Cells[5,i]:=xrowbuf[3];
                      sgForm5.Cells[6,i]:=vP24;
                     end else begin
                       showmessage('Не найден клиент "'+vName+'" ИНН/КПП "'+vINN+'/'+vKPP+'" и его невозможно будет сопоставить!');
                       if vP24<>'0' then begin
                         i:=sgForm5.RowCount;
                         sgForm5.RowCount:=i+1;
                         sgForm5.Cells[0,i]:='*';
                         sgForm5.Cells[1,i]:=CodeIMNS; // ИМНС
                         sgForm5.Cells[2,i]:=vINN;
                         sgForm5.Cells[3,i]:=vName;
                         sgForm5.Cells[4,i]:=vINN;
                         sgForm5.Cells[5,i]:=vkpp;
                         sgForm5.Cells[6,i]:=vP24;

                       end else
                       begin
                         showmessage('Нет остатка "'+vName+'" ИНН/КПП "'+vINN+'/'+vKPP+'" и его невозможно будет сопоставить!');

                       end;
                     end;

                  end;
                  Child3 := Child3.NextSibling;
                end;
              end;
              Child2 := Child2.NextSibling;
            end;
          end;
          Child1 := Child1.NextSibling;
       end;
    end;
    Child := Child.NextSibling;
  end;
  TrunForm5();
  bbOldForm5.Enabled:=false;
end;

function TFormExportForm5.GetLicToXML(const vClientRegId: string): string;
var
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin

end;

procedure  TFormExportForm5.TrunForm5();
var
  ind:integer;
  iForm5:integer;
  vsumm:real;
  iClient:String;
  imns:string;
  i:integer;
  arrSum:array[6..20] of real;
begin
  i:=sgForm5.RowCount-1;
  if sgForm5.Cells[0,i]='1' then
    sgForm5.DeleteRow(i);
  iform5:=1;
  for i:=6 to 20 do;
    arrSum[i]:= 0;
  while iform5< sgForm5.RowCount do begin
    imns:= sgForm5.Cells[1,iForm5];
    iClient:=sgForm5.Cells[2,iForm5];
    ind:=iForm5+1;
    while ind< sgForm5.RowCount do begin
      if (iClient = sgForm5.Cells[2,ind]) AND (imns = sgForm5.Cells[1,ind]) then
        begin
          // сворачиваем значения
          sgForm5.Cells[6,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[6,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[6,ind]))]);
          sgForm5.Cells[7,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[7,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[7,ind]))]);
          sgForm5.Cells[8,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[8,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[8,ind]))]);
          sgForm5.Cells[9,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[9,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[9,ind]))]);
          sgForm5.Cells[10,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[10,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[10,ind]))]);
          sgForm5.Cells[11,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[11,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[11,ind]))]);
          sgForm5.Cells[12,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[12,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[12,ind]));
          sgForm5.Cells[13,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[13,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[13,ind]));
          sgForm5.Cells[14,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[14,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[14,ind]));
          sgForm5.Cells[15,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[15,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[15,ind]));
          sgForm5.Cells[16,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[16,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[16,ind]));
          sgForm5.Cells[17,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[17,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[17,ind]));
          sgForm5.Cells[18,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[18,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[18,ind]));
          sgForm5.Cells[19,iForm5] := FORMAT('%8.4f',[(formstart.StrToFloat( sgForm5.Cells[19,iForm5])
                                                 +formstart.StrToFloat(sgForm5.Cells[19,ind]))]);

     //     sgForm5.Cells[7,iForm5] := sgForm5.Cells[7,iForm5]+sgForm5.Cells[7,ind];
     //     sgForm5.Cells[8,iForm5] := sgForm5.Cells[8,iForm5]+sgForm5.Cells[8,ind];
     //     sgForm5.Cells[9,iForm5] := sgForm5.Cells[9,iForm5]+sgForm5.Cells[9,ind];
     //     sgForm5.Cells[10,iForm5] := sgForm5.Cells[10,iForm5]+sgForm5.Cells[10,ind];
     //     sgForm5.Cells[11,iForm5] := sgForm5.Cells[11,iForm5]+sgForm5.Cells[11,ind];
     //     sgForm5.Cells[12,iForm5] := sgForm5.Cells[12,iForm5]+sgForm5.Cells[12,ind];
     //     sgForm5.Cells[13,iForm5] := sgForm5.Cells[13,iForm5]+sgForm5.Cells[13,ind];
     //     sgForm5.Cells[14,iForm5] := sgForm5.Cells[14,iForm5]+sgForm5.Cells[14,ind];
     //     sgForm5.Cells[15,iForm5] := sgForm5.Cells[15,iForm5]+sgForm5.Cells[15,ind];
      //    sgForm5.Cells[16,iForm5] := sgForm5.Cells[16,iForm5]+sgForm5.Cells[16,ind];
      //    sgForm5.Cells[17,iForm5] := sgForm5.Cells[17,iForm5]+sgForm5.Cells[17,ind];
          sgForm5.DeleteRow(ind);
          ind:=ind-1;
        end;
      ind:=ind+1;
    end;
    sgForm5.Cells[6,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[6,iForm5]));
    vsumm:= formstart.StrToFloat( sgForm5.Cells[6,iForm5]);
    sgForm5.Cells[7,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[7,iForm5]));
    vsumm:= vsumm+ formstart.StrToFloat( sgForm5.Cells[7,iForm5]);
    sgForm5.Cells[8,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[8,iForm5]));
    vsumm:= vsumm+formstart.StrToFloat( sgForm5.Cells[8,iForm5]);
    sgForm5.Cells[9,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[9,iForm5]));
    vsumm:= vsumm+formstart.StrToFloat( sgForm5.Cells[9,iForm5]);
    sgForm5.Cells[10,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[10,iForm5]));
    vsumm:= vsumm+formstart.StrToFloat( sgForm5.Cells[10,iForm5]);
    sgForm5.Cells[11,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[11,iForm5]));
    vsumm:= vsumm+formstart.StrToFloat( sgForm5.Cells[11,iForm5]);
    sgForm5.Cells[12,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[12,iForm5]));
    vsumm:= vsumm+formstart.StrToFloat( sgForm5.Cells[12,iForm5]);
    sgForm5.Cells[13,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[13,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[13,iForm5]);
    sgForm5.Cells[14,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[14,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[14,iForm5]);
    sgForm5.Cells[15,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[15,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[15,iForm5]);
    sgForm5.Cells[16,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[16,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[16,iForm5]);
    sgForm5.Cells[17,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[17,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[17,iForm5]);
    sgForm5.Cells[18,iForm5] := floattostr(formstart.StrToFloat( sgForm5.Cells[18,iForm5]));
    vsumm:= vsumm-formstart.StrToFloat( sgForm5.Cells[18,iForm5]);
    sgForm5.Cells[19,iForm5] := FORMAT('%8.4f',[vsumm]);
    for i:=6 to 19 do
      arrsum[i]:=arrsum[i]+formstart.StrToFloat(sgForm5.Cells[i,iForm5]);
    iForm5:=iForm5+1;
  end;
  iForm5:=sgForm5.RowCount;
  sgForm5.RowCount:=iForm5+1;
  sgForm5.Cells[0,iForm5]:='1';
  for i:=6 to 19 do
    sgForm5.Cells[i,iForm5]:=format('%8.4f',[arrsum[i]]);
end;

procedure TFormExportForm5.bbFormRefreshClick(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  iform5,
  i:integer;
  optind1:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
  indCl:integer;
  flError:string;
  sum6:Real;
  sum7:real;
  sum7ret:real;
  typecln:string;
  str2,str3:string;
begin
  // ====
  FormShowStatus.Panel1.Caption:='Формируем отчет,'+#13#10+' это займет некоторое время.';
  FormShowStatus.Show;
  Application.ProcessMessages;
  indCl:=1;
  bbOldForm5.Enabled:=true;
  // >>>>>>>>>>> форма 5 <<<<<<<<<<<<<<<<<<
  Query:='SELECT `spproduct`.`clientregid` AS `ipproducer`,'+
  ' `spproduct`.`productvcode`  AS `vcode`,'+
  ' REPLACE(FORMAT(SUM(`doc23`.`count`*`spproduct`.`capacity`*0.1),3),'','','''') AS `dal1`,'+
  ' ''0'','+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prkpp`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprkpp`,'+
  ' `spproduct`.`import` AS `prdimport`,' +
  ' `spproduct`.`iclientregid` AS `impprod`,'+
  ' '''' '+
  ' '+
  ' FROM `spproduct`,`doc23`,`docjurnale` '+
  ' WHERE `docjurnale`.`numdoc`=`doc23`.`numdoc` AND `docjurnale`.`datedoc`=`doc23`.`datedoc` AND `docjurnale`.`type`=''ActWriteOff'' AND `docjurnale`.`isdelete`<>''+'' AND  (`doc23`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`doc23`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''') AND `spproduct`.`alccode`=`doc23`.`alccode` '+
  ' GROUP BY `spproduct`.`productvcode`,`spproduct`.`clientregid`  '+
  ' ORDER BY `spproduct`.`productvcode`,`spproduct`.`clientregid` ASC;';
   xrecbuf:= formstart.DB_query(Query);
   xrowbuf:=formStart.DB_Next(xrecbuf);
  sgForm5.Clean;
  sgForm5.RowCount:=1;
  i:=1;
  while xrowbuf<>nil do begin
   sgForm5.RowCount:=i+1;
   sgForm5.Cells[1,i]:=xrowbuf[1]; // ИМНС
   if xrowbuf[10] = '1' then begin
       sgForm5.Cells[2,i]:=xrowbuf[11];
       sgForm5.Cells[3,i]:=xrowbuf[7];
       sgForm5.Cells[4,i]:=xrowbuf[8];
       sgForm5.Cells[5,i]:=xrowbuf[9];
     end else begin
       sgForm5.Cells[2,i]:=xrowbuf[0];
       sgForm5.Cells[3,i]:=xrowbuf[4];
       sgForm5.Cells[4,i]:=xrowbuf[5];
       sgForm5.Cells[5,i]:=xrowbuf[6];
     end;
   sgForm5.Cells[16,i]:=xrowbuf[2] ;
   i:=i+1;
   xrowbuf:=formStart.DB_Next(xrecbuf);
  end;


  // >>>>>>>>>>>>>> Формируем 7 форму <<<<<<<<<<<<<<<<<<<<<<<<<
  Query:='SELECT  `spproduct`.`clientregid` AS `ipproducer`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prkpp`,'+
  ' `spproduct`.`import` '+
  ' FROM `spproduct`,`doc21`'+
  ' WHERE (`doc21`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`doc21`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''') AND (`spproduct`.`alccode`=`doc21`.`alcitem` )'+
  ' GROUP BY `spproduct`.`clientregid` '+
  ' ORDER BY `spproduct`.`clientregid` ASC;';
  xrecbuf:= formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  sgProducer.Clean;
  sgProducer.RowCount:=1;
  i:=1;
  while xrowbuf<>nil do begin
     if xrowbuf[2]<> '' then begin
       sgProducer.RowCount:=i+1;
       sgProducer.Cells[1,i]:=xrowbuf[0];
       sgProducer.Cells[2,i]:=xrowbuf[1];
       sgProducer.Cells[3,i]:=xrowbuf[2];
       sgProducer.Cells[4,i]:=xrowbuf[3];
       sgProducer.Cells[5,i]:=xrowbuf[4];
       i:=i+1;
     end;
     xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  // >>>>>>>>>>>>>> Формируем 7 форму <<<<<<<<<<<<<<<<<<<<<<<<<
  Query:='SELECT  `spproduct`.`clientregid` AS `ipproducer`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prkpp`,'+
  ' `spproduct`.`import` '+
  ' FROM `spproduct`,`doc221`'+
  ' WHERE (`doc221`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`doc221`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''') AND `spproduct`.`alccode`=`doc221`.`alcitem` '+
  ' GROUP BY `spproduct`.`clientregid` '+
  ' ORDER BY `spproduct`.`clientregid` ASC;';
  xrecbuf:= formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
    i:=1;
    while (i< sgProducer.RowCount-1) and(sgProducer.Cells[1,i]<>xrowbuf[0]) do
     i:=i+1;
    if  sgProducer.Cells[1,i]<>xrowbuf[0] then
      begin
       i:= sgProducer.RowCount;
     if xrowbuf[2]<> '' then begin
       sgProducer.RowCount:=i+1;
       sgProducer.Cells[1,i]:=xrowbuf[0];
       sgProducer.Cells[2,i]:=xrowbuf[1];
       sgProducer.Cells[3,i]:=xrowbuf[2];
       sgProducer.Cells[4,i]:=xrowbuf[3];
       sgProducer.Cells[5,i]:=xrowbuf[4];
       i:=i+1;
     end;
     end;
     xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  // >>>>>>>>>>>>>> Формируем 6 форму <<<<<<<<<<<<<<<<<<<<<<<<<
  Query:='SELECT `doc21`.`numdoc`,DATE_FORMAT(`doc21`.`datedoc`, ''%d.%m.%Y'') AS `data1`, `spproduct`.`clientregid` AS `ipproducer`,'+
  ' `docjurnale`.`ClientRegId`  AS `regClient`,'+
  ' `spproduct`.`productvcode`  AS `vcode`,'+
  ' REPLACE(FORMAT(SUM(`doc21`.`valuetov`*`spproduct`.`capacity`*0.1),3),'','','''') AS `dal1`,'+
  ' REPLACE(FORMAT(SUM(`doc21`.`factcount`*`spproduct`.`capacity`*0.1),3),'','','''') AS `dal2`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE ((`spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) or (`spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`)) AND `spproducer`.`inn`<>"" ) AS `prname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prkpp`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clkpp`, '+
  '`docjurnale`.`issueclient`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprkpp`,'+
  ' `spproduct`.`import` AS `prdimport123`,' +
  ' `spproduct`.`iclientregid` AS `impprod123`,'+
  ' `docjurnale`.`type`  AS `type1`,'+
  ' (SELECT `typeproducer` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `typeproducer`'+
  ' FROM `spproduct`,`doc21`,`docjurnale` '+
  ' WHERE `docjurnale`.`numdoc`=`doc21`.`numdoc` AND `docjurnale`.`datedoc`=`doc21`.`datedoc` AND `docjurnale`.`registry`=''-'' AND `docjurnale`.`isdelete`<>''+'' AND (`doc21`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`doc21`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''') AND `spproduct`.`alccode`=`doc21`.`alcitem` '+
  ' GROUP BY `doc21`.`numdoc`,`spproduct`.`clientregid`,`spproduct`.`productvcode` ,`docjurnale`.`issueclient`'+
  ' ORDER BY `spproduct`.`productvcode`,`spproduct`.`clientregid` ASC;';
  xrecbuf:= formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  sgSales6.Clean;
  sgSales6.RowCount:=1;
  i:=1;
  sum6:=0;
  while xrowbuf<>nil do begin
     i:=sgSales6.RowCount;
     sgSales6.RowCount:=i+1;

     sgSales6.Cells[11,i]:=xrowbuf[1];
     sgSales6.Cells[10,i]:=xrowbuf[0];
     sgSales6.Cells[6,i]:=xrowbuf[3];
     sgSales6.Cells[1,i]:=xrowbuf[4];
     optind1:=12;
     if  xrowbuf[2] = xrowbuf[16] then
       optind1:=12;
     if  db_boolean(xrowbuf[13]) then // **** разница недовоз
        sgSales6.Cells[12,i]:=xrowbuf[6]
     else
        sgSales6.Cells[12,i]:=xrowbuf[5]; // 6

     if (xrowbuf[17]<>'1')AND(xrowbuf[8]<>'') then begin
       sgSales6.Cells[2,i]:=xrowbuf[2];
       sgSales6.Cells[3,i]:=xrowbuf[7];
       sgSales6.Cells[4,i]:=xrowbuf[8];
       sgSales6.Cells[5,i]:=xrowbuf[9];
     end else begin
       sgSales6.Cells[2,i]:=xrowbuf[18];
       sgSales6.Cells[3,i]:=xrowbuf[14];
       sgSales6.Cells[4,i]:=xrowbuf[15];
       sgSales6.Cells[5,i]:=xrowbuf[16];
     end;
     sgSales6.Cells[7,i]:=xrowbuf[10];
     sgSales6.Cells[8,i]:=xrowbuf[11];
     sgSales6.Cells[9,i]:=xrowbuf[12];
     sum6:=sum6+formstart.StrToFloat(sgSales6.Cells[12,i]);
     // ==== форма 5 ============
     i:=sgForm5.RowCount;
     sgForm5.RowCount:=i+1;
     sgForm5.Cells[1,i]:=xrowbuf[4]; // ИМНС
     if (xrowbuf[17]<>'1')AND(xrowbuf[8]<>'') then begin
         sgForm5.Cells[2,i]:=xrowbuf[2];
         sgForm5.Cells[3,i]:=xrowbuf[7];
         sgForm5.Cells[4,i]:=xrowbuf[8];
         sgForm5.Cells[5,i]:=xrowbuf[9];
       end else begin
         sgForm5.Cells[2,i]:=xrowbuf[18];
         sgForm5.Cells[3,i]:=xrowbuf[14];
         sgForm5.Cells[4,i]:=xrowbuf[15];
         sgForm5.Cells[5,i]:=xrowbuf[16];
       end;
       if (flTransferToShop)and(formstart.FirmINN = xrowbuf[11]) then begin
         sgForm5.Cells[18,i]:=xrowbuf[5];
        end
         else begin
           typecln:=xrowbuf[20];
           if  (typecln ='')or(typecln ='06') then begin
              if  db_boolean(xrowbuf[13])  then
                 sgForm5.Cells[14,i]:=xrowbuf[6]  // 6
               else
                 sgForm5.Cells[14,i]:=xrowbuf[5] ;
            end else  begin
              if  db_boolean(xrowbuf[13]) then
                 sgForm5.Cells[13,i]:=xrowbuf[6]  // 6
               else
                 sgForm5.Cells[13,i]:=xrowbuf[5] ;
            end;
        end;
     // =========================

     xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  i:=sgSales6.RowCount;
 sgSales6.RowCount:=i+1;
  sgSales6.Cells[0,i]:='1';
  sgSales6.Cells[12,i]:= format('%7.3f',[sum6]);
  // >>>>>>> форма 6 <<<<<<<
  sum7:=0;
  sum7ret:=0;
  sgBuy7.RowCount:=1;
  i:=1;
  Query:='SELECT `doc221`.`numdoc`,DATE_FORMAT(`doc221`.`datedoc`, ''%d.%m.%Y'') AS `data1`, `spproduct`.`clientregid` AS `ipproducer`,'+
  ' `docjurnale`.`ClientRegId`  AS `regClient`,'+
  ' `spproduct`.`productvcode`  AS `vcode`,'+
  ' REPLACE(FORMAT(SUM(`doc221`.`factcount`*`spproduct`.`capacity`*0.1),3),'','','''') AS `dal1`,''0'','+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId`) AS `prkpp`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`docjurnale`.`ClientRegId`) AS `clkpp`,'+
  ' (SELECT `fullname` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprname`,'+
  ' (SELECT `inn` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprinn`,'+
  ' (SELECT `kpp` FROM `spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`iClientRegId`) AS `iprkpp`,'+
  ' `spproduct`.`iclientregid` AS `impproducer`,' +
  ' `docjurnale`.`issueclient`,'+
  ' `docjurnale`.`type` '+
  ' FROM `spproduct`,`doc221`,`docjurnale` '+
  ' WHERE `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`docid`=`doc221`.`docid` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` AND `docjurnale`.`registry`=''+'' '+
  ' AND `docjurnale`.`status`=''+++'' '+
  ' AND (`doc221`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`doc221`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''') AND `spproduct`.`alccode`=`doc221`.`alcitem` '+
  ' GROUP BY `doc221`.`docid`,`spproduct`.`clientregid`,`spproduct`.`iclientregid`,`spproduct`.`productvcode`'+
  ' ORDER BY `spproduct`.`productvcode`,`spproduct`.`clientregid` ASC;';
  xrecbuf:= formstart.DB_query(Query);
  xrowbuf:=formStart.DB_Next(xrecbuf);
  sgBuy7.Clean;
  sgBuy7.RowCount:=1;
  sgBuy7ret.Clean;
  sgBuy7ret.RowCount:=1;
  i:=1;
  while xrowbuf<>nil do begin
    if xrowbuf[18] <> 'RetWayBill' then begin
     i:=sgBuy7.RowCount;
     sgBuy7.RowCount:=i+1;
     sgBuy7.Cells[2,i]:=xrowbuf[2];
     sgBuy7.Cells[11,i]:=xrowbuf[1];
     sgBuy7.Cells[10,i]:=xrowbuf[0];
     sgBuy7.Cells[6,i]:=xrowbuf[3];
     sgBuy7.Cells[1,i]:=xrowbuf[4];
     sgBuy7.Cells[12,i]:=xrowbuf[5]; // 6
     sgBuy7.Cells[3,i]:=xrowbuf[7];
     sgBuy7.Cells[4,i]:=xrowbuf[8];
     sgBuy7.Cells[5,i]:=xrowbuf[9];
     sgBuy7.Cells[7,i]:=xrowbuf[10];
     sgBuy7.Cells[8,i]:=xrowbuf[11];
     sgBuy7.Cells[9,i]:=xrowbuf[12];
     if xrowbuf[16]<>'' then begin
        sgBuy7.Cells[2,i]:=xrowbuf[16];
        sgBuy7.Cells[3,i]:=xrowbuf[13];
        sgBuy7.Cells[4,i]:=xrowbuf[14];
        sgBuy7.Cells[5,i]:=xrowbuf[15];
       end;
     sum7:=sum7+formstart.StrToFloat(sgBuy7.Cells[12,i]);
    end else begin
       i:=sgBuy7ret.RowCount;
       sgBuy7ret.RowCount:=i+1;
       sgBuy7ret.Cells[2,i]:=xrowbuf[2];
       sgBuy7ret.Cells[11,i]:=xrowbuf[1];
       sgBuy7ret.Cells[10,i]:=xrowbuf[0];
       sgBuy7ret.Cells[6,i]:=xrowbuf[3];
       sgBuy7ret.Cells[1,i]:=xrowbuf[4];
       sgBuy7ret.Cells[12,i]:=xrowbuf[5]; // 6
       sgBuy7ret.Cells[3,i]:=xrowbuf[7];
       sgBuy7ret.Cells[4,i]:=xrowbuf[8];
       sgBuy7ret.Cells[5,i]:=xrowbuf[9];
       sgBuy7ret.Cells[7,i]:=xrowbuf[10];
       sgBuy7ret.Cells[8,i]:=xrowbuf[11];
       sgBuy7ret.Cells[9,i]:=xrowbuf[12];
       if xrowbuf[16]<>'' then begin
          sgBuy7ret.Cells[2,i]:=xrowbuf[16];
          sgBuy7ret.Cells[3,i]:=xrowbuf[13];
          sgBuy7ret.Cells[4,i]:=xrowbuf[14];
          sgBuy7ret.Cells[5,i]:=xrowbuf[15];
         end;
       sum7ret:=sum7ret+formstart.StrToFloat(sgBuy7ret.Cells[12,i]);
      end;
      optind1:=8;
      if (flProducerEn) and (xrowbuf[18] <> 'RetWayBill') then begin
        str2:= trim(xrowbuf[8]);
        str3:= trim(xrowbuf[11]);
        if str2 = str3 then
          optind1:=7;
       end
        else begin
        str2:= trim(xrowbuf[2]);
        str3:= trim(xrowbuf[3]);
      if str2 = str3 then
        optind1:=7;
      end;
      if xrowbuf[18] = 'RetWayBill' then
        optind1:=10;
      iform5:= sgform5.RowCount;
      sgform5.RowCount:=iform5+1;
      sgform5.cells[1,iform5]:=xrowbuf[4];
      sgform5.Cells[2,iform5]:=xrowbuf[2];
      sgform5.Cells[3,iform5]:=xrowbuf[7];
      sgform5.Cells[4,iform5]:=xrowbuf[8];
      sgform5.Cells[5,iform5]:=xrowbuf[9];
      if xrowbuf[16]<>'' then begin
        sgform5.Cells[2,iform5]:=xrowbuf[16];
        sgform5.Cells[3,iform5]:=xrowbuf[13];
        sgform5.Cells[4,iform5]:=xrowbuf[14];
        sgform5.Cells[5,iform5]:=xrowbuf[15];
       end;
      // 7,8,9

      sgform5.Cells[optind1,iform5]:=xrowbuf[5]; // 6

      // ================================

     xrowbuf:=formStart.DB_Next(xrecbuf);
  end;
  i:=sgBuy7ret.RowCount;
  sgBuy7ret.RowCount:=i+1;
  sgBuy7ret.Cells[0,i]:='1';
  sgBuy7ret.Cells[12,i]:= format('%7.4f',[sum7ret]);

  i:=sgBuy7.RowCount;
  sgBuy7.RowCount:=i+1;
  sgBuy7.Cells[0,i]:='1';
  sgBuy7.Cells[12,i]:= format('%7.4f',[sum7]);
  TrunForm5();
  // ==== заполнение справочника клиентов


  query:='SELECT `spproducer`.`clientregid`,`spproducer`.`fullname`,`spproducer`.`inn`,`spproducer`.`kpp`,`spproducer`.`description`,`spproducer`.`addressimns`,`docjurnale`.`registry`,`spproducer`.`region`,`spproducer`.`email` FROM `spproducer`,`docjurnale` WHERE `spproducer`.`clientregid`=`docjurnale`.`clientregid`  AND (`docjurnale`.`datedoc`>= '''+FormatDateTime('YYYY-MM-DD',flStartDate)+''')AND(`docjurnale`.`datedoc`<= '''+FormatDateTime('YYYY-MM-DD',flEndDate)+''')  AND (`docjurnale`.`type` = ''WayBill'' OR `docjurnale`.`type` = ''RetWayBill'' OR `docjurnale`.`type` = ''WAYBILL'')  GROUP BY `docjurnale`.`clientregid`,`docjurnale`.`registry`;';
  xrecbuf:= formStart.DB_query(Query);
  xrowbuf:= formStart.DB_Next(xrecbuf);
  sgClients.Clean;
  i:=1;
  sgClients.RowCount:=1;
  while  xrowbuf<>nil do begin
    flError:='';
     if not CheckedAddress(xrowbuf[5]) then
        flError:='*';
     query:='SELECT DATE_FORMAT(`startdatelic`, ''%d.%m.%Y'') AS `data1`,DATE_FORMAT(`enddatelic`, ''%d.%m.%Y'') AS `data2`,`serlic`,`numlic`,`deplic`,`imns` FROM `splicproducer` WHERE  `clientregid`="'+xrowbuf[0]+'" AND (`startdatelic`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'")  ; '; // AND  `startdatelic`<>"0000-00-00"
     FormStart.recbuf:= formStart.DB_query(Query);
     FormStart.rowbuf:= formStart.DB_Next(FormStart.recbuf);
     if ( FormStart.rowbuf <> nil) then begin
        while FormStart.rowbuf <> nil do begin
         sgClients.RowCount:=i+1;
         if FormStart.rowbuf[0]='00.00.0000' then
             flError:='*';
         if FormStart.rowbuf[1]='00.00.0000' then
             flError:='*';

         sgClients.Cells[0,i]:= flError;
         sgClients.Cells[1,i]:= xrowbuf[0];
         sgClients.Cells[2,i]:= xrowbuf[1];
         sgClients.Cells[3,i]:= xrowbuf[2];
         sgClients.Cells[4,i]:= xrowbuf[3];
         sgClients.Cells[5,i]:= xrowbuf[4];
         sgClients.Cells[6,i]:= FormStart.rowbuf[0];
         sgClients.Cells[7,i]:= FormStart.rowbuf[1];
         sgClients.Cells[8,i]:= FormStart.rowbuf[2];
         sgClients.Cells[9,i]:= FormStart.rowbuf[3];
         sgClients.Cells[10,i]:= FormStart.rowbuf[4];
         sgClients.Cells[11,i]:= xrowbuf[5];
         sgClients.Cells[12,i]:= xrowbuf[6];
         sgClients.Cells[13,i]:= inttostr(indCl);
         sgClients.Cells[14,i]:= xrowbuf[7];
         sgClients.Cells[15,i]:= FormStart.rowbuf[5];
         sgClients.Cells[16,i]:= xrowbuf[8];
         FormStart.rowbuf:= formStart.DB_Next(FormStart.recbuf);
         i:=i+1;
        end;
       end else
       begin
         sgClients.RowCount:=i+1;
         sgClients.Cells[0,i]:= flError;
         sgClients.Cells[1,i]:= xrowbuf[0];
         sgClients.Cells[2,i]:= xrowbuf[1];
         sgClients.Cells[3,i]:= xrowbuf[2];
         sgClients.Cells[4,i]:= xrowbuf[3];
         sgClients.Cells[5,i]:= xrowbuf[4];
         sgClients.Cells[12,i]:= xrowbuf[6];
         sgClients.Cells[11,i]:= xrowbuf[5];
         sgClients.Cells[13,i]:= inttostr(indCl);
         sgClients.Cells[14,i]:= xrowbuf[7];
         i:=i+1;
       end;

     indCl:=indCl+1;
     xrowbuf:= formStart.DB_Next(xrecbuf);
  end;

  FormShowStatus.Hide;
end;

procedure TFormExportForm5.bbEmailClientsClick(Sender: TObject);
begin
  formsendemails.ShowOnTop;
end;

procedure TFormExportForm5.BitBtn2Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  ind, ind2,
  i:integer;
  ii,iii:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
  period:string;
  findSp:integer;
  findcl:integer;
  curcl:string;
  flObor:boolean;
  pppy,pppm,pppd:word;
  flLic:boolean;
begin

   DecodeDate(flstartdate, pppy, pppm, pppd);
  if (pppm>=1) and (pppm<=3) then
       pppm:=3;
       if (pppm>=4) and (pppm<=6) then
        pppm:=6;
       if (pppm>=7) and (pppm<=9) then
        pppm:=9;
       if (pppm>=10) and (pppm<=12) then
        pppm:=0;
        Lists:=TStringList.Create;
        Lists.Clear;
        i:=1;
        Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
        Lists.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',flEndDate)+'" ВерсФорм="4.31" НаимПрог="'+NameApp+' '+CurVer+'">');
        Lists.add('<Справочники>');
        for i:=1 to sgClients.RowCount-1 do
        if sgClients.cells[12,i]<>'+' then
        begin
         Lists.add('<Контрагенты ИдКонтр="'+inttostr(i)+'" П000000000007="'+replacestr5(sgClients.cells[2,i],false)+'">');
           Lists.add(' <Резидент>');
               flLic:=true;
               if sgClients.cells[9,i]<>'' then
                begin
                 if flLic then begin
                   Lists.add(' <Лицензии>');
                   flLic:=false;
                 end;
                 Lists.add('  <Лицензия ИдЛицензии="'+inttostr(i)+'" П000000000011="'+sgClients.cells[9,i]+'" П000000000012="'+sgClients.cells[6,i]+'" П000000000013="'+sgClients.cells[7,i]+'" П000000000014="'+replaceStr5(sgClients.cells[10,i])+'"/> ')
                end;
               if not flLic then
                 Lists.add(' </Лицензии>');
           Lists.add('<П000000000008>');

           Lists.add(GetIMNStoXML(sgClients.cells[11,i],sgClients.cells[14,i]));

           Lists.add('</П000000000008>');
                 if sgClients.cells[4,i]<>'' then
                  Lists.add('  <ЮЛ П000000000009="'+sgClients.cells[3,i]+'" П000000000010="'+sgClients.cells[4,i]+'"/> ')
                 else
                  Lists.add('  <ФЛ П000000000009="'+sgClients.cells[3,i]+'" /> ');
                 Lists.add(' </Резидент>');
         Lists.add(' </Контрагенты>');
        end;
        for i:=1 to sgProducer.RowCount-1 do
        begin
         Lists.add('<ПроизводителиИмпортеры ИдПроизвИмп="'+inttostr(i)+'" П000000000004="'+replaceStr5(sgProducer.cells[2,i],false)+'"');
         if sgProducer.cells[4,i]<>'' then
          Lists.add('   П000000000005="'+sgProducer.cells[3,i]+'" П000000000006="'+sgProducer.cells[4,i]+'"/> ')
         else
          Lists.add('   П000000000005="'+sgProducer.cells[3,i]+'" /> ');
        // Lists.add(' </ПроизводителиИмпортеры>');
        end;

        Lists.add('</Справочники>');
        Lists.add('<ФормаОтч НомФорм="06" ПризПериодОтч="'+inttostr(pppm)+'" ГодПериодОтч="'+FormatDateTime('YYYY',flEndDate)+'" >');
        Lists.add('<Первичная/>');
        Lists.add('</ФормаОтч>');
        Lists.add('<Документ>');
        Lists.add('<Организация>');
        Lists.add('<Реквизиты Наим="'+replaceStr5(formstart.FirmFullName,false)+'" ТелОрг="'+formstart.GetConstant('telephone')+'" EmailОтпр="'+formstart.GetConstant('email')+'" >');
        Lists.add(' <АдрОрг>');
        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс></Индекс>');
        Lists.add('  <КодРегион>61</КодРегион>');
        Lists.add('   <Район></Район>');
        Lists.add('  <Город></Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица></Улица>');
        Lists.add('  <Дом></Дом>');
        Lists.add('  <Корпус></Корпус>');
        Lists.add('  <Кварт></Кварт> ');
        Lists.add('</АдрОрг>');
        if formstart.FirmKPP<>'' then begin
          Lists.add('<ЮЛ ИННЮЛ="'+formstart.FirmINN+'" КППЮЛ="'+formstart.FirmKPP+'"/>');
        end else
          Lists.add('<ФЛ ИННФЛ="'+formstart.FirmINN+'"/>');
        Lists.add('</Реквизиты>');
        Lists.add('<ОтветЛицо>');
        Lists.add(' <Руководитель >');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество>');
        Lists.add(' </Руководитель>');
        Lists.add(' <Главбух>');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество> ');
        Lists.add(' </Главбух>');
        Lists.add('</ОтветЛицо>');
        Lists.add('<Деятельность >');
        Lists.add(' <Лицензируемая >');
        Lists.add('  <Лицензия ВидДеят="03" СерНомЛиц="61ЗАП0005203" ДатаНачЛиц="15.02.2016" ДатаОконЛиц="20.06.2021" />');
        Lists.add(' </Лицензируемая>');
        Lists.add('</Деятельность>');
        Lists.add('</Организация>');

        if formstart.FirmKPP<>'' then begin
        Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" КППЮЛ="'+formstart.FirmKPP+'" НаличиеПоставки="false" НаличиеВозврата="false" >');
        Lists.add(' <АдрОрг>');
        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс></Индекс>');
        Lists.add('  <КодРегион>61</КодРегион>');
        Lists.add('   <Район></Район>');
        Lists.add('  <Город></Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица></Улица>');
        Lists.add('  <Дом></Дом>');
        Lists.add('  <Корпус></Корпус>');
        Lists.add('  <Кварт></Кварт> ');
         Lists.add('</АдрОрг>');
        end
        else
         Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" НаличиеПоставки="true" НаличиеВозврата="false" >');
        //==== адрес
        // =========================
        ii:=0;
        iii:=0;
        curimns:='';
        curIdClient:='';
        for i:=1 to sgForm5.RowCount-1 do  begin
           findcl:=1;
           ind2:=1;
           curcl:='';
           flObor := false;

            for ind:=1 to sgSales6.RowCount-1 do begin
             if ((sgSales6.Cells[1,ind]=sgForm5.cells[1,i] )and(sgSales6.Cells[2,ind]=sgForm5.cells[2,i]))and(sgSales6.Cells[0,ind]<>'1') then
               begin
                  if curimns<> sgForm5.cells[1,i] then begin
                    if curIdClient<>'' then
                     Lists.add('</СведПроизвИмпорт>');
                    if curimns<>'' then
                      Lists.add('</Оборот>');
                    curimns:= sgForm5.cells[1,i];
                    ii:=ii+1;
                    Lists.add('<Оборот ПN="'+inttostr(ii)+'" П000000000003="'+curimns+'">');
                    curIdClient:='';
                    iii:=0;
                   end;
                  if  curIdClient <> sgForm5.cells[2,i] then begin
                    if curIdClient<>'' then
                       Lists.add('</СведПроизвИмпорт>');
                    iii:=iii+1;
                    curIdClient:=sgForm5.cells[2,i];
                    findSp:=1 ;
                    while (sgProducer.cells[1,findSp] <>  curIdClient ) and(sgProducer.RowCount-1>findSp) do
                      findSp:=findSp+1;
                    Lists.add('<СведПроизвИмпорт ПN="'+inttostr(iii)+'" ИдПроизвИмп="'+inttostr(findSp)+'">');
                  end;
                 if curcl<>sgSales6.Cells[6,ind] then
                   begin
                    if curcl<>'' then
                      Lists.add('</Получатель>');
                    findcl:=1;
                    curcl:=sgSales6.Cells[6,ind] ;
                    while ((sgClients.cells[1,findcl] <>  curcl )or(sgClients.cells[12,findcl]='+') )and(sgClients.RowCount-1>findcl) do
                     findcl:=findcl+1;
                    Lists.add('<Получатель ПN="'+inttostr(ind2)+'" ИдПолучателя="'+inttostr(findcl)+'" >');
                    // ИдЛицензии="'+inttostr(findcl)+'"
                    ind2:=ind2+1;
                   end;
                 flObor :=true;
                 Lists.add('<Поставка П000000000018="'+sgSales6.Cells[11,ind]+'" П000000000019="'+sgSales6.Cells[10,ind]+'" П000000000020="" П000000000021="'+sgSales6.Cells[12,ind]+'"/>');
                 sgSales6.Cells[0,ind]:='1';
               end;
             end;
             if curcl<>'' then
                 Lists.add('</Получатель>');
//             Lists.add('<Движение ПN="1" П100000000006="'+stringgrid2.cells[7,i]+'" П100000000007="'+stringgrid2.cells[8,i]+'" П100000000008="'+stringgrid2.cells[9,i]+'" П100000000009="'+stringgrid2.cells[10,i]+'"'+
//                   ' П100000000010="'+format('%0.3f',[formstart.StrToFloat(stringgrid2.cells[8,i])+formstart.StrToFloat(stringgrid2.cells[9,i])+formstart.StrToFloat(stringgrid2.cells[10,i])])+'" П100000000011="'+stringgrid2.cells[11,i]+'"'+
//                   ' П100000000012="'+stringgrid2.cells[12,i]+'" П100000000013="'+stringgrid2.cells[13,i]+'" П100000000014="'+stringgrid2.cells[14,i]+'" П100000000015="'+stringgrid2.cells[14,i]+'" П100000000016="'+stringgrid2.cells[14,i]+'"'+
//                   ' П100000000017="'+stringgrid2.cells[17,i]+'" П100000000018="'+stringgrid2.cells[18,i]+'"/> ');

         end;

         if curIdClient<>'' then
             Lists.add('</СведПроизвИмпорт>');
         if curimns<>'' then
            Lists.add('</Оборот>');
         // ==== КонецЦикла =====
         Lists.add('</ОбъемОборота>');
         Lists.add('</Документ>');
         Lists.add('</Файл>');
    if sdd1.Execute then begin
      lists.Text:=utf8toansi(lists.Text);
      lists.SaveToFile(utf8toAnsi(sdd1.FileName+'\D6_'+formstart.FirmINN+'_'+Format('%.2d',[pppm])+'2_'+FormatDateTime('DDMMYYYY',now())+'_'+formstart.NewGUID()+'.xml'));
      Showmessage('Сформирован!');
    end;

end;

procedure TFormExportForm5.BitBtn3Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  ind, ind2,
  i:integer;
  ii,iii:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
  period:string;
  findSp:integer;
  findcl:integer;
  curcl:string;
  flObor:boolean;
  pppy,pppm,pppd:word;
  flLic:boolean;
  flfreelic:integer;
begin
   DecodeDate(flstartdate, pppy, pppm, pppd);
  if (pppm>=1) and (pppm<=3) then
       pppm:=3;
       if (pppm>=4) and (pppm<=6) then
        pppm:=6;
       if (pppm>=7) and (pppm<=9) then
        pppm:=9;
       if (pppm>=10) and (pppm<=12) then
        pppm:=0;
        Lists:=TStringList.Create;
        Lists.Clear;
        i:=1;
        Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
        Lists.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',flEndDate)+'" ВерсФорм="4.31" НаимПрог="'+NameApp+' '+CurVer+'">');

        Lists.add('<Справочники>');
        for i:=1 to sgProducer.RowCount-1 do
        begin
         Lists.add('<ПроизводителиИмпортеры ИдПроизвИмп="'+inttostr(i)+'" П000000000004="'+replaceStr5(sgProducer.cells[2,i],false)+'"');
         if sgProducer.cells[4,i]<>'' then
          Lists.add('   П000000000005="'+sgProducer.cells[3,i]+'" П000000000006="'+sgProducer.cells[4,i]+'"/> ')
         else
          Lists.add('   П000000000005="'+sgProducer.cells[3,i]+'" /> ');
         //Lists.add(' </ПроизводителиИмпортеры>');
        end;
        for i:=1 to sgClients.RowCount-1 do
        if sgClients.cells[12,i]='+' then
        begin
         sgClients.cells[13,i]:=inttostr(i);
         Lists.add('<Поставщики ИдПостав="'+inttostr(i)+'" П000000000007="'+replaceStr5(sgClients.cells[2,i],false)+'">');
         Lists.add(' <Резидент>');
//         Lists.add('<Лицензии>');
//             if sgClients.cells[4,i]<>'' then
//              begin
//               Lists.add('  <Лицензия ИдЛицензии="'+inttostr(i)+'" П000000000011="'+sgClients.cells[9,i]+'" П000000000012="'+sgClients.cells[6,i]+'" П000000000013="'+sgClients.cells[7,i]+'" П000000000014="'+replaceStr5(sgClients.cells[10,i])+'"/> ')
//              end;
//        Lists.add('</Лицензии>');

        flLic:=true;
        if sgClients.cells[9,i]<>'' then
         begin
          if flLic then begin
            Lists.add(' <Лицензии>');
            flLic:=false;
          end;
          Lists.add('  <Лицензия ИдЛицензии="'+inttostr(i)+'" П000000000011="'+sgClients.cells[9,i]+'" П000000000012="'+sgClients.cells[6,i]+'" П000000000013="'+sgClients.cells[7,i]+'" П000000000014="'+replaceStr5(sgClients.cells[10,i])+'"/> ')
         end;
        if not flLic then
          Lists.add(' </Лицензии>');
        Lists.add('<П000000000008>');

           Lists.add(GetIMNStoXML(sgClients.cells[11,i],sgClients.cells[14,i]));
            Lists.add('</П000000000008>');
         if sgClients.cells[4,i]<>'' then
          Lists.add('  <ЮЛ П000000000009="'+sgClients.cells[3,i]+'" П000000000010="'+sgClients.cells[4,i]+'"/> ')
         else
          Lists.add('  <ФЛ П000000000009="'+sgClients.cells[3,i]+'" /> ');
         Lists.add(' </Резидент>');
         Lists.add(' </Поставщики>');
        end;


        Lists.add('</Справочники>');

        Lists.add('<ФормаОтч НомФорм="07" ПризПериодОтч="'+inttostr(pppm)+'" ГодПериодОтч="'+FormatDateTime('YYYY',flEndDate)+'" >');
        Lists.add('<Первичная/>');
        Lists.add('</ФормаОтч>');
        Lists.add('<Документ>');
        Lists.add('<Организация>');
        Lists.add('<Реквизиты Наим="'+replaceStr5(formstart.FirmFullName,false)+'" ТелОрг="'+formstart.GetConstant('telephone')+'" EmailОтпр="'+formstart.GetConstant('email')+'" >');
        Lists.add(' <АдрОрг>');
        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс></Индекс>');
        Lists.add('  <КодРегион>61</КодРегион>');
       Lists.add('   <Район></Район>');
        Lists.add('  <Город></Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица></Улица>');
        Lists.add('  <Дом></Дом>');
        Lists.add('  <Корпус></Корпус>');
        Lists.add('  <Кварт></Кварт> ');
         Lists.add('</АдрОрг>');
        if formstart.FirmKPP<>'' then begin
          Lists.add('<ЮЛ ИННЮЛ="'+formstart.FirmINN+'" КППЮЛ="'+formstart.FirmKPP+'"/>');
        end else
        Lists.add('<ФЛ ИННФЛ="'+formstart.FirmINN+'"/>');
        Lists.add('</Реквизиты>');
        Lists.add('<ОтветЛицо>');
        Lists.add(' <Руководитель >');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество>');
        Lists.add(' </Руководитель>');
        Lists.add(' <Главбух>');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество> ');
        Lists.add(' </Главбух>');
        Lists.add('</ОтветЛицо>');
        Lists.add('<Деятельность >');
        Lists.add(' <Лицензируемая >');
        Lists.add('  <Лицензия ВидДеят="03" СерНомЛиц="61ЗАП0005203" ДатаНачЛиц="15.02.2016" ДатаОконЛиц="20.06.2021" />');
        Lists.add(' </Лицензируемая>');
        Lists.add('</Деятельность>');
        Lists.add('</Организация>');

        if formstart.FirmKPP<>'' then begin
          Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" КППЮЛ="'+formstart.FirmKPP+'" НаличиеЗакупки="false" НаличиеВозврата="false" >');
          Lists.add(' <АдрОрг>');
          Lists.add('  <КодСтраны>643</КодСтраны>');
          Lists.add('  <Индекс></Индекс>');
          Lists.add('  <КодРегион>61</КодРегион>');
          Lists.add('   <Район></Район>');
          Lists.add('  <Город></Город>');
          Lists.add('  <НаселПункт></НаселПункт>');
          Lists.add('  <Улица></Улица>');
          Lists.add('  <Дом></Дом>');
          Lists.add('  <Корпус></Корпус>');
          Lists.add('  <Кварт></Кварт> ');
           Lists.add('</АдрОрг>');
        end
        else
         Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" НаличиеЗакупки="true" НаличиеВозврата="false" >');
        //==== адрес
        // =========================
        ii:=0;
        iii:=0;
        curimns:='';
        curIdClient:='';
        for i:=1 to sgForm5.RowCount-1 do  begin
           findcl:=1;
           ind2:=1;
           curcl:='';
           flObor := false;
            for ind:=1 to sgbuy7.RowCount-1 do begin
             if ((sgbuy7.Cells[1,ind]=sgForm5.cells[1,i] )and(sgbuy7.Cells[2,ind]=sgForm5.cells[2,i]))and(sgbuy7.Cells[0,ind]<>'1') then
               begin
                 if curimns<> sgForm5.cells[1,i] then begin
                    if curIdClient<>'' then
                      Lists.add('</СведПроизвИмпорт>');
                    if curimns<>'' then
                      Lists.add('</Оборот>');
                    curimns:= sgForm5.cells[1,i];
                    ii:=ii+1;
                    Lists.add('<Оборот ПN="'+inttostr(ii)+'" П000000000003="'+curimns+'">');
                    curIdClient:='';
                    iii:=0;
                   end;
                  if  curIdClient <> sgForm5.cells[2,i] then begin
                   if curIdClient<>'' then
                      Lists.add('</СведПроизвИмпорт>');
                   iii:=iii+1;
                   curIdClient:=sgForm5.cells[2,i];
                   findSp:=1 ;
                   while (sgProducer.cells[1,findSp] <>  curIdClient ) and(sgProducer.RowCount-1>findSp) do
                     findSp:=findSp+1;
                   Lists.add('<СведПроизвИмпорт ПN="'+inttostr(iii)+'" ИдПроизвИмп="'+inttostr(findSp)+'">');
                   end;
                 if curcl<>sgbuy7.Cells[7,ind] then
                   begin
                    if curcl<>'' then
                      Lists.add('</Поставщик>');
                    findcl:=1;
                    curcl:=sgbuy7.Cells[6,ind] ;
                    flfreelic:=0;
                    while (((
                      (sgClients.cells[1,findcl] <>  curcl )
                      or
                      (sgClients.cells[12,findcl]<>'+') )or(sgClients.cells[15,findcl]<>curimns))
                      ) and(sgClients.RowCount-1>findcl) do begin
                       if ((sgClients.cells[15,findcl] = '')AND(sgClients.cells[1,findcl] =  curcl)) then
                           flfreelic:= findcl;

                     findcl:=findcl+1;
                    end;
                    if (flfreelic<>0 )and(sgClients.RowCount=(findcl+1)) then
                       findcl:= flfreelic;
                    Lists.add('<Поставщик ПN="'+inttostr(ind2)+'" ИдПоставщика="'+sgClients.cells[13,findcl]+'" >');
                    // ИдЛицензии="'+inttostr(findcl)+'"
                    ind2:=ind2+1;
                   end;
                 flObor :=true;
                 Lists.add('<Закупка П000000000018="'+sgbuy7.Cells[11,ind]+'" П000000000019="'+sgbuy7.Cells[10,ind]+'" П000000000020="" П000000000021="'+sgbuy7.Cells[12,ind]+'"/>');
                 sgbuy7.Cells[0,ind]:='1';
               end;
             end;
            for ind:=1 to sgbuy7ret.RowCount-1 do begin
             if ((sgbuy7ret.Cells[1,ind]=sgForm5.cells[1,i] )and(sgbuy7ret.Cells[2,ind]=sgForm5.cells[2,i]))and(sgbuy7ret.Cells[0,ind]<>'1') then
               begin
                 if curimns<> sgForm5.cells[1,i] then begin
                    if curIdClient<>'' then
                      Lists.add('</СведПроизвИмпорт>');
                    if curimns<>'' then
                      Lists.add('</Оборот>');
                    curimns:= sgForm5.cells[1,i];
                    ii:=ii+1;
                    Lists.add('<Оборот ПN="'+inttostr(ii)+'" П000000000003="'+curimns+'">');
                    curIdClient:='';
                    iii:=0;
                   end;
                  if  curIdClient <> sgForm5.cells[2,i] then begin
                   if curIdClient<>'' then
                      Lists.add('</СведПроизвИмпорт>');
                   iii:=iii+1;
                   curIdClient:=sgForm5.cells[2,i];
                   findSp:=1 ;
                   while (sgProducer.cells[1,findSp] <>  curIdClient ) and(sgProducer.RowCount-1>findSp) do
                     findSp:=findSp+1;
                   Lists.add('<СведПроизвИмпорт ПN="'+inttostr(iii)+'" ИдПроизвИмп="'+inttostr(findSp)+'">');
                   end;
                 if curcl<>sgbuy7ret.Cells[7,ind] then
                   begin
                    if curcl<>'' then
                      Lists.add('</Поставщик>');
                    findcl:=1;
                    curcl:=sgbuy7ret.Cells[6,ind] ;
                    while ((sgClients.cells[1,findcl] <>  curcl )
                        or(sgClients.cells[12,findcl]<>'+')
                        ) and(sgClients.RowCount-1>findcl) do
                     findcl:=findcl+1;
                    Lists.add('<Поставщик ПN="'+inttostr(ind2)+'" ИдПоставщика="'+sgClients.cells[13,findcl]+'" >');
                    // ИдЛицензии="'+inttostr(findcl)+'"
                    ind2:=ind2+1;
                   end;
                 flObor :=true;
                 Lists.add('<Возврат П000000000018="'+sgbuy7ret.Cells[11,ind]+'" П000000000019="'+sgbuy7ret.Cells[10,ind]+'" П000000000020="" П000000000021="'+sgbuy7ret.Cells[12,ind]+'"/>');
                 sgbuy7ret.Cells[0,ind]:='1';
               end;
             end;
             if curcl<>'' then
                 Lists.add('</Поставщик>');
        end;
        if curIdClient<>'' then
         Lists.add('</СведПроизвИмпорт>');
        if curimns<>'' then
          Lists.add('</Оборот>');
       // ==== КонецЦикла =====
       Lists.add('</ОбъемОборота>');
       Lists.add('</Документ>');
       Lists.add('</Файл>');
    if sdd1.Execute then begin
      lists.Text:=utf8toansi(lists.Text);
      lists.SaveToFile(utf8toAnsi(sdd1.FileName+'\D7_'+formstart.FirmINN+'_'+Format('%.2d',[pppm])+'2_'+FormatDateTime('DDMMYYYY',now())+'_'+formstart.NewGUID()+'.xml'));
      Showmessage('Сформирован!');
    end;


end;

procedure TFormExportForm5.BitBtn4Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  ind, ind2,
  i:integer;
  ii,iii:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
  period:string;
  findSp:integer;
  findcl:integer;
  curcl:string;
  flObor:boolean;
  pppy,pppm,pppd:word;
begin     // ==== форма 5 ========
   DecodeDate(flstartdate, pppy, pppm, pppd);
  if (pppm>=1) and (pppm<=3) then
       pppm:=3;
       if (pppm>=4) and (pppm<=6) then
        pppm:=6;
       if (pppm>=7) and (pppm<=9) then
        pppm:=9;
       if (pppm>=10) and (pppm<=12) then
        pppm:=0;
        Lists:=TStringList.Create;
        Lists.Clear;
        i:=1;
        Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
        Lists.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',flEndDate)+'" ВерсФорм="4.31" НаимПрог="'+NameApp+' '+CurVer+'">');
        Lists.add('<ФормаОтч НомФорм="05" ПризПериодОтч="'+inttostr(pppm)+'" ГодПериодОтч="'+FormatDateTime('YYYY',flEndDate)+'" >');
        Lists.add('<Первичная/>');
        Lists.add('</ФормаОтч>');
        Lists.add('<Документ>');
        Lists.add('<Организация>');
        Lists.add('<Реквизиты Наим="'+replaceStr5(formstart.FirmFullName,false)+'" ТелОрг="'+formstart.GetConstant('telephone')+'" EmailОтпр="'+formstart.GetConstant('email')+'" >');
        Lists.add(' <АдрОрг>');
        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс></Индекс>');
        Lists.add('  <КодРегион>61</КодРегион>');
       Lists.add('   <Район></Район>');
        Lists.add('  <Город></Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица></Улица>');
        Lists.add('  <Дом></Дом>');
        Lists.add('  <Корпус></Корпус>');
        Lists.add('  <Кварт></Кварт> ');
         Lists.add('</АдрОрг>');
        if formstart.FirmKPP<>'' then begin
          Lists.add('<ЮЛ ИННЮЛ="'+formstart.FirmINN+'" КППЮЛ="'+formstart.FirmKPP+'"/>');
        end else
          Lists.add('<ФЛ ИННФЛ="'+formstart.FirmINN+'"/>');
        Lists.add('</Реквизиты>');
        Lists.add('<ОтветЛицо>');
        Lists.add(' <Руководитель >');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество>');
        Lists.add(' </Руководитель>');
        Lists.add(' <Главбух>');
        Lists.add('  <Фамилия></Фамилия>');
        Lists.add('  <Имя></Имя>');
        Lists.add('  <Отчество></Отчество> ');
        Lists.add(' </Главбух>');
        Lists.add('</ОтветЛицо>');
        Lists.add('<Деятельность >');
        Lists.add(' <Лицензируемая >');
        Lists.add('  <Лицензия ВидДеят="03" СерНомЛиц="61ЗАП0005203" ДатаНачЛиц="15.02.2016" ДатаОконЛиц="20.06.2021" />');
        Lists.add(' </Лицензируемая>');
        Lists.add('</Деятельность>');
        Lists.add('</Организация>');


        if formstart.FirmKPP<>'' then begin
          Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" КППЮЛ="'+formstart.FirmKPP+'" НаличиеОборота="true" >');
          Lists.add(' <АдрОрг>');
          Lists.add('  <КодСтраны>643</КодСтраны>');
          Lists.add('  <Индекс></Индекс>');
          Lists.add('  <КодРегион>61</КодРегион>');
          Lists.add('   <Район></Район>');
          Lists.add('  <Город></Город>');
          Lists.add('  <НаселПункт></НаселПункт>');
          Lists.add('  <Улица></Улица>');
          Lists.add('  <Дом></Дом>');
          Lists.add('  <Корпус></Корпус>');
          Lists.add('  <Кварт></Кварт> ');
          Lists.add('</АдрОрг>');
        end else
          Lists.add('<ОбъемОборота Наим="'+replaceStr5(formstart.FirmFullName,false)+'" НаличиеОборота="true" >');
        //==== адрес
        // =========================
        ii:=0;
        iii:=0;
        curimns:='';
        for i:=1 to sgForm5.RowCount-1 do  begin
          if sgForm5.cells[0,i]<>'1' then begin
         if curimns<> sgForm5.cells[1,i] then begin
            if curimns<>'' then
              Lists.add('</Оборот>');
            curimns:= sgForm5.cells[1,i];
            ii:=ii+1;
            Lists.add('<Оборот ПN="'+inttostr(ii)+'" П000000000003="'+curimns+'">');
            curIdClient:='';
            iii:=0;
           end;
         iii:=iii+1;
         curIdClient:=sgForm5.cells[2,i];
         findSp:=1 ;
         if sgForm5.cells[5,i]<>'' then
         Lists.add('<СведПроизвИмпорт ПN="'+inttostr(iii)+'" П000000000004="'+ replaceStr5(sgForm5.cells[3,i])+'" П000000000005="'+sgForm5.cells[4,i]+
         '" П000000000006="'+sgForm5.cells[5,i]+'" '+
         ' П000000000007="'+sgForm5.cells[6,i]+'" '+
         ' П000000000008="'+sgForm5.cells[7,i]+'" '+
         ' П000000000009="'+sgForm5.cells[8,i]+'" '+
         ' П000000000010="'+sgForm5.cells[9,i]+'" '+
         ' П000000000011="'+floattoStr(formstart.StrToFloat( sgForm5.cells[7,i])+formstart.StrToFloat(sgForm5.cells[8,i])+formstart.StrToFloat(sgForm5.cells[9,i]))+'" '+
         ' П000000000012="'+sgForm5.cells[10,i]+'" '+
         ' П000000000013="'+sgForm5.cells[11,i]+'" '+
         ' П000000000014="'+sgForm5.cells[12,i]+'" '+
         ' П000000000015="'+floattostr(formstart.StrToFloat(sgForm5.cells[7,i])+formstart.StrToFloat(sgForm5.cells[8,i])+formstart.StrToFloat(sgForm5.cells[9,i])+formstart.StrToFloat(sgForm5.cells[10,i]+sgForm5.cells[11,i])+formstart.StrToFloat(sgForm5.cells[12,i]))+'" '+
         ' П000000000016="'+sgForm5.cells[13,i]+'" '+
         ' П000000000017="'+sgForm5.cells[14,i]+'" '+
         ' П000000000018="'+sgForm5.cells[15,i]+'" '+
         ' П000000000019="'+floattostr(formstart.StrToFloat(sgForm5.cells[13,i])+formstart.StrToFloat(sgForm5.cells[14,i])+formstart.StrToFloat(sgForm5.cells[15,i]))+'" '+
         ' П000000000020="'+sgForm5.cells[16,i]+'" '+  // >>> Списания
         ' П000000000021="'+sgForm5.cells[17,i]+'" '+
         ' П000000000022="'+sgForm5.cells[18,i]+'" '+
         ' П000000000023="'+floattostr(formstart.StrToFloat(sgForm5.cells[13,i])+formstart.StrToFloat(sgForm5.cells[14,i])+formstart.StrToFloat(sgForm5.cells[15,i])+formstart.StrToFloat(sgForm5.cells[16,i])+formstart.StrToFloat(sgForm5.cells[17,i])+formstart.StrToFloat(sgForm5.cells[18,i]))+'" '+
         ' П000000000024="'+sgForm5.cells[19,i]+'" '+
         ' П000000000025="0" '+
          // П000000000007="16.8" П000000000008="0" П000000000009="0" П000000000010="0" П000000000011="0" П000000000012="0" П000000000013="0" П000000000014="0" П000000000015="0" П000000000016="0" П000000000017="8.1" П000000000018="0" П000000000019="8.1" П000000000020="0" П000000000021="0" П000000000022="0" П000000000023="8.1" П000000000024="8.7" П000000000025="0" />
          '/>') else
          Lists.add('<СведПроизвИмпорт ПN="'+inttostr(iii)+'" П000000000004="'+ replaceStr5(sgForm5.cells[3,i])+'" П000000000005="'+sgForm5.cells[4,i]+
          '" '+
          ' П000000000007="'+sgForm5.cells[6,i]+'" '+
          ' П000000000008="'+sgForm5.cells[7,i]+'" '+
          ' П000000000009="'+sgForm5.cells[8,i]+'" '+
          ' П000000000010="'+sgForm5.cells[9,i]+'" '+
          ' П000000000011="'+floattoStr(formstart.StrToFloat( sgForm5.cells[7,i])+formstart.StrToFloat(sgForm5.cells[8,i])+formstart.StrToFloat(sgForm5.cells[9,i]))+'" '+
          ' П000000000012="'+sgForm5.cells[10,i]+'" '+
          ' П000000000013="'+sgForm5.cells[11,i]+'" '+
          ' П000000000014="'+sgForm5.cells[12,i]+'" '+
          ' П000000000015="'+floattostr(formstart.StrToFloat(sgForm5.cells[7,i])+formstart.StrToFloat(sgForm5.cells[8,i])+formstart.StrToFloat(sgForm5.cells[9,i])+formstart.StrToFloat(sgForm5.cells[10,i]+sgForm5.cells[11,i])+formstart.StrToFloat(sgForm5.cells[12,i]))+'" '+
          ' П000000000016="'+sgForm5.cells[13,i]+'" '+
          ' П000000000017="'+sgForm5.cells[14,i]+'" '+
          ' П000000000018="'+sgForm5.cells[15,i]+'" '+
          ' П000000000019="'+floattostr(formstart.StrToFloat(sgForm5.cells[13,i])+formstart.StrToFloat(sgForm5.cells[14,i])+formstart.StrToFloat(sgForm5.cells[15,i]))+'" '+
          ' П000000000020="'+sgForm5.cells[16,i]+'" '+
          ' П000000000021="'+sgForm5.cells[17,i]+'" '+
          ' П000000000022="'+sgForm5.cells[18,i]+'" '+
          ' П000000000023="'+floattostr(formstart.StrToFloat(sgForm5.cells[13,i])+formstart.StrToFloat(sgForm5.cells[14,i])+formstart.StrToFloat(sgForm5.cells[15,i])+formstart.StrToFloat(sgForm5.cells[16,i])+formstart.StrToFloat(sgForm5.cells[17,i])+formstart.StrToFloat(sgForm5.cells[18,i]))+'" '+
          ' П000000000024="'+sgForm5.cells[19,i]+'" '+
          ' П000000000025="0" '+
           // П000000000007="16.8" П000000000008="0" П000000000009="0" П000000000010="0" П000000000011="0" П000000000012="0" П000000000013="0" П000000000014="0" П000000000015="0" П000000000016="0" П000000000017="8.1" П000000000018="0" П000000000019="8.1" П000000000020="0" П000000000021="0" П000000000022="0" П000000000023="8.1" П000000000024="8.7" П000000000025="0" />
           '/>');

           findcl:=1;
           ind2:=1;
           curcl:='';
           flObor := true;
         end;
        end;
         if curimns<>'' then
            Lists.add('</Оборот>');
         // ==== КонецЦикла =====
         Lists.add('</ОбъемОборота>');
         Lists.add('</Документ>');
         Lists.add('</Файл>');
    if sdd1.Execute then begin
      lists.Text:=utf8toansi(lists.Text);
      lists.SaveToFile(utf8toAnsi(sdd1.FileName+'\D5_'+formstart.FirmINN+'_'+Format('%.2d',[pppm])+'2_'+FormatDateTime('DDMMYYYY',now())+'_'+formstart.NewGUID()+'.xml'));
      Showmessage('Сформирован!');
    end;


end;

procedure TFormExportForm5.bbOldForm5Click(Sender: TObject);
var
  str1:TStringList;
begin
  if opendialog1.Execute then begin
    str1:=tStringList.create();
    str1.LoadFromFile(opendialog1.FileName);
    str1.Text:=ansitoutf8(str1.text);
    str1.Delete(0);
    LoadOldForm5(str1.text);
    str1.free();
  end;
end;

procedure TFormExportForm5.PageControl2Change(Sender: TObject);
begin

end;

procedure TFormExportForm5.sgClientsDblClick(Sender: TObject);
begin
    if sgClients.Row>0 then begin
      formEditProducer.flClientRegId:=sgClients.Rows[sgClients.Row].Strings[1];

      formEditProducer.ShowOnTop;
    end;
end;

procedure TFormExportForm5.sgClientsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin
    if  ((Sender as TStringGrid).Name = 'sgClients') AND (sgClients.Cells[0,aRow] = '*') then begin

    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=clred;
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[1];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);


    end;


end;

procedure TFormExportForm5.sgForm5DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin
    if  ((Sender as TStringGrid).Name = 'sgForm5') AND (sgForm5.Cells[0,aRow] = '*') then begin

    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=clred;
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[1];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);


    end;

end;

procedure TFormExportForm5.sgSales6DblClick(Sender: TObject);
begin
    if sgSales6.Row>0 then begin
      formEditProducer.flClientRegId:=sgSales6.Rows[sgSales6.Row].Strings[6];
      formEditProducer.showModal;
    end;
end;

end.

