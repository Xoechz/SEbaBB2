
UNIT QADS;

INTERFACE

FUNCTION IsEmpty: BOOLEAN;

PROCEDURE Enqueue(val: INTEGER; VAR ok: BOOLEAN);

PROCEDURE Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);

PROCEDURE ClearQueue;

IMPLEMENTATION

USES
VADS;

FUNCTION IsEmpty: BOOLEAN;
BEGIN (* IsEmpty *)
  IsEmpty := Size() = 0;
END; (* IsEmpty *)

PROCEDURE Enqueue(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Enqueue *)
  Add(val, ok);
END; (* Enqueue *)

PROCEDURE Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Dequeue *)
  IF IsEmpty() THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ElementAt(1, val, ok);
      RemoveElementAt(1, ok);
    END; (* ELSE *)
END; (* Dequeue *)

PROCEDURE ClearQueue;
BEGIN (* ClearQueue *)
  Clear();
END; (* ClearQueue *)

END.