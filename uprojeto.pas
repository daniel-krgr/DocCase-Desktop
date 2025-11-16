unit uProjeto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBCtrls, SynEdit, ZDataset, ZAbstractRODataset, ZConnection, ShellApi, windows;

type

  { TfrmProjeto }

  TfrmProjeto = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnAnexar: TBitBtn;
    btnRemoverImagem: TBitBtn;
    cbTime: TComboBox;
    dsOne: TDataSource;
    dsImgs: TDataSource;
    dsUpImg: TDataSource;
    dsExec: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBMemo1: TDBMemo;
    dsProjeto: TDataSource;
    dsTime: TDataSource;
    Thumb: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnlImagem: TPanel;
    qryProjeto: TZQuery;
    qryProjetocodigo: TZRawStringField;
    qryProjetocodigo1: TZRawStringField;
    qryProjetodata_cadastro: TZDateField;
    qryProjetodata_cadastro1: TZDateField;
    qryProjetodescricao: TZRawStringField;
    qryProjetodescricao1: TZRawStringField;
    qryProjetodetalhe: TZRawCLobField;
    qryProjetodetalhe1: TZRawCLobField;
    qryProjetoidprojeto: TZIntegerField;
    qryProjetoidprojeto1: TZIntegerField;
    qryProjetonome: TZRawStringField;
    qryProjetonome1: TZRawStringField;
    qryProjetoop_publico: TZRawStringField;
    qryProjetoop_publico1: TZRawStringField;
    qryProjetotime_idtime: TZIntegerField;
    qryProjetotime_idtime1: TZIntegerField;
    qryTime: TZQuery;
    qryTimeidtime: TZIntegerField;
    qryTimeidtime1: TZIntegerField;
    qryTimenome: TZRawStringField;
    qryTimenome1: TZRawStringField;
    ScrollBox1: TScrollBox;
    qryOne: TZQuery;
    qryImgs: TZQuery;
    qryUpImg: TZQuery;
    qryExec: TZQuery;
    ScrollBoxImagens: TScrollBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnAnexarClick(Sender: TObject);
    procedure btnRemoverImagemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FImagemSelecionadaID: Integer;
    procedure CarregarMiniaturas(const PID: Integer);
    procedure ThumbSelect(Sender: TObject);
    procedure ThumbOpen(Sender: TObject);

  public
   _action_:String;//edit,insert
   idprojeto:Integer;
  end;

var
  frmProjeto: TfrmProjeto;

implementation

{$R *.lfm}

{ TfrmProjeto }

procedure TfrmProjeto.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmProjeto.btnAnexarClick(Sender: TObject);
var
  i, PID: Integer;
  FS: TFileStream;
  Ext, Mime: String;
begin
  PID := qryProjeto.FieldByName('idprojeto').AsInteger;
  if PID = 0 then begin
    ShowMessage('Salve o projeto antes de anexar imagens.'); Exit;
  end;

  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  OpenDialog1.Filter := 'Imagens|*.png;*.jpg;*.jpeg;*.bmp;*.gif';
  if not OpenDialog1.Execute then Exit;

  for i := 0 to OpenDialog1.Files.Count - 1 do
  begin
    Ext := LowerCase(ExtractFileExt(OpenDialog1.Files[i]));
    if (Ext='.png') then Mime:='image/png' else
    if (Ext='.jpg') or (Ext='.jpeg') then Mime:='image/jpeg' else
    if (Ext='.bmp') then Mime:='image/bmp' else
    if (Ext='.gif') then Mime:='image/gif' else
      Mime:='application/octet-stream';

    qryUpImg.Close;
    qryUpImg.SQL.Text :=
      'INSERT INTO projeto_imagem(projeto_idprojeto, nome_arquivo, mime, imagem) '+
      'VALUES (:pid,:nome,:mime,:img)';
    qryUpImg.ParamByName('pid').AsInteger := PID;
    qryUpImg.ParamByName('nome').AsString := ExtractFileName(OpenDialog1.Files[i]);
    qryUpImg.ParamByName('mime').AsString := Mime;

    FS := TFileStream.Create(OpenDialog1.Files[i], fmOpenRead or fmShareDenyWrite);
    try
      qryUpImg.ParamByName('img').LoadFromStream(FS, ftBlob);
      qryUpImg.ExecSQL;
    finally
      FS.Free;
    end;
  end;

  pnlImagem.Width := ScrollBoxImagens.ClientWidth;
  pnlImagem.Height := 0;

  for i := 0 to pnlImagem.ControlCount - 1 do
    if pnlImagem.Controls[i].Top + pnlImagem.Controls[i].Height > pnlImagem.Height then
      pnlImagem.Height := pnlImagem.Controls[i].Top + pnlImagem.Controls[i].Height + 10;

  CarregarMiniaturas(PID);
end;

procedure TfrmProjeto.btnRemoverImagemClick(Sender: TObject);
var
  PID: Integer;
