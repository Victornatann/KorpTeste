unit Utils;

interface

uses
  System.JSON, System.SysUtils;

function ProcessaRetorno(
  JsonRet: TJSONObject;
  var Msg: String
): Boolean;

implementation

function ProcessaRetorno(
  JsonRet: TJSONObject;
  var Msg: String
): Boolean;
var
  Success: Boolean;
  MessageText: string;
begin
  if Assigned(JsonRet) then
  begin
    try
      Success := JsonRet.GetValue<Boolean>('success');
      MessageText := JsonRet.GetValue<string>('message');
      Msg := MessageText;
      Result := Success;
    except
      on E: Exception do
      begin
        Msg := 'Erro ao processar retorno: ' + E.Message;
        Result := False;
      end;
    end;
  end
  else
  begin
    Msg := 'Erro ao processar retorno';
    Result := False;
  end;
end;

end.

