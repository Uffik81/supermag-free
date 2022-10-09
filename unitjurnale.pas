{
  Журнал документов
}

unit unitJurnale;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, LR_Desgn, Forms, Controls, Graphics,
  Dialogs, Menus, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, types, mysql50,
  LCLIntf, LCLType, ExtDlgs, LazHelpHTML, modulemercury, attabs;

type

  {панель навигации}
  TItemMenuPanel = record
    ItemMenu:TStaticText;
    PanelMenu:TPanel;
    FunctionName:String;
    SubGroup:boolean;
  end;
  TMenuPanel = record
     Panel:TPanel;
     SizaPanel:integer;
  end;
  {TODPageControl}
  TODPageControl = class(TPageControl)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  override;
    procedure PaintWindow(DC: HDC); override;
    procedure DestroyWnd; override;
  private
    FCanvas: TCanvas;
    FBitmap: TBitmap;
  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
  end;

type


  { TFormJurnale }

  TFormJurnale = class(TForm)
    FATTabControl:TATTabs;
    bbEgais: TBitBtn;
    bbEgais1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn8: TBitBtn;
    cldDialog: TCalendarDialog;
    frDesigner1: TfrDesigner;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    Image1: TImage;
    ImageList1: TImageList;
    ilDocIcons: TImageList;
    ListView3: TListView;
    ListView5: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuAddGoods: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    miChecketMark: TMenuItem;
    miWriteOnShop: TMenuItem;
    miInventShop: TMenuItem;
    miWriteOffShop: TMenuItem;
    miOtherOpenDoc: TMenuItem;
    miPrintPDF417: TMenuItem;
    miQueryShopRest1: TMenuItem;
    miShowRest1: TMenuItem;
    miFullReportRest: TMenuItem;
    miSmallReportRest: TMenuItem;
    miExportXLS: TMenuItem;
    miQueryRest1: TMenuItem;
    miDeclarantAlco: TMenuItem;
    miTransferToShop: TMenuItem;
    miInfoGoodsINN: TMenuItem;
    miInfoGoodsAlcCode: TMenuItem;
    miTransferShop: TMenuItem;
    miReportOstatok: TMenuItem;
    Panel1: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    pmMenuCash: TPopupMenu;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
    pnlUserPolice: TPanel;
    pmRJSelect: TMenuItem;
    miReturnTTN: TMenuItem;
    MenuSubGoods: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    pmRetJurnale: TPopupMenu;
    pmInfoGoods: TPopupMenu;
    pmMenuShop: TPopupMenu;
    pmRestOwner1: TPopupMenu;
    pmOtherDocs: TPopupMenu;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    sgShopRest: TStringGrid;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    sgSalesOpt: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet8: TTabSheet;
    ToggleBox1: TToggleBox;
    tbrejected: TToggleBox;
    ToggleBox2: TToggleBox;
    tbNotAccept: TToggleBox;
    tbError: TToggleBox;
    tbIssue: TToggleBox;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolBar4: TToolBar;
    ToolBar5: TToolBar;
    //procedure if(Sender: TObject);
    procedure bbCloseTab1Click(Sender: TObject);
    procedure bbCloseTabClick(Sender: TObject);
    procedure bbEgaisClick(Sender: TObject);
    procedure bbRefGoodsClick(Sender: TObject);
    procedure bbRefreshShopClick(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn28Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuAddGoodsClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem42Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem44Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure MenuItem48Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem53Click(Sender: TObject);
    procedure MenuItem54Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem56Click(Sender: TObject);
    procedure MenuItem58Click(Sender: TObject);
    procedure MenuItem59Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure MenuItem62Click(Sender: TObject);
    procedure MenuItem63TransferClick(Sender: TObject);
    procedure MenuItem64Click(Sender: TObject);
    procedure MenuItem65Click(Sender: TObject);
    procedure MenuItem66Click(Sender: TObject);
    procedure MenuItem67Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuSubGoodsClick(Sender: TObject);
    procedure miChecketMarkClick(Sender: TObject);
    procedure miDeclarantAlcoClick(Sender: TObject);
    procedure miExportXLSClick(Sender: TObject);
    procedure miFullReportRestClick(Sender: TObject);
    procedure miGoodForSalesClick(Sender: TObject);
    procedure miInfoGoodsAlcCodeClick(Sender: TObject);
    procedure miInfoGoodsINNClick(Sender: TObject);
    procedure miInventShopClick(Sender: TObject);
    procedure miOtherOpenDocClick(Sender: TObject);
    procedure miPrintPDF417Click(Sender: TObject);
    procedure miQueryListDocsClick(Sender: TObject);
    procedure miQueryRest1Click(Sender: TObject);
    procedure miQueryShopRest1Click(Sender: TObject);
    procedure miQueryTTNClick(Sender: TObject);
    procedure miReportOstatokClick(Sender: TObject);
    procedure miReturnTTNClick(Sender: TObject);
    procedure miShowRest1Click(Sender: TObject);
    procedure miSmallReportRestClick(Sender: TObject);
    procedure miTransferShopClick(Sender: TObject);
    procedure miTransferToShopClick(Sender: TObject);
    procedure miWriteOffShopClick(Sender: TObject);
    procedure miWriteOnShopClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Resize(Sender: TObject);
    procedure pmRJSelectClick(Sender: TObject);
    procedure pnlFWOptionsClick(Sender: TObject);
    procedure pnlNewsClick(Sender: TObject);
    procedure sgSalesOptDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgSalesOptMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure sgSalesOptMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgSalesOptMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgShopRestDblClick(Sender: TObject);
    procedure sgShopRestDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgShopRestResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure StaticText13Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText1MouseLeave(Sender: TObject);
    procedure StaticText1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StaticText2Click(Sender: TObject);
    procedure StringGrid1MouseEnter(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet1Resize(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure TabSheet8ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbCashReportShow(Sender: TObject);
    procedure tbErrorChange(Sender: TObject);
    procedure ToggleBox1Click(Sender: TObject);
    procedure ToggleBox2Change(Sender: TObject);
    procedure tsAlcDeclShow(Sender: TObject);
    procedure tsEditCheckFormShow(Sender: TObject);
    procedure tsFastGoodsShow(Sender: TObject);
    procedure tsFirmOptionsShow(Sender: TObject);
    procedure tsFWOptionsShow(Sender: TObject);
    procedure tsHomePageShow(Sender: TObject);
    procedure tsPrintTicketShow(Sender: TObject);
    procedure tsSprAlcItemsShow(Sender: TObject);
    procedure tsSprGoodsShow(Sender: TObject);
    procedure tsSprProducerShow(Sender: TObject);
    procedure tsUserPoliceShow(Sender: TObject);
    procedure tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
    procedure pbbClick(Sender: TObject); // ====
    procedure pmiClick(Sender: TObject); // ====
    procedure pmiMouseLeave(Sender: TObject);
    procedure pmiMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TabCloseEvent(Sender: TObject; ATabIndex: integer;
    var ACanClose, ACanContinue: boolean);
    procedure TabSelectEvent(Sender: TObject);
  private
    { private declarations }
    idRetJurnaleRowSelect:integer;
    arrPanelItem:array[0..100] of TItemMenuPanel;
  public
    { public declarations }
    CountPanelItemMenu:integer;
    CountPanelMenu:integer;
    endDateRetTTN,
    startDateRetTTN,
    endDateOutTTN,
    startDateOutTTN,
    startDateInTTN,
    endDateInTTN:TdateTime;
    startdateStock:TdateTime;  // начальный период складских документов
    endDateStock:TdateTime;
    FiltrIn:String;
    FiltrOut:String;
    flGroupGoods:TStringList;
    //selRowRetJurnale:integer;
    procedure refreshJurnaleIn();
    procedure refreshJurnaleOut();
    procedure refreshRests();
    Procedure refreshReply();
    procedure RefreshNumFix();
    procedure RefreshNumFormB();
    Procedure refreshJurnaleRet();
    function addPanel(aName:String):TPanel;
    function AddPanelItemMenu(aName:string;owPanel:TPanel;flSubItem:boolean;aFunct:String):integer;
    procedure AutoSendTransferToShop;
    function GetTabStatisVisible(Obj:TForm):boolean;
  end;

var
  FormJurnale: TFormJurnale;

implementation

{$R *.lfm}
uses unitStart,
  unitOptions,
  unitrealttn,
  unitBuyTTH,
  unitInsertINN,
  unitFilter,
  unitInvent,
  unitOstatok,
  unitTicket,
  unitActWriteOff,
  unitInfo,
  unitInv2,
  unitspproduct,
  unitspproducer,
  unitRepOborot,
  unitWayBillAct,
  unitLoginAdmin,
  unitResendDoc,
  unitDocDelete,
  unitViewOborot,
  unitreportclient,
  unitreturnttn,
  unitspkass,
  unitsalesbeer,
  unitrepoborotap,
  unitcashreport,
  unitreportoborot,
  unittransfercash,
  unitpdf417,
  unitactchargeonshop,
  unitshoprest,
  unittransfertoshop,
  unitactwriteoffshop,
  unitexportdecalc,
  unitspgoods,
  unitPrintPDF417,
  unitInventShop,
  unitquerypdf417
  ,unitReportSalesGoods
  ,unitspusers
  ,unitlogging
  ,unitcheckedmark
  ,unitspfastgood
  ,unitnews
  ,math
  ,unitEditFormCheck,
  unitprintticket,
  unitloginuserv3
  ,unitactwritebeer
  ,unitshoptotransfer
  ,unitwaybillv2
  ,uspdiscountcards
  ,unitupdatetransfer
  ,unitJurnaleAlcForms
  ,unitJurnaleStocks
  ,unitJurnaleInWayBills
  ,unitJurnaleDocCash
  ,unithonestsign // Список Деклараций
  ,unitJurnaleReturnWaybill;
{ TFormJurnale }

const
  ls1_Date     = 1;
  ls1_Kontr    = 2;
  ls1_Summ     = 3;
  ls1_Status   = 4;
  ls1_docEgais = 5;

  ls2_Date     = 0;
//  ls2_Kontr    = 1;
//  ls2_Summ     = 2;
//  ls2_Status   = 3;
  ls2_docEgais = 4;
var
  userplc:TPolices;


{ TODPageControl }

procedure TODPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  r:TRect;
  i, h2:integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TODPageControl.PaintWindow(DC: HDC);
const
  FColorBg:TColor= clBlack;
  FColorDrop:TColor= $6060E0;
  FColorTabActive:TColor= $808080;
  FColorTabPassive:TColor= $786868;
  FColorTabOver:TColor= $A08080;
  FColorFontModified:TColor= $A00000;
  FColorBorderActive:TColor= $A0A0A0;
  FColorBorderPassive:TColor= $A07070;
  FColorCloseBg:TColor= clNone;
  FColorCloseBgOver:TColor= $6060E0;
  //FColorCloseBorderOver:TColor= FColorCloseBgOver;
  FColorCloseX:TColor= clLtGray;
  FColorCloseXOver:TColor= clWhite;
  FColorArrow:TColor= $999999;
  FColorArrowOver:TColor= $E0E0E0;

  FTabBottom= false;
  FTabAngle= {$ifdef darwin} 0 {$else} 5 {$endif};
  FTabHeight= 24;
  FTabWidthMin= 20;
  FTabWidthMax= 130;
  FTabWidthHideX= 55;
  FTabNumPrefix= '';
  FTabIndentLeft= 6;
  FTabIndentDropI= 4;
  FTabIndentInter= 0;
  FTabIndentInit= 4;
  FTabIndentTop= 5;
  FTabIndentXRight= 10;
  FTabIndentXInner= 4;
  FTabIndentXSize= 12;
  FTabIndentArrowSize= 4;
  FTabIndentArrowLeft= 4;
  FTabIndentArrowRight= 20;
  FTabIndentColor= 3;
var r:TRect;
    points: array[0..1] of TPoint;
    i, h, h2: Integer;
   ATabBg:TColor;
   PX1, PX2, PX3, PX4, PXX1, PXX2: TPoint;
   C:TCanvas;
   SelInd:integer;
begin
  inherited PaintWindow(DC);
//  if FCanvas<>nil then begin
  C:=FCanvas;
  for i:=0 to PageCount-1 do begin
    begin
    c.Handle:=DC;
    r:= TabRect(i);
    SelInd:= self.PageIndex;
    R.Right:=R.Right-1;
    R.Left:= R.Right-16;
    R.top:=R.Top+2;
    R.Bottom:=R.Bottom-2;

      C.Brush.Color:= IfThen(ActivePage = pages[i], FColorCloseBg, FColorCloseBgOver);
      C.FillRect(R);
      C.Pen.Color:= IfThen(ActivePage = pages[i], FColorCloseBg, FColorCloseBgOver);
      C.Rectangle(R);
      C.Brush.Color:= FColorCloseBgOver; //FColorCloseBgOver;

      //paint cross by 2 polygons, each has 6 points (3 points at line edge)
      C.Brush.Color:= IfThen(ActivePage = pages[i], FColorCloseX, FColorCloseXOver);; //ATabCloseXMark;
      C.Pen.Color:= IfThen(ActivePage = pages[i], FColorCloseX, FColorCloseXOver);; //ATabCloseXMark;

      PXX1:= Point(R.Left+FTabIndentXInner, R.Top+FTabIndentXInner);
      PXX2:= Point(R.Right-FTabIndentXInner-1, R.Bottom-FTabIndentXInner-1);
      PX1:= Point(PXX1.X+1, PXX1.Y);
      PX2:= Point(PXX1.X, PXX1.Y+1);
      PX3:= Point(PXX2.X-1, PXX2.Y);
      PX4:= Point(PXX2.X, PXX2.Y-1);
      C.Polygon([PX1, PXX1, PX2, PX3, PXX2, PX4]);

      PXX1:= Point(R.Right-FTabIndentXInner-1, R.Top+FTabIndentXInner);
      PXX2:= Point(R.Left+FTabIndentXInner, R.Bottom-FTabIndentXInner-1);
      PX1:= Point(PXX1.X-1, PXX1.Y);
      PX2:= Point(PXX1.X, PXX1.Y+1);
      PX3:= Point(PXX2.X+1, PXX2.Y);
      PX4:= Point(PXX2.X, PXX2.Y-1);
      C.Polygon([PX1, PXX1, PX2, PX3, PXX2, PX4]);

      C.Brush.Color:= FColorCloseBg ; //ATabBg;
      c.Refresh;

    end;
  end;//for

//  end;
end;

procedure TODPageControl.DestroyWnd;
begin
  if FCanvas <> nil then
    FreeAndNil(FCanvas);
  inherited DestroyWnd;
end;

constructor TODPageControl.Create(AOnwer: TComponent);
begin
  inherited Create(AOnwer);
  FCanvas := TCanvas.Create;
  //FCanvas.Handle:=DC;
//  FBitmap:=TBitmap.Create;
//  FBitmap.PixelFormat:= pf24bit;
//  FBitmap.Width:= 60;
//  FBitmap.Height:= 60;
end;

destructor TODPageControl.Destroy;
begin
  if FCanvas<>nil then
     FCanvas.Destroy;
  inherited Destroy;
end;

procedure TFormJurnale.TabSelectEvent(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  for i:=0 to FATTabControl.TabCount-1 do
   begin
     d:= FATTabControl.GetTabData(i);
     (d.TabObject as TForm).hide;
   end;
  d:= FATTabControl.GetTabData(FATTabControl.TabIndex);
  (d.TabObject as TForm).Show;
end;

procedure TFormJurnale.TabCloseEvent(Sender: TObject; ATabIndex: integer;
var ACanClose, ACanContinue: boolean);
var
   i:integer;
   d: TATTabData;
begin
  i:=ATabIndex;
  d:=FATTabControl.GetTabData(i);
  (d.TabObject as TForm).hide;
end;

procedure TFormJurnale.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  cLoseAction:=caHide;
  if not formStart.flSuperMarket then begin
    formStart.close;
  end;
end;

procedure TFormJurnale.FormCreate(Sender: TObject);
var
  namemodule:string;

begin
  self.FATTabControl:=TATTabs.create(self.pnlUserPolice);
  self.FATTabControl.Parent:=self.pnlUserPolice;
  self.FATTabControl.Align := alTop;
  FATTabControl.ColorTabActive:= clBtnFace;
  FATTabControl.ColorFontActive:= clBlack;
  FATTabControl.OptSpaceBetweenTabs:= 8;
  FATTabControl.OptShowPlusTab:= false;
  FATTabControl.OnTabClose:=@TabCloseEvent;
  //FATTabControl.OptShowXButtons:= atbxShowNone;
  FATTabControl.OptButtonLayout:= '';
  FATTabControl.OnTabClick:= @TabSelectEvent;
  flGroupGoods:=TStringList.Create;
  namemodule:='';

  CountPanelMenu:=0;
  CountPanelItemMenu:=0;
  //self.OwnerDraw:=true;
  // ===== ЕГАИС =================
  AddPanelItemMenu('Справочники',Panel3,true,'showrest');
  AddPanelItemMenu('Подакцизный товар',Panel3,false,'showsprproduct');
  AddPanelItemMenu('Производители и импортеры',Panel3,false,'showsprproducer');

  AddPanelItemMenu('Документы ЕГАИС',Panel3,true,'show');
  AddPanelItemMenu('Входящие документы',Panel3,false,'showwaybill');
  AddPanelItemMenu('Возвраты поставшику',Panel3,false,'showretwaybill');
  AddPanelItemMenu('Складские документы',Panel3,false,'showrest');
  AddPanelItemMenu('Прочие документы',Panel3,false,'showdocjurnal3');

  AddPanelItemMenu('Отчеты',Panel3,true,'showrest');
  AddPanelItemMenu('Декларант Алко',Panel3,false,'showalcdecl');
  // ===== Розница ===============
  AddPanelItemMenu('Справочники',Panel4,true,'showrest');
  AddPanelItemMenu('Товары для кассы',Panel4,false,'showsprgoods');
  AddPanelItemMenu('Быстрые товары',Panel4,false,'showfastgood');
  AddPanelItemMenu('Карты скидок',Panel4,false,'showdiscountcards');
  //AddPanelItemMenu('Документы',Panel4,true,'showrest');
  //AddPanelItemMenu('Установка цен',Panel4,false,'showsalesrest');
  //AddPanelItemMenu('Инвентаризация',Panel4,false,'showsalesrest');
  AddPanelItemMenu('Отчеты',Panel4,true,'showtabsheet5');
  AddPanelItemMenu('Печать ценников и этикеток',Panel4,false,'showsalesticket');
  AddPanelItemMenu('Розничные продажи',Panel4,false,'showsalesorder'); // showcashreport
  //AddPanelItemMenu('Текущие остатки',Panel4,false,'showrest');
  //AddPanelItemMenu('Оборот за период',Panel4,false,'showrest');

  // ===== Закупки ===============
  // ===== Честный Знак ====
  AddPanelItemMenu('Документы',Panel11,false,'showHonestSign'); // showcashreport
  // ===== Производство ==========

  // ===== Администрирование =====
  AddPanelItemMenu('Права и пользователи',Panel5,false,'showuserpolice');
  AddPanelItemMenu('Настройки программы',Panel5,false,'showfirmopt');
  AddPanelItemMenu('Настройки оборудования',Panel5,false,'showdevopt');
  AddPanelItemMenu('Шаблон предчека',Panel5,false,'showformcheck');
  AddPanelItemMenu('Редактор шаблонов',Panel5,false,'showtempreport');
  AddPanelItemMenu('Журнал транзаций',Panel5,false,'showcashreport');

  Caption:=NameOEM+' '+NameApp+':'+namemodule+'-'+CurVer;
  endDateInTTN:=now();
  StartDateInTTN:=now();
  endDateOutTTN:=now();
  StartDateOutTTN:=now();
  startDateStock:=now();
  endDateStock:=now();
  //tsHomePage.TabVisible:=true;
  //PageControl1.ActivePage:=tsHomePage;
  //TabSheet1.Caption:='Входящие накладные ';//['+FormatDateTime('DD-MM-YYYY',StartDateInTTN)+' - '+FormatDateTime('DD-MM-YYYY',endDateInTTN)+']';
  //TabSheet2.Caption:='Реализация ТТН ['+FormatDateTime('DD-MM-YYYY',StartDateOutTTN)+' - '+FormatDateTime('DD-MM-YYYY',endDateOutTTN)+']';
  //tsSprGoods.Caption:='Основной склад ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';

end;

procedure TFormJurnale.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 18)and(Shift = [ssAlt]) then begin
    self.Menu:=mainmenu1;
    mainmenu1.Parent:=self;

  end;
end;

procedure TFormJurnale.FormResize(Sender: TObject);
begin

end;

procedure TFormJurnale.FormShow(Sender: TObject);
var
  l_rect:tRect;
  tt:TTabSheet;
  i:integer;
  d: TATTabData;
begin
  pnlUserPolice.Visible:=true;// pnlUserPolice
  FATTabControl.TabIndex:= 0;


  if db_boolean(FormStart.GetConstant('enableauth')) then
    begin
    if FormLoginUserV3.ShowModal <> 1377 then  begin
      Close;
      Application.Terminate;
    end;
  end else
   formstart.flCurUserId:='30';
  userplc:=formspusers.GetPolice(formstart.flCurUserId);
  //ShowMessage('Здесь Авторизация!!');
  left:=0;
  top:=0;
  //tsUserPolice.AddControl;
  //tsHomePage.AddControl;
  menu:=nil;
  if formstart.GetConstant('typelicense') = '999' then
     panel3.Visible:= False
  else
     panel3.Visible:= True;
  // == Если не оптовик то убираем лишнее ===
  PageControl1.Pages[1].TabVisible:= formStart.flOptMode;
  // PageControl1.Pages[5].TabVisible:= formStart.flOptMode;   // == Запрос сведений по ИНН
  //PageControl1.Pages[4].TabVisible:= formStart.flOptMode;
  // PageControl1.Pages[2].TabVisible:= formStart.flOptMode;  // == возвраты
   MenuItem23.Visible:=formStart.flOptMode;
   MenuItem23.Visible:=formStart.flOptMode;
   //BitBtn13.Visible:=formStart.flOptMode;
   MenuItem42.Visible:=formStart.flOptMode;
   MenuItem54.Visible:=not formstart.fldisableutm;
   MenuItem18.Visible:=true;
   miWriteOnShop.Visible:=not formStart.flOptMode;
   miWriteOffShop.Visible:=not formStart.flOptMode;
   menuItem33.Visible:=(formStart.flAsAdmin and formStart.flDocStatusEdit);
   menuItem33.Visible:=(formStart.flAsAdmin and formStart.flDocStatusEdit);
  // ========================================
  startDateInTTN:=now();
  EndDateInTTN:=now();
//  refreshJurnalein();
 // refreshJurnaleout();
//  refreshRests();
//  refreshReply();
 // FormatDateTime:=now();

 {tsFastGoods.TabVisible:=true;
 PageControl1.ActivePage:=tsFastGoods;
 tsFastGoods.Visible:=true;}
 {for i:=0 to PageControl1.PageCount-1 do begin
     tt:=PageControl1.Pages[i];
     tt.Visible:=True;
 end; }
 //IpHTMLPanel1.SetHtmlFromStr('');
end;

procedure TFormJurnale.ListView2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TFormJurnale.MenuAddGoodsClick(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem10Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem11Click(Sender: TObject);
var
  query:String;
begin
  // ==== выбрали расход ====

  FormStart.ConnectDB();
  Query:='SELECT docid FROM `docjurnale` WHERE (`uid`="'+Listview5.Selected.SubItems.strings[3]+'")AND( (`type`="ReplyPartner")OR(`type`="ReplyAP"));';
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  if formStart.recbuf=Nil then
    exit;
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  if formStart.rowbuf<>nil then begin
   FormStart.SaveToServerPOST(formStart.rowbuf[0],' ');
   Query:='DELETE `docjurnale` WHERE (`uid`="'+Listview5.Selected.SubItems.strings[3]+'")AND( (`type`="ReplyPartner")OR(`type`="ReplyAP"));';
   if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
      exit;
  end;
  FormStart.disconnectDB();


end;

procedure TFormJurnale.MenuItem12Click(Sender: TObject);
var
  sLine:TStringList;
  s:String;
begin
  if SaveDialog1.Execute then begin
    // == Сохраняем в файл ====
   sLine:=TStringList.Create;
   sLine.Add('');
   s:= SaveDialog1.FileName;
   if not (pos('.xml',s) >0) then
    s:= SaveDialog1.FileName+'.xml';
   sLine.SaveToFile(s);
  end;
end;

procedure TFormJurnale.MenuItem13Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem14Click(Sender: TObject);
var
  query:string;
  i:integer;
begin
  sgShopRestDblClick(nil);

end;

procedure TFormJurnale.MenuItem15Click(Sender: TObject);
var
  s1:string;
begin
  if sgShopRest.Row>0 then begin
   s1:=sgShopRest.Cells[5,sgShopRest.Row];
   formTicket.uid:=s1;
   formTicket.WBRegID:=s1;
   formTicket.DocDate:=sgShopRest.Cells[2,sgShopRest.Row];
   formTicket.DocNum:=sgShopRest.Cells[7,sgShopRest.Row];
   formTicket.ShowModal;
  end;
end;

procedure TFormJurnale.MenuItem16Click(Sender: TObject);
begin
  // Подтвердить
  if  sgSalesOpt.Row>0 then begin
   formwaybillact.docDate:=sgSalesOpt.Cells[2,sgSalesOpt.Row];
   formwaybillact.docNumber:=sgSalesOpt.Cells[1,sgSalesOpt.Row];
   formwaybillact.ShowModal;
   //FormStart.FromSaleActTTH( Listview2.Selected.Caption, Listview2.Selected.SubItems.Strings[ls2_Date],true);
  end;
end;

procedure TFormJurnale.MenuItem17Click(Sender: TObject);
begin
  // Отказать клиенту/Клиента
  if sgSalesOpt.Row>0 then begin
   //formwaybillact.ShowModal;
     FormStart.FromSaleActTTH( sgSalesOpt.Cells[1,sgSalesOpt.Row], sgSalesOpt.Cells[2,sgSalesOpt.Row],false);

  end;
end;

procedure TFormJurnale.MenuItem18Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem19Click(Sender: TObject);
begin
  // ===== Справочник товара
  formspproduct.Show;
end;

procedure TFormJurnale.MenuItem20Click(Sender: TObject);
begin
  // ===== Cghfdjxybr rjynhfutynjd
  formspproducer.Show;
end;

procedure TFormJurnale.MenuItem21Click(Sender: TObject);
// ====== Только просмотр ========
var
  Query:String;
begin
  // ==== выбрали расход ===
  if sgSalesOpt.Row>0 then begin
  formRealTTN.flReadOnly:=true;
  formRealTTN.DocNumber:= sgSalesOpt.Cells[1,sgSalesOpt.Row];
  formRealTTN.DocDate:= sgSalesOpt.Cells[2,sgSalesOpt.Row];
  formRealTTN.ShowModal;
  FormStart.disconnectDB();

  end;
end;

procedure TFormJurnale.MenuItem23Click(Sender: TObject);
begin
  // отчет по обороту товара за период
  FormRepOborot.Show;
end;

procedure TFormJurnale.MenuItem24Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem25Click(Sender: TObject);
var
  sLine:TStringList;
begin
  // ==== акт подтверждения ====
  if opendialog1.Execute then begin
    sLine:=TStringList.Create;
    sLine.LoadFromFile(OpenDialog1.FileName);
    formStart.loadWayBillAct(sLine.Text);
    sLine.Free;
  end;
end;

procedure TFormJurnale.MenuItem26Click(Sender: TObject);
begin
  FormStart.refreshEGAISReply()  ;
end;

procedure TFormJurnale.MenuItem27Click(Sender: TObject);
begin
  formStart.refreshEGAISformB();
end;

procedure TFormJurnale.MenuItem28Click(Sender: TObject);
var
  sLine:TStringList;
begin
  if opendialog1.Execute then begin
    sLine:=TStringList.Create;
    sLine.LoadFromFile(OpenDialog1.FileName);
    formStart.loadFromEGAISFormB(sLine.Text);
    sLine.Free;
  end;
end;

procedure TFormJurnale.MenuItem29Click(Sender: TObject);
var
  sLine:TStringList;
begin
  // ==== акт Waybill ====
  if opendialog1.Execute then begin
    sLine:=TStringList.Create;
    sLine.LoadFromFile(OpenDialog1.FileName);
    formStart.loadFromEGAISTTN(sLine.Text);
    sLine.Free;
  end;

end;

procedure TFormJurnale.MenuItem2Click(Sender: TObject);
begin
  formInfo.StaticText2.Caption:=formStart.curVersion;
  formInfo.ShowModal;
end;

procedure TFormJurnale.MenuItem30Click(Sender: TObject);
var
  query:string;
begin
  // === снять отказ
  if sgSalesOpt.Row>0 then begin
     Query:='UPDATE `docjurnale` SET `ClientAccept`="" WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'");';
     formStart.recbuf := formStart.DB_query(Query);
  end;
end;

procedure TFormJurnale.MenuItem31Click(Sender: TObject);
var
  query:string;
begin
  // ==== как принятый ===
  if sgSalesOpt.Row>0 then begin
     Query:='UPDATE `docjurnale` SET `status`="+++" ,`ClientAccept`="+" WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'");';
     formStart.recbuf := formStart.DB_query(Query);
   end;
end;

procedure TFormJurnale.MenuItem32Click(Sender: TObject);
var
  listid:TStringList;
  i:integer;
  query:string;
begin
  // === Восстановить историю ====
   if sgSalesOpt.Row>0 then begin
    ListId:= TStringList.Create;
    listid.Clear;
     Query:='SELECT `uid` FROM `ticket` WHERE `comment` LIKE "%'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'%";';
     formStart.recbuf := formStart.DB_query(Query);
     formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     while formStart.rowbuf<>nil do begin
       listid.Add(formStart.rowbuf[0]);
       formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     end;
     for i:=0 to listid.Count-1 do begin;
       Query:='UPDATE `ticket` SET `numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'", `datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'" WHERE `uid`="'+listid.Strings[i]+'" or `regid` ="'+listid.Strings[i]+'" ;';
       formStart.DB_query(Query);
     end;
     listid.Clear;
      Query:='SELECT `regid` FROM `ticket` WHERE `comment` LIKE "%'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'%";';
      formStart.recbuf := formStart.DB_query(Query);
      formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
      while formStart.rowbuf<>nil do begin
        listid.Add(formStart.rowbuf[0]);
        formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
      end;
      for i:=0 to listid.Count-1 do begin;
        Query:='UPDATE `ticket` SET `numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'", `datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'" WHERE `uid`="'+listid.Strings[i]+'" or `regid` ="'+listid.Strings[i]+'" ;';
        formStart.DB_query(Query);
      end;
    listId.free;
   end;
end;

procedure TFormJurnale.MenuItem34Click(Sender: TObject);
begin
  //hide;
  if formLoginAdmin.ShowModal=1377 then
   begin
    formStart.flAsAdmin:=true;
    menuItem33.Visible:=(formStart.flAsAdmin and formStart.flDocStatusEdit);
    caption:=caption+' [Администратор]';
   end;

  //show;
end;

procedure TFormJurnale.MenuItem35Click(Sender: TObject);
begin
end;

procedure TFormJurnale.MenuItem36Click(Sender: TObject);
var
  query:string;
accept:string;
i1:integer;
begin
  // === Пометить на удаление исходящие документы ===
  if sgSalesOpt.Row>0 then begin
     //isDelete
   accept:='';
   Query:='SELECT ClientAccept,status FROM `docjurnale` WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'");';
   formStart.recbuf := formStart.DB_query(Query);
   formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
   if formStart.rowbuf<>nil then
     accept:=formStart.rowbuf[0];
   if accept='+' then
    begin
     showmessage('Нельзя удалить принятый клиентом документ!');
     exit;
    end ;

   i1:=MessageDlg('Уверены что хотите пометить на удаление?',mtConfirmation,mbYesNo,0);
  if i1 = 6 then
  begin
     Query:='UPDATE `docjurnale` SET `isdelete`="+" WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'");';
     formStart.recbuf := formStart.DB_query(Query);
    end;
  end;
end;

procedure TFormJurnale.MenuItem37Click(Sender: TObject);
var
  listid:TStringList;
  i:integer;
  query:string;
begin
  // === Восстановить историю ====
 {  if Listview1.Selected <> nil then begin
    ListId:= TStringList.Create;
    listid.Clear;
     Query:='SELECT `uid` FROM `ticket` WHERE `comment` LIKE "%№'+Listview1.Selected.Caption+' %";';
     formStart.recbuf := formStart.DB_query(Query);
     formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     while formStart.rowbuf<>nil do begin
       listid.Add(formStart.rowbuf[0]);
       formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     end;
     for i:=0 to listid.Count-1 do begin;
       Query:='UPDATE `ticket` SET `numdoc`="'+Listview1.Selected.Caption+'", `datedoc`="'+Listview1.Selected.SubItems.Strings[ls2_Date]+'" WHERE `uid`="'+listid.Strings[i]+'" or `regid` ="'+listid.Strings[i]+'" ;';
       formStart.DB_query(Query);
     end;
     listid.Clear;
      Query:='SELECT `regid` FROM `ticket` WHERE `comment` LIKE "%№'+Listview1.Selected.Caption+' %";';
      formStart.recbuf := formStart.DB_query(Query);
      formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
      while formStart.rowbuf<>nil do begin
        listid.Add(formStart.rowbuf[0]);
        formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
      end;
      for i:=0 to listid.Count-1 do begin;
        Query:='UPDATE `ticket` SET `numdoc`="'+Listview1.Selected.Caption+'", `datedoc`="'+Listview1.Selected.SubItems.Strings[ls2_Date]+'" WHERE `uid`="'+listid.Strings[i]+'" or `regid` ="'+listid.Strings[i]+'" ;';
        formStart.DB_query(Query);
      end;
    listId.free;
   end;   }

end;

procedure TFormJurnale.MenuItem39Click(Sender: TObject);
var
  query:string;
begin
  // ==== как принятый ===
{  if Listview1.Selected <> nil then begin
     Query:='UPDATE `docjurnale` SET `status`="+++" WHERE (`numdoc`="'+Listview1.Selected.Caption+'")AND(`datedoc`="'+Listview1.Selected.SubItems.Strings[ls2_Date]+'");';
     formStart.recbuf := formStart.DB_query(Query);
   end;
      }
end;

procedure TFormJurnale.MenuItem3Click(Sender: TObject);
begin
  if formStart.flUpdateAdmin then begin
   if not formStart.flAsAdmin then
     exit;
  end;
  if formStart.flOptMode then begin
    formStart.loadFromFileTTN();
  end;
  FormStart.refreshEGAIS();
  StatusBar1.Panels.Items[0].Text:='Обновили!';
end;

procedure TFormJurnale.MenuItem40Click(Sender: TObject);
var
  query:string;
begin
  // ==== как принятый ===
{  if Listview1.Selected <> nil then begin
     Query:='UPDATE `docjurnale` SET `ClientAccept`="+" WHERE (`numdoc`="'+Listview1.Selected.Caption+'")AND(`datedoc`="'+Listview1.Selected.SubItems.Strings[ls2_Date]+'");';
     formStart.recbuf := formStart.DB_query(Query);
   end;

    }
end;

procedure TFormJurnale.MenuItem41Click(Sender: TObject);
begin
  FormDocDelete.ShowModal;
end;

procedure TFormJurnale.MenuItem42Click(Sender: TObject);
begin
  // === Оборот по Справке Б ====
{  if Listview4.Selected <> nil then begin
    formViewOborot.selWBRegId:=Listview4.Selected.SubItems.Strings[3];;
    formViewOborot.ShowModal;

  end; }
end;

procedure TFormJurnale.MenuItem43Click(Sender: TObject);
var
  sLine:TStringList;
begin
  if opendialog1.Execute then begin
    sLine:=TStringList.Create;
    sLine.LoadFromFile(OpenDialog1.FileName);
    formStart.loadFromEGAISRestsShop_v2( SLine.Text);
    sLine.Free;
  end;

end;

procedure TFormJurnale.MenuItem44Click(Sender: TObject);
begin
  formReportClient.frReport1.DesignReport;
end;

procedure TFormJurnale.MenuItem45Click(Sender: TObject);
begin
  // === Справочник кассовых мест ====
  FormSpKass.showmodal;
end;

procedure TFormJurnale.MenuItem46Click(Sender: TObject);
begin
  formsalesbeer.PrintAlcReport(FormatDateTime('YYYY-MM-DD',now()));
end;

procedure TFormJurnale.MenuItem47Click(Sender: TObject);
begin
 // =======================
  //hide;
  formrepoborotap.showmodal;
  //show;
  //=======================
end;

procedure TFormJurnale.MenuItem48Click(Sender: TObject);
begin
  //hide;
  formcashreport.showmodal;
  //show;
end;

procedure TFormJurnale.MenuItem4Click(Sender: TObject);
begin
end;

procedure TFormJurnale.MenuItem53Click(Sender: TObject);
begin
  //hide;
  formshoprest.ShowModal;
  //show;
end;

procedure TFormJurnale.MenuItem54Click(Sender: TObject);
begin
  //hide;
  formrepoborotap.showmodal;
  //show;
end;

procedure TFormJurnale.MenuItem55Click(Sender: TObject);
begin
  FormReportSalesGoods.ShowModal;
end;

procedure TFormJurnale.MenuItem56Click(Sender: TObject);
begin
  formsalesbeer.PrintAlcReport(FormatDateTime('YYYY-MM-DD',now()));
end;

procedure TFormJurnale.MenuItem58Click(Sender: TObject);
begin
  FormInfo.BitBtn1Click(nil);
end;

procedure TFormJurnale.MenuItem59Click(Sender: TObject);
var
  sLine:TstringList;
begin
  formstart.flRMKOffline:=true;
  sLine:=TstringList.Create;
  if formstart.flRMKFolderLoad[length(formstart.flRMKFolderLoad)]<>'\' then
     formstart.flRMKFolderLoad:=formstart.flRMKFolderLoad+'\';
  try
    sline.LoadFromFile(formstart.flRMKFolderLoad+formstart.flRMKFileLoad);

  except
    showmessage('Ошибка чтения файла:'+formstart.flRMKFolderLoad+formstart.flRMKFileLoad);
  end;
  formstart.LoadShtrihMFile(sLine.Text);
  sLine.Free;
end;

procedure TFormJurnale.MenuItem5Click(Sender: TObject);
begin
end;

procedure TFormJurnale.MenuItem61Click(Sender: TObject);
begin
  FormLogging.Show;
end;

procedure TFormJurnale.MenuItem62Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuItem63TransferClick(Sender: TObject);
begin
  formshoptotransfer.NowDocument;
end;

procedure TFormJurnale.MenuItem64Click(Sender: TObject);
begin
  formInventShop.NewDocAP();
  TabSheet7Show(sender);
end;

procedure TFormJurnale.MenuItem65Click(Sender: TObject);
begin
  formInventShop.NewDocBeer();
  TabSheet7Show(sender);
end;

procedure TFormJurnale.MenuItem66Click(Sender: TObject);
begin

  formwaybillv2.NowDocument;

end;

procedure TFormJurnale.MenuItem67Click(Sender: TObject);
var
  xrowbuf : MYSQL_ROW;
  xrecbuf : PMYSQL_RES;
  query:string;
  i:integer;
begin
  if sgSHopRest.Cells[8,sgSHopRest.row] = 'ActShopFromTransfer' then   begin

    //formShopToTransfer.
    //FormWayBillv2.OpenDocument(sgSHopRest.Cells[7,sgSHopRest.row],sgSHopRest.Cells[2,sgSHopRest.row]);
    FormWayBillv2.flNow:=true;
    FormWayBillv2.edNumDoc.Text:=sgSHopRest.Cells[7,sgSHopRest.row];
    FormWayBillv2.dpDateDoc.Date:=formStart.Str1ToDate(sgSHopRest.Cells[2,sgSHopRest.row]);
    //FormWayBillv2.flnow:=false;
    FormWayBillv2.flMove:=true;
    FormWayBillv2.flEditing:=true;
    FormWayBillv2.flClient:='';
    FormWayBillv2.stringgrid1.RowCount:=1;
    FormWayBillv2.stNameClient.Caption:='';
    FormWayBillv2.stDescription.Caption:='';
//    xrecbuf:=FormStart.DB_Query('SELECT `ClientRegId` FROM `docjurnale` WHERE (`datedoc`="'+FormWayBillv2.DateDoc+'")AND(`numdoc`="'+FormWayBillv2.edNumDoc.Text+'") AND `type`="MoveWayBill";'  );
//    xrowbuf:=formStart.DB_Next(xrecbuf);
//    if xrowbuf<> nil then begin
//       FormWayBillv2.flClient:=xrowbuf[0];
//      end ;
//    xrecbuf:=FormStart.DB_Query('SELECT `fullname`,`inn`,`kpp`,`description` FROM `spproducer` WHERE `clientregid`="'+FormWayBillv2.flClient+'";'  );
//    xrowbuf:=formStart.DB_Next(xrecbuf);
//    if xrowbuf<> nil then begin
//       FormWayBillv2.stNameClient.Caption:=xrowbuf[0];
//       FormWayBillv2.stDescription.Caption:=xrowbuf[3];
//      end ;
    Query:='SELECT (SELECT `name` FROM `spproduct` WHERE `spproduct`.`alccode`=`doc31`.`alccode` LIMIT 1) AS `tovar`,'+
     '"0",`alccode`,`quality`,'+
     '(select `informaregid` from `regrestsproduct` where `regrestsproduct`.`informbregid`=`doc31`.`form2` limit 1) as `form11`,'+
     '`form2`,`crdate` FROM `doc31` WHERE (`datedoc`="'+FormWayBillv2.DateDoc+'")AND(`numdoc`="'+FormWayBillv2.edNumDoc.Text+'");';
    xrecbuf:=FormStart.DB_Query(Query);
    xrowbuf:=formStart.DB_Next(xrecbuf);
    while xrowbuf<>nil do begin
      i:=FormWayBillv2.StringGrid1.RowCount;
      FormWayBillv2.StringGrid1.RowCount:=i+1;
      FormWayBillv2.StringGrid1.Cells[1,i]:=xrowbuf[2];
      FormWayBillv2.StringGrid1.Cells[2,i]:=xrowbuf[0];
      FormWayBillv2.StringGrid1.Cells[3,i]:=xrowbuf[4];
      FormWayBillv2.StringGrid1.Cells[4,i]:=xrowbuf[5];
      FormWayBillv2.StringGrid1.Cells[5,i]:=xrowbuf[6];
      FormWayBillv2.StringGrid1.Cells[6,i]:=xrowbuf[1];
      FormWayBillv2.StringGrid1.Cells[7,i]:=xrowbuf[3];
      FormWayBillv2.StringGrid1.Col:=3;
      FormWayBillv2.StringGrid1.Row:=i;
      xrowbuf:=formStart.DB_Next(xrecbuf);
    end;
    FormWayBillv2.showmodal;

  end;


end;

procedure TFormJurnale.MenuItem6Click(Sender: TObject);
var
  Query:String;
begin
  // ==== выбрали расход ====
  if sgSalesOpt.Row>0 then begin
    formRealTTN.flReadOnly:=false;
    formRealTTN.DocNumber:= sgSalesOpt.Cells[1,sgSalesOpt.Row];
    formRealTTN.DocDate:= sgSalesOpt.Cells[2,sgSalesOpt.Row];
    FormStart.ConnectDB();
    Query:='SELECT * FROM `docjurnale` WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'")AND(`block`="+") ;';
    if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
     exit;
    formStart.recbuf := mysql_store_result(formStart.sockMySQL);
    if formStart.recbuf=Nil then exit;
    formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
    if formStart.rowbuf<>nil then begin
       ShowMessage('Документ используется!');
       exit;
       end
     else
       formrealttn.ShowModal;
    FormStart.disconnectDB();

  end;
end;

procedure TFormJurnale.MenuItem7Click(Sender: TObject);
var
  Query:String;
begin
  formTicket.DocNum:=sgSalesOpt.Cells[1,sgSalesOpt.Row];
  formTicket.DocDate:=sgSalesOpt.Cells[2,sgSalesOpt.Row];
  // Обработка Сообщений ЕГАИС
  formTicket.uid:='';
//  FormStart.ConnectDB();
  Query:='SELECT `uid`,`WBregId` FROM `docjurnale` WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'") ;';
  formStart.recbuf := FormStart.DB_query(Query);
  if formStart.recbuf=Nil then exit;
  formStart.rowbuf := FormStart.DB_next(formStart.recbuf);
  if formStart.rowbuf<>nil then begin
    formTicket.uid:=formStart.rowbuf[0];
    formTicket.WBRegID:=formStart.rowbuf[1];
  end;
  if (formTicket.uid<>'')OR(formTicket.WBRegID<>'') then
    formTicket.ShowModal;
  FormStart.disconnectDB();
end;

procedure TFormJurnale.MenuItem8Click(Sender: TObject);
begin
  // ===== Вызов Формы настройки ======
  formOptions.ShowModal;
end;

procedure TFormJurnale.MenuItem9Click(Sender: TObject);
begin

end;

procedure TFormJurnale.MenuSubGoodsClick(Sender: TObject);
begin

end;

procedure TFormJurnale.miChecketMarkClick(Sender: TObject);
begin
  formCheckedMark.ShowModal;
end;

procedure TFormJurnale.miDeclarantAlcoClick(Sender: TObject);
begin
  formexportdecalc.show;
end;

procedure TFormJurnale.miExportXLSClick(Sender: TObject);
begin
  FormReprotOborot.BitBtn5Click(Sender);
end;

procedure TFormJurnale.miFullReportRestClick(Sender: TObject);
begin
  FormReprotOborot.BitBtn2Click(Sender);
end;

procedure TFormJurnale.miGoodForSalesClick(Sender: TObject);
begin
  // === Справочник товара для продажи
  //hide;
  formspgoods.ShowModal;
  //show;
end;

procedure TFormJurnale.miInfoGoodsAlcCodeClick(Sender: TObject);
var
  salccode:String;
begin

  // ====== AlcCode ========
  salcCode:=Formgetpdf417.getAlcCode();
  if sAlcCode='' then
     formStart.QueryAP_v2(salcCode);
end;

procedure TFormJurnale.miInfoGoodsINNClick(Sender: TObject);
begin
  // === ИНН
  FormInsertINN.Edit1.Text:='';
  formInsertINN.Caption:='Введите ИНН производителя.';
  IF formInsertINN.ShowModal= 1377 then begin
    formStart.LoadEGAISTovar(FormInsertINN.Edit1.Text);
    refreshReply();
  end;
end;

procedure TFormJurnale.miInventShopClick(Sender: TObject);
begin

end;

procedure TFormJurnale.miOtherOpenDocClick(Sender: TObject);
var
  query:string;
  i:integer;
  strType:string;
  numdoc,datedoc:string;
begin
  if listview5.Selected<>nil then begin
     i:=1;
     query:='SELECT `type`,`numdoc`,`datedoc` FROM `docjurnale` WHERE `uid`="'+listview5.Selected.SubItems.Strings[3]+'";';
     formStart.recbuf := formStart.DB_query(Query);
     formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
     if formStart.rowbuf<>nil then  begin
      strType:= formStart.rowbuf[0];
     if strType = 'QueryPDF417' then   begin
       // =====
       numdoc:= formStart.rowbuf[1];
       datedoc:= formStart.rowbuf[2];
       Query:='SELECT `pdf417`,`marktype`,`markserial`,`marknumber` FROM `doc30` WHERE `numdoc`="'+numdoc+'" AND `datedoc`="'+datedoc+'";';
       formStart.recbuf := formStart.DB_query(Query);
       formStart.rowbuf := formStart.DB_Next(formStart.recbuf);
       if formStart.rowbuf<>nil then begin
         formQueryPDF417.EdResult.Text:=formStart.rowbuf[0];
         formQueryPDF417.ComboBox1.Text:='';
         formQueryPDF417.edSerial.Text:=formStart.rowbuf[2];
         formQueryPDF417.edNumber.Text:=formStart.rowbuf[3];
         formQueryPDF417.ShowModal;
       end;
     end;
     end;
  end;

end;

procedure TFormJurnale.miPrintPDF417Click(Sender: TObject);
begin
  // =====
  FormPrintPDF417.showModal;
end;

procedure TFormJurnale.miQueryListDocsClick(Sender: TObject);
begin
end;

procedure TFormJurnale.miQueryRest1Click(Sender: TObject);
begin
  FormStart.readOstatok();
  showMessage('Запрос отправлен в ЕГАИС');
end;

procedure TFormJurnale.miQueryShopRest1Click(Sender: TObject);
begin
  IF FormUpdateTransfer.UpdateBalance then


end;

procedure TFormJurnale.miQueryTTNClick(Sender: TObject);
begin

end;

procedure TFormJurnale.miReportOstatokClick(Sender: TObject);
begin
  //hide;
  FormReprotOborot.showmodal;
  ///show;
end;

procedure TFormJurnale.miReturnTTNClick(Sender: TObject);
begin

end;

procedure TFormJurnale.miShowRest1Click(Sender: TObject);
begin

end;

procedure TFormJurnale.miSmallReportRestClick(Sender: TObject);
begin
  FormReprotOborot.BitBtn1Click(Sender);
end;

procedure TFormJurnale.miTransferShopClick(Sender: TObject);
begin
end;

procedure TFormJurnale.miTransferToShopClick(Sender: TObject);
begin
  //hide;
  FormOstatok.ShowModal();
  //show;
end;

procedure TFormJurnale.miWriteOffShopClick(Sender: TObject);
begin
end;

procedure TFormJurnale.miWriteOnShopClick(Sender: TObject);
begin
end;

procedure TFormJurnale.PageControl1Change(Sender: TObject);
begin
end;

procedure TFormJurnale.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin

end;

procedure TFormJurnale.PageControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFormJurnale.PageControl1Resize(Sender: TObject);
begin
end;

procedure TFormJurnale.pmRJSelectClick(Sender: TObject);
begin
  if (idRetJurnaleRowSelect<Stringgrid1.RowCount)and(idRetJurnaleRowSelect>0) then
   begin
   formreturnTTN.DocNumber:=Stringgrid1.Cells[1,idRetJurnaleRowSelect];
   formreturnTTN.DocDate:= Stringgrid1.Cells[2,idRetJurnaleRowSelect];
   //formreturnTTN.Docid:= Listview1.Selected.SubItems.Strings[5];
 //  formreturnTTN.CreateDoc(nil);
   //formreturnTTN.flEditing:=false;
   formreturnTTN.flNewDoc:=false;
   hide;
   formreturnTTN.ShowModal;
   show;
   end;
end;

procedure TFormJurnale.pnlFWOptionsClick(Sender: TObject);
begin

end;

procedure TFormJurnale.pnlNewsClick(Sender: TObject);
begin

end;

procedure TFormJurnale.sgSalesOptDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin
    if arow<=0 then
     exit;
    if sgSalesOpt.Cells[8,arow]<>'+' then
       exit;

    if not (gdFixed in aState) then // si no es el tituloŽ
      if not (gdSelected in aState) then
        begin
        (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[0];
        end
      else
        begin
        (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[0];
        (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
       //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
        end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);


end;

procedure TFormJurnale.sgSalesOptMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
 // sgSalesOpt.Perform(WM_VSCROLL, 1, 0);
end;

procedure TFormJurnale.sgSalesOptMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    if  sgSalesOpt.row+sgSalesOpt.DefaultRowHeight<sgSalesOpt.RowCount  then
      sgSalesOpt.row:=sgSalesOpt.row+sgSalesOpt.DefaultRowHeight
    else
      sgSalesOpt.row:=sgSalesOpt.RowCount-1;
  Handled := True;
end;

procedure TFormJurnale.sgSalesOptMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if  sgSalesOpt.row-sgSalesOpt.DefaultRowHeight>0  then
    sgSalesOpt.row:=sgSalesOpt.row-sgSalesOpt.DefaultRowHeight
  else
    sgSalesOpt.row:=1;
  Handled := True;
end;

procedure TFormJurnale.sgShopRestDblClick(Sender: TObject);
begin
end;

procedure TFormJurnale.sgShopRestDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aCol=0 then
  ilDocIcons.Draw(sgShopRest.Canvas,aRect.Left+(aRect.Right-aRect.Left-20) div 2,aRect.Top+(aRect.Bottom-aRect.Top-20) div 2,0);
end;

procedure TFormJurnale.sgShopRestResize(Sender: TObject);
begin

end;

procedure TFormJurnale.SpeedButton1Click(Sender: TObject);
begin
  if Panel4.tag = 0 then begin
     panel4.tag:= Panel4.Height;
     Panel4.Height:=30;
  end else begin
    Panel4.Height:=panel4.tag;
    panel4.tag:=0;
  end;
end;

procedure TFormJurnale.StaticText13Click(Sender: TObject);
begin

end;

procedure TFormJurnale.StaticText1Click(Sender: TObject);
begin
end;

procedure TFormJurnale.StaticText1MouseLeave(Sender: TObject);
begin
  (Sender As TStaticText).Font.Style:= [];
end;

procedure TFormJurnale.StaticText1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender As TStaticText).Font.Style:= [fsUnderline];
end;

procedure TFormJurnale.StaticText2Click(Sender: TObject);
begin
  tabsheet6.TabVisible:=true;
  pageControl1.ActivePage:=tabSheet6;
end;

procedure TFormJurnale.StringGrid1MouseEnter(Sender: TObject);
begin

end;

procedure TFormJurnale.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer
  );
begin
  idRetJurnaleRowSelect:=arow;
end;

procedure TFormJurnale.StringGrid2DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
const
  Colores:array[0..3] of TColor=($ffef55, $efff55, $efefff, $efffff);
  Colores1:array[0..3] of TColor=($ffefee, $efffee, $efefff, $efffff);
  ColSele:array[0..3] of TColor=($444444, $444444, $444444, $444444);
begin


    if not (gdFixed in aState) then // si no es el tituloŽ
    if not (gdSelected in aState) then
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=Colores1[aRow mod 4];
      end
    else
      begin
      (Sender as TStringGrid).Canvas.Brush.Color:=ColSele[aRow mod 4];
      (Sender as TStringGrid).Canvas.Font.Color:=$ffffff;
     //(Sender as TStringGrid).Canvas.Font.Style:=[fsBold];
      end;

    //(Sender as TStringGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);
    (Sender as TStringGrid).defaultdrawcell(acol,arow,arect,astate);

end;

procedure TFormJurnale.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TFormJurnale.TabSheet1Resize(Sender: TObject);
begin

end;

procedure TFormJurnale.TabSheet1Show(Sender: TObject);
begin

end;

procedure TFormJurnale.TabSheet2Show(Sender: TObject);
begin
  refreshJurnaleOut();
end;

procedure TFormJurnale.TabSheet3Show(Sender: TObject);
begin
  refreshReply();
end;

{ @TabSheet4Show
Карты скидок}
procedure TFormJurnale.TabSheet4Show(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( FormSpDiscountCards) then
     exit;
  d:= FATTabControl.AddTab(-1,'Карты скидок');
  FormSpDiscountCards.Parent:=pnlUserPolice AS TWinControl;
  FormSpDiscountCards.Top:=0;
  FormSpDiscountCards.Left:=0;
  FormSpDiscountCards.BorderStyle:=bsNone;
  FormSpDiscountCards.Align:=alClient;
  FormSpDiscountCards.Visible:=true;
  d.TabObject := FormSpDiscountCards;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.TabSheet5Show(Sender: TObject);
begin
end;

procedure TFormJurnale.TabSheet6Show(Sender: TObject);
begin
  refreshJurnaleRet();
end;

procedure TFormJurnale.TabSheet7Show(Sender: TObject);

  // ==== журнал Торгового склада ====
var
  i:integer;
    status1:String;
  Query:String ;
  comment1:string;
  DocType:string;
  xrowbuf:MYSQL_ROW;
  xrecbuf:PMYSQL_RES;
begin
  i:=1;
  SgShoprest.RowCount:=1;
  if not formStart.ConnectDB() then
    exit;
  // if ToggleBox1.Checked then                                                                                                           (`type`=''ActTransferOnShop'')OR(`type`=''InventRest'')OR      OR(`type`=''ActTransferOnShop'')
  Query:='SELECT `type`,`numdoc`,`dateDoc`,`status`,`uid`,`comment`,`type` FROM `docjurnale` WHERE ((`type`=''ActWriteOffShop'')OR(`type`=''ActChargeOnShop'')OR(`type`="ActChargeOn")OR(`type`="ActTransferOnShop")OR(`type`="ActWriteOff")OR(`type`="QueryHistoryFormB")OR(`type`="InventRest")OR(`type`="InventShop")OR(`type`="ActShopFromTransfer")OR(`type`="MoveWayBill"))AND'+
  '(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateStock)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateStock)+''') ORDER BY `dateDoc` ASC;';
  xrecbuf := formstart.DB_Query(Query);
  xrowbuf := formstart.DB_Next(xrecbuf);
  while xrowbuf<>nil do
   begin
     comment1:='';
     SgShoprest.RowCount:=i+1;
     //     with SgShoprest.Rows[i] do begin
     //       add('');
     DocType:= xrowbuf[0];
     case DocType of
       'ActTransferOnShop': begin
           comment1:= 'Главный склад';
           SgShoprest.Cells[1,i]:='Перемещение в торговый зал '+xrowbuf[1];
        end;
      'QueryHistoryFormB':
                SgShoprest.Cells[1,i]:='Оборот по FB-'+xrowbuf[1];
      'ActWriteOffShop': begin
                    comment1:= 'Торговый зал';
                    SgShoprest.Cells[1,i]:='Списание '+xrowbuf[1];
        end;
      'InventRest': begin
                       comment1:= 'Главный склад';
                       SgShoprest.Cells[1,i]:='Инвентаризация '+xrowbuf[1];
        end;
      'InventShop': begin
                       comment1:= 'Торговый зал';
                       SgShoprest.Cells[1,i]:='Инвентаризация '+xrowbuf[1];
        end;
      'ActChargeOn': begin
                         comment1:= 'Главный склад';
                        SgShoprest.Cells[1,i]:='Оприходование  '+xrowbuf[1];
        end;
      'ActWriteOff': begin
           comment1:= 'Главный склад';
                             SgShoprest.Cells[1,i]:='Списание  '+xrowbuf[1];
        end;
      'ActChargeOnShop':begin
                              comment1:= 'Торговый зал';
                              SgShoprest.Cells[1,i]:='Оприходование '+xrowbuf[1];

        end;
      'ActShopFromTransfer': begin
                              comment1:= 'Торговый зал';
                              SgShoprest.Cells[1,i]:='Перемещение '+xrowbuf[1];
        end;
      'MoveWayBill': begin
          comment1:= 'Главный склад';
          SgShoprest.Cells[1,i]:='Перемещение '+xrowbuf[1];
       end;
      else
      end;
      SgShoprest.Cells[2,i]:=xrowbuf[2];         //3
            status1:= xrowbuf[3];
            SgShoprest.Cells[4,i]:='';
            case status1[1] of
            '0': begin
                  SgShoprest.Cells[3,i]:='Ошибка при отправке';

                 end;
            '-': begin
                SgShoprest.Cells[3,i]:='Новый'; end;
            '1': begin SgShoprest.Cells[3,i]:='Готов к отправке!'; end;
            '+': begin
              SgShoprest.Cells[3,i]:='Отправлен в ЕГАИС';
              if status1[3] = '+' then
                   SgShoprest.Cells[4,i]:='Принят в ЕГАИС';
              //subitems.Add('');
            end
            else
              SgShoprest.Cells[3,i]:=''
            end;
      //      subitems.Add('');
            SgShoprest.Cells[5,i]:=xrowbuf[4];
            SgShoprest.Cells[6,i]:=comment1;//formStart.rowbuf[5];
            SgShoprest.Cells[7,i]:=xrowbuf[1];
            SgShoprest.Cells[8,i]:=xrowbuf[6];
           i:=i+1;
         // end;
     xrowbuf := formstart.DB_Next(xrecbuf);
   end ;
end;

procedure TFormJurnale.TabSheet8ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TFormJurnale.tbCashReportShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formcashreport) then
     exit;
  d:= FATTabControl.AddTab(-1,'Журнал транзакций');
  // Журнал транзакций
  formcashreport.Parent:=pnlUserPolice AS TWinControl;
  formcashreport.Top:=0;
  formcashreport.Left:=0;
  formcashreport.BorderStyle:=bsNone;
  formcashreport.Align:=alClient;
  formcashreport.Visible:=true;
  d.TabObject := formcashreport;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tbErrorChange(Sender: TObject);
begin
  refreshJurnaleOut();
end;

procedure TFormJurnale.ToggleBox1Click(Sender: TObject);
begin
  refreshJurnaleIn();
end;

procedure TFormJurnale.ToggleBox2Change(Sender: TObject);
var
  query:string;
begin
 if ToggleBox2.Checked then begin
   if sgSalesOpt.Row>0 then  begin
       Query:='SELECT `clientRegId` FROM `docjurnale` WHERE (`numdoc`="'+sgSalesOpt.Cells[1,sgSalesOpt.Row]+'")AND(`datedoc`="'+sgSalesOpt.Cells[2,sgSalesOpt.Row]+'") ;';
       formStart.recbuf := FormStart.DB_query(Query);
       formStart.rowbuf := FormStart.DB_next(formStart.recbuf);
       if formStart.rowbuf<>nil then begin
         FiltrOut:=formStart.rowbuf[0];
       end;
     end;
 end
 else begin
   FiltrOut:='';
 end;
 refreshJurnaleOut();
end;

procedure TFormJurnale.tsAlcDeclShow(Sender: TObject);
begin
end;

procedure TFormJurnale.tsEditCheckFormShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( FormeditFormCheck) then
     exit;
  d:= FATTabControl.AddTab(-1,'Шаблон предчека');
 // Шаблон предчека
    FormeditFormCheck.Parent:=pnlUserPolice AS TWinControl;
    FormeditFormCheck.Top:=0;
    FormeditFormCheck.Left:=0;
    FormeditFormCheck.BorderStyle:=bsNone;
    FormeditFormCheck.Align:=alClient;
    FormeditFormCheck.Visible:=true;
  d.TabObject := FormeditFormCheck;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsFastGoodsShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formspfastgood) then
     exit;
  d:= FATTabControl.AddTab(-1,'Быстрые товары');
    formspfastgood.Parent:=pnlUserPolice AS TWinControl;
    formspfastgood.Top:=0;
    formspfastgood.Left:=0;
    formspfastgood.BorderStyle:=bsNone;
    formspfastgood.Align:=alClient;
    formspfastgood.Visible:=true;
    d.TabObject := formspfastgood;
    FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsFirmOptionsShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formOptions) then
     exit;
  d:= FATTabControl.AddTab(-1,'Настройка предприятия');
  formOptions.Parent:=pnlUserPolice AS TWinControl;
  formOptions.Top:=0;
  formOptions.Left:=0;
  //formOptions.Panel1.Visible:=false;
  formOptions.BorderStyle:=bsNone;
  formOptions.Align:=alClient;
  formOptions.Visible:=true;
  d.TabObject := formOptions;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsFWOptionsShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formspkass) then
     exit;
  d:= FATTabControl.AddTab(-1,'Торговое оборудование');
  // Торговое оборудование
  formspkass.Parent:=pnlUserPolice AS TWinControl;
  formspkass.Top:=0;
  formspkass.Left:=0;
  formspkass.BorderStyle:=bsNone;
  formspkass.Align:=alClient;
  formspkass.Visible:=true;
  d.TabObject := formspkass;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsHomePageShow(Sender: TObject);
