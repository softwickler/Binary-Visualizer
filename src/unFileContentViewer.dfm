object frmViewer: TfrmViewer
  Left = 0
  Top = 0
  ClientHeight = 750
  ClientWidth = 852
  Color = clMaroon
  DoubleBuffered = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clYellow
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 21
  object imgViewer: TImage
    Left = 0
    Top = 27
    Width = 852
    Height = 696
    Align = alClient
    Constraints.MinHeight = 10
    Constraints.MinWidth = 10
    DragMode = dmAutomatic
    Stretch = True
    ExplicitLeft = 5
    ExplicitTop = 0
    ExplicitHeight = 740
  end
  object lblCroppedBefore: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 846
    Height = 21
    Align = alTop
    Caption = 'Cropped'
    ExplicitWidth = 65
  end
  object lblCroppedAfter: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 726
    Width = 846
    Height = 21
    Align = alBottom
    Caption = 'Cropped'
    ExplicitWidth = 65
  end
  object SaveDialog: TSaveDialog
    Filter = '*.bmp|*.bmp|*.jpg|*.jpg|*.png|*.png'
    FilterIndex = 2
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Choose a path to save the image file'
    Left = 56
    Top = 68
  end
end
