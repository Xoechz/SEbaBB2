PROGRAM ExprParse;

USES
ExpressionParser, ExpressionTree;

VAR 
  f: TEXT;
  errorCode: BYTE;
  ok: BOOLEAN;
  errorCol, errorLine: INTEGER;
  tree: TreePtr;
  errorMessage: STRING;
BEGIN (* ExprParse *)
  IF (ParamCount <> 1) THEN
    BEGIN (* IF *)
      WriteLn('Usage: ExprParse <input file>');
      Halt(1);
    END; (* IF *)

  Assign(f, ParamStr(1));

  {$I-}
  Reset(f);
  {$I+}

  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN (* IF *)
      WriteLn('Error opening file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END; (* IF *)

  Parse(f, ok, errorLine, errorCol, tree, errorMessage);
  Close(f);

  IF ok THEN
    BEGIN (* IF *)
      WriteLn('InOrder: ');
      PrintTreeInOrder(tree);
      WriteLn();
      WriteLn('PostOrder: ');
      PrintTreePostOrder(tree);
      WriteLn();
      WriteLn('PreOrder: ');
      PrintTreePreOrder(tree);
      WriteLn();
      WriteLn('Graphviz: ');
      PrintGraphviz(tree);
      WriteLn();
      WriteLn('Result: ', ValueOf(tree));
      DisposeTree(tree);
    END (* IF *)
  ELSE
    IF (errorMessage <> '') THEN
      BEGIN (* ELSE IF *)
        WriteLn('Error: ', errorMessage, ' at line ', errorLine, ' column ', errorCol);
      END (* ELSE IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
    END; (* ELSE *)
END. (* ExprParse *)