begin
end;

procedure TFormJurnale.tsPrintTicketShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formprintticket) then
     exit;
  d:= FATTabControl.AddTab(-1,'Печать ценников и этикеток');
  // Печать ценников и этикеток

  formprintticket.Parent:=pnlUserPolice AS TWinControl;
  formprintticket.Top:=0;
  formprintticket.Left:=0;
  formprintticket.BorderStyle:=bsNone;
  formprintticket.Align:=alClient;
  formprintticket.Visible:=true;
  d.TabObject:= formprintticket;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsSprAlcItemsShow(Sender: TObject);
begin

end;

procedure TFormJurnale.tsSprGoodsShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formspgoods) then
     exit;
  d:= FATTabControl.AddTab(-1,'Справочник товара');
  formspgoods.Parent:=pnlUserPolice AS TWinControl;
  formspgoods.Top:=0;
  formspgoods.Left:=0;
  formspgoods.BorderStyle:=bsNone;
  formspgoods.Align:=alClient;
  formspgoods.Visible:=true;
  d.TabObject:= formspgoods;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsSprProducerShow(Sender: TObject);
var
   i:integer;
   d: TATTabData;
begin
  if GetTabStatisVisible( formspproducer) then
     exit;
  d:= FATTabControl.AddTab(-1,'Справочник производителей');
  formspproducer.Parent:=pnlUserPolice AS TWinControl;
  formspproducer.Top:=0;
  formspproducer.Left:=0;
  formspproducer.BorderStyle:=bsNone;
  formspproducer.Align:=alClient;
  formspproducer.Visible:=true;
  d.TabObject:=formspproducer;
  FATTabControl.TabIndex:= d.Index;
