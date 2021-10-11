unit AnVisu1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AnVisu2, AnVisu3, StdCtrls, Buttons;

type
  TFVisu = class(TForm)
    Ecran: TImage;
    ODlg: TOpenDialog;
    ScenBox: TMemo;
    SBProjection: TSpeedButton;
    SBQuitter: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBProjectionClick(Sender: TObject);
    procedure ChargerSequence(n : integer);
    procedure Code_A(fon,num,psx,psy,tmp,trs : integer);
    procedure Code_B(act,nbr,brc : integer);
    procedure Code_D(fon,num,dx,dy,px,py,tmp,trs : integer);
    procedure Code_F(sns : integer);
    procedure Code_M(fon,deb,fin,nbr,dx,dy,px,py,tmp,trs : integer);
    procedure Code_P(fon,deb,fin,nbr,dx,dy,px,py,tmp : integer);
    procedure Code_S(num,act : integer);
    procedure Code_T(tmp : integer);
    procedure Code_V(deb,fin,nbr,tmp : integer);
    procedure Code_X(lg,ht : integer);
    procedure JouerSequence;
    procedure SBQuitterClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FVisu: TFVisu;

implementation

{$R *.dfm}

var
  tempo : integer;
  bcb : boolean;

procedure TFVisu.FormCreate(Sender: TObject);
begin
  chemin := ExtractFilePath(Application.ExeName);
  ODlg.InitialDir := chemin;
  Initialise;
end;

procedure TFVisu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Libere;
end;

procedure TFVisu.SBProjectionClick(Sender: TObject);
var  i,nb,lg : integer;
     vs : string;
     lb : byte;
     mms : TMemoryStream;
begin
  if ODlg.Execute then
  begin
    SBProjection.Visible := false;
    SBQuitter.Visible := false;
    FileStrm := TFileStream.Create(ODlg.FileName,fmOpenRead);
    SetLength(vs,7);                       
    FileStrm.ReadBuffer(vs[1],7);
    if vs <> version  then
    begin
      ShowMessage(vs+' Version incompatible');
      SBProjection.Visible := true;
      SBQuitter.Visible := true;
      exit;
    end;
    FileStrm.ReadBuffer(lb,1);
    SetLength(Ftitre,lb);
    FileStrm.ReadBuffer(Ftitre[1],lb);
    FileStrm.ReadBuffer(Pfilm,SizeOf(TParfilm));
    Nbson := Pfilm.nbsn;
    if Nbson > 0 then
    begin
      SetLength(tbPson,Nbson+1);
      for i := 1 to Nbson do                        // table des paramètres son
        FileStrm.ReadBuffer(tbPson[i],SizeOf(TParson));
      FileStrm.ReadBuffer(lg,SizeOf(integer));      // longueur du stream son
      SonStrm.Clear;
      SonStrm.CopyFrom(FileStrm,lg);                // stream son
      for i := 1 to Nbson do
      begin
        mms := TMemoryStream.Create;
        try
          SonStrm.Position := tbPson[i].psn;
          mms.SetSize(tbPson[i].dim);
          mms.CopyFrom(SonStrm,tbPson[i].dim);
          mms.Position := 0;
          fson := chemin+'\Son'+IntToStr(i)+tbPson[i].ext;
          mms.SaveToFile(fson);
        finally
          mms.Free;
        end;
      end;
    end;
    FVisu.Caption := Ftitre;
    MaxX := Pfilm.dimX;
    MaxY := Pfilm.dimY;
    Nbseq := Pfilm.nbse;
    Prima.Width := MaxX;
    Prima.Height := MaxY;
    Prima.Canvas.Pen.Color := clWhite;
    Prima.Canvas.Rectangle(0,0,MaxX,MaxY);
    FEcran.ClientWidth := MaxX;
    FEcran.ClientHeight := MaxY;
    FEcran.Left := (Screen.Width - MaxX) div 2;
    FEcran.Top := (Screen.Height - MaxY) div 2;
    FEcran.Ecran.Picture.Bitmap := Prima;
    FEcran.Ecran.Repaint;
    FEcran.AlphaBlendValue := 255;
    for nb := 1 to Nbseq do ChargerSequence(nb);
    FileStrm.Free;
    FEcran.Visible := false;
    SBProjection.Visible := true;
    SBQuitter.Visible := true;
    if Nbson > 0 then
      for i := 1 to nbson do
      begin
        fson := chemin+'\Son'+IntToStr(i)+tbPson[i].ext;
        if FileExists(fson) then DeleteFile(fson);
      end;
  end;
