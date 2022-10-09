unit unitexportform12;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DSet, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ComCtrls, Grids, Buttons, Menus;

type

  { TFormExportForm12 }

  TFormExportForm12 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    bbControle: TBitBtn;
    BitBtn7: TBitBtn;
    frReport1: TfrReport;
    frUserDataset1: TfrUserDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    odForm12: TOpenDialog;
    PageControl1: TPageControl;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    ppImportForms12_8: TPopupMenu;
    sdd1: TSelectDirectoryDialog;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure bbControleClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frUserDataset1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frUserDataset1First(Sender: TObject);
    procedure frUserDataset1Next(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }
  public
    flForm12:boolean;
    flNumDoc:string;
    flDateDoc:String;
    flUIDDoc:string;
    flCorrecting:integer;
    { public declarations }
    flStartDate, flEndDate:tdatetime;
    flIMNSKods:String; // === коды учавствущие в отчете ====
    flselreprow:integer;
    procedure SaveToXLS();
    procedure SortByIMNS();
  end;

var
  FormExportForm12: TFormExportForm12;

implementation

uses lazutf8
  ,LConvEncoding
  ,XMLRead
  ,DOM
  ,unitstart
  , unitfilter
  , mysql50
  , unitextreport
  ,unitlogging;
{$R *.lfm}

// '500','520','261','263','262'

function thisBeer(fIMNS:string):boolean;
begin
 result:=false;
 if fIMNS ='500' then result:=true;
 if fIMNS ='520' then result:=true;
 if fIMNS ='261' then result:=true;
 if fIMNS ='263' then result:=true;
 if fIMNS ='262' then result:=true;
end;
{ TFormExportForm12 }

procedure TFormExportForm12.SortByIMNS();
var
  i:integer;
  ii:integer;
  value:string;
begin




 for i:=stringGrid2.RowCount-1 downto 2 do
      if strtoint(stringGrid2.Cells[1,i])<strtoint(stringGrid2.Cells[1,i-1]) then
        for ii:=1 to 19 do begin
           value:= stringGrid2.Cells[ii,i-1];
           stringGrid2.Cells[ii,i-1]:= stringGrid2.Cells[ii,i];
           stringGrid2.Cells[ii,i]:=value;
        end;
end;

procedure TFormExportForm12.BitBtn2Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  ii:integer;
  i:integer=1;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
  imns1:string;
  kodegais:string;
  fAlcCode:string;
  ffindrow:boolean;
  qr1:double;
