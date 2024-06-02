
UNIT MpCompiler;

INTERFACE

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; outputFileName: STRING);

IMPLEMENTATION

USES
MpScanner, SymTblC, CodeGen, CodeDef;

VAR 
  success: boolean;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN
  success := FALSE;
  errMessage := message;
END;

PROCEDURE MP(outputFileName: STRING); Forward;
PROCEDURE VarBlock; Forward;
PROCEDURE Variable; Forward;
PROCEDURE StatementSeq; Forward;
PROCEDURE Statement; Forward;
PROCEDURE Expr; Forward;
PROCEDURE Term; Forward;
PROCEDURE Fact; Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; outputFileName: STRING);
BEGIN
  success := TRUE;
  errMessage := '';
  InitScanner(inputFile);
  MP(outputFileName);
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
  errorMessage := errMessage;
END;

PROCEDURE MP(outputFileName: STRING);
{local}VAR ca: CodeArray;{endlocal}
BEGIN
  IF GetCurrentSymbol() <> programSym THEN
    BEGIN
      success := false;
      exit;
    END;

  {sem}
  ResetSymbolTable();
  InitCodeGenerator();
  {endsem}

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

  {sem}
  Emit1(endOpc);
  GetCode(ca);
  StoreCode(outputFileName, ca);
  {endsem}
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
{local}VAR identName: STRING;{endlocal}
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
                Expr();
                IF NOT success THEN exit;
                {sem}Emit2(storeOpc, AddressOF(identName));{endsem}
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
               Emit2(readOpc, AddressOF(identName));
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
                Expr();
                IF NOT success THEN exit;

                {sem}Emit1(writeOpc);{endsem}

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
                   {sem}Emit1(addOpc);{endsem}
                   IF NOT success THEN exit;
                 END;
        minusSym:
                  BEGIN
                    ReadNextSymbol();
                    Term();
                    {sem}Emit1(subOpc);{endsem}
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
                   {sem}Emit1(mulOpc);{endsem}
                   IF NOT success THEN exit;
                 END;
        divSym:
                BEGIN
                  ReadNextSymbol();
                  Fact();
                  {sem}Emit1(divOpc);{endsem}
                  IF NOT success THEN exit;
                END;
      END;
    END;
END;

PROCEDURE Fact;
{local} VAR sign: integer; {endlocal}
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
                 {sem}
                 Emit2(loadConstOpc, GetCurrentNumberValue());
                 Emit2(loadConstOpc, sign);
                 Emit1(mulOpc);
                {endsem}
                 ReadNextSymbol();
               END;
    identSym:
              BEGIN
                {sem}
                IF NOT IsDeclared(GetCurrentIdentName()) THEN
                  BEGIN
                    SemErr('Variable not declared');
                    Exit;
                  END;
                Emit2(loadValOpc, AddressOF(GetCurrentIdentName()));
                Emit2(loadConstOpc, sign);
                Emit1(mulOpc);
                {endsem}
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