unit NotaFrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Grids,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  System.Generics.Collections,
  System.JSON;

type
  TFrmNota = class(TForm)
    grpCabecalho: TGroupBox;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblData: TLabel;
    dtpData: TDateTimePicker;
    grpItens: TGroupBox;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    btnAdicionarItem: TButton;
    gridItens: TStringGrid;
    EdtCodPro: TEdit;
    btnConcluir: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure Critica();
    procedure LimpaTela();
  public
    { Public declarations }
  end;

var
  FrmNota: TFrmNota;

implementation

{$R *.dfm}

uses Produto,
     FaturamentoService,
     EstoqueService,
     Utils;

procedure TFrmNota.btnAdicionarItemClick(Sender: TObject);
var
  RowIndex: Integer;
begin
  Critica();

  RowIndex := gridItens.RowCount;
  gridItens.RowCount := RowIndex + 1;

  gridItens.Cells[0, RowIndex] := EdtCodPro.Text;
  gridItens.Cells[1, RowIndex] := edtQuantidade.Text;


  LimpaTela();
end;

procedure TFrmNota.btnConcluirClick(Sender: TObject);
var
  ListaProdutos: TObjectList<TProduto>;
  ProdutoItem: TProduto;
  i: Integer;
  LMsg: String;
  LSucess: Boolean;
begin
  if gridItens.RowCount <= 1 then
  begin
    ShowMessage('Nenhum item adicionado.');
    Exit;
  end;

  ListaProdutos := TObjectList<TProduto>.Create;
  try
    for i := 1 to gridItens.RowCount - 1 do
    begin
      ProdutoItem := TProduto.Create;
      ProdutoItem.Id := StrToIntDef(gridItens.Cells[0, i], 0);
      ProdutoItem.Saldo := StrToIntDef(gridItens.Cells[1, i], 0);
      ProdutoItem.Preco := StrToFloatDef(gridItens.Cells[2, i], 0.00);
      ListaProdutos.Add(ProdutoItem);
    end;

    //CRITICA SALDO
    for ProdutoItem in ListaProdutos do
    begin
      LSucess := 
        ProcessaRetorno(
          TEstoqueService
          .New
            .ConsultarSaldo(
              ProdutoItem.ID,
              ProdutoItem.Saldo
            ),
          LMsg
        );

      if not LSucess then begin
        ShowMessage(LMsg);
        Exit;
      end;
    end;


    // INSERE NOTA
    ProcessaRetorno(
      TFaturamentoService
      .New
        .CadastrarNotaFiscal(
          ListaProdutos
        ),
      LMsg
    );

    ShowMessage(LMsg);

    // ATUALIZA SALDO
    for ProdutoItem in ListaProdutos do
    begin
      LSucess := 
        ProcessaRetorno(
          TEstoqueService
          .New
            .AtualizarSaldo(
              ProdutoItem.ID,
              ProdutoItem.Saldo
            ),
          LMsg
        );

      if not LSucess then begin
        ShowMessage(LMsg);
        Exit;
      end;
    end;

    Close();

  finally
    ListaProdutos.Free;
  end;
end;

procedure TFrmNota.Critica;
var
  i: Integer;
begin

  if (Trim(EdtCodPro.Text) = '') then
  begin
    ShowMessage('Informe o produto.');
    Abort;
  end;

  if (Trim(edtQuantidade.Text) = '') then
  begin
    ShowMessage('Informe a quantidade.');
    Abort;
  end;

  for i := 1 to gridItens.RowCount - 1 do 
  begin
    if gridItens.Cells[0, i] = Trim(EdtCodPro.Text) then
    begin
      ShowMessage('Produto ja adicionado');
      Abort;
    end;
  end;
end;

procedure TFrmNota.FormCreate(Sender: TObject);
begin
  gridItens.Cells[0, 0] := 'Codigo';
  gridItens.Cells[1, 0] := 'Quantidade';

  gridItens.ColWidths[0] := 150;
  gridItens.ColWidths[1] := 100;
end;

procedure TFrmNota.LimpaTela;
begin
  // Limpa os campos para a pr�xima inser��o
  edtQuantidade.Text := '';
  EdtCodPro.Text := '';
end;

end.
