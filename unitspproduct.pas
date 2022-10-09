unit unitspProduct;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Grids, Menus, Buttons, StdCtrls, mysql50;

type

  { TFormSpProduct }

  TFormSpProduct = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    bbRefreshBC: TBitBtn;
    Edit1: TEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    StringGrid1: TStringGrid;
    ToggleBox1: TToggleBox;
    tbQuantity: TToggleBox;
    TreeView1: TTreeView;
    procedure bbRefreshBCClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
      var Accept: Boolean);
    procedure StringGrid1EditingDone(Sender: TObject);
    procedure StringGrid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure tbClearingChange(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
  public
    { public declarations }
    flReadOnly:boolean;
    flSelected:Boolean;
    sAlcCode:String;
    sAlcName:String;
    sRow:integer;
    sCol:integer;
    sValue:String;
    sClientRegId:String;
    listClientIDI:TStringList;
    listClientIDR:TStringList;
    procedure refreshprodlist();
  end;

var
  FormSpProduct: TFormSpProduct;

implementation

{$R *.lfm}
uses unitstart, unitlogging, unitpdf417, unitedititem, unitalcitem,unitspgoods;
{ TFormSpProduct }

procedure TFormSpProduct.Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
  var Accept: Boolean);
begin

end;

procedure TFormSpProduct.StringGrid1EditingDone(Sender: TObject);
var
  str1:string;
  tmpPLU:string;
  intPLU:integer;
