object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  ClientHeight = 361
  ClientWidth = 384
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 400
  DoubleBuffered = True
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  DesignSize = (
    384
    361)
  PixelsPerInch = 96
  TextHeight = 13
  object rgPixelFormat: TRadioGroup
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 368
    Height = 113
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 'Bytes Per Pixel'
    Items.Strings = (
      '1 Byte per pixel (8 bits per pixel)'
      '2 Bytes per pixel (16 bits per pixel)'
      '3 Bytes per pixel (24 bits per pixel - True Color)'
      '4 Bytes per pixel (Transparent)')
    TabOrder = 0
    OnClick = Changed
    ExplicitWidth = 428
  end
  object BitBtn2: TBitBtn
    Left = 283
    Top = 328
    Width = 93
    Height = 25
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 1
    ExplicitLeft = 343
    ExplicitTop = 329
  end
  object chkSmoothResize: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 161
    Width = 368
    Height = 17
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 'Smooth Resize'
    TabOrder = 2
    OnClick = Changed
    ExplicitTop = 128
    ExplicitWidth = 97
  end
  object Panel1: TPanel
    Left = 0
    Top = 129
    Width = 384
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 32
      Height = 13
      Caption = 'Width:'
    end
    object Label2: TLabel
      Left = 136
      Top = 6
      Width = 35
      Height = 13
      Caption = 'Height:'
    end
    object edtWidth: TSpinEdit
      Left = 46
      Top = 3
      Width = 75
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = Changed
    end
    object edtHeight: TSpinEdit
      Left = 177
      Top = 3
      Width = 75
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = Changed
    end
  end
end
