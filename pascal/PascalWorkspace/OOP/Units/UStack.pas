
UNIT UStack;

INTERFACE

USES
UList;

TYPE 
  Stack = OBJECT
    PROCEDURE Init;
    PROCEDURE Done;
    PROCEDURE Push(val: integer; VAR ok: boolean);
    PROCEDURE Pop(VAR val: integer; VAR ok: boolean);
    FUNCTION IsEmpty: boolean;

    PRIVATE 
      elements: List;
  END;

IMPLEMENTATION

PROCEDURE Stack.Init;
BEGIN
  elements.Init();
END;

PROCEDURE Stack.Done;
BEGIN
  elements.Done();
END;

PROCEDURE Stack.Push(val: integer; VAR ok: boolean);
BEGIN
  elements.Prepend(val, ok);
END;

PROCEDURE Stack.Pop(VAR val: integer; VAR ok: boolean);
BEGIN
  elements.RemoveFirst(val, ok);
END;

FUNCTION Stack.IsEmpty: boolean;
BEGIN
  IsEmpty := elements.IsEmpty();
END;

END.