begin
    // === Цикл =====
     Query:='SELECT '+
     '(SELECT `fullname` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `nameclient`,'+
     '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `innclient`,'+
     '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `kppclient`,'
     +'`docjurnale`.`ClientRegId` FROM `docjurnale` WHERE `docjurnale`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `docjurnale`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" GROUP BY `docjurnale`.`ClientRegId`;';
     xrecbuf:=formstart.DB_Query(Query);
     xrowbuf:=formstart.DB_Next(xrecbuf);
     stringgrid3.RowCount:=1;
     while xrowbuf<>nil do begin
     // ==== оборот =====
        i:=0;
        while ((StringGrid3.Cells[1,i]<>xrowbuf[3]) and
               (i<StringGrid3.RowCount-1)) do i:=i+1;
        if (StringGrid3.Cells[1,i]<>xrowbuf[3]) then begin
          i:=StringGrid3.RowCount;
          StringGrid3.RowCount:=i+1;
        end;
       stringgrid3.Cells[1,i]:=xrowbuf[3];
       stringgrid3.Cells[2,i]:=xrowbuf[0];
       stringgrid3.Cells[3,i]:=xrowbuf[1];
       stringgrid3.Cells[4,i]:=xrowbuf[2];
       xrowbuf:=formstart.DB_Next(xrecbuf);

      end;
     i:=1;
     // === Цикл =====
      Query:='SELECT '+
      '`spproduct`.`import`,'+
      '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
      '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
      '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
      '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
      '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
      '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
      '(SELECT `fullname` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `nameclient`,'+
      '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `innclient`,'+
      '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `kppclient`,'+
      '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` ,`doc221`.`numdoc`, DATE_FORMAT(`doc221`.`datedoc`,"%d.%m.%Y"), FORMAT(SUM(`doc221`.`factcount`*`spproduct`.`capacity`*0.1),3)'
      +',`docjurnale`.`ClientRegId` FROM `doc221`,`docjurnale`,`spproduct` WHERE `doc221`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc221`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" AND `spproduct`.`alccode`=`doc221`.`alcitem` AND `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` GROUP BY `spproduct`.`ClientRegId`,`docjurnale`.`ClientRegId`;';
      xrecbuf:=formstart.DB_Query(Query);
      xrowbuf:=formstart.DB_Next(xrecbuf);
      stringgrid4.RowCount:=1;
      while xrowbuf<>nil do begin // ==== оборот =====
          i:=0;


         if xrowbuf[2]='' then begin
          while ((StringGrid4.Cells[1,i]<>xrowbuf[11]) and
                 (i<StringGrid4.RowCount-1)) do i:=i+1;
          if StringGrid4.Cells[1,i]<>xrowbuf[11] then begin
            i:=StringGrid4.RowCount;
            StringGrid4.RowCount:=i+1;
          end;
           stringgrid4.Cells[3,i]:=xrowbuf[5];
           stringgrid4.Cells[4,i]:=xrowbuf[6];
           stringgrid4.Cells[1,i]:=xrowbuf[11];
           stringgrid4.Cells[2,i]:=xrowbuf[4];
          end
         else begin
            while ((StringGrid4.Cells[1,i]<>xrowbuf[10]) and
                   (i<StringGrid4.RowCount-1)) do i:=i+1;
            if StringGrid4.Cells[1,i]<>xrowbuf[10] then begin
              i:=StringGrid4.RowCount;
              StringGrid4.RowCount:=i+1;
            end;
          stringgrid4.Cells[3,i]:=xrowbuf[2];
          stringgrid4.Cells[4,i]:=xrowbuf[3];
          stringgrid4.Cells[1,i]:=xrowbuf[10];
          stringgrid4.Cells[2,i]:=xrowbuf[1];
         end;
        xrowbuf:=formstart.DB_Next(xrecbuf);
        i:=i+1;
       end;
    // === Цикл =====
    Query:='SELECT '+
    '`spproduct`.`productvcode`,'+  // [0]
    '`spproduct`.`alccode`,'+       // [1]
    '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+ // [2]
    '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+                                 // [3]
    '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+                                 // [4]
    '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+ // [5]
    '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+                                 // [6]
    '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+                                 // [7]
    '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `nameclient`,'+           // [8]
    '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `innclient`,'+                              // [9]
    '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`docjurnale`.`ClientRegId` limit 1) AS `kppclient`,'+                              // [10]
    '`spproduct`.`ClientRegId`,'+                                                                                                           // [11]
    '`spproduct`.`iClientRegId` ,'+                                                                                                         // [12]
    '`doc221`.`numdoc`,'+                                                                                                                   // [13]
    ' DATE_FORMAT(`doc221`.`datedoc`,"%d.%m.%Y"),'+                                                                                         // [14]
    ' FORMAT(SUM(`doc221`.`factcount`*`spproduct`.`capacity`* 0.1),5)'                                                                      // [15]
    +',`docjurnale`.`ClientRegId`'+                                                                                                         // [16]
    ' FROM `doc221`,`docjurnale`,`spproduct` WHERE `doc221`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc221`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" AND `spproduct`.`alccode`=`doc221`.`alcitem` AND `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`,`docjurnale`.`ClientRegId`,`doc221`.`numdoc`;';
    xrecbuf:=formstart.DB_Query(Query);
    xrowbuf:=formstart.DB_Next(xrecbuf);
    i:=1;
    stringgrid1.RowCount:=i+1;
    while xrowbuf<>nil do begin
    // ==== оборот =====
      if (thisBeer(xrowbuf[0]))  then  begin
        if not flForm12 then begin
          xrowbuf:=formstart.DB_Next(xrecbuf);
          continue;
          end;
      end else begin
        if  flForm12 then begin
          xrowbuf:=formstart.DB_Next(xrecbuf);
          continue;
          end;
      end;

      stringgrid1.RowCount:=i+1;
      stringgrid1.Cells[1,i]:=xrowbuf[0];
      stringgrid1.Cells[13,i]:=xrowbuf[1];
      if (xrowbuf[6] = '')and(xrowbuf[3] = '') then begin
               stringgrid1.Cells[0,i]:='*';
               FormStart.DB_Query('INSERT `stacksender` (`type`,`value`,`sending`) VALUES ("queryap","'+xrowbuf[1]+'","");');
             end;
      if xrowbuf[3]='' then begin
         stringgrid1.Cells[3,i]:=xrowbuf[5];
         stringgrid1.Cells[4,i]:=xrowbuf[6];
         stringgrid1.Cells[5,i]:=xrowbuf[7];
         stringgrid1.Cells[2,i]:=xrowbuf[12];
        end
       else begin
        stringgrid1.Cells[3,i]:=xrowbuf[2];
        stringgrid1.Cells[4,i]:=xrowbuf[3];
        stringgrid1.Cells[5,i]:=xrowbuf[4];
        stringgrid1.Cells[2,i]:=xrowbuf[11];
       end;
       stringgrid1.Cells[6,i]:=xrowbuf[16];
       stringgrid1.Cells[7,i]:=xrowbuf[8];
       stringgrid1.Cells[8,i]:=xrowbuf[9];
       stringgrid1.Cells[9,i]:=xrowbuf[10];


       stringgrid1.Cells[10,i]:=xrowbuf[13];
       stringgrid1.Cells[11,i]:=xrowbuf[14];
       stringgrid1.Cells[12,i]:=xrowbuf[15];

      xrowbuf:=formstart.DB_Next(xrecbuf);
      i:=i+1;
     end;

        i:=1;
        // === Цикл =====
        Query:='SELECT '+
        '`spproduct`.`productvcode`,'+
        '`spproduct`.`import`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
        '`spproduct`.`ClientRegId`,'+
        '`spproduct`.`iClientRegId` ,'+
        ' FORMAT(SUM(`doc221`.`factcount`*`spproduct`.`capacity` *0.1),3)'
        +',`docjurnale`.`ClientRegId` AS `jClientRegId` FROM `doc221`,`docjurnale`,`spproduct` WHERE `doc221`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc221`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" AND `spproduct`.`alccode`=`doc221`.`alcitem` AND `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` '+
        'GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId`;';
        xrecbuf:=formstart.DB_Query(Query);
        xrowbuf:=formstart.DB_Next(xrecbuf);
        stringgrid2.RowCount:=1;
        while xrowbuf<>nil do begin  // ==== оборот =====
          if stringgrid2.RowCount > 1 then begin
            ffindrow:=false;
            for i:=2 to stringgrid2.RowCount-1 do begin
              if (stringgrid2.Cells[1,i] = xrowbuf[0])
                 and ((stringgrid2.Cells[3,i] = xrowbuf[9])
                 or (stringgrid2.Cells[3,i] = xrowbuf[8])) then begin
                 ii:=i; ffindrow:=true; break;
              end;
            end;

            if ffindrow then  begin

              if xrowbuf[3]='' then begin
                 if xrowbuf[1] = '' then begin
                   if xrowbuf[9] = xrowbuf[11] then stringgrid2.Cells[10,ii]:=floattostr(formstart.StrToFloat(stringgrid2.Cells[10,ii])+formstart.StrToFloat(xrowbuf[10]))
                   else stringgrid2.Cells[9,ii]:=floattostr(formstart.StrToFloat(stringgrid2.Cells[9,ii])+formstart.StrToFloat(xrowbuf[10])) ;
                 end else stringgrid2.Cells[10,ii]:=floattostr(formstart.StrToFloat(stringgrid2.Cells[10,ii])+formstart.StrToFloat(xrowbuf[10])) ;
               end else begin
                 if xrowbuf[1] = '' then begin
                   if xrowbuf[8]= xrowbuf[11] then begin
                     qr1:=formstart.StrToFloat(stringgrid2.Cells[8,ii])+formstart.StrToFloat(xrowbuf[10]);
                     stringgrid2.Cells[8,ii]:=floattostr(qr1);
                   end
                   else stringgrid2.Cells[9,ii]:=floattostr(formstart.StrToFloat(stringgrid2.Cells[9,ii])+formstart.StrToFloat(xrowbuf[10])) ;
                 end else stringgrid2.Cells[10,ii]:=floattostr(formstart.StrToFloat(stringgrid2.Cells[10,ii])+formstart.StrToFloat(xrowbuf[10])) ;
               end;
               xrowbuf:=formstart.DB_Next(xrecbuf);
               continue;
            end;
          end;
          i:=stringgrid2.RowCount;
          stringgrid2.RowCount:=i+1;
          for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';

          if not (thisBeer(xrowbuf[0]))  then begin // Это не Пиво!!!
              xrowbuf:=formstart.DB_Next(xrecbuf);
              continue;
          end;
          stringgrid2.Cells[1,i]:=xrowbuf[0];
          stringgrid2.Cells[2,i]:=xrowbuf[1];
          if (xrowbuf[6] = '')and(xrowbuf[3] = '') then stringgrid2.Cells[0,i]:='*';
          if xrowbuf[3]='' then begin
             stringgrid2.Cells[4,i]:=xrowbuf[5];
             stringgrid2.Cells[5,i]:=xrowbuf[6];
             stringgrid2.Cells[6,i]:=xrowbuf[7];
             stringgrid2.Cells[3,i]:=xrowbuf[9];
             if xrowbuf[9] = xrowbuf[11] then stringgrid2.Cells[10,i]:=xrowbuf[10]
               else stringgrid2.Cells[9,i]:=xrowbuf[10] ;
           end else begin
            stringgrid2.Cells[4,i]:=xrowbuf[2];
            stringgrid2.Cells[5,i]:=xrowbuf[3];
            stringgrid2.Cells[6,i]:=xrowbuf[4];
            stringgrid2.Cells[3,i]:=xrowbuf[8];
            if xrowbuf[8]= xrowbuf[11] then stringgrid2.Cells[8,i]:=xrowbuf[10]
                else stringgrid2.Cells[9,i]:=xrowbuf[10] ;

           end;

          xrowbuf:=formstart.DB_Next(xrecbuf);

         end;


        //i:=1;
        // === Цикл ===== Реализация через кассу
        Query:='SELECT '+
        '`spproduct`.`productvcode`,`spproduct`.`alccode`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
        '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` , FORMAT(SUM(`doccash`.`quantity`*`spproduct`.`capacity` *0.1),3) '
        +' FROM `doccash`,`spproduct` WHERE `doccash`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doccash`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND  `spproduct`.`alccode`=`doccash`.`alccode` AND `doccash`.`alccode`<>"" GROUP BY `spproduct`.`productvcode`,`spproduct`.`import`,`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId`;';
        xrecbuf:=formstart.DB_Query(Query);
        xrowbuf:=formstart.DB_Next(xrecbuf);
     //   stringgrid2.RowCount:=i+1;
        while xrowbuf<>nil do begin
        // ==== оборот =====
         if (thisBeer(xrowbuf[0]))  then begin
           if not flForm12 then begin
             xrowbuf:=formstart.DB_Next(xrecbuf);
             continue;
             end;
         end else begin
           if  flForm12 then begin
             xrowbuf:=formstart.DB_Next(xrecbuf);
             continue;
             end;
         end;
         i:=1;
         imns1:= stringgrid2.Cells[1,i];
         if (xrowbuf[6] = '')and(xrowbuf[3] = '') then  begin
              stringgrid2.Cells[0,i]:='*';
              FormStart.DB_Query('INSERT `stacksender` (`type`,`value`,`sending`) VALUES ("queryap","'+xrowbuf[1]+'","");');
            end;

         if xrowbuf[3]='' then begin
          kodegais:= xrowbuf[9];
          while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[9])) and(i<stringgrid2.RowCount-1) do
            i:=i+1;
            if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[9]))) then
               stringgrid2.Cells[15,i]:=xrowbuf[10]
            else begin
               i:=stringgrid2.RowCount;
               stringgrid2.RowCount:=i+1;
               for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
               stringgrid2.Cells[1,i]:=xrowbuf[0];
               stringgrid2.Cells[2,i]:=xrowbuf[1];
               stringgrid2.Cells[4,i]:=xrowbuf[5];
               stringgrid2.Cells[5,i]:=xrowbuf[6];
               stringgrid2.Cells[6,i]:=xrowbuf[7];
               stringgrid2.Cells[3,i]:=xrowbuf[9];
               stringgrid2.Cells[15,i]:=xrowbuf[10];
            end;
         end else
            begin
             kodegais:= xrowbuf[8];
             while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[8])) and(i<stringgrid2.RowCount-1) do
                i:=i+1;
               if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[8]))) then
                    stringgrid2.Cells[14,i]:=xrowbuf[10]
               else begin
                i:=stringgrid2.RowCount;
                stringgrid2.RowCount:=i+1;
                for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
                stringgrid2.Cells[1,i]:=xrowbuf[0];
                stringgrid2.Cells[2,i]:=xrowbuf[1];
                stringgrid2.Cells[4,i]:=xrowbuf[2];
                stringgrid2.Cells[5,i]:=xrowbuf[3];
                stringgrid2.Cells[6,i]:=xrowbuf[4];
                stringgrid2.Cells[3,i]:=xrowbuf[8];
                stringgrid2.Cells[15,i]:=xrowbuf[10];
               end;
         end;
          xrowbuf:=formstart.DB_Next(xrecbuf);
         end;
        // === Цикл =====
        Query:='SELECT '+
        '`spproduct`.`productvcode`,`spproduct`.`import`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
        '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
        '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
        '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
        '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` , FORMAT(SUM(`doc28`.`count`*`spproduct`.`capacity` *0.1),3)'+
        ' FROM `doc28`,`spproduct`,`docjurnale` WHERE `docjurnale`.`status`="+++" AND `docjurnale`.`numdoc`=`doc28`.`numdoc` AND `docjurnale`.`datedoc`=`doc28`.`datedoc` AND `doc28`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc28`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" '+
        ' AND  `spproduct`.`alccode`=`doc28`.`alccode` AND `doc28`.`alccode`<>"" '+
        ' GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`,`spproduct`.`import`,`spproduct`.`iClientRegId`;';
        xrecbuf:=formstart.DB_Query(Query);
        xrowbuf:=formstart.DB_Next(xrecbuf);
     //   stringgrid2.RowCount:=i+1;
        while xrowbuf<>nil do begin
        // ==== оборот =====
         if (thisBeer(xrowbuf[0]))  then
         begin
           if not flForm12 then begin
             xrowbuf:=formstart.DB_Next(xrecbuf);
             continue;
             end;
         end else begin
           if  flForm12 then begin
             xrowbuf:=formstart.DB_Next(xrecbuf);
             continue;
             end;
         end;
         i:=1;
         imns1:= stringgrid2.Cells[1,i]; // Импорт +

         if xrowbuf[3]='' then begin
          kodegais:= xrowbuf[9];
          while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[9])) and(i<stringgrid2.RowCount-1) do
             i:=i+1;
          if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[9]))) then
               stringgrid2.Cells[16,i]:=xrowbuf[10]
               else
           begin
           i:=stringgrid2.RowCount;
           stringgrid2.RowCount:=i+1;
           for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
           stringgrid2.Cells[1,i]:=xrowbuf[0];
           stringgrid2.Cells[2,i]:=xrowbuf[1];
           stringgrid2.Cells[4,i]:=xrowbuf[5];
           stringgrid2.Cells[5,i]:=xrowbuf[6];
           stringgrid2.Cells[6,i]:=xrowbuf[7];
           stringgrid2.Cells[3,i]:=xrowbuf[9];
           stringgrid2.Cells[15,i]:=xrowbuf[10];
          end;
         end else
            begin
             kodegais:= xrowbuf[8];
             while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[8])) and(i<stringgrid2.RowCount-1) do
                i:=i+1;
             if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[8]))) then
                  stringgrid2.Cells[15,i]:=xrowbuf[10]
             else begin

              i:=stringgrid2.RowCount;
              stringgrid2.RowCount:=i+1;
              for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
              stringgrid2.Cells[1,i]:=xrowbuf[0];
              stringgrid2.Cells[2,i]:=xrowbuf[1];
              stringgrid2.Cells[4,i]:=xrowbuf[2];
              stringgrid2.Cells[5,i]:=xrowbuf[3];
              stringgrid2.Cells[6,i]:=xrowbuf[4];
              stringgrid2.Cells[3,i]:=xrowbuf[8];
              stringgrid2.Cells[15,i]:=xrowbuf[10];
             end;
         end;
          xrowbuf:=formstart.DB_Next(xrecbuf);
         end;
        // === Цикл =====
         Query:='SELECT '+
         '`spproduct`.`productvcode`,`spproduct`.`import`,'+
         '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
         '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
         '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
         '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
         '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
         '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
         '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` , FORMAT(SUM(`doc26`.`count`*`spproduct`.`capacity` *0.1),3), `spproduct`.`AlcCode`'
         +' FROM `doc26`,`spproduct` WHERE `doc26`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc26`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND  `spproduct`.`alccode`=`doc26`.`alccode` AND `doc26`.`alccode`<>"" GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId`;';
         xrecbuf:=formstart.DB_Query(Query);
         xrowbuf:=formstart.DB_Next(xrecbuf);
      //   stringgrid2.RowCount:=i+1;
         while xrowbuf<>nil do begin
         // ==== оборот =====
          i:=1;
          imns1:= stringgrid2.Cells[1,i];
          fAlcCode := xrowbuf[11];
          if xrowbuf[3]='' then begin
           kodegais:= xrowbuf[9];
           while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[9])) and(i<stringgrid2.RowCount-1) do
              i:=i+1;
           if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[9]))) then
                stringgrid2.Cells[13,i]:=xrowbuf[10]
                else
            begin
            i:=stringgrid2.RowCount;
            stringgrid2.RowCount:=i+1;
            for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
            stringgrid2.Cells[1,i]:=xrowbuf[0];
            stringgrid2.Cells[2,i]:=xrowbuf[1];
            stringgrid2.Cells[4,i]:=xrowbuf[5];
            stringgrid2.Cells[5,i]:=xrowbuf[6];
            stringgrid2.Cells[6,i]:=xrowbuf[7];
            stringgrid2.Cells[3,i]:=xrowbuf[9];
            stringgrid2.Cells[13,i]:=xrowbuf[10];
           end;
          end else
             begin
              kodegais:= xrowbuf[8];
              while ((xrowbuf[0]<>stringgrid2.Cells[1,i] )OR(stringgrid2.Cells[3,i]<>xrowbuf[8])) and(i<stringgrid2.RowCount-1) do
                 i:=i+1;
              if  ((xrowbuf[0]=stringgrid2.Cells[1,i] )AND((stringgrid2.Cells[3,i]=xrowbuf[8]))) then
                   stringgrid2.Cells[13,i]:=xrowbuf[10]
              else begin

               i:=stringgrid2.RowCount;
               stringgrid2.RowCount:=i+1;
               for ii:=7 to 19 do stringgrid2.Cells[ii,i]:='0';
               stringgrid2.Cells[1,i]:=xrowbuf[0];
               stringgrid2.Cells[2,i]:=xrowbuf[1];
               stringgrid2.Cells[4,i]:=xrowbuf[2];
               stringgrid2.Cells[5,i]:=xrowbuf[3];
               stringgrid2.Cells[6,i]:=xrowbuf[4];
               stringgrid2.Cells[3,i]:=xrowbuf[8];
               stringgrid2.Cells[13,i]:=xrowbuf[10];
              end;
          end;
           xrowbuf:=formstart.DB_Next(xrecbuf);
          end;
