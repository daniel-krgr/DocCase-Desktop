unit uator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ZDataset, ZAbstractRODataset;

type

  { TFrmAtor }

  TFrmAtor = class(TForm)
    btSalvar: TBitBtn;
    btCancelar: TBitBtn;
    dsAtor: TDataSource;
    dbcNivel: TDBComboBox;
    edtNome: TDBEdit;
    edtFuncao: TDBEdit;
    Image1: TImage;
    Label1: TLabel;
    label2: TLabel;
    Label3: TLabel;
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
    procedure btCancelarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
   _action_:String;//edit,insert
   idator:Integer;
  end;

var
  FrmAtor: TFrmAtor;

implementation
uses
  ulistaator;

{$R *.lfm}

{ TFrmAtor }

procedure TFrmAtor.FormShow(Sender: TObject);
begin
  qryAtor.Close;
  qryAtor.SQL.Text := 'SELECT * FROM atores';
  qryAtor.Open;

  if _action_ = 'insert' then
  begin
    qryAtor.Insert;

    // aqui tu pega o ID do projeto direto do form pai
    qryAtor.FieldByName('projeto_idprojeto').AsInteger := FrmListaAtor.ProjetoID;
  end
  else if _action_ = 'edit' then
  begin
    qryAtor.Close;
    qryAtor.SQL.Text := 'SELECT * FROM atores WHERE idatores = :id';
    qryAtor.ParamByName('id').AsInteger := idAtor;
    qryAtor.Open;
    qryAtor.Edit;
  end;
end;

procedure TFrmAtor.btSalvarClick(Sender: TObject);
begin
  qryAtor.Post;
  ShowMessage('Ator cadastrado com sucesso. ');
end;

procedure TFrmAtor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FrmListaAtor.qryAtor.Refresh;
end;

procedure TFrmAtor.FormCreate(Sender: TObject);
begin
   dbcNivel.Items.Clear;
  dbcNivel.Items.Add('Primario');
  dbcNivel.Items.Add('Secundario');
  dbcNivel.Items.Add('Externo');
  dbcNivel.Items.Add('Sistema');
  dbcNivel.Items.Add('Interno');
end;

procedure TFrmAtor.btCancelarClick(Sender: TObject);
begin
  Close;
end;

end.

