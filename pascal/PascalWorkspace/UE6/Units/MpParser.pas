
UNIT MpParser;

INTERFACE

USES
CodeDef;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; VAR outputFile: FILE);

IMPLEMENTATION

USES
MpScanner, SymTblC, CodeGen, ExpressionParser, ExpressionTree;

VAR 
  success: boolean;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN (* SemErr *)
  success := FALSE;
  errMessage := message;
END; (* SemErr *)

PROCEDURE EmitCodeForExprNode(t: TreePtr);
VAR 
  n: integer;
  errorCode: WORD;
  errorCodeString: STRING;
BEGIN (* EmitCodeForExprNode *)
  IF (t <> NIL) THEN
    BEGIN (* IF *)
      EmitCodeForExprNode(t^.left);
      EmitCodeForExprNode(t^.right);

      IF (Length(t^.val) = 0) THEN
        BEGIN (* IF *)
          SemErr('Invalid Expression Node');
          exit;
        END; (* IF *)

      IF (t^.isNumber) THEN
        BEGIN (* IF *)
          Val(t^.val, n, errorCode);
          IF (errorCode <> 0) THEN
            BEGIN (* IF *)
              Str(errorCode, errorCodeString);
              SemErr(Concat('Invalid Number ', t^.val, ' (Error Code: ', errorCodeString, ')'));
              exit;
            END; (* IF *)
          Emit2(LoadConstOpc, n);
        END (* IF *)
      ELSE
        IF (t^.val = '+') THEN
          BEGIN (* ELSE IF *)
            Emit1(AddOpc)
          END (* ELSE IF *)
      ELSE
        IF (t^.val = '-') THEN
          BEGIN (* ELSE IF *)
            Emit1(SubOpc)
          END (* ELSE IF *)
      ELSE
        IF (t^.val = '*') THEN
          BEGIN (* ELSE IF *)
            Emit1(MultOpc)
          END (* ELSE IF *)
      ELSE
        IF (t^.val = '/') THEN
          BEGIN (* ELSE IF *)
            Emit1(DivOpc)
          END (* ELSE IF *)
      ELSE
        BEGIN (* ELSE *)
          Emit2(LoadValOpc, AddressOF(t^.val));
        END (* ELSE *)
    END; (* IF *)
END; (* EmitCodeForExprNode *)

PROCEDURE EmitCodeForExprTree(t: TreePtr);
VAR 
  ok: boolean;
BEGIN (* EmitCodeForExprTree *)
  WriteLn('Unoptimized Expression Tree:');
  PrintTreePostOrder(t);
  WriteLn();
  OptimizeTree(t, ok);
  WriteLn('Optimized Expression Tree:');
  PrintTreePostOrder(t);
  WriteLn();
  WriteLn();

  IF (NOT ok) THEN
    BEGIN (* IF *)
      SemErr('Division by zero in expression.');
      DisposeTree(t);
      Exit;
    END; (* IF *)

  EmitCodeForExprNode(t);
  DisposeTree(t);
END; (* EmitCodeForExprTree *)

PROCEDURE MP(VAR outputFile: FILE); Forward;
PROCEDURE VarBlock; Forward;
PROCEDURE Variable; Forward;
PROCEDURE StatementSeq; Forward;
PROCEDURE Statement; Forward;

PROCEDURE Parse(VAR inputFile: text; VAR ok: boolean; VAR errorLine, errorCol: integer; VAR errorMessage: STRING; VAR outputFile: FILE);
BEGIN (* Parse *)
  success := TRUE;
  errMessage := '';

  InitScanner(inputFile);
  MP(outputFile);

  ok := success;
  GetCurrentSymbolPosition(errorLine, errorCol);
  errorMessage := errMessage;
END; (* Parse *)

