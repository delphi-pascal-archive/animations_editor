unit AnVisu2;   //  Gestion des fichiers images
                //  inspiré par la Gestion de fichier binaire de Caribensila
interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls, ExtCtrls,
  Dialogs, Jpeg;

const
  version = 'Anx 3.3';
type
  TParima = record               // Paramètres image
              posima : integer;      // position de l'image dans le stream
              taille : integer;      // taille de l'image
              ftype  : integer;      // 0 = bitmap - 1 = jpeg
              delai  : integer;      // durée d'affichage
            end;
  TParfilm = record               // Paramètres généraux
              dimX,
              dimY : integer;       // dimensions de l'écran
              nbse : integer;       // nbre de séquence
              nbsn : integer;       // nbre de modules son
            end;
  TParseq = record
              num,
              nbi,                 // nbre d'images
              snb : integer;       // nbre de lignes de script
            end;
  TParson = record
              psn : integer;       // position dans le stream
              dim : integer;       // taille du module
              ext : string[4];     // extension du fichier son
            end;
  var
    Prima,
    Image : TBitmap;
    Jpgim : TJPEGImage;
    SonStrm,
    MemStrm,
    ImaStrm : TMemoryStream;
    FileStrm : TFileStream;
    Nbson,
    Nbseq,
    Nbima : integer;
    Pfilm : TParfilm;
    Pseq  : TParseq;
    MaxX,
    MaxY : integer;
    tbPima : array of TParima;
    tbPson : array of TParson;
    fond,
    inter : TBitmap;
    Ftitre,
    chemin : string;
    ipl,ipx,ipy,
    bcnb,bclg : integer;
    ipxy : array of TPoint;

    procedure Trace(n : integer);
    procedure Initialise;
    procedure Libere;
    procedure LitUneImage(pima : TParima);

implementation

procedure Trace(n : integer);
begin
  ShowMessage(IntToStr(n));
end;

procedure Initialise;
begin
  Prima := TBitmap.Create;
  Image := TBitmap.Create;
  Jpgim := TJPEGImage.Create;
  SonStrm := TMemoryStream.Create;
  ImaStrm := TMemoryStream.Create;
  MemStrm := TMemoryStream.Create;
end;

procedure Libere;
begin
  Prima.Free;
  Image.Free;
  Jpgim.Free;
  SonStrm.Free;
  ImaStrm.Free;
  MemStrm.Free;
end;

procedure LitUneImage(pima : TParima);
var  MemS : TMemoryStream;
begin
  ImaStrm.Position := pima.posima;
  MemS := TMemoryStream.Create;
  try
    MemS.SetSize(pima.taille);            
    MemS.CopyFrom(ImaStrm,pima.taille);
    MemS.Position := 0;
    case pima.ftype of
      0 : Image.LoadFromStream(Mems);
      1 : begin
            Jpgim.LoadFromStream(Mems);
            Image.Assign(Jpgim);
          end;
    end;
  finally
    MemS.Free;
  end;
end;

end.
