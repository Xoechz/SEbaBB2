
UNIT UPrimeVector;

INTERFACE

USES
UVector;


TYPE 
  PrimeVectorPtr = ^PrimeVector;
  PrimeVector = OBJECT(Vector)
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
  END;

IMPLEMENTATION

CONSTRUCTOR PrimeVector.Init;
BEGIN (* Init *)
  INHERITED Init();
END; (* Init *)

DESTRUCTOR PrimeVector.Done;
BEGIN (* Done *)
  INHERITED Done();
END; (* Done *)

FUNCTION IsPrime(n: INTEGER): BOOLEAN;
VAR 
  i: INTEGER;
  result: BOOLEAN;
BEGIN (* IsPrime *)
  result := TRUE;
  n := Abs(n);

  IF (n <= 1) THEN
    BEGIN (* IF *)
      result := FALSE;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      i := 2;
      WHILE (i <= Round(Sqrt(n))) AND (result) DO
        BEGIN (* WHILE *)
          IF (n MOD i = 0) THEN
            BEGIN (* IF *)
              result := FALSE;
            END; (* IF *)
          i := i + 1;
        END; (* WHILE *)
    END; (* ELSE *)

  IsPrime := result;
END; (* IsPrime *)

PROCEDURE PrimeVector.Add(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Add *)
  IF (IsPrime(val)) THEN
    BEGIN (* IF *)
      INHERITED Add(val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* Add *)

PROCEDURE PrimeVector.InsertElementAt(pos, val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* InsertElementAt *)
  IF (IsPrime(val)) THEN
    BEGIN (* IF *)
      INHERITED InsertElementAt(pos, val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* InsertElementAt *)

END.