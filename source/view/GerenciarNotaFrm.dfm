object FrmGerenciarNota: TFrmGerenciarNota
  Left = 0
  Top = 0
  Caption = 'FrmGerenciarNota'
  ClientHeight = 247
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 412
    Height = 50
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 600
    object lblTitulo: TLabel
      Left = 10
      Top = 10
      Width = 239
      Height = 30
      Caption = 'Lista de Notas Fiscais'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object gridNotas: TStringGrid
    Left = 0
    Top = 50
    Width = 412
    Height = 160
    Align = alTop
    ColCount = 3
    DefaultColWidth = 100
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 1
    ExplicitLeft = 20
    ExplicitTop = 80
    ExplicitWidth = 440
  end
  object btnConcluir: TButton
    AlignWithMargins = True
    Left = 329
    Top = 213
    Width = 80
    Height = 31
    Align = alRight
    Caption = 'Imprimir'
    TabOrder = 2
    OnClick = btnConcluirClick
    ExplicitLeft = 929
    ExplicitTop = 216
    ExplicitHeight = 25
  end
  object btnNova: TButton
    AlignWithMargins = True
    Left = 243
    Top = 213
    Width = 80
    Height = 31
    Align = alRight
    Caption = 'Nova'
    TabOrder = 3
    OnClick = btnNovaClick
    ExplicitLeft = 233
    ExplicitTop = 216
  end
end
