PROGRAM TestQueue;

USES
UEvenQueue;

TYPE 
  test = FUNCTION : BOOLEAN;

FUNCTION InitialQueue_IsEmpty: BOOLEAN;
VAR 
  q: EvenQueue;
BEGIN (* InitialQueue_IsEmpty *)
  q.Init();
  InitialQueue_IsEmpty := q.IsEmpty();
  q.Done();
END; (* InitialQueue_IsEmpty *)

FUNCTION EnqueueOne_IsNotEmpty: BOOLEAN;
VAR 
  q: EvenQueue;
  enqueueOk: BOOLEAN;
BEGIN (* EnqueueOne_IsNotEmpty *)
  q.Init();
  q.Enqueue(2, enqueueOk);
  EnqueueOne_IsNotEmpty := NOT q.IsEmpty()
                           AND enqueueOk;
  q.Done();
END; (* EnqueueOne_IsNotEmpty *)

FUNCTION EnqueueOneDequeueOne_IsEmpty: BOOLEAN;
VAR 
  q: EvenQueue;
  enqueueOk: BOOLEAN;
  dequeueOk: BOOLEAN;
  value: INTEGER;
BEGIN (* EnqueueOneDequeueOne_IsEmpty *)
  q.Init();
  q.Enqueue(2, enqueueOk);
  q.Dequeue(value, dequeueOk);
  EnqueueOneDequeueOne_IsEmpty := q.IsEmpty()
                                  AND enqueueOk
                                  AND dequeueOk
                                  AND (value = 2);
  q.Done();
END; (* EnqueueOneDequeueOne_IsEmpty *)

FUNCTION EnqueueUneven_DoesNotEnqueue: BOOLEAN;
VAR 
  q: EvenQueue;
  enqueueOk: BOOLEAN;
BEGIN (* EnqueueUneven_DoesNotEnqueue *)
  q.Init();
  q.Enqueue(3, enqueueOk);
  EnqueueUneven_DoesNotEnqueue := NOT enqueueOk
                                  AND q.IsEmpty();
  q.Done();
END; (* EnqueueUneven_DoesNotEnqueue *)

PROCEDURE RunTest(name: STRING; t: test);
BEGIN (* RunTest *)
  IF (t()) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunTest *)

BEGIN (* TestQueue *)
  WriteLn('EvenQueue:');
  RunTest('InitialQueue_IsEmpty', InitialQueue_IsEmpty);
  RunTest('EnqueueOne_IsNotEmpty', EnqueueOne_IsNotEmpty);
  RunTest('EnqueueOneDequeueOne_IsEmpty', EnqueueOneDequeueOne_IsEmpty);
  RunTest('EnqueueUneven_DoesNotEnqueue', EnqueueUneven_DoesNotEnqueue);
  WriteLn('All tests passed');
END. (* TestQueue *)