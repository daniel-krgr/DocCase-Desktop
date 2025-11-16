unit uSeguranca;

{$mode ObjFPC}{$H+}

interface
 uses
  Classes, SysUtils,  md5, DB;

function GeraMD5(const Texto: string): string;
function ResumirCampoMemo(AField: TField; ATamanho: Integer = 300): string;

implementation

function GeraMD5(const Texto: string): string;
begin
  Result := MD5Print(MD5String(Texto));
end;

function ResumirCampoMemo(AField: TField; ATamanho: Integer): string;
var
  s: string;
begin
  s := AField.AsString;
  if Length(s) > ATamanho then
    Result := Copy(s, 1, ATamanho) + '...'
  else
    Result := s;
end;

end.


