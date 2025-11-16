unit uListaVersoesCasoUso;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmListaVersoesCasoUso }

  TFrmListaVersoesCasoUso = class(TForm)
    dsVersoes: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryVersoescaso_uso_id: TZIntegerField;
    qryVersoesdata_versao: TZDateTimeField;
    qryVersoesdescricao: TZRawCLobField;
    qryVersoesidversao: TZIntegerField;
    qryVersoesnome: TZRawStringField;
    qryVersoesprecondicao: TZRawStringField;
    qryVersoesusuario_nome: TZRawStringField;
    qryVersoesversao: TZIntegerField;
    sbtAtualizar: TSpeedButton;
    sbtNovo: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    qryVersoes: TZQuery;
    procedure FormShow(Sender: TObject);
    procedure qryVersoesdescricaoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtNovoClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
  private
   procedure CarregarVersoes;
  public

  end;

var
  FrmListaVersoesCasoUso: TFrmListaVersoesCasoUso;

implementation
uses
  uConex, ulistacasouso, uSeguranca;
{$R *.lfm}

{ TFrmListaVersoesCasoUso }

procedure TFrmListaVersoesCasoUso.sbtNovoClick(Sender: TObject);
var
  Q: TZQuery;
begin
  if qryVersoes.IsEmpty then
  begin
    ShowMessage('Nenhuma versão selecionada.');
    Exit;
  end;

  if MessageDlg('Confirmar',
                'Deseja tornar esta versão a versão ativa do caso de uso?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DM.ZConnection;
    Q.SQL.Text :=
      'UPDATE caso_uso SET ' +
      '  nome = :nome, ' +
      '  descricao = :descricao, ' +
      '  precondicao = :precondicao, ' +
      '  versao = :versao ' +
      'WHERE idcaso_uso = :id';

    Q.ParamByName('nome').AsString :=
      qryVersoes.FieldByName('nome').AsString;

    Q.ParamByName('descricao').AsString :=
      qryVersoes.FieldByName('descricao').AsString;

    Q.ParamByName('precondicao').AsString :=
      qryVersoes.FieldByName('precondicao').AsString;

    Q.ParamByName('versao').AsInteger :=
      qryVersoes.FieldByName('versao').AsInteger;

    Q.ParamByName('id').AsInteger :=
      qryVersoes.FieldByName('caso_uso_id').AsInteger;

    Q.ExecSQL;
  finally
    Q.Free;
  end;

  ShowMessage('Versão ativada com sucesso.');
  FrmListaCasoUso.qryListaCasoUso.Refresh;
  Close;
end;

procedure TFrmListaVersoesCasoUso.sbtPesquisarClick(Sender: TObject);
begin
   if edtPesquisar.Text = '' then
   begin
     ShowMessage('para pesquisar um projeto digite o nome do projeto no campo de texto. ');
     Exit;
   end;

 qryVersoes.Close;
  qryVersoes.SQL.Text :=
    'SELECT * FROM caso_uso_versao ' +
    'WHERE nome LIKE :nome';
  qryVersoes.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryVersoes.Open;

  edtPesquisar.Text:='';
end;

procedure TFrmListaVersoesCasoUso.FormShow(Sender: TObject);
begin
   qryVersoes.Connection := DM.ZConnection;
  CarregarVersoes;
end;

procedure TFrmListaVersoesCasoUso.qryVersoesdescricaoGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
 aText := ResumirCampoMemo(Sender, 300);
end;

procedure TFrmListaVersoesCasoUso.sbtAtualizarClick(Sender: TObject);
begin
  qryVersoes.Refresh;
end;

procedure TFrmListaVersoesCasoUso.CarregarVersoes;
begin
  qryVersoes.Close;
  qryVersoes.SQL.Clear;
  qryVersoes.SQL.Text :=
    'SELECT ' +
    '  idversao, ' +
    '  caso_uso_id, ' +
    '  versao, ' +
    '  nome, ' +
    '  descricao, ' +
    '  precondicao, ' +
    '  data_versao, ' +
    '  usuario_nome ' +
    'FROM caso_uso_versao ' +
    'ORDER BY nome, versao DESC';

  qryVersoes.Open;
end;

end.

