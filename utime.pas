unit utime;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmTime }

  TFrmTime = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBEdit1: TDBEdit;
    dsTime: TDataSource;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryTime: TZQuery;
    qryTimeidtime: TZIntegerField;
    qryTimenome: TZRawStringField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    var
    _action_:String;
    idtime: Integer;
  end;

var
  FrmTime: TFrmTime;

implementation

uses
  ulistatime, uConex;
{$R *.lfm}

{ TFrmTime }

procedure TFrmTime.BitBtn2Click(Sender: TObject);
begin
  Close;
  FrmListaTime.qryListaTime.Refresh;
end;

procedure TFrmTime.FormShow(Sender: TObject);
begin
  // Editar
  if _action_ = 'edit' then
  begin
    with qryTime do
    begin
      Close;
      SQL.Text := 'SELECT * FROM time WHERE idtime = :id';
      ParamByName('id').AsInteger := idtime;
      Open;
      Edit;
    end;
  end

  // Novo
  else if _action_ = 'insert' then
  begin
    with qryTime do
    begin
      Close;
      SQL.Text := 'SELECT * FROM time';
      Open;
      Insert;
    end;
  end;
end;

procedure TFrmTime.BitBtn1Click(Sender: TObject);
var
  Q: TZQuery;
  NomeTime: string;
  IDAtual: Integer;
begin
  NomeTime := Trim(DBEdit1.Text);

  if NomeTime = '' then
  begin
    ShowMessage('Escreva o nome do time para salvar. ');
    DBEdit1.SetFocus;
    Exit;
  end;

  // ID do registro atual (pode ser 0 se for insert)
  IDAtual := qryTime.FieldByName('idtime').AsInteger;

  // verifica se já existe outro time com mesmo nome
  Q := TZQuery.Create(nil);
  try
    Q.Connection := DM.ZConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS qtd ' +
      'FROM time ' +
      'WHERE UPPER(nome) = UPPER(:nome) ' +
      '  AND (:id = 0 OR idtime <> :id)';

    Q.ParamByName('nome').AsString := NomeTime;
    Q.ParamByName('id').AsInteger  := IDAtual;
    Q.Open;

    if Q.FieldByName('qtd').AsInteger > 0 then
    begin
      ShowMessage('Já existe um time com esse nome. Escolha outro.');
      DBEdit1.SetFocus;
      Exit;
    end;
  finally
    Q.Free;
  end;

  qryTime.FieldByName('nome').AsString := NomeTime;
  qryTime.Post;

  ShowMessage('Time cadastrado com sucesso. ');
  FrmListaTime.qryListaTime.Refresh;
  Close;
end;

end.

