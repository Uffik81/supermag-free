unit unitShowStatus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls;

type

  { TFormShowStatus }

  TFormShowStatus = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormShowStatus: TFormShowStatus;

implementation

{$R *.lfm}

end.

