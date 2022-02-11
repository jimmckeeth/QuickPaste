program QuickPaste;

uses
  System.StartUpCopy,
  FMX.Forms,
  QP_Main in 'QP_Main.pas' {Form9};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
