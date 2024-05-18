
UNIT MpiParser;

INTERFACE

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer);

IMPLEMENTATION

USES
MpiScanner;

VAR 
  success: boolean;

PROCEDURE MP; Forward;
PROCEDURE VarBlock; Forward;
PROCEDURE Variable; Forward;
PROCEDURE StatementSeq; Forward;
PROCEDURE Statement; Forward;
PROCEDURE Expr; Forward;
PROCEDURE Term; Forward;
PROCEDURE Fact; Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer);
BEGIN
  success := TRUE;
  InitScanner(inputFile);
  MP();
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
END;

PROCEDURE MP;
BEGIN
  IF GetCurrentSymbol() <> programSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  IF GetCurrentSymbol() <> identSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  IF GetCurrentSymbol() <> semicolonSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  VarBlock();
  IF NOT success THEN exit;

  IF GetCurrentSymbol() <> beginSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  StatementSeq();
  IF NOT success THEN exit;

  IF GetCurrentSymbol() <> endSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  IF GetCurrentSymbol() <> periodSym THEN
    BEGIN
      success := false;
      exit;
    END;
END;

PROCEDURE VarBlock;
BEGIN
  IF GetCurrentSymbol() <> varSym THEN
    BEGIN
      exit;
    END;

  ReadNextSymbol();

  Variable();
  IF NOT success THEN exit;

  WHILE GetCurrentSymbol() = identSym DO
    BEGIN
      ReadNextSymbol();
      Variable();
      IF NOT success THEN exit;
    END;
END;

PROCEDURE Variable;
BEGIN
  IF GetCurrentSymbol() <> identSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  WHILE GetCurrentSymbol() = commaSym DO
    BEGIN
      ReadNextSymbol();
      IF GetCurrentSymbol() <> identSym THEN
        BEGIN
          success := false;
          exit;
        END;

      ReadNextSymbol();
    END;

  IF (GetCurrentSymbol() <> colonSym) THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  IF (GetCurrentSymbol() <> integerSym) THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();

  IF GetCurrentSymbol() <> semicolonSym THEN
    BEGIN
      success := false;
      exit;
    END;

  ReadNextSymbol();
END;

PROCEDURE StatementSeq;
BEGIN
  Statement();
  IF NOT success THEN exit;

  WHILE GetCurrentSymbol() = semicolonSym DO
    BEGIN
      ReadNextSymbol();
      Statement();
      IF NOT success THEN exit;
    END;
END;

PROCEDURE Statement;
BEGIN
  CASE GetCurrentSymbol() OF 
    identSym:
              BEGIN
                ReadNextSymbol();
                IF GetCurrentSymbol() <> assignSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;
                ReadNextSymbol();
                Expr();
                IF NOT success THEN exit;
              END;
    readSym:
             BEGIN
               ReadNextSymbol();
               IF GetCurrentSymbol() <> leftParSym THEN
                 BEGIN
                   success := FALSE;
                   Exit;
                 END;
               ReadNextSymbol();
               IF GetCurrentSymbol() <> identSym THEN
                 BEGIN
                   success := FALSE;
                   Exit;
                 END;
               ReadNextSymbol();
               IF GetCurrentSymbol() <> rightParSym THEN
                 BEGIN
                   success := FALSE;
                   Exit;
                 END;
               ReadNextSymbol();
             END;
    writeSym:
              BEGIN
                ReadNextSymbol();
                IF GetCurrentSymbol() <> leftParSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;
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
        Exit;
      END;
  END;
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
    identSym:
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