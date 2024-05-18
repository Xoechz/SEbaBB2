PROGRAM TestParser;

USES
MpiParser;

VAR 
  f: text;
  errorCode: Byte;
  ok: boolean;
  errorCol, errorLine: integer;
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

  Parse(f, ok, errorLine, errorCol);
  Close(f);
  IF ok THEN
    WriteLn('Expression is correct')
  ELSE
    WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
END.