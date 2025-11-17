unit uConex;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TDM = class(TDataModule)
    ZConnection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ZConnection.Connected:=False;
  ZConnection.ClientCodepage:= 'utf8';

  with ZConnection.Properties do
  begin
   Values['codepage']:= 'utf8';
   Values['character_set_client']:= 'utf8';
   Values['character_set_connection']:= 'utf8';
   Values['character_set_results']:= 'utf8';
  end;

  ZConnection.Connected:=True;
  ZConnection.ExecuteDirect('SET NAMES utf8');
end;

end.

