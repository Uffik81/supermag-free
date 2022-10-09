{/*
Форма отвечает за ввод данных о сигаретах!!!
*/}
unit unitcigar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TFormCigar }

  TFormCigar = class(TForm)
    BitBtn1: TBitBtn;
    edCodeItem: TEdit;
    Label1: TLabel;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure edCodeItemEnter(Sender: TObject);
    procedure edCodeItemKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    function get_gtin(type_mark:word; serial_gtin:string;break_ch:string=''):string;
  end;

var
  FormCigar: TFormCigar;

implementation

{$R *.lfm}

{ TFormCigar }

function replaceStrSerial(const aStr:string):string;
var
  i:integer;
  begin
    result:='';
    for i:=1 to length(aStr) do
     if not (aStr[i] in ['(',')']) then
       result:=result+aStr[i];


  end;

{функция формирует код для тега 1162
ссылки:
       https://xn--80ajghhoc2aj1c8b.xn--p1ai/upload/iblock/09e/09e9978505dad5ba4a8f814420ab20b7.pdf
пример GTIN: 011500015807102221VFVD1KXEH40H791EE0692TgCr+T/nLRMUHK9G/KSNotpzVMbqSO/kAOgABkIyRow=
AI = 01, 21, 91, 92
формат значения цифры первый последнее значение
Код DataMAtrix 444D
Штрих-М
НомерТэга_hex = ПолучитьБайтыВОбратномПорядке(DecToHex(НомерТэга_инт, 4));
ДлинаТэга_hex = ПолучитьБайтыВОбратномПорядке(DecToHex(Окр(СтрДлина(ЗначениеТэга_hex)/2), 4));
ФР.TLVDataHex = НомерТэга_hex + ДлинаТэга_hex + ЗначениеТэга_hex;
ФР.FNSendTLVOperation();
АТОЛ
driver.StreamFormat = 5;
driver.BeginItem();
driver.AttrNumber = 1162;
driver.AttrValue = "00 05 00 00 02 C0 BE D3 72 51 4D 54 46 34 53";
driver.WriteAttribute();

}
function TFormCigar.get_gtin( type_mark:word; serial_gtin:string;break_ch:string='' ):string;
var
  tmpS:string;
  s1, s2:string;
  gtin:int64;
  i,ii:integer;
  mass:array[0..25] of byte; // массив байт
begin

  {2b  6b   7b + 11b}
  {приобразуем GTIN в int64 и отсекаем последние 2 байта}
  s1:='';
  s2:='';
  i:=1;
  tmpS:=replaceStrSerial( serial_gtin);
  while i<length(tmpS)-1 do
    case (tmpS[i]+tmpS[i+1]) of
      '01': begin // read gtin len 14
        i:=i+2;
        s1:='';
          for ii:= i to i+13 do
            s1 := s1 + tmpS[ii];
          i:=i+14;
       end;
       '21':begin // len 20
          i:=i+2;
          s2:='';
          for ii:= i to i+12 do
            s2 := s2 +inttohex(ord(tmpS[ii]),2);
          break;
       end;
       '91':;
    else
      i:=i+1;
    end;


  gtin:= strtoint64(S1);
  s1:= inttohex(gtin, 6);
  if (length(s1) mod 2 ) = 1 then
      s1:='0'+s1;

  result:='444D'+s1+s2;

end;

procedure TFormCigar.FormCreate(Sender: TObject);
begin

end;

procedure TFormCigar.FormShow(Sender: TObject);
begin
  edCodeItem.Text:='';
  edCodeItem.SetFocus;
end;

procedure TFormCigar.BitBtn1Click(Sender: TObject);
var
  res1:string;
  i:integer;
begin
  if (pos('(',edCodeItem.text)<>0)  and (pos(')',edCodeItem.text)<>0) then begin
     i:=pos(')',edCodeItem.text);
     edCodeItem.Text:= copy(edCodeItem.Text,i+1,length(edCodeItem.Text));
     i:= pos('(',edCodeItem.text);
     res1:=  copy(edCodeItem.Text,1,i-1);
     i:=pos(')',edCodeItem.text);
     edCodeItem.Text:= copy(edCodeItem.Text,i+1,length(edCodeItem.Text));
     i:= pos('(',edCodeItem.text);
     res1:=  res1+copy(edCodeItem.Text,1,i-1);
     edCodeItem.Text:=res1;
  end;
  ModalResult:=1137;
end;

procedure TFormCigar.edCodeItemEnter(Sender: TObject);
var
  i:integer;
  str1,
  res1,SerialNumber,GTIN:string;
begin
  str1:=  edCodeItem.Text;
  if (pos('(',edCodeItem.text)<>0)  and (pos(')',edCodeItem.text)<>0) then begin
     i:=pos(')',str1);
     str1:= copy(str1,i+1,length(str1));
     i:= pos('(',str1);
     res1:=  copy(str1,1,i-1);
     i:=pos(')',str1);
     str1:= copy(str1,i+1,length(str1));
     i:= pos('(',str1);
     res1:=  res1+copy(str1,1,i-1);
//     edCodeItem.Text:=res1;
  end;
  StaticText1.Caption:= res1;

  GTIN:=Copy(res1,1,14);
  SerialNumber:=Copy(res1,15,7);
  StaticText1.Caption:= StaticText1.Caption+' GTIN:'+GTIN +' SN:'+SerialNumber;
end;

procedure TFormCigar.edCodeItemKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then begin
    edCodeItemEnter(Sender);
    key := #0;
  end;
end;

end.

