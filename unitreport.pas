unit unitReport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, Buttons;

type

  { TFormReport }

  TFormReport = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
  private
    { private declarations }
  public
    { public declarations }

  end;

var
  FormReport: TFormReport;

implementation

{$R *.lfm}

end.

