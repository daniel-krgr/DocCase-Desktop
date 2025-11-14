unit uProjeto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBCtrls, SynEdit, ZDataset, ZAbstractRODataset, ZConnection;

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
    pnlImagem: TFlowPanel;
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
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnAnexarClick(Sender: TObject);
    procedure btnRemoverImagemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ThumbClick(Sender: TObject);
  private
    FImagemSelecionadaID: Integer;
    procedure CarregarMiniaturas(const PID: Integer);
    //procedure AbrirImagemGrande(const AnexoID: Integer);
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
  Thumb.Picture.Assign(nil);
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

  while pnlImagem.ControlCount > 0 do
    pnlImagem.Controls[0].Free;

  qryImgs.First;
  while not qryImgs.EOF do
  begin
    Img := TImage.Create(pnlImagem);
    Img.Parent        := pnlImagem;
    Img.Width         := 120;
    Img.Height        := 90;
    Img.Stretch       := True;
    Img.Proportional  := True;
    Img.Center        := True;
    Img.Cursor        := crHandPoint;
    Img.Hint          := qryImgs.FieldByName('nome_arquivo').AsString;
    Img.ShowHint      := True;
    Img.Tag           := qryImgs.FieldByName('idimagem').AsInteger;
    Img.OnClick       := @ThumbClick;  // <-- corrige aqui

    Ext := LowerCase(ExtractFileExt(qryImgs.FieldByName('nome_arquivo').AsString));
    if Ext = '' then
    begin
      if Pos('png',  LowerCase(qryImgs.FieldByName('mime').AsString)) > 0 then Ext := '.png' else
      if Pos('jpeg', LowerCase(qryImgs.FieldByName('mime').AsString)) > 0 then Ext := '.jpg' else
      if Pos('jpg',  LowerCase(qryImgs.FieldByName('mime').AsString)) > 0 then Ext := '.jpg' else
      if Pos('bmp',  LowerCase(qryImgs.FieldByName('mime').AsString)) > 0 then Ext := '.bmp' else
      if Pos('gif',  LowerCase(qryImgs.FieldByName('mime').AsString)) > 0 then Ext := '.gif';
    end;

    MS := TMemoryStream.Create;
    try
      TBlobField(qryImgs.FieldByName('imagem')).SaveToStream(MS);
      MS.Position := 0;

      if Ext <> '' then
        Img.Picture.LoadFromStreamWithFileExt(MS, Ext)
      else
        Img.Picture.LoadFromStream(MS);
    finally
      MS.Free;
    end;

    qryImgs.Next;
  end;
end;

procedure TfrmProjeto.BitBtn1Click(Sender: TObject);
begin
  // verifica se o usuário selecionou um time
  if cbTime.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um time antes de salvar o projeto!');
    Exit;
  end;

  // define o id do time selecionado
  qryProjeto.FieldByName('time_idtime').AsInteger :=
    PtrInt(cbTime.Items.Objects[cbTime.ItemIndex]);

  qryProjeto.FieldByName('detalhe').AsString:= DBMemo1.Lines.Text;

  qryProjeto.Post;
  qryProjeto.ApplyUpdates; // opcional, mas recomendável
  ShowMessage('Projeto salvo com sucesso!');
end;

procedure TfrmProjeto.FormShow(Sender: TObject);
var i: Integer;
begin
 // 🟦 Preenche ComboBox com os times
  cbTime.Clear;
  with qryTime do
  begin
    Close;
    SQL.Text := 'SELECT idtime, nome FROM time ORDER BY nome';
    Open;
    while not Eof do
    begin
      cbTime.Items.AddObject(
        FieldByName('nome').AsString,
        TObject(PtrInt(FieldByName('idtime').AsInteger))
      );
      Next;
    end;
  end;

  // 🟨 Ação: editar projeto existente
  if _action_ = 'edit' then
  begin
    with qryProjeto do
    begin
      Close;
      SQL.Text := 'SELECT * FROM projeto WHERE idprojeto = :id';
      ParamByName('id').AsInteger := idprojeto;
      Open;
      Edit;

      // seleciona o time correspondente na combo
      if not FieldByName('time_idtime').IsNull then
      begin
        for i := 0 to cbTime.Items.Count - 1 do
          if PtrInt(cbTime.Items.Objects[i]) = FieldByName('time_idtime').AsInteger then
          begin
            cbTime.ItemIndex := i;
            Break;
          end;
      end;
    end;
  end

  // 🟩 Ação: inserir novo projeto
  else if _action_ = 'insert' then
  begin
    with qryProjeto do
    begin
      Close;
      SQL.Text := 'SELECT * FROM projeto';
      Open;
      Insert;
      FieldByName('data_cadastro').AsDateTime := Date;
      FieldByName('op_publico').AsString := 'N';
    end;
  end;
end;

procedure TfrmProjeto.ThumbClick(Sender: TObject);
var
  AnexoID: Integer;
  MS: TMemoryStream;
  Ext: String;
begin
  AnexoID := (Sender as TImage).Tag;
  FImagemSelecionadaID := AnexoID;

  qryOne.Close;
  qryOne.SQL.Text := 'SELECT nome_arquivo, mime, imagem FROM projeto_imagem WHERE idimagem = :id';
  qryOne.ParamByName('id').AsInteger := AnexoID;
  qryOne.Open;
  if qryOne.IsEmpty then Exit;

  Ext := LowerCase(ExtractFileExt(qryOne.FieldByName('nome_arquivo').AsString));
  if Ext = '' then
  begin
    if Pos('png',  LowerCase(qryOne.FieldByName('mime').AsString)) > 0 then Ext := '.png' else
    if Pos('jpeg', LowerCase(qryOne.FieldByName('mime').AsString)) > 0 then Ext := '.jpg' else
    if Pos('jpg',  LowerCase(qryOne.FieldByName('mime').AsString)) > 0 then Ext := '.jpg' else
    if Pos('bmp',  LowerCase(qryOne.FieldByName('mime').AsString)) > 0 then Ext := '.bmp' else
    if Pos('gif',  LowerCase(qryOne.FieldByName('mime').AsString)) > 0 then Ext := '.gif';
  end;

  MS := TMemoryStream.Create;
  try
    TBlobField(qryOne.FieldByName('imagem')).SaveToStream(MS);
    MS.Position := 0;

    if Ext <> '' then
      Thumb.Picture.LoadFromStreamWithFileExt(MS, Ext) // <-- usa Thumb
    else
      Thumb.Picture.LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

end.

