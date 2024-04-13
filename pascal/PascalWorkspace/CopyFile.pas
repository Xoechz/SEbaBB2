PROGRAM CopyFile;
VAR 
  s, d: File OF byte;
  buffer: array[1..1024] OF byte;
  count: word;
BEGIN
  IF ParamCount <> 2 THEN
    BEGIN
      writeln('Usage: CopyFile source destination');
      halt(1);
    END;
  Assign(s, ParamStr(1));
  Assign(d, ParamStr(2));
  Reset(s, 1);
  Rewrite(d, 1);
  WHILE NOT eof(s) DO
    BEGIN
      BlockRead(s, buffer, Length(buffer), count);
      BlockWrite(d, buffer, count);
    END;
  close(s);
  close(d);
END.