end;

procedure TFVisu.ChargerSequence(n : integer);
var  mms : TMemoryStream;
     lg : integer;
begin
  ScenBox.Clear;
  mms := TMemoryStream.Create;
  try
    FileStrm.ReadBuffer(Pseq,SizeOf(TParseq));
    Nbima := Pseq.nbi;
    FileStrm.ReadBuffer(lg,SizeOf(integer));
    mms.CopyFrom(FileStrm,lg);
    mms.Position := 0;
    ScenBox.Lines.LoadFromStream(mms);
    SetLength(tbPima,Nbima+1);
    for lg := 1 to Nbima do
      FileStrm.ReadBuffer(tbPima[lg],SizeOf(TParima));
    FileStrm.ReadBuffer(lg,SizeOf(integer));
    ImaStrm.Clear;
    ImaStrm.CopyFrom(FileStrm,lg);
  finally
    mms.Free;
  end;
  JouerSequence;
end;

procedure TFVisu.Code_A(fon,num,psx,psy,tmp,trs : integer);
begin
  if fon > 0 then
  begin
    LitUneImage(tbPima[fon]);
    Image.Transparent := false;
    Prima.Canvas.Draw(0,0,Image);
  end;
  LitUneImage(tbPima[num]);
  if trs = 0 then
    Image.Transparent := false
  else
    begin
      Image.Transparent := true;
      Image.TransparentMode := tmAuto;
    end;
  Prima.Canvas.Draw(psx,psy,Image);
  if tmp > 0 then tempo := tmp*10
  else tempo := tbPima[num].delai*10;
  FEcran.Ecran.Picture.Bitmap := Prima;
  FEcran.Ecran.Repaint;
  Sleep(tempo);
end;

procedure TFVisu.Code_B(act,nbr,brc : integer);
var  i : integer;
begin
  case act of
    0 : begin
          bcb := true;
          bcnb := nbr-1;
          bclg := brc;
          for i := ipl to ScenBox.Lines.Count-1 do
            ipxy[i].X := MaxInt;
        end;
    1 : begin
          FEcran.Ecran.Picture.Bitmap := Prima;
          FEcran.Ecran.Repaint;
          Sleep(tempo);
          dec(bcnb);
          if bcnb > 0 then ipl := bclg
          else
            begin
              for i := ipl to ScenBox.Lines.Count-1 do ipxy[i].X := MaxInt;
              bcb := false;
            end;
        end;
  end;
end;

procedure TFVisu.Code_D(fon,num,dx,dy,px,py,tmp,trs : integer);
begin
  if ipxy[ipl].X = MaxInt then
    ipxy[ipl] := Point(dx,dy);
  if fon > 0 then
    begin
      LitUneImage(tbPima[fon]);
      Image.Transparent := false;
      Prima.Canvas.Draw(0,0,Image);
    end;
  LitUneImage(tbPima[num]);
  if trs = 1 then
  begin
    Image.Transparent := true;
    Image.TransparentMode := tmAuto;
  end
  else Image.Transparent := false;
  Prima.Canvas.Draw(ipxy[ipl].X,ipxy[ipl].Y,Image);
  tempo := tmp*10;
  inc(ipxy[ipl].X,px);
  inc(ipxy[ipl].Y,py);
  if not bcb then
  begin
    FEcran.Ecran.Picture.Graphic := Prima;
    FEcran.Ecran.Repaint;
    Sleep(tempo);
  end;