end;

procedure TFormJurnale.tsUserPoliceShow(Sender: TObject);
var
  i:integer;
  d: TATTabData;
begin
  if GetTabStatisVisible( formspusers) then
     exit;
  d:= FATTabControl.AddTab(-1,'Права и пользователи');
  formspusers.Parent:=pnlUserPolice AS TWinControl;
  formspusers.Top:=0;
  formspusers.Left:=0;
  formspusers.BorderStyle:=bsNone;
  formspusers.Align:=alClient;
  formspusers.Visible:=true;
  d.TabObject:=formspusers;
  FATTabControl.TabIndex:= d.Index;
  //formspusers.Show;

end;

procedure TFormJurnale.tvGroupGoodsChange(Sender: TObject; Node: TTreeNode);
begin

end;

procedure TFormJurnale.pbbClick(Sender: TObject);
begin

end;

procedure TFormJurnale.pmiClick(Sender: TObject);
var
  i:integer;
  d: TATTabData;
  fname:string;
begin
  PageControl1.Visible:=true;
  fname:=arrPanelItem[(Sender AS TStaticText).Tag].FunctionName;
  case fname of
   'showrest': begin // === складские документы
       //tabsheet8.TabVisible:=true;
       //PageControl1.ActivePage:=tabsheet8;
     if FormJurnaleStocks = nil then
        FormJurnaleStocks := TFormJurnaleStocks.Create(Application);
       if GetTabStatisVisible( FormJurnaleStocks) then
          exit;
       d:= FATTabControl.AddTab(-1,'Складские документы');
       FormJurnaleStocks.Parent:=pnlUserPolice AS TWinControl;
       FormJurnaleStocks.Top:=0;
       FormJurnaleStocks.Left:=0;
       FormJurnaleStocks.BorderStyle:=bsNone;
       FormJurnaleStocks.Align:=alClient;
       FormJurnaleStocks.Visible:=true;
       d.TabObject:=FormJurnaleStocks;
       FATTabControl.TabIndex:= d.Index;
     end;
   'showwaybill':begin // ==== Входные накладные из ЕГАИС
       if FormJurnaleInWayBills = nil then
           FormJurnaleInWayBills := TFormJurnaleInWayBills.Create(Application);
      if GetTabStatisVisible( FormJurnaleInWayBills) then
        exit;
     d:= FATTabControl.AddTab(-1,'Входящие накладные');
     FormJurnaleInWayBills.Parent:=pnlUserPolice AS TWinControl;
     FormJurnaleInWayBills.Top:=0;
     FormJurnaleInWayBills.Left:=0;
     FormJurnaleInWayBills.BorderStyle:=bsNone;
     FormJurnaleInWayBills.Align:=alClient;
     FormJurnaleInWayBills.Visible:=true;
     d.TabObject:=FormJurnaleInWayBills;
     FATTabControl.TabIndex:= d.Index;
   end;
   'showretwaybill':begin
       //tabsheet6.TabVisible:=true;
       //PageControl1.ActivePage:=tabsheet6;
       // showretwaybill
      if FormJurnaleReturnWaybill = nil then
          FormJurnaleReturnWaybill := TFormJurnaleReturnWaybill.Create(Application);
      if GetTabStatisVisible( FormJurnaleReturnWaybill) then
         exit;
      d:= FATTabControl.AddTab(-1,'Возврат поставщику');
      FormJurnaleReturnWaybill.Parent:=pnlUserPolice AS TWinControl;
      FormJurnaleReturnWaybill.Top:=0;
      FormJurnaleReturnWaybill.Left:=0;
      FormJurnaleReturnWaybill.BorderStyle:=bsNone;
      FormJurnaleReturnWaybill.Align:=alClient;
      FormJurnaleReturnWaybill.Visible:=true;
      d.TabObject:=FormJurnaleReturnWaybill;
      FATTabControl.TabIndex:= d.Index;
   end;
   'showsprproduct':begin // справочник алк товара
      if formspproduct = nil then
          formspproduct := Tformspproduct.Create(Application);
      if GetTabStatisVisible( formspproduct) then
         exit;
      d:= FATTabControl.AddTab(-1,'Справочник алк продукции');
      formspproduct.Parent:=pnlUserPolice AS TWinControl;
      formspproduct.Top:=0;
      formspproduct.Left:=0;
      formspproduct.BorderStyle:=bsNone;
      formspproduct.Align:=alClient;
      formspproduct.Visible:=true;
      d.TabObject:=formspproduct;
      FATTabControl.TabIndex:= d.Index;
   end;
   'showsprproducer': tsSprProducerShow(Sender);
   'showuserpolice': if userplc.editusers  then tsUserPoliceShow(Sender) else showmessage('Недостаточно прав!');
   'showsprgoods':  if userplc.editgoods then  tsSprGoodsShow(sender) else showmessage('Недостаточно прав!');
   'showdiscountcards': if userplc.editgoods then  TabSheet4Show(Sender) else showmessage('Недостаточно прав!');
   'showfirmopt': if userplc.editsoft then tsFirmOptionsShow(Sender) else showmessage('Недостаточно прав!');
  'showsalesorder':begin
      //tabsheet5.TabVisible:=true;
      //PageControl1.ActivePage:=tabsheet5;
         //tabsheet8.TabVisible:=true;
       //PageControl1.ActivePage:=tabsheet8;
       if FormJurnaleDocCash = nil then
          FormJurnaleDocCash := TFormJurnaleDocCash.Create(Application);
       if GetTabStatisVisible( FormJurnaleDocCash) then
          exit;
       d:= FATTabControl.AddTab(-1,'Журнал регистрации продаж');
       FormJurnaleDocCash.Parent:=pnlUserPolice AS TWinControl;
       FormJurnaleDocCash.Top:=0;
       FormJurnaleDocCash.Left:=0;
       FormJurnaleDocCash.BorderStyle:=bsNone;
       FormJurnaleDocCash.Align:=alClient;
       FormJurnaleDocCash.Visible:=true;
       d.TabObject:=FormJurnaleDocCash;
       FATTabControl.TabIndex:= d.Index;
    end;
  'showHonestSign': begin
      //tabsheet5.TabVisible:=true;
      //PageControl1.ActivePage:=tabsheet5;
         //tabsheet8.TabVisible:=true;
       //PageControl1.ActivePage:=tabsheet8;
       if FormHonestSign = nil then
          FormHonestSign := TFormHonestSign.Create(Application);
       if GetTabStatisVisible( FormHonestSign) then
          exit;
       d:= FATTabControl.AddTab(-1,'Честный знак');
       FormHonestSign.Parent:=pnlUserPolice AS TWinControl;
       FormHonestSign.Top:=0;
       FormHonestSign.Left:=0;
       FormHonestSign.BorderStyle:=bsNone;
       FormHonestSign.Align:=alClient;
       FormHonestSign.Visible:=true;
       d.TabObject:=FormHonestSign;
       FATTabControl.TabIndex:= d.Index;
    end;
  'showfastgood': tsFastGoodsShow(Sender);
  'showformcheck': tsEditCheckFormShow(Sender);
  'showdevopt': if userplc.edithw then tsFWOptionsShow(Sender) else showmessage('Недостаточно прав!');
  'showcashreport': tbCashReportShow(Sender);
  'showsalesticket': tsPrintTicketShow(Sender);
  'showdocjurnal3':begin
      tabsheet3.TabVisible:=true;
      PageControl1.ActivePage:=tabsheet3;
    end;
  'showalcdecl':begin // Форма декларант алко
       if FormJurnaleAlcForms = nil then
           FormJurnaleAlcForms := TFormJurnaleAlcForms.Create(Application);

       if GetTabStatisVisible( FormJurnaleAlcForms) then
          exit;
       d:= FATTabControl.AddTab(-1,'Декларант Алко');
       FormJurnaleAlcForms.Parent:=pnlUserPolice AS TWinControl;
       FormJurnaleAlcForms.Top:=0;
       FormJurnaleAlcForms.Left:=0;
       FormJurnaleAlcForms.BorderStyle:=bsNone;
       FormJurnaleAlcForms.Align:=alClient;
       FormJurnaleAlcForms.Visible:=true;
       d.TabObject:=FormJurnaleAlcForms;
       FATTabControl.TabIndex:= d.Index;
    end;
  'showtempreport':begin
    formReportClient.frReport1.DesignReport;
   end;
  end;
