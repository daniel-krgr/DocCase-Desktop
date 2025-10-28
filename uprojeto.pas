unit uProjeto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, RichMemo, SynHighlighterTeX;

type

  { TfrmProjeto }

  TfrmProjeto = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ColorButton1: TColorButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    RichMemo1: TRichMemo;
    sBtNegrito: TSpeedButton;
    sBtCorFonte: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    sBtTamanhoFonte: TSpeedButton;
    sBtFonte: TSpeedButton;
    procedure BitBtn2Click(Sender: TObject);
    procedure sBtFonteClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sBtCorFonteClick(Sender: TObject);
    procedure sBtTamanhoFonteClick(Sender: TObject);
  private

  public

  end;

var
  frmProjeto: TfrmProjeto;

implementation

{$R *.lfm}

{ TfrmProjeto }

{
  Funções para formatação do texto
}
// Toggle Negrito
procedure ToggleBold(Rich: TRichMemo);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  // pega atributos no ponto inicial da seleção/caret
  Rich.GetTextAttributes(iStart, fp);
  // alterna o fsBold
  if fsBold in fp.Style then
    fp.Style := fp.Style - [fsBold]
  else
    fp.Style := fp.Style + [fsBold];
  // aplica para a seleção atual
  Rich.SetTextAttributes(iStart, iLen, fp);
end;

// Toggle Itálico
procedure ToggleItalic(Rich: TRichMemo);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  Rich.GetTextAttributes(iStart, fp);
  if fsItalic in fp.Style then
    fp.Style := fp.Style - [fsItalic]
  else
    fp.Style := fp.Style + [fsItalic];
  Rich.SetTextAttributes(iStart, iLen, fp);
end;

// Toggle Sublinhado
procedure ToggleUnderline(Rich: TRichMemo);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  Rich.GetTextAttributes(iStart, fp);
  if fsUnderline in fp.Style then
    fp.Style := fp.Style - [fsUnderline]
  else
    fp.Style := fp.Style + [fsUnderline];
  Rich.SetTextAttributes(iStart, iLen, fp);
end;

// Mudar cor da fonte
procedure SetFontColor(Rich: TRichMemo; AColor: TColor);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  Rich.GetTextAttributes(iStart, fp);
  fp.Color := AColor;
  Rich.SetTextAttributes(iStart, iLen, fp);
end;

// Mudar nome da fonte
procedure SetFontName(Rich: TRichMemo; const AName: string);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  Rich.GetTextAttributes(iStart, fp);
  fp.Name := AName; // field costuma ser 'Name'
  Rich.SetTextAttributes(iStart, iLen, fp);
end;

// Mudar tamanho da fonte
procedure SetFontSize(Rich: TRichMemo; ASize: Integer);
var
  fp: TFontParams;
  iStart, iLen: Integer;
begin
  iStart := Rich.SelStart;
  iLen := Rich.SelLength;
  Rich.GetTextAttributes(iStart, fp);
  fp.Size := ASize;
  Rich.SetTextAttributes(iStart, iLen, fp);
end;
{
 Fim da funções para formatação do texto
}

procedure TfrmProjeto.BitBtn2Click(Sender: TObject);
begin
  Close;
  frmProjeto.Free;
  frmProjeto:= nil;
end;

procedure TfrmProjeto.sBtFonteClick(Sender: TObject);
var
  fp: TFontParams;
begin
  // Pega atributos da seleção atual
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, fp);

  // Aplica os atributos atuais no FontDialog (para abrir já com a fonte em uso)
  FontDialog1.Font.Name := fp.Name;
  FontDialog1.Font.Size := fp.Size;
  FontDialog1.Font.Style := fp.Style;
  FontDialog1.Font.Color := fp.Color;

  // Abre o diálogo
  if FontDialog1.Execute then
  begin
    // Atualiza os atributos
    fp.Name := FontDialog1.Font.Name;
    fp.Size := FontDialog1.Font.Size;
    fp.Style := FontDialog1.Font.Style;
    fp.Color := FontDialog1.Font.Color;

    // Aplica na seleção
    RichMemo1.SetTextAttributes(RichMemo1.SelStart, RichMemo1.SelLength, fp);
  end;
end;

procedure TfrmProjeto.SpeedButton1Click(Sender: TObject);
begin
  ToggleBold(RichMemo1);
end;

procedure TfrmProjeto.sBtCorFonteClick(Sender: TObject);
begin
 SetFontColor(RichMemo1,ColorButton1.ButtonColor)
end;

procedure TfrmProjeto.sBtTamanhoFonteClick(Sender: TObject);
begin

end;

end.

