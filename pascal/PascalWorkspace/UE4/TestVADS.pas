PROGRAM TestVADS;

USES
VADS;

TYPE 
  test = PROCEDURE (VAR success: BOOLEAN);

PROCEDURE InitialVector_IsEmpty(VAR success: BOOLEAN);
BEGIN (* InitialVector_IsEmpty *)
  success := (Size() = 0)
             AND (Capacity() = 10);
END; (* InitialVector_IsEmpty *)

PROCEDURE Clear_EmptiesVector(VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
BEGIN (* Clear_EmptiesVector *)
  Add(1, addOk);
  Clear();

  success := (Size() = 0)
             AND (Capacity() = 10)
             AND addOk;
END; (* Clear_EmptiesVector *)

PROCEDURE AddingElement_IncreasesSize(VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk: BOOLEAN;
  elementAtValue: INTEGER;
BEGIN (* AddingElement_IncreasesSize *)
  Clear();
  Add(17, addOk);
  ElementAt(1, elementAtValue, elementAtOk);

  success := (Size() = 1)
             AND (Capacity() = 10)
             AND addOk
             AND elementAtOk
             AND (elementAtValue = 17);
END; (* AddingElement_IncreasesSize *)

PROCEDURE AddingElementsOverCapacity_ResizesVector(VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, ok: BOOLEAN;
  i, elementAtValue: INTEGER;
BEGIN (* AddingElementsOverCapacity_ResizesVector *)
  Clear();
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(i, addOk);
      ElementAt(i, elementAtValue, elementAtOk);

      ok := (Size() = i)
            AND (Capacity() = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  Add(11, addOk);
  ElementAt(11, elementAtValue, elementAtOk);

  success := ok
             AND (Size() = 11)
             AND (Capacity() = 20)
             AND addOk
             AND elementAtOk
             AND (elementAtValue = 11);
END; (* AddingElementsOverCapacity_ResizesVector *)

PROCEDURE SetElementAt_UpdatesValue(VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, setElementAtOk, ok: BOOLEAN;
  i, elementAtValue: INTEGER;
BEGIN (* SetElementAt_UpdatesValue *)
  Clear();
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(i, addOk);
      ElementAt(i, elementAtValue, elementAtOk);

      ok := (Size() = i)
            AND (Capacity() = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  SetElementAt(5, 17, setElementAtOk);
  ElementAt(5, elementAtValue, elementAtOk);

  success := ok
             AND setElementAtOk
             AND (Size() = 10)
             AND (Capacity() = 10)
             AND elementAtOk
             AND (elementAtValue = 17);
END; (* SetElementAt_UpdatesValue *)

PROCEDURE SetElementAtOutOfRange_ReturnsFalse(VAR success: BOOLEAN);
VAR 
  setElementAtOk: BOOLEAN;
BEGIN (* SetElementAtOutOfRange_ReturnsFalse *)
  Clear();
  SetElementAt(5, 17, setElementAtOk);

  success := NOT setElementAtOk
             AND (Size() = 0)
             AND (Capacity() = 10);
END; (* SetElementAtOutOfRange_ReturnsFalse *)

PROCEDURE ElementAtOutOfRange_ReturnsFalse(VAR success: BOOLEAN);
VAR 
  elementAtOk: BOOLEAN;
  elementAtValue: INTEGER;
BEGIN (* ElementAtOutOfRange_ReturnsFalse *)
  Clear();
  ElementAt(5, elementAtValue, elementAtOk);

  success := NOT elementAtOk
             AND (Size() = 0)
             AND (Capacity() = 10);
END; (* ElementAtOutOfRange_ReturnsFalse *)

PROCEDURE RemoveElementAtOutOfRange_ReturnsFalse(VAR success: BOOLEAN);
VAR 
  removeElementAtOk: BOOLEAN;
BEGIN (* RemoveElementAtOutOfRange_ReturnsFalse *)
  Clear();
  RemoveElementAt(5, removeElementAtOk);

  success := NOT removeElementAtOk
             AND (Size() = 0)
             AND (Capacity() = 10);
END; (* RemoveElementAtOutOfRange_ReturnsFalse *)

PROCEDURE RemoveElementAt_RemovesValueAndDoesNotResize(VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, removeElementAtOk, ok: BOOLEAN;
  i, j, elementAtValue: INTEGER;
BEGIN (* RemoveElementAt_RemovesValueAndDoesNotResize *)
  Clear();
  i := 1;
  ok := TRUE;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      Add(i, addOk);
      ElementAt(i, elementAtValue, elementAtOk);

      ok := (Size() = i)
            AND (Capacity() = 10)
            AND addOk
            AND elementAtOk
            AND (elementAtValue = i);

      i := i + 1;
    END; (* WHILE *)

  Add(11, addOk);
  RemoveElementAt(5, removeElementAtOk);

  i := 1;
  j := 1;

  WHILE (ok) AND (i <= 10) DO
    BEGIN (* WHILE *)
      ElementAt(i, elementAtValue, elementAtOk);

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
             AND (Size() = 10)
             AND (Capacity() = 20);
END;

PROCEDURE AddingTenThousandElements_ResizesVector(VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk, ok: BOOLEAN;
  i, expectedCapacity, elementAtValue: INTEGER;
BEGIN (* AddingTenThousandElements_ResizesVector *)
  Clear();
  i := 1;
  ok := TRUE;
  expectedCapacity := 10;

  WHILE (ok) AND (i <= 10000) DO
    BEGIN (* WHILE *)
      Add(i, addOk);
      ElementAt(i, elementAtValue, elementAtOk);

      ok := (Size() = i)
            AND (Capacity() = expectedCapacity)
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

BEGIN (* TestVADS *)
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
  WriteLn('All tests passed');
END. (* TestVADS *)