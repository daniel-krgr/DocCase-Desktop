unit uSeguranca;

{$mode ObjFPC}{$H+}

interface
 uses
  Classes, SysUtils,  md5, DB;

function GeraMD5(const Texto: string): string;
function ResumirCampoMemo(AField: TField; ATamanho: Integer = 300): string;

procedure FiltraSomenteLetras(var Key: Char; AceitaEspaco: Boolean = True);
procedure FiltraSomenteNumeros(var Key: Char; AceitaDecimal: Boolean = False);

function TamanhoEntre(const S: string; Min, Max: Integer): Boolean;

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

procedure FiltraSomenteLetras(var Key: Char; AceitaEspaco: Boolean);
begin
  if Key in [#8, #13] then
    Exit;

  if AceitaEspaco and (Key = ' ') then
    Exit;

  if not (Key in ['A'..'Z', 'a'..'z']) then
    Key := #0;
end;

procedure FiltraSomenteNumeros(var Key: Char; AceitaDecimal: Boolean);
begin
  if Key in [#8, #13] then
    Exit;

  if Key in ['0'..'9'] then
    Exit;

  if AceitaDecimal and (Key in [',', '.']) then
    Exit;

  Key := #0;
end;

function TamanhoEntre(const S: string; Min, Max: Integer): Boolean;
var
  Tam: Integer;
begin
  Tam := Length(Trim(S));
  Result := (Tam >= Min) and (Tam <= Max);
end;

end.


