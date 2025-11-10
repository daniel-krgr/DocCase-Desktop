unit ulistatime;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls, ZDataset, ZAbstractRODataset;

type

  { TFrmListaTime }

  TFrmListaTime = class(TForm)
    DBGrid1: TDBGrid;
    dsListaTime: TDataSource;
    edtPesquisar: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryListaTime: TZQuery;
    qryListaTimeidtime: TZIntegerField;
    qryListaTimeidtime1: TZIntegerField;
    qryListaTimenome: TZRawStringField;
    qryListaTimenome1: TZRawStringField;
    sbtAdicionar: TSpeedButton;
    sbtAtualizar: TSpeedButton;
    sbtEditar: TSpeedButton;
    sbtPesquisar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure sbtAdicionarClick(Sender: TObject);
    procedure sbtAtualizarClick(Sender: TObject);
    procedure sbtEditarClick(Sender: TObject);
    procedure sbtPesquisarClick(Sender: TObject);
  private

  public
   var
   _action_: String;
  end;

var
  FrmListaTime: TFrmListaTime;

implementation

uses
  utime;

{$R *.lfm}

{ TFrmListaTime }

procedure TFrmListaTime.sbtAtualizarClick(Sender: TObject);
begin
  With qryListaTime do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM time';
    Open;
  end;
end;

procedure TFrmListaTime.sbtEditarClick(Sender: TObject);
begin
 if FrmTime = nil then
  FrmTime:= TFrmTime.Create(self);
  FrmTime._action_ := 'edit';
  FrmTime.idtime := qryListaTime.FieldByName('idtime').AsInteger;
  FrmTime.ShowModal;
  FrmTime.Free;
  FrmTime:= nil;
end;

procedure TFrmListaTime.sbtPesquisarClick(Sender: TObject);
begin
  if edtPesquisar.Text = '' then
 begin
   ShowMessage('para pesquisar um time digite o nome do time no campo de texto. ');
   Exit;
 end;

 qryListaTime.Close;
  qryListaTime.SQL.Text :=
    'SELECT * FROM time ' +
    'WHERE nome LIKE :nome';
  qryListaTime.ParamByName('nome').AsString := '%' + edtPesquisar.Text + '%';
  qryListaTime.Open;

  edtPesquisar.Text:='';
end;

procedure TFrmListaTime.sbtAdicionarClick(Sender: TObject);
begin
  if FrmTime = nil then
  FrmTime:= TFrmTime.Create(self);
  FrmTime._action_ := 'insert';
  FrmTime.ShowModal;
  FrmTime.Free;
  FrmTime:= nil;
end;

procedure TFrmListaTime.FormShow(Sender: TObject);
begin
 With qryListaTime do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM time';
    Open;
  end;
end;

end.

