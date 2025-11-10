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
  ulistatime;
{$R *.lfm}

{ TFrmTime }

procedure TFrmTime.BitBtn2Click(Sender: TObject);
begin
  Close;
  FrmListaTime.qryListaTime.Refresh;
end;

procedure TFrmTime.FormShow(Sender: TObject);
begin
  // 🟨 Ação: editar projeto existente
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

  // 🟩 Ação: inserir novo projeto
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
begin
  if DBEdit1.Text = '' then
  begin
    ShowMessage('Escreva o nome do time para salvar. ');
    Exit;
  end;

  qryTime.Post;

  FrmListaTime.qryListaTime.Refresh;
end;

end.

