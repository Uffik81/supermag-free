{
 Framework Core:

}
unit fwcore;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, PythonEngine;

type

    { TFWCore }

    TFWCore = class(TObject)
    private
        {Наш внешний модуль.

        Требуется для общения с нашим кодом}
        FPyCoreModules:TPythonModule;
        {Обрабатываем стандартный Ввод/Вывод }
        FIOConsole:TPythonInputOutput;
        {Класс движка.

        Через него будем запускать скрипты}
        FPyEngine: TPythonEngine;

    public
        Constructor Create();
        procedure IOSendDate(Sender: TObject; const Data: AnsiString);
        Function PyExecuteScript(SScript:String):Boolean;
    end;

implementation

uses unitstart;

{ Python extend functions }

function Py_readversion(Self, Args : PPyObject): PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result:= PyUnicode_FromString('Core version: 0.0.1');
end;

{ TFWCore }

{Выполняем скрипт}
function TFWCore.PyExecuteScript(SScript: String): Boolean;
var
  SS:AnsiString;
begin
  SS:=utf8toansi(SScript);
  FPyEngine.ExecString(SS);
end;

constructor TFWCore.Create();
begin
    FPyEngine:= TPythonEngine.Create(nil);
    {Модуль который обращается к внешним ф-циям из приложения}
    FPyCoreModules := TPythonModule.Create(FPyEngine);
    with FPyCoreModules as TPythonModule do
        begin
          Engine := FPyEngine;
          ModuleName := 'pycore';
          FPyCoreModules.AddMethod('readversion',@py_readversion,'readversion' );
        end;
    {Инициализируем класс в/вывод}
    FIOConsole:= TPythonInputOutput.Create(FPyEngine);
    {Добавляем обработку события вывода в консоль}
    FIOConsole.OnSendData:=@IOSendDate;
    {Назначаем класс обработки в/вывода}
    FPyEngine.IO := FIOConsole;
    {Указываем "ядро" python}
    FPyEngine.DllName:='python38.dll';
    {Добавляем свой модуль со своими функциями}
    FPyEngine.AddClient(FPyCoreModules as TEngineClient);
    {Иниализируем библиотеку Python }
    FPyEngine.LoadDll();
    {Выполняем скрипт}
    PyExecuteScript('import pycore'+LF+
        's = pycore.readversion()'+LF+
        'print(s)');
end;

{ Выводим сообщение}
procedure TFWCore.IOSendDate(Sender: TObject; const Data: AnsiString);
var
  s:AnsiString;
begin

    s:=Data;
    formstart.fshowmessage(ansitoutf8(s));
end;


end.

