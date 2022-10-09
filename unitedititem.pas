unit unitedititem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Grids, ComCtrls;

type

  { TFormEditItem }

  TFormEditItem = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    cbAlcProduct: TCheckBox;
    cbFreePrice: TCheckBox;
    cbVesovoi: TCheckBox;
    cbTypeGood: TComboBox;
    edGroup: TEdit;
    edSection: TEdit;
    edName: TEdit;
    Edit3: TEdit;
    edPLU: TEdit;
    edPrint: TEdit;
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StringGrid1: TStringGrid;
    SGAlcCode: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn1KeyPress(Sender: TObject; var Key: char);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn6KeyPress(Sender: TObject; var Key: char);
    procedure BitBtn7Click(Sender: TObject);
    procedure edGroupChange(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure edNameChangeBounds(Sender: TObject);
    procedure edNameEnter(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: char);
    procedure edPrintChange(Sender: TObject);
    procedure edPrintChangeBounds(Sender: TObject);
    procedure edPrintExit(Sender: TObject);
    procedure edPrintKeyPress(Sender: TObject; var Key: char);
    procedure edSectionKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure SGAlcCodeDblClick(Sender: TObject);
  private
    { private declarations }
    flEditing:boolean;
  public
    { public declarations }
    ArrAlcCode:string;
    flAlcCode:string;
    flPLU:string;
    flNew:boolean;
    flGroupId:string;
    tMPCAPTION:string;
    procedure EditCapt;
    procedure CopyItem(aPLU:String);
    Procedure NewItem;
    Procedure EditItem(aPLU:String;aAlcCode:String='');
    function SelectItem():boolean;
  end;

var
  FormEditItem: TFormEditItem;

implementation

{$R *.lfm}
 uses unitstart, unitshoprest,unitselgroup, mysql50;
{ TFormEditItem }
const
  t_typegood:array[0..12] of string = (
                   'Нет',
                   'Шубы',
                   'Обувь',
                   'Лекарства',
                   'Фотоаппараты и лампы-вспышки',
                   'Шины и покрышки',
                   'Товары легкой промышленности',
                   'Духи и туалетная вода',
                   'Молочная продукция',
                   'Кресла-коляски',
                   'Велосипеды',
                   'Упакованная вода',
                   'Пиво и пивные напитки');

procedure TFormEditItem.FormCreate(Sender: TObject);
begin
  tMPCAPTION:=caption;
  //++ 2021-02-04 Uffik
  // Проверка соответствии справочника
  formStart.DB_checkCol('sprgoods','typegood','int(3)','');
  //-- 2021-02-04
end;

procedure TFormEditItem.BitBtn2Click(Sender: TObject);
begin
  Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
end;

procedure TFormEditItem.BitBtn1Click(Sender: TObject);
var
  query:string;
  ii:integer;
  str1:string;
  ves1:string;
  flSKU:Int64;
  flfreeprice:string;
  flAlcCode1:string;
begin
  if (edPrint.text='') then begin
    showmessage('Пустое наименование товара!');
    exit;
  end;

  if (trim(edPLU.text)='')or(trim(edPLU.text)='0') then begin
    showmessage('Пустое ПЛУ товара!');
    exit;
  end;
  if cbAlcProduct.Checked then
    flAlcCode1:='+'
    else
     flAlcCode1:='-';
  if cbFreeprice.Checked then
    flfreeprice:='+'
    else
      flfreeprice:='';

  if flNew then begin
          Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'";';
          formstart.recbuf:=formstart.DB_query(query);
          formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
          if formstart.rowbuf<>nil then
            begin
                    ShowMessage('Такой такой код товара уже имеется, исправьте и сохраните повторно.');
                    exit;
            end;
    if flSKU < Strtoint(edplu.text) then
       formStart.SetConstant('NumberSKU',edplu.text);
  end else
  begin
    if edPLU.text<>flPLU then begin
      Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'";';
      formstart.recbuf:=formstart.DB_query(query);
      formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
      if formstart.rowbuf<>nil then
        begin
                ShowMessage('Такой такой код товара уже имеется, исправьте и сохраните повторно.');
                edPLU.text:=flPLU;
                exit;
        end;
        formStart.DB_query('UPDATE `sprgoods` SET `plu`="'+edPLU.text+'" WHERE `plu`="'+flPLU+'";');
        flPLU:=edPLU.text;
      end;
  end;


  ves1:='';
  if cbVesovoi.Checked then
     ves1:='+';
  if flAlcCode <>'' then begin
    if StringGrid1.RowCount<1 then begin
      showmessage('Должен быть хоть один Штрихкод!');
      exit;
    end;
    Query:='SELECT `plu` FROM `sprgoods` WHERE `extcode` = "'+flAlcCode+'";';
    formstart.recbuf:=formstart.DB_query(query);
    formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
    if formstart.rowbuf<>nil then begin
      // === Есть такой товар в справочнике ===

      if formstart.rowbuf[0] = edplu.text then begin
          // === надо изменить данные
        query:='DELETE FROM `sprgoods` WHERE `extcode`="'+flAlcCode+'" and `plu` = "'+edplu.text+'";';
       formstart.recbuf:=formstart.DB_query(query);
        for ii:=1 to StringGrid1.RowCount-1 do
              formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`freeprice`,`groupid`,`section`,`typegood`,`article`,`viewcash`,`isdelete`,`notkkm`)'+
              'VALUE ('''+edplu.text+''','''+StringGrid1.Cells[0,ii]+''','''+flAlcCode+
              ''',''+'',''+'','''+edPrint.Text+''','''+edName.text+''','''+trim(Edit3.Text)+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'','''',''+'',''-'',''-'');');
        exit;
        end else
        begin
          Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'";';
          formstart.recbuf:=formstart.DB_query(query);
          formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
          if formstart.rowbuf<>nil then
            begin
              ShowMessage('Товар с таким PLU уже есть. Сначало удалите его из справочника, а после измените этот.');
              exit;
            end else
            begin
              for ii:=1 to StringGrid1.RowCount-1 do
                Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'" AND `extcode` = "'+flAlcCode+'" AND `barcodes` = "'+StringGrid1.Cells[0,ii]+'" ;';
                formstart.recbuf:=formstart.DB_query(query);
                formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
                if formstart.rowbuf<>nil then  begin
                     formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`freeprice`,`groupid`,`section`,`typegood`,`article`,`viewcash`,`isdelete`,`notkkm`)'+
                     'VALUE ('''+edplu.text+''','''+StringGrid1.Cells[0,ii]+''','''+flAlcCode+
                    ''',''+'',''+'','''+edPrint.Text+''','''+edName.text+''','''+trim(edit3.text)+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'','''',''+'',''-'',''-'');');
                  end else
                    formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`freeprice`,`groupid`,`section`,`typegood`,`article`,`viewcash`,`isdelete`,`notkkm`) VALUE ('''+edplu.text+''','''+StringGrid1.Cells[0,ii]+''','''+flAlcCode+
                    ''',''+'',''+'','''+edPrint.Text+''','''+edName.text+''','''+trim(edit3.text)+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'','''',''+'',''-'',''-'');');
                end;
              exit;
            end;
        end else begin
          Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'" AND `extcode`="" ;';
          formstart.recbuf:=formstart.DB_query(query);
          formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
          if formstart.rowbuf<>nil then begin
              query:='DELETE FROM `sprgoods` WHERE `extcode`="'+flAlcCode+'";';
             formstart.recbuf:=formstart.DB_query(query);
           end;
          for ii:=1 to StringGrid1.RowCount-1 do
                formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`extcode`,`updating`,`alcgoods`,`name`,`fullname`,`currentprice`,`freeprice`,`groupid`,`section`,`typegood`,`article`,`viewcash`,`isdelete`,`notkkm`)VALUE ('''+edplu.text+''','''+StringGrid1.Cells[0,ii]+''','''+flAlcCode+
                ''',''+'',''+'','''+edPrint.Text+''','''+edName.text+''','''+trim(edit3.text)+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'','''',''+'',''-'',''-'');');

        end;

    end else
    begin
      Query:='SELECT `plu` FROM `sprgoods` WHERE `plu` = "'+edplu.text+'" AND `extcode`="" ;';
      formstart.recbuf:=formstart.DB_query(query);
      formstart.rowbuf:=FormStart.DB_Next(formstart.recbuf);
      if formstart.rowbuf<>nil then begin
          Query:='DELETE FROM `sprgoods` WHERE `plu` = "'+edplu.text+'" AND `extcode`="" ;';
          formStart.DB_query(Query);
       end;
      if StringGrid1.RowCount>1 then
          for ii:=1 to StringGrid1.RowCount-1 do begin
            formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`updating`,`name`,`fullname`,`currentprice`,`weightgood`,`freeprice`,`groupid`,`section`,`typegood`,`alcgoods`,`extcode`,`article`,`isdelete`,`notkkm`,`viewcash`)VALUE '+
            '('''+ edplu.text+''','''+StringGrid1.Cells[0,ii]+''',''+'','''+ReplaceStr(edPrint.Text)+''','''+ReplaceStr(edPrint.Text)+''','''+trim(edit3.Text)+''','''+ves1+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'',''-'','''','''',''-'',''-'',''+'');');
          end
       else begin
         formStart.DB_query('INSERT INTO `sprgoods` ( `plu`,`barcodes`,`updating`,`name`,`fullname`,`currentprice`,`weightgood`,`freeprice`,`groupid`,`section`,`typegood`,`alcgoods`,`extcode`,`article`,`isdelete`,`notkkm`,`viewcash`)VALUE '+
         '('''+ edplu.text+''','''',''+'','''+ReplaceStr(edPrint.Text)+''','''+ReplaceStr(edPrint.Text)+''','''+trim(edit3.Text)+''','''+ves1+''','''+flfreeprice+''','''+flGroupId+''','''+trim(edSection.text)+''',''0'',''-'','''','''',''-'',''-'',''+'');');

       end;

    end;
  flEditing:=false;
  Caption:=tMPCAPTION;
end;

procedure TFormEditItem.BitBtn1KeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then begin
    BitBtn1Click(sender);
    key:=#0;
    self.SelectNext(ActiveControl,True,True);
  end;
end;

procedure TFormEditItem.BitBtn3Click(Sender: TObject);
begin
 if Stringgrid1.Row> 0 then
  Stringgrid1.DeleteRow(Stringgrid1.Row);
 EditCapt;

end;

procedure TFormEditItem.BitBtn4Click(Sender: TObject);
var
    i:integer;
begin
    FormShopRest.flSelectMode:=true;
    if FormShopRest.ShowModal =1377 then begin
        i:=SGAlcCode.RowCount;
        SGAlcCode.RowCount:=i+1;
        SGAlcCode.Cells[0,i]:=FormShopRest.flAlcCode;
        flAlcCode:=FormShopRest.flAlcCode;
        SGAlcCode.Cells[1,i]:=FormShopRest.StringGrid1.Cells[1,FormShopRest.StringGrid1.row];
        SGAlcCode.Cells[2,i]:=FormShopRest.StringGrid1.Cells[4,FormShopRest.StringGrid1.row];
        //GroupBox1.Caption:='Алкогольный товар ['+flAlcCode+']';

        EditCapt;
        //StringGrid1.Cells[4,i]:=FormShopRest.StringGrid1.Cells[3,FormShopRest.StringGrid1.row];
    end;
    FormShopRest.flSelectMode:=false;
end;

procedure TFormEditItem.BitBtn5Click(Sender: TObject);
begin
  flGroupId:=formselgroup.selectfolder();
  if flGroupId<>'' then begin
     edGroup.text:=formselgroup.flNameGroup;
     EditCapt;
  end;
end;

procedure TFormEditItem.BitBtn6Click(Sender: TObject);
var
    res:integer;
begin
{  res:=MessageDlg('Сохранить изменения?',mtWarning,[ mbYes, mbNo],0);
  if 6 = res then begin
    BitBtn1Click(Sender);
    end; }
  modalresult:=0;
  close;
end;

procedure TFormEditItem.BitBtn6KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    Close;
  end;
end;

procedure TFormEditItem.BitBtn7Click(Sender: TObject);
begin
  flGroupId:='';
  edGroup.text:='';
end;

procedure TFormEditItem.edGroupChange(Sender: TObject);
begin
  EditCapt;
end;

procedure TFormEditItem.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if  key in ['0'..'9','.',#1..#31] then
   else
     begin
       key:=#0;
     end;
  if key=#13 then begin
    key:=#0;
    self.SelectNext(ActiveControl,True,True);
  end;
end;

procedure TFormEditItem.edNameChangeBounds(Sender: TObject);
begin

end;

procedure TFormEditItem.edNameEnter(Sender: TObject);
begin
  if flNew and (edName.Text='') then begin
    edName.Text:=edPrint.text;
    EditCapt;
  end;

end;

procedure TFormEditItem.edNameKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    self.SelectNext(ActiveControl,True,True);
  end;
end;

procedure TFormEditItem.edPrintChange(Sender: TObject);
begin
  EditCapt;
end;

procedure TFormEditItem.edPrintChangeBounds(Sender: TObject);
begin
  EditCapt;
end;

procedure TFormEditItem.edPrintExit(Sender: TObject);
begin
  if flNew and (edName.Text='') then
    edName.Text:=edPrint.text;
end;

procedure TFormEditItem.edPrintKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then begin
    key:=#0;
    self.SelectNext(ActiveControl,True,True);
  end;
end;

procedure TFormEditItem.edSectionKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFormEditItem.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );

var
      res:integer;
begin
  if flEditing then begin
    res:=MessageDlg('Сохранить изменения?',mtWarning,[ mbYes, mbNo],0);
    if 6 = res then begin
      BitBtn1Click(Sender);
      end;
    end;
  CloseAction:=caHide;
end;

procedure TFormEditItem.FormShow(Sender: TObject);

begin
  flEditing:=false;

end;

procedure TFormEditItem.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if not(key in [#1..#31,'0'..'9']) then
    key:=#0;
end;

procedure TFormEditItem.SGAlcCodeDblClick(Sender: TObject);
begin

end;

procedure TFormEditItem.EditCapt;
begin
  Caption:=tMPCAPTION+' *';
  flEditing:=true;
end;

procedure TFormEditItem.CopyItem(aPLU: String);
var
  query:string;
  flSKU:integer;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
    flAlcCode:='';
    query:='SELECT `barcodes`,`currentprice`,`name`,`fullname`,`weightgood`,`alcgoods`,`extcode`,`freeprice`,`groupid`,(SELECT `name` FROM `sprgroups` WHERE `groupid`=`sprgoods`.`groupid`) AS `grpname`,`section` FROM `sprgoods` WHERE `plu`="'+aPLU+'"  GROUP BY `barcodes`;';
    xrecbuf:=formstart.DB_query(query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
    cbFreePrice.Checked:=false;
    Stringgrid1.RowCount:=1;
    while xrowbuf<>nil do begin
      Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
      Stringgrid1.Cells[0,Stringgrid1.RowCount-1]:=xrowbuf[0];
      //Stringgrid1.Cells[1,Stringgrid1.RowCount-1]:=formStart.rowbuf[1];
      edName.text:=xrowbuf[3];
      flGroupId:=xrowbuf[8];
      edGroup.text:=xrowbuf[9];
      edPrint.Text:=xrowbuf[2];
      edit3.Text:=xrowbuf[1];
      edSection.text:=xrowbuf[10];
     if xrowbuf[7]='+' then
       cbFreePrice.Checked:=true;
      if flAlcCode = '' then begin

        if db_boolean(xrowbuf[4]) then
          cbVesovoi.Checked:=true
        else
          cbVesovoi.Checked:=false;
        if db_boolean(xrowbuf[5]) then begin
            flAlcCode:= xrowbuf[6];
            cbAlcProduct.Checked:=true;
            end
          else
            flAlcCode:='';
      end else
        cbAlcProduct.Checked:=true;


//      query:='SELECT `barcodes`,`currentprice`,`name`,`fullname`,`weightgood`,`alcgoods`,`extcode` FROM `sprgoods` WHERE `plu`="'+flPLU+'" GROUP BY `barcodes`;';
      xrowbuf:=formStart.DB_Next(xrecbuf);

    end;
    if  formStart.GetConstant('NumberSKU')='' then
        flSKU:=1
        else
          flSKU:=strtoint(formStart.GetConstant('NumberSKU')) ; // === Номер последнего товара
     if flSKU>99997 then
       flSKU:=1;
     //Stringgrid1.Clear;
     //Stringgrid1.RowCount:=1;
     flPLU:= inttostr(flSKU+1);
     edPLU.Text:=flPLU;
     Caption:=tmpCaption;
  formedititem.ShowModal;
end;

procedure TFormEditItem.NewItem;
var
  query:string;
  flSKU:int64;
   xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  //GroupBox1.Caption:='Алкогольный товар []';
  edName.Text:='';
  edPrint.Text:='';
  StringGrid1.RowCount:=1;
  Edit3.Text:='0.00';
  flAlcCode:='';
  flPLU:='';
  flNew:=true;
  SGAlcCode.Clear;
  SGAlcCode.RowCount:=0;

  if  trim(formStart.GetConstant('NumberSKU'))='' then
    flSKU:=1
    else
      flSKU:=strtoint(formStart.GetConstant('NumberSKU')) ; // === Номер последнего товара

  Query:='SELECT MAX(`plu`) AS `maxplu` FROM `sprgoods`;';
  xrecbuf:=formstart.DB_query(query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  if xrowbuf<>nil then
    begin
      if xrowbuf[0]<>'' then begin
        if flSKU<strtoint(xrowbuf[0]) then
          flSKU:=strtoint(xrowbuf[0]);
      end;
    end;
  if flSKU>99997 then
   flSKU:=1;

  flPLU:= inttostr(flSKU+1);
  edPLU.Text:=flPLU;
  edName.text:='';
  //stAlcName.Caption:='';
  Stringgrid1.Clear;
  Stringgrid1.RowCount:=1;
  edGroup.Text:='';
  cbFreePrice.Checked:=false;
  EditCapt;
  formedititem.ShowModal;
end;

procedure TFormEditItem.EditItem(aPLU: String;aAlcCode:String='');
var
  query:string;
  flSKU:integer;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
  i:integer;
begin
  flPLU:=aPLU;
  edName.Text:='';
  Edit3.Text:='0.00';
  flAlcCode:=aAlcCode;
  cbFreePrice.Checked:=false;
  cbAlcProduct.Checked:=false;
  if flAlcCode<>''  then begin // ====
    query:='SELECT `name` FROM `spproduct` WHERE `alccode`="'+flAlcCode+'";';
    xrecbuf:=formstart.DB_query(query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
    if xrowbuf<>nil then begin
      edName.text:=xrowbuf[0];
      //stAlcName.Caption:=xrowbuf[0];
    end;
    cbFreePrice.Checked:=false;
    query:='SELECT `barcodes`,`currentprice`,`name`,`plu`,`fullname`,`freeprice`,`groupid`,(SELECT `name` FROM `sprgroups` WHERE `groupid`=`sprgoods`.`groupid`) AS `grpname`,`section` FROM `sprgoods` WHERE `extcode`="'+flAlcCode+'";';
    xrecbuf:=formstart.DB_query(query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
    Stringgrid1.RowCount:=1;
    while formStart.rowbuf<>nil do begin
      Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
      Stringgrid1.Cells[0,Stringgrid1.RowCount-1]:=xrowbuf[0];
      //Stringgrid1.Cells[1,Stringgrid1.RowCount-1]:=formStart.rowbuf[1];
      edName.text:=xrowbuf[4];
      edplu.text:= xrowbuf[3];
      edPrint.Text:=xrowbuf[2];
      edit3.Text:=xrowbuf[1];
      flGroupId:=xrowbuf[6];
      edGroup.text:=xrowbuf[7];
      edSection.text:=xrowbuf[8];
      if formStart.rowbuf[5]='+' then
       cbFreePrice.Checked:=true;
      xrowbuf:=formStart.DB_Next(xrecbuf);
    end;
    //GroupBox1.Caption:='Алкогольный товар ['+flAlcCode+']';
    cbVesovoi.Checked:=false;
    cbAlcProduct.Checked:=true;
    flNew:=false;

  end;
  if flPLU<>''  then begin
  {  query:='SELECT `name` FROM `spproduct` WHERE `alccode`="'+flAlcCode+'";';
    formstart.recbuf:=formstart.DB_query(query);
    formStart.rowbuf:=formStart.DB_Next(formstart.recbuf);
    if formStart.rowbuf<>nil then begin
      stName.Caption:=formStart.rowbuf[0];

    end; }
    edPLU.Text:=flPLU;

    query:='SELECT `barcodes`,`currentprice`,`name`,`fullname`,`weightgood`,`alcgoods`,`extcode`,`freeprice`,`groupid`,(SELECT `name` FROM `sprgroups` WHERE `groupid`=`sprgoods`.`groupid`) AS `grpname`,`section` FROM `sprgoods` WHERE `plu`="'+flPLU+'"  GROUP BY `barcodes`;';
    xrecbuf:=formstart.DB_query(query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
    cbFreePrice.Checked:=false;
    Stringgrid1.RowCount:=1;
    while xrowbuf<>nil do begin
      Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
      Stringgrid1.Cells[0,Stringgrid1.RowCount-1]:=xrowbuf[0];
      //Stringgrid1.Cells[1,Stringgrid1.RowCount-1]:=formStart.rowbuf[1];
      edName.text:=xrowbuf[3];
      flGroupId:=xrowbuf[8];
      edGroup.text:=xrowbuf[9];
      edPrint.Text:=xrowbuf[2];
      edit3.Text:=xrowbuf[1];
      edSection.text:=xrowbuf[10];
      cbAlcProduct.Checked:=db_boolean(xrowbuf[5]);
     if xrowbuf[7]='+' then
       cbFreePrice.Checked:=true;
      if flAlcCode = '' then begin
        cbVesovoi.Checked:= db_boolean(xrowbuf[4]);

        if db_boolean(xrowbuf[5]) then begin
            flAlcCode:= xrowbuf[6];
            cbAlcProduct.Checked:=true;
            end
          else
            flAlcCode:='';
      end else
        cbAlcProduct.Checked:=true;

      //GroupBox1.Caption:='Алкогольный товар ['+flAlcCode+']';
//      query:='SELECT `barcodes`,`currentprice`,`name`,`fullname`,`weightgood`,`alcgoods`,`extcode` FROM `sprgoods` WHERE `plu`="'+flPLU+'" GROUP BY `barcodes`;';
      xrowbuf:=formStart.DB_Next(xrecbuf);

    end;
     flNew:=false;

  end;

  formedititem.ShowModal;
end;



function TFormEditItem.SelectItem: boolean;
begin

end;

end.

