PROGRAM TestMLList;

USES
MLLi, MLInt, MLColl, MLObj;

TYPE 
  test = PROCEDURE (l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);

PROCEDURE NewList_IsEmpty(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
BEGIN (* NewList_IsEmpty *)
  success := (l^.Size() = 0);
END; (* NewList_IsEmpty *)

PROCEDURE Clear_EmptiesList(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
BEGIN (* Clear_EmptiesList *)
  l^.Add(i1);
  l^.Add(i2);
  l^.Add(i3);

  success := (l^.Size() = 3);
  l^.Clear();

  success := success 
  AND (l^.Size() = 0);
END; (* Clear_EmptiesList *)

PROCEDURE Add_AddsCorrectElement(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
VAR
  o: MLObject;
  it: MLIterator;
BEGIN (* Add_AddsCorrectElement *)
  l^.Add(i1);

  it := l^.NewIterator();
  o := it^.Next();
  Dispose(it, Done);
  
  success := (i1^.IsEqualTo(o))  
    AND (l^.Size() = 1);
END; (* Add_AddsCorrectElement *)

PROCEDURE Remove_RemovesCorrectElement(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
VAR
  o1, o2, o3: MLObject;
  it: MLIterator;
BEGIN (* Remove_RemovesCorrectElement *)
  l^.Add(i1);
  l^.Add(i2);
  
  o1 := l^.Remove(i1);
  o3 := l^.Remove(i3);
  
  it := l^.NewIterator();
  o2 := it^.Next();
  Dispose(it, Done);

  success := (i1^.IsEqualTo(o1))
    AND (i2^.IsEqualTo(o2))
    AND (o3 = NIL)
    AND (l^.Size() = 1);
END; (* Remove_RemovesCorrectElement *)

PROCEDURE Contains_ReturnsCorrectValue(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
BEGIN (* Contains_ReturnsCorrectValue *)
  l^.Add(i1);
  
  success := l^.Contains(i1)
    AND not l^.Contains(i2);
END; (* Contains_ReturnsCorrectValue *)

PROCEDURE Prepend_AddsElementAtBeginning(l: MLList; VAR success: BOOLEAN; i1, i2, i3: MLInteger);
var
  o1, o2, o3: MLObject;
  it: MLIterator;
BEGIN (* Prepend_AddsElementAtBeginning *)
  l^.Add(i1);
  l^.Prepend(i2);
  l^.Prepend(i3);
  
  it := l^.NewIterator();
  o1 := it^.Next();
  o2 := it^.Next();
  o3 := it^.Next();
  Dispose(it, Done);

  success := (i3^.IsEqualTo(o1))
    AND (i2^.IsEqualTo(o2))
    AND (i1^.IsEqualTo(o3))
    AND (l^.Size() = 3);
END; (* Prepend_AddsElementAtBeginning *)

PROCEDURE RunTest(name: STRING; t: test; i1, i2, i3: MLInteger);
VAR 
  l: MLList;
  success: BOOLEAN;
BEGIN (* RunTest *)
  l := NewMLList();
  t(l, success, i1, i2, i3);
  Dispose(l, Done);
  
  IF (success) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
    END; (* ELSE *)
END; (* RunTest *)

var
  i1, i2, i3: MLInteger;
BEGIN (* TestMLList *)
  i1 := NewMLInteger(1);
  i2 := NewMLInteger(2);
  i3 := NewMLInteger(3);

  RunTest('NewList_IsEmpty', NewList_IsEmpty, i1, i2, i3);
  RunTest('Clear_EmptiesList', Clear_EmptiesList, i1, i2, i3);
  RunTest('Add_AddsCorrectElement', Add_AddsCorrectElement, i1, i2, i3);
  RunTest('Remove_RemovesCorrectElement', Remove_RemovesCorrectElement, i1, i2, i3);
  RunTest('Contains_ReturnsCorrectValue', Contains_ReturnsCorrectValue, i1, i2, i3);
  RunTest('Prepend_AddsElementAtBeginning', Prepend_AddsElementAtBeginning, i1, i2, i3);

  Dispose(i1, Done);
  Dispose(i2, Done);
  Dispose(i3, Done);
  WriteLn('All tests passed');
END. (* TestMLList *)