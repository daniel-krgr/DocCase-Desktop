unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ActnList, ZDataset, RxDBGrid;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    act_projetos: TAction;
    act_usuarios: TAction;
    act_dashboard: TAction;
    act_novo: TAction;
    ActionList1: TActionList;
    ds_projeto_list: TDataSource;
    Image1: TImage;
    Image10: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblNumerVersao: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Proj7: TLabel;
    Proj8: TLabel;
    Autor2: TLabel;
    Data2: TLabel;
    Data1: TLabel;
    Autor1: TLabel;
    Data3: TLabel;
    Autor3: TLabel;
    Data4: TLabel;
    Autor4: TLabel;
    Data8: TLabel;
    Autor8: TLabel;
    Data7: TLabel;
    Autor7: TLabel;
    Data6: TLabel;
    Autor6: TLabel;
    Data5: TLabel;
    Autor5: TLabel;
    Proj1: TLabel;
    Proj5: TLabel;
    Proj2: TLabel;
    Proj6: TLabel;
    Proj4: TLabel;
    Proj3: TLabel;
    projeto1: TPanel;
    projeto5: TPanel;
    projeto2: TPanel;
    projeto6: TPanel;
    projeto4: TPanel;
    projeto3: TPanel;
    projeto7: TPanel;
    projeto8: TPanel;
    qry_projeto_list: TZQuery;
    sbtNovo: TSpeedButton;
    sbtProjetos: TSpeedButton;
    sbtUsuarios: TSpeedButton;
    sbtDashboard: TSpeedButton;
    procedure act_dashboardExecute(Sender: TObject);
    procedure act_novoExecute(Sender: TObject);
    procedure act_projetosExecute(Sender: TObject);
    procedure act_usuariosExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses
  uCadastroUsuario, uProjeto;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 { with qry_projeto_list do
  begin
  Close;
  sql.Clear;
  SQL.Text:='SELECT * FROM projeto';
  Open;
  end;
  }
end;

procedure TfrmPrincipal.act_novoExecute(Sender: TObject);
begin
  if frmProjeto = nil then
  frmProjeto:= TfrmProjeto.Create(self);
  frmProjeto.ShowModal;
  frmProjeto.Free;
  frmProjeto:= nil;
end;

procedure TfrmPrincipal.act_dashboardExecute(Sender: TObject);
begin
 { if FrmCadastroUsuario = nil then
  FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
  FrmCadastroUsuario._action_ := 'insert';
  FrmCadastroUsuario.ShowModal;
  FrmCadastroUsuario.Free;
  FrmCadastroUsuario:= nil;
}
end;

procedure TfrmPrincipal.act_projetosExecute(Sender: TObject);
begin
  {if FrmCadastroUsuario = nil then
  FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
  FrmCadastroUsuario._action_ := 'insert';
  FrmCadastroUsuario.ShowModal;
  FrmCadastroUsuario.Free;
  FrmCadastroUsuario:= nil;
  }
end;

procedure TfrmPrincipal.act_usuariosExecute(Sender: TObject);
begin
 { if FrmCadastroUsuario = nil then
  FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
  FrmCadastroUsuario._action_ := 'insert';
  FrmCadastroUsuario.ShowModal;
  FrmCadastroUsuario.Free;
  FrmCadastroUsuario:= nil;
  }
  end;


end.

