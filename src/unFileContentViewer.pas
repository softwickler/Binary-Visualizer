unit unFileContentViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Classes, System.Math, System.StrUtils,
  Vcl.Graphics, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls,
  GR32_Resamplers, GR32;

type
  TfrmViewer = class(TForm)
    imgViewer: TImage;
    lblCroppedBefore: TLabel;
    lblCroppedAfter: TLabel;
    SaveDialog: TSaveDialog;
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPixelFormatIndex: Integer;
    FFileName: string;
    FFileSize: Int64;
    FSmoothResize: Boolean;
    FSeekBegin, FSeekEnd: Int64;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure SaveToFile;
  public
    { Public declarations }
  end;

var
  frmViewer: TfrmViewer;

implementation

{$R *.dfm}

uses
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

const
  DEFAULT_CHUNK_SIZE = 20 * 1024 * 1024;

function GenerateBitmap(aBytes: TBytes; const aRect: TRect; const aPixelFormat: TPixelFormat; aDefaultValue: Byte = 0): TBitmap;
var
  BytesPerPixel: Integer;
  TotalPixels: Integer;
  CalcWidth, Height: Integer;
  Row, Col: Integer;
  PixelIndex: Integer;
  RowPtr: PByte;
begin
  case aPixelFormat of
    pf8bit:  BytesPerPixel := 1;
    pf16bit: BytesPerPixel := 2;
    pf24bit: BytesPerPixel := 3;
    pf32bit: BytesPerPixel := 4;
  else
    raise Exception.Create('Unsupported PixelFormat');
  end;

  if Length(aBytes) = 0 then
    raise Exception.Create('No data');

  // --- calculate width based on rectangle and aspect ratio ---
  TotalPixels := Length(aBytes) div BytesPerPixel;
  if TotalPixels = 0 then
    TotalPixels := 1;

  CalcWidth := Round(Sqrt((aRect.Width / Max(1, aRect.Height)) * TotalPixels));
  if CalcWidth <= 0 then
    CalcWidth := 1;

  // --- compute height based on pixel count ---
  Height := (TotalPixels + CalcWidth - 1) div CalcWidth;

  // --- create bitmap ---
  Result := TBitmap.Create;
  try
    Result.PixelFormat := aPixelFormat;
    Result.Width := CalcWidth;
    Result.Height := Height;

    // --- fill bitmap ---
    for Row := 0 to Height - 1 do
    begin
      RowPtr := Result.ScanLine[Row];
      for Col := 0 to CalcWidth - 1 do
      begin
        PixelIndex := (Row * CalcWidth + Col) * BytesPerPixel;
        if PixelIndex < Length(aBytes) then
          Move(aBytes[PixelIndex], RowPtr^, BytesPerPixel)
        else
          FillChar(RowPtr^, BytesPerPixel, aDefaultValue);
        Inc(RowPtr, BytesPerPixel);
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TfrmViewer.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
  FPixelFormatIndex := 3;
  FFileName := ParamStr(0);
  FSmoothResize := False;
  FSeekBegin := 0;
  FSeekEnd := DEFAULT_CHUNK_SIZE;
end;

procedure TfrmViewer.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);
end;

procedure TfrmViewer.WMDropFiles(var Msg: TWMDropFiles);
var
  cnt, len: UINT;
  buf: array[0..MAX_PATH-1] of Char;
  sFile: string;
begin
  cnt := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  if cnt = 0 then Exit;

  len := DragQueryFile(Msg.Drop, 0, buf, MAX_PATH);
  if len > 0 then
  begin
    sFile := StrPas(buf);
    if FileExists(sFile) then
    begin
      FSeekBegin := 0;
      FSeekEnd := DEFAULT_CHUNK_SIZE;
      FSmoothResize := False;
      FFileName := sFile;
      FormResize(nil);
    end;
  end;

  DragFinish(Msg.Drop);
  SetForegroundWindow(Application.Handle);
end;

