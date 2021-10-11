unit AnEd01;      // Editeur d'animation
{ Trois types de fichiers sont générés par le programme, stockés dans un dossier
  portant comme nom le titre du film :

  Pfilm.src : fichier source recevant :
  - La version du programme
  - La taille du titre
  - Le titre
  - Les paramètres généraux (Parfilm)
  - s'il y a lieu :
    - la table des paramètres son (tbPson)
    - la taille du stream son
    - le stream son lui-même (SonStrm).

  Pseq#.src : fichiers source séquence (# = numéro de séquence)
  - Les paamètres de la séquence (Pseq)
  - La taille de la liste des commandes
  - La liste des commandes
  - La table des paramètres images (tbPima)
  - La taille du stream images
  - Le stream images (ImaStrm).

  Titre_du_film.anx : le film définitif, assemblage des fichiers précédents.
  C'est ce fichier qui sera lu et interprété par le programme AnVisu.

  Seules les sons et les images sont chargées dans des MemoryStream pendant
  la mise en oeuvre du film.
  Cela facilite les manipulations d'images qui se font à travers la table des
  paramètres, par exemple :
    - Insertion  :  - les paramètres sont insérés à leur place dans la table
                    - l'image est ajoutée en fin du stream ImaStrm.
    - Suppression : on supprime les paramètres et on réorganise le stream pour
                    récupérer la place mémoire.
  L'ajout est plus simple puisqu'il se met en fin de table et stream.

  SonStrm empile simplement les modules son les uns à la suite des autres.

  Les instructions générés par les commandes sont détaillées dans l'aide.
  Ces instructions sont stockées dans la Mémo ScenBox, ce qui permet de les
  retoucher en place éventuellement.

  Attention : Les Items du combo CBox, les onglets de la PageControl PCscene
              et les procédures de mise en forme des instructions sont
              synchronisés, à modifier avec moultes précautions.
}
interface                     

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, Jpeg, StdCtrls, ExtCtrls, Menus, Math, Buttons,
  ComCtrls, AnEd02, AnEd05;

type
  TFmain = class(TForm)
    OPDlg: TOpenPictureDialog;
    FileBox: TListBox;
    Vimage: TImage;                       
    MainMenu1: TMainMenu;
    Test1: TMenuItem;
    Quitter1: TMenuItem;                   
    ODlg: TOpenDialog;
    Image1: TMenuItem;
    AjouterImages: TMenuItem;
    Inserer1Image: TMenuItem;
    Supprimer1Image: TMenuItem;
    SPDlg: TSavePictureDialog;
    Extraire1Image: TMenuItem;
    N1: TMenuItem;
    Couper1Image: TMenuItem;
    Copier1Image: TMenuItem;
    Coller1Image: TMenuItem;
    PBx_Film: TPaintBox;
    Image2: TImage;
    Image3: TImage;
    SBdroite: TSpeedButton;
    SBGauche: TSpeedButton;
    VShape: TShape;
    Pdur0: TPanel;
    Pdur1: TPanel;
    Pdur2: TPanel;
    Pdur3: TPanel;
    Pdur4: TPanel;
    Film1: TMenuItem;
    Nouveau1: TMenuItem;
    Ouvrir1: TMenuItem;
    Squence1: TMenuItem;
    Nouvelle1: TMenuItem;
    Ouvrir2: TMenuItem;
    EnregistrerSequence: TMenuItem;
    Enregistrer2: TMenuItem;
    Assembler1: TMenuItem;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Lab_X: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Lab_Y: TLabel;
    Label8: TLabel;
    Lab_Nbs: TLabel;
    Lab_Titre: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Lab_Seq: TLabel;
    Label9: TLabel;
    Lab_Nbi: TLabel;
    Lbnum1: TLabel;
    Lbnum2: TLabel;
    Lbnum3: TLabel;
    Lbnum4: TLabel;
    Lbnum5: TLabel;
    Pndel1: TPanel;
    Pndel2: TPanel;
    Pndel3: TPanel;
    Pndel4: TPanel;
    Pndel5: TPanel;
    Label7: TLabel;
    Lab_Enc: TLabel;
    SeqTest: TMenuItem;
    Temporiser1: TMenuItem;
    ScenBox: TMemo;
    FilmTest: TMenuItem;
    PnScript: TPanel;
    Label10: TLabel;
    CBox: TComboBox;
    Bt_OK: TButton;
    Modifier1: TMenuItem;
    Aide1: TMenuItem;
    PCscene: TPageControl;
    Tabs_A: TTabSheet;
    Label14: TLabel;
    Label11: TLabel;
    EdA_num: TEdit;
    CBA_trs: TCheckBox;
    EdA_psx: TLabeledEdit;
    EdA_psy: TLabeledEdit;
    EdA_tmp: TLabeledEdit;
    EdA_fon: TLabeledEdit;
    Tabs_B: TTabSheet;
    RGB: TRadioGroup;
    EdB_nbr: TLabeledEdit;
    Tabs_D: TTabSheet;
    Label17: TLabel;
    Label19: TLabel;
    EdD_tmp: TLabeledEdit;
    EdD_psy: TLabeledEdit;
    EdD_psx: TLabeledEdit;
    EdD_fon: TLabeledEdit;
    EdD_dby: TLabeledEdit;
    EdD_dbx: TLabeledEdit;
    CBD_trs: TCheckBox;
    EdD_num: TLabeledEdit;
    Tabs_F: TTabSheet;
    RgF: TRadioGroup;
    Tabs_M: TTabSheet;
    EdM_psy: TLabeledEdit;
    EdM_psx: TLabeledEdit;
    EdM_fon: TLabeledEdit;
    EdM_fin: TLabeledEdit;
    EdM_deb: TLabeledEdit;
    EdM_dby: TLabeledEdit;
    EdM_dbx: TLabeledEdit;
    CBM_trs: TCheckBox;
    EdM_nbr: TLabeledEdit;
    EdM_tmp: TLabeledEdit;
    Tabs_P: TTabSheet;
    EdP_psy: TLabeledEdit;
    EdP_psx: TLabeledEdit;
    EdP_fon: TLabeledEdit;
    EdP_fin: TLabeledEdit;
    EdP_deb: TLabeledEdit;
    EdP_dby: TLabeledEdit;
    EdP_dbx: TLabeledEdit;
    EdP_nbr: TLabeledEdit;
    EdP_tmp: TLabeledEdit;
    Tabs_V: TTabSheet;
    EdV_deb: TLabeledEdit;
    EdV_fin: TLabeledEdit;
    EdV_nbr: TLabeledEdit;
    EdV_tmp: TLabeledEdit;
    Tabs_T: TTabSheet;
    EdT_tmp: TLabeledEdit;
    Tabs_X: TTabSheet;
    EdX_lgr: TLabeledEdit;
    EdX_htr: TLabeledEdit;
    Tabs_S: TTabSheet;
    EdS_num: TLabeledEdit;
    RGS: TRadioGroup;
    Sono1: TMenuItem;
    Label12: TLabel;
    Lab_son: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QuitterClick(Sender: TObject);

    procedure NouveauFilmClick(Sender: TObject);
    procedure OuvrirFilmClick(Sender: TObject);
    procedure EnregistrerFilmClick(Sender: TObject);
    procedure ModifierFilmClick(Sender: TObject);
    procedure AssemblerFilmClick(Sender: TObject);

    procedure NouvelleSequenceClick(Sender: TObject);
    procedure ChargerSequence(nomf : string);
    procedure AfficherSequence;
    procedure OuvrirSequenceClick(Sender: TObject);
    procedure EnregistrerSequenceClick(Sender: TObject);
    procedure ReorganiserLaSequence;

    procedure AjouterImagesClick(Sender: TObject);
    procedure Inserer1ImageClick(Sender: TObject);
    procedure Supprimer1ImageClick(Sender: TObject);
    procedure AfficherImages(db,fn : integer);
    procedure FormatVignette;
    procedure Extraire1ImageClick(Sender: TObject);
    procedure Couper1ImageClick(Sender: TObject);
    procedure Copier1ImageClick(Sender: TObject);
    procedure Coller1ImageClick(Sender: TObject);
    procedure Pndel1Click(Sender: TObject);
    procedure Temporiser1Click(Sender: TObject);
    procedure SetLabIma;
    procedure InitVImage;
    procedure PBx_FilmPaint(Sender: TObject);
    procedure PBx_FilmMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

    function  Lbnum(no : byte) : TLabel;
    function  Pndel(no : byte) : TPanel;
    procedure SBdroiteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SBGaucheMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SeqTestClick(Sender: TObject);
    procedure FilmTestClick(Sender: TObject);
    procedure CBoxClick(Sender: TObject);
    procedure Bt_OKClick(Sender: TObject);
    procedure Sono1Click(Sender: TObject);

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
    procedure PCsceneChange(Sender: TObject);
    procedure ControleScene;
    procedure Aide1Click(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }

  end;

