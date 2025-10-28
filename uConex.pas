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
  ZConnection.Connected:=True;
end;

end.

