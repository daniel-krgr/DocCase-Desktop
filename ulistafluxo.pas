unit ulistafluxo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, LResources, ZDataset, ZAbstractRODataset;

type

  { TFrmListaFluxo }

  TFrmListaFluxo = class(TForm)
    dsFluxo: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    lblProjeto: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryFluxocaso_uso_idcaso_uso: TZIntegerField;
    qryFluxoidfluxo: TZIntegerField;
    qryFluxonome: TZRawStringField;
    qryFluxopre_requisito: TZRawCLobField;
    qryFluxoprojeto_idprojeto: TZIntegerField;
    qryFluxotipo_fluxo: TZRawStringField;
    qryFluxoversao: TZRawStringField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    qryFluxo: TZQuery;
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
  private

  public
   var
    ProjetoID: Integer;
    CasoUsoID: Integer;
    NomeProjeto: string;
  end;

var
  FrmListaFluxo: TFrmListaFluxo;

implementation

uses
  ufluxo, ucasodeuso;
{$R *.lfm}

{ TFrmListaFluxo }

procedure TFrmListaFluxo.sbtAtualizarClick(Sender: TObject);
begin
   qryFluxo.Close;
   qryFluxo.SQL.Text :=
  'SELECT idfluxo, nome, tipo_fluxo, versao, pre_requisito, ' +
  'projeto_idprojeto, caso_uso_idcaso_uso ' +
  'FROM fluxo WHERE caso_uso_idcaso_uso = :idCasoUso ORDER BY nome';
   qryFluxo.ParamByName('idCasoUso').AsInteger := CasoUsoID;
   qryFluxo.Open;
end;

procedure TFrmListaFluxo.sbtEditarClick(Sender: TObject);
begin
   if not qryFluxo.IsEmpty then
  begin
    if FrmFluxo = nil then
      FrmFluxo := TFrmFluxo.Create(Self);

    FrmFluxo._action_ := 'edit';
    FrmFluxo.IdFluxo := qryFluxo.FieldByName('idfluxo').AsInteger;
    FrmFluxo.ProjetoID := ProjetoID;
    FrmFluxo.CasoUsoID := CasoUsoID;
    FrmFluxo.ShowModal;

    FrmFluxo.Free;
    FrmFluxo := nil;

    qryFluxo.Refresh;
  end;
end;

procedure TFrmListaFluxo.FormShow(Sender: TObject);
begin
   lblProjeto.Caption := 'Fluxos do Projeto: ' + NomeProjeto;

  qryFluxo.Close;
  qryFluxo.SQL.Text :=
    'SELECT idfluxo, nome, tipo_fluxo, versao, pre_requisito, projeto_idprojeto, caso_uso_idcaso_uso ' +
    'FROM fluxo ' +
    'WHERE projeto_idprojeto = :projId ' +
    '  AND caso_uso_idcaso_uso = :casoId ' +
    'ORDER BY nome';
  qryFluxo.ParamByName('projId').AsInteger := ProjetoID;
  qryFluxo.ParamByName('casoId').AsInteger := CasoUsoID;
  qryFluxo.Open;
end;

procedure TFrmListaFluxo.sbtAdicionarClick(Sender: TObject);
begin
   if FrmFluxo = nil then
    FrmFluxo := TFrmFluxo.Create(Self);

  FrmFluxo._action_ := 'insert';
  FrmFluxo.ProjetoID := ProjetoID;
  FrmFluxo.CasoUsoID := CasoUsoID;
  FrmFluxo.ShowModal;

  FrmFluxo.Free;
  FrmFluxo := nil;

  qryFluxo.Refresh;
end;

end.

