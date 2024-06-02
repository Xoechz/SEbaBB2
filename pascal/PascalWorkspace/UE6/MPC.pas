PROGRAM MPC;

USES
MpCompiler;

VAR 
  inputFile: text;
  errorCode: Byte;
  ok: boolean;
  errorCol, errorLine: integer;
  errMessage, outputFileName: string;
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
      outputFileName :=  ParamStr(2);
    END
  ELSE
    BEGIN
      outputFileName := ParamStr(1) + 'c';
    END;

  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      WriteLn('Error opening output file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END;

  Parse(inputFile, ok, errorLine, errorCol, errMessage, outputFileName);
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