var
  Fmain: TFmain;

implementation     

{$R *.dfm}

const
  HH_DISPLAY_TOPIC        = $0000;
var
  noseq,nolig,
  debima,
  encours : integer;
  psx,psy,
  vgx,vgy : integer;
  minX : integer = 152;
  minY : integer = 114;
  Lscn : string;
  tempo : integer;
  bcb : boolean;

////////////////////////////////////////////////////////////////////////////////

function HtmlHelp(hwndCaller: HWND;pszFile: PChar; uCommand: UINT;
  dwData: DWORD): HWND; stdcall; external 'HHCTRL.OCX' name 'HtmlHelpA';

function QuelType(ext : string) : integer;
begin
  Result := -1;
  if LowerCase(ext) = '.bmp' then Result := 0
  else
    if (LowerCase(ext) = '.jpg') or (LowerCase(ext) = '.jpe') then Result := 1;
  if Result = -1 Then ShowMessage('Ce format d''image n''est pas reconnu.');
end;

////////////////////////////////////////////////////////////////////////////////

procedure TFmain.FormCreate(Sender: TObject);
begin
  FMain.DoubleBuffered := true;
  chemin := ExtractFilePath(Application.ExeName);
  Initialise;
  noseq := -1;
  Nbseq := 0;
  Nbson := 0;
  fond.Width := minX;
  fond.Height := minY;
  fond.Canvas.Brush.Color := clWhite;
  fond.Canvas.Brush.Style := bsSolid;
  fond.Canvas.Rectangle(0,0,minX,minY);
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Libere;
end;

procedure TFmain.QuitterClick(Sender: TObject);
begin
  Close;
end;

////////////// Paramètres Film /////////////////////////////////////////////////

procedure TFmain.NouveauFilmClick(Sender: TObject);
var  titre,ex,ey : string;
begin
  // Le titre sert entre autre à créer un dossier qui recevra les fichiers du
  // film. Il servira aussi à nommer le fichier définitif du film.
  titre := InputBox('Création de film', 'Donnez un titre', '');
  if titre = '' then exit;
  if not DirectoryExists(chemin+titre) then
    if not CreateDir(chemin+titre) then
      raise Exception.Create('Impossible de créer '+ chemin+titre);
  FTitre := titre;
  chemin := chemin+titre+'\';
  repeat
    ex := InputBox('Dimensions écran','Largeur : ','640');
    MaxX := StrToInt(ex);
  until MaxX > 0;
  repeat
    ey := InputBox('Dimensions écran','Hauteur : ','480');
    MaxY := StrToInt(ey);
  until MaxY > 0;
  Nbseq := 0;
  Nbson := 0;
  SetLength(tbPson,1);                 // création et initialisation de la
  with tbPson[0] do                    // table des paramètres son
  begin
    psn := 0;
    dim := 0;
    ext := '    ';
  end;
  Lab_Titre.Caption := Ftitre;
  Lab_X.Caption := ex;
  Lab_Y.Caption := ey;
  Lab_Nbs.Caption := IntToStr(Nbseq);
  Lab_son.Caption := IntToStr(Nbson);
  Pfilm.dimX := MaxX;                  // initialisation des paramètres
  Pfilm.dimY := MaxY;
  Pfilm.nbse := Nbseq;
  Pfilm.nbsn := Nbson;
  Ftest.ClientWidth := MaxX;           // mise en place de l'écran de test
  Ftest.ClientHeight := MaxY;
  Ftest.Left := (Screen.Width - MaxX) div 2;
  Ftest.Top := (Screen.Height - MaxY) div 2;
