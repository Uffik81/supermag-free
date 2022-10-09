unit unitinputsumm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFormInputSumm }

  TFormInputSumm = class(TForm)
    bbEnter: TBitBtn;
    bbEnter1: TBitBtn;
    ed_Email: TEdit;
    edSumm: TEdit;
    StaticText1: TStaticText;
    ToggleBox1: TToggleBox;
    procedure bbEnter1Click(Sender: TObject);
    procedure bbEnterClick(Sender: TObject);
    procedure bbEnterNotPrintClick(Sender: TObject);
    procedure ed_EmailChange(Sender: TObject);
    procedure edSummKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    {}
    fl_active_basket:boolean; // Флаг указывает на активацию оплаты
    fl_not_print:boolean;
    flrecipientEmail:String;
    flCodeRRN:String;
    flCodeAuth:String;
    flSumma:real;
    flOperBank:boolean;
    flCheckSales:boolean;
    flDepBank:integer;
    flemail:string;
    function InputSumm(var aSumm:real):boolean;
    function TransBank(var aSumm:real):boolean;
  end;

var
  FormInputSumm: TFormInputSumm;

implementation

{$R *.lfm}
uses unitstart,unitsalesbeer,unitsalesbeerts,unitinputsummv2;

{ TFormInputSumm }

procedure TFormInputSumm.bbEnterClick(Sender: TObject);
var
  res:real;
  i:integer;
  allSummTmp:real;
begin
  res:=StrToFloat(trim(edSumm.text));
  //if (formsalesbeerTS.SummCheck.Active)and (not (formsalesbeerTS.SummCheck.inputsummBank = 0) ) then
  //  exit;
  formsalesbeerTS.SummCheck.inputsummNal   := formsalesbeerTS.SummCheck.AllSumm;
  formsalesbeerTS.SummCheck.inputsummBank  := 0;
  flSumma:=res;
  self.flOperBank:=false;
  self.fl_not_print := self.ToggleBox1.Checked;
  self.flrecipientEmail:=ed_Email.text;
  modalresult:= 1377;
end;

procedure TFormInputSumm.bbEnterNotPrintClick(Sender: TObject);
var
  res:real;
  i:integer;
  allSummTmp:real;
begin
  res:=StrToFloat(trim(edSumm.text));
  //if (formsalesbeerTS.SummCheck.Active)and (not (formsalesbeerTS.SummCheck.inputsummBank = 0) ) then
  //  exit;
  formsalesbeerTS.SummCheck.inputsummNal   := formsalesbeerTS.SummCheck.AllSumm;
  formsalesbeerTS.SummCheck.inputsummBank  := 0;
  flSumma:=res;
  self.flOperBank:=false;
  self.fl_not_print := false;
  self.flrecipientEmail:=ed_Email.text;
  modalresult:= 1377;

end;

procedure TFormInputSumm.ed_EmailChange(Sender: TObject);
begin

end;

procedure TFormInputSumm.bbEnter1Click(Sender: TObject);
var
  i:integer;
  Noerr:boolean;
  ResSumm:real;
begin
  hide;
  if self.flCheckSales then begin
    self.fl_not_print := self.ToggleBox1.Checked;
    self.flrecipientEmail:=ed_Email.text;
    if formStart.flKKMSberbank then begin
       // BEGIN SberBank  Продажа
       noerr:=true;
       if (formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0) then begin
        if formsalesbeerTS.SalesCardSB(i,formsalesbeerTS.SummCheck.AllSumm,flCoderrn,flcodeauth)=0 then begin
            bbEnter.Enabled:=false;
            bbEnter1.Enabled:=false;
            self.flOperBank:=true;
            formsalesbeerTS.SummCheck.inputsummNal:=0;
            formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
            modalresult:= 1377
          end else begin
            self.show();
            noerr:=false;
          end;
        end;
      {if NoErr then

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
        end;}
      // END SberBank Продажа
      end else begin
        formsalesbeerTS.SummCheck.inputsummNal:=0;
        formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
  end else  begin
     // НАЧАЛО Сбербанк Возврат
     if formStart.flKKMSberbank then begin
          if formsalesbeerts.ReturnSalesCardSB(formsalesbeerTS.flSBDep,flSumma,flCoderrn,flcodeauth)<>-1 then
            begin
              bbEnter.Enabled:=false;
              bbEnter1.Enabled:=false;
              flOperBank:=true;
              formsalesbeerTS.SummCheck.inputsummNal:=0;
              formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
              modalresult:= 1377;
            end else
              show;
      end else begin
           formsalesbeerTS.SummCheck.inputsummNal:=0;
        formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
      // КОНЕЦ Сбербанк возврат
  end
end;

