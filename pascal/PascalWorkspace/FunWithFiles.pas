PROGRAM FunWithFiles;
VAR 
  f: TEXT;
  s: STRING;
BEGIN
  Assign(f, 'output.txt');
  Rewrite(f);
  Writeln(f, 1);
  Writeln(f, 3.1415926:0:5);
  Writeln(f, 'Hello World!');
  Close(f);

  Assign(f, 'input.txt');
  Reset(f);
  Readln(f,s);
  writeln(s);
  Read(f,s);
  writeln(s);
  Read(f,s);
  writeln(s);
  Read(f,s);
  writeln(output,'error');
  Close(f);
END.