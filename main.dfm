object MainForm: TMainForm
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Problem Sender'
  ClientHeight = 71
  ClientWidth = 234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BtnConf: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 57
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 0
    OnClick = BtnConfClick
  end
  object BtnSend: TButton
    Left = 89
    Top = 8
    Width = 137
    Height = 57
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = BtnSendClick
  end
end