end;

procedure TFormExportForm12.BitBtn3Click(Sender: TObject);
begin

  frReport1.LoadFromFile('report\form12-1.lrf');
  flselreprow:=1;
  frReport1.ShowReport;
end;

procedure TFormExportForm12.BitBtn4Click(Sender: TObject);
begin
  SaveToXLS;
end;

procedure TFormExportForm12.bbControleClick(Sender: TObject);
var
  i:integer;
  qr1,
  qr2,
  qr3,
  qr4:Double;
begin
  self.SortByIMNS();
  // Расчет таблицы
  for i:=1 to stringgrid2.RowCount-1 do  begin
    qr1:=0;
    qr2:=FormStart.StrToFloat( stringgrid2.cells[7,i]); // Остаток на начало периода
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[8,i]); // Приход от производителя
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[9,i]); // Приход от оптового
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[10,i]); // Приход от импортера
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[11,i]); // Перемещение между подразделениями
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[12,i]); // Приход от производителя
    qr1:=qr1+FormStart.StrToFloat( stringgrid2.cells[13,i]); // Приход поступления
    stringgrid2.cells[14,i]:=FormatFloat('0.00000',qr1); // Приход поступления
    qr3 := FormStart.StrToFloat( stringgrid2.cells[15,i]);
    qr3 := qr3 + FormStart.StrToFloat( stringgrid2.cells[16,i]);
    qr3 := qr3 + FormStart.StrToFloat( stringgrid2.cells[17,i]);
    stringgrid2.cells[18,i]:=FormatFloat('0.00000',qr3);
    qr4:=qr2 + qr1 - qr3;
    stringgrid2.cells[19,i]:=FormatFloat('0.00000',qr4);
  end;
