unit AnEd05;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, MPlayer;

type
  TFtest = class(TForm)
    Ecran: TImage;
    MP: TMediaPlayer;
    MTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure MTimerTimer(Sender: TObject);
    procedure Ouvrir;
    procedure Fermer;
    procedure Jouer;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

  TMStatus = set of (msNoFile, msOpen, msPlaying, msPaused);

var
  Ftest: TFtest;
  MStat : TMStatus;
  fson : string;
  bson : boolean;

implementation

{$R *.dfm}

procedure TFtest.FormCreate(Sender: TObject);
begin
  Ftest.DoubleBuffered := true;
  bson := false;
end;
   
procedure TFtest.Ouvrir;
begin
  MP.FileName := fson;
  MP.Open;
  MStat := [msOpen];
end;

procedure TFtest.Jouer;
begin
  if msOpen in MStat then
    if mpCanPlay in MP.Capabilities then
    begin
      MP.Play;
      MStat := MStat-[msPaused]+[msPlaying];
      bson := true;
    end;
end;

procedure TFtest.MTimerTimer(Sender: TObject);   // Répétition
begin
  if msOpen in MStat then
  begin
    if (MP.Position = 0)
    or (MP.Position = MP.Length) then
      if msPlaying in MStat then
      begin
        MStat := MStat-[msPlaying];
      end;
    if MP.Position = MP.Length then
    begin
      Fermer;
      Ouvrir;
      Jouer;
    end;
  end;
end;

procedure TFtest.Fermer;
begin
  if msOpen in MStat then
  begin
    MP.Close;
    MStat := [msNoFile];
    bson := false;
  end;
end;

end.
