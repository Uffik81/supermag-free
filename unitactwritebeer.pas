unit unitActWriteBeer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Grids, StdCtrls, Buttons;

type

  { TFormActWriteBeer }

  TFormActWriteBeer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1ChangeBounds(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
    CurData:TDateTime;
    NumDoc:string;
    DateDoc:string;
    listAlcCode:TStringList;
    Currentrow:integer;
    procedure SaveToDB;

    procedure GetActToEgais;
    function GetRestAlcCode(aAlcCode:string):string;
    procedure SelectofSprProduct(_Index:integer);
    procedure SelectOfRestShop(_Index:integer);
  end;

var
  FormActWriteBeer: TFormActWriteBeer;

implementation
uses lazutf8, unitstart, unitspproduct,mysql50,lconvencoding,typinfo,LCLIntf, LCLProc,unitdevices,unitshoprest;
{$R *.lfm}

{ TFormActWriteBeer }

procedure TFormActWriteBeer.FormShow(Sender: TObject);
var
  query:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  i:integer;
begin
  staticText3.Caption:='Остатки на складе за :'+FormStart.GetConstant('finupdaterestshop');;
  Stringgrid1.RowCount:=1;
  Stringgrid1.Clear;
  numdoc:=formStart.prefixClient+'-'+GetShiftCash();
  datedoc:=FormatDateTime('YYYY-MM-DD',CurData);
  query:='SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";';
  xrecbuf:=formstart.DB_query(Query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
   begin
     showmessage('Уже списание проводилось!!!');
     close;
   end;

    query:='SELECT `name`,`plu`,`eanbc`,'+
    '(SELECT `egaisname` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `name`,'+
    '(SELECT `alcVolume` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `alcvolume`,'+
    '(SELECT `productVCode` FROM `spproduct` WHERE `alccode`=`doccash`.`alccode` ) AS `productVCode`,'+
    'SUM(`quantity`) AS `summ`,'+
    '`price`,'+
    '(SELECT `extcode` FROM `sprgoods` WHERE `sprgoods`.`plu`=`doccash`.`plu` AND `alcgoods`="+" LIMIT 1) AS `alccode1`'+
    ',`urlegais`,`datedoc`,`alccode`,'+
    '(SELECT `Quantity` FROM `regrestsshop` WHERE `alccode`=`doccash`.`alccode` ) AS `quantity`'+
    ' FROM `doccash` WHERE `datedoc`="'
    +FormatDateTime('YYYY-MM-DD',CurData)+'" AND (`typetrans`="11" OR `typetrans`="13") GROUP BY `plu`, `alccode`;' ;
    xrecbuf:=formstart.DB_query(Query);
    xrowbuf:=formstart.DB_Next(xrecbuf);
    while xrowbuf<>nil do begin
      if   thisBeer(xrowbuf[5]) then
        begin
          i:= Stringgrid1.RowCount;
          Stringgrid1.RowCount:=i+1;
          StringGrid1.Cells[0,i]:=inttostr(i);
          StringGrid1.Cells[1,i]:=xrowbuf[1];
          StringGrid1.Cells[2,i]:=xrowbuf[0];
          StringGrid1.Cells[3,i]:=xrowbuf[2];
          StringGrid1.Cells[4,i]:=xrowbuf[7];
          StringGrid1.Cells[5,i]:=xrowbuf[6];
          if xrowbuf[11] <> '' then begin
                StringGrid1.Cells[8,i]:=xrowbuf[12] ;
                StringGrid1.Cells[6,i]:=xrowbuf[11];
              end
            else begin
                StringGrid1.Cells[8,i]:='0' ;
                StringGrid1.Cells[6,i]:=xrowbuf[8]; {При условии что в справочнике еще остался товар}
             end;
          StringGrid1.Cells[7,i]:=xrowbuf[3];
        end else
         begin
           if (xrowbuf[5]='')or(xrowbuf[5]=nil) then
            begin
              i:= Stringgrid1.RowCount;
              Stringgrid1.RowCount:=i+1;
              StringGrid1.Cells[1,i]:=xrowbuf[1];
              StringGrid1.Cells[2,i]:=xrowbuf[0];
              StringGrid1.Cells[3,i]:=xrowbuf[2];
              StringGrid1.Cells[4,i]:=xrowbuf[7];
              StringGrid1.Cells[5,i]:=xrowbuf[6];
              StringGrid1.Cells[6,i]:=xrowbuf[11];
              StringGrid1.Cells[7,i]:=xrowbuf[3];
              StringGrid1.Cells[8,i]:=xrowbuf[12] ;
            end;
         end;
      xrowbuf:=formstart.DB_Next(xrecbuf);
    end;


end;

procedure TFormActWriteBeer.ListBox1ChangeBounds(Sender: TObject);
var
  i:integer;
begin
  exit;
  for i:=0 to listbox1.Items.Count-1 do
    if ListBox1.Selected[i] then begin
      if listAlcCode.strings[i] = '-1' then // Выбрать из справочника
        SelectofSprProduct(CurrentRow)
        else begin
          if listAlcCode.strings[i] = '-2' then // выбрать из остатков
            SelectOfRestShop(CurrentRow)
           else begin
            StringGrid1.Cells[6,i]:= listAlcCode.strings[i];
            StringGrid1.Cells[7,i]:= ListBox1.items.Strings[i];
           end;

        end;

  end;
end;

procedure TFormActWriteBeer.ListBox1Click(Sender: TObject);
var
  i:integer;
begin
  exit;
  for i:=0 to listbox1.Items.Count-1 do
    if ListBox1.Selected[i] then begin
      if listAlcCode.strings[i] = '-1' then // Выбрать из справочника
       begin
        listbox1.Hide;
        SelectofSprProduct(CurrentRow)
        end else begin
          if listAlcCode.strings[i] = '-2' then // выбрать из остатков
           begin
            listbox1.Hide;
            SelectOfRestShop(CurrentRow)
           end else begin
            StringGrid1.Cells[6,i]:= listAlcCode.strings[i];
            StringGrid1.Cells[7,i]:= ListBox1.items.Strings[i];
           end;

        end;

  end;

end;

procedure TFormActWriteBeer.ListBox1DblClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to listbox1.Items.Count-1 do
    if ListBox1.Selected[i] then begin
      if listAlcCode.strings[i] = '-1' then // Выбрать из справочника
        SelectofSprProduct(CurrentRow)
        else begin
          if listAlcCode.strings[i] = '-2' then // выбрать из остатков
            SelectOfRestShop(CurrentRow)
           else begin
            StringGrid1.Cells[6,i]:= listAlcCode.strings[i];
            StringGrid1.Cells[7,i]:= ListBox1.items.Strings[i];
           end;

        end;

  end;

end;

procedure TFormActWriteBeer.ListBox1SelectionChange(Sender: TObject;
  User: boolean);
begin

end;

procedure TFormActWriteBeer.StringGrid1Click(Sender: TObject);
begin
  ListBox1.Visible:=false;
end;

procedure TFormActWriteBeer.BitBtn1Click(Sender: TObject);
begin
  SaveToDB;
  GetActToEgais;
end;

procedure TFormActWriteBeer.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFormActWriteBeer.FormCreate(Sender: TObject);
begin
  CurData:=now();
  listAlcCode:=TStringList.Create;
end;
{ -----------------------------------------------------------
  2019.02.01 Уфандеев Е.В.
Изменен механизм выбора товара из справочника
Показываем выподающий список, где показываем список товара,
  или предлагаем выбрать из справочников
}
procedure TFormActWriteBeer.StringGrid1DblClick(Sender: TObject);
var
  i:integer;
  fnoupd:boolean;
  query:string;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;
  SpProduct:TFormSpProduct;
  lstAlcCode:TStringList;
begin
    Currentrow:=StringGrid1.Row;
    if (Currentrow>0) and (stringgrid1.Col=7) then begin
     //showmessage(inttostr(StringGrid1.Selection.Left));
    listAlcCode.Clear;
    ListBox1.hide;
    // ### Заполняем список известных товаров
    lstAlcCode:=TStringList.Create;
    ListBox1.Items.Clear;
    lstAlcCode.Text:=formstart.GetAlcCodeOfBarCode(StringGrid1.Cells[3,Currentrow]);

    for i:=0 to  lstAlcCode.Count-1 do
     if lstAlcCode.Strings[i]<>'' then begin
       ListBox1.Items.Add(formstart.GetAlcNameOfCode(lstAlcCode.Strings[i]));
       listAlcCode.add(lstAlcCode.Strings[i]);
     end;
    listAlcCode.add('-1');
    listAlcCode.add('-2');

    ListBox1.Items.Add('Из справочника....');
    ListBox1.Items.Add('Из остатков торгового зала....');
    //listbox1.SetBounds( StringGrid1.Selection.Left,StringGrid1.Selection.Bottom,StringGrid1.Selection.Width,100);
    ListBox1.Show;
    listbox1.Visible:=true;
    end;
  {  if i>0 then begin
      Spproduct:=TFormSpProduct.Create(self);
      Spproduct.flSelected:=true;
      spproduct.Height:=400;
      spproduct.Width:=700;
      spproduct.Position:=poDesktopCenter;
      //FormShopRest.flSelectMode:=true;
      if Spproduct.ShowModal =1377 then begin
          StringGrid1.Cells[6,i]:=Spproduct.sAlcCode;
          StringGrid1.Cells[7,i]:=Spproduct.sAlcName;
          // ==== Указать количество из остатков ====
          StringGrid1.Cells[8,i]:=GetRestAlcCode(StringGrid1.Cells[6,i]) ;

          // ========================================
          //StringGrid1.Cells[4,i]:=FormShopRest.StringGrid1.Cells[3,FormShopRest.StringGrid1.row];
          formstart.DB_query('UPDATE `doccash` SET `alccode`="'+StringGrid1.Cells[6,i]+'" WHERE `alccode`=`plu` AND `eanbc`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";');

          query:='SELECT `plu` FROM `sprgoods` WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" ;';
          yrecbuf:= formStart.DB_query( Query);
          yrowbuf:=formstart.DB_next(yrecbuf);
          if yrowbuf<>nil then
            formstart.DB_query('UPDATE `sprgoods` SET `extcode`="'+StringGrid1.Cells[6,i]+'", `alcgoods`="+",`updating`="+" WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";')

          else begin
            yrecbuf:= formStart.DB_query( 'SELECT `plu`,`alcgoods`,`name`,`fullname`,`currentprice`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+StringGrid1.Cells[3,i]+'" ;');
            yrowbuf:=formstart.DB_next(yrecbuf);
            fnoupd:=true;
            query:='';
            while yrowbuf<>nil do begin

               Query:='INSERT INTO `sprgoods` (`plu`, `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`) '+
               'VALUES ('''+yrowbuf[0]+''','''+trim(StringGrid1.Cells[3,i])+''','''+StringGrid1.Cells[6,i]+''',''+'',''+'','''+trim(yrowbuf[2])+''','''+trim(yrowbuf[3])+''','''+trim(yrowbuf[4])+''');';
               if trim(yrowbuf[5]) = trim(StringGrid1.Cells[6,i]) then
                  fnoupd:=false;
               yrowbuf := formstart.DB_Next(yrecbuf);
              end;
            if (fnoupd)and(query<>'') then
             formStart.DB_query(Query);
          end;

      end;
      Spproduct.destroy;
    end;     }
end;
{ ---------------------------------------------
  2019.02.01 Уфандеев Е.В.
  Определяем координаты выбранной ячейки
}
procedure TFormActWriteBeer.StringGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
var
  r2,r:tRect;
begin
    if  ((Sender as TStringGrid).Name = 'StringGrid1') AND ((StringGrid1.Cells[8,aRow] = '')or(StringGrid1.Cells[8,aRow] = '0')) then begin

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
  if (Stringgrid1.row = aRow)and(aCol=7) then
    listbox1.SetBounds( arect.Left,arect.Bottom,arect.Width,100);
end;

procedure TFormActWriteBeer.SaveToDB;
var
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  i:integer;
  flEditing:boolean;
begin

  flEditing:=false;
  // ==== сохранить в БД документ ====
  for i:=1 to Stringgrid1.RowCount-1 do begin
     if StringGrid1.Cells[1,i] <> StringGrid1.Cells[6,i] then begin
    xrecbuf:=formstart.DB_query('SELECT `count` FROM `doc28` WHERE `alccode`="'+StringGrid1.Cells[6,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      flEditing:=true;
      formstart.DB_query('UPDATE `doc28` SET `count`="'+StringGrid1.Cells[5,i]+'",`price`="'+StringGrid1.Cells[4,i]+'" WHERE `alccode`="'+StringGrid1.Cells[6,i]+'" AND `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
    end else begin
      formstart.DB_query('INSERT INTO `doc28` (`numdoc`,`datedoc`,`alccode`,`count`,`price`) VALUES ("'+NumDoc+'","'+DateDoc+'","'+StringGrid1.Cells[6,i]+'","'+StringGrid1.Cells[5,i]+'","'+StringGrid1.Cells[4,i]+'");');
    end;
    end;
  end;
  if flEditing then begin
    xrecbuf:=formstart.DB_query('SELECT `status` FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";');
    xrowbuf:=formStart.DB_Next(xrecbuf);

    if xrowbuf<>nil then
             formstart.DB_query('UPDATE SET `status`="---" FROM `docjurnale` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'" AND `type`="ActWriteOffShop";')
        else
     formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActWriteOffShop","---");');
  end else
  begin
    formstart.DB_query('INSERT INTO `docjurnale` (`numdoc`,`datedoc`,`type`,`status`) VALUES ("'+NumDoc+'","'+DateDoc+'","ActWriteOffShop","---");');

  end;
  xrecbuf:=formstart.DB_query('SELECT `typedoc` FROM `docx28` WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
  xrowbuf:=formStart.DB_Next(xrecbuf);
  if xrowbuf<>nil then begin
     flEditing:=true;
     formstart.DB_query('UPDATE `docx28` SET `notedoc`="Розничная реализация продукции, не подлежащая фиксации в ЕГАИС", `typedoc`="Реализация" WHERE  `numdoc`="'+NumDoc+'" AND `datedoc`="'+DateDoc+'";');
   end else begin
     formstart.DB_query('INSERT INTO `docx28` (`numdoc`,`datedoc`,`notedoc`, `typedoc`) VALUES ("'+NumDoc+'","'+DateDoc+'","Розничная реализация продукции, не подлежащая фиксации в ЕГАИС","Реализация");');
   end;


end;

procedure TFormActWriteBeer.GetActToEgais;
var
  SLine:TStringList;
  aClientRegId:string;
  query:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
  i:integer;
  strGUID:string;
  str,url:string;
  idProductVCode,
  idAlcCode:String;
  ind:integer;
  flrussia:boolean;
begin
  strGUID:=formstart.NewGUID();
  sLine:= TStringList.Create;
  SLine.add('<?xml version="1.0" encoding="UTF-8"?>');
  SLine.add('<ns:Documents Version="2.0"');
  SLine.add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  SLine.add('xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"');
  SLine.add('xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef_v2"');
  SLine.add('xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef_v2"');
  SLine.add('xmlns:awr="http://fsrar.ru/WEGAIS/ActWriteOffShop_v2"');
  SLine.add('xmlns:ce="http://fsrar.ru/WEGAIS/CommonEnum"');
  SLine.add('>');
  SLine.add('<ns:Owner>');
  SLine.add('<ns:FSRAR_ID>'+formstart.EgaisKod+'</ns:FSRAR_ID>');
  SLine.add('</ns:Owner>');
  SLine.add('<ns:Document>');
  SLine.add('<ns:ActWriteOffShop_v2>');
  SLine.add('<awr:Identity>'+strGUID+'</awr:Identity>');
  SLine.add('<awr:Header>');
  SLine.add('<awr:ActDate>'+datedoc+'</awr:ActDate>');
  SLine.add('<awr:ActNumber>'+numdoc+'</awr:ActNumber>');
  SLine.add('<awr:TypeWriteOff>Реализация</awr:TypeWriteOff>');
  SLine.add('<awr:Note>Розничная реализация продукции, не подлежащая фиксации в ЕГАИС</awr:Note>');
  SLine.add('</awr:Header>');
  SLine.add('<awr:Content>');
  // ==== Описание позиции =====
  idAlcCode:='';
  ind:=1;
  query:='SELECT `alccode`,`count` FROM `doc28` WHERE `numdoc`="'+numdoc+'" AND `datedoc`="'+datedoc+'";';
  recbuf:=formstart.DB_Query(Query);
  rowBuf:=formstart.DB_Next(recbuf);
  while rowbuf<>nil do begin
      idAlcCode:=rowbuf[0];
      SLine.add('<awr:Position>');
      SLine.add('<awr:Identity>'+inttostr(ind)+'</awr:Identity>');
      Query:= 'SELECT `name`,`capacity`,`clientregid`,`productvcode`,`unpacked`  FROM `spproduct` WHERE `alccode`="'+idAlcCode+'" LIMIT 1;';
      xrecbuf:=formstart.DB_Query(query);
      xrowbuf:=formstart.DB_Next(xrecbuf);
      if xrowbuf<> nil then begin
        aClientRegId:= xrowbuf[2];
        idProductVCode:=xrowbuf[3];
        SLine.add('<awr:Product>');
        SLine.add('<pref:UnitType>Packed</pref:UnitType>');
        SLine.add('<pref:Type>АП</pref:Type>');
        SLine.add('<pref:FullName>'+ReplaceStr(xrowbuf[0])+'</pref:FullName>');
        SLine.add('<pref:ShortName>'+utf8copy(ReplaceStr(xrowbuf[0]),1,64)+'</pref:ShortName>');
        SLine.add('<pref:AlcCode>'+idAlcCode+'</pref:AlcCode>');
        if  xrowBuf[4] <>'+' then
         SLine.add('<pref:Capacity>'+xrowBuf[1]+'</pref:Capacity>');
         // === получим данные о производителе ===
          SLine.add('<pref:Producer>');
        Query:= 'SELECT `inn`,`kpp`,`FullName`,`description`,`Country`,`region`  FROM `spproducer` WHERE `ClientRegId`="'+aClientRegId+'" LIMIT 1;';
        xrecbuf:=formstart.DB_Query(query);
        xrowbuf:=formstart.DB_Next(xrecbuf);
        if xrowbuf<> nil then begin
          if (xrowbuf[4]='') or (xrowbuf[4]='643') then flrussia:=true else flrussia:=false;


          if flrussia then SLine.add('<oref:UL>') else SLine.add('<oref:FO>');
          SLine.add('<oref:ClientRegId>'+aClientRegId+'</oref:ClientRegId>');
          SLine.add('<oref:FullName>'+replacestr(xrowbuf[2])+'</oref:FullName>');
          SLine.add('<oref:ShortName>'+UTF8Copy(replacestr(xrowbuf[2]),1,64)+'</oref:ShortName>');
          if xrowbuf[0]<>'' then begin
            SLine.add('<oref:INN>'+xrowbuf[0]+'</oref:INN>');
            if xrowbuf[1]<>'' then
              SLine.add('<oref:KPP>'+xrowbuf[1]+'</oref:KPP>');
          end;
          SLine.add('<oref:address>');
          if (xrowbuf[4]='')or(xrowbuf[4]='643') then begin
              SLine.add('<oref:Country>643</oref:Country>') ;
              if  xrowbuf[5]<>'' then
               SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>')
               else
                SLine.add('<oref:RegionCode>'+copy(xrowbuf[0],1,2)+'</oref:RegionCode>')
              end
            else begin
              SLine.add('<oref:Country>'+xrowbuf[4]+'</oref:Country>');
              if xrowbuf[5]<>'' then SLine.add('<oref:RegionCode>'+xrowbuf[5]+'</oref:RegionCode>') ;
            end;

          SLine.add('<oref:description>'+replaceStr(xrowbuf[3])+'</oref:description>');
          SLine.add('</oref:address>');
          if flrussia then SLine.add('</oref:UL>') else SLine.add('</oref:FO>');

        end;
      SLine.add('</pref:Producer>');
      SLine.add('<pref:ProductVCode>'+idProductVCode+'</pref:ProductVCode>');
      SLine.add('</awr:Product>');
    end;
      SLine.add('<awr:Quantity>'+rowbuf[1]+'</awr:Quantity>');
      SLine.add('</awr:Position>');
      rowbuf:=formstart.DB_Next(recbuf);
      ind:=ind+1;
end;
// ==== Описание позиции ===========
SLine.add('</awr:Content>');
SLine.add('</ns:ActWriteOffShop_v2>');
SLine.add('</ns:Document>');
SLine.add('</ns:Documents>');

  str:=formStart.savetoserverpost('opt/in/ActWriteOffShop_v2',Sline.text) ;
  url:=formStart.getXMLtoURL(str);
  showmessage(str);
  SLine.text:=str;
  if SLine.Count < 1 then begin
    SLine.SaveToFile(formStart.pathfile()+'\ActWriteOffShopv2.txt');
     exit;
  end;
  if url='' then begin
  Query:='UPDATE `docjurnale`   SET uid="'+strGUID+'", status="0--", docid="'+strGUID+'", ClientAccept="" '+
               'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND `type`="ActWriteOffShop";';
               // добавлен сброс подтверждения клиента для ОПТА
     formStart.DB_query(Query);
     Query:='INSERT INTO `ticket` (`uid`,`DocID`,`RegID`,`transportID`,`Accept`,`Comment`,`type`,`OperationResult`,`OperationName`,`datedoc`,`numdoc`) VALUES'
                 +' ('''','''','''','''',''Rejected'','''+''',''ActWriteOffShop'',''ActWriteOffShop'',''ActWriteOffShop'','''+numdoc+''','''+datedoc+''');';
     formStart.DB_query(Query);


   end else begin
     Query:='UPDATE `docjurnale`   SET uid="'+url+'", docid="'+strGUID+'", ClientAccept="", status="+--" '+
           'WHERE (`numdoc`="'+NumDoc+'")AND(`datedoc`="'+datedoc+'")AND `type`="ActWriteOffShop";';
     formStart.DB_query(Query);
     Query:='INSERT `replyid` (`egaisid`,`numdoc`,`datedoc`) VALUE ("'+url+'","'+NumDoc+'","'+datedoc+'");';
     formStart.DB_query(Query);
   end;

  SLine.Free





end;

function TFormActWriteBeer.GetRestAlcCode(aAlcCode: string): string;
var
  query:string;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;
begin
  result:='0';
  query:='SELECT `Quantity` FROM `regrestsshop` WHERE `alccode`="'+aAlcCode+'" ;';
  yrecbuf:= formStart.DB_query( Query);
  yrowbuf:=formstart.DB_next(yrecbuf);
  if yrowbuf<>nil then
    result:=yrowbuf[0];

end;

procedure TFormActWriteBeer.SelectofSprProduct(_Index: integer);
var
  i:integer;
  fnoupd:boolean;
  query:string;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;
  SpProduct:TFormSpProduct;
begin
    i:=_Index;

    if i>0 then begin
      Spproduct:=TFormSpProduct.Create(self);
      Spproduct.flSelected:=true;
      spproduct.Height:=400;
      spproduct.Width:=700;
      spproduct.Position:=poDesktopCenter;
      //FormShopRest.flSelectMode:=true;
      if Spproduct.ShowModal =1377 then begin
          StringGrid1.Cells[6,i]:=Spproduct.sAlcCode;
          StringGrid1.Cells[7,i]:=Spproduct.sAlcName;
          // ==== Указать количество из остатков ====
          StringGrid1.Cells[8,i]:=GetRestAlcCode(StringGrid1.Cells[6,i]) ;
          formstart.SetAlcToBarCode(StringGrid1.Cells[6,i],StringGrid1.Cells[3,i]);
          // ========================================
          //StringGrid1.Cells[4,i]:=FormShopRest.StringGrid1.Cells[3,FormShopRest.StringGrid1.row];
          formstart.DB_query('UPDATE `doccash` SET `alccode`="'+StringGrid1.Cells[6,i]+'" WHERE `alccode`=`plu` AND `eanbc`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";');

          query:='SELECT `plu` FROM `sprgoods` WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" ;';
          yrecbuf:= formStart.DB_query( Query);
          yrowbuf:=formstart.DB_next(yrecbuf);
          if yrowbuf<>nil then
            formstart.DB_query('UPDATE `sprgoods` SET `extcode`="'+StringGrid1.Cells[6,i]+'", `alcgoods`="+",`updating`="+" WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";')

          else begin
            yrecbuf:= formStart.DB_query( 'SELECT `plu`,`alcgoods`,`name`,`fullname`,`currentprice`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+StringGrid1.Cells[3,i]+'" ;');
            yrowbuf:=formstart.DB_next(yrecbuf);
            fnoupd:=true;
            query:='';
            while yrowbuf<>nil do begin

               Query:='INSERT INTO `sprgoods` (`plu`, `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`) '+
               'VALUES ('''+yrowbuf[0]+''','''+trim(StringGrid1.Cells[3,i])+''','''+StringGrid1.Cells[6,i]+''',''+'',''+'','''+trim(yrowbuf[2])+''','''+trim(yrowbuf[3])+''','''+trim(yrowbuf[4])+''');';
               if trim(yrowbuf[5]) = trim(StringGrid1.Cells[6,i]) then
                  fnoupd:=false;
               yrowbuf := formstart.DB_Next(yrecbuf);
              end;
            if (fnoupd)and(query<>'') then
             formStart.DB_query(Query);
          end;

      end;
      Spproduct.destroy;
    end;

end;

procedure TFormActWriteBeer.SelectOfRestShop(_Index: integer);
var
  i:integer;
  fnoupd:boolean;
  query:string;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;

begin
    i:=_Index;

    if i>0 then begin
      //FormShopRest.flSelectMode:=true;
      FormShopRest.flSelectMode:=true;
      if FormShopRest.ShowModal =1377 then begin
          StringGrid1.Cells[6,i]:=FormShopRest.flAlcCode;
          StringGrid1.Cells[7,i]:=formstart.GetAlcNameOfCode(FormShopRest.flAlcCode);
          // ==== Указать количество из остатков ====
          StringGrid1.Cells[8,i]:=GetRestAlcCode(StringGrid1.Cells[6,i]) ;
          formstart.SetAlcToBarCode(StringGrid1.Cells[6,i],StringGrid1.Cells[3,i]);
          // ========================================
          //StringGrid1.Cells[4,i]:=FormShopRest.StringGrid1.Cells[3,FormShopRest.StringGrid1.row];
          formstart.DB_query('UPDATE `doccash` SET `alccode`="'+StringGrid1.Cells[6,i]+'" WHERE `alccode`=`plu` AND `eanbc`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";');

          query:='SELECT `plu` FROM `sprgoods` WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" ;';
          yrecbuf:= formStart.DB_query( Query);
          yrowbuf:=formstart.DB_next(yrecbuf);
          if yrowbuf<>nil then
            formstart.DB_query('UPDATE `sprgoods` SET `extcode`="'+StringGrid1.Cells[6,i]+'", `alcgoods`="+",`updating`="+" WHERE `extcode`=`plu` AND `barcodes`="'+StringGrid1.Cells[3,i]+'" AND `plu`="'+StringGrid1.Cells[1,i]+'";')

          else begin
            yrecbuf:= formStart.DB_query( 'SELECT `plu`,`alcgoods`,`name`,`fullname`,`currentprice`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+StringGrid1.Cells[3,i]+'" ;');
            yrowbuf:=formstart.DB_next(yrecbuf);
            fnoupd:=true;
            query:='';
            while yrowbuf<>nil do begin

               Query:='INSERT INTO `sprgoods` (`plu`, `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`) '+
               'VALUES ('''+yrowbuf[0]+''','''+trim(StringGrid1.Cells[3,i])+''','''+StringGrid1.Cells[6,i]+''',''+'',''+'','''+trim(yrowbuf[2])+''','''+trim(yrowbuf[3])+''','''+trim(yrowbuf[4])+''');';
               if trim(yrowbuf[5]) = trim(StringGrid1.Cells[6,i]) then
                  fnoupd:=false;
               yrowbuf := formstart.DB_Next(yrecbuf);
              end;
            if (fnoupd)and(query<>'') then
             formStart.DB_query(Query);
          end;

      end;

    end;


end;



end.

