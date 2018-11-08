program Problem_Sender;

uses
  Vcl.Forms,
  main in 'main.pas' {MainForm},
  config in 'config.pas' {ConfigForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