end;

procedure TFormJurnale.pmiMouseLeave(Sender: TObject);
begin
  (Sender As TStaticText).Font.Style:= [];
end;

procedure TFormJurnale.pmiMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  (Sender As TStaticText).Font.Style:= [fsUnderline];
end;


procedure TFormJurnale.BitBtn2Click(Sender: TObject);
begin
  refreshJurnaleOut();
end;

procedure TFormJurnale.BitBtn1Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn20Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn21Click(Sender: TObject);
begin
  hide;
  formcashreport.showmodal;
  show;
end;

procedure TFormJurnale.BitBtn22Click(Sender: TObject);
begin
  if Panel5.tag = 0 then begin
     panel5.tag:= Panel5.Height;
     Panel5.Height:=30;
  end else begin
    Panel5.Height:=panel5.tag;
    panel5.tag:=0;
  end;
end;

procedure TFormJurnale.BitBtn23Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn24Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn25Click(Sender: TObject);
begin

    formQueryPDF417.ShowModal;

end;

procedure TFormJurnale.BitBtn26Click(Sender: TObject);
begin

 if db_boolean(FormStart.GetConstant('autoactwritebeer')) then
 if  cldDialog.Execute then  begin
     formActWriteBeer.CurData:=cldDialog.Date;
     formActWriteBeer.showmodal;
 end;