procedure TFormInputSumm.edSummKeyPress(Sender: TObject; var Key: char);
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

procedure TFormInputSumm.FormShow(Sender: TObject);
begin
  edSumm.SetFocus;
  //ed_Email.SelectAll;
  edSumm.SelectAll;
  self.fl_not_print := false;
end;

function TFormInputSumm.InputSumm(var aSumm:real): boolean;
begin
  self.fl_active_basket :=True;
  self.fl_not_print := false;
  if FormSalesBeerTs.flgresto then begin
    formInputSummv2.flCheckSales:=flCheckSales;
    result:=formInputSummv2.InputSumm(aSumm) ;
    flemail:= formInputSummv2.flemail;
   end else begin
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
    //ed_Email.SelectAll;
    edSumm.SelectAll;
    if showModal=1377 then begin
        self.fl_active_basket :=False;
      result:=true;
      if not flOperBank then
        aSumm:=formstart.StrToFloat(trim(edSumm.text));
    end;
   end;
   self.fl_active_basket :=False;
end;

{var
  i:integer;
  Noerr:boolean;
  ResSumm:real;
begin
  hide;
  if self.flCheckSales then begin
    self.fl_not_print := self.ToggleBox1.Checked;
    self.flrecipientEmail:=ed_Email.text;
    if formStart.flKKMSberbank then begin
       // BEGIN SberBank  Продажа
       noerr:=true;
       if (formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0) then begin
        if formsalesbeerTS.SalesCardSB(i,formsalesbeerTS.SummCheck.AllSumm,flCoderrn,flcodeauth)=0 then begin
            bbEnter.Enabled:=false;
            bbEnter1.Enabled:=false;
            self.flOperBank:=true;
            formsalesbeerTS.SummCheck.inputsummNal:=0;
            formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
            modalresult:= 1377
          end else begin
            self.show();
            noerr:=false;
          end;
        end;
      {if NoErr then

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
        end;}
      // END SberBank Продажа
      end else begin
        formsalesbeerTS.SummCheck.inputsummNal:=0;
        formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
  end else  begin
     // НАЧАЛО Сбербанк Возврат
     if formStart.flKKMSberbank then begin
          if formsalesbeerts.ReturnSalesCardSB(formsalesbeerTS.flSBDep,flSumma,flCoderrn,flcodeauth)<>-1 then
            begin
              bbEnter.Enabled:=false;
              bbEnter1.Enabled:=false;
              flOperBank:=true;
              formsalesbeerTS.SummCheck.inputsummNal:=0;
              formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
              modalresult:= 1377;
            end else
              show;
      end else begin
           formsalesbeerTS.SummCheck.inputsummNal:=0;
        formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
        flCoderrn:='0000';
        flcodeauth:='0000';
        flOperBank:=true;
        modalresult:= 1377;
      end;
      // КОНЕЦ Сбербанк возврат
  end       }
function TFormInputSumm.TransBank(var aSumm: real): boolean;
var
  i:integer;
  Noerr:boolean;
  ResSumm:real;
begin
    if self.fl_active_basket then  // Уже запущена оплата
        exit;
    if not formStart.flKKMSberbank then
        begin
            FormStart.fshowmessage('Работает только с подключенным терминалом!');
            Exit;
        end;
    self.fl_active_basket :=True;
    self.fl_not_print := false;
    if not FormSalesBeerTs.flgresto then  begin


        self.flemail:='';
        bbEnter.Enabled:=true;
        bbEnter1.Enabled:=true;
        flOperBank :=false;
        flCodeRRN  :='';
        flCodeAuth :='';
        flSumma:=aSumm;
        edSumm.text:= trim(format('%0.2f',[aSumm]));
        result:=false;
        //edSumm.SetFocus;
        //ed_Email.SelectAll;
        //self.edSumm.SelectAll;
        //edSumm.SetFocus;
        //edSumm.SelectAll;
        self.fl_not_print := false;
        self.fl_not_print := self.ToggleBox1.Checked;
        self.flrecipientEmail:=ed_Email.text;
        i:=0;
        if ((formsalesbeerTS.SummCheck.Active)and(formsalesbeerTS.SummCheck.inputsummBank=0))
            and ( formsalesbeerTS.SalesCardSB(0,formsalesbeerTS.SummCheck.AllSumm,flCoderrn,flcodeauth)=0 ) then begin
             bbEnter.Enabled:=false;
             bbEnter1.Enabled:=false;
             self.flOperBank:=true;
             formsalesbeerTS.SummCheck.inputsummNal:=0;
             formsalesbeerTS.SummCheck.inputsummBank:=formsalesbeerTS.SummCheck.AllSumm;
        end;

    end;
    self.fl_active_basket :=False;
end;

end.