begin
  if FImagemSelecionadaID = 0 then
  begin
    ShowMessage('Selecione uma miniatura primeiro.'); Exit;
  end;

  qryExec.Close;
  qryExec.SQL.Text := 'DELETE FROM projeto_imagem WHERE idimagem=:id';
  qryExec.ParamByName('id').AsInteger := FImagemSelecionadaID;
  qryExec.ExecSQL;

  PID := qryProjeto.FieldByName('idprojeto').AsInteger;
  CarregarMiniaturas(PID);
  FImagemSelecionadaID := 0;
end;

procedure TFrmProjeto.CarregarMiniaturas(const PID: Integer);
var
  Img: TImage;
  MS: TMemoryStream;
  Ext: String;
begin
  qryImgs.Close;
  qryImgs.SQL.Text :=
    'SELECT idimagem, nome_arquivo, mime, imagem '+
    'FROM projeto_imagem WHERE projeto_idprojeto = :pid ORDER BY idimagem DESC';
  qryImgs.ParamByName('pid').AsInteger := PID;
  qryImgs.Open;

  // limpar miniaturas
  while pnlImagem.ControlCount > 0 do
    pnlImagem.Controls[0].Free;

  qryImgs.First;
  while not qryImgs.EOF do
  begin
    Img := TImage.Create(pnlImagem);
    Img.Parent        := pnlImagem;
    Img.Width         := 500;
    Img.Height        := 300;
    Img.Stretch       := True;
    Img.Proportional  := True;
    Img.Center        := True;
    Img.Cursor        := crHandPoint;
    Img.Tag           := qryImgs.FieldByName('idimagem').AsInteger;

    Img.OnClick       := @ThumbSelect;
    Img.OnDblClick    := @ThumbOpen;

    // extensão
    Ext := ExtractFileExt(qryImgs.FieldByName('nome_arquivo').AsString);
    if Ext = '' then Ext := '.jpg';

    // carregar imagem
    MS := TMemoryStream.Create;
    try
      TBlobField(qryImgs.FieldByName('imagem')).SaveToStream(MS);
      MS.Position := 0;
      Img.Picture.LoadFromStreamWithFileExt(MS, Ext);
    finally
      MS.Free;
    end;

    qryImgs.Next;
  end;
end;

procedure TfrmProjeto.BitBtn1Click(Sender: TObject);
begin
   begin
    if cbTime.ItemIndex < 0 then
    begin
      ShowMessage('Selecione um time.');
      Exit;
    end;

    qryProjeto.FieldByName('time_idtime').AsInteger :=
      PtrInt(cbTime.Items.Objects[cbTime.ItemIndex]);
    qryProjeto.FieldByName('detalhe').AsString := DBMemo1.Lines.Text;

    qryProjeto.Post;
    qryProjeto.ApplyUpdates;

    ShowMessage('Projeto salvo com sucesso.');
   end;
end;

procedure TfrmProjeto.FormShow(Sender: TObject);
begin
 cbTime.Clear;
 qryTime.Close;
 qryTime.SQL.Text := 'SELECT idtime, nome FROM time ORDER BY nome';
 qryTime.Open;

 while not qryTime.EOF do
 begin
   cbTime.Items.AddObject(qryTime.FieldByName('nome').AsString,
     TObject(PtrInt(qryTime.FieldByName('idtime').AsInteger)));
   qryTime.Next;
 end;

 // EDITAR
 if _action_ = 'edit' then
 begin
   qryProjeto.Close;
   qryProjeto.SQL.Text := 'SELECT * FROM projeto WHERE idprojeto = :id';
   qryProjeto.ParamByName('id').AsInteger := idprojeto;
   qryProjeto.Open;
   qryProjeto.Edit;

   CarregarMiniaturas(idprojeto);
 end

 // NOVO
 else if _action_ = 'insert' then
 begin
   qryProjeto.Close;
   qryProjeto.SQL.Text := 'SELECT * FROM projeto';
   qryProjeto.Open;
   qryProjeto.Insert;

   qryProjeto.FieldByName('data_cadastro').AsDateTime := Date;
   qryProjeto.FieldByName('op_publico').AsString := 'N';
 end;
end;

procedure TfrmProjeto.ThumbSelect(Sender: TObject);
var
  Img: TImage;
  i: Integer;
begin
  Img := Sender as TImage;

  // salva ID selecionado
  FImagemSelecionadaID := Img.Tag;
end;

procedure TfrmProjeto.ThumbOpen(Sender: TObject);
var
  ID: Integer;
  MS: TMemoryStream;
  Ext, Temp: String;
begin
  ID := (Sender as TImage).Tag;

  qryOne.Close;
  qryOne.SQL.Text := 'SELECT nome_arquivo, imagem FROM projeto_imagem WHERE idimagem = :id';
  qryOne.ParamByName('id').AsInteger := ID;
  qryOne.Open;

  Ext := ExtractFileExt(qryOne.FieldByName('nome_arquivo').AsString);

  Temp := GetTempDir + 'proj_img_preview' + Ext;

  MS := TMemoryStream.Create;
  try
    TBlobField(qryOne.FieldByName('imagem')).SaveToStream(MS);
    MS.SaveToFile(Temp);
  finally
    MS.Free;
  end;

  ShellExecute(0, 'open', PChar(Temp), nil, nil, SW_SHOWNORMAL);
end;

end.