end;

procedure TFmain.OuvrirFilmClick(Sender: TObject);    // Pfilm.src
// on charge le fichier dans un MemoryStream et on récupère les éléments
var  mms : TMemoryStream;
     lg : integer;
     fnom : string;
     vs : string;
begin
  if ODlg.Execute then
  begin
    chemin := ExtractFilePath(ODlg.FileName);
    mms := TMemoryStream.Create;
    try
      mms.LoadFromFile(ODlg.FileName);
      mms.Position := 0;
      SetLength(vs,7);
      mms.ReadBuffer(vs[1],7);                   // version
      if vs <> version  then
      begin
        ShowMessage(vs+' Version incompatible');
        exit;
      end;                        
      mms.ReadBuffer(lg,1);                      // longeur du titre
      SetLength(Ftitre,lg);
      mms.ReadBuffer(Ftitre[1],lg);              // titre
      mms.ReadBuffer(Pfilm,SizeOf(TParfilm));    // record paramètres
      Nbson := Pfilm.nbsn;
      if Nbson > 0 then
      begin
        SetLength(tbPson,Nbson+1);
        for lg := 1 to Nbson do                  // table des paramètres son
          mms.ReadBuffer(tbPson[lg],SizeOf(TParson));
        mms.ReadBuffer(lg,SizeOf(integer));      // longueur du stream son
        SonStrm.Clear;
        SonStrm.CopyFrom(mms,lg);                // stream son
      end;  
    finally
      mms.Free;
    end;
    Lab_Titre.Caption := Ftitre;
    Lab_X.Caption := IntToStr(Pfilm.dimX);
    Lab_Y.Caption := IntToStr(Pfilm.dimY);
    Lab_Nbs.Caption := IntToStr(Pfilm.nbse);
    Lab_son.Caption := IntToStr(Nbson);
    MaxX := Pfilm.dimX;
    MaxY := Pfilm.dimY;
    Nbseq := Pfilm.nbse;
    Ftest.ClientWidth := MaxX;             // on dimmensionne l'écran de test
    Ftest.ClientHeight := MaxY;
    Lab_Nbs.Caption := IntToStr(Nbseq);
    if Nbseq > 0 then                      // on charge en même temps la
    begin                                  // première séquence
      fnom := ExtractFilePath(ODlg.FileName)+'Pseq1.src';
      if FileExists(fnom) then
        ChargerSequence(fnom);
    end;
  end;
end;

procedure TFmain.FilmTestClick(Sender: TObject);  // test du film complet
var  i : integer;
     fnom : string;
begin
  if Nbseq > 0 then                      // exécution des séquences
    for i := 1 to Nbseq do
    begin
      fnom := chemin+'\Pseq'+IntToStr(i)+'.src';
      if FileExists(fnom) then
      begin
        ChargerSequence(fnom);
        SeqTestClick(self);
      end;
    end;
  if bson then Ftest.Fermer;    // on arrête le son
end;

procedure TFmain.ModifierFilmClick(Sender: TObject);
// les modifications au niveau du film se limitent au dimensions de l'écran
// et au nombre de séquences (en cas de supression de l'une d'elle).
var  ex,ey,nb : string;
begin
  repeat
    ex := InputBox('Dimensions écran','Largeur : ',Lab_X.Caption);
    MaxX := StrToInt(ex);
  until MaxX > 0;
  repeat
    ey := InputBox('Dimensions écran','Hauteur : ',Lab_Y.Caption);
    MaxY := StrToInt(ey);
  until MaxY > 0;
  nb := InputBox('Film '+Ftitre,'Nbre de séquences :',IntToStr(nbseq));
  Nbseq := StrToInt(nb);
  Lab_X.Caption := ex;
  Lab_Y.Caption := ey;
  Lab_nbs.Caption := nb;
  Pfilm.dimX := MaxX;
  Pfilm.dimY := MaxY;
  Pfilm.nbse := Nbseq;
end;

procedure TFmain.EnregistrerFilmClick(Sender: TObject);
// enregistrement des paramètres généraux du film. Les éléments sont
// rassemblés dans un MemeoryStream qui est ensuite copié dans un fichier.
var  mms : TMemoryStream;
     i,lg : integer;
begin
  if not DirectoryExists(chemin) then exit;
  Pfilm.nbse := Nbseq;
  Pfilm.nbsn := Nbson;
  mms := TMemoryStream.Create;
  try
    mms.WriteBuffer(version[1],7);
    lg := length(Ftitre);
    mms.WriteBuffer(lg,1);
    mms.WriteBuffer(Ftitre[1],lg);
    mms.WriteBuffer(Pfilm,SizeOf(TParfilm));
    if Nbson > 0 then
    begin
      for i := 1 to Nbson do
        mms.WriteBuffer(tbPson[i],SizeOf(TParson)); // paramètres son
      lg := SonStrm.Size;
      mms.WriteBuffer(lg,SizeOf(integer));          // taille du stream son
      mms.CopyFrom(SonStrm,0);
    end;
    mms.SaveToFile(chemin+'\Pfilm.src');
  finally
    mms.Free;
  end;
end;

procedure TFmain.AssemblerFilmClick(Sender: TObject);
// l'assemblage du film consiste à réunir dans un même fichier (.anx) tous les
// fichiers source (.src) pour créer le film complet.
var  mms : TMemoryStream;
     fnom : string;
     i : integer;
