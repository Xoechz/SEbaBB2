
UNIT UCardinalStack;

INTERFACE

USES
UVector;

TYPE 
  CardinalStack = OBJECT

    (* Initializes the Stack *)
    CONSTRUCTOR Init;

    (* Destroys the Stack *)
    DESTRUCTOR Done;

    (* Pushes a value onto the Stack *)
    (*  val - The value to be pushed to the stack *)
    (*  ok - A boolean value that is set to TRUE if the push was successful, FALSE otherwise *)
    PROCEDURE Push(val: INTEGER; VAR ok: BOOLEAN);

    (* Pops a value from the Stack *)
    (*  val - The value that was popped from the stack *)
    (*  ok - A boolean value that is set to TRUE if the pop was successful, FALSE otherwise *)
    PROCEDURE Pop(VAR val: INTEGER; VAR ok: BOOLEAN);

    (* Checks if the Stack is empty *)
    FUNCTION IsEmpty: BOOLEAN;

    PRIVATE 
      data: Vector;

  END;

IMPLEMENTATION

CONSTRUCTOR CardinalStack.Init;
BEGIN (* Init *)
  data.Init();
END; (* Init *)

DESTRUCTOR CardinalStack.Done;
BEGIN (* Done *)
  data.Done();
END; (* Done *)

PROCEDURE CardinalStack.Push(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Push *)
  IF (val >= 0) THEN
    BEGIN (* IF *)
      data.InsertElementAt(0, val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* Push *)

PROCEDURE CardinalStack.Pop(VAR val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Pop *)
  data.GetElementAt(1, val, ok);

  IF ok THEN
    BEGIN (* IF *)
      data.RemoveElementAt(1, ok);
    END (* IF *)
END; (* Pop *)

FUNCTION CardinalStack.IsEmpty: BOOLEAN;
BEGIN (* IsEmpty *)
  IsEmpty := data.Size() = 0;
END; (* IsEmpty *)

END.