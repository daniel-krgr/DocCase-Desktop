unit ulistausuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, ZDataset, ZAbstractRODataset, LMessages, ActnList;

type

  { TFrmListaUsuarios }

  TFrmListaUsuarios = class(TForm)
    ActionList1: TActionList;
    dsUsuarios: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryUsuariosdata_cadastro: TZDateField;
    qryUsuariosemail: TZRawStringField;
    qryUsuariosidusuarios: TZIntegerField;
    qryUsuariosimg_user: TZRawStringField;
    qryUsuariosnivel_acesso: TZRawStringField;
    qryUsuariosnome: TZRawStringField;
    qryUsuariossenha: TZRawStringField;
    qryUsuariossobrenome: TZRawStringField;
    qryUsuariosstatus: TZRawStringField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    qryUsuarios: TZQuery;
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
  private

  public
    var
    _action_:String;
  end;

var
  FrmListaUsuarios: TFrmListaUsuarios;

implementation
uses
  uCadastroUsuario;

{$R *.lfm}

{ TFrmListaUsuarios }

procedure TFrmListaUsuarios.FormShow(Sender: TObject);
begin
 With qryUsuarios do
  begin
    Close;
    SQL.clear;
    SQL.Text:='SELECT * FROM usuarios';
    open;
  end;
end;

procedure TFrmListaUsuarios.sbtAdicionarClick(Sender: TObject);
begin
 if FrmCadastroUsuario = nil then
    FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
    FrmCadastroUsuario._action_ := 'insert';
    FrmCadastroUsuario.ShowModal;
    FrmCadastroUsuario.Free;
    FrmCadastroUsuario:= nil;
end;

procedure TFrmListaUsuarios.sbtAtualizarClick(Sender: TObject);
begin
 With qryUsuarios do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM usuarios';
    Open;
  end;

end;

procedure TFrmListaUsuarios.sbtEditarClick(Sender: TObject);
begin
 if FrmCadastroUsuario = nil then
    FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
    FrmCadastroUsuario._action_ := 'edit';
    FrmCadastroUsuario.idusuarios := qryUsuarios.FieldByName('idusuarios').AsInteger;
    FrmCadastroUsuario.ShowModal;
    FrmCadastroUsuario.Free;
    FrmCadastroUsuario:= nil;
end;

procedure TFrmListaUsuarios.sbtPesquisarClick(Sender: TObject);
begin
  if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um usuário digite o nome do usuário no campo de texto. ');
   Exit;
 end;

 qryUsuarios.Close;
  qryUsuarios.SQL.Text :=
    'SELECT * FROM usuarios ' +
    'WHERE nome LIKE :nome';
  qryUsuarios.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryUsuarios.Open;

  edtPesquisar.Text:='';
end;


end.

