unit uCadastroUsuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmCadastroUsuario }

  TFrmCadastroUsuario = class(TForm)
    btCancelar: TBitBtn;
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
    procedure btCancelarClick(Sender: TObject);
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

procedure TFrmCadastroUsuario.btCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmCadastroUsuario.btSalvarClick(Sender: TObject);
var
  SenhaHash: String;
begin
//>>>>>>>>>>>>>>>>>>>>  Validação do Nome  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
    Exit;
    edtNome.SetFocus;
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
    Exit;
    edtSobrenome.SetFocus;
  end;

  if Length(edtSobrenome.Text) > 120 then
  begin
    ShowMessage('O sobrenome deve conter até 120 caracteres');
    edtSobrenome.SetFocus;
    Exit;
  end;

//>>>>>>>>>>>>>>>>>>>>  Validação do email  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  //if Length(edtEmail);


  SenhaHash := GeraMD5(edtSenha.Text);
  qry_usuarios.FieldByName('senha').AsString     := SenhaHash;


  qry_usuarios.Post;
  ShowMessage('Dados salvos com sucesso!');
  FrmListaUsuarios.qryUsuarios.Refresh;
end;

procedure TFrmCadastroUsuario.FormShow(Sender: TObject);
begin
   // 🟨 Ação: editar projeto existente
  if _action_ = 'edit' then
  begin
    with qry_usuarios do
    begin
      Close;
      SQL.Text := 'SELECT * FROM usuarios WHERE idusuarios = :id';
      ParamByName('id').AsInteger := idusuarios;
      Open;
      Edit;
    end;
  end

  // 🟩 Ação: inserir novo projeto
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