begin
  if not DirectoryExists(chemin) then exit;
  mms := TMemoryStream.Create;
  MemStrm.Clear;
  try
    mms.LoadFromFile(chemin+'\Pfilm.src');
    MemStrm.CopyFrom(mms,0);
    for i := 1 to Nbseq do
    begin
      fnom := chemin+'\Pseq'+IntToStr(i)+'.src';
      if FileExists(fnom) then
      begin
        mms.LoadFromFile(fnom);
        MemStrm.CopyFrom(mms,0);
      end
      else ShowMessage('Fichier '+ fnom +' non trouvé');
    end;
    MemStrm.SaveToFile(chemin+'\'+Ftitre+'.anx');
  finally
    mms.Free;
  end;
  ShowMessage('Assemblage terminé');
end;

////////////// Paramètres Séquence /////////////////////////////////////////////

procedure TFmain.NouvelleSequenceClick(Sender: TObject);
begin
  inc(Nbseq);
  noseq := Nbseq;
  nolig := 0;
  Pseq.num := noseq;
  Pseq.nbi := 0;
  Pseq.snb := 0;
  Lab_Nbs.Caption := IntToStr(Nbseq);
  Lab_Seq.Caption := IntToStr(noseq);
  Nbima := 0;
  Lab_Nbi.Caption := IntToStr(Nbima);
  SetLength(tbPima,1);                 // création et initialisation de la
  with tbPima[0] do                    // table des paramètres séquence
  begin
    posima := 0;
    taille := 0;
    ftype := 0;
    delai := 0;
  end;
  ScenBox.Clear;                      // initialisation de la liste des
  inter.Width := minX;                // des commandes (scenario)
  inter.Canvas.Draw(0,0,fond);
  PBx_Film.Repaint;
end;

procedure TFmain.ChargerSequence(nomf : string); // Pseq+n° de séquence+.src
// pour changer, on ne charge pas le ficher en bloc, mais par FileStream, on
// récupère les éléments un à un, soit directement, soit en passant par un
// memoryStream.
var  mms : TMemoryStream;
     lg : integer;
     st : string;
begin
  Ftest.Visible := false;     
  ScenBox.Clear;
  inter.Width := minX;
  inter.Canvas.Draw(0,0,fond);
  PBx_Film.Repaint;
  st := ExtractFilename(nomf);
  noseq := StrToInt(Copy(st,5,Length(st)-8)); // n° de séquence pris dans le
  mms := TMemoryStream.Create;                // nom du fichier
  try
    FileStrm := TFileStream.Create(nomf,fmOpenRead);
    FileStrm.ReadBuffer(Pseq,SizeOf(TParseq));  // paramètres de la séquence
    Pseq.num := noseq;
    Nbima := Pseq.nbi;
    FileStrm.ReadBuffer(lg,SizeOf(integer));    // longueur liste des commandes
    mms.CopyFrom(FileStrm,lg);
    mms.Position := 0;
    ScenBox.Lines.LoadFromStream(mms);          // liste des commandes
    SetLength(tbPima,Nbima+1);
    for lg := 1 to Nbima do                     // table des paramètres images
      FileStrm.ReadBuffer(tbPima[lg],SizeOf(TParima));
    FileStrm.ReadBuffer(lg,SizeOf(integer));    // longueur du stream d'images
    ImaStrm.Clear;
    ImaStrm.CopyFrom(FileStrm,lg);              // stream d'images
  finally
    mms.Free;
    FileStrm.Free;
  end;
  if Nbima < 6 then AfficherImages(1,Nbima)
  else AfficherImages(1,5);
  Lab_Seq.Caption := IntToStr(noseq);
  Lab_Nbi.Caption := IntToStr(Pseq.nbi);
end;

procedure TFmain.OuvrirSequenceClick(Sender: TObject);
begin
  if ODlg.Execute then
    ChargerSequence(ODlg.Filename);
end;

procedure TFmain.AfficherSequence;
var  nb : integer;
begin
  if Nbima > 5 then nb := 5
  else nb := Nbima;
  debima := 1;
  encours := debima;
  lgfilm := minX * nb;
  PBx_Film.Width := lgfilm;
  PBx_Film.Height := minY;
  VShape.Left := PBx_Film.Left;
  Lab_Nbi.Caption := IntToStr(Nbima);
  inter.Width := lgfilm;
  inter.Height := minY;
  AfficherImages(1,nb);
end;

procedure TFmain.ReorganiserLaSequence;
// après des modidications(insertion,suppression), réorganisation du stream
// d'images à l'aide de la table des paramètres
var  mems : TMemoryStream;
     i : byte;
begin
  mems := TmemoryStream.Create;
  try
    for i := 1 to Nbima do
    begin
      ImaStrm.Position := tbPima[i].posima;
      tbPima[i].posima := mems.Position;
      mems.CopyFrom(ImaStrm,tbPima[i].taille);
    end;
    ImaStrm.Clear;
    mems.Position := 0;
    ImaStrm.CopyFrom(mems,mems.Size);
  finally
    mems.Free;
  end;
end;

procedure TFmain.EnregistrerSequenceClick(Sender: TObject);
// enregistrement de la séquence. Les éléments sont rassemblés dans un
// MemeoryStream qui est ensuite copié dans un fichier.
var  mms : TMemoryStream;
     nomf : string;
     i,lg : integer;
begin
  ControleScene;
  Pseq.nbi := Nbima;
  Pseq.snb := ScenBox.Lines.Count;
  nomf := chemin+'\Pseq'+IntToStr(noseq)+'.src';    // nom du fichier
  MemStrm.Clear;
  mms := TMemoryStream.Create;
  try
    MemStrm.WriteBuffer(Pseq,SizeOf(TParseq));      // paramètres séquence
    ScenBox.Lines.SaveToStream(mms);
    lg := mms.Size;
    MemStrm.WriteBuffer(lg,SizeOf(integer));        // taille des commandes
    mms.Position := 0;
    MemStrm.CopyFrom(mms,lg);                       // commandes
    for i := 1 to Nbima do
      MemStrm.WriteBuffer(tbPima[i],SizeOf(TParima)); // paramètres images
    lg := ImaStrm.Size;
    MemStrm.WriteBuffer(lg,SizeOf(integer));        // taille du stream images
    ImaStrm.Position := 0;
    MemStrm.CopyFrom(ImaStrm,lg);                   // stream images
    MemStrm.SaveToFile(nomf);
  finally
    mms.Free;
  end;
end;

////////////// Menu Image //////////////////////////////////////////////////////

procedure TFmain.AjouterImagesClick(Sender: TObject);
// Ajout d'une ou plusieurs images. En cas de sélection multiple, il est bon
// que les fichiers soient numérotés dans l'ordre de leur utilisation. Il est
// néanmoins possible de modifier la position des images en place.
var  ext : string;
     typ : integer;
     i,fnima,nbi : integer;
begin
  if OPDlg.Execute then
  begin
    nbi := OPDlg.Files.Count;
    FileBox.Clear;
    FileBox.Items.Assign(OPDlg.Files);
    if Nbima = 0 then debima := Nbima+1;
    fnima := Nbima;
    for i := 1 to nbi do
    begin
      ImaFile := FileBox.Items[i-1];
      ext := ExtractFileExt(ImaFile);
      typ := QuelType(ext);
      if typ > -1 then
      begin
        inc(Nbima);
        inc(fnima);
        pseq.nbi := Nbima;
        SetLength(tbPima,Nbima+1);   // on agrandit la table des paramètres
        tbPima[Nbima] := tbPima[0];  // initialisation à l'aide de l'élément 0
        tbPima[Nbima].ftype := typ;  // on note le type de fichier image
        ImaStrm.Position := ImaStrm.Size;
        tbPima[Nbima].posima := ImaStrm.Position; // position dans le stream
        VImage.Picture.LoadFromFile(ImaFile);
        Image.Assign(VImage.Picture.Graphic);
        VImage.Picture.Graphic.SaveToStream(ImaStrm); // copie de l'image
        tbPima[Nbima].taille := ImaStrm.Position - tbPima[Nbima].posima;
        // la taille de l'image est calculée par différence entre sa position
        // et la taille du stream après ajout de l'image.
      end;
    end;
    AfficherImages(debima,fnima);
  end;
end;

procedure TFmain.Inserer1ImageClick(Sender: TObject);
// l'image est insérée à sa place (devant l'image en cours) dans la table
// et ajoutée en fin de stream.
var  ext : string;
     i,fni : integer;
begin
   if OPDlg.Execute then
  begin
    ImaFile := OPDlg.FileName;
    ext := ExtractFileExt(ImaFile);
    if QuelType(ext) = -1 then exit;
    tbPima[encours].ftype := QuelType(ext);
    inc(Nbima);
    Pseq.nbi := Nbima;
    SetLength(tbPima,Nbima+1);
    for i := Nbima-1 downto encours do tbPima[i+1] := tbPima[i];
    ImaStrm.Position := ImaStrm.Size;
    tbPima[encours].posima := ImaStrm.Position;
    VImage.Picture.LoadFromFile(ImaFile);
    Image.Assign(VImage.Picture.Graphic);
    VImage.Picture.Graphic.SaveToStream(ImaStrm);
    tbPima[encours].taille := ImaStrm.Position - tbPima[encours].posima;
    fni := debima + 4;
    while fni > Nbima do dec(fni);
    AfficherImages(debima,fni);
  end;
end;

procedure TFmain.Supprimer1ImageClick(Sender: TObject);
// l'image est supprimée de la table, puis le stream est réorganisé pour
// récupérer la place mémoire.
var  i,fni : integer;
begin
  if encours < Nbima then
    for i := encours to Nbima-1 do tbPima[i] := tbPima[i+1];
  dec(Nbima);
  Lab_Nbi.Caption := IntToStr(Nbima);
  ReorganiserLaSequence;
  fni := debima + 4;
  while fni > Nbima do dec(fni);
  encours := debima;
  AfficherImages(debima,fni);
  VShape.Left := PBx_Film.Left;
end;

procedure TFmain.AfficherImages(db,fn : integer);
var  i,n : integer;
begin
  i := 0;
  inter.Width := 0;
  inter.Height := minY;
  debima := db;
  for n := db to fn do
  begin
    inter.Width := inter.Width + minX;
    LitUneImage(tbPima[n]);
    FormatVignette;
    inter.Canvas.Draw(minX * (i),0,fond);
    inter.Canvas.Draw(minX * (i) + psx,psy,vignette);
    inc(i);
    PBx_Film.Repaint;
  end;
  encours := debima;
  SetLabIma;
end;

procedure TFmain.FormatVignette;
// réduction de la taille des images au format des vignettes affichées.
var   md : boolean;
begin
  md := false;
  vgx := Image.Width;
  vgy := Image.Height;
  if vgx > minX then
  begin
    vgy := vgy * minX div vgx;
    vgx := minX;
    md := true;
  end;
  if vgy > minY then
  begin
    vgx := vgx * minY div vgy;
    vgy := minY;
    md := true;
  end;
  if md then BitmapRedim(Image,vignette,vgx,vgy,true)
  else
    begin
      vignette.Width := vgx;
      vignette.Height := vgy;
      vignette.Canvas.CopyRect(Rect(0,0,vgx,vgy),Image.Canvas,Rect(0,0,vgx,vgy));
    end;
  if vgx < minX then psx := (minX-vgx) div 2 else psx := 0;
  if vgy < minY then psy := (minY-vgy) div 2 else psy := 0;
end;

procedure TFmain.InitVImage;
var  bmp : TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := Pfilm.dimX;
  bmp.Height := Pfilm.dimY;
  bmp.Canvas.Rectangle(bmp.Canvas.ClipRect);
  if tbPima[encours].ftype = 0 then VImage.Picture.Bitmap := bmp
  else begin
         jpgim.Assign(bmp);
         VImage.Picture.Graphic := jpgim;
       end;
  bmp.Free;
end;

procedure TFmain.Extraire1ImageClick(Sender: TObject);
// extraction d'une image du stream et sauvegarde dans un fichier.
begin
  if SPDlg.Execute then
  begin
    ImaStrm.Position := tbPima[encours].posima;
    InitVimage;
    VImage.Picture.Graphic.LoadFromStream(ImaStrm);
    Vimage.Picture.SaveToFile(SPDlg.FileName);
  end;
end;

procedure TFmain.Couper1ImageClick(Sender: TObject);
// mémorisation puis suppression d'une image du stream images
begin
  Copier1ImageClick(Self);
  Supprimer1ImageClick(Self);
end;

procedure TFmain.Copier1ImageClick(Sender: TObject);
// mémorisation d'une image à partir du stream images
begin
  MemStrm.Clear;
  svPima := tbPima[encours];
  ImaStrm.Position := svPima.posima;
  MemStrm.CopyFrom(ImaStrm,svPima.taille);
  Coller1Image.Enabled := true;
end;

procedure TFmain.Coller1ImageClick(Sender: TObject);
// insertion d'une image mémorisée devant l'image en cours.
var  i : integer;
begin
  if not Coller1Image.Enabled then exit;
  inc(Nbima);
  SetLength(tbPima,Nbima);
  for i := Nbima-1 downto encours do tbPima[i+1] := tbPima[i];
  ImaStrm.Position := ImaStrm.Size;
  tbPima[encours] := svPima;
  tbPima[encours].posima := ImaStrm.Position;
  MemStrm.Position := 0;
  ImaStrm.CopyFrom(MemStrm,svPima.taille);
  ReorganiserLaSequence;
  AfficherSequence;
end;

procedure TFmain.PBx_FilmPaint(Sender: TObject);
begin
 PBx_Film.Canvas.Draw(0,0,inter);
end;

procedure TFmain.PBx_FilmMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);  // Sélection d'une image
var  px : integer;
begin
  encours := debima + X div minX;
  Lab_Enc.Caption := IntToStr(encours);
  px := minX * (encours-debima);
  VShape.Left := PBx_Film.Left+px;