end;

procedure TFVisu.Code_F(sns : integer);
var  i : integer;
begin
  if sns = 0 then
    for i := 255 downto 0 do
    begin
      FEcran.AlphaBlendValue := i;
      Sleep(10);
    end
  else
    for i := 0 to 255 do
    begin
      FEcran.AlphaBlendValue := i;
      Sleep(10);
    end;
end;

procedure TFVisu.Code_M(fon,deb,fin,nbr,dx,dy,px,py,tmp,trs : integer);
var  nb,ec,x,y : integer;
begin
  if ipxy[ipl].X = MaxInt then ipxy[ipl] := Point(dx,dy);
  x := ipxy[ipl].X;
  y := ipxy[ipl].Y;
  for nb := 1 to nbr do
  begin
    for ec := deb to fin do
    begin
      if fon > 0 then
      begin
        LitUneImage(tbPima[fon]);
        Image.Transparent := false;
        Prima.Canvas.Draw(0,0,Image);
      end;
      LitUneImage(tbPima[ec]);
      if trs = 1 then
      begin
        Image.Transparent := true;
        Image.TransparentMode := tmAuto;
      end
      else Image.Transparent := false;
      inc(x,px);
      inc(y,py);
      Prima.Canvas.Draw(x,y,Image);
      FEcran.Ecran.Picture.Graphic := Prima;
      FEcran.Ecran.Repaint;
      Sleep(tmp*10);
    end;
  end;
  ipxy[ipl] := Point(x,y);
end;

procedure TFVisu.Code_P(fon,deb,fin,nbr,dx,dy,px,py,tmp : integer);
var  nb,ec,x,y : integer;
begin
  if ipxy[ipl].X = MaxInt then ipxy[ipl] := Point(dx,dy);
  x := ipxy[ipl].X;
  y := ipxy[ipl].Y;
  for nb := 1 to nbr do
  begin
    for ec := deb to fin do
    begin
      LitUneImage(tbPima[fon]);
      Image.Transparent := false;
      Prima.Canvas.Draw(x,y,Image);
      LitUneImage(tbPima[ec]);
      Image.Transparent := true;
      Image.TransparentMode := tmAuto;
      Prima.Canvas.Draw(0,0,Image);
      FEcran.Ecran.Picture.Graphic := Prima;
      FEcran.Ecran.Repaint;
      Sleep(tmp*10);
      inc(x,px);
      inc(y,py);
    end;
  end;
  ipxy[ipl] := Point(x,y);
end;

procedure TFVisu.Code_S(num,act : integer);  // Son
begin
  if act = 0 then
  begin
    fson := chemin+'\Son'+IntToStr(num)+tbPson[num].ext;
    FEcran.Ouvrir;
    FEcran.Jouer;
  end
  else FEcran.Fermer;
end;

procedure TFVisu.Code_T(tmp : integer);
begin
  tempo := tmp*10;
  if not bcb then sleep(tempo);
end;

procedure TFVisu.Code_V(deb,fin,nbr,tmp : integer);
var  nb,ec : integer;
begin
  for nb := 1 to nbr do
  begin
    for ec := deb to fin do
    begin
      LitUneImage(tbPima[ec]);
      Image.Transparent := false;
      FEcran.Ecran.Picture.Graphic := Image;
      FEcran.Ecran.Repaint;
      Sleep(tmp*10);
    end;
  end;
end;

procedure TFVisu.Code_X(lg,ht : integer);
begin
  FEcran.Ecran.Visible := False;
  MaxX := lg;
  MaxY := ht;
  Prima.Width := MaxX;
  Prima.Height := MaxY;
  Pfilm.dimX := MaxX;
  Pfilm.dimY := MaxY;
  FEcran.ClientWidth := MaxX;
  FEcran.ClientHeight := MaxY;
  FEcran.Left := (Screen.Width - MaxX) div 2;
  FEcran.Top := (Screen.Height - MaxY) div 2;
  FEcran.Ecran.Visible := True;
