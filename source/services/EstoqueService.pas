unit EstoqueService;

interface

uses
  System.JSON,
  uDm,
  FireDAC.Stan.Param,
  Estoque.Service.Interfaces,
  Produto,
  Data.DB;

type
  TEstoqueService = class(TInterfacedObject, IEstoqueService)
  private
    FDM: TDM;
    function MsgRetorno(const Texto: string; Success: Boolean): TJSONObject;
  public
    constructor create;
    destructor Destroy; override;
    class function New: IEstoqueService;
    function CadastrarProduto(Produto: TProduto): TJsonObject;
    function ConsultarSaldo(ID: Integer; Quantidade: Integer): TJsonObject;
    function AtualizarSaldo(ID: Integer; Quantidade: Integer): TJsonObject;
  end;

implementation

uses
  FireDAC.Comp.Client,
  System.SysUtils;

{ TEventosMain }

function TEstoqueService.MsgRetorno(const Texto: string; Success: Boolean): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('success', TJSONBool.Create(Success));
  Result.AddPair('message', Texto);
end;

constructor TEstoqueService.create;
begin
  FDM := TDM.create(nil);
end;

destructor TEstoqueService.Destroy;
begin
  FDM.Free;
  inherited;
end;

function TEstoqueService.CadastrarProduto(Produto: TProduto): TJsonObject;
var
  Qry: TFDQuery;
begin
  try
    Qry := FDM.GetQuery();
    try
      Qry.SQL.Text := 'INSERT INTO PRODUTO (NOME, PRECO, SALDO) VALUES (:NOME, :PRECO, :SALDO)';
      Qry.ParamByName('NOME').AsString := Produto.Nome;
      Qry.ParamByName('PRECO').AsFloat := Produto.Preco;
      Qry.ParamByName('SALDO').AsInteger := Produto.Saldo;
      Qry.ExecSQL;
      Result := MsgRetorno('Produto cadastrado com sucesso', True);
    finally
      Qry.Free;
    end;
  except
    on E: Exception do
      Result := MsgRetorno('Erro ao cadastrar produto: ' + E.Message, False);
  end;
end;

function TEstoqueService.ConsultarSaldo(ID: Integer; Quantidade: Integer): TJsonObject;
var
  Qry: TFDQuery;
  LMsg: String;
begin
  try
    Qry := FDM.GetQuery();
    try
      Qry.SQL.Text := 'SELECT SALDO FROM PRODUTO WHERE ID = :ID';
      Qry.ParamByName('ID').AsInteger := ID;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        LMsg := Format('Produto %d n�o encontrado', [ID]);
        Result := MsgRetorno(LMsg, False);
      end
      else
      begin
        if Qry.FieldByName('SALDO').AsInteger < Quantidade then
        begin
          LMsg := Format('Produto %d com saldo insuficiente', [ID]);
          Result := MsgRetorno(LMsg, False);
        end
        else
        begin
          LMsg := Format('Produto %d com saldo suficiente', [ID]);
          Result := MsgRetorno(LMsg, True);
        end;
      end;
    finally
      Qry.Free;
    end;
  except
    on E: Exception do
      Result := MsgRetorno('Erro ao consultar saldo: ' + E.Message, False);
  end;
end;

function TEstoqueService.AtualizarSaldo(ID, Quantidade: Integer): TJsonObject;
var
  Qry: TFDQuery;
begin
  try
    Qry := FDM.GetQuery();
    try
      Qry.SQL.Text := 'UPDATE PRODUTO SET SALDO = SALDO - :QTD WHERE ID = :ID';
      Qry.ParamByName('ID').AsInteger := ID;
      Qry.ParamByName('QTD').AsInteger := Quantidade;
      Qry.ExecSQL;
      Result := MsgRetorno('Estoque atualizado com sucesso', True);
    finally
      Qry.Free;
    end;
  except
    on E: Exception do
      Result := MsgRetorno('Erro ao atualizar saldo: ' + E.Message, False);
  end;
end;

class function TEstoqueService.New: IEstoqueService;
begin
  Result := Self.Create;
end;

end.

