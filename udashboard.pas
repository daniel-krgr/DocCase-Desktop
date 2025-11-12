unit udashboard;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  NiceChart, ZDataset, TAGraph, TASeries, TALegend, TATools, TASources, TAChartUtils;

type

  { TFrmDashboard }

  TFrmDashboard = class(TForm)
    ChartCasosPorProjeto: TChart;
    ChartFluxosPorCaso: TChart;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblAtores: TLabel;
    Label2: TLabel;
    lblProjetos: TLabel;
    Label4: TLabel;
    lblCasouso: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblFluxos: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    qryTotalProjetos: TZQuery;
    qryTotalCasos: TZQuery;
    qryTotalAtores: TZQuery;
    qryTotalFluxos: TZQuery;
    qryFluxoPorCaso: TZQuery;
    qryCasosPorProjeto: TZQuery;
    procedure FormShow(Sender: TObject);
  private
   procedure AtualizarTotais;
   procedure AtualizarGraficoCasosPorProjeto;
   procedure AtualizarGraficoFluxosPorCaso;
  public

  end;

var
  FrmDashboard: TFrmDashboard;

implementation

{$R *.lfm}

{ TFrmDashboard }

procedure TFrmDashboard.FormShow(Sender: TObject);
begin
   // Atualiza os painéis de totais
  AtualizarTotais;

  // Atualiza os gráficos
  AtualizarGraficoCasosPorProjeto;
  AtualizarGraficoFluxosPorCaso;
end;

procedure TFrmDashboard.AtualizarTotais;
begin
  qryTotalProjetos.Close;
  qryTotalProjetos.SQL.Text := 'SELECT COUNT(*) AS total FROM projeto';
  qryTotalProjetos.Open;
  lblProjetos.Caption := qryTotalProjetos.FieldByName('total').AsString;

  qryTotalCasos.Close;
  qryTotalCasos.SQL.Text := 'SELECT COUNT(*) AS total FROM caso_uso';
  qryTotalCasos.Open;
  lblCasouso.Caption := qryTotalCasos.FieldByName('total').AsString;

  qryTotalAtores.Close;
  qryTotalAtores.SQL.Text := 'SELECT COUNT(*) AS total FROM atores';
  qryTotalAtores.Open;
  lblAtores.Caption := qryTotalAtores.FieldByName('total').AsString;

  qryTotalFluxos.Close;
  qryTotalFluxos.SQL.Text := 'SELECT COUNT(*) AS total FROM fluxo';
  qryTotalFluxos.Open;
  lblFluxos.Caption := qryTotalFluxos.FieldByName('total').AsString;
end;

procedure TFrmDashboard.AtualizarGraficoCasosPorProjeto;
var
  Bar: TBarSeries;
  i: Integer;
begin
  qryCasosPorProjeto.Close;
  qryCasosPorProjeto.SQL.Text :=
    'SELECT p.nome AS projeto, COUNT(c.idcaso_uso) AS total ' +
    'FROM projeto p ' +
    'LEFT JOIN caso_uso c ON c.projeto_idprojeto = p.idprojeto ' +
    'GROUP BY p.nome ' +
    'ORDER BY total DESC ' +
    'LIMIT 5';  // 🔹 mostra só os 5 maiores
  qryCasosPorProjeto.Open;

  ChartCasosPorProjeto.ClearSeries;

  Bar := TBarSeries.Create(Self);
  Bar.Title := 'Casos de Uso por Projeto';
  Bar.BarWidthPercent := 40;
  Bar.SeriesColor := RGBToColor(79,129,189);
  Bar.Marks.Visible := False;

  i := 0;
  while not qryCasosPorProjeto.EOF do
  begin
    Inc(i);
    Bar.AddXY(
      i,
      qryCasosPorProjeto.FieldByName('total').AsFloat,
      qryCasosPorProjeto.FieldByName('projeto').AsString
    );
    qryCasosPorProjeto.Next;
  end;

  ChartCasosPorProjeto.AddSeries(Bar);

  with ChartCasosPorProjeto do
  begin
    Color := clWhite;
    Legend.Visible := False;

    BottomAxis.Marks.Source := Bar.ListSource;
    BottomAxis.Marks.Style  := smsLabel;
    BottomAxis.Title.Caption := 'Projetos (Top 5)';
    BottomAxis.Grid.Visible := False;

    LeftAxis.Title.Caption := 'Casos de Uso';
    LeftAxis.Grid.Color := RGBToColor(210,210,210);
    LeftAxis.Grid.Style := psDot;
  end;
end;

procedure TFrmDashboard.AtualizarGraficoFluxosPorCaso;
var
  Bar: TBarSeries;
  i: Integer;
begin
  qryFluxoPorCaso.Close;
  qryFluxoPorCaso.SQL.Text :=
    'SELECT c.nome AS caso_uso, COUNT(f.idfluxo) AS total ' +
    'FROM caso_uso c ' +
    'LEFT JOIN fluxo f ON f.caso_uso_idcaso_uso = c.idcaso_uso ' +
    'GROUP BY c.nome ' +
    'ORDER BY total DESC ' +
    'LIMIT 5';  // 🔹 mostra só os 5 maiores
  qryFluxoPorCaso.Open;

  ChartFluxosPorCaso.ClearSeries;

  Bar := TBarSeries.Create(Self);
  Bar.Title := 'Fluxos por Caso de Uso';
  Bar.BarWidthPercent := 40;
  Bar.SeriesColor := RGBToColor(79,129,189);
  Bar.Marks.Visible := False;

  i := 0;
  while not qryFluxoPorCaso.EOF do
  begin
    Inc(i);
    Bar.AddXY(
      i,
      qryFluxoPorCaso.FieldByName('total').AsFloat,
      qryFluxoPorCaso.FieldByName('caso_uso').AsString
    );
    qryFluxoPorCaso.Next;
  end;

  ChartFluxosPorCaso.AddSeries(Bar);

  with ChartFluxosPorCaso do
  begin
    Color := clWhite;
    Legend.Visible := False;

    BottomAxis.Marks.Source := Bar.ListSource;
    BottomAxis.Marks.Style  := smsLabel;
    BottomAxis.Title.Caption := 'Casos de Uso (Top 5)';
    BottomAxis.Grid.Visible := False;

    LeftAxis.Title.Caption := 'Fluxos';
    LeftAxis.Grid.Color := RGBToColor(210,210,210);
    LeftAxis.Grid.Style := psDot;
  end;
end;

end.

