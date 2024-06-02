(* Symbol table for MiniPascal/MidiPascal compiler. *)
(* GHO, 13.05.2017 *)
UNIT SymTblC;

INTERFACE

(* Resets symbol table clearing all declared variables. *)
PROCEDURE ResetSymbolTable;

(* Declares new variable. *)
(* IN name: Name of variable to declare. *)
(* OUT ok: True if declaration was successful, false if variable has already been declared before. *)
PROCEDURE DeclareVar(name: STRING; VAR ok: BOOLEAN);

(* Checks if variable is declared. *)
(* IN name: Name of variable to check. *)
(* RETURNS: True if variable is declared. *)
FUNCTION IsDeclared(name: STRING): BOOLEAN;

(* Gets address of variable. *)
(* IN name: Name of variable to get address of. *)
(* RETURNS: Address of variable. *)
FUNCTION AddressOf(name: STRING): INTEGER;

IMPLEMENTATION

TYPE
	Variable = ^VariableRec;
	VariableRec = RECORD
		name: STRING;
		address: INTEGER;
		next: Variable;
	END;
	VariableList = Variable;

VAR
	variables: VariableList;
	nextAddress: INTEGER;

FUNCTION LookUp(name: STRING): INTEGER;
VAR
	found: BOOLEAN;
	v: Variable;
BEGIN
	LookUp := 0;
	found := FALSE;
	v := variables;
	WHILE (NOT found) AND (v <> NIL) DO BEGIN
		IF v^.name = name THEN BEGIN
			LookUp := v^.address;
			found := TRUE;
		END;
		v := v^.next;
	END;
END;

PROCEDURE ResetSymbolTable;
VAR
	next: Variable;
BEGIN
	WHILE variables <> NIL DO BEGIN
		next := variables^.next;
		Dispose(variables);
		variables := next;
	END;
	nextAddress := 1;
END;

PROCEDURE DeclareVar(name: STRING; VAR ok: BOOLEAN);
VAR
	v: Variable;
BEGIN
	IF IsDeclared(name) THEN
		ok := FALSE
	ELSE BEGIN
		New(v);
		v^.name := name;
		v^.address := nextAddress;
		v^.next := variables;
		variables := v;
		Inc(nextAddress);
		ok := TRUE;
	END;
END;

FUNCTION IsDeclared(name: STRING): BOOLEAN;
BEGIN
	IsDeclared := LookUp(name) <> 0;
END;

FUNCTION AddressOf(name: STRING): INTEGER;
BEGIN
	AddressOf := LookUp(name);
END;

BEGIN
	variables := NIL;
	ResetSymbolTable;
END.
