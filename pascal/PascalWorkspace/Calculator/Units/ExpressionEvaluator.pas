
UNIT ExpressionEvaluator;

INTERFACE

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol, result: integer; VAR errorMessage: STRING);

IMPLEMENTATION

USES
ExpressionScanner;

VAR 
  success: boolean;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN
  success := FALSE;
  errMessage := message;
END;

PROCEDURE Expr(VAR e: integer); Forward;
PROCEDURE Term(VAR t: integer); Forward;
PROCEDURE Fact(VAR f: integer); Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol, result: integer; VAR errorMessage: STRING);
BEGIN
  success := TRUE;
  errMessage := '';
  InitScanner(inputFile);
  Expr(result);
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
  errorMessage := errMessage;
END;

PROCEDURE Expr(VAR e: integer);
{local} VAR temp: integer; {endlocal}
BEGIN
  Term(e);
  IF NOT success THEN exit;

  WHILE (GetCurrentSymbol() = plusSym) OR (GetCurrentSymbol() = minusSym) DO
    BEGIN
      CASE GetCurrentSymbol() OF 
        plusSym:
                 BEGIN
                   ReadNextSymbol();
                   Term(temp);
                   {sem} e := e + temp; {endsem}
                   IF NOT success THEN exit;
                 END;
        minusSym:
                  BEGIN
                    ReadNextSymbol();
                    Term(temp);
                    {sem} e := e - temp; {endsem}
                    IF NOT success THEN exit;
                  END;
      END;
    END;
END;

PROCEDURE Term(VAR t: integer);
{local} VAR temp: integer; {endlocal}
BEGIN
  Fact(t);
  IF NOT success THEN exit;

  WHILE (GetCurrentSymbol() = multSym) OR (GetCurrentSymbol() = divSym) DO
    BEGIN
      CASE GetCurrentSymbol() OF 
        multSym:
                 BEGIN
                   ReadNextSymbol();
                   Fact(temp);
                   {sem} t := t * temp; {endsem}
                   IF NOT success THEN exit;
                 END;
        divSym:
                BEGIN
                  ReadNextSymbol();
                  Fact(temp);
                  {sem}
                  IF temp = 0 THEN
                    BEGIN
                      SemErr('Division by zero!');
                      Exit;
                    END;
                  t := t DIV temp;
                  {endsem}
                  IF NOT success THEN exit;
                END;
      END;
    END;
END;

PROCEDURE Fact(VAR f: integer);
{local} VAR temp, sign: integer; {endlocal}
BEGIN
  sign := 1;
  CASE GetCurrentSymbol() OF 
    minusSym:
              BEGIN
                ReadNextSymbol();
                sign := -1;
              END;
    plusSym:
             BEGIN
               ReadNextSymbol();
             END;
  END;

  CASE GetCurrentSymbol() OF 
    numberSym:
               BEGIN
                 ReadNextSymbol();
                  {sem} f := sign * GetCurrentNumberValue(); {endsem}
               END;
    leftParSym:
                BEGIN
                  ReadNextSymbol();
                  Expr(temp);
                  {sem} f := sign * temp; {endsem}
                  IF NOT success THEN exit;

                  IF GetCurrentSymbol() <> rightParSym THEN
                    BEGIN
                      success := FALSE;
                      Exit;
                    END;
                  ReadNextSymbol();
                END;
    ELSE
      BEGIN
        success := FALSE;
        Exit;
      END;
  END;
END;

END.