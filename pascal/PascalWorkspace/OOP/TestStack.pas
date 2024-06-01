PROGRAM TestStack;
Uses UStack;
var 
  s: Stack;
  i, j: integer;
  ok: boolean;
begin
  j := 0;
  s.InitStack();

  for i := 1 to 11 do
  begin
    s.Push(i, ok);
    writeln('i = ', i, ' ok = ', ok);
  end;

  for i := 1 to 11 do
  begin
    s.Pop(j, ok);
    writeln('j = ', j, ' ok = ', ok);
  end;

  s.DisposeStack();
end.
