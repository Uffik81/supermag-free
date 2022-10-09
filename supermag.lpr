program supermag;
{
 Разработчик мсходного кода:Уфандеев Е.В.
 е-майл:uffik@mail.ru

}
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unitStart, unitrealttn, unitSelItem, unitJurnale, unitOptions,
  unitBuyTTH, unitInsertINN, unitFilter, unitInvent, unitOstatok, unitTicket,
  unitSelectTov, unitActwriteoff, datetimectrls, printer4lazarus, pack_powerpdf,
  laz_fpspreadsheet, unitaddFormB, unitInfo, unitSelectProd, unitEditFormA,
  unitViewReport, unitInv2, unitSpProducer, unitspProduct, unitRepOborot,
  unitReport, unitWayBillAct, unitSetPasswordAdmin, unitAddOptions,
  unitLoginAdmin, unitResendDoc, unitSupportUTM, unitdocdelete, unitViewOborot,
  unitReportClient, lazreportpdfexport, unitreturnttn, unitspkass, unitlogging,
  unitframework, unitsetpdf417, unitpdf417, unitinputprice, unitrepoborotap,
  unitexportdecalc, unitcashreport, unitreportoborot, unitaddbarcode,
  unitselectproduct, unittransfercash, unitedititem, unitinputsumm,
  unitsetalcdate, unitActChargeOnShop, unitshoprest, unittransfertoshop,
  unitactwriteoffshop, unitexportform12, unitsendnumber, unitalcitem,
  unitspgoods, unitPrintPDF417, unitquerypdf417, unitInventShop, unitShowStatus,
  unitRegClient, unitunlockscreen, unitReportSalesGoods, unitexportform5,
  unitcomment, unitCheckedMark, uniteditproducer, unitcommon, unituserloginv2,
  unitsendemails, unitSalesBeerTS, unitjurnalets, unitinputstring,
  uniteditgroup, unitNews, unitselgroup, unitspusers, unitspfastgood,
  Unitdevices, unitextreport, unitEditFormCheck, unitprintticket,
  unitvisualfindgoods, unitvisualselectgoods, unitloginuserv3,
  unitvisualselecttable, unitinputsummv2, unitInputQuantity, unitactwriteoffts,
  unitActWriteBeer, frameworkmodules, unitvikisetting, unitshowmessage,
  unitwaybillv2, unitshoptotransfer, unitupdatetransfer, udiscountcard,
  uspdiscountcards, unitAddFormBv2, unitcigar, unitcashfilter, univiewcheck,
  unitJurnaleAlcForms, unitJurnaleInWayBills
  , UniqueInstanceRaw;
  { you can add units after this }

{$R *.res}
const
  sUniqueMutexName = 'supermag_TestMutex'; // это просто уникальная строка для мьютекса
  sMainTitle = 'УНИВЕРСАЛЬНЫЙ КАССОВЫЙ МОДУЛЬ'; // это должно совпадать с заголовком главной формы приложения

