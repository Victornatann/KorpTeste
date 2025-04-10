unit Faturamento.Service.Interfaces;

interface

uses
  System.JSON, System.Generics.Collections, Produto;

type
  IFaturamentoService = interface
  ['{4186E760-5EFF-4032-9E28-3DACE43A7325}']
    function CadastrarNotaFiscal(
      Itens: TObjectList<TProduto>
    ): TJsonObject;
    function ConsultarNotaFiscal(ID: Integer): TJsonObject; overload;
    function ConsultarNotaFiscal(): TJSONArray; overload;
    function AtualizarStatusNotaFiscal(ID: Integer; Status: string): TJsonObject;
  end;

implementation

end.

