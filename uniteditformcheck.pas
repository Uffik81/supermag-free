unit unitEditFormCheck;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TFormEditFormCheck }

  TFormEditFormCheck = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    cbPrintNumCheck: TCheckBox;
    cbDisabledCut: TCheckBox;
    cbPrintFullReport: TCheckBox;
    Edit1: TEdit;
    edPrefixCheck: TEdit;
    EdNumChar: TEdit;
    Memo1: TMemo;
    mmheader: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure cbPrintNumCheckChange(Sender: TObject);
    procedure EdNumCharChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormEditFormCheck: TFormEditFormCheck;

implementation

{$R *.lfm}
uses unitstart, unitsalesbeerts;
{ TFormEditFormCheck }

procedure TFormEditFormCheck.BitBtn1Click(Sender: TObject);
begin
  if cbPrintNumCheck.Checked then formStart.SetConstant('printnumcheck','1') else
    formStart.SetConstant('printnumcheck','0') ;
  if Checkbox6.Checked then formStart.SetConstant('precheckclose','1') else
    formStart.SetConstant('precheckclose','0') ;
  if Checkbox7.Checked then formStart.SetConstant('enableprecheck','1') else
    formStart.SetConstant('enableprecheck','0') ;
  formstart.SetConstant('PrefixCheck',trim(edPrefixCheck.Text));
  formstart.SetConstant('StringSizeKKM',trim(edNumChar.Text));
  if cbDisabledCut.Checked then
      FormStart.SetConstant('DisabledCut','1')
  else
    FormStart.SetConstant('DisabledCut','1');
  FormStart.SetConstBool('printfullreport',cbPrintFullReport.Checked);
  //formstart.SetConstant('TypeKKM'+formstart.prefixClient,trim(edNumChar.Text));
end;

procedure TFormEditFormCheck.BitBtn2Click(Sender: TObject);
var
  i:integer;
begin
  //formSalesBeerTS.FRPrintHeader;
  for i:=0 to mmheader.Lines.Count-1 do
        formSalesBeerTS.PrintLineString(mmheader.Lines.Strings[i]);
  formSalesBeerTS.PrintLineGood('Пакет маленький',' ');
  formSalesBeerTS.PrintLineGood(' 01','1.00 = 1.00');
  formSalesBeerTS.PrintLineGood(''#9'И'#9'Т'#9'О'#9'Г','=1.00',false);
  formSalesBeerTS.PrintLineGood('ОПЛАТА','');
  formSalesBeerTS.PrintLineGood('НАЛИЧНЫМИ','=1.00');
  for i:=0 to Memo1.Lines.Count-1 do
        formSalesBeerTS.PrintLineString(Memo1.Lines.Strings[i]);
  formSalesBeerTS.PrintLineGood('СМЕНА №','1');
  formSalesBeerTS.PrintLineGood('ЧЕК №','1');
  formSalesBeerTS.PrintLineGood('+','+');
  formSalesBeerTS.PrintLineGood('ИТОГ','=1.00');
  formSalesBeerTS.PrintLineGood(' РН ККТ:','00000000000000 ');
  formSalesBeerTS.PrintLineGood('+','+');
  formSalesBeerTS.PrintLineGood('+','+');
  formSalesBeerTS.PrintLineGood('+','+');
  formSalesBeerTS.PrintLineGood('+','+');
  formSalesBeerTS.FRPrintQRCode('http://www.retailika.ru/');
  formSalesBeerTS.FRPrintHeader;

end;

procedure TFormEditFormCheck.CheckBox6Change(Sender: TObject);
begin

end;

procedure TFormEditFormCheck.cbPrintNumCheckChange(Sender: TObject);
begin

end;

procedure TFormEditFormCheck.EdNumCharChange(Sender: TObject);
begin

end;

procedure TFormEditFormCheck.FormShow(Sender: TObject);
begin
  EdNumChar.Text:=formstart.GetConstant('StringSizeKKM');
  Checkbox6.Checked:= db_boolean(formstart.GetConstant('precheckclose'));
  Checkbox7.Checked:=db_boolean(formstart.GetConstant('enableprecheck'));
  cbPrintNumCheck.Checked:= db_boolean(formstart.GetConstant('printnumcheck'));
  cbDisabledCut.Checked:= db_boolean(formstart.GetConstant('DisabledCut'));
  EdPrefixCheck.Text:=formstart.GetConstant('PrefixCheck');
  cbPrintFullReport.Checked := formstart.GetConstBool('printfullreport');
end;

end.

