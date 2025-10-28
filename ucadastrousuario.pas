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
    cbNivelAcesso: TComboBox;
    edtSobrenome: TDBEdit;
    edtEmail: TDBEdit;
    edtSenha: TDBEdit;
    ds_usuarios: TDataSource;
    edtNome: TDBEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    qry_usuarios: TZQuery;
    qry_usuariosdata_cadastro: TZDateField;
    qry_usuariosemail: TZRawStringField;
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

{$R *.lfm}

{ TFrmCadastroUsuario }

procedure TFrmCadastroUsuario.btCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmCadastroUsuario.btSalvarClick(Sender: TObject);
begin
  qry_usuarios.Post;
  ShowMessage('Dados salvos com sucesso!');
end;

procedure TFrmCadastroUsuario.FormShow(Sender: TObject);
begin
  if _action_ = 'edit'then
  begin
    with qry_usuarios do begin
      close;
      sql.Clear;
      sql.Add('select * from usuarios where idusuarios = :id');
      ParamByName('id').AsInteger:=idusuarios;
      open;
    end;
    qry_usuarios.Edit;
  end;
  if _action_ = 'insert'then
  begin
    with qry_usuarios do begin
      close;
      sql.Clear;
      sql.Add('select * from usuarios where idusuarios = :id');
      ParamByName('id').AsInteger:=-1;
      open;
    end;
    qry_usuarios.Insert;
  end;

end;

end.

