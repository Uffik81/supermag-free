unit udiscountcard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFormDiscountCard }

  TFormDiscountCard = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private

  public
    {записываем новую карту}
    procedure add_user_card(card, _name, contact:string);
    function SendDiscountCard():string;
  end;

var
  FormDiscountCard: TFormDiscountCard;

implementation

{$R *.lfm}
uses unitstart, mysql50;
{ TFormDiscountCard }

procedure TFormDiscountCard.add_user_card(card,_name,contact:string);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  Query:string='';
begin
  xRecBuf:=formstart.DB_query('SELECT `discount` FROM `discountcards` WHERE `card`="'+card+'";');
  xRowBuf:=formstart.DB_Next(xrecbuf);
  if xRowBuf = nil then
      //formstart.DB_query('INSERT INTO `discountcards`  (`card`,`discount`,`name`,`contacts` ) VALUES ("'+card+'",0,"'+name+'","'+contact+'");');
    begin
      formstart.DB_query('INSERT INTO `discountcards`  (`card`,`discount`,`name`,`contacts` ) VALUES ("'+card+'",0,"'+_name+'","'+contact+'");');
    end;
end;



procedure TFormDiscountCard.BitBtn2Click(Sender: TObject);
begin
  modalresult:=0;

end;

procedure TFormDiscountCard.BitBtn1Click(Sender: TObject);
begin
  if Edit1.Text = '' then
    exit;
  modalresult:=1377;
end;

function TFormDiscountCard.SendDiscountCard(): string;
var
    xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  Query:string='';
begin
  result:='0';
  Edit1.Text:='';
  if showmodal = 1377 then begin
    xRecBuf:=formstart.DB_query('SELECT `discount` FROM `discountcards` WHERE `card`="'+edit1.Text+'";');
    xRowBuf:=formstart.DB_Next(xrecbuf);
    if xRowBuf<>nil then
      result:=xrowbuf[0];
  end;
end;

end.

