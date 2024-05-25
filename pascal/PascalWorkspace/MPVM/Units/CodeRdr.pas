(* Helper unit for reading MiniPascal/MidiPascal code file. *)
(* GHO, 13.05.2017 *)
UNIT CodeRdr;

INTERFACE

USES CodeDef;

(* Reads code file and initializes code reader. *)
(* IN filename: Code file to read. *)
(* OUT ok: True if code file could be successfully read. *)
PROCEDURE InitCodeReader(filename: STRING; VAR ok: BOOLEAN);

(* Reads op code and advances in code. *)
(* OUT opC: Op code read from code. *)
PROCEDURE FetchOpCode(VAR opC: OpCode);

(* Reads argument and advances in code. *)
(* OUT arg: Argument read from code. *)
PROCEDURE FetchArgument(VAR arg: INTEGER);

(* Gets current position in code. *)
(* RETURNS: Current position in code. *)
FUNCTION CurrentAddress: INTEGER;

(* Jumps to position in code. *)
(* IN addr: Address of position in code where to jump to. *)
PROCEDURE JumpToAddress(addr: INTEGER);

IMPLEMENTATION

TYPE
	CodeArray = ARRAY[1..1] OF BYTE;
	CodeArrayPtr = ^CodeArray;

VAR
	code: CodeArrayPtr;
	codeLength: LONGINT;
	currentPosition: LONGINT;

FUNCTION FetchByte: BYTE;
BEGIN
	IF currentPosition > codeLength THEN BEGIN
		WriteLn('CodeRdr.FetchByte: End of code reached.');
		Halt;
	END;
	(*$R-*)
	FetchByte := code^[currentPosition];
	(*$R+*)
	Inc(currentPosition);
END;

PROCEDURE InitCodeReader(filename: STRING; VAR ok: BOOLEAN);
VAR
	codeFile: FILE;
BEGIN
	IF code <> NIL THEN BEGIN
		FreeMem(code, codeLength * SizeOf(BYTE));
		codeLength := 0;
		code := NIL;
	END;
	Assign(codeFile, filename);
	(*$I-*)
	Reset(codeFile, 1);
	(*$I+*)
	IF IOResult <> 0 THEN
		ok := FALSE
	ELSE BEGIN
		codeLength := FileSize(codeFile);
		GetMem(code, codeLength * SizeOf(BYTE));
		BlockRead(codeFile, code^, codeLength);
		Close(codeFile);
		ok := TRUE;
	END;
END;


PROCEDURE FetchOpCode(VAR opC: OpCode);
BEGIN
	opC := OpCode(FetchByte);
END;

PROCEDURE FetchArgument(VAR arg: INTEGER);
BEGIN
	arg := FetchByte * 256;
	arg := arg + FetchByte;
END;

FUNCTION CurrentAddress: INTEGER;
BEGIN
	CurrentAddress := currentPosition;
END;

PROCEDURE JumpToAddress(addr: INTEGER);
BEGIN
	IF (addr < 1) OR (addr > codeLength) THEN BEGIN
		WriteLn('CodeRdr.JumpToAddress: Invalid address to jump to.');
		Halt;
	END;
	currentPosition := addr;
END;

BEGIN
	code := NIL;
	codeLength := 0;
	currentPosition := 1;
END.
