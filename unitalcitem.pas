unit unitalcitem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons;

type

  { TFormAclItem }

  TFormAclItem = class(TForm)
    BitBtn1: TBitBtn;
    cbUnpacket: TCheckBox;
    ComboBox1: TComboBox;
    edAlcEgais: TEdit;
    edINNProducer: TEdit;
    edName: TEdit;
    edShortName: TEdit;
    edProductVCode: TEdit;
    edCapacity: TEdit;
    edAlcVolume: TEdit;
    edNameProducer: TEdit;
    edNameImporter: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    flAlcCode:String;

  end;

var
  FormAclItem: TFormAclItem;

implementation

{$R *.lfm}
uses unitstart;
{ TFormAclItem }

procedure TFormAclItem.FormShow(Sender: TObject);
var
  query:string;

begin
  Query:=' SELECT `name`,`Capacity`,`AlcVolume`,`ProductVCode`,`ClientRegId`,`IClientRegId`,'+
  '(SELECT `FullName` FROM `spproducer` WHERE `ClientRegId`=`spproduct`.`ClientRegId`) AS `producerName`,'+
  '(SELECT `FullName` FROM `spproducer` WHERE `ClientRegId`=`spproduct`.`IClientRegId`) AS `IproducerName`,`egaisname`,`unpacked` FROM `spproduct` WHERE `alccode`="'+flAlcCode+'";';

  formstart.rowbuf:=FormStart.DB_Next(formStart.DB_query(Query));
  if formstart.rowbuf<>nil then begin
    edname.Text:=formstart.rowbuf[8];
    edAlcEgais.Text:=flAlcCode;
    edCapacity.Text:=formstart.rowbuf[1];
    edProductVCode.Text:=formstart.rowbuf[3];
    edAlcVolume.Text:=formstart.rowbuf[2];
    GroupBox1.Caption:='Производитель ['+formstart.rowbuf[4]+']';
    edNameProducer.Text:=formstart.rowbuf[6];
    edNameImporter.Text:=formstart.rowbuf[7];
    GroupBox2.Caption:='Импортер ['+formstart.rowbuf[5]+']';
    edShortName.Text:=formstart.rowbuf[0];
    cbUnpacket.Checked:=db_boolean(formstart.rowbuf[9]);
  end;
end;

procedure TFormAclItem.BitBtn1Click(Sender: TObject);
begin
  Close();
end;

procedure TFormAclItem.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caHide;
end;

end.

