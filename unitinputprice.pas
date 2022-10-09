unit unitinputprice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormInputPrice }

  TFormInputPrice = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    stAlcValue: TStaticText;
    StaticText2: TStaticText;
    stBarcode: TStaticText;
    stDal: TStaticText;
    stName: TStaticText;
    stQual: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flplu:string;
    flName:string;
    flbarCode:string;
    //flSetPrice:String;
    flAlcCode:String;
    flAlcVolume:String;
    flPrice:String;
    flProductVCode:String;
    flCapacity:String;
    flReturn:boolean;
    function getPrice():boolean;
    function controlPrice(strPrice:string):String;
  end;

var
  FormInputPrice: TFormInputPrice;

implementation

{$R *.lfm}

uses unitstart,mysql50;

procedure TFormInputPrice.BitBtn1Click(Sender: TObject);
begin
   flPrice := ControlPrice(trim(Edit1.Text));
   self.ModalResult:=1377;
end;

procedure TFormInputPrice.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key in ['.','0'..'9'] then
     exit;
  if key=',' then
     key:='.';
  if ord(key)>32 then
   key:=#0;

end;

procedure TFormInputPrice.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    CloseAction:=caHide;
end;

procedure TFormInputPrice.FormKeyPress(Sender: TObject; var Key: char);
var
  con1:integer;
begin
  if key<>#13 then begin
   if key in ['.','0'..'9'] then
      exit;
   end;
  if key=',' then begin key:='.'; exit; end;

  if key=#13 then begin
     edit1.text:= trim(edit1.text);
     if strtofloat(trim(edit1.text))=0 then
        begin
          key:=#0;
          showmessage('Цена не может быть нулевой!');
          exit;
        end;
     flPrice := ControlPrice(trim(Edit1.Text));
     key:=#0;
     self.ModalResult:=1377;
     exit;
  end;
  if ord(key)>32 then
   key:=#0;

end;

procedure TFormInputPrice.FormShow(Sender: TObject);
begin

  Edit1.Text:= trim(flPrice);
  edit1.SetFocus;
  edit1.SelectAll;
end;


function TFormInputPrice.controlPrice(strPrice:string):String;
var
  query:string;
  tst:real;
begin
  try
    tst:=strtofloat(trim(strPrice));
  except
    strPrice:=flPrice;
  end;
  if flPrice<>strPrice then begin
     if flPLU<>'' then
      Query:='UPDATE `sprgoods` SET `currentprice`="'+strPrice+'" WHERE `plu`="'+flplu+'";'
     else
      Query:='UPDATE `sprgoods` SET `currentprice`="'+strPrice+'" WHERE `barcodes`="'+flbarCode+'";';
    FormStart.DB_Query(Query);
  end;
  result:=strPrice;

end;

function TFormInputPrice.getPrice():boolean;
var
  res:integer;
begin
  result:=false;
 // flPDF417:='';
  stName.Caption:=flName;
  stBarcode.Caption:=flBarcode;
  stDal.Caption:=flCapacity+' л.';
  stAlcValue.Caption:=flAlcVolume+'%';
  edit1.SelectAll;
  res:=showmodal;
  if res = 1377 then begin
    result:=true ;
  end;


end;

end.

