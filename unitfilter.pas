unit unitFilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, Buttons, StdCtrls, ExtDlgs;

type

  { TFormFilter }

  TFormFilter = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    StartDate:TdateTime;
    EndDate:TdateTime;
  end;

var
  FormFilter: TFormFilter;

implementation

{$R *.lfm}
uses unitStart,unitJurnale;
{ TFormFilter }

function getDayOfMount(yy,mm:word):integer;
begin
  case mm of
      4,6,9,11:
          result:=30;
      1,3,5,7,8,10,12:
          result:=31;
      2:
          if (yy mod 400 = 0) or
          (yy mod 100 <> 0) and (yy mod 4 = 0) then
              result:=29
          else
              result:=28
      else
        result:=0;
  end;
end;

function GetKvart(mm:word):word;
begin
  case mm of
      1,2,3:result:=1;
      4,5,6:result:=2;
      7,8,9:result:=3
      else
        result:=4;
  end;
end;

procedure TFormFilter.BitBtn1Click(Sender: TObject);
var
  yy,mm,dd,ee:word;
begin
  // ====== Обработка выбора =====
  if RadioButton1.Checked then begin
    //formJurnale.startDateInTTN:= DateTimePicker3.Date;
    //formJurnale.endDateInTTN  := DateTimePicker3.Date;
    StartDate := DateTimePicker2.Date;
    EndDate   := DateTimePicker1.Date;
  end;
  if RadioButton2.Checked then begin
    DecodeDate(now(),yy,mm,dd);
    mm:=(ComboBox1.ItemIndex)*3+1;
    if CheckBox1.Checked then
      mm:=1;
    StartDate := EncodeDate(yy,mm,1);
    dd        := getDayOfMount(yy,(ComboBox1.ItemIndex+1)*3);
    EndDate   := EncodeDate(yy,(ComboBox1.ItemIndex+1)*3,dd);
  end;
  if RadioButton3.Checked then begin
    DecodeDate(now(),yy,mm,dd);
    mm:=ComboBox2.ItemIndex+1;
    if CheckBox2.Checked then
        mm:=(GetKvart(mm)-1)*3+1;
    StartDate :=EncodeDate(yy,mm,1);
    dd:=getDayOfMount(yy,ComboBox2.ItemIndex+1);
    EndDate   :=EncodeDate(yy,ComboBox2.ItemIndex+1,dd);
  end;
  if RadioButton4.Checked then begin
//    formJurnale.startDateInTTN:= DateTimePicker3.Date;
//    formJurnale.endDateInTTN  := DateTimePicker3.Date;
    DecodeDate(DateTimePicker3.Date,yy,mm,dd);
    if CheckBox3.Checked then
      dd:=1;

    StartDate := EncodeDate(yy,mm,dd);
    EndDate   := DateTimePicker3.Date;
  end;
  modalresult:=1377;

end;

procedure TFormFilter.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFormFilter.Button3Click(Sender: TObject);
begin

end;

procedure TFormFilter.FormCreate(Sender: TObject);
begin
  DateTimePicker1.date:=now();
  DateTimePicker2.date:=now();
  DateTimePicker3.date:=now();
end;

procedure TFormFilter.FormShow(Sender: TObject);
begin
  DateTimePicker1.Enabled:=RadioButton1.Checked;
  DateTimePicker2.Enabled:=RadioButton1.Checked;
  ComboBox2.Enabled:=RadioButton3.Checked;
  ComboBox1.Enabled:=RadioButton2.Checked;
  CheckBox1.Enabled:=RadioButton2.Checked;
  CheckBox2.Enabled:=RadioButton3.Checked;
  StaticText1.Caption:='Текущая дата:'+#13#10+FormatDateTime('yyyy-mm-dd',now());
end;

procedure TFormFilter.RadioButton1Change(Sender: TObject);
begin
  DateTimePicker1.Enabled:=RadioButton1.Checked;
  DateTimePicker2.Enabled:=RadioButton1.Checked;
end;

procedure TFormFilter.RadioButton2Change(Sender: TObject);
begin
  ComboBox1.Enabled:=RadioButton2.Checked;
  CheckBox1.Enabled:=RadioButton2.Checked;
end;

procedure TFormFilter.RadioButton3Change(Sender: TObject);
begin
  ComboBox2.Enabled:=RadioButton3.Checked;
  CheckBox2.Enabled:=RadioButton3.Checked;

end;

procedure TFormFilter.RadioButton4Change(Sender: TObject);
begin
  DateTimePicker3.Enabled:=RadioButton4.Checked;
  CheckBox3.Enabled:=RadioButton4.Checked;
end;

end.

