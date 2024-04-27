PROGRAM TestsADT;

USES StackADTP2;
VAR 
  ok : boolean;
  value : integer;
  s, s2 : Stack;
BEGIN
  InitStack(s);
  Writeln('Test s');
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 1, ok);
  Writeln('Push 1: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 2, ok);
  Writeln('Push 2: ', ok);
  Pop(s, value,ok);
  Writeln('Pop 2: ', value, ' ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Pop(s, value,ok);
  Writeln('Pop 1: ', value, ' ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Pop(s, value,ok);
  Writeln('Pop FALSE: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 1, ok);
  Writeln('Push 1: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 2, ok);
  Writeln('Push 2: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 3, ok);
  Writeln('Push 3: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 4, ok);
  Writeln('Push 4: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 5, ok);
  Writeln('Push 5: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 6, ok);
  Writeln('Push 6: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 7, ok);
  Writeln('Push 7: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 8, ok);
  Writeln('Push 8: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 9, ok);
  Writeln('Push 9: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 10, ok);
  Writeln('Push 10: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  Push(s, 11, ok);
  Writeln('Push 11: ', ok);
  Writeln('IsEmpty: ',IsEmpty(s));
  InitStack(s2);
  Push(s2, 1, ok);
  Writeln('Push 1: ', ok);
  Pop(s2, value,ok);
  Writeln('Pop 1: ', value, ' ', ok);
  DisposeStack(s2);
  DisposeStack(s);
END.