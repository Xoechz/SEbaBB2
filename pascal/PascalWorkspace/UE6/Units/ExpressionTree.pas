
UNIT ExpressionTree;

INTERFACE

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    left, right: NodePtr;
    val: STRING;
    isNumber: BOOLEAN;
  END;
  TreePtr = NodePtr;

PROCEDURE DisposeTree(VAR root: TreePtr);

PROCEDURE OptimizeTree(VAR root: TreePtr; VAR ok: BOOLEAN);

PROCEDURE PrintTreePostOrder(root: TreePtr);

IMPLEMENTATION

PROCEDURE PrintTreePostOrder(root: TreePtr);
BEGIN (* PrintTreePostOrder *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      PrintTreePostOrder(root^.left);
      PrintTreePostOrder(root^.right);
      Write(root^.val, ' ');
    END; (* IF *)
END; (* PrintTreePostOrder *)

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

PROCEDURE OptimizeAdd(VAR root: TreePtr);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN (* OptimizeAdd *)
  IF (root^.left^.val = '0') THEN
    BEGIN (* IF *)
      temp := root^.right;
      Dispose(root^.left);
      Dispose(root);
      root := temp;
    END (* IF *)
  ELSE
    IF (root^.right^.val = '0') THEN
      BEGIN (* ELSE IF *)
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END (* ELSE IF *)
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN (* ELSE IF *)
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l + r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END (* ELSE IF *)
END; (* OptimizeAdd *)

PROCEDURE OptimizeSub(VAR root: TreePtr);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN (* OptimizeSub *)
  IF (root^.right^.val = '0') THEN
    BEGIN (* IF *)
      temp := root^.left;
      Dispose(root^.right);
      Dispose(root);
      root := temp;
    END (* IF *)
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN (* ELSE IF *)
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l - r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END (* ELSE IF *)
END; (* OptimizeSub *)

PROCEDURE OptimizeMul(VAR root: TreePtr);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN (* OptimizeMul *)
  IF (root^.left^.val = '0') OR (root^.right^.val = '0') THEN
    BEGIN (* IF *)
      DisposeTree(root^.left);
      DisposeTree(root^.right);
      root^.val := '0';
      root^.isNumber := TRUE;
    END (* IF *)
  ELSE
    IF (root^.left^.val = '1') THEN
      BEGIN (* ELSE IF *)
        temp := root^.right;
        Dispose(root^.left);
        Dispose(root);
        root := temp;
      END (* ELSE IF *)
  ELSE
    IF (root^.right^.val = '1') THEN
      BEGIN (* ELSE IF *)
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END (* ELSE IF *)
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN (* ELSE IF *)
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l * r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END (* ELSE IF *)
END; (* OptimizeMul *)

PROCEDURE OptimizeDiv(VAR root: TreePtr; VAR ok: BOOLEAN);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN (* OptimizeDiv *)
  IF (root^.right^.val = '0') THEN
    BEGIN (* IF *)
      ok := FALSE;
    END (* IF *)
  ELSE
    IF (root^.left^.val = '0') THEN
      BEGIN (* ELSE IF *)
        Dispose(root^.left);
        DisposeTree(root^.right);
        root^.val := '0';
        root^.isNumber := TRUE;
      END (* ELSE IF *)
  ELSE
    IF (root^.right^.val = '1') THEN
      BEGIN (* ELSE IF *)
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END (* ELSE IF *)
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN (* ELSE IF *)
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l DIV r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END (* ELSE IF *)
END; (* OptimizeDiv *)

PROCEDURE OptimizeTree(VAR root: TreePtr; VAR ok: BOOLEAN);
BEGIN (* OptimizeTree *)
  IF (root <> NIL) THEN
    BEGIN (* IF *)
      OptimizeTree(root^.left, ok);
      OptimizeTree(root^.right, ok);

      IF (ok) THEN
        BEGIN (* IF *)
          IF (root^.val = '+') THEN
            BEGIN (* IF *)
              OptimizeAdd(root);
            END (* IF *)
          ELSE
            IF (root^.val = '-') THEN
              BEGIN (* ELSE IF *)
                OptimizeSub(root);
              END (* ELSE IF *)
          ELSE
            IF (root^.val = '*') THEN
              BEGIN (* ELSE IF *)
                OptimizeMul(root);
              END (* ELSE IF *)
          ELSE
            IF (root^.val = '/') THEN
              BEGIN (* ELSE IF *)
                OptimizeDiv(root, ok);
              END; (* ELSE IF *)
        END; (* IF *)
    END; (* IF *)
END; (* OptimizeTree *)

END. (* ExpressionTree *)