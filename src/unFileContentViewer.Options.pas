unit unFileContentViewer.Options;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Classes, System.Math, System.StrUtils,
  Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, Vcl.Samples.Spin;

type
  TfrmOptions = class(TForm)
    rgPixelFormat: TRadioGroup;
    BitBtn2: TBitBtn;
    chkSmoothResize: TCheckBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtWidth: TSpinEdit;
    edtHeight: TSpinEdit;
    procedure Changed(Sender: TObject);
  private
    FOnChanged: TNotifyEvent;
  public
    property OnChange: TNotifyEvent read FOnChanged write FOnChanged;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

procedure TfrmOptions.Changed(Sender: TObject);
begin
  if Assigned(FOnChanged) and Active then
    FOnChanged(Sender);
end;

end.
