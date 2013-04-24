object Form2: TForm2
  Left = 134
  Top = 56
  Width = 800
  Height = 600
  Caption = 'SDScore/plus'#12398#12487#12496#12483#12464#12392#12363#12486#12473#12488#12434#12377#12427#12383#12417#12398#12518#12491#12483#12488
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 541
    Width = 792
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      792
      32)
    object Button1: TButton
      Left = 717
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'execute'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 645
      Top = 4
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'copy'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 220
      Top = 8
      Width = 65
      Height = 21
      Caption = 'Button3'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 792
    Height = 541
    Align = alClient
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
