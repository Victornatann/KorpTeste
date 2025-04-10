unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.ConsoleUI.Wait, FireDAC.Phys.PGDef,
  FireDAC.DApt,
  FireDAC.Phys.PG, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FDConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetQuery: TFDQuery;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.FDConnectionBeforeConnect(Sender: TObject);
var
  LServer: String;
  LBase: String;
  LUser: String;
  LPass: String;
begin

  LServer := '127.0.0.1';
  LBase := 'KorpErp';
  LUser := 'sa';
  LPass := 'Infarma@060115.';

  TFDConnection(Sender).Params.Clear;
  TFDConnection(Sender).Params.Add('DriverID=MSSQL');
  TFDConnection(Sender).Params.Add('Server=' + LServer);
  TFDConnection(Sender).Params.Add('Port=5432');
  TFDConnection(Sender).Params.Add('Database=' + LBase);
  TFDConnection(Sender).Params.Add('User_Name=' + LUser);
  TFDConnection(Sender).Params.Add('Password=' + LPass);
  TFDConnection(Sender).Params.Add('Protocol=TCPIP');
  TFDConnection(Sender).Params.Add('Charset=ISO8859_1');
  TFDConnection(Sender).DriverName := 'MSSQL';
  TFDConnection(Sender).LoginPrompt := false;
  TFDConnection(Sender).UpdateOptions.CountUpdatedRecords := false;
end;

function TDM.GetQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDConnection;
  Result.Close;
  Result.SQL.Clear;
end;

end.