end;

procedure TFormExportForm12.BitBtn5Click(Sender: TObject);
var
  r:TPoint;
begin
    r:=BitBtn5.ClientOrigin;
    ppImportForms12_8.PopUp(r.x,r.y+BitBtn5.Height);

end;

procedure TFormExportForm12.BitBtn7Click(Sender: TObject);
begin
    formfilter.ShowModal;
    flStartDate:=formfilter.StartDate;
    flendDate:=formfilter.EndDate;
    self.Caption:='Форма 8 [ '+FormatDateTime('DD.MM.YYYY',flStartDate)+' - '+FormatDateTime('DD.MM.YYYY',flEndDate)+']';
end;

procedure TFormExportForm12.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 self.fluiddoc := '';
  CloseAction:=cahide;
end;

procedure TFormExportForm12.FormShow(Sender: TObject);
begin
  self.Caption:='Форма 8 [ '+FormatDateTime('DD.MM.YYYY',flStartDate)+' - '+FormatDateTime('DD.MM.YYYY',flEndDate)+']';
  if (self.flNumDoc = '') and (self.fluiddoc = '') then
     self.flNumDoc:= formStart.GetConstant('numdocalcreport8');
  if (self.flNumDoc = '') then
     self.flNumDoc :='1';
end;

procedure TFormExportForm12.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
    ParValue:='';
    if ParName='num' then begin
       ParValue:=inttostr(flselreprow);
    end;
    if ParName='nameimns' then
        ParValue:='';
    if ParName='imns' then
        ParValue:=StringGrid2.Cells[1,flselreprow];
   if ParName='imnscode' then
        ParValue:=StringGrid2.Cells[1,flselreprow];
   if ParName='k3' then
        ParValue:=StringGrid2.Cells[4,flselreprow];
   if ParName='k4' then
        ParValue:=StringGrid2.Cells[5,flselreprow];
   if ParName='k5' then
        ParValue:=StringGrid2.Cells[6,flselreprow];
   if ParName='k6' then
        ParValue:=StringGrid2.Cells[7,flselreprow];
   if ParName='k7' then
        ParValue:=StringGrid2.Cells[8,flselreprow];
   if ParName='k8' then
        ParValue:=StringGrid2.Cells[9,flselreprow];
   if ParName='k9' then
        ParValue:=StringGrid2.Cells[10,flselreprow];
   if ParName='k10' then
        ParValue:=format('%0.3f',[
         formstart.StrToFloat( StringGrid2.Cells[8,flselreprow])
         +formstart.StrToFloat(StringGrid2.Cells[9,flselreprow])
         +formstart.StrToFloat(StringGrid2.Cells[10,flselreprow])]);
   if ParName='k11' then
        ParValue:=StringGrid2.Cells[11,flselreprow];
   if ParName='k12' then
        ParValue:=StringGrid2.Cells[12,flselreprow];
   if ParName='k13' then
   ParValue:=format('%0.3f',[
    formstart.StrToFloat( StringGrid2.Cells[8,flselreprow])
    +formstart.StrToFloat(StringGrid2.Cells[9,flselreprow])
    +formstart.StrToFloat(StringGrid2.Cells[10,flselreprow])]);

   if ParName='k14' then
        ParValue:=StringGrid2.Cells[14,flselreprow];
   if ParName='k15' then
        ParValue:=StringGrid2.Cells[15,flselreprow];
   if ParName='k16' then
        ParValue:=StringGrid2.Cells[16,flselreprow];
   if ParName='k19' then
        ParValue:=StringGrid2.Cells[17,flselreprow];;
   if ParName='k20' then
        ParValue:=StringGrid2.Cells[18,flselreprow];
end;

procedure TFormExportForm12.frUserDataset1CheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  if flselreprow<stringgrid2.RowCount then
     eof:=false
    else
     eof:=true;
end;

procedure TFormExportForm12.frUserDataset1First(Sender: TObject);
begin
  flselreprow:=flselreprow-1;
end;

procedure TFormExportForm12.frUserDataset1Next(Sender: TObject);
begin
  flselreprow:=flselreprow+1;
end;

{ Загружаем Форму 12
}
procedure TFormExportForm12.MenuItem2Click(Sender: TObject);
var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  iii,
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  sline:TStringList;
  curimns,quartperiod,
  yearperiod:string;
  namenode:string;
  ListClient:array[1..300] of t_egais_producer;

