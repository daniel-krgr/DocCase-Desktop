unit uregranegocio;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, StdCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmRegraNegocio }

  TFrmRegraNegocio = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbeNome: TDBEdit;
    dbeCodigo: TDBEdit;
    dbmDescricao: TDBMemo;
    dsRegra: TDataSource;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    qryRegra: TZQuery;
    qryRegracaso_uso_idcaso_uso: TZIntegerField;
    qryRegracod: TZIntegerField;
    qryRegradescricao: TZRawStringField;
    qryRegraidregra_negocio: TZIntegerField;
    qryRegraitem: TZIntegerField;
    qryRegranome: TZRawStringField;
    qryRegraversao: TZRawStringField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    _action_: string;
    idregra: Integer;
    idcaso_uso: Integer;
  end;

var
  FrmRegraNegocio: TFrmRegraNegocio;

implementation
 uses
   ulistaregranegocios;
{$R *.lfm}

{ TFrmRegraNegocio }

procedure TFrmRegraNegocio.FormShow(Sender: TObject);
begin
   qryRegra.Close;

  if _action_ = 'insert' then
  begin
    qryRegra.SQL.Text := 'SELECT * FROM regra_negocio WHERE 1=0';
    qryRegra.Open;
    qryRegra.Insert;

    qryRegra.FieldByName('caso_uso_idcaso_uso').AsInteger := idcaso_uso;
  end
  else
  if _action_ = 'edit' then
  begin
    qryRegra.SQL.Text := 'SELECT * FROM regra_negocio WHERE idregra_negocio = :id';
    qryRegra.ParamByName('id').AsInteger := idregra;
    qryRegra.Open;
    qryRegra.Edit;
  end;

end;

procedure TFrmRegraNegocio.BitBtn1Click(Sender: TObject);
begin
   // validações básicas
  if Trim(dbeNome.Text) = '' then
  begin
    ShowMessage('Informe o nome da regra de negócio.');
    dbeNome.SetFocus;
    Exit;
  end;
   if Trim(dbeCodigo.Text) = '' then
  begin
    ShowMessage('Informe o código da regra de negócio.');
    dbeCodigo.SetFocus;
    Exit;
  end;
  if Trim(dbmDescricao.Lines.Text) = '' then
  begin
    ShowMessage('Digite a descrição da regra de negócio.');
    dbmDescricao.SetFocus;
    Exit;
  end;

  if qryRegra.FieldByName('caso_uso_idcaso_uso').AsInteger = 0 then
    qryRegra.FieldByName('caso_uso_idcaso_uso').AsInteger := idcaso_uso;

  qryRegra.Post;
  ShowMessage('Dados cadastrados. ');
  FrmListaRegrasNegocio.qryListaRegra.Refresh;
  Close;
end;

procedure TFrmRegraNegocio.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.

