unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ActnList, ZDataset, RxDBGrid;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    act_cadastroUsuario: TAction;
    act_novo: TAction;
    act_editar: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ds_projeto_list: TDataSource;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    pnlNavBar: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RxDBGrid1: TRxDBGrid;
    sbt_cadastroUsuario: TSpeedButton;
    SpeedButton2: TSpeedButton;
    qry_projeto_list: TZQuery;
    procedure act_cadastroUsuarioExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses
  uCadastroUsuario;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  with qry_projeto_list do
  begin
  Close;
  sql.Clear;
  SQL.Text:='SELECT * FROM projeto';
  Open;
  end;

end;

procedure TfrmPrincipal.act_cadastroUsuarioExecute(Sender: TObject);
begin
  if FrmCadastroUsuario = nil then
  FrmCadastroUsuario:= TFrmCadastroUsuario.Create(self);
  FrmCadastroUsuario._action_ := 'insert';
  FrmCadastroUsuario.ShowModal;
  FrmCadastroUsuario.Free;
  FrmCadastroUsuario:= nil;
end;


end.

