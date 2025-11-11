unit ucasodeuso;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ZDataset, ZAbstractRODataset;

type

  { TFrmCasoUso }

  TFrmCasoUso = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dsCasoUso: TDataSource;
    edtNome: TDBEdit;
    edtVersao: TDBEdit;
    edtPrecondicao: TDBEdit;
    dbmDescricao: TDBMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    qryCasoUso: TZQuery;
    qryCasoUsodata_criacao: TZDateField;
    qryCasoUsodescricao: TZRawStringField;
    qryCasoUsoetiqueta_idetiqueta: TZIntegerField;
    qryCasoUsohora_criacao: TZTimeField;
    qryCasoUsoidcaso_uso: TZIntegerField;
    qryCasoUsonome: TZRawStringField;
    qryCasoUsoprecondicao: TZRawStringField;
    qryCasoUsoprojeto_idprojeto: TZIntegerField;
    qryCasoUsoversao: TZRawStringField;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
   var
    ProjetoID: Integer;
    NomeProjeto: string;
    IdCasoUso: Integer;
    _action_: string;
  end;

var
  FrmCasoUso: TFrmCasoUso;

implementation

{$R *.lfm}

{ TFrmCasoUso }

procedure TFrmCasoUso.BitBtn1Click(Sender: TObject);
begin
  // garante que tá no modo correto
  if not (qryCasoUso.State in [dsInsert, dsEdit]) then
    qryCasoUso.Insert;

  // preenche o campo de vínculo
  qryCasoUso.FieldByName('projeto_idprojeto').AsInteger := ProjetoID;

  // grava data e hora automaticamente
  qryCasoUso.FieldByName('data_criacao').AsDateTime := Date;
  qryCasoUso.FieldByName('hora_criacao').AsDateTime := Time;

  qryCasoUso.Post;

  ShowMessage('Caso de uso salvo com sucesso!');
  Close;
end;

procedure TFrmCasoUso.FormShow(Sender: TObject);
begin
  
  qryCasoUso.Close;
  qryCasoUso.SQL.Text := 'SELECT * FROM caso_uso';
  qryCasoUso.Open;

  if _action_ = 'insert' then
  begin
    qryCasoUso.Insert;
    qryCasoUso.FieldByName('projeto_idprojeto').AsInteger := ProjetoID;
    qryCasoUso.FieldByName('etiqueta_idetiqueta').AsInteger := 1; // sempre 1
    qryCasoUso.FieldByName('data_criacao').AsDateTime := Date;
    qryCasoUso.FieldByName('hora_criacao').AsDateTime := Time;
  end
  else if _action_ = 'edit' then
  begin
    qryCasoUso.Close;
    qryCasoUso.SQL.Text := 'SELECT * FROM caso_uso WHERE idcaso_uso = :id';
    qryCasoUso.ParamByName('id').AsInteger := IdCasoUso;
    qryCasoUso.Open;
    qryCasoUso.Edit;
  end;
end;

end.

