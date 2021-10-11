object FEcran: TFEcran
  Left = 705
  Top = 487
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Ecran'
  ClientHeight = 210
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Ecran: TImage
    Left = 0
    Top = 0
    Width = 280
    Height = 210
    Align = alClient
  end
  object MP: TMediaPlayer
    Left = 5
    Top = 5
    Width = 29
    Height = 30
    VisibleButtons = []
    Visible = False
    TabOrder = 0
  end
  object MTimer: TTimer
    Interval = 500
    Left = 40
    Top = 5
  end
end
