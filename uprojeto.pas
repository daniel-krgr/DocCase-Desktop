unit uProjeto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBCtrls, ZDataset, ZAbstractRODataset, RichMemo, SynHighlighterTeX, ZConnection;

type

  { TfrmProjeto }

  TfrmProjeto = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbTime: TComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBMemo1: TDBMemo;
    dsProjeto: TDataSource;
    dsTime: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    qryProjetocodigo: TZRawStringField;
    qryProjetodata_cadastro: TZDateField;
    qryProjetodescricao: TZRawStringField;
    qryProjetodetalhe: TZRawCLobField;
    qryProjetoidprojeto: TZIntegerField;
    qryProjetonome: TZRawStringField;
    qryProjetoop_publico: TZRawStringField;
    qryProjetotime_idtime: TZIntegerField;
    qryTimeidtime: TZIntegerField;
    qryTimenome: TZRawStringField;
    qryProjeto: TZQuery;
    qryTime: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
   var
   _action_:String;//edit,insert
   idprojeto:Integer;
  end;

var
  frmProjeto: TfrmProjeto;

implementation

{$R *.lfm}

{ TfrmProjeto }

procedure TfrmProjeto.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmProjeto.BitBtn1Click(Sender: TObject);
begin
  // verifica se o usuário selecionou um time
  if cbTime.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um time antes de salvar o projeto!');
    Exit;
  end;

  // define o id do time selecionado
  qryProjeto.FieldByName('time_idtime').AsInteger :=
    PtrInt(cbTime.Items.Objects[cbTime.ItemIndex]);

  qryProjeto.Post;
  qryProjeto.ApplyUpdates; // opcional, mas recomendável
  ShowMessage('Projeto salvo com sucesso!');
end;

procedure TfrmProjeto.FormShow(Sender: TObject);
var i: Integer;
begin
 // 🟦 Preenche ComboBox com os times
  cbTime.Clear;
  with qryTime do
  begin
    Close;
    SQL.Text := 'SELECT idtime, nome FROM time ORDER BY nome';
    Open;
    while not Eof do
    begin
      cbTime.Items.AddObject(
        FieldByName('nome').AsString,
        TObject(PtrInt(FieldByName('idtime').AsInteger))
      );
      Next;
    end;
  end;

  // 🟨 Ação: editar projeto existente
  if _action_ = 'edit' then
  begin
    with qryProjeto do
    begin
      Close;
      SQL.Text := 'SELECT * FROM projeto WHERE idprojeto = :id';
      ParamByName('id').AsInteger := idprojeto;
      Open;
      Edit;

      // seleciona o time correspondente na combo
      if not FieldByName('time_idtime').IsNull then
      begin
        for i := 0 to cbTime.Items.Count - 1 do
          if PtrInt(cbTime.Items.Objects[i]) = FieldByName('time_idtime').AsInteger then
          begin
            cbTime.ItemIndex := i;
            Break;
          end;
      end;
    end;
  end

  // 🟩 Ação: inserir novo projeto
  else if _action_ = 'insert' then
  begin
    with qryProjeto do
    begin
      Close;
      SQL.Text := 'SELECT * FROM projeto';
      Open;
      Insert;
      FieldByName('data_cadastro').AsDateTime := Date;
      FieldByName('op_publico').AsString := 'N';
    end;
  end;
end;

end.

