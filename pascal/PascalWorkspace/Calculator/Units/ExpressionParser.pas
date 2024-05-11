
UNIT ExpressionParser;

INTERFACE

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer);

IMPLEMENTATION

USES
ExpressionScanner;

VAR 
  success: boolean;

PROCEDURE Expr; Forward;
PROCEDURE Term; Forward;
PROCEDURE Fact; Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer);
BEGIN
  success := TRUE;
  InitScanner(inputFile);
  Expr();
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
END;

PROCEDURE Expr;
BEGIN
  Term();
  IF NOT success THEN exit;

  WHILE (GetCurrentSymbol() = plusSym) OR (GetCurrentSymbol() = minusSym) DO
    BEGIN
      CASE GetCurrentSymbol() OF 
        plusSym:
                 BEGIN
                   ReadNextSymbol();
                   Term();
                   IF NOT success THEN exit;
                 END;
        minusSym:
                  BEGIN
                    ReadNextSymbol();
                    Term();
                    IF NOT success THEN exit;
                  END;
      END;
    END;
END;

PROCEDURE Term;
BEGIN
  Fact();
  IF NOT success THEN exit;

  WHILE (GetCurrentSymbol() = multSym) OR (GetCurrentSymbol() = divSym) DO
    BEGIN
      CASE GetCurrentSymbol() OF 
        multSym:
                 BEGIN
                   ReadNextSymbol();
                   Fact();
                   IF NOT success THEN exit;
                 END;
        divSym:
                BEGIN
                  ReadNextSymbol();
                  Fact();
                  IF NOT success THEN exit;
                END;
      END;
    END;
END;

PROCEDURE Fact;
BEGIN
  CASE GetCurrentSymbol() OF 
    minusSym:
              BEGIN
                ReadNextSymbol();
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
               END;
    leftParSym:
                BEGIN
                  ReadNextSymbol();
                  Expr();
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