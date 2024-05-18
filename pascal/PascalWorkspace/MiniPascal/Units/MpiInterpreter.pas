
UNIT MpiInterpreter;

INTERFACE

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING);

IMPLEMENTATION

USES
MpiScanner, SymTbl;

VAR 
  success: boolean;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN
  success := FALSE;
  errMessage := message;
END;

PROCEDURE MP; Forward;
PROCEDURE VarBlock; Forward;
PROCEDURE Variable; Forward;
PROCEDURE StatementSeq; Forward;
PROCEDURE Statement; Forward;
PROCEDURE Expr(VAR e: integer); Forward;
PROCEDURE Term(VAR t: integer); Forward;
PROCEDURE Fact(VAR f: integer); Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING);
BEGIN
  success := TRUE;
  errMessage := '';
  InitScanner(inputFile);
  MP();
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
  errorMessage := errMessage;
END;

PROCEDURE MP;
BEGIN
  IF GetCurrentSymbol() <> programSym THEN
    BEGIN
      success := false;
      exit;
    END;

  {sem}ResetSymbolTable();{endsem}
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

  ReadNextSymbol();
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
VAR 
{local} ok : boolean;{endlocal}
BEGIN
  IF GetCurrentSymbol() <> identSym THEN
    BEGIN
      success := false;
      exit;
    END;

  {sem}
  DeclareVar(GetCurrentIdentName(), ok);
  IF NOT ok THEN
    BEGIN
      SemErr('Variable already declared');
      exit;
    END;
  {endsem}

  ReadNextSymbol();

  WHILE GetCurrentSymbol() = commaSym DO
    BEGIN
      ReadNextSymbol();
      IF GetCurrentSymbol() <> identSym THEN
        BEGIN
          success := false;
          exit;
        END;

      {sem}
      DeclareVar(GetCurrentIdentName(), ok);
      IF NOT ok THEN
        BEGIN
          SemErr('Variable already declared');
          exit;
        END;
      {endsem}

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
{local}VAR temp: integer; identName: STRING;{endlocal}
BEGIN
  CASE GetCurrentSymbol() OF 
    identSym:
              BEGIN
                {sem}
                identName := GetCurrentIdentName();
                IF NOT IsDeclared(identName) THEN
                  BEGIN
                    SemErr('Variable not declared');
                    Exit;
                  END;
                {endsem}

                ReadNextSymbol();
                IF GetCurrentSymbol() <> assignSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;

                ReadNextSymbol();
                Expr(temp);
                IF NOT success THEN exit;
                {sem}SetValue(identName, temp);{endsem}
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

              {sem}
               identName := GetCurrentIdentName();
               IF NOT IsDeclared(identName) THEN
                 BEGIN
                   SemErr('Variable not declared');
                   Exit;
                 END;
               Read(temp);
               SetValue(identName, temp);
              {endsem}

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
                Expr(temp);
                IF NOT success THEN exit;
                {sem}writeln(temp);{endsem}

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
                 {sem} f := sign * GetCurrentNumberValue(); {endsem}
                 ReadNextSymbol();
               END;
    identSym:
              BEGIN
                {sem}
                IF NOT IsDeclared(GetCurrentIdentName()) THEN
                  BEGIN
                    SemErr('Variable not declared');
                    Exit;
                  END
                ELSE IF NOT IsAssingned(GetCurrentIdentName()) THEN
                       BEGIN
                         semErr('Variable not assigned');
                         exit;
                       END;
                f := sign * GetValue(GetCurrentIdentName());
                {endsem}
                ReadNextSymbol();
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