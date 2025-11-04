program BinaryVisualizer;

uses
  Vcl.Forms,
  unFileContentViewer in 'unFileContentViewer.pas' {frmViewer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmViewer, frmViewer);
  Application.Run;
end.
