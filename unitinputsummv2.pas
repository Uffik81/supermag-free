unit unitinputsummv2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormInputSummv2 }

  TFormInputSummv2 = class(TForm)
    bbEnter: TBitBtn;
    bbEnter1: TBitBtn;
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
    procedure bbEnter1Click(Sender: TObject);
    procedure bbEnterClick(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure edSummKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
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
    flemail:string;
    function InputSumm(var aSumm:real):boolean;
  end;

var
  FormInputSummv2: TFormInputSummv2;

implementation
uses unitstart,unitsalesbeer, unitsalesbeerts;
{$R *.lfm}

{ TFormInputSummv2 }

procedure TFormInputSummv2.bbEnterClick(Sender: TObject);
var
  res:real;
  i:integer;
  allSummTmp:real;
begin
  res:=StrToFloat(trim(edSumm.text));

  //if res< flSumma then

  if (formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0) then begin
      formsalesbeerTS.SummCheck.inputsummNal:=formsalesbeerTS.SummCheck.AllSumm;
    end;
  flSumma:=res;
  flOperBank:=false;
  modalresult:= 1377;
end;

procedure TFormInputSummv2.BitBtn10Click(Sender: TObject);
begin
  edSumm.Text:='0';
end;

procedure TFormInputSummv2.BitBtn12Click(Sender: TObject);
begin
  edSumm.Text:=edSumm.Text+'.';
end;

procedure TFormInputSummv2.BitBtn13Click(Sender: TObject);
begin
  modalresult:=0 ;
  close;
end;

procedure TFormInputSummv2.BitBtn1Click(Sender: TObject);
begin
  if edSumm.SelLength<>0 then
    edSumm.Text:='';
  if edSumm.Text='0' then
      edSumm.Text:=inttostr((sender AS TBitbtn).Tag)
      else
  edSumm.Text:=edSumm.Text+inttostr((sender AS TBitbtn).Tag);
end;

procedure TFormInputSummv2.BitBtn5Click(Sender: TObject);
begin

end;

procedure TFormInputSummv2.edSummKeyPress(Sender: TObject; var Key: char);
begin
  if key<>#13 then begin
   if key in ['.','0'..'9'] then
      exit;
   end;
  if key=',' then begin key:='.'; exit; end;

  if key=#13 then begin
     key:=#0;
     bbEnterClick(nil);
     exit;
  end;
  if key='+' then begin
     key:=#0;
     bbEnter1Click(nil);
     exit;
  end;
end;

procedure TFormInputSummv2.FormShow(Sender: TObject);
begin
  edSumm.SetFocus;
  //edit1.SelectAll;
  edSumm.SelectAll;
end;

procedure TFormInputSummv2.bbEnter1Click(Sender: TObject);
var
  i:integer;
  Noerr:boolean;
  ResSumm:real;
begin
  hide;
  if flCheckSales then begin
    if formStart.flKKMSberbank then
      begin
      noerr:=true;

       if (formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0) then begin
        if formsalesbeerTS.SalesCardSB(i,formsalesbeerTS.SummCheck.AllSumm,flCoderrn,flcodeauth)<>-1 then
          begin
            bbEnter.Enabled:=false;
            bbEnter1.Enabled:=false;
            flOperBank:=true;
            formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
          end else begin
           noerr:=false;
          end;
        end;


      if NoErr then
          modalresult:= 1377
        else begin
          // Рассчитываем сумму которую осталось внести
          ResSumm:=0;
           if (formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0) then begin
               ResSumm:=ResSumm+formsalesbeerTS.SummCheck.AllSumm;
             end;
          edSumm.text:=floattostr(resSumm);
          bbEnter.Enabled:=true;
          bbEnter1.Enabled:=true;
          show;
        end;
      end else begin

        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
  end else  begin
     if formStart.flKKMSberbank then begin
          if formsalesbeerts.ReturnSalesCardSB(formsalesbeerTS.flSBDep,flSumma,flCoderrn,flcodeauth)<>-1 then
            begin
              bbEnter.Enabled:=false;
              bbEnter1.Enabled:=false;
              flOperBank:=true;
              modalresult:= 1377;
            end else
              show;
      end else begin
        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
  end
end;

function TFormInputSummv2.InputSumm(var aSumm: real): boolean;
begin
  flemail:='';
  bbEnter.Enabled:=true;
  bbEnter1.Enabled:=true;
  flOperBank :=false;
  flCodeRRN  :='';
  flCodeAuth :='';
  flSumma:=aSumm;
  edSumm.text:= trim(format('%0.2f',[aSumm]));
  result:=false;
  //edSumm.SetFocus;
  //edit1.SelectAll;
  edSumm.SelectAll;
  if showModal=1377 then begin
    result:=true;
    if not flOperBank then
      aSumm:=formstart.StrToFloat(trim(edSumm.text));
  end;

end;

end.