PROCEDURE MP(VAR outputFile: FILE);
BEGIN (* MP *)
  IF GetCurrentSymbol() <> programSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  {sem}
  ResetSymbolTable();
  ResetCodeGenerator();
  {endsem}

  ReadNextSymbol();

  IF GetCurrentSymbol() <> identSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  IF GetCurrentSymbol() <> semicolonSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  VarBlock();
  IF NOT success THEN exit;

  IF GetCurrentSymbol() <> beginSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  StatementSeq();
  IF NOT success THEN exit;

  IF GetCurrentSymbol() <> endSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  IF GetCurrentSymbol() <> periodSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  {sem}
  Emit1(endOpc);
  WriteCodeToFile(outputFile);
  {endsem}
END; (* MP *)

PROCEDURE VarBlock;
BEGIN (* VarBlock *)
  IF GetCurrentSymbol() <> varSym THEN
    BEGIN (* IF *)
      exit;
    END; (* IF *)

  ReadNextSymbol();

  Variable();
  IF NOT success THEN exit;

  WHILE GetCurrentSymbol() = identSym DO
    BEGIN (* WHILE *)
      ReadNextSymbol();
      Variable();
      IF NOT success THEN exit;
    END; (* WHILE *)
END; (* VarBlock *)

PROCEDURE Variable;
VAR 
{local} ok : boolean;{endlocal}
BEGIN (* Variable *)
  IF GetCurrentSymbol() <> identSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  {sem}
  DeclareVar(GetCurrentIdentName(), ok);
  IF NOT ok THEN
    BEGIN (* IF *)
      SemErr('Variable already declared');
      exit;
    END; (* IF *)
  {endsem}

  ReadNextSymbol();

  WHILE GetCurrentSymbol() = commaSym DO
    BEGIN (* WHILE *)
      ReadNextSymbol();
      IF GetCurrentSymbol() <> identSym THEN
        BEGIN (* IF *)
          success := false;
          exit;
        END; (* IF *)

      {sem}
      DeclareVar(GetCurrentIdentName(), ok);
      IF NOT ok THEN
        BEGIN (* IF *)
          SemErr('Variable already declared');
          exit;
        END; (* IF *)
      {endsem}

      ReadNextSymbol();
    END; (* WHILE *)

  IF (GetCurrentSymbol() <> colonSym) THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  IF (GetCurrentSymbol() <> integerSym) THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();

  IF GetCurrentSymbol() <> semicolonSym THEN
    BEGIN (* IF *)
      success := false;
      exit;
    END; (* IF *)

  ReadNextSymbol();
END; (* Variable *)

PROCEDURE StatementSeq;
BEGIN (* StatementSeq *)
  Statement();
  IF NOT success THEN exit;

  WHILE GetCurrentSymbol() = semicolonSym DO
    BEGIN (* WHILE *)
      ReadNextSymbol();
      Statement();
      IF NOT success THEN exit;
    END; (* WHILE *)
END; (* StatementSeq *)

