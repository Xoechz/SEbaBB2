PROGRAM PrintSymbols;

USES
ExpressionScanner;

VAR 
  f: text;
BEGIN
  Assign(f, '../TestFiles/expressionScanner.txt');
  Reset(f);
  InitScanner(f);
  WHILE (GetCurrentSymbol() <> noSym) DO
    BEGIN
      Write('Symbol: ', GetCurrentSymbol());
      IF (GetCurrentSymbol() = numberSym) THEN
        BEGIN
          Write(' Value: ', GetCurrentNumberValue());
        END;

      WriteLn();
      ReadNextSymbol();
    END;
END.