begin
  if odForm12.Execute then begin

   // Обходим ограничение по кодировке
   sline:= TStringList.create();
   sline.LoadFromFile(odForm12.FileName);
   sline.Strings[0]:='<?xml version="1.0" encoding="utf-8"?>';
   sline.Text := CP1251ToUTF8(sline.Text);
   S:= TStringStream.Create(sline.Text);
   Try
      S.Position:=0;
      XML:=Nil;
      xmlread.ReadXMLFile(XML,S); // XML документ целиком
   Finally
      S.Free;
   end;
   StringGrid1.RowCount:=1;
   StringGrid2.RowCount:=1;
   StringGrid3.RowCount:=1;
   StringGrid4.RowCount:=1;
   Child :=XML.DocumentElement.FirstChild;

   while Assigned(Child) do begin
     formstart.fshowmessage( Child.NodeName);
     namenode:= Child.NodeName;
     if namenode = 'ФормаОтч' then begin

       quartperiod := Child.Attributes.Item[1].NodeValue; // type form
       yearperiod := Child.Attributes.Item[2].NodeValue;
       formstart.fshowmessage(quartperiod);
     END;
     if namenode = 'Справочники' then begin
      Child1 := Child.FirstChild;
      while Assigned(Child1) do begin
        namenode:= Child1.NodeName;
        if namenode = 'ПроизводителиИмпортеры' then begin
          i:=strtoint(Child1.Attributes.Item[0].NodeValue);
          ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
          ListClient[i].importer:=true;
          ListClient[i].production:=true;
          Child2 := Child1.FirstChild;
          while Assigned(Child2) do begin
            namenode:= Child2.NodeName;
            if namenode = 'ЮЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
            end;
            if namenode = 'ФЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:='';
            end;

            Child2 := Child2.NextSibling;
          end;
          ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
          ii:=StringGrid4.RowCount;
          StringGrid4.RowCount:=ii+1;
          StringGrid4.Cells[1,ii]:=ListClient[i].egais_id;
          StringGrid4.Cells[2,ii]:=ListClient[i].firm_name;
          StringGrid4.Cells[3,ii]:=ListClient[i].tax_id;
          StringGrid4.Cells[4,ii]:=ListClient[i].deport_id;
        end;
        if namenode = 'Поставщики' then begin
         i:=strtoint(Child1.Attributes.Item[0].NodeValue);
         ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
         ListClient[i].importer:=false;
         ListClient[i].production:=false;
         ListClient[i].production:=true;
         Child2 := Child1.FirstChild;
         while Assigned(Child2) do begin
           namenode:= Child2.NodeName;
           if namenode = 'ЮЛ' then begin
             ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
             ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
           end;
           if namenode = 'ФЛ' then begin
             ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
             ListClient[i].deport_id:='';
           end;
           Child2 := Child2.NextSibling;
         end;
         ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
         ii:=StringGrid3.RowCount;
         StringGrid3.RowCount:=ii+1;
         StringGrid3.Cells[1,ii]:=ListClient[i].egais_id;
         StringGrid3.Cells[2,ii]:=ListClient[i].firm_name;
         StringGrid3.Cells[3,ii]:=ListClient[i].tax_id;
         StringGrid3.Cells[4,ii]:=ListClient[i].deport_id;
        end;
        Child1 := Child1.NextSibling;
      end;

     END;
     if namenode = 'Документ' then begin
       Child1 := Child.FirstChild;
       while Assigned(Child1) do begin
         namenode:= Child1.NodeName;
         if namenode = 'ОбъемОборота' then begin
           Child2 := Child1.FirstChild;
           while Assigned(Child2) do begin
             namenode:= Child2.NodeName;
             if namenode = 'Оборот' then begin
               curimns := Child2.Attributes.Item[1].NodeValue;
               Child3 := Child2.FirstChild;
               while Assigned(Child3) do begin
                 namenode:= Child3.NodeName;
                 if namenode = 'СведПроизвИмпорт' then begin
                   i:=strtoint(Child3.Attributes.Item[1].NodeValue);
                   Child4 := Child3.FirstChild;
                   while Assigned(Child4) do begin
                     namenode:= Child4.NodeName;
                     if namenode = 'Движение' then begin
                       //  ПN="1"
                       ii:=StringGrid2.RowCount;
                       StringGrid2.RowCount:=ii+1;
                       StringGrid2.Cells[1,ii]:=curimns;
                       StringGrid2.Cells[3,ii]:=ListClient[i].egais_id;
                       StringGrid2.Cells[4,ii]:=ListClient[i].firm_name;
                       StringGrid2.Cells[5,ii]:=ListClient[i].tax_id;
                       StringGrid2.Cells[6,ii]:=ListClient[i].deport_id;
                       StringGrid2.Cells[7,ii]:= Child4.Attributes.Item[1].NodeValue;  //  П100000000006="0.65000"
                       StringGrid2.Cells[8,ii]:= Child4.Attributes.Item[2].NodeValue;  //  П100000000007="0.00000"
                       StringGrid2.Cells[9,ii]:= Child4.Attributes.Item[3].NodeValue;  //  П100000000008="6.36800"
                       StringGrid2.Cells[10,ii]:= Child4.Attributes.Item[4].NodeValue; //  П100000000009="0.00000"
                       //  П100000000010="6.36800" (итого поступление)
                       StringGrid2.Cells[12,ii]:= Child4.Attributes.Item[6].NodeValue; //  П100000000011="0.00000" (Возврат)
                       StringGrid2.Cells[13,ii]:= Child4.Attributes.Item[7].NodeValue;//  П100000000012="0.00000" (Прочее)
                       StringGrid2.Cells[14,ii]:= Child4.Attributes.Item[8].NodeValue; //  П100000000013="6.36800"
                       StringGrid2.Cells[15,ii]:= Child4.Attributes.Item[9].NodeValue; //  П100000000014="7.01800"
                       StringGrid2.Cells[16,ii]:= Child4.Attributes.Item[10].NodeValue; //  П100000000015="0.00000"
                       StringGrid2.Cells[17,ii]:= Child4.Attributes.Item[11].NodeValue; //  П100000000016="0.00000"
                       StringGrid2.Cells[18,ii]:= Child4.Attributes.Item[12].NodeValue; //  П100000000017="7.01800"
                       StringGrid2.Cells[19,ii]:= Child4.Attributes.Item[13].NodeValue; //  П100000000018="0.00000"
                     end;
                     if namenode = 'Поставщик' then begin
                       //  ПN="1"
                       iii:=strtoint(Child4.Attributes.Item[1].NodeValue); // Поставка
                       Child5 := Child4.FirstChild;
                       while Assigned(Child5) do begin
                          ii:=StringGrid1.RowCount;
                          StringGrid1.RowCount:=ii+1;
                          StringGrid1.Cells[1,ii]:=curimns;
                          StringGrid1.Cells[2,ii]:=ListClient[i].egais_id;
                          StringGrid1.Cells[3,ii]:=ListClient[i].firm_name;
                          StringGrid1.Cells[4,ii]:=ListClient[i].tax_id;
                          StringGrid1.Cells[5,ii]:=ListClient[i].deport_id;
                          StringGrid1.Cells[6,ii]:=ListClient[iii].egais_id;
                          StringGrid1.Cells[7,ii]:=ListClient[iii].firm_name;
                          StringGrid1.Cells[8,ii]:=ListClient[iii].tax_id;
                          StringGrid1.Cells[9,ii]:=ListClient[iii].deport_id;
                          StringGrid1.Cells[10,ii]:= Child5.Attributes.Item[1].NodeValue;
                          StringGrid1.Cells[11,ii]:= Child5.Attributes.Item[0].NodeValue;
                          StringGrid1.Cells[12,ii]:= Child5.Attributes.Item[3].NodeValue;
                          Child5 := Child5.NextSibling;
                       end;
                     end;
                     Child4 := Child4.NextSibling;
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
     End;
     Child := Child.NextSibling;
   end;
   freeandnil(sline);
  end;
  self.Caption:='Форма 8 [ '+FormatDateTime('DD.MM.YYYY',flStartDate)+' - '+FormatDateTime('DD.MM.YYYY',flEndDate)+']';
end;

procedure TFormExportForm12.MenuItem3Click(Sender: TObject);

var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  iii,
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  sline:TStringList;
  curimns,quartperiod,
  yearperiod:string;
  namenode:string;
  ListClient:array[1..300] of t_egais_producer;

begin
  if odForm12.Execute then begin
   for i:=1 to StringGrid1.RowCount-1 do  StringGrid1.Cells[14,i]:='';
   // Обходим ограничение по кодировке
   sline:= TStringList.create();
   sline.LoadFromFile(odForm12.FileName);
   sline.Strings[0]:='<?xml version="1.0" encoding="utf-8"?>';
   sline.Text := CP1251ToUTF8(sline.Text);
   S:= TStringStream.Create(sline.Text);
   Try
      S.Position:=0;
      XML:=Nil;
      xmlread.ReadXMLFile(XML,S); // XML документ целиком
   Finally
      S.Free;
   end;
   Child :=XML.DocumentElement.FirstChild;

   while Assigned(Child) do begin
     formstart.fshowmessage( Child.NodeName);
     namenode:= Child.NodeName;
     if namenode = 'ФормаОтч' then begin

       quartperiod := Child.Attributes.Item[1].NodeValue; // type form
       yearperiod := Child.Attributes.Item[2].NodeValue;
       formstart.fshowmessage(quartperiod);
     END;
     if namenode = 'Справочники' then begin
      Child1 := Child.FirstChild;
      while Assigned(Child1) do begin
        namenode:= Child1.NodeName;
        if namenode = 'ПроизводителиИмпортеры' then begin
          i:=strtoint(Child1.Attributes.Item[0].NodeValue);
          ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
          ListClient[i].importer:=true;
          ListClient[i].production:=true;
          Child2 := Child1.FirstChild;
          while Assigned(Child2) do begin
            namenode:= Child2.NodeName;
            if namenode = 'ЮЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
            end;
            if namenode = 'ФЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:='';
            end;

            Child2 := Child2.NextSibling;
          end;
          ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
          ii:=1;
          while ((StringGrid4.Cells[1,ii]<>ListClient[i].egais_id) and
                 (ii<StringGrid4.RowCount-1)) do ii:=ii+1;
          if StringGrid4.Cells[1,ii]<>ListClient[i].egais_id then begin
            ii:=StringGrid4.RowCount;
            StringGrid4.RowCount:=ii+1;
            StringGrid4.Cells[1,ii]:=ListClient[i].egais_id;
            StringGrid4.Cells[2,ii]:=ListClient[i].firm_name;
            StringGrid4.Cells[3,ii]:=ListClient[i].tax_id;
            StringGrid4.Cells[4,ii]:=ListClient[i].deport_id;
          end;
        end;
        if namenode = 'Поставщики' then begin
         i:=strtoint(Child1.Attributes.Item[0].NodeValue);
         ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
         ListClient[i].importer:=false;
         ListClient[i].production:=false;
         ListClient[i].production:=true;
         Child2 := Child1.FirstChild;
         while Assigned(Child2) do begin
           namenode:= Child2.NodeName;
           if namenode = 'ЮЛ' then begin
             ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
             ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
           end;
           if namenode = 'ФЛ' then begin
             ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
             ListClient[i].deport_id:='';
           end;
           Child2 := Child2.NextSibling;
         end;
         ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
         ii:=1;
         while ((StringGrid3.Cells[1,ii]<>ListClient[i].egais_id) and
                (ii<StringGrid3.RowCount-1)) do ii:=ii+1;
         if StringGrid3.Cells[1,ii]<>ListClient[i].egais_id then begin
           ii:=StringGrid3.RowCount;
           StringGrid3.RowCount:=ii+1;
           StringGrid3.Cells[1,ii]:=ListClient[i].egais_id;
           StringGrid3.Cells[2,ii]:=ListClient[i].firm_name;
           StringGrid3.Cells[3,ii]:=ListClient[i].tax_id;
           StringGrid3.Cells[4,ii]:=ListClient[i].deport_id;
         end;
        end;
        Child1 := Child1.NextSibling;
      end;

     END;
     if namenode = 'Документ' then begin
       Child1 := Child.FirstChild;
       while Assigned(Child1) do begin
         namenode:= Child1.NodeName;
         if namenode = 'ОбъемОборота' then begin
           Child2 := Child1.FirstChild;
           while Assigned(Child2) do begin
             namenode:= Child2.NodeName;
             if namenode = 'Оборот' then begin
               curimns := Child2.Attributes.Item[1].NodeValue;
               Child3 := Child2.FirstChild;
               while Assigned(Child3) do begin
                 namenode:= Child3.NodeName;
                 if namenode = 'СведПроизвИмпорт' then begin
                   i:=strtoint(Child3.Attributes.Item[1].NodeValue);
                   Child4 := Child3.FirstChild;
                   while Assigned(Child4) do begin
                     namenode:= Child4.NodeName;
                     if namenode = 'Движение' then begin
                       //  ПN="1"
                      if  strtoFloat(Child4.Attributes.Item[13].NodeValue) <> 0 then begin
                        ii:=1;
                        while (((StringGrid2.Cells[1,ii]<>curimns)
                          or(StringGrid2.Cells[3,ii]<>ListClient[i].egais_id))
                          and (ii<StringGrid2.RowCount-1)) do ii:=ii+1;
                        if ((StringGrid2.Cells[1,ii]<>curimns )
                           or(StringGrid2.Cells[3,ii]<>ListClient[i].egais_id)) then begin
                           ii:=StringGrid2.RowCount;
                           StringGrid2.RowCount:=ii+1;
                           for iii:=7 to 19 do stringgrid2.Cells[iii,ii]:='0';
                           StringGrid2.Cells[1,ii]:=curimns;
                           StringGrid2.Cells[3,ii]:=ListClient[i].egais_id;
                           StringGrid2.Cells[4,ii]:=ListClient[i].firm_name;
                           StringGrid2.Cells[5,ii]:=ListClient[i].tax_id;
                           StringGrid2.Cells[6,ii]:=ListClient[i].deport_id;
                         end;
                         StringGrid2.Cells[7,ii]:= Child4.Attributes.Item[13].NodeValue; //  П100000000018="0.00000"

                      end;
                     end;
                     Child4 := Child4.NextSibling;
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
     End;
     Child := Child.NextSibling;
   end;
   freeandnil(sline);
  end;
  self.Caption:='Форма 8 [ '+FormatDateTime('DD.MM.YYYY',flStartDate)+' - '+FormatDateTime('DD.MM.YYYY',flEndDate)+']';

