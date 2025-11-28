unit ucasodeuso;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ZDataset, ZAbstractRODataset;

type

  { TFrmCasoUso }

  TFrmCasoUso = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dsCasoUso: TDataSource;
    edtNome: TDBEdit;
    edtVersao: TDBEdit;
    edtPrecondicao: TDBEdit;
    dbmDescricao: TDBMemo;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    qryCasoUso: TZQuery;
    qryCasoUsodata_criacao: TZDateField;
    qryCasoUsodescricao: TZRawStringField;
    qryCasoUsoetiqueta_idetiqueta: TZIntegerField;
    qryCasoUsohora_criacao: TZTimeField;
    qryCasoUsoidcaso_uso: TZIntegerField;
    qryCasoUsonome: TZRawStringField;
    qryCasoUsoprecondicao: TZRawStringField;
    qryCasoUsoprojeto_idprojeto: TZIntegerField;
    qryCasoUsoversao: TZRawStringField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure edtNomeKeyPress(Sender: TObject; var Key: char);
    procedure edtPrecondicaoKeyPress(Sender: TObject; var Key: char);
    procedure edtVersaoKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
   procedure SalvarVersaoAtualNoHistorico;
  public
   var
    ProjetoID: Integer;
    NomeProjeto: string;
    IdCasoUso: Integer;
    _action_: string;
  end;

var
  FrmCasoUso: TFrmCasoUso;

implementation
uses
  uConex, uSeguranca, ulistacasouso;
{$R *.lfm}

{ TFrmCasoUso }

procedure TFrmCasoUso.SalvarVersaoAtualNoHistorico;
var
  Q: TZQuery;
  v: Integer;
begin
  // garante que sempre tem um número de versão
  v := StrToIntDef(qryCasoUso.FieldByName('versao').AsString, 0);
  if v <= 0 then
    v := 1;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DM.ZConnection;

    Q.SQL.Text :=
      'INSERT INTO caso_uso_versao ' +
      '  (caso_uso_id, versao, nome, descricao, precondicao, data_versao, usuario_nome) ' +
      'VALUES ' +
      '  (:caso_uso_id, :versao, :nome, :descricao, :precondicao, :data_versao, :usuario_nome)';

    Q.ParamByName('caso_uso_id').AsInteger :=
      qryCasoUso.FieldByName('idcaso_uso').AsInteger;
    Q.ParamByName('versao').AsInteger :=
      v;
    Q.ParamByName('nome').AsString :=
      qryCasoUso.FieldByName('nome').AsString;
    Q.ParamByName('descricao').AsString :=
      qryCasoUso.FieldByName('descricao').AsString;
    Q.ParamByName('precondicao').AsString :=
      qryCasoUso.FieldByName('precondicao').AsString;
    Q.ParamByName('data_versao').AsDateTime :=
      Now;

    // se tiver controle de usuário logado, coloca aqui
    Q.ParamByName('usuario_nome').AsString := '';

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFrmCasoUso.BitBtn1Click(Sender: TObject);
var
  v: Integer;
begin

  if not TamanhoEntre(EdtNome.Text, 5, 100) then
  begin
    ShowMessage('O nome deve ter entre 5 e 100 caracteres.');
    EdtNome.SetFocus;
    Exit;
  end;

  if edtVersao.Text = '' then
  begin
   ShowMessage('Indique a versão do caso de uso. ');
   edtVersao.SetFocus;
   Exit;
  end;

  if Trim(dbmDescricao.Lines.Text) = '' then
  begin
    ShowMessage('Digite a descrição do caso de uso. ');
    dbmDescricao.SetFocus;
    Exit;
  end;

  // garante que tem algo em edição
  if not (qryCasoUso.State in [dsInsert, dsEdit]) then
  begin
    ShowMessage('Nada para salvar.');
    Exit;
  end;

  if qryCasoUso.State = dsInsert then
  begin
    qryCasoUso.FieldByName('projeto_idprojeto').AsInteger := ProjetoID;
    qryCasoUso.FieldByName('data_criacao').AsDateTime := Date;
    qryCasoUso.FieldByName('hora_criacao').AsDateTime := Time;

    qryCasoUso.FieldByName('versao').AsString := '1';
  end
  else
  if qryCasoUso.State = dsEdit then
  begin
    v := StrToIntDef(qryCasoUso.FieldByName('versao').AsString, 0);
    if v <= 0 then
      v := 1;
    Inc(v);
    qryCasoUso.FieldByName('versao').AsString := IntToStr(v);
  end;
  qryCasoUso.Post;

  SalvarVersaoAtualNoHistorico;

  ShowMessage('Caso de uso salvo com sucesso!');
  FrmListaCasoUso.qryListaCasoUso.Refresh;
  Close;
end;

procedure TFrmCasoUso.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmCasoUso.edtNomeKeyPress(Sender: TObject; var Key: char);
begin
  FiltraSomenteLetras(Key, True);
end;

procedure TFrmCasoUso.edtPrecondicaoKeyPress(Sender: TObject; var Key: char);
begin
  FiltraSomenteLetras(Key, True);
end;

procedure TFrmCasoUso.edtVersaoKeyPress(Sender: TObject; var Key: char);
begin
  FiltraSomenteNumeros(Key, False);
end;

procedure TFrmCasoUso.FormShow(Sender: TObject);
begin
  
  qryCasoUso.Close;
  qryCasoUso.SQL.Text := 'SELECT * FROM caso_uso';
  qryCasoUso.Open;

  if _action_ = 'insert' then
  begin
    qryCasoUso.Insert;
    qryCasoUso.FieldByName('projeto_idprojeto').AsInteger := ProjetoID;
    qryCasoUso.FieldByName('etiqueta_idetiqueta').AsInteger := 1; // sempre 1
    qryCasoUso.FieldByName('data_criacao').AsDateTime := Date;
    qryCasoUso.FieldByName('hora_criacao').AsDateTime := Time;
  end
  else if _action_ = 'edit' then
  begin
    qryCasoUso.Close;
    qryCasoUso.SQL.Text := 'SELECT * FROM caso_uso WHERE idcaso_uso = :id';
    qryCasoUso.ParamByName('id').AsInteger := IdCasoUso;
    edtVersao.Enabled:= False;
    qryCasoUso.Open;
    qryCasoUso.Edit;
  end;
end;

end.

