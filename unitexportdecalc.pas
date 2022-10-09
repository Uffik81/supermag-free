unit unitexportdecalc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, mysql50;

type

  { TFormExportDecAlc }

  TFormExportDecAlc = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    cbTransferToShop: TCheckBox;
    sdd1: TSelectDirectoryDialog;
    StaticText1: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
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
uses unitstart,unitexportform12,unitFilter, unitexportform5;
{ TFormExportDecAlc }

procedure TFormExportDecAlc.BitBtn2Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  indka:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
begin
  Lists:=TStringList.Create;
  Lists.Clear;
  indka:=1;
  Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
  Lists.add('<Справочники>');
  // ==== в цикле ===== по документам =====
  // === Цикл =====
  Query:='SELECT '+
  '`spproduct`.`productvcode`,`spproduct`.`import`,'+
  '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
  '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
  '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
  '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
  '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
  '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
  //'(SELECT `name` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameimp`,'+
  '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` ,`doc221`.`numdoc`, DATE_FORMAT(`doc221`.`datedoc`,"%d.%m.%Y"), SUM(`doc221`.`factcount`*`spproduct`.`capacity`)'
  +' FROM `doc221`,`docjurnale`,`spproduct` WHERE `doc221`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc221`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" AND `spproduct`.`alccode`=`doc221`.`alcitem` AND `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`;';
  xrecbuf:=formstart.DB_Query(Query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
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
  Lists.add('<Производитель value="True"/>');
  Lists.add('<Перевозчик value="False"/>');
  Lists.add('</Резидент>');
  Lists.add('</Контрагенты>');
  end;
  Lists.add('</Справочники>');
  if sdd1.Execute then begin
    lists.Text:=utf8toansi(lists.Text);
    lists.SaveToFile(sdd1.FileName+'\spproducer.xml');
    Showmessage('Сформирован!');
  end;
  Lists.free;
end;

procedure TFormExportDecAlc.BitBtn1Click(Sender: TObject);
begin
  formfilter.ShowModal;
  flStartDate:=formfilter.StartDate;
  flendDate:=formfilter.EndDate;
  Statictext1.Caption:='Период с '+FormatDateTime('DD.MM.YYYY',flStartDate)+' по '+FormatDateTime('DD.MM.YYYY',flEndDate);

end;

procedure TFormExportDecAlc.BitBtn3Click(Sender: TObject);
var
  Lists:TStringList;
  fullnameka:String;
  i:integer;
  Query:String;
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  curIdClient:string='';
  curImns:string='';
begin

  Lists:=TStringList.Create;
  Lists.Clear;
  i:=1;
  Lists.add('<?xml version="1.0" encoding="windows-1251"?>');
  Lists.add('<Файл ДатаДок="'+FormatDateTime('DD.MM.YYYY',now())+'" ВерсФорм="4.20" НаимПрог="'+NameApp+' '+CurVer+'">');
  Lists.add('<Документ>');
  // === Цикл =====
  Query:='SELECT '+
  '`spproduct`.`productvcode`,`spproduct`.`import`,'+
  '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameprod`,'+
  '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `innprod`,'+
  '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `kppprod`,'+
  '(SELECT `spproducer`.`fullname` FROM `spproducer` WHERE `spproducer`.`clientregid`=`spproduct`.`iClientRegId` limit 1) AS `nameimp`,'+
  '(SELECT `inn` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `innimp`,'+
  '(SELECT `kpp` FROM `spproducer` WHERE `clientregid`=`spproduct`.`iClientRegId` limit 1) AS `kppimp`,'+
  //'(SELECT `name` FROM `spproducer` WHERE `clientregid`=`spproduct`.`ClientRegId` limit 1) AS `nameimp`,'+
  '`spproduct`.`ClientRegId`,`spproduct`.`iClientRegId` ,`doc221`.`numdoc`, DATE_FORMAT(`doc221`.`datedoc`,"%d.%m.%Y"), SUM(`doc221`.`factcount`*`spproduct`.`capacity`)'
  +' FROM `doc221`,`docjurnale`,`spproduct` WHERE `doc221`.`datedoc`>="'+FormatDateTime('YYYY-MM-DD',flStartDate)+'" AND `doc221`.`datedoc`<="'+FormatDateTime('YYYY-MM-DD',flEndDate)+'" AND `docjurnale`.`registry`="+" AND `spproduct`.`alccode`=`doc221`.`alcitem` AND `docjurnale`.`numdoc`=`doc221`.`numdoc` AND `docjurnale`.`datedoc`=`doc221`.`datedoc` GROUP BY `spproduct`.`productvcode`,`spproduct`.`ClientRegId`;';
  xrecbuf:=formstart.DB_Query(Query);
  xrowbuf:=formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do begin
  // ==== оборот =====
  if CurIMNS<>xrowbuf[0] then  begin
    if CurIMNS<>'' then
        Lists.add('</Оборот>');
      Lists.add('<Оборот  ПN="'+inttostr(i)+'" П000000000003="'+xrowbuf[0]+'" >');
      CurIMNS:=xrowbuf[0];
      i:=i+1;
     end;

  if xrowbuf[1] <> '1' then begin
      if curIdClient<> xrowbuf[8] then  begin
          if curIdClient<>'' then
             Lists.add('</СведПроизвИмпорт>');
          Lists.add('<СведПроизвИмпорт  NameOrg="'+replacestr(xrowbuf[2],false)+'" INN="'+xrowbuf[3]+'" KPP="'+xrowbuf[4]+'" >')  ;
          curIdClient:= xrowbuf[8];
          end
    end else
      if curIdClient<> xrowbuf[8] then begin
           if curIdClient<>'' then
               Lists.add('</СведПроизвИмпорт>');
          Lists.add('<СведПроизвИмпорт  NameOrg="'+xrowbuf[5]+'" INN="'+xrowbuf[6]+'" KPP="'+xrowbuf[7]+'" >') ;
         curIdClient:= xrowbuf[8];
      end;
   Lists.add('<Продукция П200000000013="'+xrowbuf[10]+'" П200000000014="'+xrowbuf[11]+'" П200000000015="" П200000000016="'+xrowbuf[12]+'"/>');




  xrowbuf:=formstart.DB_Next(xrecbuf);
   end;
  if curIdClient<>'' then
      Lists.add('</Оборот>');
  // ==== КонецЦикла =====
  Lists.add('</Документ>');
  Lists.add('</Файл>');

  if sdd1.Execute then begin
    lists.Text:=utf8toansi(lists.Text);
    lists.SaveToFile(sdd1.FileName+'\spproduct.xml');
    Showmessage('Сформирован!');
  end;
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
  lists.Free;
end;

procedure TFormExportDecAlc.BitBtn4Click(Sender: TObject);
begin
  formexportform12.flStartDate:=flStartDate;
  formexportform12.flEndDate:=flEndDate;
  formexportform12.flForm12:=true;

  formexportform12.ShowModal;
end;

procedure TFormExportDecAlc.BitBtn5Click(Sender: TObject);
begin
  formexportform12.flStartDate:=flStartDate;
  formexportform12.flEndDate:=flEndDate;
  formexportform12.flForm12:=false;

  formexportform12.ShowModal;
end;

procedure TFormExportDecAlc.BitBtn6Click(Sender: TObject);
begin
  formexportform5.flProducerEn:=false;  // Производитель поставщик по коду ЕГАИС
  formexportform5.flTransferToShop:=not cbTransferToShop.checked;

  formexportform5.flStartDate:=flStartDate;
  formexportform5.flEndDate:=flEndDate;


  formexportform5.ShowModal;
end;

end.

