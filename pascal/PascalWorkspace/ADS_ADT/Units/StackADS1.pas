
UNIT StackADS1;

INTERFACE

PROCEDURE Push(value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty: boolean;

IMPLEMENTATION
CONST 
  size = 10;

VAR 
  data: Array[1..size] OF integer;
  currentIndex: 0..size;

PROCEDURE Push(value: integer; VAR ok: boolean);
BEGIN
  ok := currentIndex < size;
  IF (ok) THEN
    BEGIN
      currentIndex := currentIndex + 1;
      data[currentIndex] := value;
    END;
END;

PROCEDURE Pop(VAR value: integer; VAR ok: boolean);
BEGIN
  ok := NOT IsEmpty;
  IF (ok) THEN
    BEGIN
      value := data[currentIndex];
      currentIndex := currentIndex - 1;
    END;
END;

FUNCTION IsEmpty: boolean;
BEGIN
  IsEmpty := currentIndex = 0;
END;

BEGIN
  currentIndex := 0;
END.