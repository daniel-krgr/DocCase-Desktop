unit ulistaprojetos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, Buttons, ActnList, ZDataset, ZAbstractRODataset;

type

  { TFrmListaProjetos }

  TFrmListaProjetos = class(TForm)
    actNovoCasoUso: TAction;
    actPesquisa: TAction;
    ActionList1: TActionList;
    dsListaProjetos: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    lblNumerVersao: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryListaProjetoscodigo: TZRawStringField;
    qryListaProjetosdata_cadastro: TZDateField;
    qryListaProjetosdescricao: TZRawStringField;
    qryListaProjetosdetalhe: TZRawCLobField;
    qryListaProjetosidprojeto: TZIntegerField;
    qryListaProjetosnome: TZRawStringField;
    qryListaProjetosop_publico: TZRawStringField;
    qryListaProjetostime_idtime: TZIntegerField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar2: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtNovo: TSpeedButton;
    qryListaProjetos: TZQuery;
    sbtPesquisar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    procedure actNovoCasoUsoExecute(Sender: TObject);
    procedure actPesquisaExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
  private

  public
    var
    _action_:String;
    idprojeto: Integer;
  end;

var
  FrmListaProjetos: TFrmListaProjetos;

implementation

uses
  uProjeto, ulistacasouso, uPrincipal, ulogin;
{$R *.lfm}

{ TFrmListaProjetos }

procedure TFrmListaProjetos.FormShow(Sender: TObject);
begin
 with qryListaProjetos do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT * FROM projeto';
    Open;
  end;

  lblNumerVersao.Caption := IntToStr(qryListaProjetos.RecordCount);

  // Debug temporário
  ShowMessage('Função do usuário: ' + frmLogin.UsuarioFuncao);

  // 🔹 Controle de acesso
  if SameText(Trim(frmLogin.UsuarioFuncao), 'Analista') then
  begin
    sbtAdicionar.Enabled  := True;
    sbtEditar.Enabled := True;
  end
  else
  begin
    sbtAdicionar.Enabled  := False;
    sbtEditar.Enabled := False;
  end;
end;

procedure TFrmListaProjetos.sbtAdicionarClick(Sender: TObject);
begin
  if frmProjeto = nil then
  frmProjeto:= TfrmProjeto.Create(self);
  frmProjeto._action_ := 'insert';
  frmProjeto.ShowModal;
  frmProjeto.Free;
  frmProjeto:= nil;
end;

procedure TFrmListaProjetos.sbtAtualizarClick(Sender: TObject);
begin
 With qryListaProjetos do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM projeto';
    Open;
  end;
end;

procedure TFrmListaProjetos.sbtEditarClick(Sender: TObject);
begin
   if frmProjeto = nil then
  frmProjeto:= TfrmProjeto.Create(self);
  frmProjeto._action_ := 'edit';
  frmProjeto.idprojeto := qryListaProjetos.FieldByName('idprojeto').AsInteger;
  frmProjeto.ShowModal;
  frmProjeto.Free;
  frmProjeto:= nil;
end;

procedure TFrmListaProjetos.actNovoCasoUsoExecute(Sender: TObject);
begin
  if FrmListaCasoUso = nil then
  FrmListaCasoUso:= TFrmListaCasoUso.Create(self);
  FrmListaCasoUso.ProjetoID := qryListaProjetos.FieldByName('idprojeto').AsInteger;
  FrmListaCasoUso.ShowModal;
  FrmListaCasoUso.Free;
  FrmListaCasoUso:= nil;
end;

procedure TFrmListaProjetos.actPesquisaExecute(Sender: TObject);
begin

 if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um projeto digite o nome do projeto no campo de texto. ');
   Exit;
 end;

 qryListaProjetos.Close;
  qryListaProjetos.SQL.Text :=
    'SELECT * FROM projeto ' +
    'WHERE nome LIKE :nome';
  qryListaProjetos.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryListaProjetos.Open;

  edtPesquisar.Text:='';
end;

procedure TFrmListaProjetos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  frmPrincipal.qry_projeto_list.Refresh;
end;

end.

