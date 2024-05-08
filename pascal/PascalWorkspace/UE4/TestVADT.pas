PROGRAM TestVADT;

USES
VADT;

TYPE 
  test = PROCEDURE (VAR v: Vector; VAR success: BOOLEAN);

PROCEDURE InitialVector_IsEmpty(VAR v: Vector; VAR success: BOOLEAN);
BEGIN (* InitialVector_IsEmpty *)
  success := (Size(v) = 0)
             AND (Capacity(v) = 10);
END; (* InitialVector_IsEmpty *)

PROCEDURE Clear_EmptiesVector(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
BEGIN (* Clear_EmptiesVector *)
  Add(v, 1, addOk);
  Clear(v);

  success := (Size(v) = 0)
             AND (Capacity(v) = 10)
             AND addOk;
END; (* Clear_EmptiesVector *)

PROCEDURE AddingElement_IncreasesSize(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk: BOOLEAN;
  elementAtValue: INTEGER;
BEGIN (* AddingElement_IncreasesSize *)
  Add(v, 17, addOk);
  ElementAt(v, 1, elementAtValue, elementAtOk);

  success := (Size(v) = 1)
             AND (Capacity(v) = 10)
             AND addOk
             AND elementAtOk
             AND (elementAtValue = 17);
END; (* AddingElement_IncreasesSize *)

PROCEDURE AddingElementsOverCapacity_ResizesVector(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, ok: BOOLEAN;
  i, elementAtValue: INTEGER;
BEGIN (* AddingElementsOverCapacity_ResizesVector *)
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(v, i, addOk);
      ElementAt(v, i, elementAtValue, elementAtOk);

      ok := (Size(v) = i)
            AND (Capacity(v) = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  Add(v, 11, addOk);
  ElementAt(v, 11, elementAtValue, elementAtOk);

  success := ok
             AND (Size(v) = 11)
             AND (Capacity(v) = 20)
             AND addOk
             AND elementAtOk
             AND (elementAtValue = 11);
END; (* AddingElementsOverCapacity_ResizesVector *)

PROCEDURE SetElementAt_UpdatesValue(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, setElementAtOk, ok: BOOLEAN;
  i, elementAtValue: INTEGER;
BEGIN (* SetElementAt_UpdatesValue *)
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(v, i, addOk);
      ElementAt(v, i, elementAtValue, elementAtOk);

      ok := (Size(v) = i)
            AND (Capacity(v) = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  SetElementAt(v, 5, 17, setElementAtOk);
  ElementAt(v, 5, elementAtValue, elementAtOk);

  success := ok
             AND setElementAtOk
             AND (Size(v) = 10)
             AND (Capacity(v) = 10)
             AND elementAtOk
             AND (elementAtValue = 17);
END; (* SetElementAt_UpdatesValue *)

PROCEDURE SetElementAtOutOfRange_ReturnsFalse(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  setElementAtOk: BOOLEAN;
BEGIN (* SetElementAtOutOfRange_ReturnsFalse *)
  SetElementAt(v, 5, 17, setElementAtOk);

  success := NOT setElementAtOk
             AND (Size(v) = 0)
             AND (Capacity(v) = 10);
END; (* SetElementAtOutOfRange_ReturnsFalse *)

PROCEDURE ElementAtOutOfRange_ReturnsFalse(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  elementAtOk: BOOLEAN;
  elementAtValue: INTEGER;
BEGIN (* ElementAtOutOfRange_ReturnsFalse *)
  ElementAt(v, 5, elementAtValue, elementAtOk);

  success := NOT elementAtOk
             AND (Size(v) = 0)
             AND (Capacity(v) = 10);
END; (* ElementAtOutOfRange_ReturnsFalse *)

PROCEDURE RemoveElementAtOutOfRange_ReturnsFalse(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  removeElementAtOk: BOOLEAN;
BEGIN (* RemoveElementAtOutOfRange_ReturnsFalse *)
  RemoveElementAt(v, 5, removeElementAtOk);

  success := NOT removeElementAtOk
             AND (Size(v) = 0)
             AND (Capacity(v) = 10);
END; (* RemoveElementAtOutOfRange_ReturnsFalse *)

PROCEDURE RemoveElementAt_RemovesValueAndDoesNotResize(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, removeElementAtOk, ok: BOOLEAN;
  i, j, elementAtValue: INTEGER;
BEGIN (* RemoveElementAt_RemovesValueAndDoesNotResize *)
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(v, i, addOk);
      ElementAt(v, i, elementAtValue, elementAtOk);

      ok := (Size(v) = i)
            AND (Capacity(v) = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  Add(v, 11, addOk);
  RemoveElementAt(v, 5, removeElementAtOk);

  i := 1;
  j := 1;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      ElementAt(v, i, elementAtValue, elementAtOk);

      ok := elementAtOk
            AND (elementAtValue = j);

      i := i + 1;
      j := j + 1;

      IF (i = 5) THEN
        BEGIN (* IF *)
          j := j + 1;
        END; (* IF *)
    END; (* WHILE *)

  success := ok
             AND removeElementAtOk
             AND (Size(v) = 10)
             AND (Capacity(v) = 20);
END;

PROCEDURE AddingTenThousandElements_ResizesVector(VAR v: Vector; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, ok: BOOLEAN;
  i, expectedCapacity, elementAtValue: INTEGER;
BEGIN (* AddingTenThousandElements_ResizesVector *)
  i := 1;
  ok := TRUE;
  expectedCapacity := 10;

  WHILE (ok) AND (i <= 10000) DO
    BEGIN (* WHILE *)
      Add(v, i, addOk);
      ElementAt(v, i, elementAtValue, elementAtOk);

      ok := (Size(v) = i)
            AND (Capacity(v) = expectedCapacity)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;

      IF (i > expectedCapacity) THEN
        BEGIN (* IF *)
          expectedCapacity := expectedCapacity * 2;
        END; (* IF *)
    END; (* WHILE *)

  success := ok
END; (* AddingTenThousandElements_ResizesVector *)

PROCEDURE RunTest(name: STRING; t: test);
VAR 
  success: BOOLEAN;
  v: Vector;
BEGIN (* RunTest *)
  InitVector(v, success);

  IF (NOT success) THEN
    BEGIN
      WriteLn('FAILED to initialize vector');
      Halt(1);
    END
  ELSE
    BEGIN
      t(v ,success);
      DisposeVector(v);

      IF (success) THEN
        BEGIN (* IF *)
          WriteLn('PASSED - ', name);
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          WriteLn('FAILED - ', name);
          Halt(1);
        END; (* ELSE *)
    END;
END; (* RunTest *)

PROCEDURE TestConcurrentExecution;
VAR 
  v1, v2: Vector;
  success1, success2: BOOLEAN;
BEGIN (* TestConcurrentExecution *)
  InitVector(v1, success1);
  InitVector(v2, success2);

  IF (success1 AND success2) THEN
    BEGIN (* IF *)
      RemoveElementAt_RemovesValueAndDoesNotResize(v1, success1);
      SetElementAt_UpdatesValue(v2, success2);
      DisposeVector(v1);
      DisposeVector(v2);

      IF (success1 AND success2) THEN
        BEGIN (* IF *)
          WriteLn('PASSED - Concurrent Execution');
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          WriteLn('FAILED - Concurrent Execution');
          Halt(1);
        END; (* ELSE *)
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED to initialize vectors');
      Halt(1);
    END; (* ELSE *)
END; (* TestConcurrentExecution *)

BEGIN (* TestVADT *)
  RunTest('InitialVector_IsEmpty', InitialVector_IsEmpty);
  RunTest('Clear_EmptiesVector', Clear_EmptiesVector);
  RunTest('AddingElement_IncreasesSize', AddingElement_IncreasesSize);
  RunTest('AddingElementsOverCapacity_ResizesVector', AddingElementsOverCapacity_ResizesVector);
  RunTest('SetElementAt_UpdatesValue', SetElementAt_UpdatesValue);
  RunTest('SetElementAtOutOfRange_ReturnsFalse', SetElementAtOutOfRange_ReturnsFalse);
  RunTest('ElementAtOutOfRange_ReturnsFalse', ElementAtOutOfRange_ReturnsFalse);
  RunTest('RemoveElementAtOutOfRange_ReturnsFalse', RemoveElementAtOutOfRange_ReturnsFalse);
  RunTest('RemoveElementAt_RemovesValueAndDoesNotResize', RemoveElementAt_RemovesValueAndDoesNotResize);
  RunTest('AddingTenThousandElements_ResizesVector', AddingTenThousandElements_ResizesVector);
  TestConcurrentExecution();
  WriteLn('All tests passed');
END. (* TestVADT *)