end;

procedure TFormExportForm12.MenuItem4Click(Sender: TObject);
var
  ii,i:integer;
  value:string;
begin
  for i:=StringGrid2.Row+1 to StringGrid2.RowCount-1 do
    for ii:=1 to 19 do begin
//            value:= stringGrid2.Cells[ii,i-1];
            stringGrid2.Cells[ii,i-1]:= stringGrid2.Cells[ii,i];
//            stringGrid2.Cells[ii,i]:=value;
         end;
  StringGrid2.RowCount:=StringGrid2.RowCount-1;
end;

procedure TFormExportForm12.MenuItem5Click(Sender: TObject);

var
  XML: TXMLDocument;
  Child4,Child3,CHild5,
  Child2, Child1, Child: TDOMNode;
  iii,
  ii,i:Integer;
  S1:String;
  S : TStringStream;
  sline:TStringList;
  curimns,quartperiod,
  yearperiod:string;
  namenode:string;
  ListClient:array[1..300] of t_egais_producer;

begin
  if odForm12.Execute then begin
   for i:=1 to StringGrid1.RowCount-1 do  StringGrid1.Cells[14,i]:='';
   // Обходим ограничение по кодировке
   sline:= TStringList.create();
   sline.LoadFromFile(odForm12.FileName);
   sline.Strings[0]:='<?xml version="1.0" encoding="utf-8"?>';
   sline.Text := CP1251ToUTF8(sline.Text);
   S:= TStringStream.Create(sline.Text);
   Try
      S.Position:=0;
      XML:=Nil;
      xmlread.ReadXMLFile(XML,S); // XML документ целиком
   Finally
      S.Free;
   end;
   Child :=XML.DocumentElement.FirstChild;

   while Assigned(Child) do begin
     formstart.fshowmessage( Child.NodeName);
     namenode:= Child.NodeName;
     if namenode = 'ФормаОтч' then begin

       quartperiod := Child.Attributes.Item[1].NodeValue; // type form
       yearperiod := Child.Attributes.Item[2].NodeValue;
       formstart.fshowmessage(quartperiod);
     END;
     if namenode = 'Справочники' then begin
      Child1 := Child.FirstChild;
      while Assigned(Child1) do begin
        namenode:= Child1.NodeName;
        if namenode = 'ПроизводителиИмпортеры' then begin
          i:=strtoint(Child1.Attributes.Item[0].NodeValue);
          ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
          ListClient[i].importer:=true;
          ListClient[i].production:=true;
          Child2 := Child1.FirstChild;
          while Assigned(Child2) do begin
            namenode:= Child2.NodeName;
            if namenode = 'ЮЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
            end;
            if namenode = 'ФЛ' then begin
              ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
              ListClient[i].deport_id:='';
            end;

            Child2 := Child2.NextSibling;
          end;
          ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
          ii:=1;
          while ((StringGrid4.Cells[1,ii]<>ListClient[i].egais_id) and
                 (ii<StringGrid4.RowCount-1)) do ii:=ii+1;
          if StringGrid4.Cells[1,ii]<>ListClient[i].egais_id then begin
            ii:=StringGrid4.RowCount;
            StringGrid4.RowCount:=ii+1;
            StringGrid4.Cells[1,ii]:=ListClient[i].egais_id;
            StringGrid4.Cells[2,ii]:=ListClient[i].firm_name;
            StringGrid4.Cells[3,ii]:=ListClient[i].tax_id;
            StringGrid4.Cells[4,ii]:=ListClient[i].deport_id;
          end;
        end;
        // ===== Поставщик ========
        //if namenode = 'Поставщики' then begin
        // i:=strtoint(Child1.Attributes.Item[0].NodeValue);
        // ListClient[i].firm_name:=Child1.Attributes.Item[1].NodeValue;
        // ListClient[i].importer:=false;
        // ListClient[i].production:=false;
         //ListClient[i].production:=true;
        // Child2 := Child1.FirstChild;
        // while Assigned(Child2) do begin
        //   namenode:= Child2.NodeName;
        //   if namenode = 'ЮЛ' then begin
        //     ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
        //     ListClient[i].deport_id:=Child2.Attributes.Item[1].NodeValue;
        //   end;
        //   if namenode = 'ФЛ' then begin
        //     ListClient[i].tax_id:=Child2.Attributes.Item[0].NodeValue;
        //     ListClient[i].deport_id:='';
        //   end;
        //   Child2 := Child2.NextSibling;
        // end;
        // ListClient[i].egais_id:=formstart.get_producer_id(ListClient[i].tax_id,ListClient[i].deport_id).egais_id;
        // ii:=1;
        // while ((StringGrid3.Cells[1,ii]<>ListClient[i].egais_id) and
        //        (ii<StringGrid3.RowCount-1)) do ii:=ii+1;
        // if StringGrid3.Cells[1,ii]<>ListClient[i].egais_id then begin
        //   ii:=StringGrid3.RowCount;
        //   StringGrid3.RowCount:=ii+1;
        //   StringGrid3.Cells[1,ii]:=ListClient[i].egais_id;
        //   StringGrid3.Cells[2,ii]:=ListClient[i].firm_name;
        //   StringGrid3.Cells[3,ii]:=ListClient[i].tax_id;
        //   StringGrid3.Cells[4,ii]:=ListClient[i].deport_id;
        // end;
        //end;
        // ======= Поставщик =========
        Child1 := Child1.NextSibling;
      end;

     END;
     if namenode = 'Документ' then begin
       Child1 := Child.FirstChild;
       while Assigned(Child1) do begin
         namenode:= Child1.NodeName;
         if namenode = 'ОбъемОборота' then begin
           Child2 := Child1.FirstChild;
           while Assigned(Child2) do begin
             namenode:= Child2.NodeName;
             if namenode = 'Оборот' then begin
               curimns := Child2.Attributes.Item[1].NodeValue;
               Child3 := Child2.FirstChild;
               while Assigned(Child3) do begin
                 namenode:= Child3.NodeName;
                 //formstart.fshowmessage( namenode);
                 if namenode = 'СведПроизвИмпортер' then begin
                   i:=strtoint(Child3.Attributes.Item[1].NodeValue);
                   formlogging.AddMessage( ListClient[i].egais_id);
                   Child4 := Child3.FirstChild;
                   while Assigned(Child4) do begin
                     namenode:= Child4.NodeName;
                     //formstart.fshowmessage( namenode);
                     if namenode = 'Движение' then begin
                       //  ПN="1"
                      if  strtoFloat(Child4.Attributes.Item[15].NodeValue) <> 0 then begin
                        ii:=1;
                        while (((StringGrid2.Cells[1,ii]<>curimns)
                          or(StringGrid2.Cells[3,ii]<>ListClient[i].egais_id))
                          and (ii<StringGrid2.RowCount-1)) do ii:=ii+1;
                         if ((StringGrid2.Cells[1,ii]<>curimns )
                           or(StringGrid2.Cells[3,ii]<>ListClient[i].egais_id)) then begin
                           ii:=StringGrid2.RowCount;
                           StringGrid2.RowCount:=ii+1;
                           for iii:=7 to 19 do stringgrid2.Cells[iii,ii]:='0';
                           StringGrid2.Cells[1,ii]:=curimns;
                           StringGrid2.Cells[3,ii]:=ListClient[i].egais_id;
                           StringGrid2.Cells[4,ii]:=ListClient[i].firm_name;
                           StringGrid2.Cells[5,ii]:=ListClient[i].tax_id;
                           StringGrid2.Cells[6,ii]:=ListClient[i].deport_id;
                         end;
                         StringGrid2.Cells[7,ii]:= Child4.Attributes.Item[15].NodeValue; //  П100000000018="0.00000"

                      end
                      //else showmessage(Child4.Attributes.Item[15].NodeName);

                     end;
                     Child4 := Child4.NextSibling;
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
     End;
     Child := Child.NextSibling;
   end;
   freeandnil(sline);
  end;
  self.Caption:='Форма 8 [ '+FormatDateTime('DD.MM.YYYY',flStartDate)+' - '+FormatDateTime('DD.MM.YYYY',flEndDate)+']';


