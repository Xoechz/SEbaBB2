PROGRAM TestParser;

USES
ExpressionParser;

VAR 
  f: text;
  ok: boolean;
  errorCol, errorLine: integer;
BEGIN
  Assign(f, '../TestFiles/expressionScanner.txt');
  Reset(f);
  Parse(f, ok, errorLine, errorCol);
  WriteLn('Parse result: ', ok);
  Close(f);
  IF ok THEN
    WriteLn('Expression is correct')
  ELSE
    WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
END.