unit Editeur_niveau;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, ImgList;

type
  TForm1 = class(TForm)
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image2: TImage;
    Save: TBitBtn;
    Load: TBitBtn;
    Clear: TBitBtn;
    Back: TBitBtn;
    forg: TBitBtn;
    action: TBitBtn;
    Label1: TLabel;
    ImageList1: TImageList;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileSprites(source : TImage; ListeImg: TimageList);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure drawMap();
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;
  selSprite : integer;
  listPlateau  : array[0..149] of Integer;
Const
  SPRITE = 48;

implementation

{$R *.dfm}

//Cette procedure est appel� quand on clique sur le sprite � poser, et r�cup�re l'index correspondant dans l'image liste
procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index : integer;
begin
  index:=0;
  if (x>=0) and (x<49) then
  begin
    if(y>=0) and (y<49)then
      index:=1
    else if(y>48) and (y<97) then
      index:=4
    else index:=7;
  end
  else if(x>48) and (x<97) then
  begin
    if(y>=0) and (y<49)then
      index:=2
    else if(y>48) and (y<97) then
      index:=5
    else index:=8;
  end
  else if(x>96) then
  begin
    if(y>=0) and (y<49)then
      index:=3
    else if(y>48) and (y<97) then
      index:=6
    else index:=9;
  end;

  selSprite:=index-1;
end;

//D�coupe les sprites et les stockent dans l'imagelist
procedure TForm1.TileSprites(source : TImage; ListeImg: TimageList);
var MyBmp: TBitmap;
i, j, index: integer;
begin
  index:=0;
  MyBmp := TBitmap.Create();
  try
    MyBmp.Height:= SPRITE;
    MyBmp.Width := SPRITE;

    while index <9 do
    begin
      for i :=0 to SPRITE do
        for j :=0 to SPRITE do
        begin
          case index of
          0:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i,j];
          1:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+SPRITE,j];
          2:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+(SPRITE*2),j];
          3:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i,j+SPRITE];
          4:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+SPRITE,j+SPRITE];
          5:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+(SPRITE*2),j+SPRITE];
          6:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i,j+(SPRITE*2)];
          7:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+SPRITE,j+(SPRITE*2)];
          8:MyBmp.Canvas.Pixels[i,j]:=source.Canvas.Pixels[i+(SPRITE*2),j+(SPRITE*2)];
          else ShowMessage ('error');
          end

        end;
      ListeImg.Add(MyBmp, nil);
      index:=index+1;
    end
  finally
    FreeAndNil(MyBmp);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var i : integer;
begin
  TileSprites(Image2,ImageList1);

  for i:=0 to 149 do
    listPlateau[i]:=0;
    
  Image1.Canvas.Pen.Color:=clWhite;
  Image1.Canvas.Rectangle(0,0,image1.Width, Image1.Height);
end;

//Cette procedure s'execute quand on clique sur la zone d'�dition
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index, i, j, nX, nY : integer;
tmp : TBitmap;
begin
  index:=x div SPRITE;
  i:=X div SPRITE;
  j:=Y div SPRITE;
  tmp := TBitmap.Create;
  tmp.Height := Sprite;
  tmp.Width := Sprite;
  ImageList1.GetBitmap(selSprite,tmp);

  case j of
    0:index:=index ;
    1:index:=index+(15*j) ;
    2:index:=index+(15*j) ;
    3:index:=index+(15*j) ;
    4:index:=index+(15*j) ;
    5:index:=index+(15*j) ;
    6:index:=index+(15*j) ;
    7:index:=index+(15*j) ;
    8:index:=index+(15*j) ;
    9:index:=index+(15*j) ;
    else Showmessage('error');
  end;
  nX:=SPRITE*i;
  nY:=SPRITE*j;
  Image1.Canvas.Draw(nX,nY,tmp);
  listPlateau[index]:=selSprite;
  freeandnil(tmp);
end;

//R�initialise la zone d'�dition
procedure TForm1.ClearClick(Sender: TObject);
var i :integer;
begin
  for i:=0 to 149 do
    listPlateau[i]:=-1;
  Image1.Canvas.Pen.Color:=clWhite;
  image1.Canvas.Rectangle(0,0,image1.Width, Image1.Height);
end;

//Sauvegarde la map
procedure TForm1.SaveClick(Sender: TObject);
var myFile : TextFile;
Path, tmpLvl:string;
i : integer;
begin
  tmpLvl:='' ;
  path:= ExtractFilePath(Application.ExeName);
  if Edit1.Text<>'' then
  begin
    AssignFile(myFile, path+'map/'+Edit1.Text+'.txt');
    Rewrite(myFile);
    for i:=0 to 149 do
    begin
      tmpLvl:=tmpLvl+intToStr(i)+','+intToStr(listPlateau[i])+#13#10;
    end;
    WriteLN(myFile, tmpLvl);
    CloseFile(myFile);
  end
  else
    showmessage('Veuillez nommer votre map');
end;

//charge un niveau
procedure TForm1.LoadClick(Sender: TObject);
var path, tmp, lvlLoad : string;
myFile : TextFile;
i, tmpPos, tmpImg : integer;
begin
  lvlLoad:='';
  tmp:='';
  if Edit2.Text='' then
  begin
    ShowMessage('Veuillez entrer un nom de fichier');
    exit;
  end;

  path:= ExtractFilePath(Application.ExeName);

  if FileExists(path+'map/'+edit2.Text+'.txt') then
    begin
      AssignFile(myFile, path+'map/'+Edit2.Text+'.txt');
      Reset(myFile);
      while not EoF(myFile) do
      begin
        readLn(MyFile, tmp);
        i:=ansipos(',',tmp);
        if i<>0 then
        begin
          tmpPos:=StrToInt(copy(tmp,0,i-1));
          tmpImg:=StrToInt(copy(tmp,i+1,length(tmp)));
          listPlateau[tmpPos]:=tmpImg;
        end;

      end;
      CloseFile(myFile);
      drawMap();
    end
  else
    showmessage('Le fichier est introuvable');

end;

//dessine le niveau charg�
procedure TForm1.drawMap();
var i,pI, pJ, x, y : integer;
tmp : TBitmap;
begin
  tmp := TBitmap.Create;
  tmp.Height := SPRITE;
  tmp.Width := SPRITE;

  for i:=0 to 149 do
  begin
    if i<15 then
    begin
      x:=SPRITE*i;
      y:=0;
    end else
    begin
      pI:=i mod 15;
      pJ:=i div 15;
      x:=SPRITE*pI;
      y:=SPRITE*pJ;
    end;

    ImageList1.GetBitmap(listPlateau[i],tmp);
    Image1.Canvas.Draw(X,Y,tmp);
  end;
end;

end.
