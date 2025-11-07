unit ulistaprojetos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, Buttons, ActnList, ZDataset, ZAbstractRODataset;

type

  { TFrmListaProjetos }

  TFrmListaProjetos = class(TForm)
    actNovoCasoUso: TAction;
    actPesquisa: TAction;
    ActionList1: TActionList;
    dsListaProjetos: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    lblNumerVersao: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryListaProjetoscodigo: TZRawStringField;
    qryListaProjetosdata_cadastro: TZDateField;
    qryListaProjetosdescricao: TZRawStringField;
    qryListaProjetosdetalhe: TZRawCLobField;
    qryListaProjetosidprojeto: TZIntegerField;
    qryListaProjetosnome: TZRawStringField;
    qryListaProjetosop_publico: TZRawStringField;
    qryListaProjetostime_idtime: TZIntegerField;
    sbtNovo: TSpeedButton;
    qryListaProjetos: TZQuery;
    sbtPesquisar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    procedure actNovoCasoUsoExecute(Sender: TObject);
    procedure actPesquisaExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
  private

  public

  end;

var
  FrmListaProjetos: TFrmListaProjetos;

implementation

{$R *.lfm}

{ TFrmListaProjetos }

procedure TFrmListaProjetos.FormShow(Sender: TObject);
begin
  With qryListaProjetos do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM projeto';
    Open;
  end;

  lblNumerVersao.Caption :=IntToStr(qryListaProjetos.RecordCount);
end;

procedure TFrmListaProjetos.sbtAtualizarClick(Sender: TObject);
begin
 With qryListaProjetos do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM projeto';
    Open;
  end;
end;

procedure TFrmListaProjetos.actNovoCasoUsoExecute(Sender: TObject);
begin

end;

procedure TFrmListaProjetos.actPesquisaExecute(Sender: TObject);
begin

 if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um projeto digite o nome do projeto no campo de texto. ');
   Exit;
 end;

 qryListaProjetos.Close;
  qryListaProjetos.SQL.Text :=
    'SELECT * FROM projeto ' +
    'WHERE nome LIKE :nome';
  qryListaProjetos.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryListaProjetos.Open;

  edtPesquisar.Text:='';
end;

end.

