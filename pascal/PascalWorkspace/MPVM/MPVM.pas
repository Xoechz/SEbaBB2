(* MiniPascal/MidiPascal VM. *)
(* GHO, 13.05.2017 *)
PROGRAM MPVM;

USES MPVMImpl;

VAR
	mode: ExecutionMode;
	success: BOOLEAN;
BEGIN
	mode := Run;
	success := TRUE;
	IF (ParamCount < 1) OR (ParamCount > 2) THEN
		success := FALSE
	ELSE IF ParamCount > 1 THEN BEGIN
		IF ParamStr(2) = '-v' THEN
			mode := RunVerbose
		ELSE IF ParamStr(2) = '-d' THEN
			mode := DisassembleOnly
		ELSE
			success := FALSE;
	END;

	IF NOT success THEN BEGIN
		WriteLn('USAGE: mpvm <codefile> [ -v | -d ]');
		WriteLn('  -v(erbose)       executes prgram in single step mode displaying op-codes.');
		WriteLn('  -d(isassemble)   displays op-codes only.');
	END ELSE
		Interpret(ParamStr(1), mode);
END.