end;

procedure TFormExportForm12.StringGrid2DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin
    if  ((Sender as TStringGrid).Name = 'StringGrid2') AND (StringGrid2.Cells[0,aRow] = '*') then begin

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


procedure TFormExportForm12.SaveToXLS();
var
  i:integer;
  curimns:string;
  summ1:real;
begin
  FormExtReport.InitBook;
  FormExtReport.setColWidth(0,2);
  FormExtReport.setColWidth(1,7);
  FormExtReport.setColWidth(2,15);
  FormExtReport.setColWidth(3,10);
  FormExtReport.setColWidth(4,15);
  FormExtReport.setColWidth(5,15);
  FormExtReport.setColWidth(6,15);
  FormExtReport.setColWidth(7,15);
  FormExtReport.setColWidth(8,15);
  FormExtReport.setColWidth(9,15);
  FormExtReport.setColWidth(10,15);
  FormExtReport.setColWidth(11,15);
  FormExtReport.setColWidth(12,15);
  FormExtReport.setColWidth(13,15);
  FormExtReport.setColWidth(14,15);
  FormExtReport.setColWidth(15,15);
  FormExtReport.setColWidth(16,15);
  FormExtReport.setColWidth(17,15);
  FormExtReport.setColWidth(18,15);
  FormExtReport.setColWidth(19,15);
  curimns:='';
  summ1:=0;

  FormExtReport.mergedCells(FormExtReport.flCurrentRow,1,FormExtReport.flCurrentRow,13);
  FormExtReport.SetValueRowBold(1,'Декларация об объемах розничной продажи  алкогольной  и спиртосодержащей продукции');
  FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,1,FormExtReport.flCurrentRow,13);
  FormExtReport.SetValueRowBold(1,'С '+FormatDateTime('DD.MM.YYYY',flStartDate)+' по '+FormatDateTime('DD.MM.YYYY',flEndDate));
  FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;

  //FormExtReport.flCurrentRow:=0;
  FormExtReport.SetValueRowBold(1,'п/п');
  FormExtReport.SetValueRowBold(2,'Вид продукции ');
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,1,FormExtReport.flCurrentRow+1,1);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,2,FormExtReport.flCurrentRow+1,2);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,3,FormExtReport.flCurrentRow+1,3);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,4,FormExtReport.flCurrentRow,6);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,7,FormExtReport.flCurrentRow,9);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,10,FormExtReport.flCurrentRow+1,10);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,11,FormExtReport.flCurrentRow+1,11);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,12,FormExtReport.flCurrentRow+1,12);
  FormExtReport.mergedCells(FormExtReport.flCurrentRow,13,FormExtReport.flCurrentRow+1,13);
  FormExtReport.SetValueRowBold(3,'Код вида продукции');
  FormExtReport.SetValueRowBold(7,'Сведения о поставщике');
  FormExtReport.SetValueRowBold(4,'Сведения о производителе\импортере');
  FormExtReport.SetValueRowBold(10,'Дата поставки');
  FormExtReport.SetValueRowBold(11,'Номер ТТН');
  FormExtReport.SetValueRowBold(13,'Объем поставленной продукции');
  FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;

  FormExtReport.SetValueRow(4,'Наименование');
  FormExtReport.SetValueRow(5,'ИНН');
  FormExtReport.SetValueRow(6,'КПП');
  FormExtReport.SetValueRow(7,'Наменование');
  FormExtReport.SetValueRow(8,'ИНН');
  FormExtReport.SetValueRow(9,'КПП');

  FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;
  for i:=1 to  stringgrid1.RowCount-1 do begin
    if curimns = '' then
      curimns:= stringgrid1.Cells[1,i];
    if curimns<>stringgrid1.Cells[1,i] then begin
       FormExtReport.SetValueRowBold(3,curimns);
       FormExtReport.SetValueRowBold(2,'Итого');
       FormExtReport.SetValueRowBold(13,format('%8.5f',[summ1]));
       summ1:=0;
       FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;
       curimns:= stringgrid1.Cells[1,i];
    end;
    summ1:=summ1+formstart.StrToFloat(stringgrid1.Cells[12,i]);
    FormExtReport.SetValueRow(1,inttostr(i));
    FormExtReport.SetValueRow(2,'_');
    FormExtReport.SetValueRow(3,stringgrid1.Cells[1,i]);
    FormExtReport.SetValueRow(4,stringgrid1.Cells[3,i]);
    FormExtReport.SetValueRow(5,stringgrid1.Cells[4,i]);
    FormExtReport.SetValueRow(6,stringgrid1.Cells[5,i]);
    FormExtReport.SetValueRow(7,stringgrid1.Cells[7,i]);
    FormExtReport.SetValueRow(8,stringgrid1.Cells[8,i]);
    FormExtReport.SetValueRow(9,stringgrid1.Cells[9,i]);
    FormExtReport.SetValueRow(10,stringgrid1.Cells[10,i]);
    FormExtReport.SetValueRow(11,stringgrid1.Cells[11,i]);
    FormExtReport.SetValueRow(13,stringgrid1.Cells[12,i]);
    FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;
  end;
  if curimns<>'' then begin
       FormExtReport.SetValueRowBold(3,curimns);
       FormExtReport.SetValueRowBold(2,'Итого');
       FormExtReport.SetValueRowBold(13,format('%8.5f',[summ1]));
       FormExtReport.flCurrentRow:=FormExtReport.flCurrentRow+1;
    end;
  if flform12 then
    FormExtReport.SaveToFile('d:\form12_'+formstart.NewGUID+'.xls')
   else
    FormExtReport.SaveToFile('d:\form11_'+formstart.NewGUID+'.xls');
end;

// '500','520','261','263','262'
procedure TFormExportForm12.BitBtn1Click(Sender: TObject);
const
  arr_imns:array[1..5] of string = ('500','520','261','263','262');
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
  filename1:string;
  qr1:double;
