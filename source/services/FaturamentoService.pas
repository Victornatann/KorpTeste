unit FaturamentoService;

interface

uses
  System.JSON, System.Generics.Collections, Produto, Faturamento.Service.Interfaces,
  FireDAC.Comp.Client, FireDAC.Stan.Param, System.SysUtils, uDm,
  Data.DB;

type
  TFaturamentoService = class(TInterfacedObject, IFaturamentoService)
  private
    FDM: TDM;
    function MsgRetorno(const Texto: string; Success: Boolean): TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IFaturamentoService;
    function CadastrarNotaFiscal(Itens: TObjectList<TProduto>): TJsonObject;
    function ConsultarNotaFiscal(ID: Integer): TJsonObject; overload;
    function ConsultarNotaFiscal(): TJSONArray; overload;
    function AtualizarStatusNotaFiscal(ID: Integer; Status: string): TJsonObject;
  end;

implementation

{ TFaturamentoService }

uses
  Nota;

constructor TFaturamentoService.Create;
begin
  inherited Create;
  FDM := TDM.Create(nil);
end;

destructor TFaturamentoService.Destroy;
begin
  FDM.Free;
  inherited Destroy;
end;

function TFaturamentoService.MsgRetorno(const Texto: string; Success: Boolean): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('success', TJSONBool.Create(Success));
  Result.AddPair('message', Texto);
end;

class function TFaturamentoService.New: IFaturamentoService;
begin
  Result := Self.Create;
end;

function TFaturamentoService.CadastrarNotaFiscal(Itens: TObjectList<TProduto>): TJsonObject;
var
  NotaID: Integer;
  Qry: TFDQuery;
  Produto: TProduto;
begin
  try

    FDM.FDConnection.StartTransaction;


    Qry := FDM.GetQuery;
    try
      Qry.SQL.Text :=
        'INSERT INTO NOTA_FISCAL (STATUS, EMISSAO, TOTAL) ' +
        'OUTPUT INSERTED.ID ' +
        'VALUES (:STATUS, :EMISSAO, :TOTAL)';
      Qry.ParamByName('STATUS').AsString := 'A';
      Qry.ParamByName('EMISSAO').AsDateTime := Now;
      Qry.ParamByName('TOTAL').AsFloat := 0;
      Qry.Open;

      NotaID := Qry.Fields[0].AsInteger;


      for Produto in Itens do
      begin
        Qry.SQL.Text := 'INSERT INTO NOTA_ITEM (NOTA_FISCAL_ID, PRODUTO_ID, QUANTIDADE, PRECO) VALUES (:NOTA_FISCAL_ID, :PRODUTO_ID, :QUANTIDADE, :PRECO)';
        Qry.ParamByName('NOTA_FISCAL_ID').AsInteger := NotaID;
        Qry.ParamByName('PRODUTO_ID').AsInteger := Produto.ID;
        Qry.ParamByName('QUANTIDADE').AsInteger := Produto.Saldo;
        Qry.ParamByName('PRECO').AsFloat := Produto.Preco;
        Qry.ExecSQL;
      end;

      FDM.FDConnection.Commit;
      Result := MsgRetorno('Nota Fiscal cadastrada com sucesso', True);
    finally
      Qry.Free;
    end;
  except
    on E: Exception do
    begin
      FDM.FDConnection.Rollback;
      Result := MsgRetorno('Erro ao cadastrar nota fiscal: ' + E.Message, False);
    end;
  end;
end;

function TFaturamentoService.ConsultarNotaFiscal: TJSONArray;
var
  Qry: TFDQuery;
  Nota: TNota;
  JsonArray: TJSONArray;
begin
  JsonArray := TJSONArray.Create;
  try
    Qry := FDM.GetQuery;
    try
      Qry.SQL.Text :=
        'SELECT '+
        '   STATUS, '+
        '   EMISSAO, '+
        '   ID '+
        'FROM NOTA_FISCAL ';

      Qry.Open;
      while not Qry.Eof do
      begin
        Nota :=
         TNota.Create(
          Qry.FieldByName('ID').AsInteger,
          Qry.FieldByName('EMISSAO').AsDateTime,
          Qry.FieldByName('STATUS').AsString
         );

       JsonArray.Add(Nota.ToJson);
       Qry.Next;
      end;

      Result := JsonArray;
    finally
      Qry.Free;
    end;
  except
    on E: Exception do
      Result := Nil;
  end;
end;

function TFaturamentoService.ConsultarNotaFiscal(ID: Integer): TJsonObject;
var
  Qry: TFDQuery;
  LMsg: String;
begin
  try
    Qry := FDM.GetQuery;
    try
      Qry.SQL.Text :=
        'SELECT '+
        '   STATUS, '+
        '   EMISSAO, '+
        '   TOTAL '+
        'FROM NOTA_FISCAL '+
        'WHERE ID = :ID'+
        '  AND STATUS = ''A'' ';
      Qry.ParamByName('ID').AsInteger := ID;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        LMsg := Format('Nota Fiscal %d n�o encontrada ou n�o est� aberta', [ID]);
        Result := MsgRetorno(LMsg, False);
      end
      else
      begin
        LMsg := Format('Nota Fiscal %d - Status: %s, Total: %.2f', [ID, Qry.FieldByName('STATUS').AsString, Qry.FieldByName('TOTAL').AsFloat]);
        Result := MsgRetorno(LMsg, True);
      end;

    finally
      Qry.Free;
    end;
  except
    on E: Exception do
      Result := MsgRetorno('Erro ao consultar nota fiscal: ' + E.Message, False);
  end;
end;

function TFaturamentoService.AtualizarStatusNotaFiscal(ID: Integer; Status: string): TJsonObject;
var
  Qry: TFDQuery;
begin
  try
    FDM.FDConnection.StartTransaction;
    Qry := FDM.GetQuery;
    try
      Qry.SQL.Text := 'UPDATE NOTA_FISCAL SET STATUS = :STATUS WHERE ID = :ID';
      Qry.ParamByName('STATUS').AsString := Status;
      Qry.ParamByName('ID').AsInteger := ID;
      Qry.ExecSQL;
      FDM.FDConnection.Commit;
      Result := MsgRetorno(Format('Nota Fiscal %d impressa', [ID]), True);
    finally
      Qry.Free;
    end;
  except
    on E: Exception do begin
      Result := MsgRetorno('Erro ao atualizar status da nota fiscal: ' + E.Message, False);
      FDM.FDConnection.RollBack;
    end;
  end;
end;

end.