begin
  if (sCol = 6)or(sCol = 7) then begin
     // ====== исправляем справочники товара по изменеию данных
     if sCol=6 then begin // === обновляем ШК он должен равняться 8 или 13 символам
        if length(sValue) =13 then
           begin
              formStart.recbuf := formStart.DB_query('SELECT `extcode` FROM `sprgoods` WHERE `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'";');
              if  formStart.DB_Next(formStart.recbuf)<> nil then
                 formStart.DB_query('UPDATE FROM `sprgoods` SET `barcodes`="'+trim(sValue)+'",`updating`="+",`alcgoods`="+" WHERE `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'";')
                 else begin
                    // === нет такого товара но надо проверить есть такой в справочнике по ШК
                   formStart.recbuf := formStart.DB_query('SELECT `extcode` FROM `sprgoods` WHERE `barcodes`="'+trim(svalue)+'";');
                   if  formStart.DB_Next(formStart.recbuf)<> nil then
                    formStart.DB_query('UPDATE FROM `sprgoods` SET `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'",`updating`="+",`alcgoods`="+" WHERE  `barcodes`="'+trim(sValue)+'";')
                   else begin
                       tmpPLU:=formStart.GetConstant('NumberSKU');
                       if (tmpPLU = '' )or (tmpPLU='0') then
                           intPLU:=1
                         else
                           intPLU:=strtoint(tmpPLU)+1;
                       tmpPLU:=inttostr( intPLU);
                    str1:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`plu`)VALUE ('''+trim(sValue)+''','''+trim(StringGrid1.Cells[1,sRow])+''',''+'',''+'','''+trim(StringGrid1.Cells[2,sRow])+''','''+trim(StringGrid1.Cells[2,sRow])+''','''+tmpPLU+''');';
                    formStart.DB_query(str1);
                   end;
                 end;
            end;
        end;
    if sCol=7 then begin // === обновляем цену
       if (pos(',',sValue)=0)and(length(sValue)<>0) then
          begin
             formStart.recbuf := formStart.DB_query('SELECT `extcode` FROM `sprgoods` WHERE `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'";');
             if  formStart.DB_Next(formStart.recbuf)<> nil then
                formStart.DB_query('UPDATE  `sprgoods` SET `currentprice`="'+trim(sValue)+'",`updating`="+",`alcgoods`="+" WHERE `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'";')
                else begin
                   // === нет такого товара но надо проверить есть такой в справочнике по ШК
                  formStart.recbuf := formStart.DB_query('SELECT `extcode` FROM `sprgoods` WHERE `barcodes`="'+trim(StringGrid1.Cells[6,sRow])+'";');
                  if  formStart.DB_Next(formStart.recbuf)<> nil then
                   formStart.DB_query('UPDATE  `sprgoods` SET `extcode`="'+trim(StringGrid1.Cells[1,sRow])+'",`updating`="+",`alcgoods`="+",`currentprice`="'+trim(sValue)+'" WHERE  `barcodes`="'+trim(StringGrid1.Cells[6,sRow])+'";')
                  else begin
                    tmpPLU:=formStart.GetConstant('NumberSKU');
                    if (tmpPLU = '' )or (tmpPLU='0') then
                        intPLU:=1
                      else
                        intPLU:=strtoint(tmpPLU)+1;
                    tmpPLU:=inttostr( intPLU);
                   str1:='INSERT INTO `sprgoods` ( `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`plu`)VALUE ('''+trim(StringGrid1.Cells[6,sRow])+''','''+trim(StringGrid1.Cells[1,sRow])+''',''+'',''+'','''+trim(StringGrid1.Cells[2,sRow])+''','''+trim(StringGrid1.Cells[2,sRow])+''','''+trim(sValue)+''','''+tmpPLU+''');';
                   formStart.DB_query(str1);
                  end;
                end;
           end;
       end;
     //text:='';

  end else
//  formlogging.AddMessage('Исправили на  = '+inttostr(sCol),'>');
  sValue:='';
end;

procedure TFormSpProduct.StringGrid1SelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin
  sCol:=0;
  sRow:=aRow;
  if (aCol = 6)or(aCol = 7) then begin
   if editor is TCustomEdit then
   with Editor as TCustomEdit  do begin
     text:=StringGrid1.Cells[aCol,aRow];
     sCol:=aCol;
   end;
  end else
//  formlogging.AddMessage('Исправили на  = '+inttostr(aCol),'>');
end;

procedure TFormSpProduct.StringGrid1Selection(Sender: TObject; aCol,
  aRow: Integer);
begin
  if aRow>=0 then begin
    sRow:=aRow;
    sAlcCode:=StringGrid1.Rows[aRow].Strings[1];
    sAlcName:=StringGrid1.Rows[aRow].Strings[2];
  end;
end;

procedure TFormSpProduct.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  str1:string;
begin
  if (aCol = 6)or(aCol = 7) then begin
     // ====== исправляем справочники товара по изменеию данных
     sValue:=Value;
     //text:='';

  end else begin
    sValue:='';
  end;


end;

procedure TFormSpProduct.tbClearingChange(Sender: TObject);
var
  str1:string;
  str2:string;
  query:string;
  i:integer;
  twRoot:TTreeNode;
  twRootR:TTreeNode;
  twRootI:TTreeNode;
begin
 // ActiveControl
  StringGrid1.SetFocus;
  str2:=Formgetpdf417.getAlcCode();
  if length(str2)>13 then
   formStart.recbuf:= formStart.DB_query('SELECT `ClientRegId`,`IClientRegId`,`Import`,`alccode` FROM `spproduct` WHERE `alccode`="'+str2+'";')
  else begin
 //  if formstart.controlena13(str2) then
 //   showmessage('Неверный Штрихкода товара:'+str2);
   formStart.recbuf:= formStart.DB_query('SELECT `spproduct`.`ClientRegId`,`spproduct`.`IClientRegId`,`spproduct`.`Import`,`spproduct`.`alccode`,`sprgoods`.`barcodes`,`sprgoods`.`extcode` FROM `spproduct`,`sprgoods` WHERE `spproduct`.`alccode`=`sprgoods`.`extcode` AND `sprgoods`.`barcodes`="'+str2+'";');
  end;

  formstart.rowbuf:=formstart.DB_Next(formStart.recbuf);
  if formstart.rowbuf<>nil then
    begin
     str2:= formstart.rowbuf[3];
      if formstart.rowbuf[2]='1' then
        str1:= formstart.rowbuf[0]
        else  str1:= formstart.rowbuf[0] ;

      sClientRegId:=str1;
      refreshprodlist();

      for i:=1 to StringGrid1.RowCount-1 do
       if StringGrid1.cells[1,i] = str2 then begin
          StringGrid1.Row:=i;
          StringGrid1.Col:=1;
       end;
    end else begin
        showmessage('Товар с кодом:'+str2+' не найден производитель/импортер!');
    end;
end;

procedure TFormSpProduct.ToggleBox1Change(Sender: TObject);
var
      query:string;
      i:integer;
      twRoot:TTreeNode;
      twRootR:TTreeNode;
      twRootI:TTreeNode;
begin
      twRoot:=nil;
      listClientIDR.Clear;
      listClientIDI.Clear;
      treeView1.items.Clear;
      twRootR:=treeView1.items.Add(twRoot,'Производители Россия');
      twRootI:=treeView1.items.Add(twRoot,'Производители импорт');
     if ToggleBox1.Checked then
      query:='SELECT `spproducer`.`ShortName`,`spproducer`.`fullName`,`spproducer`.`ClientRegId`,`spproduct`.`import`,`spproducer`.`kpp` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` AND `spproducer`.`fullName` LIKE "%'+edit1.text+'%" GROUP BY `spproduct`.`ClientRegId`,`spproducer`.`ShortName`'
     else
      query:='SELECT `spproducer`.`ShortName`,`spproducer`.`fullName`,`spproducer`.`ClientRegId`,`spproduct`.`import`,`spproducer`.`kpp` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` GROUP BY `spproduct`.`ClientRegId`,`spproducer`.`ShortName`';
    //  query:='SELECT `spproducer`.`ShortName`,`ClientRegId` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` ORDER BY `ClientRegId`' ;

      formStart.recbuf := formStart.DB_query(Query);
      formStart.rowbuf := formstart.DB_next(formStart.recbuf);
      i:=0;

      //StringGrid1.RowCount:=formStart.recbuf
      while formStart.rowbuf<>nil do begin
        if formStart.rowbuf[3]='1' then begin
             listClientIDI.Add(formStart.rowbuf[2]);
             twRoot:=twrooti  ;
             end
           else begin
           twRoot:=twrootr ;
           listClientIDR.Add(formStart.rowbuf[2]);
           end;
        if formStart.rowbuf[0]<>'' then begin
          treeView1.items.AddChild(twRoot,formStart.rowbuf[0]+'['+formStart.rowbuf[4]+']')

        end
        else
          treeView1.items.AddChild(twRoot,formStart.rowbuf[1]+'['+formStart.rowbuf[4]+']');
     //   listClientID.Add(formStart.rowbuf[2]);
        i:=i+1;
        formStart.rowbuf := formstart.DB_next(formStart.recbuf);
      end;
      formstart.disconnectDB();
end;

procedure TFormSpProduct.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if node<>nil then begin
    if node.Parent<>nil then begin
      if node.Parent.Index=0 then
        sClientRegId:=listClientIDR.Strings[node.Index]
      else
        sClientRegId:=listClientIDI.Strings[node.Index]
    end;
  end
  else
    sClientRegId:='000000000000';
  refreshprodlist();
//  caption:=sClientRegId;
end;

procedure TFormSpProduct.BitBtn1Click(Sender: TObject);
begin
  // ==== выбор ====
  modalresult:=1377;
//  close;
end;

procedure TFormSpProduct.bbRefreshBCClick(Sender: TObject);
var
  fnoupd:boolean;
  Query:string;
  ean13:string;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  yrowbuf : MYSQL_ROW;
  yrecbuf : PMYSQL_RES;
begin
  xrecbuf:=formStart.DB_query('SELECT `alccode`,`eanbc`,(SELECT `name` FROM `spproduct` WHERE `alccode` = `doccash`.`AlcCode`) as `name`,`price` FROM `doccash` WHERE (`eanbc`<>"") AND (`alccode`<>`plu`) AND (`alccode`<>"") GROUP BY `alccode`;');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
    begin
      formstart.SetEAN13rib(xrowbuf[0],xrowbuf[2],xrowbuf[1]);
      xrowbuf := formstart.DB_Next(xrecbuf);
    end;

  xrecbuf:=formStart.DB_query('SELECT `extcode`,`barcodes`,(SELECT `name` FROM `spproduct` WHERE `alccode` = `sprgoods`.`extcode`) as `name` FROM `sprgoods` WHERE (`barcodes`<>"") AND (`extcode`<>`plu`) AND (`extcode`<>"") AND (`alcgoods`="+");');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
   begin
     formstart.SetEAN13rib(xrowbuf[0],xrowbuf[2],xrowbuf[1]);
     xrowbuf := formstart.DB_Next(xrecbuf);
     //formstart.rowbuf := formstart.DB_Next(formstart.recbuf);
   end;



  xrecbuf:=formStart.DB_query('SELECT `alccode` FROM `regrestsshop` ;');
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
    begin
      ean13:=formstart.GetEAN13rib(xrowbuf[0]);
      yrecbuf:= formStart.DB_query( 'SELECT `plu` FROM `sprgoods` WHERE `extcode`=`plu` AND `barcodes`="'+ean13+'" ;');
      yrowbuf:=formstart.DB_next(yrecbuf);
      if yrowbuf<>nil then
        formstart.DB_query('UPDATE `sprgoods` SET `extcode`="'+xrowbuf[0]+'", `alcgoods`="+",`updating`="+" WHERE `extcode`=`plu` AND `barcodes`="'+ean13+'" AND `plu`="'+yrowbuf[0]+'";')
      else begin
        yrecbuf:= formStart.DB_query( 'SELECT `plu`,`alcgoods`,`name`,`fullname`,`currentprice`,`extcode` FROM `sprgoods` WHERE `barcodes`="'+ean13+'" ;');
        yrowbuf:=formstart.DB_next(yrecbuf);
        fnoupd:=true;
        query:='';
        while yrowbuf<>nil do begin

           Query:='INSERT INTO `sprgoods` (`plu`, `barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`) '+
           'VALUES ('''+yrowbuf[0]+''','''+trim(ean13)+''','''+xrowbuf[0]+''',''+'',''+'','''+trim(yrowbuf[2])+''','''+trim(yrowbuf[3])+''','''+trim(yrowbuf[4])+''');';
           if trim(yrowbuf[5]) = trim(xrowbuf[0]) then
              fnoupd:=false;
           yrowbuf := formstart.DB_Next(yrecbuf);
          end;
        if (fnoupd)and(query<>'') then
         formStart.DB_query(Query);
      end;


      xrowbuf := formstart.DB_Next(xrecbuf);
    end;

end;

procedure TFormSpProduct.BitBtn2Click(Sender: TObject);
begin

end;

procedure TFormSpProduct.Edit1Change(Sender: TObject);
begin

end;

procedure TFormSpProduct.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;
end;

procedure TFormSpProduct.FormCreate(Sender: TObject);
begin
  listClientIDI:=TStringList.Create;
  listClientIDR:=TStringList.Create;
end;

procedure TFormSpProduct.FormDestroy(Sender: TObject);
begin
  listClientIDI.Free;
  listClientIDR.free;
end;

procedure TFormSpProduct.FormShow(Sender: TObject);
var
  query:string;
  i:integer;
  twRoot:TTreeNode;
  twRootR:TTreeNode;
  twRootI:TTreeNode;
begin
  StringGrid1.Columns[0].Visible:=formstart.flOptMode;//formstart.;
  StringGrid1.Columns[2].Visible:=formstart.flOptMode;
  StringGrid1.Columns[3].Visible:=formstart.flOptMode;
  StringGrid1.Columns[4].Visible:=formstart.flOptMode;
  twRoot:=nil;
  listClientIDR.Clear;
  listClientIDI.Clear;
  treeView1.items.Clear;
  twRootR:=treeView1.items.Add(twRoot,'Производители Россия');
  twRootI:=treeView1.items.Add(twRoot,'Производители импорт');
  if ToggleBox1.Checked then
   query:='SELECT `spproducer`.`ShortName`,`spproducer`.`fullName`,`spproducer`.`ClientRegId`,`spproduct`.`import`,`spproducer`.`kpp` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` AND `spproducer`.`fullName` LIKE "%'+edit1.text+'%" GROUP BY `spproduct`.`ClientRegId`,`spproducer`.`ShortName`'
  else
   query:='SELECT `spproducer`.`ShortName`,`spproducer`.`fullName`,`spproducer`.`ClientRegId`,`spproduct`.`import`,`spproducer`.`kpp` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` GROUP BY `spproduct`.`ClientRegId`,`spproducer`.`ShortName`';
 //  query:='SELECT `spproducer`.`ShortName`,`ClientRegId` FROM `spproduct`,`spproducer` WHERE `spproducer`.`ClientRegId`=`spproduct`.`ClientRegId` ORDER BY `ClientRegId`' ;

  formStart.recbuf := formStart.DB_query(Query);
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  i:=0;

  //StringGrid1.RowCount:=formStart.recbuf
  while formStart.rowbuf<>nil do begin
    if formStart.rowbuf[3]='1' then begin
         listClientIDI.Add(formStart.rowbuf[2]);
         twRoot:=twrooti  ;
         end
       else begin
       twRoot:=twrootr ;
       listClientIDR.Add(formStart.rowbuf[2]);
       end;
    if formStart.rowbuf[0]<>'' then begin
      treeView1.items.AddChild(twRoot,formStart.rowbuf[0]+'['+formStart.rowbuf[4]+']')

    end
    else
      treeView1.items.AddChild(twRoot,formStart.rowbuf[1]+'['+formStart.rowbuf[4]+']');
 //   listClientID.Add(formStart.rowbuf[2]);
    i:=i+1;
    formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  end;
  formstart.disconnectDB();
end;

procedure TFormSpProduct.MenuItem1Click(Sender: TObject);
var
  query:string;
begin
  // ==== Редакт штрихкода
  if sRow>0 then begin

    query:='SELECT `plu` FROM `sprgoods` WHERE `extcode`="'+sAlcCode+'"  GROUP BY `plu`;' ;
    formStart.recbuf := formStart.DB_query(Query);
    formStart.rowbuf := formstart.DB_next(formStart.recbuf);
    if formStart.rowbuf<> nil then begin
      FormEditItem.flAlcCode:= sAlcCode;
      FormEditItem.flPLU:= formStart.rowbuf[0];
      FormEditItem.showmodal;
    end else begin
      FormSpGoods.flSelectItem:=true;
      if FormSpGoods.ShowModal = 1377 then begin
        FormEditItem.flAlcCode:= sAlcCode;
        FormEditItem.flPLU:= FormSpGoods.flPLU;
        FormEditItem.showmodal;
      end;
      FormSpGoods.flSelectItem:=false;
    end;
  end;
end;

procedure TFormSpProduct.MenuItem2Click(Sender: TObject);
begin
  // ==== Редакт Алк
  if sRow>0 then begin
    FormAclItem.flAlcCode:= sAlcCode;
    FormAclItem.showmodal;
  end;
end;

procedure TFormSpProduct.MenuItem3Click(Sender: TObject);
begin
  if (sRow>0)and (sAlcCode<>'') then begin

    formStart.DB_query(' DELETE FROM `sprgoods` WHERE `extcode`="'+sAlcCode+'" ;');
  end;
end;

procedure TFormSpProduct.refreshprodlist();
var
  query:string;
  i:integer;
  filtrL:string;
begin
  filtrL:='';

  StringGrid1.clear;
  query:='SELECT `AlcCode`,`name`,`ClientRegId`,`Capacity`,`AlcVolume`,( SELECT `barcodes` FROM `sprgoods` WHERE `extcode`=`spproduct`.`AlcCode` LIMIT 1) as `barcodes`,( SELECT `currentprice` FROM `sprgoods` WHERE `extcode`=`spproduct`.`AlcCode` LIMIT 1) as `currentprice`,( SELECT SUM(`Quantity`) FROM `regrestsproduct` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countitem` ,( SELECT SUM(`Quantity`) FROM `regrestsshop` WHERE `AlcCode`=`spproduct`.`AlcCode`) as `countshop`  FROM `spproduct` WHERE `ClientRegId`="'+sClientRegId+'" '+filtrL+' ORDER BY `AlcCode` ASC;' ;
  formStart.recbuf := formStart.DB_query(Query);
  formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  StringGrid1.RowCount:=2;
  i:=1;
//  StringGrid1.RowCount:=mysql_row_tell(formStart.recbuf);
  //StringGrid1.RowCount:=formStart.recbuf
  while formStart.rowbuf<>nil do begin
    StringGrid1.RowCount:=i+1;
    StringGrid1.Rows[i].Clear;
    StringGrid1.Rows[i].Add('');
//    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[0]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[1]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[2]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[3]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[4]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[5]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[6]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[7]);
    StringGrid1.Rows[i].Add(formStart.rowbuf[8]);
    i:=i+1;
    formStart.rowbuf := formstart.DB_next(formStart.recbuf);
  end;
  formstart.disconnectDB();

end;

end.

