unit CadProFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmCadPro = class(TForm)
    lblNome: TLabel;
    edtNome: TEdit;
    lblPreco: TLabel;
    edtPreco: TEdit;
    lblSaldo: TLabel;
    edtSaldo: TEdit;
    btnSalvar: TButton;
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadPro: TFrmCadPro;

implementation

{$R *.dfm}

uses
  Produto,
  EstoqueService,
  Utils;

procedure TFrmCadPro.btnSalvarClick(Sender: TObject);
  var Produto : TProduto;
  var LMsg: String;
begin
  Produto := TProduto.Create;
  Produto.Nome := EdtNome.Text;
  Produto.Preco := StrToFloatDef(edtPreco.Text, 0.0);
  Produto.Saldo := StrToIntDef(edtSaldo.Text, 0);

  ProcessaRetorno(
    TEstoqueService
    .New
      .CadastrarProduto(
        Produto
      ),
    LMsg
  );

  ShowMessage(LMsg);
  Close;
end;

end.
