object Form1: TForm1
  Left = 382
  Top = 115
  Width = 503
  Height = 303
  Caption = 'ResBuf Viewer'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 121
    Top = 0
    Width = 4
    Height = 276
    Cursor = crHSplit
  end
  object ListView1: TListView
    Left = 125
    Top = 0
    Width = 370
    Height = 276
    Align = alClient
    Columns = <
      item
        Caption = 'Contents'
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'ResType'
        Width = 75
      end
      item
        Caption = 'BufType'
        Width = 75
      end
      item
        Caption = 'Comment'
        Width = 150
      end>
    ReadOnly = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 276
    Align = alLeft
    Indent = 19
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 244
    Top = 80
    object Copy1: TMenuItem
      Caption = #12467#12500#12540
      OnClick = Copy1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = #38281#12376#12427
      OnClick = Close1Click
    end
  end
end
