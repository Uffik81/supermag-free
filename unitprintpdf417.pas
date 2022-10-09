unit unitPrintPDF417;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons;

type

  { TFormPrintPDF417 }

  TFormPrintPDF417 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    frReport1: TfrReport;
    Image1: TImage;
    StaticText1: TStaticText;
    ToolBar1: TToolBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormPrintPDF417: TFormPrintPDF417;

implementation

{$R *.lfm}
uses pdf417lib, pdf417libimp;
{ TFormPrintPDF417 }
var
 Buffer1:array[0..1000,0..30] of boolean;
 lengthX,lengthY:integer;
 {
 function addwordb(const aWord:int64;x,y:integer;aSize:integer):integer;
 const
   bytetobit:array[0..18] of int64 = (1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144);
 var
    i:integer;
     wordL:integer;
     wordH:int64;
     wordB:array[0..6] of byte;
 begin

    i:=0;
    wordh:=aWord;
    wordL:=x;
    for i:= aSize-1 downto 0 do begin
      if ( wordh and bytetobit[i] ) <>0 then  begin
        buffer1[wordL,y]:=true;
        pix1(xdelt+i,ydelt+40-1+ii,clBlack);
        end else begin
         buffer1[wordL,y]:=false;
        end;
      wordL:=wordL+1;
    end;
    result:=x+aSize;
     //buffer1[
 end;        }

procedure GeneratorPDF417(const aStr:String);


var
  i:integer;
  strbuff:string;
  lenB:integer;

  x,y:integer;


begin
  x:=0;
  y:=0;
  lengthX:=0;
  lengthY:=0;
//  strBuff:=utf8toAnsi(aStr);

//  x:=addwordb(START_PATTERN,x,y,17);
//  x:=addwordb(STOP_PATTERN,x,y,18);
  lengthX:=x;
end;

procedure TFormPrintPDF417.FormShow(Sender: TObject);
begin
  image1.Canvas.FillRect(0,0,image1.Width,image1.Height);
  FrReport1.Clear;
  FrReport1.LoadFromFile('report\pdf417.lrf');

end;

procedure TFormPrintPDF417.frReport1EnterRect(Memo: TStringList; View: TfrView);
  var
    bm:TBitmap;
    Height1,Width1:integer;
    p1:Pdf417param;
//   qrpm: TDelphiZXingQRCode;
  begin
    if View.Name = 'Picture1' then begin
      Height1:= TfrPictureView(View).Picture.Bitmap.Height;
      Width1 := TfrPictureView(View).Picture.Bitmap.Width;
      TfrPictureView(View).Picture.Bitmap.FreeImage;
      TfrPictureView(View).Picture.Bitmap.Assign(Image1.Picture.Bitmap);
    end;

end;

procedure TFormPrintPDF417.BitBtn2Click(Sender: TObject);
  procedure pix1(x,y:integer;col:tColor);
  begin
    image1.Canvas.Pixels[x*3,y*3]:=col;
    image1.Canvas.Pixels[x*3+1,y*3]:=col;
    image1.Canvas.Pixels[x*3,y*3+1]:=col;
    image1.Canvas.Pixels[x*3+1,y*3+1]:=col;

    image1.Canvas.Pixels[x*3+2,y*3]:=col;
    image1.Canvas.Pixels[x*3+2,y*3+1]:=col;
    image1.Canvas.Pixels[x*3+2,y*3+2]:=col;
    image1.Canvas.Pixels[x*3+1,y*3+2]:=col;
    image1.Canvas.Pixels[x*3,y*3+2]:=col;
  end;

  function addwordb(const aWord:int64;x,y:integer;aSize:integer):integer;
  const
    bytetobit:array[0..18] of int64 = (1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144);
  var
     i:integer;
      wordL:integer;
      wordH:int64;
      wordB:array[0..6] of byte;
  begin

     i:=0;
     wordh:=aWord;
     wordL:=x;
     for i:= aSize-1 downto 0 do begin
       if ( wordh and bytetobit[i] ) <>0 then  begin
         buffer1[wordL,y]:=true;
         pix1(10+wordL,10+y,clBlack);
         end else begin
          buffer1[wordL,y]:=false;
          pix1(10+wordL,10+y,clWhite);
         end;
       wordL:=wordL+1;
     end;
     result:=x+aSize;
      //buffer1[
  end;

  const
    bithex:array[0..7] of integer = (1,2,4,8,16,32,64,128);
  var ii,y,ind1,
    i:integer;
    bit1:integer;
    p:pdf417lib.pdf417param;
    xdelt,ydelt:integer;
    edge,prtx,
    row,rowmod:integer;
    codePtr:integer;
  begin
    ydelt:=10;
    xdelt:=10;
//    GeneratorPDF417( edit1.Text);

    image1.Canvas.FillRect(0,0,image1.Width,image1.Height);

    pdf417lib.pdf417init(@p);
    //p.options:= p.options or PDF417_FIXED_COLUMNS;
  //  p.codeColumns:=5;
  //  p.codeRows:=16;
    p.aspectRatio:=1;
    p.text:=pchar(utf8toansi(edit1.Text));
    p.lenText:=length(edit1.Text);
    pdf417lib.paintCode(@p);
  {  i:=0;
    y:=0;
    for ii:=0 to p.lenBits - 1 do
      for ind1:=0 to 7 do   begin
      bit1:=ord(p.outBits[ii]);
      if (bit1 and bithex[ind1]) <> 0 then
        pix1(xdelt+i+1,ydelt+y,clBlack)
       else
        pix1(xdelt+i+1,ydelt+y,clWhite);
      i:=i+1;
      if i > p.bitColumns then begin
        i:=0;
        y:=y+1;
      end;
    end;   }


  lengthx:=0;
  lengthy:=0;
  codePtr:=0;
  for row:=0 to p.codeRows-1 do begin
    rowMod := row mod 3;
    case rowMod of
      0: edge := 30 * (row div 3) + ((p.codeRows - 1) div 3);
      1: edge := 30 * (row div 3) + p.errorLevel * 3 + ((p.codeRows - 1) mod 3);
      else edge := 30 * (row div 3) + p.codeColumns - 1;
    end;
    prtx:=0;
    y:=row;
    prtx:=addwordb(START_PATTERN,prtx,y,17);
    prtx:=addwordb(CLUSTERS[rowMod][edge],prtx,y,17);
    for ii:=0 to p.codeColumns - 1 do begin
       prtx:=addwordb(CLUSTERS[rowMod][p.codewords[codePtr]],prtx,y,17);
       codePtr:=codePtr+1;
    end;
    case rowMod of
      0: edge := 30 * (row div 3) + p.codeColumns - 1;
      1: edge := 30 * (row div 3) + ((p.codeRows - 1) div 3);
      else edge := 30 * (row div 3) + p.errorLevel * 3 + ((p.codeRows - 1) mod 3);
    end;
    prtx:=addwordb(CLUSTERS[rowMod][edge],prtx,y,17);
    prtx:=addwordb(STOP_PATTERN,prtx,y,18);
    lengthx:=prtx+1;
  end;

 { for ii:=0 to p.codeRows-1 do begin
     for i:=0 to lengthx do begin
       if buffer1[i,ii] then
        pix1(xdelt+i,ydelt+40-1+ii,clBlack)
       else
        pix1(xdelt+i,ydelt+40-1+ii,clWhite);
     end;

  end; }


  pdf417lib.pdf417free(@p);
end;

procedure TFormPrintPDF417.BitBtn1Click(Sender: TObject);
begin
  frReport1.ShowReport;
end;

end.