end;

////////////// Affichage et Mise à jour des paramètres /////////////////////////

procedure TFmain.SetLabIma;
var  n,x : integer;
begin
  n := debima;
  x := 1;
  repeat
    Lbnum(x).Caption := IntToStr(n);
    Pndel(x).Caption := IntToStr(tbPima[n].delai);
    inc(n);
    inc(x);
  until (n > Nbima) or (x > 5);
  Lab_Nbi.Caption := IntTostr(Nbima);
  Lab_Enc.Caption := IntTostr(encours);
end;

function TFmain.Lbnum(no : byte) : TLabel;
// adressage d'un composant TLabel.
begin
  result := FindComponent('Lbnum'+ IntToStr(no)) as TLabel;
end;

function TFmain.Pndel(no : byte) : TPanel;
// adressage d'un composant TPanel.
begin
  result := FindComponent('Pndel'+ IntToStr(no)) as TPanel;
end;

procedure TFmain.SBdroiteMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// décalage de la bande images vers la droite
var  fni : integer;
begin
  if Nbima < 6 then exit;
  if Button = mbleft then
  begin
    if debima+4 >= Nbima then exit;        // 1 image
    inc(debima);
  end
  else begin
         if debima+5 > Nbima then exit;    // 5 images
         inc(debima,5);
       end;
  fni := debima+4;
  while fni > Nbima do dec(fni);
  encours := debima;
  AfficherImages(debima,fni);
  VShape.Left := PBx_Film.Left;
