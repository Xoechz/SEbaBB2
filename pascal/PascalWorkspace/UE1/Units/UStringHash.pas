
UNIT UStringHash;

INTERFACE

FUNCTION ModPower(base, exponent, modulus: Longword): Longword;

FUNCTION GetHashCode(word:STRING; modulus: Longword): Longword;

IMPLEMENTATION

FUNCTION ModPower(base, exponent, modulus: Longword): Longword;
VAR 
  result: Longword;
BEGIN
  result := 1;
  WHILE exponent > 0 DO
    BEGIN
      result := (result * base) MOD modulus;
      exponent := exponent - 1;
    END;
  ModPower := result;
END;

FUNCTION GetHashCode(word:STRING; modulus: Longword): Longword;
VAR i, result: Longword;
BEGIN
  result := 0;
  FOR i := 1 TO Length(word) DO
    BEGIN
      result := (result + ((ord(word[i])* ModPower(31, i, modulus)) MOD modulus)) MOD modulus;
    END;
  GetHashCode := result;
END;

END.