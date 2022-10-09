unit unitexportdecalc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, mysql50;

type

  { TFormExportDecAlc }

  TFormExportDecAlc = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Panel1: TPanel;
    sdd1: TSelectDirectoryDialog;
    StaticText1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { private declarations }
  public
    flStartDate,flEndDate:tdatetime;
    { public declarations }
  end;

var
  FormExportDecAlc: TFormExportDecAlc;

implementation

{$R *.lfm}
uses unitstart,unitexportform12,unitFilter;
{ TFormExportDecAlc }

procedure TFormExportDecAlc.BitBtn2Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  indka:integer;
begin
  Lists:=TStringList.Create;
  Lists.Clear;
  indka:=1;
  Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
  Lists.add('<Справочники>');
  // ==== в цикле ===== по документам =====

  Lists.add('<Контрагенты ИдКонтр="'+inttostr(indka)+'" П000000000007="'+fullnameka+'" >');
  Lists.add('<Резидент>');
  Lists.add('<Лицензии>');
  Lists.add('<Лицензия ИдЛицензии=""1"" П000000000011=""А,647683"" П000000000012=""21.06.2011"" П000000000013=""14.02.2016"" П000000000014=""Федеральная служба по регулированию алкогольного рынка"">');
  Lists.add('</Лицензии>');
  Lists.add('<П000000000008>');
  Lists.add('<КодСтраны","643">');
  Lists.add('<Индекс","346413"');
  Lists.add('<КодРегион","61"');
  Lists.add('<Район"');
  Lists.add('<Город","г. Новочеркасск"');
  Lists.add('<НаселПункт"');
  Lists.add('<Улица","ш. Харьковское"');
  Lists.add('<Дом","д. 5"');
  Lists.add('<Корпус"');
  Lists.add('<Литера"');
  Lists.add('<Кварт"');
  Lists.add('</П000000000008>');
  Lists.add('<ЮЛ П000000000009="6150006362" П000000000010="615045002"/>');
  Lists.add('<Производитель value="False"/>');
  Lists.add('<Перевозчик value="False"/>');
  Lists.add('</Резидент>');
  Lists.add('</Контрагенты>');

  Lists.add('</Справочники>');
  if sdd1.Execute then begin
    lists.Text:=utf8toansi(lists.Text);
    lists.SaveToFile(sdd1.FileName+'\spproduct.xml');
    Showmessage('Сформирован!');
  end;
  Lists.free;
end;

procedure TFormExportDecAlc.BitBtn1Click(Sender: TObject);
begin
  formfilter.ShowModal;
  flStartDate:=formfilter.StartDate;
  flEndDate:=formfilter.EndDate;
  Statictext1.Caption:='C '+FormatDateTime('YYYY-MM-DD',flStartDate)+' по '+FormatDateTime('YYYY-MM-DD',flEndDate);
end;

procedure TFormExportDecAlc.BitBtn3Click(Sender: TObject);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
  Lists:TStringList;
  fullnameka:String;
  i:integer;
begin
  query:='SELECT (SELECT `ClientRegId` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `ClientRegId`'+
  ',(SELECT `IClientRegId` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `IClientRegId`'+ ',SUM(`factcount`)'+
  ',(SELECT `capacity` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `capacity`'+
  ',(SELECT `productvcode` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `productvcode` '+
  ', `datedoc`,`numdoc`'+
      ',(SELECT `Import` FROM `spproduct` WHERE `spproduct`.`alccode`=`alcitem`) AS `Import`'+' FROM `doc221`'+
  ' WHERE  (`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'") GROUP BY `numdoc`,`productvcode`,`capacity`;';
  xRecBuf:=formstart.DB_query(Query);
  xRowBuf:=formStart.DB_Next(xrecbuf);

  Lists:=TStringList.Create;
  Lists.Clear;

  Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
  Lists.add('<Файл ДатаДок="ДатавХМЛ" ВерсФорм="4.20" НаимПрог="1с в7.7"">');
  Lists.add('<Документ>');
  // === Цикл =====
  i:=1;
  while xrowbuf<>nil do begin


  // ==== оборот =====
  Lists.add('<Оборот  ПN="'+inttostr(i)+'" П000000000003="'+xrowbuf[3]+'" >');
  if xrowbuf[7]='' then
    Lists.add('<СведПроизвИмпорт"," NameOrg="'+xrowbuf[0]+'" >')
  else
     Lists.add('<СведПроизвИмпорт"," NameOrg="'+xrowbuf[1]+'" >');
  Lists.add('<Продукция П200000000013="'+xrowbuf[6]+'" П200000000014="'+xrowbuf[5]+'" П200000000015="" П200000000016="'+FloatToStr(formStart.StrToFloat(xrowbuf[3])*formStart.StrToFloat(xrowbuf[2])*0.1)+'"/>');
  Lists.add('</СведПроизвИмпорт>');

  Lists.add('</Оборот>');
  xRowBuf:=formStart.DB_Next(xrecbuf);
  i:=i+1;