end;

procedure TFmain.SBGaucheMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// décalage de la bande images vers la gauche
var  fni : integer;
begin
  if (Nbima < 6) or (debima = 1) then exit;
  if Button = mbleft then
  begin
    if debima = 1 then exit;
    dec(debima);
  end
  else begin
         if debima < 6 then debima := 1
         else dec(debima,5);
       end;
  fni := debima+4;
  while fni > Nbima do dec(fni);
  encours := debima;
  AfficherImages(debima,fni);
  VShape.Left := PBx_Film.Left;
end;

/////////////////////////////// Test ///////////////////////////////////////////

// procédures d'exécution des commandes
// pour l'explication des paramètres voir le fichier d'aide.

procedure TFmain.Code_A(fon,num,psx,psy,tmp,trs : integer);
// Afficher une image
begin
  if fon > 0 then                       // Affichage d'un fond ?
    begin
      LitUneImage(tbPima[fon]);
      Image.Transparent := false;
      Prima.Canvas.Draw(0,0,Image);
    end;
  LitUneImage(tbPima[num]);
  if trs = 0 then                       // image transparente ?
    Image.Transparent := false
  else
    begin
      Image.Transparent := true;
      Image.TransparentMode := tmAuto;
    end;
  Prima.Canvas.Draw(psx,psy,Image);
  if tmp > 0 then tempo := tmp*10
  else tempo := tbPima[num].delai*10;
  if not bcb then                     // si l'image est incluse dans une boucle
  begin                               // elle sera affichée en fin de boucle
    FTest.Ecran.Picture.Graphic := Prima;
    FTest.Ecran.Repaint;
    Sleep(tempo);
  end;
end;

procedure TFmain.Code_B(act,nbr,brc : integer);   // Boucle
var  i : integer;
begin
  case act of
    0 : begin               // début
          bcb := true;      // boucle active
          bcnb := nbr-1;    // nbre de répétition
          bclg := brc;      // adresse de branchement
          for i := ipl to ScenBox.Lines.Count-1 do ipxy[i].X := MaxInt;
          // ipxy[] est une table permettant de stocker la position d'une image
          // dans une boucle. Chaque élément correspond à une ligne de commande.
        end;
    1 : begin               // fin
          FTest.Ecran.Picture.Bitmap := Prima;
          FTest.Ecran.Repaint;
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