end;

procedure TFormJurnale.BitBtn27Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn27.ClientOrigin;
  pmrestOwner1.PopUp(r.x,r.y+BitBtn27.Height);
end;

procedure TFormJurnale.BitBtn28Click(Sender: TObject);
begin

end;

procedure TFormJurnale.BitBtn10Click(Sender: TObject);
var
  r:Tpoint;
begin
 if formstart.flOptMode then begin
  hide;
  FormOstatok.ShowModal();
  show;
  TabSheet7Show(sender);
 end else begin
  r:=BitBtn10.ClientOrigin;
  pmMenuShop.PopUp(r.x,r.y+BitBtn10.Height);
  //pmrestOwner1.PopUp(r.x,r.y+BitBtn10.Height);
 end;

end;

procedure TFormJurnale.bbRefreshShopClick(Sender: TObject);
begin

end;

procedure TFormJurnale.bbRefGoodsClick(Sender: TObject);
begin

end;

procedure TFormJurnale.bbCloseTab1Click(Sender: TObject);
begin
  //TabSheet1.TabVisible:=false;
end;

procedure TFormJurnale.bbCloseTabClick(Sender: TObject);
begin

end;

procedure TFormJurnale.bbEgaisClick(Sender: TObject);
begin
  if Panel3.tag = 0 then begin
     panel3.tag:= Panel3.Height;
     Panel3.Height:=30;
  end else begin
    Panel3.Height:=panel3.tag;
    panel3.tag:=0;
  end;
