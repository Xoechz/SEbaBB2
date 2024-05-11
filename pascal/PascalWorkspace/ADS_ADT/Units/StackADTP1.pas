
UNIT StackADTP1;

INTERFACE

CONST 
  size = 10;

TYPE 
  Stack = Pointer;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty(VAR s: Stack): boolean;
PROCEDURE InitStack(VAR s: Stack);
PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION

TYPE 
  State = RECORD
    data: Array[1..size] OF integer;
    currentIndex: 0..size;
  END;
  StatePtr = ^State;

PROCEDURE InitStack(VAR s: Stack);
VAR 
  sp: StatePtr;
BEGIN
  New(sp);
  IF (sp <> NIL) THEN
    BEGIN
      sp^.currentIndex := 0;
    END;
  s := sp;
END;

PROCEDURE DisposeStack(VAR s: Stack);
BEGIN
  Dispose(StatePtr(s));
END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
VAR 
  sp: StatePtr;
BEGIN
  sp := StatePtr(s);
  ok := sp^.currentIndex < size;
  IF (ok) THEN
    BEGIN
      sp^.currentIndex := sp^.currentIndex + 1;
      sp^.data[sp^.currentIndex] := value;
    END;
END;

PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
VAR 
  sp: StatePtr;
BEGIN
  sp := StatePtr(s);
  ok := sp^.currentIndex <> 0;
  IF (ok) THEN
    BEGIN
      value := sp^.data[sp^.currentIndex];
      sp^.currentIndex := sp^.currentIndex - 1;
    END;
END;

FUNCTION IsEmpty(VAR s: Stack): boolean;
VAR 
  sp: StatePtr;
BEGIN
  sp := StatePtr(s);
  IsEmpty := sp^.currentIndex = 0;
END;

END.