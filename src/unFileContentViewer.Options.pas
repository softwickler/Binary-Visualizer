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
    rgChunkSize: TRadioGroup;
    procedure Changed(Sender: TObject);
  private
    FOnChanged: TNotifyEvent;
    function GetChunkSize: Int64;
    procedure SetChunkSize(const Value: Int64);
  public
    property OnChange: TNotifyEvent read FOnChanged write FOnChanged;
    property ChunkSize: Int64 read GetChunkSize write SetChunkSize;
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

function TfrmOptions.GetChunkSize: Int64;
begin
  Result := StrToInt(StringReplace(rgChunkSize.Items[rgChunkSize.ItemIndex], 'MB', '', [])) * 1024 * 1024;
end;

procedure TfrmOptions.SetChunkSize(const Value: Int64);
var
  ItemStr: string;
  i: Integer;
begin
  ItemStr := IntToStr((Value div 1024) div 1024) + 'MB';
  for i := 0 to rgChunkSize.Items.Count - 1 do
  begin
    if rgChunkSize.Items[i] = ItemStr then
    begin
      rgChunkSize.ItemIndex := i;
      Break;
    end;
  end;
end;

end.
