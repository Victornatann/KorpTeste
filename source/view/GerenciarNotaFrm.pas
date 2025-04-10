unit GerenciarNotaFrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls;

type
  TFrmGerenciarNota = class(TForm)
    pnlHeader: TPanel;
    lblTitulo: TLabel;
    gridNotas: TStringGrid;
    btnConcluir: TButton;
    btnNova: TButton;
    procedure btnNovaClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaNota();
  public
    { Public declarations }
  end;

var
  FrmGerenciarNota: TFrmGerenciarNota;

implementation

{$R *.dfm}

uses
  NotaFrm,
  Utils,
  FaturamentoService,
  Nota;

procedure TFrmGerenciarNota.btnConcluirClick(Sender: TObject);
  var SelectedRow: Integer;
  var NotaID: Integer;
  var LMsg: String;
  var LSucess: Boolean;
begin

  SelectedRow := gridNotas.Row;
  NotaID := StrToIntDef(gridNotas.Cells[0, SelectedRow], -1);
  if NotaID = -1 then
    Exit;

  LSucess :=
    ProcessaRetorno(
      TFaturamentoService
      .New
        .ConsultarNotaFiscal(
          NotaID
        ),
      LMsg
    );

  if not LSucess then
  begin  
   ShowMessage(LMsg);
   Exit;
  end;

  ProcessaRetorno(
    TFaturamentoService
    .New
      .AtualizarStatusNotaFiscal(
        NotaID,
        'F'
      ),
    LMsg
  );

  ShowMessage(LMsg);
  CarregaNota();
  
end;

 


procedure TFrmGerenciarNota.btnNovaClick(Sender: TObject);
begin

  FrmNota := TFrmNota.Create(nil);
  try
    FrmNota.ShowModal;
  finally
    FrmNota.Free;
    CarregaNota();
  end;

end;

procedure TFrmGerenciarNota.CarregaNota;
 var JsonArray: TJSONArray;
 var NotaList: TObjectList<TNota>;
 var i: Integer;
 var Nota: TNota;
begin
  gridNotas.RowCount := 2;
  JsonArray :=
    TFaturamentoService
    .New
    .ConsultarNotaFiscal();

  try
    NotaList := TNota.JsonArrayToNotaList(JsonArray);
    gridNotas.RowCount := NotaList.Count + 1;

    
    for i := 0 to NotaList.Count - 1 do
    begin
      Nota := NotaList[i];
      gridNotas.Cells[0, i + 1] := IntToStr(Nota.ID);  
      gridNotas.Cells[1, i + 1] := DateToStr(Nota.Emissao);
      gridNotas.Cells[2, i + 1] := Nota.Status;
    end;
      
  finally
    JsonArray.Free;
  end;
  
end;

procedure TFrmGerenciarNota.FormCreate(Sender: TObject);
begin
  gridNotas.Cells[0, 0] := 'ID';
  gridNotas.Cells[1, 0] := 'Data';
  gridNotas.Cells[2, 0] := 'Status';
  CarregaNota();
end;

end.