end;

procedure TFVisu.JouerSequence;
var  i,ip,nb,np : integer;
     tp : array[0..9] of integer;
     st,sp : string;
     cd : char;

  function ExtraitNum(sep : char) : integer;
  begin
    sp := '';
    while st[ip] <> sep do
    begin
      sp := sp+st[ip];
      inc(ip);
    end;
    if sp = '' then sp := '0';
    Result := StrToInt(sp);
  end;

begin
  nb := ScenBox.Lines.Count;
  if nb = 0 then exit;
  SetLength(ipxy,nb);
  for i := 0 to ScenBox.Lines.Count-1 do ipxy[i].X := MaxInt;
  FEcran.Visible := true;
  bcb := false;
  ipl := 0;
  repeat
    st := ScenBox.Lines[ipl];            
    cd := st[1];
    case cd of
      'A' : begin
              ip := 3;
              for np := 0 to 4 do
              begin
                tp[np] := ExtraitNum(',');
                inc(ip);
              end;
              tp[5] := ExtraitNum(')');
              Code_A(tp[0],tp[1],tp[2],tp[3],tp[4],tp[5]);
            end;
      'B' : begin
              ip := 3;
              tp[0] := ExtraitNum(',');
              inc(ip);
              tp[1] := ExtraitNum(')');
              tp[2] := ipl;
              Code_B(tp[0],tp[1],tp[2]);
            end;
      'D' : begin
              ip := 3;
              for np := 0 to 6 do
              begin
                tp[np] := ExtraitNum(',');
                inc(ip);
              end;
              tp[7] := ExtraitNum(')');
              Code_D(tp[0],tp[1],tp[2],tp[3],tp[4],tp[5],tp[6],tp[7]);
            end;
      'E' : FEcran.AlphaBlendValue := 0;
      'F' : begin
              ip := 3;
              Code_F(ExtraitNum(')'));
            end;
      'M' : begin
              ip := 3;
              for np := 0 to 8 do
              begin
                tp[np] := ExtraitNum(',');
                inc(ip);
              end;
              tp[9] := ExtraitNum(')');
              Code_M(tp[0],tp[1],tp[2],tp[3],tp[4],tp[5],tp[6],tp[7],tp[8],tp[9]);
            end;
      'P' : begin
              ip := 3;
              for np := 0 to 7 do
              begin
                tp[np] := ExtraitNum(',');
                inc(ip);
              end;
              tp[8] := ExtraitNum(')');
              Code_P(tp[0],tp[1],tp[2],tp[3],tp[4],tp[5],tp[6],tp[7],tp[8]);
            end;
      'S' : begin
              ip := 3;
              tp[0] := ExtraitNum(',');
              inc(ip);
              tp[1] := ExtraitNum(')');
              Code_S(tp[0],tp[1]);
            end;
      'T' : begin
              ip := 3;
              Code_T(ExtraitNum(')'));
            end;
      'V' : begin
              ip := 3;
              for np := 0 to 2 do
              begin
                tp[np] := ExtraitNum(',');
                inc(ip);
              end;
              tp[3] := ExtraitNum(')');
              Code_V(tp[0],tp[1],tp[2],tp[3]);
            end;
      'X' : begin
              ip := 3;
              tp[0] := ExtraitNum(',');
              inc(ip);
              tp[1] := ExtraitNum(')');
              Code_X(tp[0],tp[1]);
            end;
    end;
    if bcb then
    begin
      FEcran.Ecran.Picture.Bitmap := Prima;
      FEcran.Ecran.Repaint;
      Sleep(tempo);
    end;
    inc(ipl)
  until ipl >= nb;
//  FEcran.Visible := false;
(*
  if Nbson > 0 then
    for i := 1 to Nbson do
    begin
      fson := chemin+'\Son'+IntToStr(i)+tbPson[i].ext;
    end;
*)
end;

procedure TFVisu.SBQuitterClick(Sender: TObject);
begin
  Close;
end;

end.
