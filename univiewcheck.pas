unit univiewcheck;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFormViewCheck }

  TFormViewCheck = class(TForm)
    MmCheck: TMemo;
    Panel1: TPanel;
  private

  public

  end;

var
  FormViewCheck: TFormViewCheck;

implementation

{$R *.lfm}

end.

