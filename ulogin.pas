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

  SenhaHash := GeraMD5(edtSenha.Text);

  // usando Query do DataModule (DM.qryLogin)
  with qryLogin do
  begin
    Close;
    SQL.Text :=
      'SELECT nome, funcao FROM usuarios '+
      'WHERE nome = :nome AND senha = :senha';
    ParamByName('nome').AsString  := edtUsuario.Text;
    ParamByName('senha').AsString := SenhaHash;
    Open;
  end;

  if not qryLogin.IsEmpty then
  begin
    UsuarioLogado := qryLogin.FieldByName('nome').AsString;
    UsuarioFuncao := qryLogin.FieldByName('funcao').AsString;

    // fecha o ShowModal e entrega o controle ao .lpr
    ModalResult := mrOk;
  end
  else
    ShowMessage('Nome ou senha incorretos!');
end;

end.

