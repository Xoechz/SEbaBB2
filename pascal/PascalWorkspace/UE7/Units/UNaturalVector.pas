
UNIT UNaturalVector;

INTERFACE

USES
UVector;


TYPE 
  NaturalVectorPtr = ^NaturalVector;
  NaturalVector = OBJECT(Vector)
    (* Initializes the vector. *)
    CONSTRUCTOR Init;

    (* Destroys the vector. *)
    DESTRUCTOR Done; VIRTUAL;

    (* Adds an element to the end of the vector. *)
    (* If the value is less than 0, the operation will fail. *)
    (*  val - The value to be added to the vector. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE Add(val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;

    (* Inserts/sets the value of the element at the specified position, the other elements are moved accordinglly. *)
    (* If the value is less than 0, the operation will fail. *)
    (* If the position is greater than the vSize of the vector, the element will be added at the end. *)
    (* If the position is equal to or less than 0, the element will be added at the start. *)
    (* If the position is greater than the capacity of the vector, the operation will fail. *)
    (*  pos - The position of the element to be set. *)
    (*  val - The value to be set. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE InsertElementAt(pos, val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;
  END;

IMPLEMENTATION

CONSTRUCTOR NaturalVector.Init;
BEGIN (* Init *)
  INHERITED Init();
END; (* Init *)

DESTRUCTOR NaturalVector.Done;
BEGIN (* Done *)
  INHERITED Done();
END; (* Done *)

PROCEDURE NaturalVector.Add(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Add *)
  IF (val >= 0) THEN
    BEGIN (* IF *)
      INHERITED Add(val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* Add *)

PROCEDURE NaturalVector.InsertElementAt(pos, val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* InsertElementAt *)
  IF (val >= 0) THEN
    BEGIN (* IF *)
      INHERITED InsertElementAt(pos, val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* InsertElementAt *)

END.