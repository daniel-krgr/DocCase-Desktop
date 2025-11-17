unit ufluxo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ZDataset, ZAbstractRODataset;

type

  { TFrmFluxo }

  TFrmFluxo = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    dsFluxo: TDataSource;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    qryFluxo: TZQuery;
    qryFluxocaso_uso_idcaso_uso: TZIntegerField;
    qryFluxoidfluxo: TZIntegerField;
    qryFluxonome: TZRawStringField;
    qryFluxopre_requisito: TMemoField;
    qryFluxoprojeto_idprojeto: TZIntegerField;
    qryFluxotipo_fluxo: TZRawStringField;
    qryFluxoversao: TZRawStringField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBEdit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public
    var
    ProjetoID: Integer;
    CasoUsoID: Integer;
    NomeProjeto: string;
    IdFluxo: Integer;
    _action_: string;
  end;

var
  FrmFluxo: TFrmFluxo;

implementation
 uses
   ulistafluxo, uSeguranca;
{$R *.lfm}

{ TFrmFluxo }

procedure TFrmFluxo.FormShow(Sender: TObject);
begin
    qryFluxo.Close;
  qryFluxo.SQL.Text := 'SELECT * FROM fluxo';
  qryFluxo.Open;

  if _action_ = 'insert' then
  begin
    qryFluxo.Insert;
    qryFluxo.FieldByName('projeto_idprojeto').AsInteger := ProjetoID;
    qryFluxo.FieldByName('caso_uso_idcaso_uso').AsInteger := CasoUsoID;
  end
  else if _action_ = 'edit' then
  begin
    qryFluxo.Close;
    qryFluxo.SQL.Text := 'SELECT * FROM fluxo WHERE idfluxo = :id';
    qryFluxo.ParamByName('id').AsInteger := IdFluxo;
    qryFluxo.Open;
    qryFluxo.Edit;
  end;
end;

procedure TFrmFluxo.BitBtn1Click(Sender: TObject);
begin
  if DBEdit1.Text = '' then
  begin
   ShowMessage('Descreva o nome do fluxo. ');
   DBEdit1.SetFocus;
   Exit;
  end;

  if Trim(DBMemo1.Lines.Text) = '' then
  begin
    ShowMessage('Digite a descrição do fluxo. ');
    DBMemo1.SetFocus;
    Exit;
  end;

  qryFluxo.Post;
  ShowMessage('Fluxo salvo com sucesso!');
  FrmListaFluxo.qryFluxo.Refresh;
  Close;
end;

procedure TFrmFluxo.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmFluxo.DBEdit1KeyPress(Sender: TObject; var Key: char);
begin
   FiltraSomenteLetras(Key, True);
end;

end.

