PROGRAM TestEvaluator;

USES
ExpressionEvaluator;

VAR 
  f: text;
  ok: boolean;
  errorCol, errorLine, result: integer;
  errMessage: string;
BEGIN
  Assign(f, '../TestFiles/expressionScanner.txt');
  Reset(f);
  Parse(f, ok, errorLine, errorCol, result, errMessage);
  WriteLn('Parse result: ', ok);
  Close(f);
  IF ok THEN
    BEGIN
      WriteLn('Result: ', result)
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