end;
  // ==== КонецЦикла =====
  Lists.add('</Документ>');
  Lists.add('</Файл>');

  if sdd1.Execute then begin
    lists.Text:=utf8toansi(lists.Text);
    lists.SaveToFile(sdd1.FileName+'\spproduct.xml');
    Showmessage('Сформирован!');
  end;
  lists.Free;
{
текст.ДобавитьСтроку("<?xml version=""1.0"" encoding=""windows-1251""?>");
Атриб = "ДатаДок="""+ДатавХМЛ+""" ВерсФорм=""4.20"" НаимПрог=""1с в7.7"" ";
ХМЛОткрытьЭлем(текст,"Файл",Атриб);

Сообщить(" Создали Документ");
ХМЛОткрытьЭлем(текст,"Документ");
   // Документ
			НомОбор = 0;

		отчетПр.ВыбратьСтроки();
		Пока отчетПр.ПолучитьСтроку() = 1 цикл
    Если (Найти(отчетПр.к_2,"520")=0)
				и (((Найти(отчетПр.к_2,"Cидр")=0)
				и (Найти(отчетПр.к_2,"500")=0))
				и ((Найти(отчетПр.к_2,"261")=0)
				и ((Найти(отчетПр.к_2,"262")=0)
				и (Найти(отчетПр.к_2,"263")=0))))
				тогда
				продолжить;
			КонецЕсли;
			ЕстьОборот = 0;
			ОтчетПроизв.ВыбратьСтроки();
            //Сообщить("По Произв:"+отчетПр.к_2+" ТТ:"+ОтчетТТ.к_9);

			номПр = 0;
			Пока ОтчетПроизв.ПолучитьСтроку() = 1 цикл
				Если (ОтчетПроизв.к_2 = отчетПр.к_2) тогда
					отчет.ВыбратьСтроки();
					ном = 0;
					текКПППост = "";
					Пока отчет.ПолучитьСтроку() = 1 цикл
						ПрСтатусБар(отчет.КоличествоСтрок(),отчет.НомерСтроки);

						Если  (((отчет.к_2 = отчетПр.к_2)и(отчет.к_6=КА))и((Отчет.к_4=ОтчетПроизв.к_4)и(Отчет.к_10=ОтчетТТ.к_10)))и(Отчет.к_5=ОтчетПроизв.к_5) тогда
							Если ЕстьОборот = 0 тогда
								   Атриб = " ПN="""+НомОбор+""" П000000000003="""+Лев(отчетПр.к_2,3)+""" ";
								ХМЛОткрытьЭлем(текст,"Оборот",Атриб);  // Табл 3.9.1
								ЕстьОборот = 1;
								НомОбор = НомОбор+1;
							КонецЕсли;

							Если ном = 0 тогда
								номПр=номПр+1;

								ХМЛОткрытьЭлем(текст,"СведПроизвИмпорт"," NameOrg="""+СтрЗаменить(СтрЗаменить(Отчет.к_3,"&","и"),"""","&quot;")+""" INN="""+Отчет.к_4+""" KPP="""+Отчет.к_5+""" ");
							ном = 1;
							КонецЕсли;

						    Атриб = "П200000000013="""+отчет.к_17+""" П200000000014="""+отчет.к_18+""" П200000000015="""+отчет.к_19+""" П200000000016="""+отчет.к_20+"""";
						//	Атриб =  "П200000000013="""+Отчет.к_17+""" П200000000014="""+Отчет.к_18+""" П200000000015="""" П200000000016="""+Отчет.к_20+""" ";
							ХМЛОткрытьЭлем(Текст,"Продукция",Атриб,1);
							Отчет.к_6 = "-1";
						КонецЕсли;

					КонецЦикла;


					Если ном = 0 тогда
                иначе
						ХМЛЗакрытьЭлем(Текст,"СведПроизвИмпорт");
					КонецЕсли;
				КонецЕсли;

			КонецЦикла;
		Если ЕстьОборот = 1 тогда
			ХМЛЗакрытьЭлем(Текст,"Оборот");
		КонецЕсли;
	КонецЦикла;

ХМЛЗакрытьЭлем(Текст,"Документ");


}
  //lists.Free;
end;

procedure TFormExportDecAlc.BitBtn4Click(Sender: TObject);
begin
  //formexportform12.flStartDate:=;
  formexportform12.flFilter:='';///(`productvcode`="500" OR `productvcode`= "520") AND';
  formexportform12.flStartDate:=flStartDate;
  formexportform12.flEndDate:=flEndDate;
  formexportform12.ShowModal;
end;

procedure TFormExportDecAlc.BitBtn5Click(Sender: TObject);
begin
  formexportform12.flFilter:='';// (`productvcode`<>"500" OR `productvcode`<> "520") AND';
  formexportform12.flStartDate:=flStartDate;
  formexportform12.flEndDate:=flEndDate;
  formexportform12.ShowModal;
end;

end.