procedure TFmain.Code_D(fon,num,dx,dy,px,py,tmp,trs : integer);
// défilement d'une image. Celle-ci est affichée puis sa position est
// incrémentée pour l'affichage suivant. A utiliser dans une boucle.
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
    FTest.Ecran.Picture.Graphic := Prima;
    Ftest.Ecran.Repaint;
    Sleep(tempo);
  end;
end;

procedure TFmain.Code_F(sns : integer);   // Fondu
var  i : integer;
begin
  if sns = 0 then
    for i := 255 downto 0 do         // disparition
    begin
      Ftest.AlphaBlendValue := i;
      Sleep(10);
    end
  else
    for i := 0 to 255 do             // apparition
    begin
      Ftest.AlphaBlendValue := i;
      Sleep(10);
    end;
end;

procedure TFmain.Code_M(fon,deb,fin,nbr,dx,dy,px,py,tmp,trs : integer);
// Répétition d'une série d'images avec déplacement de leur position.
var  nb,ec,x,y : integer;
begin
  if ipxy[ipl].X = MaxInt then ipxy[ipl] := Point(dx,dy);
  x := ipxy[ipl].X;
  y := ipxy[ipl].Y;
  for nb := 1 to nbr do       // boucle répétion
  begin
    for ec := deb to fin do       // boucle images
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
      FTest.Ecran.Picture.Graphic := Prima;
      FTest.Ecran.Repaint;
      Sleep(tmp*10);
    end;
  end;
  ipxy[ipl] := Point(x,y);
end;

procedure TFmain.Code_P(fon,deb,fin,nbr,dx,dy,px,py,tmp : integer);
// Répétition d'une série d'images avec déplacement du fond.
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
      Ftest.Ecran.Picture.Graphic := Prima;
      Ftest.Ecran.Repaint;
      Sleep(tmp*10);
      inc(x,px);
      inc(y,py);
    end;
  end;
  ipxy[ipl] := Point(x,y);
end;

procedure TFmain.Code_S(num,act : integer);  // Son
var  parm : TParson;
     mms : TMemoryStream;
begin
  if act = 0 then
  begin
    parm := tbPson[num];
    fson := chemin+'\Sono'+parm.ext;
    SonStrm.Position := parm.psn;
    mms := TMemoryStream.Create;
    mms.SetSize(parm.dim);
    mms.CopyFrom(SonStrm,parm.dim);
    mms.Position := 0;
    mms.SaveToFile(fson);
    mms.Free;
    Ftest.Ouvrir;
    Ftest.Jouer;
  end
  else begin
         Ftest.Fermer;
         if FileExists(fson) then DeleteFile(fson);
       end;
end;

procedure TFmain.Code_T(tmp : integer);  // Temporisation
begin
  tempo := tmp*10;
  if not bcb then sleep(tempo);
end;
 
procedure TFmain.Code_V(deb,fin,nbr,tmp : integer);
// Suite d'images (diaporama)
var  nb,ec : integer;
begin
  for nb := 1 to nbr do
  begin
    for ec := deb to fin do
    begin
      LitUneImage(tbPima[ec]);
      Image.Transparent := false;
      Ftest.Ecran.Picture.Graphic := Image;
      Ftest.Ecran.Repaint;
      Sleep(tmp*10);
    end;
  end;
end;

procedure TFmain.Code_X(lg,ht : integer);   // modification taille écran
begin
  Ftest.Ecran.Visible := False;
  MaxX := lg;
  MaxY := ht;
  Prima.Width := MaxX;
  Prima.Height := MaxY;
  Pfilm.dimX := MaxX;
  Pfilm.dimY := MaxY;
  Ftest.ClientWidth := MaxX;
  Ftest.ClientHeight := MaxY;
  Ftest.Ecran.Width := MaxX;
  Ftest.Ecran.Height := MaxY;
  Ftest.Left := (Screen.Width - MaxX) div 2;
  Ftest.Top := (Screen.Height - MaxY) div 2;
  Ftest.Ecran.Visible := True;
end;

procedure TFmain.SeqTestClick(Sender: TObject);
// Test d'exécution d'une séquence
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

begin                // analyse et exécution des commandes
  ControleScene;
  Ftest.ClientWidth := MaxX;
  Ftest.ClientHeight := MaxY;
  Ftest.Left := (Screen.Width - MaxX) div 2;
  Ftest.Top := (Screen.Height - MaxY) div 2;
  Ftest.Visible := true;
  Ftest.Ecran.Visible := true;
  Ftest.AlphaBlendValue := 255;
  Prima.Width := MaxX;
  Prima.Height := MaxY;
  nb := ScenBox.Lines.Count;
  SetLength(ipxy,nb);
  if nb < 0 then exit;
  for i := 0 to ScenBox.Lines.Count-1 do ipxy[i].X := MaxInt;
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
              tp[2] := ipl;                // adresse de branchement
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
      'E' : Ftest.AlphaBlendValue := 0;
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
    inc(ipl);        
  until ipl >= nb;
  Ftest.Visible := false;
end;

procedure TFmain.Pndel1Click(Sender: TObject);
var  tag : byte;
     tm : string;
begin
  tag := (Sender as TPanel).Tag;
  tm := InputBox('Temporisation','Durée en 1/100 sec : ','0');
  Pndel(tag+1).Caption := tm;
  tbPima[debima+tag].delai := StrToInt(tm);
end;

procedure TFmain.Temporiser1Click(Sender: TObject);
// application d'un délai identique à toutes les images. Ce délai peut être
// modifié au niveau des commandes.
var  tm : string;
     i,dr : integer;
begin
  tm := InputBox('Temporisation générale','Durée en 1/100 sec : ','0');
  dr := StrToInt(tm);
  for i := 1 to Nbima do
  begin
    tbPima[i].delai := dr;
    if InRange(i,debima,debima+5) then Pndel(i-debima+1).Caption := tm;
  end;
end;

/////////////////// Saisie d'un scénario ///////////////////////////////////////

