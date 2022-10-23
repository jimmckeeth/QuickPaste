program QuickPaste;

uses
  System.StartUpCopy,
  FMX.Forms,
  QP_Main in 'QP_Main.pas' {Form9},
  ColorDialog in 'ColorDialog.pas' {frmColorDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TfrmColorDialog, frmColorDialog);
  Application.Run;
end.
