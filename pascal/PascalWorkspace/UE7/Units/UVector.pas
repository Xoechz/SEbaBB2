
UNIT UVector;

INTERFACE

CONST 
  MAX_CAPACITY = 10;

TYPE 
  VectorPtr = ^Vector;
  Vector = OBJECT
    (* Initializes the vector. *)
    CONSTRUCTOR Init;

    (* Destroys the vector. *)
    DESTRUCTOR Done; VIRTUAL;

    (* Adds an element to the end of the vector. *)
    (*  val - The value to be added to the vector. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE Add(val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;

    (* Inserts/sets the value of the element at the specified position, the other elements are moved accordinglly. *)
    (* If the position is greater than the vSize of the vector, the element will be added at the end. *)
    (* If the position is equal to or less than 0, the element will be added at the start. *)
    (* If the position is greater than the capacity of the vector, the operation will fail. *)
    (*  pos - The position of the element to be set. *)
    (*  val - The value to be set. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE InsertElementAt(pos, val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;

    (* Gets the value of the element at the specified position. If the position is greater than the vSize of the vector, the operation will fail. *)
    (*  pos - The position of the element to be retrieved. *)
    (*  val - The value of the element at the specified position. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);

    (* Removes the element at the specified position, the other elements are moved accordinglly. If the position is greater than the vSize of the vector, the operation will fail. *)
    (*  pos - The position of the element to be retrieved. *)
    (*  val - The value of the element at the specified position. *)
    (*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
    PROCEDURE RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN);

    (* Returns the number of elements in the vector. *)
    FUNCTION Size: INTEGER;

    (* Returns the current capacity of the vector. *)
    FUNCTION Capacity: INTEGER;

    (* Clears the vector and sets its capacity to the base value. *)
    PROCEDURE Clear;

    PRIVATE 
      data: ARRAY[1..MAX_CAPACITY] OF INTEGER;
      vSize: INTEGER;
  END;

IMPLEMENTATION

CONSTRUCTOR Vector.Init;
BEGIN (* Init *)
  vSize := 0;
END; (* Init *)

DESTRUCTOR Vector.Done;
BEGIN (* Done *)
  (* Nothing to do here, because the array is static. *)
END; (* Done *)

PROCEDURE Vector.Add(val: INTEGER; VAR ok: BOOLEAN);
BEGIN
  IF (vSize >= MAX_CAPACITY) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      vSize := vSize + 1;
      data[vSize] := val;
    END; (* ELSE *)
END; (* Add *)

PROCEDURE Vector.InsertElementAt(pos, val: INTEGER; VAR ok: BOOLEAN);
VAR 
  i: INTEGER;
BEGIN (* InsertElementAt *)
  IF (pos > MAX_CAPACITY) OR (vSize + 1 > Capacity) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    IF (pos > vSize) THEN
      BEGIN (* ELSE IF *)
        Add(val, ok);
      END (* ELSE IF *)
  ELSE
    BEGIN (* ELSE *)
      IF (pos <= 0) THEN
        BEGIN (* ELSE IF *)
          pos := 1;
        END; (* ELSE IF *)

      vSize := vSize + 1;

      FOR i := vSize DOWNTO pos + 1 DO
        BEGIN (* FOR *)
          data[i] := data[i-1];
        END; (* FOR *)

      data[pos] := val;
      ok := TRUE;
    END; (* ELSE *)
END; (* InsertElementAt *)

PROCEDURE Vector.GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* GetElementAt *)
  IF (pos > vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      val := data[pos];
      ok := TRUE;
    END; (* ELSE *)
END; (* GetElementAt *)

PROCEDURE Vector.RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN);
VAR 
  i: INTEGER;
BEGIN (* RemoveElementAt *)
  IF (pos > vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      vSize := vSize - 1;
      ok := TRUE;

      FOR i := pos TO vSize DO
        BEGIN (* FOR *)
          data[i] := data[i+1];
        END; (* FOR *)
    END; (* ELSE *)
END; (* RemoveElementAt *)

FUNCTION Vector.Size: INTEGER;
BEGIN (* Size *)
  Size := vSize;
END; (* Size *)

FUNCTION Vector.Capacity: INTEGER;
BEGIN (* Capacity *)
  Capacity := MAX_CAPACITY;
END; (* Capacity *)

PROCEDURE Vector.Clear;
BEGIN (* Clear *)
  vSize := 0;
END; (* Clear *)

END.