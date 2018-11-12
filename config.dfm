object ConfigForm: TConfigForm
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Problem Sender'
  ClientHeight = 294
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 417
    Height = 249
    ActivePage = Channels_Conf
    TabOrder = 0
    object Channels_Conf: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1072#1085#1072#1083#1086#1074
      ExplicitLeft = 0
      ExplicitTop = 26
      object FileNameLabel: TLabel
        Left = 16
        Top = 16
        Width = 154
        Height = 13
        Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072' '#1074#1099#1075#1088#1091#1079#1082#1080' TMSONG:'
      end
      object ThemeLabel: TLabel
        Left = 16
        Top = 79
        Width = 66
        Height = 13
        Caption = #1058#1077#1084#1072' '#1087#1080#1089#1100#1084#1072':'
      end
      object RecipientAddressLabel: TLabel
        Left = 16
        Top = 112
        Width = 98
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
      end
      object DaysLabel: TLabel
        Left = 16
        Top = 48
        Width = 339
        Height = 13
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1103' '#1082#1072#1085#1072#1083#1072' '#1076#1083#1103' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1074' '#1074#1099#1075#1088#1091#1079#1082#1091':'
      end
      object FileNameEdit: TEdit
        Left = 176
        Top = 13
        Width = 217
        Height = 21
        TabOrder = 0
      end
      object ThemeEdit: TEdit
        Left = 88
        Top = 76
        Width = 305
        Height = 21
        TabOrder = 1
      end
      object RecipientAddressEdit: TEdit
        Left = 120
        Top = 109
        Width = 273
        Height = 21
        TabOrder = 2
      end
      object DaysEdit: TEdit
        Left = 361
        Top = 45
        Width = 32
        Height = 21
        TabOrder = 3
      end
    end
    object Mail_Conf: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1086#1095#1090#1099
      ImageIndex = 1
      object ServerAddressLabel: TLabel
        Left = 11
        Top = 11
        Width = 79
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072':'
      end
      object PortLabel: TLabel
        Left = 279
        Top = 11
        Width = 29
        Height = 13
        Caption = #1055#1086#1088#1090':'
      end
      object UserNameLabel: TLabel
        Left = 11
        Top = 41
        Width = 97
        Height = 13
        Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
      end
      object PasswordLabel: TLabel
        Left = 242
        Top = 41
        Width = 41
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100':'
      end
      object SenderAddressLabel: TLabel
        Left = 11
        Top = 71
        Width = 104
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103':'
      end
      object SenderNameLabel: TLabel
        Left = 11
        Top = 101
        Width = 92
        Height = 13
        Caption = #1048#1084#1103' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103':'
      end
      object ServerAddressEdit: TEdit
        Left = 96
        Top = 8
        Width = 177
        Height = 21
        TabOrder = 0
      end
      object PortEdit: TEdit
        Left = 311
        Top = 8
        Width = 86
        Height = 21
        TabOrder = 1
      end
      object UserNameEdit: TEdit
        Left = 114
        Top = 38
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object PasswordEdit: TMaskEdit
        Left = 289
        Top = 38
        Width = 108
        Height = 21
        TabOrder = 3
        Text = ''
      end
      object SenderAddressEdit: TEdit
        Left = 121
        Top = 68
        Width = 276
        Height = 21
        TabOrder = 4
      end
      object SenderNameEdit: TEdit
        Left = 109
        Top = 98
        Width = 288
        Height = 21
        TabOrder = 5
      end
    end
  end
  object Save: TButton
    Left = 269
    Top = 261
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = SaveClick
  end
  object CloseBtn: TButton
    Left = 350
    Top = 261
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = CloseBtnClick
  end
end
