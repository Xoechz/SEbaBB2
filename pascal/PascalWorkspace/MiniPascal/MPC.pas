PROGRAM MPC;

USES
MpcCompiler;

VAR 
  inputFile: text;
  errorCode: Byte;
  outputFile: FILE OF Byte;
  ok: boolean;
  errorCol, errorLine: integer;
  errMessage: string;
BEGIN
  IF (ParamCount < 1) OR (ParamCount > 2) THEN
    BEGIN
      WriteLn('Usage: mpc <input file> [<output file>]');
      Halt(1);
    END;

  Assign(inputFile, ParamStr(1));
  {$I-}
  Reset(inputFile);
  {$I+}
  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      WriteLn('Error opening input file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END;

  IF ParamCount = 2 THEN
    BEGIN
      Assign(outputFile, ParamStr(2));
    END
  ELSE
    BEGIN
      Assign(outputFile, ParamStr(1) + 'c');
    END;

  {$I-}
  Rewrite(outputFile);
  {$I+}
  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      WriteLn('Error opening output file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END;

  Parse(inputFile, ok, errorLine, errorCol, errMessage, outputFile);
  Close(outputFile);
  Close(inputFile);
  IF ok THEN
    BEGIN
      WriteLn('Compilation completed.')
    END
  ELSE
    IF errMessage <> '' THEN
      BEGIN
        WriteLn('Error: ', errMessage, ' at line ', errorLine, ' column ', errorCol);
      END
  ELSE
    BEGIN
      WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
    END;
END.