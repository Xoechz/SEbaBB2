PROGRAM MPI;

USES
MpiInterpreter;

VAR 
  f: text;
  errorCode: Byte;
  ok: boolean;
  errorCol, errorLine: integer;
  errMessage: string;
BEGIN
  IF ParamCount <> 1 THEN
    BEGIN
      WriteLn('Usage: mpi <input file>');
      Halt(1);
    END;

  Assign(f, ParamStr(1));
  {$I-}
  Reset(f);
  {$I+}
  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      WriteLn('Error opening file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END;

  Parse(f, ok, errorLine, errorCol, errMessage);
  Close(f);
  IF ok THEN
    BEGIN
      WriteLn('Execution completed.')
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