PROGRAM TestStack;

USES
UStack;
VAR 
  s: Stack;
  i, j: integer;
  ok: boolean;
BEGIN
  j := 0;
  s.InitStack();

  writeln('Stack is empty: ', s.IsEmpty());

  FOR i := 1 TO 11 DO
    BEGIN
      s.Push(i, ok);
      writeln('i = ', i, ' ok = ', ok);
    END;

  writeln('Stack is empty: ', s.IsEmpty());

  FOR i := 1 TO 11 DO
    BEGIN
      s.Pop(j, ok);
      writeln('j = ', j, ' ok = ', ok);
    END;

  s.DisposeStack();
END.