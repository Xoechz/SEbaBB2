
UNIT UEvenQueue;

INTERFACE

USES
UVector;

TYPE 
  EvenQueue = OBJECT

    (* Initializes the Queue *)
    CONSTRUCTOR Init;

    (* Destroys the Queue *)
    DESTRUCTOR Done;

    (* Enqueues a value into the Queue *)
    (*  val - The value to be euqueued to the queue *)
    (*  ok - A boolean value that is set to TRUE if the enqueue was successful, FALSE otherwise *)
    PROCEDURE Enqueue(val: INTEGER; VAR ok: BOOLEAN);

    (* Dequeues a value from the Queue *)
    (*  val - The value that was dequeued from the queue *)
    (*  ok - A boolean value that is set to TRUE if the dequeue was successful, FALSE otherwise *)
    PROCEDURE Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);

    (* Checks if the Queue is empty *)
    FUNCTION IsEmpty: BOOLEAN;

    PRIVATE 
      data: Vector;

  END;

IMPLEMENTATION

CONSTRUCTOR EvenQueue.Init;
BEGIN (* Init *)
  data.Init();
END; (* Init *)

DESTRUCTOR EvenQueue.Done;
BEGIN (* Done *)
  data.Done();
END; (* Done *)

PROCEDURE EvenQueue.Enqueue(val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Enqueue *)
  IF val MOD 2 = 0 THEN
    BEGIN (* IF *)
      data.Add(val, ok);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      ok := FALSE;
    END; (* ELSE *)
END; (* Enqueue *)

PROCEDURE EvenQueue.Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);
BEGIN (* Dequeue *)
  data.GetElementAt(1, val, ok);

  IF ok THEN
    BEGIN (* IF *)
      data.RemoveElementAt(1, ok);
    END (* IF *)
END; (* Dequeue *)

FUNCTION EvenQueue.IsEmpty: BOOLEAN;
BEGIN (* IsEmpty *)
  IsEmpty := data.Size() = 0;
END; (* IsEmpty *)

END.