procedure TFmain.CBoxClick(Sender: TObject);
begin
  PCscene.ActivePageIndex := CBox.ItemIndex;
end;

procedure TFmain.Bt_OKClick(Sender: TObject);
// Mise en forme et affichage des lignes de commande. Le composant servant à
// les stocker étant un TMémo, il est possible de les modifier en place,
// supprimer, insérer, déplacer...
var  n : integer;
begin
  case CBox.ItemIndex of
    0 : begin
          Lscn := 'A(';
          n := StrToInt(EdA_Num.Text);
          if n < 1 then exit;
          Lscn := Lscn + EdA_fon.Text +',';
          Lscn := Lscn + EdA_num.Text +',';
          Lscn := Lscn + EdA_psx.Text +',';
          Lscn := Lscn + EdA_psy.Text +',';
          Lscn := Lscn + EdA_tmp.Text +',';
          if CBA_Trs.Checked then Lscn := Lscn + '1)'
          else Lscn := Lscn + '0)';
        end;
    1 : begin
          Lscn := 'B(';
          Lscn := Lscn + IntToStr(RgB.ItemIndex)+',';
          if RGB.ItemIndex = 0 then
            Lscn := Lscn + EdB_nbr.Text +')'
          else Lscn := Lscn + '0)';
        end;
    2 : begin
          Lscn := 'D(';
          Lscn := Lscn + EdD_fon.Text +',';
          Lscn := Lscn + EdD_num.Text +',';
          Lscn := Lscn + EdD_dbx.Text +',';
          Lscn := Lscn + EdD_dby.Text +',';
          Lscn := Lscn + EdD_psx.Text +',';
          Lscn := Lscn + EdD_psy.Text +',';
          Lscn := Lscn + EdD_tmp.Text +',';
          if CBD_trs.Checked then Lscn := Lscn + '1)'
          else Lscn := Lscn + '0)';
        end;
    3 : begin
          Lscn := 'F(';
          Lscn := Lscn + IntToStr(RgF.ItemIndex)+')';
        end;
    4 : begin
          Lscn := 'M(';
          Lscn := Lscn + EdM_fon.Text +',';
          Lscn := Lscn + EdM_deb.Text +',';
          Lscn := Lscn + EdM_fin.Text +',';
          Lscn := Lscn + EdM_nbr.Text +',';
          Lscn := Lscn + EdM_dbx.Text +',';
          Lscn := Lscn + EdM_dby.Text +',';
          Lscn := Lscn + EdM_psx.Text +',';
          Lscn := Lscn + EdM_psy.Text +',';
          Lscn := Lscn + EdM_tmp.Text +',';
          if CBM_trs.Checked then Lscn := Lscn + '1)'
          else Lscn := Lscn + '0)';
        end;
    5 : begin
          Lscn := 'P(';
          Lscn := Lscn + EdP_fon.Text +',';
          Lscn := Lscn + EdP_deb.Text +',';
          Lscn := Lscn + EdP_fin.Text +',';
          Lscn := Lscn + EdP_nbr.Text +',';
          Lscn := Lscn + EdP_dbx.Text +',';
          Lscn := Lscn + EdP_dby.Text +',';
          Lscn := Lscn + EdP_psx.Text +',';
          Lscn := Lscn + EdP_psy.Text +',';
          Lscn := Lscn + EdP_tmp.Text +')';
        end;
    6 : begin
          Lscn := 'S(';
          Lscn := Lscn + EdS_num.Text +',';
          if RGS.ItemIndex = 0 then Lscn := Lscn + '0)'
          else Lscn := Lscn + '1)';
        end;
    7 : begin
          Lscn := 'T(';
          Lscn := Lscn + EdT_tmp.Text +')';
        end;
    8 : begin
          Lscn := 'V(';
          Lscn := Lscn + EdV_deb.Text +',';
          Lscn := Lscn + EdV_fin.Text +',';
          Lscn := Lscn + EdV_nbr.Text +',';
          Lscn := Lscn + EdV_tmp.Text +')';
        end;
    9 : begin
          Lscn := 'X(';
          Lscn := Lscn + EdX_lgr.Text +',';
          Lscn := Lscn + EdX_htr.Text +')';
        end;
    10 : Lscn := 'E ';
  end;
  ScenBox.Lines.Add(Lscn);
end;

procedure TFmain.PCsceneChange(Sender: TObject);
begin
  CBox.ItemIndex := PCscene.ActivePageIndex;
end;

procedure TFmain.ControleScene;
// suppression des lignes inutiles
var i,nbl : integer;
    st : string;
begin
  nbl := ScenBox.Lines.Count-1;
  for i := nbl downto 0 do
  begin
    st := ScenBox.Lines[i];
    if (st = '') or (st[1] = ' ') then ScenBox.Lines.Delete(i);
  end;
end;

procedure TFmain.Sono1Click(Sender: TObject);
// Acquisition d'un fichier sono.
var  mms : TMemoryStream;
     lg : integer;
begin
  if ODlg.Execute then
  begin
    inc(Nbson);
    SetLength(tbPson,Nbson+1);   // on agrandit la table des paramètres
    tbPson[Nbson] := tbPson[0];  // initialisation à l'aide de l'élément 0
    tbPson[Nbson].ext := ExtractFileExt(ODlg.FileName);
    SonStrm.Position := SonStrm.Size;
    tbPson[Nbson].psn := SonStrm.Position; // position dans le stream
    mms := TMemoryStream.Create;
    try
      mms.LoadFromFile(Odlg.FileName);
      lg := mms.Size;
      tbPson[Nbson].dim := lg;
      SonStrm.CopyFrom(mms,lg);
    finally
      mms.Free;
    end;
    Lab_son.Caption := IntToStr(Nbson);
  end;
end;

procedure TFmain.Aide1Click(Sender: TObject);
// Affichage de l'aide
var  noma : string;
begin
  noma := chemin+'AnEdit.chm';
  HtmlHelp(Application.Handle,PChar(noma), HH_DISPLAY_TOPIC,0);
end;

end.
