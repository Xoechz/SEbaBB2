
UNIT UList;

INTERFACE

TYPE 
  ElementHandler = PROCEDURE (value: INTEGER);
  Node = RECORD
    value: INTEGER;
    next, prev: ^Node;
  END;
  List = OBJECT
    PROCEDURE Init;
    PROCEDURE Done;
    PROCEDURE Append (value: INTEGER; VAR ok: BOOLEAN);
    PROCEDURE RemoveFirst (VAR value: integer;VAR ok: BOOLEAN);
    PROCEDURE Prepend (value: INTEGER; VAR ok: BOOLEAN);
    FUNCTION IsEmpty: BOOLEAN;
    PROCEDURE Print;

    PRIVATE 
      head: ^Node;
  END;


IMPLEMENTATION

PROCEDURE List.Init;
BEGIN
  head := NIL;
END;

PROCEDURE List.Done;
VAR 
  temp: ^Node;
BEGIN
  WHILE head <> NIL DO
    BEGIN
      temp := head;
      head := head^.next;
      DISPOSE(temp);
    END;
END;

PROCEDURE List.Append (value: INTEGER; VAR ok: BOOLEAN);
VAR 
  temp, prev: ^Node;
BEGIN
  temp := head;
  prev := NIL;
  WHILE (temp <> NIL) DO
    BEGIN
      prev := temp;
      temp := temp^.next;
    END;

  NEW(temp);
  IF temp = NIL THEN
    ok := FALSE
  ELSE
    BEGIN
      temp^.value := value;
      temp^.next := NIL;
      temp^.prev := prev;

      IF prev = NIL THEN
        head := temp
      ELSE
        prev^.next := temp;

      ok := TRUE;
    END;
END;

PROCEDURE List.Prepend (value: INTEGER; VAR ok: BOOLEAN);
BEGIN
  IF head = NIL THEN
    BEGIN
      NEW(head);
      IF head = NIL THEN
        ok := FALSE
      ELSE
        BEGIN
          head^.value := value;
          head^.next := NIL;
          head^.prev := NIL;
          ok := TRUE;
        END;
    END
  ELSE
    BEGIN
      NEW(head^.prev);
      IF head^.prev = NIL THEN
        ok := FALSE
      ELSE
        BEGIN
          head^.prev^.value := value;
          head^.prev^.next := head;
          head^.prev^.prev := NIL;
          head := head^.prev;
          ok := TRUE;
        END;
    END;
END;

FUNCTION List.IsEmpty: BOOLEAN;
BEGIN
  IF head = NIL THEN
    IsEmpty := TRUE
  ELSE
    IsEmpty := FALSE;
END;

PROCEDURE List.RemoveFirst (VAR value: integer; VAR ok: BOOLEAN);
VAR 
  temp: ^Node;
BEGIN
  IF head = NIL THEN
    ok := FALSE
  ELSE
    BEGIN
      temp := head;
      value := head^.value;
      head := head^.next;

      DISPOSE(temp);

      IF head <> NIL THEN
        head^.prev := NIL;

      ok := TRUE;
    END;
END;

PROCEDURE List.Print;
VAR 
  temp: ^Node;
BEGIN
  temp := head;
  WHILE temp <> NIL DO
    BEGIN
      Write(temp^.value, ' ');
      temp := temp^.next;
    END;
  WriteLn;
END;

END.