unit ulogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ZDataset;

type

  { TFrmLogin }

  TFrmLogin = class(TForm)
    btEntrar: TBitBtn;
    BitBtn2: TBitBtn;
    dsLogin: TDataSource;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryLogin: TZQuery;
    procedure BitBtn2Click(Sender: TObject);
    procedure btEntrarClick(Sender: TObject);
  private

  public
   var
    UsuarioLogado: string;
    UsuarioFuncao: string;
  end;

var
  FrmLogin: TFrmLogin;

implementation
 uses
   uSeguranca, uPrincipal;
{$R *.lfm}

{ TFrmLogin }

procedure TFrmLogin.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.btEntrarClick(Sender: TObject);
var
  SenhaHash: string;
begin
  // Validação básica
  if Trim(edtUsuario.Text) = '' then
  begin
    ShowMessage('Informe o nome de usuário.');
    edtUsuario.SetFocus;
    Exit;
  end;

  if Trim(edtSenha.Text) = '' then
  begin
    ShowMessage('Informe a senha.');
    edtSenha.SetFocus;
    Exit;
  end;

  // Criptografa a senha digitada
  SenhaHash := GeraMD5(edtSenha.Text);

  // Busca no banco (login por nome + senha hash)
  qryLogin.Close;
  qryLogin.SQL.Text :=
    'SELECT nome, funcao FROM usuarios ' +
    'WHERE nome = :nome AND senha = :senha';
  qryLogin.ParamByName('nome').AsString := edtUsuario.Text;
  qryLogin.ParamByName('senha').AsString := SenhaHash;
  qryLogin.Open;

  if not qryLogin.IsEmpty then
  begin
    UsuarioLogado := qryLogin.FieldByName('nome').AsString;
    UsuarioFuncao := qryLogin.FieldByName('funcao').AsString;

    // 🔹 Abre o formulário principal
    if frmPrincipal = nil then
      frmPrincipal := TfrmPrincipal.Create(Self);

    frmPrincipal.Show; //  abre normal (não modal)
    FrmLogin.Visible:= False;             //  fecha o login
  end
  else
    ShowMessage('Nome ou senha incorretos!');
end;

end.

