
UNIT StackADT1;

INTERFACE

CONST 
  size = 10;

TYPE 
  Stack = RECORD
    data: Array[1..size] OF integer;
    currentIndex: 0..size;
  END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty(VAR s: Stack): boolean;
PROCEDURE InitStack(VAR s: Stack);
PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION

PROCEDURE InitStack(VAR s: Stack);
BEGIN
  s.currentIndex := 0;
END;

PROCEDURE DisposeStack(VAR s: Stack);
BEGIN
END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
BEGIN
  ok := s.currentIndex < size;
  IF (ok) THEN
    BEGIN
      s.currentIndex := s.currentIndex + 1;
      s.data[s.currentIndex] := value;
    END;
END;

PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
BEGIN
  ok := NOT IsEmpty(s);
  IF (ok) THEN
    BEGIN
      value := s.data[s.currentIndex];
      s.currentIndex := s.currentIndex - 1;
    END;
END;

FUNCTION IsEmpty(VAR s: Stack): boolean;
BEGIN
  IsEmpty := s.currentIndex = 0;
END;

END.