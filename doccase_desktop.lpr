program doccase_desktop;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, uPrincipal, rxnew, uConex, zcomponent,
  uCadastroUsuario, ucasodeuso, udashboard, ufluxo, ulistaator, ulistacasouso,
  ulistafluxo, ulistaprojetos, ulistatime, ulistausuarios, uProjeto, utime,
  useguranca, ulogin, uator, uListaVersoesCasoUso, ulistaregranegocios, 
uregranegocio;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='DocCase';
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  frmPrincipal.Hide;

  with TFrmLogin.Create(nil) do
  try
    if ShowModal = 1 then
      frmPrincipal.Show
    else
      Halt(0);
  finally
    Free;

  end;
  Application.Run;

end.

