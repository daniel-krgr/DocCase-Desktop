unit ulistacasouso;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmListaCasoUso }

  TFrmListaCasoUso = class(TForm)
    btnGerenciarVersoes: TSpeedButton;
    btnRegrasNegocio: TSpeedButton;
    dsListaCasoUso: TDataSource;
    DBGrid1: TDBGrid;
    dsAux: TDataSource;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblNomeCasoPai: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryAux: TZQuery;
    qryListaCasoUsodata_criacao: TZDateField;
    qryListaCasoUsodescricao: TZRawStringField;
    qryListaCasoUsoetiqueta_idetiqueta: TZIntegerField;
    qryListaCasoUsohora_criacao: TZTimeField;
    qryListaCasoUsoidcaso_uso: TZIntegerField;
    qryListaCasoUsonome: TZRawStringField;
    qryListaCasoUsoprecondicao: TZRawStringField;
    qryListaCasoUsoprojeto_idprojeto: TZIntegerField;
    qryListaCasoUsoversao: TZRawStringField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtVisualizar: TSpeedButton;
    sbtNovo: TSpeedButton;
    qryListaCasoUso: TZQuery;
    sbtNovo1: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    procedure btnGerenciarVersoesClick(Sender: TObject);
    procedure btnRegrasNegocioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
    procedure sbtNovo1Click(Sender: TObject);
    procedure sbtNovoClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
    procedure sbtVisualizarClick(Sender: TObject);
  private

  public
   var
   ProjetoID: Integer;
  end;

var
  FrmListaCasoUso: TFrmListaCasoUso;

implementation
 uses
   uProjeto, ucasodeuso, uator, ulistaator, ulistafluxo, uListaVersoesCasoUso, ulistaregranegocios;

{$R *.lfm}

{ TFrmListaCasoUso }

procedure TFrmListaCasoUso.FormShow(Sender: TObject);
begin
   if ProjetoID > 0 then
  begin
    // mostra o nome do projeto na label
    qryAux.Close;
    qryAux.SQL.Text := 'SELECT nome FROM projeto WHERE idprojeto = :id';
    qryAux.ParamByName('id').AsInteger := ProjetoID;
    qryAux.Open;

    lblNomeCasoPai.Caption := qryAux.FieldByName('nome').AsString;

    // carrega os casos de uso filtrados
    qryListaCasoUso.Close;
    qryListaCasoUso.SQL.Text := 'SELECT * FROM caso_uso WHERE projeto_idprojeto = :id';
    qryListaCasoUso.ParamByName('id').AsInteger := ProjetoID;
    qryListaCasoUso.Open;
  end;
end;

procedure TFrmListaCasoUso.btnGerenciarVersoesClick(Sender: TObject);
begin
   if FrmListaVersoesCasoUso = nil then
    FrmListaVersoesCasoUso := TFrmListaVersoesCasoUso.Create(Self);
  try
    FrmListaVersoesCasoUso.ShowModal;
  finally
    FrmListaVersoesCasoUso.Free;
    FrmListaVersoesCasoUso := nil;
  end;
end;

procedure TFrmListaCasoUso.btnRegrasNegocioClick(Sender: TObject);
begin
 if qryListaCasoUso.IsEmpty then
    Exit;

  if FrmListaRegrasNegocio = nil then
    FrmListaRegrasNegocio := TFrmListaRegrasNegocio.Create(Self);
  try
    FrmListaRegrasNegocio.idcaso_uso :=
      qryListaCasoUso.FieldByName('idcaso_uso').AsInteger;
    FrmListaRegrasNegocio.ShowModal;
  finally
    FrmListaRegrasNegocio.Free;
    FrmListaRegrasNegocio := nil;
  end;
end;

