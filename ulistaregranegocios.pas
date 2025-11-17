unit ulistaregranegocios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  StdCtrls, Buttons, ZDataset, ZAbstractRODataset;

type

  { TFrmListaRegrasNegocio }

  TFrmListaRegrasNegocio = class(TForm)
    dsListaRegra: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryListaRegracaso_uso_idcaso_uso: TZIntegerField;
    qryListaRegracod: TZIntegerField;
    qryListaRegradescricao: TZRawStringField;
    qryListaRegraidregra_negocio: TZIntegerField;
    qryListaRegraitem: TZIntegerField;
    qryListaRegranome: TZRawStringField;
    qryListaRegraversao: TZRawStringField;
    qryListaRegra: TZQuery;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    sbtVisualizar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure qryListaRegradescricaoGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
    procedure sbtVisualizarClick(Sender: TObject);
  private

  public
   _action_: string;
   idregra: Integer;
   idcaso_uso: Integer;
  end;

var
  FrmListaRegrasNegocio: TFrmListaRegrasNegocio;

implementation
 uses
   uregranegocio, uSeguranca;
{$R *.lfm}

{ TFrmListaRegrasNegocio }

procedure TFrmListaRegrasNegocio.FormShow(Sender: TObject);
begin
    qryListaRegra.Close;
  qryListaRegra.SQL.Text :=
    'SELECT * FROM regra_negocio '+
    'WHERE caso_uso_idcaso_uso = :id '+
    'ORDER BY cod';
  qryListaRegra.ParamByName('id').AsInteger := idcaso_uso;
  qryListaRegra.Open;
end;

procedure TFrmListaRegrasNegocio.qryListaRegradescricaoGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := ResumirCampoMemo(Sender, 300);
end;

procedure TFrmListaRegrasNegocio.sbtAdicionarClick(Sender: TObject);
begin
   if FrmRegraNegocio = nil then
    FrmRegraNegocio := TFrmRegraNegocio.Create(Self);
  try
    FrmRegraNegocio._action_ := 'insert';
    FrmRegraNegocio.idregra := 0;
    FrmRegraNegocio.idcaso_uso := idcaso_uso;

    if FrmRegraNegocio.ShowModal = mrOk then
     qryListaRegra.Refresh;

  finally
    FrmRegraNegocio.Free;
    FrmRegraNegocio := nil;
  end;
end;

procedure TFrmListaRegrasNegocio.sbtAtualizarClick(Sender: TObject);
begin
 qryListaRegra.Close;
  qryListaRegra.SQL.Text :=
    'SELECT * FROM regra_negocio '+
    'WHERE caso_uso_idcaso_uso = :id '+
    'ORDER BY cod';
  qryListaRegra.ParamByName('id').AsInteger := idcaso_uso;
  qryListaRegra.Open;
end;

procedure TFrmListaRegrasNegocio.sbtEditarClick(Sender: TObject);
begin
   if qryListaRegra.IsEmpty then Exit;

  if FrmRegraNegocio = nil then
    FrmRegraNegocio := TFrmRegraNegocio.Create(Self);
  try
    FrmRegraNegocio._action_ := 'edit';
    FrmRegraNegocio.idregra :=
      qryListaRegra.FieldByName('idregra_negocio').AsInteger;
    FrmRegraNegocio.idcaso_uso := idcaso_uso;

     if FrmRegraNegocio.ShowModal = mrOk then
      qryListaRegra.Refresh;

  finally
    FrmRegraNegocio.Free;
    FrmRegraNegocio := nil;
  end;
end;

procedure TFrmListaRegrasNegocio.sbtPesquisarClick(Sender: TObject);
begin
  if Trim(edtPesquisar.Text) = '' then
   begin
     ShowMessage('Para pesquisar um fluxo, digite parte do nome no campo de texto.');
     Exit;
   end;

   qryListaRegra.Close;
   qryListaRegra.SQL.Text :=
     'SELECT * FROM regra_negocio ' +
     'WHERE caso_uso_idcaso_uso = :id ' +
     '  AND nome LIKE :nome';

   qryListaRegra.ParamByName('id').AsInteger   := idcaso_uso;  // propriedade do form
   qryListaRegra.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';

   qryListaRegra.Open;

   edtPesquisar.Text := '';
end;

procedure TFrmListaRegrasNegocio.sbtVisualizarClick(Sender: TObject);
begin
   if qryListaRegra.IsEmpty then Exit;

  if FrmRegraNegocio = nil then
    FrmRegraNegocio := TFrmRegraNegocio.Create(Self);
  try
    FrmRegraNegocio._action_ := 'edit';
    FrmRegraNegocio.idregra :=
      qryListaRegra.FieldByName('idregra_negocio').AsInteger;
    FrmRegraNegocio.idcaso_uso := idcaso_uso;
    FrmRegraNegocio.BitBtn1.Enabled:= False;

    if FrmRegraNegocio.ShowModal = mrOk then
     qryListaRegra.Refresh;
  finally
    FrmRegraNegocio.Free;
    FrmRegraNegocio := nil;
  end;
end;

end.

