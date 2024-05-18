(* Symbol table for MiniPascal/MidiPascal interpreter. *)
(* GHO, 13.05.2017 *)

UNIT SymTbl;

INTERFACE

PROCEDURE ResetSymbolTable;

PROCEDURE DeclareVar(name: STRING; VAR ok: BOOLEAN);
FUNCTION IsDeclared(name: STRING): BOOLEAN;
FUNCTION IsAssingned(name: STRING): BOOLEAN;

PROCEDURE SetValue(name: STRING; value: INTEGER);
FUNCTION GetValue(name: STRING): INTEGER;

IMPLEMENTATION

TYPE 
  Variable = ^VariableRec;
  VariableRec = RECORD
    name: STRING;
    value: INTEGER;
    isAssingned: BOOLEAN;
    next: Variable;
  END;
  VariableList = Variable;

VAR 
  variables: VariableList;

FUNCTION FindVariable(name: STRING): Variable;
VAR 
  v: Variable;
BEGIN
  v := variables;
  WHILE (v <> NIL) AND (v^.name <> name) DO
    v := v^.next;
  FindVariable := v;
END;

PROCEDURE ResetSymbolTable;
VAR 
  next: Variable;
BEGIN
  WHILE variables <> NIL DO
    BEGIN
      next := variables^.next;
      Dispose(variables);
      variables := next;
    END;
END;

PROCEDURE DeclareVar(name: STRING; VAR ok: BOOLEAN);
VAR 
  v: Variable;
BEGIN
  IF IsDeclared(name) THEN
    ok := FALSE
  ELSE
    BEGIN
      New(v);
      v^.name := name;
      v^.value := 0;
      v^.isAssingned := FALSE;
      v^.next := variables;
      variables := v;
      ok := TRUE;
    END;
END;

FUNCTION IsDeclared(name: STRING): BOOLEAN;
BEGIN
  IsDeclared := FindVariable(name) <> NIL;
END;

FUNCTION IsAssingned(name: STRING): BOOLEAN;
VAR 
  v: Variable;
BEGIN
  v := FindVariable(name);
  IF v <> NIL THEN
    IsAssingned := v^.isAssingned
  ELSE
    IsAssingned := FALSE;
END;

PROCEDURE SetValue(name: STRING; value: INTEGER);
VAR 
  v: Variable;
BEGIN
  v := FindVariable(name);
  IF v <> NIL THEN
    BEGIN
      v^.value := value;
      v^.isAssingned := TRUE;
    END;
END;

FUNCTION GetValue(name: STRING): INTEGER;
VAR 
  v: Variable;
BEGIN
  v := FindVariable(name);
  IF v <> NIL THEN
    GetValue := v^.value
  ELSE
    GetValue := 0;
END;

BEGIN
  variables := NIL;
END.