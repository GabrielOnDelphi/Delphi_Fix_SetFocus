object frmMain: TfrmMain
  Left = 0
  Top = 0
  Hint = 'Replace "SetFocus" in all PAS files in the specified folder'
  AlphaBlend = True
  AlphaBlendValue = 250
  Caption = 'Fix SetFocus'
  ClientHeight = 464
  ClientWidth = 687
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  ScreenSnap = True
  ShowHint = True
  SnapBuffer = 3
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Splitter: TSplitter
    Left = 0
    Top = 197
    Width = 687
    Height = 3
    Cursor = crVSplit
    Align = alTop
    MinSize = 10
    ResizeStyle = rsUpdate
  end
  object pnlFiles: TPanel
    Left = 0
    Top = 0
    Width = 687
    Height = 197
    Align = alTop
    Caption = 'pnlFiles'
    ShowCaption = False
    TabOrder = 0
    object lblRewind: TLabel
      AlignWithMargins = True
      Left = 394
      Top = 159
      Width = 100
      Height = 34
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'Rewinded'
      Color = 8454143
      ParentBiDiMode = False
      ParentColor = False
      Transparent = False
      Layout = tlCenter
      Visible = False
    end
    object btnStart: TButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 102
      Height = 34
      Hint = 'Search "SetFocus" in all PAS files in the specified folder'
      Align = alLeft
      Anchors = [akLeft, akBottom]
      Caption = 'Search'
      TabOrder = 0
      OnClick = btnSearchClick
    end
    object lbxResults: TListBox
      Left = 1
      Top = 46
      Width = 685
      Height = 110
      Hint = 'Double click to load file'
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 15
      PopupMenu = PopupMenu
      TabOrder = 1
      OnDblClick = lbxResultsDblClick
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 685
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        685
        45)
      object edtFilter: TLabeledEdit
        Left = 464
        Top = 18
        Width = 210
        Height = 23
        Anchors = [akTop, akRight]
        EditLabel.Width = 45
        EditLabel.Height = 15
        EditLabel.Caption = 'File filter'
        TabOrder = 0
        Text = '*.pas'
      end
      object edtPath: TLabeledEdit
        Left = 8
        Top = 18
        Width = 439
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 170
        EditLabel.Height = 15
        EditLabel.Caption = 'Find text in all files in this folder:'
        TabOrder = 1
        Text = 'c:\'
      end
    end
    object btnNext: TButton
      AlignWithMargins = True
      Left = 307
      Top = 160
      Width = 81
      Height = 32
      Hint = 'Show next occurence'
      Margins.Top = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Next >'
      TabOrder = 3
      Visible = False
      OnClick = btnNextClick
    end
    object btnPrev: TButton
      AlignWithMargins = True
      Left = 220
      Top = 160
      Width = 81
      Height = 32
      Hint = 'Show previous occurence'
      Margins.Top = 4
      Margins.Bottom = 4
      Align = alLeft
      Caption = '< Prev'
      TabOrder = 4
      Visible = False
      OnClick = btnPrevClick
    end
    object btnReset: TButton
      AlignWithMargins = True
      Left = 608
      Top = 159
      Width = 75
      Height = 34
      Hint = 'Reset search in this file'
      Align = alRight
      Caption = 'Reset'
      TabOrder = 5
      Visible = False
      OnClick = btnResetClick
    end
    object btnReplace: TButton
      Tag = 1
      AlignWithMargins = True
      Left = 112
      Top = 159
      Width = 102
      Height = 34
      Hint = 'Replace "SetFocus" in all PAS files in the specified folder'
      Align = alLeft
      Anchors = [akLeft, akBottom]
      Caption = 'Replace'
      TabOrder = 6
      OnClick = btnSearchClick
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 500
      Top = 159
      Width = 102
      Height = 34
      Align = alLeft
      Anchors = [akLeft, akBottom]
      Caption = 'test'
      TabOrder = 7
      Visible = False
    end
  end
  object pnlView: TPanel
    Left = 0
    Top = 200
    Width = 687
    Height = 264
    Align = alClient
    TabOrder = 1
    Visible = False
    object lblCurFile: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 679
      Height = 15
      Align = alTop
    end
    object mmoView: TMemo
      Left = 1
      Top = 22
      Width = 685
      Height = 203
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 1
      Top = 225
      Width = 685
      Height = 38
      Align = alBottom
      TabOrder = 1
      Visible = False
    end
  end
  object PopupMenu: TPopupMenu
    Left = 496
    Top = 92
    object mnuCopyName: TMenuItem
      Caption = 'Copy filename'
      OnClick = mnuCopyNameClick
    end
    object mnuOpen: TMenuItem
      Caption = 'Open'
    end
  end
  object TimerRew: TTimer
    Enabled = False
    Interval = 4000
    OnTimer = TimerRewTimer
    Left = 544
    Top = 92
  end
end
