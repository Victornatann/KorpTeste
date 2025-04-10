unit Estoque.Service.Interfaces;

interface

uses
  System.JSON,
  Produto;

type
  IEstoqueService = interface
   ['{4BD64A67-5858-4756-BA8F-1E450755FAF1}']
   function CadastrarProduto(Produto: TProduto): TJsonObject;
   function ConsultarSaldo(ID: Integer; Quantidade: Integer): TJsonObject;
   function AtualizarSaldo(ID: Integer; Quantidade: Integer): TJsonObject;
  end;

implementation

end.

