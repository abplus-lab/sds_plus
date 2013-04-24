object Form4: TForm4
  Left = 346
  Top = 168
  Width = 381
  Height = 162
  Caption = 'Form4'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 373
    Height = 135
    Align = alClient
    Columns = <
      item
        Caption = 'Contents'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = 'ResType'
        Width = 70
      end
      item
        Caption = 'BufType'
        Width = 75
      end
      item
        Caption = 'Comment'
        Width = 100
      end>
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
