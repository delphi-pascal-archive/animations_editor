program AnVisu;

uses
  Forms,
  AnVisu1 in 'AnVisu1.pas' {FVisu},
  AnVisu2 in 'AnVisu2.pas',
  AnVisu3 in 'AnVisu3.pas' {FEcran};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFVisu, FVisu);
  Application.CreateForm(TFEcran, FEcran);
  Application.Run;
end.