procedure TfrmViewer.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Size: Int64;
begin
  if Key = VK_F1 then Application.MessageBox(PChar(
    'Enter Key:'       + sLineBreak + '  Toggle Smooth-Resize' + sLineBreak + sLineBreak +
    '1..4 Keys:'       + sLineBreak + '  Set Bytes/Pixel' + sLineBreak + sLineBreak +
    '+ / Up Key:'      + sLineBreak + '  Increase Bytes/Pixel' + sLineBreak + sLineBreak +
    '- / Down Key:'    + sLineBreak + '  Decrease Bytes/Pixel' + sLineBreak + sLineBreak +
    'Ctrl-Arrow Keys:' + sLineBreak + '  Change form size' + sLineBreak + sLineBreak +
    'Right Key:'       + sLineBreak + '  Next page (toward EOF)' + sLineBreak + sLineBreak +
    'Left Key:'        + sLineBreak + '  Previous page (toward BOF)' + sLineBreak + sLineBreak +
    'Ctrl-S Key:'      + sLineBreak + '  Save current image' + sLineBreak + sLineBreak +
    'Page Size:'       + sLineBreak + Format('  Maximum of %0.1f Mega-Bytes', [DEFAULT_CHUNK_SIZE / 1024 / 1024]) + StringOfChar(' ', 100)),
    'By: Mahan Ahmadzadeh', MB_ICONINFORMATION)
  else if (Key = VK_RETURN) then FSmoothResize := not FSmoothResize
  else if (Key = VK_NUMPAD1) or (Key = $31) then FPixelFormatIndex := 1
  else if (Key = VK_NUMPAD2) or (Key = $32) then FPixelFormatIndex := 2
  else if (Key = VK_NUMPAD3) or (Key = $33) then FPixelFormatIndex := 3
  else if (Key = VK_NUMPAD4) or (Key = $34) then FPixelFormatIndex := 4
  else if (Shift = [ssCtrl]) and (Key = Ord('S')) then SaveToFile
  else if (Shift = [ssCtrl]) and (Key = VK_UP)    then Height := Height - 1
  else if (Shift = [ssCtrl]) and (Key = VK_DOWN)  then Height := Height + 1
  else if (Shift = [ssCtrl]) and (Key = VK_LEFT)  then Width := Width - 1
  else if (Shift = [ssCtrl]) and (Key = VK_RIGHT) then Width := Width + 1
  else if (Key = VK_UP)   or (Key = VK_ADD)      or (Key = VK_OEM_PLUS)  then FPixelFormatIndex := Min(4, FPixelFormatIndex + 1)
  else if (Key = VK_DOWN) or (Key = VK_SUBTRACT) or (Key = VK_OEM_MINUS) then FPixelFormatIndex := Max(1, FPixelFormatIndex - 1)
  else if (Key = VK_RIGHT) and (lblCroppedAfter.Visible) then
  begin
    Size := FSeekEnd - FSeekBegin;
    FSeekBegin := FSeekEnd;
    FSeekEnd := FSeekEnd + Size;
  end
  else if (Key = VK_LEFT) and (lblCroppedBefore.Visible) then
  begin
    Size := FSeekEnd - FSeekBegin;
    FSeekEnd := FSeekBegin;
    FSeekBegin := FSeekBegin - Size;
    if FSeekBegin < 0 then
    begin
      FSeekEnd := FSeekEnd - FSeekBegin;
      FSeekBegin := 0;
    end;
  end;
  FormResize(Sender);
end;

procedure SmoothResize(Source: TGraphic; NewWidth, NewHeight: Integer);

  procedure SetHighQualityStretchFilter(B: TBitmap32);
  var
    KR: TKernelResampler;
  begin
    if B.Resampler is TKernelResampler then
    begin
      KR := TKernelResampler(B.Resampler);
      if not (KR.Kernel is TLanczosKernel) then
      begin
        KR.Kernel.Free;
        KR.Kernel := TLanczosKernel.Create;
      end;
    end
    else
    begin
      KR := TKernelResampler.Create(B);
      KR.Kernel := TLanczosKernel.Create;
    end;
  end;

