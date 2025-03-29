unit Nota;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections;

type
  TNota = class
  private
    FID: Integer;
    FEmissao: TDateTime;
    FStatus: string;
  public
    constructor Create; overload;
    constructor Create(Id: Integer; Emissao: TDateTime; Status: String); overload;
    function ToJson: TJSONObject;
    class function JsonArrayToNotaList(JsonArray: TJSONArray): TObjectList<TNota>;
    class function FromJson(Json: TJSONObject): TNota;
    property ID: Integer read FID write FID;
    property Emissao: TDateTime read FEmissao write FEmissao;
    property Status: string read FStatus write FStatus;
  end;

implementation

{ TNota }

constructor TNota.Create;
begin
  FID := 0;
  FEmissao := Now;
  FStatus := '';
end;

constructor TNota.Create(Id: Integer; Emissao: TDateTime; Status: String);
begin
  FID := Id;
  FEmissao := Emissao;
  FStatus := Status;
end;

class function TNota.FromJson(Json: TJSONObject): TNota;
begin
  Result := TNota.Create;
  Result.FID := Json.GetValue<Integer>('ID');
  Result.FEmissao := StrToDateTime(Json.GetValue<string>('Emissao'));
  Result.FStatus := Json.GetValue<string>('Status');
end;

class function TNota.JsonArrayToNotaList(
  JsonArray: TJSONArray
): TObjectList<TNota>;
var
  i: Integer;
  NotaJson: TJSONObject;
  Nota: TNota;
begin
  Result := TObjectList<TNota>.Create;
  try
    for i := 0 to JsonArray.Count - 1 do
    begin
      NotaJson := JsonArray.Items[i] as TJSONObject;
      Nota := TNota.FromJson(NotaJson);
      Result.Add(Nota);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TNota.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('ID', TJSONNumber.Create(FID));
  Result.AddPair('Emissao', TJSONString.Create(DateTimeToStr(FEmissao)));
  Result.AddPair('Status', FStatus);
end;

end.

