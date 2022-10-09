unit unitInputQuantity;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormInputQuantity }

  TFormInputQuantity = class(TForm)
    bbEnter: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    edSumm: TEdit;
    StaticText1: TStaticText;
    procedure bbEnterClick(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flCodeRRN:String;
    flCodeAuth:String;
    flSumma:real;
    flOperBank:boolean;
    flCheckSales:boolean;
    flDepBank:integer;
    flVesi:boolean;
    function InputSumm(var aSumm:real; aVesi:boolean = true):boolean;
  end;

var
  FormInputQuantity: TFormInputQuantity;

implementation
uses unitstart,unitsalesbeer, unitsalesbeerts;
{$R *.lfm}

{ TFormInputQuantity }

procedure TFormInputQuantity.bbEnterClick(Sender: TObject);
var
  res:real;
begin
  res:=StrToFloat(edSumm.text);
  if res< 0 then
    exit;
  flSumma:=res;
  flOperBank:=false;
  modalresult:= 1377;


end;

procedure TFormInputQuantity.BitBtn10Click(Sender: TObject);
begin
  edSumm.Text:='0';
end;

procedure TFormInputQuantity.BitBtn12Click(Sender: TObject);
begin
  edSumm.Text:=edSumm.Text+'.';
end;

procedure TFormInputQuantity.BitBtn13Click(Sender: TObject);
begin
  modalresult:=0 ;
  close;
end;

procedure TFormInputQuantity.BitBtn14Click(Sender: TObject);
var
  res:string;
begin
  res:=formsalesbeerts.GetScaleCurrentCash();
  if res <>'' then
    edSumm.Text:=res;
end;

procedure TFormInputQuantity.BitBtn1Click(Sender: TObject);
begin
  if edSumm.SelLength<>0 then
    edSumm.Text:='';
  if edSumm.Text='0' then
      edSumm.Text:=inttostr((sender AS TBitbtn).Tag)
      else
  edSumm.Text:=edSumm.Text+inttostr((sender AS TBitbtn).Tag);
end;

function TFormInputQuantity.InputSumm(var aSumm: real; aVesi: boolean): boolean;
begin
  flVesi:=aVesi;
  BitBtn12.Visible:=aVesi;
  flOperBank :=false;
  flCodeRRN  :='';
  flCodeAuth :='';
  flSumma:=aSumm;
  edSumm.text:= FloattoStr(aSumm);
  result:=false;
  //edSumm.SetFocus;
  //edit1.SelectAll;
  edSumm.SelectAll;
  if showModal=1377 then begin
    result:=true;

  end;
end;

end.