PROCEDURE Statement;
{local}
VAR 
  identName: STRING;
  addr1, addr2: INTEGER;
  exprTree: TreePtr;
{endlocal}
BEGIN (* Statement *)
  CASE GetCurrentSymbol() OF 
    identSym:
              BEGIN (* identSym *)
                {sem}
                identName := GetCurrentIdentName();

                IF NOT IsDeclared(identName) THEN
                  BEGIN (* IF *)
                    SemErr('Variable not declared');
                    Exit;
                  END; (* IF *)
                {endsem}

                ReadNextSymbol();

                IF GetCurrentSymbol() <> assignSym THEN
                  BEGIN (* IF *)
                    success := FALSE;
                    Exit;
                  END; (* IF *)

                ReadNextSymbol();
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit2(storeOpc, AddressOF(identName));
                {endsem}
              END; (* identSym *)
    readSym:
             BEGIN (* readSym *)
               ReadNextSymbol();

               IF GetCurrentSymbol() <> leftParSym THEN
                 BEGIN (* IF *)
                   success := FALSE;
                   Exit;
                 END; (* IF *)

               ReadNextSymbol();

               IF GetCurrentSymbol() <> identSym THEN
                 BEGIN (* IF *)
                   success := FALSE;
                   Exit;
                 END; (* IF *)

              {sem}
               identName := GetCurrentIdentName();

               IF NOT IsDeclared(identName) THEN
                 BEGIN (* IF *)
                   SemErr('Variable not declared');
                   Exit;
                 END; (* IF *)

               Emit2(readOpc, AddressOF(identName));
              {endsem}

               ReadNextSymbol();

               IF GetCurrentSymbol() <> rightParSym THEN
                 BEGIN (* IF *)
                   success := FALSE;
                   Exit;
                 END; (* IF *)

               ReadNextSymbol();
             END; (* readSym *)
    writeSym:
              BEGIN (* writeSym *)
                ReadNextSymbol();

                IF GetCurrentSymbol() <> leftParSym THEN
                  BEGIN (* IF *)
                    success := FALSE;
                    Exit;
                  END; (* IF *)

                ReadNextSymbol();
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit1(writeOpc);
                {endsem}

                IF GetCurrentSymbol() <> rightParSym THEN
                  BEGIN (* IF *)
                    success := FALSE;
                    Exit;
                  END; (* IF *)

                ReadNextSymbol();
              END; (* writeSym *)
    beginSym:
              BEGIN (* beginSym *)
                ReadNextSymbol();
                StatementSeq();
                IF NOT success THEN exit;

                IF GetCurrentSymbol() <> endSym THEN
                  BEGIN (* IF *)
                    success := FALSE;
                    Exit;
                  END; (* IF *)

                ReadNextSymbol();
              END; (* beginSym *)
    ifSym:
           BEGIN (* ifSym *)
             ReadNextSymbol();
             ParseExpression(exprTree, success, errMessage);
             IF NOT success THEN exit;

            {sem}
             EmitCodeForExprTree(exprTree);
             IF NOT success THEN exit;
             Emit2(JumpZeroOpc, 0);
             addr1 := CurrentAddress() - 2;
            {endsem}

             IF GetCurrentSymbol() <> thenSym THEN
               BEGIN (* IF *)
                 success := FALSE;
                 Exit;
               END; (* IF *)

             ReadNextSymbol();
             Statement();
             IF NOT success THEN exit;

             IF GetCurrentSymbol() = elseSym THEN
               BEGIN (* IF *)
                {sem}
                 Emit2(JumpZeroOpc, 0);
                 FixUpJumpTarget(addr1, CurrentAddress());
                 addr1 := CurrentAddress() - 2;
                {endsem}

                 ReadNextSymbol();
                 Statement();
                 IF NOT success THEN exit;
               END; (* IF *)

            {sem}FixUpJumpTarget(addr1, CurrentAddress());{endsem}
           END; (* ifSym *)
    whileSym:
              BEGIN (* whileSym *)
                ReadNextSymbol();
                {sem}addr1 := CurrentAddress();{endsem}
                ParseExpression(exprTree, success, errMessage);
                IF NOT success THEN exit;

                {sem}
                EmitCodeForExprTree(exprTree);
                IF NOT success THEN exit;
                Emit2(JumpZeroOpc, 0);
                addr2 := CurrentAddress() - 2;
                {endsem}

                IF GetCurrentSymbol() <> doSym THEN
                  BEGIN (* IF *)
                    success := FALSE;
                    Exit;
                  END; (* IF *)

                ReadNextSymbol();
                Statement();

                {sem}
                Emit2(JumpOpc, addr1);
                FixUpJumpTarget(addr2, CurrentAddress());
                {endsem}
              END; (* whileSym *)
    ELSE
      BEGIN (* ELSE *)
        Exit;
      END; (* ELSE *)
  END; (* CASE *)
END; (* Statement *)

END.