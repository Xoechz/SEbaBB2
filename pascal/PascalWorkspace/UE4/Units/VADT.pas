
UNIT VADT;

INTERFACE

TYPE 
  Vector = Pointer;

(* Initializes the vector. *)
(*  v - The vector to be initialized. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE InitVector(VAR v: Vector; VAR ok: BOOLEAN);

(* Disposes the vector. *)
(*  v - The vector to be disposed. *)
PROCEDURE DisposeVector(VAR v: Vector);

(* Adds an element to the end of the vector. If the vector is full, it will be resized. *)
(*  v - The vector to which the element will be added. *)
(*  val - The value to be added to the vector. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE Add(VAR v: Vector; val: INTEGER; VAR ok: BOOLEAN);

(* Sets the value of the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  v - The vector in which the element will be set. *)
(*  pos - The position of the element to be set. *)
(*  val - The value to be set. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE SetElementAt(VAR v: Vector; pos, val: INTEGER; VAR ok: BOOLEAN);

(* Gets the value of the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  v - The vector from which the element will be retrieved. *)
(*  pos - The position of the element to be retrieved. *)
(*  val - The value of the element at the specified position. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE ElementAt(VAR v: Vector; pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);

(* Removes the element at the specified position. If the position is greater than the size of the vector, the operation will fail. *)
(*  v - The vector from which the element will be removed. *)
(*  pos - The position of the element to be removed. *)
(*  ok - A boolean value that will be set to TRUE if the operation was successful, FALSE otherwise. *)
PROCEDURE RemoveElementAt(VAR v: Vector; pos: INTEGER; VAR ok: BOOLEAN);

(* Returns the number of elements in the vector. *)
(*  v - The vector whose size will be returned. *)
FUNCTION Size(VAR v: Vector): INTEGER;

(* Returns the current capacity of the vector. *)
(*  v - The vector whose capacity will be returned. *)
FUNCTION Capacity(VAR v: Vector): INTEGER;

(* Clears the vector and sets its capacity to the base value. *)
(*  v - The vector to be cleared. *)
PROCEDURE Clear(VAR v: Vector);

IMPLEMENTATION

CONST 
  BASE_CAPACITY = 10;

TYPE 
  DynamicArray = ARRAY[1..1] OF INTEGER;
  State = RECORD
    vSize, vCapacity: INTEGER;
    dynArray: ^DynamicArray;
  END;
  StatePtr = ^State;

PROCEDURE InitVector(VAR v: Vector; VAR ok: BOOLEAN);
VAR 
  state: StatePtr;
BEGIN (* InitVector *)
  state := new(StatePtr);

  IF (state = NIL) THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      state^.vSize := 0;
      state^.vCapacity := BASE_CAPACITY;
      GetMem(state^.dynArray, state^.vCapacity * sizeof(INTEGER));
      v := state;
      ok := TRUE;
    END (* ELSE *)
END; (* InitVector *)

PROCEDURE DisposeVector(VAR v: Vector);
VAR 
  state: StatePtr;
BEGIN (* DisposeVector *)
  state := StatePtr(v);
  FreeMem(state^.dynArray, state^.vCapacity * sizeof(INTEGER));
  Dispose(state);
END; (* DisposeVector *)

PROCEDURE ResizeVector(state: StatePtr; VAR ok: BOOLEAN);
VAR 
  i, oldCapacity: INTEGER;
  newArray: ^DynamicArray;
BEGIN (* ResizeVector *)
  oldCapacity := state^.vCapacity;
  state^.vCapacity := oldCapacity * 2;
  GetMem(newArray, state^.vCapacity * sizeof(INTEGER));

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
          newArray^[i] := state^.dynArray^[i];
          {$R+}
        END; (* FOR *)

      FreeMem(state^.dynArray, oldCapacity * sizeof(INTEGER));
      state^.dynArray := newArray;
    END; (* ELSE *)
END; (* ResizeVector *)

PROCEDURE Add(VAR v: Vector; val: INTEGER; VAR ok: BOOLEAN);
VAR 
  state: StatePtr;
BEGIN (* Add *)
  state := StatePtr(v);
  state^.vSize := state^.vSize + 1;
  ok := TRUE;

  IF (state^.vSize > state^.vCapacity) THEN
    BEGIN (* IF *)
      ResizeVector(state, ok);
    END; (* IF *)

  IF (ok) THEN
    BEGIN (* IF *)
      {$R-}
      state^.dynArray^[state^.vSize] := val;
      {$R+}
    END; (* IF *)
END; (* Add *)

PROCEDURE SetElementAt(VAR v: Vector; pos, val: INTEGER; VAR ok: BOOLEAN);
VAR 
  state: StatePtr;
BEGIN (* SetElementAt *)
  state := StatePtr(v);

  IF (pos > state^.vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      {$R-}
      state^.dynArray^[pos] := val;
      {$R+}
    END; (* ELSE *)
END; (* SetElementAt *)

PROCEDURE ElementAt(VAR v: Vector; pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
VAR 
  state: StatePtr;
BEGIN (* ElementAt *)
  state := StatePtr(v);

  IF (pos > state^.vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      {$R-}
      val := state^.dynArray^[pos];
      {$R+}
    END; (* ELSE *)
END; (* ElementAt *)

PROCEDURE RemoveElementAt(VAR v: Vector; pos: INTEGER; VAR ok: BOOLEAN);
VAR 
  i: INTEGER;
  state: StatePtr;
BEGIN (* RemoveElementAt *)
  state := StatePtr(v);

  IF (pos > state^.vSize) OR (pos < 1) THEN
    BEGIN (* IF *)
      ok := FALSE
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := TRUE;
      state^.vSize := state^.vSize - 1;

      FOR i := pos TO state^.vSize DO
        BEGIN (* FOR *)
          {$R-}
          state^.dynArray^[i] := state^.dynArray^[i+1];
          {$R+}
        END; (* FOR *)
    END; (* ELSE *)
END; (* RemoveElementAt *)

FUNCTION Size(VAR v: Vector): INTEGER;
VAR 
  state: StatePtr;
BEGIN (* Size *)
  state := StatePtr(v);
  Size := state^.vSize;
END; (* Size *)

FUNCTION Capacity(VAR v: Vector): INTEGER;
VAR 
  state: StatePtr;
BEGIN (* Capacity *)
  state := StatePtr(v);
  Capacity := state^.vCapacity;
END; (* Capacity *)

PROCEDURE Clear(VAR v: Vector);
VAR 
  state: StatePtr;
BEGIN (* Clear *)
  state := StatePtr(v);
  state^.vSize := 0;

  IF (state^.vCapacity <> BASE_CAPACITY) THEN
    BEGIN
      FreeMem(state^.dynArray, state^.vCapacity * sizeof(INTEGER));
      state^.vCapacity := BASE_CAPACITY;
      GetMem(state^.dynArray, state^.vCapacity * sizeof(INTEGER));
    END;
END; (* Clear *)

END.