begin
  for i:=1 to StringGrid1.RowCount-1 do  StringGrid1.Cells[14,i]:='';
  DecodeDate(flstartdate, pppy, pppm, pppd);
  pppy :=  pppy mod 10; // Получаем последнее число года
  if (pppm>=1) and (pppm<=3) then  pppm:=3;
  if (pppm>=4) and (pppm<=6) then  pppm:=6;
  if (pppm>=7) and (pppm<=9) then  pppm:=9;
  if (pppm>=10) and (pppm<=12) then pppm:=0;
        Lists:=TStringList.Create;
        Lists.Clear;
        i:=1;
        Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
        Lists.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',flEndDate)+'" ВерсФорм="4.4" НаимПрог="'+NameApp+' '+CurVer+'">');
        Lists.add('<ФормаОтч НомФорм="38" ПризПериодОтч="'+inttostr(pppm)+'" ГодПериодОтч="'+FormatDateTime('YYYY',flEndDate)+'" >');
        Lists.add('<Первичная/>');
        Lists.add('</ФормаОтч>');
        Lists.add('<Справочники>');
        for i:=1 to stringgrid4.RowCount-1 do
        begin
         Lists.add('<ПроизводителиИмпортеры ИДПроизвИмп="'+inttostr(i)+'" П000000000004="'+replacestr(stringgrid4.cells[2,i],false)+'">');
         if stringgrid4.cells[4,i]<>'' then
          Lists.add('  <ЮЛ П000000000005="'+stringgrid4.cells[3,i]+'" П000000000006="'+stringgrid4.cells[4,i]+'"/> ')
         else
          Lists.add('  <ФЛ П000000000005="'+stringgrid4.cells[3,i]+'" /> ');
         Lists.add(' </ПроизводителиИмпортеры>');
        end;
        for i:=1 to stringgrid3.RowCount-1 do
        begin
         Lists.add('<Поставщики ИдПостав="'+inttostr(i)+'" П000000000007="'+replacestr(stringgrid3.cells[2,i],false)+'">');
         if stringgrid3.cells[4,i]<>'' then
          Lists.add('  <ЮЛ П000000000009="'+stringgrid3.cells[3,i]+'" П000000000010="'+stringgrid3.cells[4,i]+'"/> ')
         else
          Lists.add('  <ФЛ П000000000009="'+stringgrid3.cells[3,i]+'" /> ');
         Lists.add(' </Поставщики>');
        end;
        Lists.add('</Справочники>');

        Lists.add('<Документ>');
        Lists.add('<Организация>');
        Lists.add('<Реквизиты Наим="'+replacestr(formstart.FirmFullName,false)+'" ТелОрг="'+formstart.GetConstant('telephone')+'" EmailОтпр="'+formstart.GetConstant('email')+'" >');
        Lists.add(' <АдрОрг>');
        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс>'+formstart.GetConstant('address_zip')+'</Индекс>');
        Lists.add('  <КодРегион>'+formstart.GetConstant('address_region')+'</КодРегион>');
       Lists.add('   <Район></Район>');
        Lists.add('  <Город>'+formstart.GetConstant('address_city')+'</Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица>'+formstart.GetConstant('address_street')+'</Улица>');
        Lists.add('  <Дом>'+formstart.GetConstant('address_home')+'</Дом>');
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
        Lists.add('</Организация>');

        if formstart.FirmKPP<>'' then begin
            Lists.add('<ОбъемОборота Наим="'+replacestr(formstart.FirmFullName,false)+'" КППЮЛ="'+formstart.FirmKPP+'">');
        end
        else
            Lists.add('<ОбъемОборота Наим="'+replacestr(formstart.FirmFullName,false)+'">');
                Lists.add(' <АдрОрг>');

        Lists.add('  <КодСтраны>643</КодСтраны>');
        Lists.add('  <Индекс>'+formstart.GetConstant('address_zip')+'</Индекс>');
        Lists.add('  <КодРегион>'+formstart.GetConstant('address_region')+'</КодРегион>');
        Lists.add('   <Район></Район>');
        Lists.add('  <Город>'+formstart.GetConstant('address_city')+'</Город>');
        Lists.add('  <НаселПункт></НаселПункт>');
        Lists.add('  <Улица>'+formstart.GetConstant('address_street')+'</Улица>');
        Lists.add('  <Дом>'+formstart.GetConstant('address_home')+'</Дом>');
        Lists.add('  <Корпус></Корпус>');
        Lists.add('  <Кварт></Кварт> ');
        Lists.add('</АдрОрг>');

        //==== адрес
        // =========================
        ii:=0;
        iii:=0;
        curimns:='';
        for i:=1 to stringgrid2.RowCount-1 do  begin
         if curimns<> stringgrid2.cells[1,i] then begin
            if curimns<>'' then
              Lists.add('</Оборот>');
            curimns:= stringgrid2.cells[1,i];
            ii:=ii+1;
            Lists.add('<Оборот ПN="'+inttostr(ii)+'" П000000000003="'+curimns+'">');
            curIdClient:='';
            iii:=0;
           end;
           iii:=iii+1;
           curIdClient:=stringgrid2.cells[3,i]; // получим ИД производителя
           findSp:=1 ;
           while (StringGrid4.cells[1,findSp] <>  curIdClient ) and(StringGrid4.RowCount-1>findSp) do
             findSp:=findSp+1;
           Lists.add('<СведПроизвИмпортер ПN="'+inttostr(iii)+'" ИдПроизвИмп="'+inttostr(findSp)+'">');
           findcl:=1;
           ind2:=1;
           curcl:='';
           flObor := false;
            for ind:=1 to StringGrid1.RowCount-1 do begin
             if ((StringGrid1.Cells[1,ind]=curimns )and(StringGrid1.Cells[2,ind]=curIdClient))and(StringGrid1.Cells[14,ind]<>'1') then begin
                 if curcl<>StringGrid1.Cells[6,ind] then
                   begin
                    if curcl<>'' then
                      Lists.add('</Поставщик>');
                    findcl:=1;
                    curcl:=StringGrid1.Cells[6,ind] ; // получим код поставщика
                    while (StringGrid3.cells[1,findcl] <>  curcl ) and(StringGrid3.RowCount-1>findcl) do
                     findcl:=findcl+1;
                    Lists.add('<Поставщик ПN="'+inttostr(ind2)+'" ИдПоставщика="'+inttostr(findcl)+'" >');
                    ind2:=ind2+1;
                   end;
                 flObor :=true;
                 Lists.add('<Поставка П000000000013="'+StringGrid1.Cells[11,ind]+'" П000000000014="'+StringGrid1.Cells[11,ind]+'" П000000000015="" П000000000016="'+StringGrid1.Cells[12,ind]+'"/>');
                 StringGrid1.Cells[14,ind]:='1';
               end;
             end;
             if curcl<>'' then
                 Lists.add('</Поставщик>');
             qr1:= formstart.StrToFloat(stringgrid2.cells[8,i])+formstart.StrToFloat(stringgrid2.cells[9,i])+formstart.StrToFloat(stringgrid2.cells[10,i]);
             Lists.add('<Движение ПN="1" П100000000006="'+stringgrid2.cells[7,i]+'" П100000000007="'+stringgrid2.cells[8,i]+'" П100000000008="'+stringgrid2.cells[9,i]+'" П100000000009="'+stringgrid2.cells[10,i]+'"'+
                   ' П100000000010="'+format('%0.3f',[qr1])+'" П100000000011="'+stringgrid2.cells[12,i]+'"'+
                   ' П100000000012="'+stringgrid2.cells[13,i]+'" П100000000013="0.00000" П100000000014="'+stringgrid2.cells[14,i]+'" П100000000015="'+stringgrid2.cells[15,i]+'" П100000000016="'+stringgrid2.cells[16,i]+'" П100000000017="'+stringgrid2.cells[17,i]+'"'+
                   ' П100000000018="0.00000" П100000000019="'+stringgrid2.cells[18,i]+'" П100000000020="'+stringgrid2.cells[19,i]+'"/> ');
             Lists.add('</СведПроизвИмпортер>');

        end;
         if curimns<>'' then
            Lists.add('</Оборот>');
         // ==== КонецЦикла =====
         Lists.add('</ОбъемОборота>');
         Lists.add('</Документ>');
         Lists.add('</Файл>');

    if sdd1.Execute then begin
      lists.Text:=lazutf8.UTF8ToWinCP(lists.Text);
      filename1:= sdd1.FileName+'\08_'+formstart.FirmINN+'_'+Format('%.2d',[pppm])+Format('%.1d',[pppy])+'_'+FormatDateTime('DDMMYYYY',now())+'_'+formstart.NewGUID()+'.xml';
        lists.SaveToFile(filename1);
      Showmessage('Сформирован и сохранен:'+filename1);
    end;
end;

end.

