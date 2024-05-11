
UNIT StackADS2;

INTERFACE

PROCEDURE Push(value: integer; VAR ok: boolean);
PROCEDURE Pop(VAR value: integer; VAR ok: boolean);
FUNCTION IsEmpty: boolean;

IMPLEMENTATION

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    data: integer;
    next: NodePtr;
  END;

VAR 
  head: NodePtr;

PROCEDURE Push(value: integer; VAR ok: boolean);
VAR 
  newNode: NodePtr;
BEGIN
  new(newNode);
  ok := newNode <> NIL;
  IF ok THEN
    BEGIN
      newNode^.data := value;
      newNode^.next := head;
      head := newNode;
    END;
END;

PROCEDURE Pop(VAR value: integer; VAR ok: boolean);
VAR 
  next: NodePtr;
BEGIN
  ok := NOT IsEmpty;
  IF ok THEN
    BEGIN
      value := head^.data;
      next := head^.next;
      dispose(head);
      head := next;
    END;
END;

FUNCTION IsEmpty: boolean;
BEGIN
  IsEmpty := head = NIL;
END;

BEGIN
  head := NIL;
END.