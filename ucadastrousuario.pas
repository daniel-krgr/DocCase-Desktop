unit uCadastroUsuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmCadastroUsuario }

  TFrmCadastroUsuario = class(TForm)
    btAlterarSenha: TBitBtn;
    btCancelar1: TBitBtn;
    btSalvar: TBitBtn;
    DBComboBox1: TDBComboBox;
    edtSenha: TEdit;
    edtSobrenome: TDBEdit;
    edtEmail: TDBEdit;
    ds_usuarios: TDataSource;
    edtNome: TDBEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    qry_usuarios: TZQuery;
    qry_usuariosdata_cadastro: TZDateField;
    qry_usuariosemail: TZRawStringField;
    qry_usuariosfuncao: TZRawStringField;
    qry_usuariosidusuarios: TZIntegerField;
    qry_usuariosimg_user: TZRawStringField;
    qry_usuariosnivel_acesso: TZRawStringField;
    qry_usuariosnome: TZRawStringField;
    qry_usuariossenha: TZRawStringField;
    qry_usuariossobrenome: TZRawStringField;
    qry_usuariosstatus: TZRawStringField;
    procedure btAlterarSenhaClick(Sender: TObject);
    procedure btCancelar1Click(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    var
    _action_:String;//edit,insert
    idusuarios:Integer;
  end;

var
  FrmCadastroUsuario: TFrmCadastroUsuario;

implementation
uses
  ulistausuarios, useguranca;

{$R *.lfm}

{ TFrmCadastroUsuario }

procedure TFrmCadastroUsuario.btAlterarSenhaClick(Sender: TObject);
begin
  edtSenha.Enabled:=True;
end;

procedure TFrmCadastroUsuario.btCancelar1Click(Sender: TObject);
begin
 Close;
end;

procedure TFrmCadastroUsuario.btSalvarClick(Sender: TObject);
var
  SenhaHash: String;
  Email: String;
  NovaSenha: String;
  Novo: Boolean;
begin
  Novo := qry_usuarios.State = dsInsert;

  //>>>>>>>>>>>>>>>>>>>>  Validação do Nome  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  edtNome.Text := Trim(edtNome.Text);

  if edtNome.Text = '' then
  begin
    ShowMessage('O campo "Nome" é obrigatório.');
    edtNome.SetFocus;
    Exit;
  end;

  if Length(edtNome.Text) < 3 then
  begin
    ShowMessage('O nome deve conter pelo menos 3 caracteres. ');
    edtNome.SetFocus;
    Exit;
  end;

  if Length(edtNome.Text) > 45 then
  begin
    ShowMessage('O nome deve conter até 45 caracteres.');
    edtNome.SetFocus;
    Exit;
  end;

  //>>>>>>>>>>>>>>>>>>>>  Validação do sobrenome  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  edtSobrenome.Text := Trim(edtSobrenome.Text);

  if edtSobrenome.Text = '' then
  begin
    ShowMessage('O campo "Sobrenome" é obrigatório.');
    edtSobrenome.SetFocus;
    Exit;
  end;

  if Length(edtSobrenome.Text) < 3 then
  begin
    ShowMessage('O sobrenome deve conter pelo menos 3 caracteres.');
    edtSobrenome.SetFocus;
    Exit;
  end;

  if Length(edtSobrenome.Text) > 120 then
  begin
    ShowMessage('O sobrenome deve conter até 120 caracteres');
    edtSobrenome.SetFocus;
    Exit;
  end;

  //>>>>>>>>>>>>>>>>>>>>  Validação do e-mail  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Email := Trim(EdtEmail.Text);

  if not EmailValido(Email) then
  begin
    ShowMessage('Informe um e-mail válido.');
    EdtEmail.SetFocus;
    Exit;
  end;

  //>>>>>>>>>>>>>>>>>>>>  Validação da função (combo)  >>>>>>>>>>>>>>>>>>>>>>>>

  if DBComboBox1.ItemIndex < 0 then
  begin
    ShowMessage('Selecione uma função. ');
    DBComboBox1.SetFocus;
    Exit;
  end;

  //>>>>>>>>>>>>>>>>>>>>  SENHA  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  NovaSenha := Trim(edtSenha.Text);

  if Novo then
  begin
    // NOVO USUÁRIO
    if Length(NovaSenha) < 3 then
    begin
      ShowMessage('A senha deve conter pelo menos 3 caracteres.');
      edtSenha.SetFocus;
      Exit;
    end;

    SenhaHash := GeraMD5(NovaSenha);
    qry_usuarios.FieldByName('senha').AsString := SenhaHash;
  end
  else
  begin
    // EDITAR USUÁRIO
    if NovaSenha <> '' then
    begin
      if Length(NovaSenha) < 3 then
      begin
        ShowMessage('A nova senha deve conter pelo menos 3 caracteres.');
        edtSenha.SetFocus;
        Exit;
      end;

      SenhaHash := GeraMD5(NovaSenha);
      qry_usuarios.FieldByName('senha').AsString := SenhaHash;
    end;
    // se NovaSenha = '' -> não mexe no campo senha, continua o hash que já veio do banco
  end;

  //>>>>>>>>>>>>>>>>>>>>  SALVAR  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  qry_usuarios.Post;
  ShowMessage('Dados salvos com sucesso!');
  FrmListaUsuarios.qryUsuarios.Refresh;
  Close;
end;

procedure TFrmCadastroUsuario.FormShow(Sender: TObject);
begin
   // Editar
  if _action_ = 'edit' then
  begin
    with qry_usuarios do
    begin
      Close;
      SQL.Text := 'SELECT * FROM usuarios WHERE idusuarios = :id';
      ParamByName('id').AsInteger := idusuarios;
      Open;
      Edit;
      edtSenha.Enabled:= False;
    end;
  end

  // Novo
  else if _action_ = 'insert' then
  begin
    with qry_usuarios do
    begin
      Close;
      SQL.Text := 'SELECT * FROM usuarios';
      Open;
      Insert;
    end;
  end;
end;

end.

