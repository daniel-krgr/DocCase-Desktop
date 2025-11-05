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
    dsNumProjeto: TDataSource;
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
    qryNumProjeto: TZQuery;
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
  uCadastroUsuario, uProjeto, ulistausuario;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
 i: Integer;
 Panel: TPanel;
 lblProj, lblAutor, lblData: TLabel;
begin
   // Consulta os 8 projetos mais recentes com nome do time
  with qry_projeto_list do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT p.nome AS nome_projeto, p.data_cadastro, t.nome AS nome_time ' +
            'FROM projeto p ' +
            'LEFT JOIN time t ON t.idtime = p.time_idtime ' +
            'ORDER BY p.data_cadastro DESC ' +
            'LIMIT 8');
    Open;
  end;

  // Esconde todos os painéis antes de preencher
  for i := 1 to 8 do
  begin
    Panel := TPanel(FindComponent('projeto' + IntToStr(i)));
    if Assigned(Panel) then
      Panel.Visible := False;
  end;

  // Preenche os painéis com os dados retornados
  qry_projeto_list.First;
  i := 1;
  while not qry_projeto_list.Eof do
  begin
    Panel := TPanel(FindComponent('projeto' + IntToStr(i)));
    if Assigned(Panel) then
    begin
      lblProj := TLabel(FindComponent('Proj' + IntToStr(i)));
      lblAutor := TLabel(FindComponent('Autor' + IntToStr(i)));
      lblData := TLabel(FindComponent('Data' + IntToStr(i)));

      if Assigned(lblProj) then
        lblProj.Caption := qry_projeto_list.FieldByName('nome_projeto').AsString;

      if Assigned(lblAutor) then
        lblAutor.Caption := qry_projeto_list.FieldByName('nome_time').AsString;

      if Assigned(lblData) then
      begin
        if not qry_projeto_list.FieldByName('data_cadastro').IsNull then
          lblData.Caption := FormatDateTime('dd/mm/yyyy', qry_projeto_list.FieldByName('data_cadastro').AsDateTime)
        else
          lblData.Caption := '';
      end;

      Panel.Visible := True;
    end;

    Inc(i);
    qry_projeto_list.Next;
  end;

  // Atualiza o total de versões (projetos listados)
  lblNumerVersao.Caption := IntToStr(i - 1);

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
  if FrmListaDeUsuarios = nil then
  FrmListaDeUsuarios:= TFrmListaDeUsuarios.Create(self);
  FrmListaDeUsuarios.ShowModal;
  FrmListaDeUsuarios.Free;
  FrmListaDeUsuarios:= nil;

end;


end.