end;

procedure TFormJurnale.BitBtn11Click(Sender: TObject);
begin

  hide;
  formReturnTTN.flNewDoc:=true;
  formReturnTTN.Showmodal;
  show;

end;

procedure TFormJurnale.BitBtn12Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn13Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn14Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn15Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn16Click(Sender: TObject);
begin
  FormSalesBeer.clearcheck();
  hide;
  FormSalesBeer.showmodal;
  show;
end;

procedure TFormJurnale.BitBtn17Click(Sender: TObject);
begin
  formreportclient.ShowModal;
end;

procedure TFormJurnale.BitBtn18Click(Sender: TObject);
begin
 if FormFilter.ShowModal = 1377 then begin
   startDateStock:= FormFilter.StartDate;
   endDateStock  := FormFilter.EndDate;
  // tsSprGoods.Caption:='Главный склад ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
   //tsAlcDecl.Caption:='Торговый зал ['+FormatDateTime('DD-MM-YYYY',StartDateStock)+' - '+FormatDateTime('DD-MM-YYYY',endDateStock)+']';
   refreshRests();
   TabSheet7Show(sender);
 end;
end;

procedure TFormJurnale.BitBtn19Click(Sender: TObject);
begin
 if FormFilter.ShowModal = 1377 then begin
   startDateRetTTN:= FormFilter.StartDate;
   endDateRetTTN  := FormFilter.EndDate;
   TabSheet6.Caption:='Возвратные накладные';
   BitBtn19.Hint:='Фильтр по зате: '+FormatDateTime('DD-MM-YYYY',startDateRetTTN)+' - '+FormatDateTime('DD-MM-YYYY',endDateRetTTN)+'';
   refreshJurnaleRet();
 end;