begin
    if InstanceRunning(sUniqueMutexName) then begin
        Application.MessageBox(pchar('Ошибка запуска'),pchar('Можно запустить только одну версию программы!'));
        exit;
    end;
  Application.Title:=sMainTitle;
    RequireDerivedFormResource := True;
    Application.Initialize;
    Application.CreateForm(TFormStart, FormStart);
    Application.CreateForm(TFormRealTTN, FormRealTTN);
    Application.CreateForm(TFormSelItem, FormSelItem);
    Application.CreateForm(TFormJurnale, FormJurnale);
    Application.CreateForm(TFormOptions, FormOptions);
    Application.CreateForm(TFormBuyTTH, FormBuyTTH);
    Application.CreateForm(TFormInsertINN, FormInsertINN);
    Application.CreateForm(TFormFilter, FormFilter);
    Application.CreateForm(TFormInvent, FormInvent);
    Application.CreateForm(TFormOstatok, FormOstatok);
    Application.CreateForm(TFormTicket, FormTicket);
    Application.CreateForm(TFormSelectTov, FormSelectTov);
    Application.CreateForm(TFormActwriteoff, FormActwriteoff);
    Application.CreateForm(TFormAddFormB, FormAddFormB);
    Application.CreateForm(TFormInfo, FormInfo);
    Application.CreateForm(TFormSelectProd, FormSelectProd);
    Application.CreateForm(TFormEditFormA, FormEditFormA);
    Application.CreateForm(TFormViewReport, FormViewReport);
    Application.CreateForm(TFormInv2, FormInv2);
    Application.CreateForm(TFormSpProducer, FormSpProducer);
    Application.CreateForm(TFormSpProduct, FormSpProduct);
    Application.CreateForm(TFormRepOborot, FormRepOborot);
    Application.CreateForm(TFormReport, FormReport);
    Application.CreateForm(TFormWayBillAct, FormWayBillAct);
    Application.CreateForm(TFormSetPasswordAdmin, FormSetPasswordAdmin);
    Application.CreateForm(TFormAddOptions, FormAddOptions);
    Application.CreateForm(TFormLoginAdmin, FormLoginAdmin);
    Application.CreateForm(TFormDocDelete, FormDocDelete);
    Application.CreateForm(TFormResendDoc, FormResendDoc);
    Application.CreateForm(TFormSupportUTM, FormSupportUTM);
    Application.CreateForm(TFormViewOborot, FormViewOborot);
    Application.CreateForm(TFormReportClient, FormReportClient);
    Application.CreateForm(TFormReturnTTN, FormReturnTTN);
    Application.CreateForm(TFormSpKass, FormSpKass);
    Application.CreateForm(TFormLogging, FormLogging);
    Application.CreateForm(TFormSetPDF417, FormSetPDF417);
    Application.CreateForm(TFormgetpdf417, Formgetpdf417);
    Application.CreateForm(TFormInputPrice, FormInputPrice);
    Application.CreateForm(TFormRepOborotAP, FormRepOborotAP);
    Application.CreateForm(TFormExportDecAlc, FormExportDecAlc);
    Application.CreateForm(TFormCashReport, FormCashReport);
    Application.CreateForm(TFormReprotOborot, FormReprotOborot);
    Application.CreateForm(TFormAddBarcode, FormAddBarcode);
    Application.CreateForm(TFormSelectProduct, FormSelectProduct);
    Application.CreateForm(TFormTransferCash, FormTransferCash);
    Application.CreateForm(TFormEditItem, FormEditItem);
    Application.CreateForm(TFormInputSumm, FormInputSumm);
    Application.CreateForm(TFormSetAlcDate, FormSetAlcDate);
    Application.CreateForm(TFormActChargeOnShop, FormActChargeOnShop);
    Application.CreateForm(TFormShopRest, FormShopRest);
    Application.CreateForm(TFormTransferToShop, FormTransferToShop);
    Application.CreateForm(TFormActWriteOffShop, FormActWriteOffShop);
    Application.CreateForm(TFormExportForm12, FormExportForm12);
    Application.CreateForm(TFormsendnumber, Formsendnumber);
    Application.CreateForm(TFormAclItem, FormAclItem);
    Application.CreateForm(TFormSpGoods, FormSpGoods);
    Application.CreateForm(TFormPrintPDF417, FormPrintPDF417);
    Application.CreateForm(TFormQueryPDF417, FormQueryPDF417);
    Application.CreateForm(TFormInventShop, FormInventShop);
    Application.CreateForm(TFormShowStatus, FormShowStatus);
    Application.CreateForm(TFormRegclient, FormRegclient);
    Application.CreateForm(TFormUnlockScreen, FormUnlockScreen);
    Application.CreateForm(TFormReportSalesGoods, FormReportSalesGoods);
    Application.CreateForm(TFormExportForm5, FormExportForm5);
    Application.CreateForm(TFormComment, FormComment);
    Application.CreateForm(TFormCheckedMark, FormCheckedMark);
    Application.CreateForm(TFormEditProducer, FormEditProducer);
    Application.CreateForm(TFormUserLoginv2, FormUserLoginv2);
    Application.CreateForm(TFormSendEMails, FormSendEMails);
    Application.CreateForm(TFormSalesBeerTS, FormSalesBeerTS);
    Application.CreateForm(TFormJurnaleTS, FormJurnaleTS);
    Application.CreateForm(TFormInputString, FormInputString);
    Application.CreateForm(TFormEditGroup, FormEditGroup);
    Application.CreateForm(TFormNews, FormNews);
    Application.CreateForm(TFormSelGroup, FormSelGroup);
    Application.CreateForm(TFormSpUsers, FormSpUsers);
    Application.CreateForm(TFormspfastgood, Formspfastgood);
    Application.CreateForm(TFormExtReport, FormExtReport);
    Application.CreateForm(TFormEditFormCheck, FormEditFormCheck);
    Application.CreateForm(TFormPrintTicket, FormPrintTicket);
    Application.CreateForm(TFormVisualFindGoods, FormVisualFindGoods);
    Application.CreateForm(TFormVisualSelectGoods, FormVisualSelectGoods);
    Application.CreateForm(TFormLoginUserV3, FormLoginUserV3);
    Application.CreateForm(TFormVisualSelectTable, FormVisualSelectTable);
    Application.CreateForm(TFormInputSummv2, FormInputSummv2);
    Application.CreateForm(TFormInputQuantity, FormInputQuantity);
    Application.CreateForm(TFormActWriteOffTS, FormActWriteOffTS);
    Application.CreateForm(TFormActWriteBeer, FormActWriteBeer);
    Application.CreateForm(TFormvikisetting, Formvikisetting);
    Application.CreateForm(TFormShowMessage, FormShowMessage);
    Application.CreateForm(TFormShopToTransfer, FormShopToTransfer);
    Application.CreateForm(TFormWayBillv2, FormWayBillv2);
    Application.CreateForm(TFormUpdateTransfer, FormUpdateTransfer);
    Application.CreateForm(TFormSpDiscountCards, FormSpDiscountCards);
    Application.CreateForm(TFormDiscountCard, FormDiscountCard);
    Application.CreateForm(TFormAddFormBv2, FormAddFormBv2);
    Application.CreateForm(TFormCigar, FormCigar);
    Application.CreateForm(TFormCashFilter, FormCashFilter);
    Application.CreateForm(TFormViewCheck, FormViewCheck);
    Application.CreateForm(TFormJurnaleAlcForms, FormJurnaleAlcForms);
    Application.CreateForm(TFormJurnaleInWayBills, FormJurnaleInWayBills);
    Application.Run;

end.

