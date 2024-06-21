PROGRAM TestVector;

USES
UVector, UNaturalVector, UPrimeVector;

CONST 
  PrimeArray: ARRAY [0..11] OF INTEGER = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37);

TYPE 
  test = PROCEDURE (v: VectorPtr; VAR success: BOOLEAN);

PROCEDURE InitialVector_IsEmpty(v: VectorPtr; VAR success: BOOLEAN);
BEGIN (* InitialVector_IsEmpty *)
  success := (v^.Size() = 0)
             AND (v^.Capacity() = 10);
END; (* InitialVector_IsEmpty *)

PROCEDURE ClearVector_IsEmpty(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
BEGIN (* ClearVector_IsEmpty *)
  v^.Add(PrimeArray[1], addOk);
  v^.Clear();
  success := addOk
             AND (v^.Size() = 0);
END; (* ClearVector_IsEmpty *)

PROCEDURE AddElement_IncreasesSize(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
BEGIN (* AddElement_IncreasesSize *)
  v^.Add(PrimeArray[1], addOk);
  success := addOk
             AND (v^.Size() = 1);
END; (* AddElement_IncreasesSize *)

PROCEDURE AddElementsOverCapacity_OkFalse(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk: BOOLEAN;
  i: INTEGER;
BEGIN (* AddElementsOverCapacity_OkFalse *)
  success := TRUE;

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.Add(PrimeArray[11], addOk);

  success := success
             AND NOT addOk
             AND (v^.Size() = 10);
END; (* AddElementsOverCapacity_OkFalse *)

PROCEDURE GetElementAt_ReturnsCorrectElement(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* GetElementAt_ReturnsCorrectElement *)
  success := TRUE;

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success
                 AND addOk
                 AND (v^.Size() = i);
    END; (* FOR *)

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success
                 AND elementAtOk
                 AND (element = PrimeArray[i]);
    END; (* FOR *)
END; (* GetElementAt_ReturnsCorrectElement *)

PROCEDURE GetElementAtOutOfBounds_OkFalse(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* GetElementAtOutOfBounds_OkFalse *)
  success := TRUE;

  FOR i := 1 TO 5 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.GetElementAt(6, element, elementAtOk);
  success := success
             AND NOT elementAtOk;

  v^.GetElementAt(0, element, elementAtOk);
  success := success
             AND NOT elementAtOk
             AND (v^.Size() = 5);
END; (* GetElementAtOutOfBounds_OkFalse *)

PROCEDURE InsertElementAt_AddsElementToPosition(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* InsertElementAt_AddsElementToPosition *)
  success := TRUE;

  FOR i := 1 TO 9 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.InsertElementAt(5, PrimeArray[11], insertOk);
  v^.GetElementAt(5, element, elementAtOk);
  success := success
             AND insertOk
             AND elementAtOk
             AND (element = PrimeArray[11])
             AND (v^.Size() = 10);

  FOR i := 6 TO 10 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success
                 AND elementAtOk
                 AND (element = PrimeArray[i - 1]);
    END; (* FOR *)
END; (* InsertElementAt_AddsElementToPosition *)

PROCEDURE InsertElementAtGreaterThanCapacity_DoesNotInsert(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  insertOk: BOOLEAN;
BEGIN (* InsertElementAtGreaterThanCapacity_DoesNotInsert *)
  v^.InsertElementAt(11, PrimeArray[1], insertOk);
  success := NOT insertOk
             AND (v^.Size() = 0);
END; (* InsertElementAtGreaterThanCapacity_DoesNotInsert *)

PROCEDURE InsertElementAtLessThanOne_AddsToFront(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* InsertElementAtLessThanOne_AddsToFront *)
  success := TRUE;

  FOR i := 1 TO 9 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.InsertElementAt(-17, PrimeArray[11], insertOk);
  v^.GetElementAt(1, element, elementAtOk);
  success := success
             AND insertOk
             AND elementAtOk
             AND (element = PrimeArray[11])
             AND (v^.Size() = 10);

  FOR i := 2 TO 10 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success
                 AND elementAtOk
                 AND (element = PrimeArray[i - 1]);
    END; (* FOR *)
END; (* InsertElementAtLessThanOne_AddsToFront *)

PROCEDURE InsertElementAtGreaterThanSize_AddsToEnd(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* InsertElementAtGreaterThanSize_AddsToEnd *)
  success := TRUE;

  FOR i := 1 TO 5 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.InsertElementAt(10, PrimeArray[11], insertOk);
  v^.GetElementAt(6, element, elementAtOk);
  success := success
             AND insertOk
             AND elementAtOk
             AND (element = PrimeArray[11])
             AND (v^.Size() = 6);

  FOR i := 1 TO 5 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success AND elementAtOk AND (element = PrimeArray[i]);
    END; (* FOR *)
END; (* InsertElementAtGreaterThanSize_AddsToEnd *)

PROCEDURE InsertElementAtAlreadyFull_OkFalse(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* InsertElementAtAlreadyFull_OkFalse *)
  success := TRUE;

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.InsertElementAt(5, PrimeArray[11], insertOk);
  success := success
             AND NOT insertOk
             AND (v^.Size() = 10);

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success
                 AND elementAtOk
                 AND (element = PrimeArray[i]);
    END; (* FOR *)
END; (* InsertElementAtAlreadyFull_OkFalse *)

PROCEDURE RemoveElementAt_RemovesElement(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, removeOk, elementAtOk: BOOLEAN;
  i, element: INTEGER;
BEGIN (* RemoveElementAt_RemovesElement *)
  success := TRUE;

  FOR i := 1 TO 10 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.RemoveElementAt(5, removeOk);
  success := success
             AND (v^.Size() = 9);

  FOR i := 1 TO 4 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success AND elementAtOk AND (element = PrimeArray[i]);
    END; (* FOR *)

  FOR i := 5 TO 9 DO
    BEGIN (* FOR *)
      v^.GetElementAt(i, element, elementAtOk);
      success := success AND elementAtOk AND (element = PrimeArray[i + 1]);
    END; (* FOR *)
END; (* RemoveElementAt_RemovesElement *)

PROCEDURE RemoveElementAtOutOfBounds_OkFalse(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  removeOk, addOk: BOOLEAN;
  i: INTEGER;
BEGIN (* RemoveElementAtOutOfBounds_OkFalse *)
  success := TRUE;

  FOR i := 1 TO 5 DO
    BEGIN (* FOR *)
      v^.Add(PrimeArray[i], addOk);
      success := success AND addOk;
    END; (* FOR *)

  v^.RemoveElementAt(6, removeOk);
  success := success AND NOT removeOk;
  v^.RemoveElementAt(0, removeOk);
  success := success
             AND NOT removeOk
             AND (v^.Size() = 5);
END; (* RemoveElementAtOutOfBounds_OkFalse *)

PROCEDURE NonPrime_AddsAndInserts(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk: BOOLEAN;
BEGIN (* NonPrime_AddsAndInserts *)
  v^.Add(4, addOk);
  v^.InsertElementAt(0, 6, insertOk);

  success := addOk
             AND insertOk
             AND (v^.Size() = 2);
END; (* NonPrime_AddsAndInserts *)

PROCEDURE NonPrime_DoesNotAddAndInsert(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk: BOOLEAN;
BEGIN (* NonPrime_DoesNotAddAndInsert *)
  v^.Add(4, addOk);
  v^.InsertElementAt(0, 6, insertOk);

  success := NOT addOk
             AND NOT insertOk
             AND (v^.Size() = 0);
END; (* NonPrime_DoesNotAddAndInsert *)

PROCEDURE NegativeNumber_AddsAndInserts(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk: BOOLEAN;
BEGIN (* NegativeNumber_AddsAndInserts *)
  v^.Add(-2, addOk);
  v^.InsertElementAt(0, -3, insertOk);

  success := addOk
             AND insertOk
             AND (v^.Size() = 2);
END; (* NegativeNumber_AddsAndInserts *)

PROCEDURE NegativeNumber_DoesNotAddAndInsert(v: VectorPtr; VAR success: BOOLEAN);
VAR 
  addOk, insertOk: BOOLEAN;
BEGIN (* NegativeNumber_DoesNotAddAndInsert *)
  v^.Add(-2, addOk);
  v^.InsertElementAt(0, -3, insertOk);

  success := NOT addOk
             AND NOT insertOk
             AND (v^.Size() = 0);
END; (* NegativeNumber_DoesNotAddAndInsert *)

PROCEDURE RunVectorTest(name: STRING; t: test);
VAR 
  success: BOOLEAN;
  v: VectorPtr;
BEGIN (* RunVectorTest *)
  New(v, Init());
  t(v, success);
  Dispose(v, Done());

  IF (success) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunVectorTest *)

PROCEDURE RunNaturalVectorTest(name: STRING; t: test);
VAR 
  success: BOOLEAN;
  v: VectorPtr;
BEGIN (* RunNaturalVectorTest *)
  v := New(NaturalVectorPtr, Init());
  t(v, success);
  Dispose(v, Done());

  IF (success) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunNaturalVectorTest *)

PROCEDURE RunPrimeVectorTest(name: STRING; t: test);
VAR 
  success: BOOLEAN;
  v: VectorPtr;
BEGIN (* RunPrimeVectorTest *)
  v := New(PrimeVectorPtr, Init());
  t(v, success);
  Dispose(v, Done());

  IF (success) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunPrimeVectorTest *)

BEGIN (* TestVector *)
  WriteLn('Vector:');
  RunVectorTest('InitialVector_IsEmpty', InitialVector_IsEmpty);
  RunVectorTest('ClearVector_IsEmpty', ClearVector_IsEmpty);
  RunVectorTest('AddElement_IncreasesSize', AddElement_IncreasesSize);
  RunVectorTest('AddElementsOverCapacity_OkFalse', AddElementsOverCapacity_OkFalse);
  RunVectorTest('GetElementAt_ReturnsCorrectElement', GetElementAt_ReturnsCorrectElement);
  RunVectorTest('GetElementAtOutOfBounds_OkFalse', GetElementAtOutOfBounds_OkFalse);
  RunVectorTest('InsertElementAt_AddsElementToPosition', InsertElementAt_AddsElementToPosition);
  RunVectorTest('InsertElementAtGreaterThanCapacity_DoesNotInsert', InsertElementAtGreaterThanCapacity_DoesNotInsert);
  RunVectorTest('InsertElementAtLessThanOne_AddsToFront', InsertElementAtLessThanOne_AddsToFront);
  RunVectorTest('InsertElementAtGreaterThanSize_AddsToEnd', InsertElementAtGreaterThanSize_AddsToEnd);
  RunVectorTest('InsertElementAtAlreadyFull_OkFalse', InsertElementAtAlreadyFull_OkFalse);
  RunVectorTest('RemoveElementAt_RemovesElement', RemoveElementAt_RemovesElement);
  RunVectorTest('RemoveElementAtOutOfBounds_OkFalse', RemoveElementAtOutOfBounds_OkFalse);
  RunVectorTest('NonPrime_AddsAndInserts', NonPrime_AddsAndInserts);
  RunVectorTest('NegativeNumber_AddsAndInserts', NegativeNumber_AddsAndInserts);

  WriteLn();
  WriteLn('NaturalVector:');
  RunNaturalVectorTest('InitialVector_IsEmpty', InitialVector_IsEmpty);
  RunNaturalVectorTest('ClearVector_IsEmpty', ClearVector_IsEmpty);
  RunNaturalVectorTest('AddElement_IncreasesSize', AddElement_IncreasesSize);
  RunNaturalVectorTest('AddElementsOverCapacity_OkFalse', AddElementsOverCapacity_OkFalse);
  RunNaturalVectorTest('GetElementAt_ReturnsCorrectElement', GetElementAt_ReturnsCorrectElement);
  RunNaturalVectorTest('GetElementAtOutOfBounds_OkFalse', GetElementAtOutOfBounds_OkFalse);
  RunNaturalVectorTest('InsertElementAt_AddsElementToPosition', InsertElementAt_AddsElementToPosition);
  RunNaturalVectorTest('InsertElementAtGreaterThanCapacity_DoesNotInsert', InsertElementAtGreaterThanCapacity_DoesNotInsert);
  RunNaturalVectorTest('InsertElementAtLessThanOne_AddsToFront', InsertElementAtLessThanOne_AddsToFront);
  RunNaturalVectorTest('InsertElementAtGreaterThanSize_AddsToEnd', InsertElementAtGreaterThanSize_AddsToEnd);
  RunNaturalVectorTest('InsertElementAtAlreadyFull_OkFalse', InsertElementAtAlreadyFull_OkFalse);
  RunNaturalVectorTest('RemoveElementAt_RemovesElement', RemoveElementAt_RemovesElement);
  RunNaturalVectorTest('RemoveElementAtOutOfBounds_OkFalse', RemoveElementAtOutOfBounds_OkFalse);
  RunNaturalVectorTest('NonPrime_AddsAndInserts', NonPrime_AddsAndInserts);
  RunNaturalVectorTest('NegativeNumber_DoesNotAddAndInsert', NegativeNumber_DoesNotAddAndInsert);

  WriteLn();
  WriteLn('PrimeVector:');
  RunPrimeVectorTest('InitialVector_IsEmpty', InitialVector_IsEmpty);
  RunPrimeVectorTest('ClearVector_IsEmpty', ClearVector_IsEmpty);
  RunPrimeVectorTest('AddElement_IncreasesSize', AddElement_IncreasesSize);
  RunPrimeVectorTest('AddElementsOverCapacity_OkFalse', AddElementsOverCapacity_OkFalse);
  RunPrimeVectorTest('GetElementAt_ReturnsCorrectElement', GetElementAt_ReturnsCorrectElement);
  RunPrimeVectorTest('GetElementAtOutOfBounds_OkFalse', GetElementAtOutOfBounds_OkFalse);
  RunPrimeVectorTest('InsertElementAt_AddsElementToPosition', InsertElementAt_AddsElementToPosition);
  RunPrimeVectorTest('InsertElementAtGreaterThanCapacity_DoesNotInsert', InsertElementAtGreaterThanCapacity_DoesNotInsert);
  RunPrimeVectorTest('InsertElementAtLessThanOne_AddsToFront', InsertElementAtLessThanOne_AddsToFront);
  RunPrimeVectorTest('InsertElementAtGreaterThanSize_AddsToEnd', InsertElementAtGreaterThanSize_AddsToEnd);
  RunPrimeVectorTest('InsertElementAtAlreadyFull_OkFalse', InsertElementAtAlreadyFull_OkFalse);
  RunPrimeVectorTest('RemoveElementAt_RemovesElement', RemoveElementAt_RemovesElement);
  RunPrimeVectorTest('RemoveElementAtOutOfBounds_OkFalse', RemoveElementAtOutOfBounds_OkFalse);
  RunPrimeVectorTest('NonPrime_DoesNotAddAndInsert', NonPrime_DoesNotAddAndInsert);
  RunPrimeVectorTest('NegativeNumber_AddsAndInserts', NegativeNumber_AddsAndInserts);
  WriteLn('All tests passed');
END. (* TestVector *)