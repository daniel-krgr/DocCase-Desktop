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
  useguranca, ulogin;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

