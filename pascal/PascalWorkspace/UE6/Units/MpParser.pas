
UNIT MpParser;

INTERFACE

USES
CodeDef;

PROCEDURE Parse(inFileName: STRING; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; VAR code: CodeArray);

IMPLEMENTATION

USES
MpScanner, SymTblC, CodeGen, ExpressionParser, ExpressionTree;

VAR 
  success: boolean;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN
  success := FALSE;
  errMessage := message;
END;

PROCEDURE EmitCodeForExprNode(t: TreePtr);
VAR 
  n: integer;
  errorCode: WORD;
  errorCodeString: STRING;
BEGIN
  IF (t <> NIL) THEN
    BEGIN
      EmitCodeForExprNode(t^.left);
      EmitCodeForExprNode(t^.right);

      IF (Length(t^.val) = 0) THEN
        BEGIN
          SemErr('Invalid Expression Node');
          exit;
        END;

      IF (t^.isNumber) THEN
        BEGIN
          Val(t^.val, n, errorCode);
          IF (errorCode <> 0) THEN
            BEGIN
              Str(errorCode, errorCodeString);
              SemErr(Concat('Invalid Number ', t^.val, ' (Error Code: ', errorCodeString, ')'));
              exit;
            END;
          Emit2(LoadConstOpc, n);
        END
      ELSE
        IF (t^.val = '+') THEN
          BEGIN
            Emit1(AddOpc)
          END
      ELSE
        IF (t^.val = '-') THEN
          BEGIN
            Emit1(SubOpc)
          END
      ELSE
        IF (t^.val = '*') THEN
          BEGIN
            Emit1(MulOpc)
          END
      ELSE
        IF (t^.val = '/') THEN
          BEGIN
            Emit1(DivOpc)
          END
      ELSE
        BEGIN
          Emit2(LoadValOpc, AddressOF(t^.val));
        END
    END;
END;

PROCEDURE EmitCodeForExprTree(t: TreePtr);
VAR 
  ok: boolean;
BEGIN
  PrintTreePostOrder(t);
  WriteLn();
  OptimizeTree(t, ok);
  PrintTreePostOrder(t);
  WriteLn();

  IF NOT ok THEN
    BEGIN
      SemErr('Division by zero in expression.');
      DisposeTree(t);
      Exit;
    END;

  EmitCodeForExprNode(t);
  DisposeTree(t);
END;

PROCEDURE MP(VAR code: CodeArray); Forward;
PROCEDURE VarBlock; Forward;
PROCEDURE Variable; Forward;
PROCEDURE StatementSeq; Forward;
PROCEDURE Statement; Forward;

PROCEDURE Parse(inFileName: STRING; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; VAR code: CodeArray);
VAR 
  inputFile: Text;
  errCodeStr: STRING;
BEGIN
  success := TRUE;
  errMessage := '';

  Assign(inputFile, inFileName);
  {$I-}
  Reset(inputFile);
  {$I+}
  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN
      str(errorCode, errCodeStr);
      errorMessage := Concat('Error opening input file: ', inFileName, ' (error code: ', errCodeStr, ')');
      ok := FALSE;
      errorCol := 0;
      errorLine := 0;
      EXIT;
    END;

  InitScanner(inputFile);
  MP(code);
  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
  errorMessage := errMessage;
END;

PROCEDURE MP(VAR code: CodeArray);
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
  GetCode(code);
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
{local}
VAR 
  identName: STRING;
  addr1, addr2: INTEGER;
  exprTree: TreePtr;
{endlocal}
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
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit2(storeOpc, AddressOF(identName));
                {endsem}
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
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit1(writeOpc);
                {endsem}

                IF GetCurrentSymbol() <> rightParSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;
                ReadNextSymbol();
              END;
    beginSym:
              BEGIN
                ReadNextSymbol();
                StatementSeq();
                IF NOT success THEN exit;

                IF GetCurrentSymbol() <> endSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;
                ReadNextSymbol();
              END;
    ifSym:
           BEGIN
             ReadNextSymbol();
             ParseExpression(exprTree, success, errMessage);
             IF NOT success THEN exit;

            {sem}
             EmitCodeForExprTree(exprTree);
             IF NOT success THEN exit;
             Emit2(JmpZOpc, 0);
             addr1 := CurAddr() - 2;
            {endsem}

             IF GetCurrentSymbol() <> thenSym THEN
               BEGIN
                 success := FALSE;
                 Exit;
               END;

             ReadNextSymbol();
             Statement();
             IF NOT success THEN exit;

             IF GetCurrentSymbol() = elseSym THEN
               BEGIN
                {sem}
                 Emit2(JmpZOpc, 0);
                 FixUp(addr1, CurAddr());
                 addr1 := CurAddr() - 2;
                {endsem}

                 ReadNextSymbol();
                 Statement();
                 IF NOT success THEN exit;
               END;

            {sem}FixUp(addr1, CurAddr());{endsem}
           END;
    whileSym:
              BEGIN
                ReadNextSymbol();
                {sem}addr1 := CurAddr();{endsem}
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit2(JmpZOpc, 0);
                addr2 := CurAddr() - 2;
                {endsem}

                IF GetCurrentSymbol() <> doSym THEN
                  BEGIN
                    success := FALSE;
                    Exit;
                  END;

                ReadNextSymbol();
                Statement();

                {sem}
                Emit2(JmpOpc, addr1);
                FixUp(addr2, CurAddr());
                {endsem}
              END;
    ELSE
      BEGIN
        Exit;
      END;
  END;
END;

END.