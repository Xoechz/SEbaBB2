(* Integer vector implemented as abstract data type. *)
(* GHO, 20.05.2017 *)
UNIT IntVect;

INTERFACE

TYPE
	(* Integer vector. *)
	IntegerVector = POINTER;


(* Initializes integer vector. *)
(* REF vector: Vector to initialize. *)
PROCEDURE InitIntegerVector(VAR vector: IntegerVector);

(* Disposes integer vector. *)
(* REF vector: Vector to dispose. *)
PROCEDURE DisposeIntegerVector(VAR vector: IntegerVector);


(* Adds element to given vector. *)
(* REF vector: Vector to add element to. *)
(* IN value: Value to add to vector. *)
PROCEDURE AddElement(VAR vector: IntegerVector; value: INTEGER);

(* Removes last element from given vector. Causes error when vector is empty. *)
(* REF vector: Vector to remove last element from. *)
(* OUT value: Value of last element that has been removed from vector. *)
PROCEDURE RemoveLastElement(VAR vector: IntegerVector; VAR value: INTEGER);

(* Removes all elements from given vector. *)
(* REF vector: Vector to remove all elements from. *)
PROCEDURE Clear(VAR vector: IntegerVector);

(* Gets element at given index in vector. *)
(* Vector is automatically resized and filled with zeros if index is larger than current vector size. *)
(* REF vector: Vector. *)
(* IN index: Index of element to retrieve. *)
(* OUT value: Value of element at given index. *)
PROCEDURE GetElementAt(VAR vector: IntegerVector; index: INTEGER; VAR value: INTEGER);

(* Sets element at given index in vector. *)
(* Vector is automatically resized and filled with zeros if index is larger than current vector size. *)
(* REF vector: Vector. *)
(* IN index: Index of element to set. *)
(* IN value: Value to store at given index in vector. *)
PROCEDURE SetElementAt(VAR vector: IntegerVector; index, value: INTEGER);

(* Gets number of elements in given vector. *)
(* REF vector: Vector to get size of. *)
(* RETURNS: Number of elements in given vector. *)
FUNCTION GetSize(VAR vector: IntegerVector): INTEGER;

IMPLEMENTATION

TYPE
	IntegerArray = ARRAY[1..1] OF INTEGER;
	IntegerArrayPtr = ^IntegerArray;

	VectorInternal = RECORD
		capacity, size: INTEGER;
		data: IntegerArrayPtr;
	END;
	VectorInternalPtr = ^VectorInternal;

(* Ensures that given vector has the given size. If not so the vector will be filled with zeros up to required size. *)
(* REF vector: Vector to check. *)
(* IN requiredSize: Required vector size. *)
PROCEDURE EnsureSize(VAR vector: IntegerVector; requiredSize: INTEGER);
BEGIN
	WHILE VectorInternalPtr(vector)^.size < requiredSize DO
		AddElement(vector, 0);
END;

PROCEDURE InitIntegerVector(VAR vector: IntegerVector);
VAR
	v: VectorInternalPtr;
BEGIN
	New(v);
	v^.capacity := 10;
	v^.size := 0;
	GetMem(v^.data, v^.capacity * SizeOf(INTEGER));
	vector := v;
END;

PROCEDURE DisposeIntegerVector(VAR vector: IntegerVector);
BEGIN
	FreeMem(VectorInternalPtr(vector)^.data, VectorInternalPtr(vector)^.capacity * SizeOf(INTEGER));
	Dispose(VectorInternalPtr(vector));
END;

PROCEDURE AddElement(VAR vector: IntegerVector; value: INTEGER);
VAR
	newArr: IntegerArrayPtr;
	i: INTEGER;
BEGIN
	IF VectorInternalPtr(vector)^.size = VectorInternalPtr(vector)^.capacity THEN BEGIN
		GetMem(newArr, 2 * VectorInternalPtr(vector)^.capacity * SizeOf(INTEGER));
		FOR i := 1 TO VectorInternalPtr(vector)^.size DO
			(*$R-*) newArr^[i] := VectorInternalPtr(vector)^.data^[i] (*$R+*);
		FreeMem(VectorInternalPtr(vector)^.data, VectorInternalPtr(vector)^.capacity * SizeOf(INTEGER));
		VectorInternalPtr(vector)^.data := newArr;
		VectorInternalPtr(vector)^.capacity := VectorInternalPtr(vector)^.capacity * 2;
	END;
	Inc(VectorInternalPtr(vector)^.size);
	(*$R-*)
	VectorInternalPtr(vector)^.data^[VectorInternalPtr(vector)^.size] := value;
	(*$R+*)
END;

PROCEDURE RemoveLastElement(VAR vector: IntegerVector; VAR value: INTEGER);
BEGIN
	IF VectorInternalPtr(vector)^.size < 1 THEN BEGIN
		WriteLn('IntVect.RemoveLastElement: Vector contains no elements.');
		Halt;
	END ELSE BEGIN
		(*$R-*)
		value := VectorInternalPtr(vector)^.data^[VectorInternalPtr(vector)^.size];
		(*$R+*)
		Dec(VectorInternalPtr(vector)^.size);
	END;
END;

PROCEDURE Clear(VAR vector: IntegerVector);
BEGIN
	VectorInternalPtr(vector)^.size := 0;
END;

PROCEDURE GetElementAt(VAR vector: IntegerVector; index: INTEGER; VAR value: INTEGER);
BEGIN
	EnsureSize(vector, index);
	(*$R-*)
	value := VectorInternalPtr(vector)^.data^[index];
	(*$R+*)
END;

PROCEDURE SetElementAt(VAR vector: IntegerVector; index, value: INTEGER);
BEGIN
	EnsureSize(vector, index);
	(*$R-*)
	VectorInternalPtr(vector)^.data^[index] := value;
	(*$R+*)
END;

FUNCTION GetSize(VAR vector: IntegerVector): INTEGER;
BEGIN
	GetSize := VectorInternalPtr(vector)^.size;
END;

END.