var
  SrcBmp, DstBmp: TBitmap32;
begin
  if ((Source.Width = NewWidth) and (Source.Height = NewHeight)) or ((NewWidth < 0) and (NewHeight < 0)) or (Source.Width < 1) or (Source.Height < 1) then
    Exit;
  if NewHeight < 0 then
    NewHeight := Round(NewWidth * Source.Height / Source.Width)
  else
  if NewWidth < 0 then
    NewWidth := Round(NewHeight * Source.Width / Source.Height);

  SrcBmp := TBitmap32.Create;
  DstBmp := TBitmap32.Create;
  try
    SrcBmp.Assign(Source);
    SetHighQualityStretchFilter(SrcBmp);
    DstBmp.SetSize(NewWidth, NewHeight);
    SrcBmp.DrawTo(DstBmp, DstBmp.BoundsRect, SrcBmp.BoundsRect);
    Source.Assign(DstBmp);
  finally
    SrcBmp.Free;
    DstBmp.Free;
  end;
end;

procedure TfrmViewer.FormResize(Sender: TObject);
var
  S: TFileStream;
  B: TBitmap;
  aBytes: TBytes;
  pf: TPixelFormat;
begin
  imgViewer.Stretch := not FSmoothResize;

  S := TFileStream.Create(FFileName, fmOpenRead);
  try
    FFileSize := S.Size;

    case FPixelFormatIndex of
      1:
        pf := pf8bit;
      2:
        pf := pf16bit;
      3:
        pf := pf24bit;
    else // 4
        pf := pf32bit;
    end;
    if FFileSize < 1500 then
      Caption := Format('%dBPP - %s (%d Bytes)', [FPixelFormatIndex, ExtractFileName(FFileName), FFileSize])
    else if FFileSize < 1500000 then
      Caption := Format('%dBPP - %s (%0.2f KB)', [FPixelFormatIndex, ExtractFileName(FFileName), FFileSize / 1024])
    else
      Caption := Format('%dBPP - %s (%0.2f MB)', [FPixelFormatIndex, ExtractFileName(FFileName), FFileSize / 1024 / 1024]);

    SetLength(aBytes, FSeekEnd - FSeekBegin + 1);
    S.Position := FSeekBegin;
    lblCroppedBefore.Visible := FSeekBegin > 0;
    SetLength(aBytes, S.Read(aBytes[0], FSeekEnd - FSeekBegin + 1));
    if Length(aBytes) > 0 then
    begin
      lblCroppedAfter.Visible := S.Position < S.Size - 1;
      imgViewer.Show;
      B := GenerateBitmap(aBytes, imgViewer.ClientRect, pf, 0);
      try
        if FSmoothResize then
          SmoothResize(B, imgViewer.Width, imgViewer.Height);
        imgViewer.Picture.Assign(B);
      finally
        FreeAndNil(B);
      end;
    end
    else
    begin
      lblCroppedBefore.Hide;
      lblCroppedAfter.Hide;
      imgViewer.Hide;
    end;
  finally
    FreeAndNil(S);
  end;
end;

procedure TfrmViewer.SaveToFile;
var
  Graphic: TGraphic;
  Ext: string;
begin
  try
    if SaveDialog.Execute then
    begin
      Graphic := nil;
      case SaveDialog.FilterIndex of
        1: begin Graphic := TBitmap.Create; Ext := '.bmp' end;
        2: begin Graphic := TJPEGImage.Create; Ext := '.jpg' end;
        3: begin Graphic := TPngImage.Create; Ext := '.png' end;
      end;
      if Assigned(Graphic) then
      begin
        Screen.Cursor := crHourGlass;
        try
          Graphic.Assign(imgViewer.Picture.Graphic);
          Graphic.SaveToFile(ChangeFileExt(SaveDialog.FileName, Ext));
        finally
          FreeAndNil(Graphic);
          Screen.Cursor := crDefault;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Unexpected error occured: ' + E.Message);
  end;
end;

end.
