
UNIT ExpressionParser;

INTERFACE

USES
ExpressionTree;

PROCEDURE ParseExpression(VAR result: TreePtr; VAR ok: BOOLEAN; VAR errorMessage: STRING);

IMPLEMENTATION

USES
MpScanner, SymTblC;

VAR 
  success: BOOLEAN;
  errMessage: STRING;

PROCEDURE SemErr(message: STRING);
BEGIN (* SemErr *)
  success := FALSE;
  errMessage := message;
END; (* SemErr *)

PROCEDURE Expr(VAR e: NodePtr); Forward;
PROCEDURE Term(VAR t: NodePtr); Forward;
PROCEDURE Fact(VAR f: NodePtr); Forward;

PROCEDURE ParseExpression(VAR result: TreePtr; VAR ok: BOOLEAN; VAR errorMessage: STRING);
BEGIN (* Parse *)
  success := TRUE;
  errMessage := '';

  Expr(result);

  ok := success;
  errorMessage := errMessage;
END; (* Parse *)

PROCEDURE Expr(VAR e: NodePtr);
{local}
VAR 
  temp, t: NodePtr;
  operatorChar: CHAR;
{endlocal}
BEGIN (* Expr *)
  Term(e);
  IF NOT success THEN EXIT;

  WHILE (GetCurrentSymbol() = plusSym) OR (GetCurrentSymbol() = minusSym) DO
    BEGIN (* WHILE *)
      CASE GetCurrentSymbol() OF 
        plusSym:
                 BEGIN (* plusSym *)
                   ReadNextSymbol();
                   Term(t);
                   {sem} operatorChar := '+'; {endsem}
                   IF NOT success THEN EXIT;
                 END; (* plusSym *)
        minusSym:
                  BEGIN (* minusSym *)
                    ReadNextSymbol();
                    Term(t);
                   {sem} operatorChar := '-'; {endsem}
                    IF NOT success THEN EXIT;
                  END; (* minusSym *)
      END; (* CASE *)

      {sem}
      temp := new(NodePtr);

      IF (temp = NIL) THEN
        BEGIN (* IF *)
          SemErr('Out of memory');
          EXIT;
        END; (* IF *)

      temp^.val := operatorChar;
      temp^.left := e;
      temp^.right := t;
      temp^.isNumber := FALSE;
      e := temp;
      {endsem}
    END; (* WHILE *)
END; (* Expr *)

PROCEDURE Term(VAR t: NodePtr);
{local}
VAR 
  temp, f: NodePtr;
  operatorChar: CHAR;
{endlocal}
BEGIN (* Term *)
  Fact(t);
  IF NOT success THEN EXIT;

  WHILE (GetCurrentSymbol() = multSym) OR (GetCurrentSymbol() = divSym) DO
    BEGIN (* WHILE *)
      CASE GetCurrentSymbol() OF 
        multSym:
                 BEGIN (* multSym *)
                   ReadNextSymbol();
                   Fact(f);
                   {sem} operatorChar := '*'; {endsem}
                   IF NOT success THEN EXIT;
                 END; (* multSym *)
        divSym:
                BEGIN (* divSym *)
                  ReadNextSymbol();
                  Fact(f);
                   {sem} operatorChar := '/'; {endsem}
                  IF NOT success THEN EXIT;
                END; (* divSym *)
      END; (* CASE *)

      {sem}
      temp := new(NodePtr);

      IF (temp = NIL) THEN
        BEGIN (* IF *)
          SemErr('Out of memory');
          EXIT
        END; (* IF *)

      temp^.val := operatorChar;
      temp^.left := t;
      temp^.right := f;
      temp^.isNumber := FALSE;
      t := temp;
      {endsem}
    END; (* WHILE *)
END; (* Term *)

PROCEDURE Fact(VAR f: NodePtr);
BEGIN (* Fact *)
  CASE GetCurrentSymbol() OF 
    numberSym:
               BEGIN (* numberSym *)
                {sem}
                 f := new(NodePtr);

                 IF (f = NIL) THEN
                   BEGIN (* IF *)
                     SemErr('Out of memory');
                     EXIT;
                   END; (* IF *)

                 f^.val := GetCurrentNumberString();
                 f^.left := NIL;
                 f^.right := NIL;
                 f^.isNumber := TRUE;
                {endsem}

                 ReadNextSymbol();
               END; (* numberSym *)
    identSym:
              BEGIN (* identSym *)
                {sem}
                IF NOT IsDeclared(GetCurrentIdentName()) THEN
                  BEGIN (* IF *)
                    SemErr('Variable not declared');
                    Exit;
                  END; (* IF *)

                f := new(NodePtr);

                IF (f = NIL) THEN
                  BEGIN (* IF *)
                    SemErr('Out of memory');
                    EXIT;
                  END; (* IF *)

                f^.val := GetCurrentIdentName();
                f^.left := NIL;
                f^.right := NIL;
                f^.isNumber := FALSE;
                {endsem}

                ReadNextSymbol();
              END; (* identSym *)
    leftParSym:
                BEGIN (* leftParSym *)
                  ReadNextSymbol();
                  Expr(f);
                  IF NOT success THEN EXIT;

                  IF GetCurrentSymbol() <> rightParSym THEN
                    BEGIN (* IF *)
                      success := FALSE;
                      EXIT;
                    END; (* IF *)

                  ReadNextSymbol();
                END; (* leftParSym *)
    ELSE
      BEGIN (* ELSE *)
        success := FALSE;
        EXIT;
      END; (* ELSE *)
  END; (* CASE *)
END; (* Fact *)

END.