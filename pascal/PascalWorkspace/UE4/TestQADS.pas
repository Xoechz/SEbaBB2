PROGRAM TestQADS;

USES
QADS;

TYPE 
  test = PROCEDURE (VAR success: BOOLEAN);

PROCEDURE InitialQueue_IsEmpty(VAR success: BOOLEAN);
BEGIN (* InitialQueue_IsEmpty *)
  success := IsEmpty();
END; (* InitialQueue_IsEmpty *)

PROCEDURE Clear_EmptiesQueue(VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
BEGIN (* Clear_EmptiesVector *)
  Enqueue(1, addOk);
  ClearQueue();

  success := IsEmpty()
             AND addOk;
END; (* Clear_EmptiesVector *)

PROCEDURE Enqueue_AddsElement(VAR success: BOOLEAN);
VAR 
  enqueueOk, dequeueOk: BOOLEAN;
  dequeueVal: INTEGER;
BEGIN (* Enqueue_AddsElement *)
  ClearQueue();
  Enqueue(1, enqueueOk);

  success := enqueueOk
             AND NOT IsEmpty();

  Dequeue(dequeueVal, dequeueOk);

  success := success
             AND dequeueOk
             AND (dequeueVal = 1)
             AND IsEmpty();
END; (* Enqueue_AddsElement *)

PROCEDURE DequeueEmptyQueue_ReturnsFalse(VAR success: BOOLEAN);
VAR 
  dequeueOk: BOOLEAN;
  dequeueVal: INTEGER;
BEGIN (* DequeueEmptyQueue_ReturnsFalse *)
  ClearQueue();
  Dequeue(dequeueVal, dequeueOk);

  success := NOT dequeueOk
             AND IsEmpty();
END; (* DequeueEmptyQueue_ReturnsFalse *)

PROCEDURE RunTest(name: STRING; t: test);
VAR 
  success: BOOLEAN;
BEGIN (* RunTest *)
  t(success);
  IF (success) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name)
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunTest *)

BEGIN (* TestQADS *)
  RunTest('InitialQueue_IsEmpty', InitialQueue_IsEmpty);
  RunTest('Clear_EmptiesQueue', Clear_EmptiesQueue);
  RunTest('Enqueue_AddsElement', Enqueue_AddsElement);
  RunTest('DequeueEmptyQueue_ReturnsFalse', DequeueEmptyQueue_ReturnsFalse);

  WriteLn('All tests passed');
END. (* TestQADS *)