procedure TFrmListaCasoUso.sbtAdicionarClick(Sender: TObject);
begin
   if FrmCasoUso = nil then
    FrmCasoUso := TFrmCasoUso.Create(Self);

  FrmCasoUso._action_ := 'insert';
  FrmCasoUso.ProjetoID := ProjetoID;
  FrmCasoUso.NomeProjeto := lblNomeCasoPai.Caption;

  FrmCasoUso.ShowModal;
  FrmCasoUso.Free;
  FrmCasoUso := nil;

  qryListaCasoUso.Refresh;
end;

procedure TFrmListaCasoUso.sbtAtualizarClick(Sender: TObject);
begin
   qryListaCasoUso.Close;
   qryListaCasoUso.SQL.Text :=
  'SELECT idcaso_uso, nome, descricao, versao, projeto_idprojeto, ' +
  'data_criacao, hora_criacao, etiqueta_idetiqueta, precondicao ' +
  'FROM caso_uso WHERE projeto_idprojeto = :idProjeto ORDER BY nome';
   qryListaCasoUso.ParamByName('idProjeto').AsInteger := ProjetoID;
   qryListaCasoUso.Open;
end;

procedure TFrmListaCasoUso.sbtEditarClick(Sender: TObject);
begin
   if not qryListaCasoUso.IsEmpty then
  begin
    if FrmCasoUso = nil then
      FrmCasoUso := TFrmCasoUso.Create(Self);

    FrmCasoUso._action_ := 'edit';
    FrmCasoUso.ProjetoID := ProjetoID;
    FrmCasoUso.IdCasoUso := qryListaCasoUso.FieldByName('idcaso_uso').AsInteger;

    FrmCasoUso.ShowModal;
    FrmCasoUso.Free;
    FrmCasoUso := nil;

    qryListaCasoUso.Refresh;
  end;
end;

procedure TFrmListaCasoUso.sbtNovo1Click(Sender: TObject);
begin
   if FrmListaAtor = nil then
    FrmListaAtor := TFrmListaAtor.Create(Self);
  FrmListaAtor.ProjetoID := ProjetoID;
  FrmListaAtor.ShowModal;
  FrmListaAtor.Free;
  FrmListaAtor := nil;
end;

procedure TFrmListaCasoUso.sbtNovoClick(Sender: TObject);
begin
   if FrmListaFluxo = nil then
    FrmListaFluxo := TFrmListaFluxo.Create(Self);

  // passa os dois identificadores
  FrmListaFluxo.ProjetoID := ProjetoID;
  FrmListaFluxo.CasoUsoID := qryListaCasoUso.FieldByName('idcaso_uso').AsInteger;
  FrmListaFluxo.NomeProjeto := lblNomeCasoPai.Caption;
  FrmListaFluxo.ShowModal;

  FrmListaFluxo.Free;
  FrmListaFluxo := nil;
end;

procedure TFrmListaCasoUso.sbtPesquisarClick(Sender: TObject);
begin
  
 if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um caso de uso digite o nome do caso de uso no campo de texto. ');
   Exit;
 end;

 qryListaCasoUso.Close;
  qryListaCasoUso.SQL.Text :=
    'SELECT * FROM caso_uso ' +
    'WHERE nome LIKE :nome';
  qryListaCasoUso.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryListaCasoUso.Open;

  edtPesquisar.Text:='';
end;

procedure TFrmListaCasoUso.sbtVisualizarClick(Sender: TObject);
begin
 if not qryListaCasoUso.IsEmpty then
  begin
    if FrmCasoUso = nil then
      FrmCasoUso := TFrmCasoUso.Create(Self);

    FrmCasoUso._action_ := 'edit';
    FrmCasoUso.ProjetoID := ProjetoID;
    FrmCasoUso.IdCasoUso := qryListaCasoUso.FieldByName('idcaso_uso').AsInteger;
    FrmCasoUso.BitBtn1.Enabled:= False;

    FrmCasoUso.ShowModal;
    FrmCasoUso.Free;
    FrmCasoUso := nil;

    qryListaCasoUso.Refresh;
  end;
end;

end.

