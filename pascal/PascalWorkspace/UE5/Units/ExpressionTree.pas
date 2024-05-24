
UNIT ExpressionTree;

INTERFACE

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    left, right: NodePtr;
    val, id: STRING;
  END;
  TreePtr = NodePtr;

PROCEDURE DisposeTree(VAR root: TreePtr);

PROCEDURE PrintTreeInOrder(root: TreePtr);

PROCEDURE PrintTreePostOrder(root: TreePtr);

PROCEDURE PrintTreePreOrder(root: TreePtr);

FUNCTION ValueOf(root: TreePtr): INTEGER;

PROCEDURE PrintGraphviz(root: TreePtr);

IMPLEMENTATION

PROCEDURE DisposeTree(VAR root: TreePtr);
BEGIN (* DisposeTree *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      DisposeTree(root^.left);
      DisposeTree(root^.right);
      Dispose(root);
      root := NIL;
    END; (* IF *)
END; (* DisposeTree *)

PROCEDURE PrintTreeInOrder(root: TreePtr);
BEGIN (* PrintTreeInOrder *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      PrintTreeInOrder(root^.left);
      Write(root^.val, ' ');
      PrintTreeInOrder(root^.right);
    END; (* IF *)
END; (* PrintTreeInOrder *)

PROCEDURE PrintTreePostOrder(root: TreePtr);
BEGIN (* PrintTreePostOrder *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      PrintTreePostOrder(root^.left);
      PrintTreePostOrder(root^.right);
      Write(root^.val, ' ');
    END; (* IF *)
END; (* PrintTreePostOrder *)

PROCEDURE PrintTreePreOrder(root: TreePtr);
BEGIN (* PrintTreePreOrder *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      Write(root^.val, ' ');
      PrintTreePreOrder(root^.left);
      PrintTreePreOrder(root^.right);
    END; (* IF *)
END; (* PrintTreePreOrder *)

FUNCTION ValueOf(root: TreePtr): INTEGER;
VAR 
  temp, code: INTEGER;
BEGIN (* ValueOf *)
  IF (root = NIL) THEN
    BEGIN (* IF *)
      WriteLn('Error: Empty (Sub)Tree');
      HALT(1);
    END; (* IF *)

  IF (root^.val = '+') THEN
    BEGIN (* IF *)
      ValueOf := ValueOf(root^.left) + ValueOf(root^.right)
    END (* IF *)
  ELSE
    IF (root^.val = '-') THEN
      BEGIN (* ELSE IF *)
        ValueOf := ValueOf(root^.left) - ValueOf(root^.right)
      END (* ELSE IF *)
  ELSE
    IF (root^.val = '*') THEN
      BEGIN (* ELSE IF *)
        ValueOf := ValueOf(root^.left) * ValueOf(root^.right)
      END (* ELSE IF *)
  ELSE
    IF (root^.val = '/') THEN
      BEGIN (* ELSE IF *)
        temp := ValueOf(root^.right);

        IF (temp = 0) THEN
          BEGIN (* IF *)
            WriteLn('Error: Division by Zero');
            HALT(1);
          END; (* IF *)

        ValueOf := ValueOf(root^.left) DIV temp;
      END (* ELSE IF *)
  ELSE
    BEGIN (* ELSE *)
      Val(root^.val, temp, code);

      IF (code <> 0) THEN
        BEGIN (* IF *)
          WriteLn('Error: Invalid Number, Error Code: ', code);
          HALT(1);
        END; (* IF *)

      ValueOf := temp;
    END; (* ELSE *)
END; (* ValueOf *)

PROCEDURE PrintGraphvizNode(root: NodePtr);
BEGIN (* PrintGraphvizNode *)
  WriteLn(root^.id + ' [label="' + root^.val + '"];');

  IF (root^.left <> NIL) THEN
    BEGIN (* IF *)
      PrintGraphvizNode(root^.left);
      WriteLn(root^.id + ' -> ' + root^.left^.id + '; ');
    END; (* IF *)

  IF (root^.right <> NIL) THEN
    BEGIN (* IF *)
      PrintGraphvizNode(root^.right);
      WriteLn(root^.id + ' -> ' + root^.right^.id + '; ');
    END; (* IF *)
END; (* PrintGraphvizNode *)

PROCEDURE PrintGraphviz(root: TreePtr);
BEGIN (* PrintGraphviz *)
  WriteLn('digraph G {');
  PrintGraphvizNode(root);
  WriteLn('}');
END; (* PrintGraphviz *)

END.