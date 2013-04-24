object Form3: TForm3
  Left = 318
  Top = 100
  Width = 696
  Height = 480
  Caption = 'ListForm'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Width = 4
    Height = 415
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 415
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 183
      Height = 413
      Align = alClient
      Columns = <
        item
          Caption = 'Contents'
          Width = 75
        end
        item
          Caption = 'Entity'
        end
        item
          Caption = 'Handle'
        end>
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = N1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 415
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 16
    object Exit1: TMenuItem
      Caption = #25805#20316
      object N1: TMenuItem
        Caption = #36984#25246#12373#12428#12390#12356#12427#12456#12531#12486#12451#12486#12451#12539#12522#12473#12488#12434#34920#31034
        OnClick = N1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit2: TMenuItem
        Caption = #32066#20102
        OnClick = Exit2Click
      end
    end
    object Window1: TMenuItem
      Caption = #12454#12451#12531#12489#12454
      object Cascade1: TMenuItem
        Caption = #37325#12397#12390#34920#31034'(&C)'
        Hint = #37325#12397#12390#34920#31034
        OnClick = Cascade1Click
      end
      object ileHorizontal1: TMenuItem
        Caption = #19978#19979#12395#20006#12409#12390#34920#31034'(&H)'
        Hint = #19978#19979#12395#20006#12409#12427
        OnClick = ileHorizontal1Click
      end
      object ileVertical1: TMenuItem
        Caption = #24038#21491#12395#20006#12409#12390#34920#31034'(&T)'
        Hint = #24038#21491#12395#20006#12409#12427
        OnClick = ileVertical1Click
      end
    end
  end
end
