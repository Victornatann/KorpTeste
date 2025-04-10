program KorpErp;

uses
  Vcl.Forms,
  Main in 'source\view\Main.pas' {MainForm},
  uDm in 'source\connection\uDm.pas' {DM: TDataModule},
  Estoque.Service.Interfaces in 'source\interface\Estoque.Service.Interfaces.pas',
  Faturamento.Service.Interfaces in 'source\interface\Faturamento.Service.Interfaces.pas',
  Produto in 'source\model\Produto.pas',
  EstoqueService in 'source\services\EstoqueService.pas',
  FaturamentoService in 'source\services\FaturamentoService.pas',
  CadProFrm in 'source\view\CadProFrm.pas' {FrmCadPro},
  NotaFrm in 'source\view\NotaFrm.pas' {FrmNota},
  Utils in 'source\shared\Utils.pas',
  GerenciarNotaFrm in 'source\view\GerenciarNotaFrm.pas' {FrmGerenciarNota},
  Nota in 'source\model\Nota.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