end;

procedure TFormJurnale.BitBtn3Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn4Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn5Click(Sender: TObject);
begin
  FormInsertINN.Edit1.Text:='';
  formInsertINN.Caption:='Введите ИНН Вашего поставщика.';
  IF (formInsertINN.ShowModal= 1377)or(formInsertINN.ShowModal=mrOk) then begin
    formStart.LoadEGAISClient(FormInsertINN.Edit1.Text);
    refreshReply();
  end;

end;

procedure TFormJurnale.BitBtn6Click(Sender: TObject);
var
  r:Tpoint;
begin
  r:=BitBtn6.ClientOrigin;
//  r.Top:=;
  pminfogoods.PopUp(r.x,r.y+BitBtn6.Height);




end;

procedure TFormJurnale.BitBtn7Click(Sender: TObject);
begin
end;

procedure TFormJurnale.BitBtn8Click(Sender: TObject);
begin
  if FormFilter.ShowModal = 1377 then begin
    startDateOutTTN:= FormFilter.StartDate;
    endDateOutTTN  := FormFilter.EndDate;
    TabSheet2.Caption:='Реализация ТТН ['+FormatDateTime('DD-MM-YYYY',StartDateOutTTN)+' - '+FormatDateTime('DD-MM-YYYY',endDateOutTTN)+']';
    refreshJurnaleOut();
  end;
end;

procedure TFormJurnale.refreshJurnaleIn();
var
  status1:string;
  Reg:string;
  CurDate:TDateTime;
  sDate:String;
  Query:String;
begin
{  ListView1.Items.Clear;
  Query:='SELECT `dateDoc`,`type`,`numdoc`,`summa`,`ClientName`,`status`,`docid`,`WBregID`,`utmv2`'+
        ' FROM `docjurnale` WHERE ((`type`="WayBill" )OR (`type`="RetWayBill")) AND (`registry`="+")'+
        'AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateInTTN)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateInTTN)+''') ORDER BY `datedoc` ASC ;';
  formStart.recbuf :=formStart.DB_query(Query) ;
  formStart.rowbuf := formStart.DB_next(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin
   //  sDate:=DefaultFormatSettings.ShortDateFormat;
     sDate := formStart.rowbuf[0];
     sDate:= sDate[9]+sDate[10]+'.'+sDate[6]+sDate[7]+'.'+sDate[1]+sDate[2]+sDate[3]+sDate[4] ;
     CurDate:=StrToDate(sDate);
     if (startDateInTTN<=Curdate)and(curdate<=endDateInTTN) then  begin
       reg:=formStart.rowbuf[1];
       with ListView1.Items.Add do begin
         caption:= formStart.rowbuf[2];
         subitems.Add(formStart.rowbuf[0]);         //3
         subitems.Add(formStart.rowbuf[3]);
         subitems.Add(formStart.rowbuf[4]);         //4
         status1:= formStart.rowbuf[5];
          if status1[1] = '0' then
            subitems.Add('Ошибка при отправке');
         if status1[1] = '-' then
            subitems.Add('Новый');
         if status1[2] = '+' then
            subitems.Add('Отправлен в ЕГАИС');
         case status1[3] of
         '1':subitems.Add('Отказ в ЕГАИС');
         '2':subitems.Add('Отказ в ЕГАИС');
         '+':subitems.Add('Принят в ЕГАИС')
            else
            subitems.Add('');
         end;

         subitems.Add(formStart.rowbuf[6]);
         if formStart.rowbuf[1]='RetWayBill' then
         subitems.Add('Возврат') else
         subitems.Add('Поступление');
         subitems.Add( formStart.rowbuf[8]);

       end;
     end;
     formStart.rowbuf := formStart.DB_next(formStart.recbuf);
   end ; }
end;

procedure TFormJurnale.refreshJurnaleOut();
var
  status1:string;
  Reg:string;
  CurDate:TDateTime;
  sDate:String;
  Query:String;
  summ:real;
  s1:String;
  flRejected:String;
  ind:integer;
begin
  sgSalesOpt.Clear;
  sgSalesOpt.rowCount:=1;
  if tbrejected.Checked then
     flRejected:='AND (`ClientAccept`="-") '
   else
     flRejected:=' ';
  if ToggleBox2.Checked then begin
     flRejected:=flRejected+'AND (`ClientRegId`="'+FiltrOut+'") '
    end;
  if tbIssue.Checked then begin
     flRejected:=flRejected+'AND (`issueclient`="+" OR `issueclient`="1") '
    end;
  if tbNotAccept.Checked then
     flRejected:=flRejected+'AND (`ClientAccept`<>"+") ' ;
  if tbError.Checked then
     flRejected:=flRejected+'AND (`status`="0--") '
    else
       flRejected:=flRejected+'';

  if ToggleBox1.Checked then
   Query:='SELECT `dateDoc`,`registry`,`numdoc`,`summa`,`ClientName`,`status`,`EGAISFixNumber`,`ClientAccept`,`isDelete`,`issueclient` FROM `docjurnale`'+
         ' WHERE (`type`="WayBill")AND (`registry`="-")'+flRejected+' AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateOutTTN)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateOutTTN)+''')  ORDER BY `datedoc`,`numdoc` ASC; '
  else
   Query:='SELECT `dateDoc`,`registry`,`numdoc`,`summa`,`ClientName`,`status`,`EGAISFixNumber`,`ClientAccept`,`isDelete`,`issueclient` FROM `docjurnale` WHERE (`type`="WayBill")AND((`status`="---")OR(`status`="++1") OR (`status`="0--"))AND (`registry`="-") '+flRejected
   +'AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateOutTTN)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',EndDateOutTTN)+''') ORDER BY `datedoc`,`numdoc` ASC;';
  formStart.recbuf :=formStart.DB_query(Query) ;
  formStart.rowbuf := formStart.DB_next(formStart.recbuf);
   while formStart.rowbuf<>nil do
   begin
   //  sDate:=DefaultFormatSettings.ShortDateFormat;
     sDate := formStart.rowbuf[0];
     sDate:= sDate[9]+sDate[10]+'.'+sDate[6]+sDate[7]+'.'+sDate[1]+sDate[2]+sDate[3]+sDate[4] ;
     CurDate:=StrToDate(sDate);
     reg:=formStart.rowbuf[1];
     sgSalesOpt.rowCount:= sgSalesOpt.rowCount+1;
     ind:=sgSalesOpt.rowCount-1;
     sgSalesOpt.Cells[1,ind]:=formStart.rowbuf[2];
     sgSalesOpt.Cells[2,ind]:=formStart.rowbuf[0];
     sgSalesOpt.Cells[3,ind]:=trim(formStart.rowbuf[3]);
     sgSalesOpt.Cells[4,ind]:=formStart.rowbuf[4];
      // summ:=StrToFloat(trim(formStart.rowbuf[3]));
               //4
       if formStart.rowbuf[8]='+' then
        s1:='Помечен на удаление'
        else begin
           status1:= formStart.rowbuf[5];
           s1:='';
           case status1[1] of
           '-': s1:='Новый';
           '1': s1:='Готов к отправке!';
           '0': s1:='Ошибка отправки';
           '+': begin
             if status1[3] = '+' then
                  s1:='Принят в ЕГАИС'
                else begin
                if status1[3] = '1' then
                  s1:='Отказ в ЕГАИС'
                else
                  s1:='Изменен'
                end;
           end
           else
           end;
           status1:= formStart.rowbuf[7];
           case status1 of
           '+':
             s1:=s1+' - Принял клиент';
           '0':
             s1:=s1+' - Разногласие';
           '-':
             s1:=s1+' - Клиент отказал'
           else
           end;
           status1:= formStart.rowbuf[9];
           sgSalesOpt.Cells[8,ind]:=status1;
           case status1 of
           '+': begin

             s1:=s1+' - Разногласие';
             end;
           '1':
             s1:=s1+' - Обработано Разногласие';
           end;
         end;
         sgSalesOpt.Cells[5,ind]:=s1;
         sgSalesOpt.Cells[6,ind]:=formStart.rowbuf[6];         //4

      formStart.rowbuf := formStart.DB_next(formStart.recbuf);
   end ;
   if sgSalesOpt.RowCount>1 then
     sgSalesOpt.Row:=1;
end;

procedure TFormJurnale.refreshJurnaleRet();
var
  s1,status1,
  Query:String;
    i:integer;
    reg:string;

begin
  i:=1;
  //stUpLoadPoint.Caption:='';
  // === подготавливаем документ для работы ===
  Query:='SELECT `dateDoc`,`registry`,`numdoc`,`summa`,`ClientName`,`status`,`EGAISFixNumber`,`ClientAccept`,`isDelete`,`issueclient`,`comment` FROM `docjurnale` WHERE (`type`="RetWayBill")AND (`registry`="-") '
  +'AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',startDateRetTTN)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',endDateRetTTN)+''') ORDER BY `datedoc`,`numdoc` ASC;';
 formStart.recbuf :=formStart.DB_query(Query) ;
 formStart.rowbuf := formStart.DB_next(formStart.recbuf);
  while formStart.rowbuf<>nil do
  begin
  //  sDate:=DefaultFormatSettings.ShortDateFormat;
 //   CurDate:=StrToDate(sDate);
    reg:=formStart.rowbuf[1];
     with StringGrid1.rows[i] do begin
       StringGrid1.RowCount:=i+1;
       Clear;
       add('');
       Add(trim(formStart.rowbuf[2]));         //0
       Add(trim(formStart.rowbuf[0]));         //1
       Add(trim(formStart.rowbuf[3]));         //2
       Add(trim(formStart.rowbuf[4]));         //2
