
UNIT StackADTP2;

INTERFACE

TYPE 
  Stack = Pointer;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty(VAR s: Stack): boolean;
PROCEDURE InitStack(VAR s: Stack);
PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    data: integer;
    next: NodePtr;
  END;

PROCEDURE InitStack(VAR s: Stack);
BEGIN
  s := NIL;
END;

PROCEDURE DisposeStack(VAR s: Stack);
VAR 
  n, next: NodePtr;
BEGIN
  n := NodePtr(s);
  WHILE n <> NIL DO
    BEGIN
      next := n^.next;
      dispose(n);
      n := next;
    END;
  s := NIL;
END;

PROCEDURE Push(VAR s: Stack; value: integer; VAR ok: boolean);
VAR 
  n, newNode: NodePtr;
BEGIN
  n := NodePtr(s);
  new(newNode);
  ok := newNode <> NIL;
  IF ok THEN
    BEGIN
      newNode^.data := value;
      newNode^.next := n;
      n := newNode;
    END;
  s := n;
END;

PROCEDURE Pop(VAR s: Stack; VAR value: integer; VAR ok: boolean);
VAR 
  n, next: NodePtr;
BEGIN
  n := NodePtr(s);
  ok := n <> NIL;
  IF ok THEN
    BEGIN
      value := n^.data;
      next := n^.next;
      dispose(n);
      n := next;
    END;
  s := n;
END;

FUNCTION IsEmpty(VAR s: Stack): boolean;
VAR 
  n: NodePtr;
BEGIN
  n := NodePtr(s);
  IsEmpty := n = NIL;
END;

END.