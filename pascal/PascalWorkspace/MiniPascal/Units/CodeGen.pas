(* Code generator for MiniPascal/MidiPascal compiler. *)
{GHO, 2.5.2011}
UNIT CodeGen;

INTERFACE

USES CodeDef;

(* Resets code generator. *)
PROCEDURE ResetCodeGenerator;

(* Emits op code. *)
(* IN opC: Op code to emit. *)
PROCEDURE Emit1(opC: OpCode);

(* Emits op code with single argument. *)
(* IN opC: Op code to emit. *)
(* IN arg: Argument to emit. *)
PROCEDURE Emit2(opC: OpCode; arg: INTEGER);

(* Gets current address. *)
(* RETURNS: Current address. *)
FUNCTION CurrentAddress: INTEGER;

(* Fixes jump target. *)
(* IN posOfJumpTarget: Position in code where jump address is. *)
(* IN addrToJumpTo: Address where jump target should point to. *)
PROCEDURE FixUpJumpTarget(posOfJumpTarget, addrToJumpTo: INTEGER);

(* Writes currently stored bytecode to given file. *)
(* REF file: File to write currently stored bytecode to. *)
PROCEDURE WriteCodeToFile(VAR outputFile: FILE);

IMPLEMENTATION

TYPE
	CodeArray = ARRAY[1..1] OF BYTE;
	CodeArrayPtr = ^CodeArray;

VAR
	code: CodeArrayPtr;
	currentCapacity: LONGINT;
	currentPosition: LONGINT;

PROCEDURE EmitByte(b: BYTE);
VAR
	newArr: CodeArrayPtr;
	i: LONGINT;
BEGIN
	IF currentPosition = currentCapacity THEN BEGIN
		GetMem(newArr, 2 * currentCapacity * SizeOf(BYTE));
		FOR i := 1 TO currentPosition DO
			(*$R-*) newArr^[i] := code^[i] (*$R+*);
		FreeMem(code, currentCapacity * SizeOf(BYTE));
		code := newArr;
		currentCapacity := currentCapacity * 2;
	END;
	Inc(currentPosition);
	(*$R-*)
	code^[currentPosition] := b;
	(*$R+*)
END;

PROCEDURE EmitWord(w: INTEGER);
BEGIN
	EmitByte(w DIV 256);
	EmitByte(w MOD 256);
END;

PROCEDURE ResetCodeGenerator;
BEGIN
	IF code <> NIL THEN BEGIN
		FreeMem(code, currentCapacity * SizeOf(BYTE));
		code := NIL;
	END;
	currentCapacity := 10;
	GetMem(code, currentCapacity * SizeOf(BYTE));
	currentPosition := 0;
END;

PROCEDURE Emit1(opC: OpCode);
BEGIN
	EmitByte(Ord(opC));
END;

PROCEDURE Emit2(opC: OpCode; arg: INTEGER);
BEGIN
	EmitByte(Ord(opC));
	EmitWord(arg);
END;

FUNCTION CurrentAddress: INTEGER;
BEGIN
	CurrentAddress := currentPosition + 1;
END;

PROCEDURE FixUpJumpTarget(posOfJumpTarget, addrToJumpTo: INTEGER);
VAR
	temp: LONGINT;
BEGIN
	temp := currentPosition;
	currentPosition := posOfJumpTarget - 1;
	EmitWord(addrToJumpTo);
	currentPosition := temp;
END;

PROCEDURE WriteCodeToFile(VAR outputFile: FILE);
BEGIN
	BlockWrite(outputFile, code^, currentPosition);
END;

BEGIN
	code := NIL;
	ResetCodeGenerator;
END.
