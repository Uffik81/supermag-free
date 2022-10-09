unit unitcashfilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls, ComCtrls;

type

  { TFormCashFilter }

  TFormCashFilter = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private

  public
    StartDate:TdateTime;
    EndDate:TdateTime;
    ProductVCode:String;
  end;

var
  FormCashFilter: TFormCashFilter;

implementation

{$R *.lfm}
uses DOM, XMLRead, typinfo,
 sockets,
 comobj,  variants,
 unitStart,
 unitAddformB,
 unitspproduct,
 unitFilter,
 unitcommon
;

{ TFormCashFilter }

procedure TFormCashFilter.BitBtn1Click(Sender: TObject);
var
    ssStartDate:string;
    ssEndDate:string;
begin
  if FormFilter.ShowModal = 1377 then begin
      StartDate := FormFilter.StartDate;
      EndDate   := FormFilter.EndDate;
      ssStartDate:= FormatDateTime('YYYY-MM-DD 00:00:00',StartDate);
      ssEndDate  := FormatDateTime('YYYY-MM-DD 23:59:59',EndDate);
      label1.Caption:='C '+ssStartDate+' ПО '+ssEndDate;
  end;
end;

procedure TFormCashFilter.BitBtn2Click(Sender: TObject);
begin
  self.ProductVCode:='';
  if not( (ComboBox2.Text = '--нет--') or (ComboBox2.Text = '')) then
     self.ProductVCode := Copy(ComboBox2.Text,1,3);
  modalresult:=1377;
end;

procedure TFormCashFilter.ComboBox2Change(Sender: TObject);
begin

end;

end.

