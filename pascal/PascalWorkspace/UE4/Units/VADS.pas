
UNIT VADS;

INTERFACE

(* Adds an element to the end of the vector. If the vector is full, it will be resized. *)
(*  val - The value to be added to the vector. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE Add(val: INTEGER; VAR ok: BOOLEAN);

(* Sets the value of the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  pos - The position of the element to be set. *)
(*  val - The value to be set. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE SetElementAt(pos, val: INTEGER; VAR ok: BOOLEAN);

(* Gets the value of the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  pos - The position of the element to be retrieved. *)
(*  val - The value of the element at the specified position. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE ElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);

(* Removes the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  pos - The position of the element to be removed. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN);

(* Returns the number of elements in the vector. *)
FUNCTION Size: INTEGER;

(* Returns the current capacity of the vector. *)
FUNCTION Capacity: INTEGER;

(* Clears the vector and sets its capacity to the base value. *)
PROCEDURE Clear;

IMPLEMENTATION

CONST 
  BASE_CAPACITY = 10;

TYPE 
  DynamicArray = ARRAY[1..1] OF INTEGER;

VAR 
  vSize, vCapacity: INTEGER;
  dynArray: ^DynamicArray;

PROCEDURE ResizeVector(VAR ok: BOOLEAN);
VAR 
  i, oldCapacity: INTEGER;
  newArray: ^DynamicArray;
BEGIN (* ResizeVector *)
  oldCapacity := vCapacity;
  vCapacity := oldCapacity * 2;
  GetMem(newArray, vCapacity * sizeof(INTEGER));

  IF (newArray = NIL) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;

      FOR i := 1 TO oldCapacity DO
        BEGIN (* FOR *)
          {$R-}
          newArray^[i] := dynArray^[i];
          {$R+}
        END; (* FOR *)

      FreeMem(dynArray, oldCapacity * sizeof(INTEGER));
      dynArray := newArray;
    END; (* ELSE *)
END; (* ResizeVector *)

PROCEDURE Add(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Add *)
  vSize := vSize + 1;
  ok := TRUE;

  IF (vSize > vCapacity) THEN
    BEGIN (* IF *)
      ResizeVector(ok);
    END; (* IF *)

  IF (ok) THEN
    BEGIN (* IF *)
      {$R-}
      dynArray^[vSize] := val;
      {$R+}
    END; (* IF *)
END; (* Add *)

PROCEDURE SetElementAt(pos, val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* SetElementAt *)
  IF (pos > vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      {$R-}
      dynArray^[pos] := val;
      {$R+}
    END; (* ELSE *)
END; (* SetElementAt *)

PROCEDURE ElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* ElementAt *)
  IF (pos > vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      {$R-}
      val := dynArray^[pos];
      {$R+}
    END; (* ELSE *)
END; (* ElementAt *)

PROCEDURE RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN);
VAR 
  i: INTEGER;
BEGIN (* RemoveElementAt *)
  IF (pos > vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      vSize := vSize - 1;

      FOR i := pos TO vSize DO
        BEGIN (* FOR *)
          {$R-}
          dynArray^[i] := dynArray^[i+1];
          {$R+}
        END; (* FOR *)
    END; (* ELSE *)
END; (* RemoveElementAt *)

FUNCTION Size: INTEGER;
BEGIN (* Size *)
  Size := vSize;
END; (* Size *)

FUNCTION Capacity: INTEGER;
BEGIN (* Capacity *)
  Capacity := vCapacity;
END; (* Capacity *)

PROCEDURE Clear;
BEGIN (* Clear *)
  IF (vCapacity <> BASE_CAPACITY) THEN
    BEGIN
      FreeMem(dynArray, vCapacity * sizeof(INTEGER));
      vCapacity := BASE_CAPACITY;
      GetMem(dynArray, vCapacity * sizeof(INTEGER));
    END;

  vSize := 0;
END; (* Clear *)

BEGIN (* VADS *)
  vSize := 0;
  vCapacity := BASE_CAPACITY;
  GetMem(dynArray, vCapacity * sizeof(INTEGER));
END. (* VADS *)