//       Add(trim(formStart.rowbuf[3]));         //6
//       Add(trim(formStart.rowbuf[4]));         //7
//       Add(trim(formStart.rowbuf[5]));         //5
//       Add(trim(formStart.rowbuf[7]));         //7
//       Add(trim(formStart.rowbuf[6]));         //5
//      Add(formStart.rowbuf[4]);         //4
      if formStart.rowbuf[8]='+' then
       s1:='Помечен на удаление'
       else begin
          status1:= formStart.rowbuf[5];
          s1:='';
          case status1[1] of
          '-': s1:='Новый';
          '1': s1:='Готов к отправке!';
          '0': s1:='Ошибка отправки';
          '+': begin
            if status1[3] = '+' then
                 s1:='Принят в ЕГАИС'
               else begin
               if status1[3] = '1' then
                 s1:='Отказ в ЕГАИС'
               else
                 s1:='Изменен'
               end;
          end
          else
          end;
          status1:= formStart.rowbuf[7];
          case status1 of
          '+':
            s1:=s1+' - Принял клиент';
          '0':
            s1:=s1+' - Разногласие';
          '-':
            s1:=s1+' - Клиент отказал'
          else
          end;
          if formStart.rowbuf[9] = '+' then
            s1:=s1+' - Разногласие';

        end;
        Add(s1);
        Add(formStart.rowbuf[6]);         //4
      end;
       i:=i+1;
     formStart.rowbuf := formStart.DB_next(formStart.recbuf);
  end ;


end;


function TFormJurnale.addPanel(aName: String): TPanel;
begin

end;

function TFormJurnale.AddPanelItemMenu(aName: string; owPanel: TPanel;
  flSubItem: boolean; aFunct: String): integer;
begin
  if CountPanelItemMenu< 100 then
    begin
      arrPanelItem[CountPanelItemMenu].SubGroup:=flSubItem;
      arrPanelItem[CountPanelItemMenu].PanelMenu:=owPanel;
      arrPanelItem[CountPanelItemMenu].ItemMenu:=TStaticText.Create(nil);
      arrPanelItem[CountPanelItemMenu].ItemMenu.Parent:=owPanel as TWinControl;
      arrPanelItem[CountPanelItemMenu].ItemMenu.Top:=owPanel.Height;
      if flSubItem then begin
         arrPanelItem[CountPanelItemMenu].ItemMenu.Left:=3;
         arrPanelItem[CountPanelItemMenu].ItemMenu.Width:=owPanel.Width-5;
         arrPanelItem[CountPanelItemMenu].ItemMenu.Font.Color:=clGray;
         arrPanelItem[CountPanelItemMenu].ItemMenu.Font.Style:=[fsBold];
        end else begin
         arrPanelItem[CountPanelItemMenu].ItemMenu.Left:=40;
         arrPanelItem[CountPanelItemMenu].ItemMenu.Width:=owPanel.Width-42;
         arrPanelItem[CountPanelItemMenu].ItemMenu.OnMouseLeave:=@pmiMouseLeave;
         arrPanelItem[CountPanelItemMenu].ItemMenu.OnMouseMove:=@pmiMouseMove;
         arrPanelItem[CountPanelItemMenu].ItemMenu.OnClick:=@pmiClick;
         arrPanelItem[CountPanelItemMenu].ItemMenu.Cursor:=crHandPoint;
        end;
      arrPanelItem[CountPanelItemMenu].FunctionName:=aFunct;
      arrPanelItem[CountPanelItemMenu].ItemMenu.Height:=20;
      arrPanelItem[CountPanelItemMenu].ItemMenu.Visible:=true;
      arrPanelItem[CountPanelItemMenu].ItemMenu.Caption:=aName;
      arrPanelItem[CountPanelItemMenu].ItemMenu.Tag:=CountPanelItemMenu;
      owPanel.Height:=owPanel.Height+20;
      CountPanelItemMenu:=CountPanelItemMenu+1;
    end;
end;

procedure TFormJurnale.AutoSendTransferToShop;
var
    i:integer;
begin
  FormOstatok.FormShow(nil);
  formtransfertoshop.edNumDoc.text:=formstart.prefixClient+'-'+FormatDateTime('HHMMSS',now());
  formtransfertoshop.dpDateDoc.Date:=now();
  formtransfertoshop.StringGrid1.Clean;
  formtransfertoshop.StringGrid1.RowCount:=FormOstatok.stringgrid1.RowCount;
  for i:=1 to stringgrid1.RowCount-1 do begin
    formtransfertoshop.StringGrid1.Cells[1,i]:=FormOstatok.StringGrid1.Cells[2,i];
    formtransfertoshop.StringGrid1.Cells[2,i]:=FormOstatok.StringGrid1.Cells[1,i];
    formtransfertoshop.StringGrid1.Cells[3,i]:=FormOstatok.StringGrid1.Cells[4,i];
    formtransfertoshop.StringGrid1.Cells[4,i]:=FormOstatok.StringGrid1.Cells[5,i];
    formtransfertoshop.StringGrid1.Cells[5,i]:=FormOstatok.StringGrid1.Cells[9,i];
  end;
  FormTransferToShop.BitBtn2Click(nil);
  FormTransferToShop.BitBtn1Click(nil);
end;

function TFormJurnale.GetTabStatisVisible(Obj: TForm): boolean;
var
   i:integer;
   d: TATTabData;
begin
  result:=false;
  for i:=0 to FATTabControl.TabCount-1 do
   begin
     d:= FATTabControl.GetTabData(i);
     //(d.TabObject as TForm).hide;
     if d.TabObject = Obj then begin
       (d.TabObject as TForm).show;
       result:=true;
       FATTabControl.TabIndex:=i;
     end else (d.TabObject as TForm).hide;
   end;

end;

procedure TFormJurnale.refreshRests();
begin

end;

procedure TFormJurnale.refreshReply();
var
  i:integer;
  status1:String;
  Query:String ;
  rowbuf : MYSQL_ROW;
  recbuf : PMYSQL_RES;
begin
  i:=1;
  Listview5.items.Clear;
  if not formStart.ConnectDB() then
    exit;
  // if ToggleBox1.Checked then
  Query:='SELECT `NumDoc`,`dateDoc`,`ClientName`,`status`,`uid` FROM `docjurnale` WHERE ((`type`=''ReplyPartner'')OR(`type`=''ReplyAP'')OR(`type`=''QueryPDF417''))AND(`dateDoc`>='''+FormatDateTime('YYYY-MM-DD',now()-30)+''')AND(`dateDoc`<='''+FormatDateTime('YYYY-MM-DD',now())+''') ORDER BY `datedoc` ASC;';
  if (mysql_query(formStart.sockMySQL,PChar(UTF8TOANSI(Query))) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  if formStart.recbuf=Nil then  begin
    formStart.disconnectDB();
    exit;
  end;
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do
   begin

     with ListView5.Items.Add do begin
       caption:= formStart.rowbuf[0];
       subitems.Add(formStart.rowbuf[1]);         //3
       subitems.Add(formStart.rowbuf[2]);
       status1:=formStart.rowbuf[3];
       if status1[1] = '-' then
          subitems.Add('Новый')
       else
          subitems.Add('отправлен в ЕГАИС');

       subitems.Add(formStart.rowbuf[4]);
       i:=i+1;
     end;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end ;
//  mysql_free_result (formStart.recbuf);
  formStart.disconnectDB();
end;

procedure TFormJurnale.RefreshNumFix();
var
  i:integer;
  status1:String;
  query:string;
  sLine:TStringList;
begin

  i:=1;
   sLine:=TStringList.Create();
  if not formStart.ConnectDB() then
    exit;
  Query:='SELECT AlcName,InformARegId,InformBRegId,Quantity,AlcCode FROM `regrestsproduct` ';
  Query:=Query+' ORDER BY `AlcCode` ASC;' ;
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
//  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do  begin
       sLine.Clear;
       sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
       sLine.Add('<ns:Documents Version="1.0"');
       sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
       sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
       sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
       sLine.Add('<ns:Owner>');
       sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
       sLine.Add('</ns:Owner>');
       sLine.Add('<ns:Document>');
       sLine.Add('<ns:QueryFormA>');
       sLine.Add('<qf:FormRegId>'+formStart.rowbuf[1]+'</qf:FormRegId>');
       sLine.Add('</ns:QueryFormA> ');
       sLine.Add('</ns:Document>');
       sLine.Add('</ns:Documents>');
       formStart.SaveToServerPOST('opt/in/QueryFormA',SLine.text);
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end  ;
  formStart.disconnectDB();
  sLine.Free;
end;

procedure TFormJurnale.RefreshNumFormB();
var
  i:integer;
  status1:String;
  query:string;
  sLine:TStringList;
begin
  i:=1;
  sLine:=TStringList.Create();
  if not formStart.ConnectDB() then
    exit;
  Query:='SELECT InformBRegId,dateTTN FROM `regrestsproduct` WHERE `dateTTN`="" ';
  Query:=Query+';' ;
  if (mysql_query(formStart.sockMySQL,PChar(Query)) < 0) then
   exit;
  formStart.recbuf := mysql_store_result(formStart.sockMySQL);
  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
//  formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
  while formStart.rowbuf<>nil do  begin
       if formStart.rowbuf[1] = '' then begin
         sLine.Clear;
         sLine.Add('<?xml version="1.0" encoding="UTF-8"?>');
         sLine.Add('<ns:Documents Version="1.0"');
         sLine.Add(' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
         sLine.Add(' xmlns:ns="http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ');
         sLine.Add(' xmlns:qf="http://fsrar.ru/WEGAIS/QueryFormAB"> ');
         sLine.Add('<ns:Owner>');
         sLine.Add('<ns:FSRAR_ID>'+FormStart.EgaisKod+'</ns:FSRAR_ID>');
         sLine.Add('</ns:Owner>');
         sLine.Add('<ns:Document>');
         sLine.Add('<ns:QueryFormB>');
         sLine.Add('<qf:FormRegId>'+formStart.rowbuf[0]+'</qf:FormRegId>');
         sLine.Add('</ns:QueryFormB> ');
         sLine.Add('</ns:Document>');
         sLine.Add('</ns:Documents>');
         formStart.SaveToServerPOST('opt/in/QueryFormB',SLine.text);
       end;
     formStart.rowbuf := mysql_fetch_row(formStart.recbuf);
   end  ;
  formStart.disconnectDB();
  sLine.Free;
end;






end.

