unit uSeguranca;

{$mode ObjFPC}{$H+}

interface

function GeraMD5(const Texto: string): string;

implementation

uses
  Classes, SysUtils,  md5;

function GeraMD5(const Texto: string): string;
begin
  Result := MD5Print(MD5String(Texto));
end;

end.


