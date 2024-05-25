(* Implementation of MiniPascal/MidiPascal VM. *)
(* GHO, 20.05.2017 *)
UNIT MPVMImpl;

INTERFACE

TYPE
	(* Execution mode *)
	ExecutionMode = (
		(* Execute code in regular fashion. *)
		Run,
		(* Execute code step by step and display op codes. *)
		RunVerbose,
		(* Only display op codes without executing code. *)
		DisassembleOnly
	);

(* Interprets given code file. *)
(* IN string: Code file to interpret. *)
(* IN mode: Interpreter mode. *)
PROCEDURE Interpret(filename: STRING; mode: ExecutionMode);

IMPLEMENTATION

USES CodeDef, CodeRdr, IntVect;

VAR
	stack: IntegerVector;
	storage: IntegerVector;

PROCEDURE ExecError(msg: STRING);
BEGIN
	WriteLn('RUNTIME ERROR: ', msg);
	Halt;
END;

(* === STACK ========== *)

PROCEDURE InitStack;
BEGIN
	Clear(stack);
END;

PROCEDURE Push(val: INTEGER);
BEGIN
	AddElement(stack, val);
END;

PROCEDURE Pop(VAR val: INTEGER);
BEGIN
	IF GetSize(stack) = 0 THEN
		ExecError('Stack underflow.');
	RemoveLastElement(stack, val);
END;

(* === STORAGE ========== *)

PROCEDURE InitStorage;
BEGIN
	Clear(storage);
END;

PROCEDURE CheckAddress(addr: INTEGER);
BEGIN
	IF addr < 1 THEN
		ExecError('Invalid variable address.');
END;

FUNCTION GetVariableValue(addr: INTEGER): INTEGER;
VAR
	value: INTEGER;
BEGIN
	GetElementAt(storage, addr, value);
	GetVariableValue := value;
END;

PROCEDURE SetVariableValue(addr, value: INTEGER);
BEGIN
	SetElementAt(storage, addr, value);
END;

(* === VM ========== *)

PROCEDURE InterpretCode(filename: STRING; run, verbose: BOOLEAN);
VAR
	ok: BOOLEAN;
	opC: OpCode;
	val, val2: INTEGER;
BEGIN
	InitCodeReader(fileName, ok);
	IF NOT ok THEN
		ExecError('Cannot load code from file.');

	InitStack;
	InitStorage;

	IF verbose THEN
		Write(CurrentAddress:3, ':   ');
	FetchOpCode(opC);
	WHILE (opC <> endOpc) DO BEGIN
		CASE opC OF
			loadConstOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('LoadConst ', val);
				IF run THEN
					Push(val);
			END;
			loadValOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('LoadVal ', val);
				IF run THEN BEGIN
					CheckAddress(val);
					Push(GetVariableValue(val));
				END;
			END;
			storeOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('Store ', val);
				IF run THEN BEGIN
					CheckAddress(val);
					Pop(val2);
					SetVariableValue(val, val2);
				END;
			END;
			addOpc: BEGIN
				IF verbose THEN	WriteLn('Add');
				IF run THEN BEGIN
					Pop(val);
					Pop(val2);
					Push(val2 + val);
				END;
			END;
			subOpc: BEGIN
				IF verbose THEN	WriteLn('Sub');
				IF run THEN BEGIN
					Pop(val);
					Pop(val2);
					Push(val2 - val);
				END;
			END;
			multOpc: BEGIN
				IF verbose THEN	WriteLn('Mul');
				IF run THEN BEGIN
					Pop(val);
					Pop(val2);
					Push(val2 * val);
				END;
			END;
			divOpc: BEGIN
				IF verbose THEN	WriteLn('Div');
				IF run THEN BEGIN
					Pop(val);
					IF val = 0 THEN
						ExecError('Division by zero.');
					Pop(val2);
					Push(val2 DIV val);
				END;
			END;
			readOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('Read ', val);
				IF run THEN BEGIN
					CheckAddress(val);
					ReadLn(val2);
					SetVariableValue(val, val2);
				END;
			END;
			writeOpc: BEGIN
				IF verbose THEN	WriteLn('Write');
				IF run THEN BEGIN
					Pop(val);
					WriteLn(val);
				END;
			END;
			jumpOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('Jump ', val);
				IF run THEN
					JumpToAddress(val);
			END;
			jumpZeroOpc: BEGIN
				FetchArgument(val);
				IF verbose THEN	WriteLn('JumpZero ', val);
				IF run THEN BEGIN
					Pop(val2);
					IF val2 = 0 THEN
						JumpToAddress(val);
				END;
			END;
			ELSE ExecError('Invalid op code found.');
		END;
		IF run AND verbose THEN
			ReadLn; (* single step mode *)
		IF verbose THEN
			Write(CurrentAddress:3, ':   ');
		FetchOpCode(opC);
	END;
	IF verbose THEN	WriteLn('End');
END;

PROCEDURE Interpret(filename: STRING; mode: ExecutionMode);
BEGIN
	CASE mode OF
		Run: InterpretCode(filename, TRUE, FALSE);
		RunVerbose: InterpretCode(filename, TRUE, TRUE);
		DisassembleOnly: InterpretCode(filename, FALSE, TRUE);
	END;
END;

BEGIN
	InitIntegerVector(stack);
	InitIntegerVector(storage);
END.
