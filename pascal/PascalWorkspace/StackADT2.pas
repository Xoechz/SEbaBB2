
UNIT StackADT2;

INTERFACE

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    data: integer;
    next: NodePtr;
  END;
  Stack = RECORD
    head: NodePtr;
  END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty(VAR s: Stack): boolean;
PROCEDURE InitStack(VAR s: Stack);
PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION

PROCEDURE InitStack(VAR s: Stack);
BEGIN
  s.head := NIL;
END;

PROCEDURE DisposeStack(VAR s: Stack);
VAR 
  next: NodePtr;
BEGIN
  WHILE s.head <> NIL DO
    BEGIN
      next := s.head^.next;
      dispose(s.head);
      s.head := next;
    END;
END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
VAR 
  newNode: NodePtr;
BEGIN
  new(newNode);
  ok := newNode <> NIL;
  IF ok THEN
    BEGIN
      newNode^.data := value;
      newNode^.next := s.head;
      s.head := newNode;
    END;
END;

PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
VAR 
  next: NodePtr;
BEGIN
  ok := NOT IsEmpty(s);
  IF ok THEN
    BEGIN
      value := s.head^.data;
      next := s.head^.next;
      dispose(s.head);
      s.head := next;
    END;
END;

FUNCTION IsEmpty(VAR s: Stack): boolean;
BEGIN
  IsEmpty := s.head = NIL;
END;

END.