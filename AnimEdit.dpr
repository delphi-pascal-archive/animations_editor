program AnimEdit;

uses
  Forms,
  AnEd01 in 'AnEd01.pas' {Fmain},
  AnEd02 in 'AnEd02.pas',
  AnEd05 in 'AnEd05.pas' {Ftest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFmain, Fmain);
  Application.CreateForm(TFtest, Ftest);
  Application.Run;
end.
