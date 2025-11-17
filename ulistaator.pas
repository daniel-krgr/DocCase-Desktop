unit ulistaator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, ZDataset, ZAbstractRODataset;

type

  { TFrmListaAtor }

  TFrmListaAtor = class(TForm)
    DBGrid1: TDBGrid;
    dsAtor: TDataSource;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryAtor: TZQuery;
    qryAtorfuncao: TZRawStringField;
    qryAtoridatores: TZIntegerField;
    qryAtornivel: TZRawStringField;
    qryAtornome: TZRawStringField;
    qryAtorprojeto_idprojeto: TZIntegerField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
  private

  public
   var
    _action_:String;
    idator: Integer;
    ProjetoID: Integer;
  end;

var
  FrmListaAtor: TFrmListaAtor;

implementation
 uses
   uator;
{$R *.lfm}

 { TFrmListaAtor }

 procedure TFrmListaAtor.sbtAdicionarClick(Sender: TObject);
 begin
   if FrmAtor = nil then
  FrmAtor:= TFrmAtor.Create(self);
  FrmAtor._action_ := 'insert';
  FrmAtor.ShowModal;
  FrmAtor.Free;
  FrmAtor:= nil;
 end;

procedure TFrmListaAtor.FormShow(Sender: TObject);
begin
  if ProjetoID > 0 then
  begin
    // carrega os atores vinculados ao projeto
    qryAtor.Close;
    qryAtor.SQL.Text :=
      'SELECT * FROM atores WHERE projeto_idprojeto = :id ORDER BY nome';
    qryAtor.ParamByName('id').AsInteger := ProjetoID;
    qryAtor.Open;
  end;
end;

procedure TFrmListaAtor.sbtAtualizarClick(Sender: TObject);
begin
  With qryAtor do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM atores';
    Open;
  end;
end;

procedure TFrmListaAtor.sbtEditarClick(Sender: TObject);
begin
  if FrmAtor = nil then
  FrmAtor:= TFrmAtor.Create(self);
  FrmAtor._action_ := 'edit';
  FrmAtor.idatores := qryAtor.FieldByName('idatores').AsInteger;
  FrmAtor.ShowModal;
  FrmAtor.Free;
  FrmAtor:= nil;
end;

procedure TFrmListaAtor.sbtPesquisarClick(Sender: TObject);
begin
  
 if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um ator digite o nome do ator no campo de texto. ');
   Exit;
 end;

 qryAtor.Close;
  qryAtor.SQL.Text :=
    'SELECT * FROM atores ' +
    'WHERE nome LIKE :nome';
  qryAtor.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryAtor.Open;

  edtPesquisar.Text:='';
end;

end.

