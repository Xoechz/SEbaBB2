
UNIT ExpressionParser;

INTERFACE

USES
ExpressionTree;

PROCEDURE Parse(VAR inputFile: TEXT; VAR ok: BOOLEAN; VAR errorLine, errorCol: INTEGER; VAR result: TreePtr; VAR errorMessage: STRING);

IMPLEMENTATION

USES
ExpressionScanner;

VAR 
  success: BOOLEAN;
  errMessage: STRING;
  id: INTEGER;

PROCEDURE SemErr(message: STRING);
BEGIN (* SemErr *)
  success := FALSE;
  errMessage := message;
END; (* SemErr *)

PROCEDURE Expr(VAR e: NodePtr); Forward;
PROCEDURE Term(VAR t: NodePtr); Forward;
PROCEDURE Fact(VAR f: NodePtr); Forward;

PROCEDURE Parse(VAR inputFile: TEXT; VAR ok: BOOLEAN; VAR errorLine, errorCol: INTEGER; VAR result: TreePtr; VAR errorMessage: STRING);
BEGIN (* Parse *)
  success := TRUE;
  errMessage := '';
  id := 1;

  InitScanner(inputFile);

  Expr(result);

  GetCurrentSymbolPosition(errorLine, errorCol);
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

      Str(id, temp^.id);
      temp^.id := 'n' + temp^.id;
      id := id + 1;
      temp^.val := operatorChar;
      temp^.left := e;
      temp^.right := t;
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

      Str(id, temp^.id);
      temp^.id := 'n' + temp^.id;
      id := id + 1;
      temp^.val := operatorChar;
      temp^.left := t;
      temp^.right := f;
      t := temp;
      {endsem}
    END; (* WHILE *)
END; (* Term *)

PROCEDURE Fact(VAR f: NodePtr);
BEGIN (* Fact *)
  CASE GetCurrentSymbol() OF 
    numberSym:
               BEGIN (* numberSym *)
                 ReadNextSymbol();

                {sem}
                 f := new(NodePtr);

                 IF (f = NIL) THEN
                   BEGIN (* IF *)
                     SemErr('Out of memory');
                     EXIT;
                   END; (* IF *)

                 Str(id, f^.id);
                 f^.id := 'n' + f^.id;
                 id := id + 1;
                 f^.val := GetCurrentNumber();
                 f^.left := NIL;
                 f^.right := NIL;
                {endsem}
               END; (* numberSym *)
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