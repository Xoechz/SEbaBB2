
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

(* Used for debugging *)
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
BEGIN
  IF (root^.left^.val = '0') THEN
    BEGIN
      temp := root^.right;
      Dispose(root^.left);
      Dispose(root);
      root := temp;
    END
  ELSE
    IF (root^.right^.val = '0') THEN
      BEGIN
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l + r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END
END;

PROCEDURE OptimizeSub(VAR root: TreePtr);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN
  IF (root^.right^.val = '0') THEN
    BEGIN
      temp := root^.left;
      Dispose(root^.right);
      Dispose(root);
      root := temp;
    END
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l - r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END
END;

PROCEDURE OptimizeMul(VAR root: TreePtr);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN
  IF (root^.left^.val = '0') OR (root^.right^.val = '0') THEN
    BEGIN
      DisposeTree(root^.left);
      DisposeTree(root^.right);
      root^.val := '0';
      root^.isNumber := TRUE;
    END
  ELSE
    IF (root^.left^.val = '1') THEN
      BEGIN
        temp := root^.right;
        Dispose(root^.left);
        Dispose(root);
        root := temp;
      END
  ELSE
    IF (root^.right^.val = '1') THEN
      BEGIN
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l * r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END
END;

PROCEDURE OptimizeDiv(VAR root: TreePtr; VAR ok: BOOLEAN);
VAR 
  temp: NodePtr;
  l, r: INTEGER;
  result: STRING;
BEGIN
  IF (root^.right^.val = '0') THEN
    BEGIN
      ok := FALSE;
    END
  ELSE
    IF (root^.left^.val = '0') THEN
      BEGIN
        Dispose(root^.left);
        DisposeTree(root^.right);
        root^.val := '0';
        root^.isNumber := TRUE;
      END
  ELSE
    IF (root^.right^.val = '1') THEN
      BEGIN
        temp := root^.left;
        Dispose(root^.right);
        Dispose(root);
        root := temp;
      END
  ELSE
    IF (root^.left^.isNumber) AND (root^.right^.isNumber) THEN
      BEGIN
        Val(root^.left^.val, l);
        Val(root^.right^.val, r);
        Str(l DIV r, result);
        root^.val := result;
        root^.isNumber := TRUE;
        Dispose(root^.left);
        Dispose(root^.right);
        root^.left := NIL;
        root^.right := NIL;
      END
END;

PROCEDURE OptimizeTree(VAR root: TreePtr; VAR ok: BOOLEAN);
BEGIN
  IF (root <> NIL) THEN
    BEGIN
      OptimizeTree(root^.left, ok);
      OptimizeTree(root^.right, ok);

      IF (ok) THEN
        BEGIN
          IF (root^.val = '+') THEN
            BEGIN
              OptimizeAdd(root);
            END
          ELSE
            IF (root^.val = '-') THEN
              BEGIN
                OptimizeSub(root);
              END
          ELSE
            IF (root^.val = '*') THEN
              BEGIN
                OptimizeMul(root);
              END
          ELSE
            IF (root^.val = '/') THEN
              BEGIN
                OptimizeDiv(root, ok);
              END;
        END;
    END;
END;

END.