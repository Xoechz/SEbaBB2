PROGRAM FileReader;
VAR 
  f: text;
  content: string;
  errorCode: Word;
BEGIN
  IF ParamCount = 0 THEN
    BEGIN
      writeln('No file specified.');
      HALT(1);
    END;
  Assign(f, ParamStr(1));
  {$I-}
  Reset(f);
  {$I+}
  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      writeln(StdErr, 'Error while opening file.');
      writeln(StdErr, 'Error code: ', errorCode);
      HALT(1);
    END;
  WHILE NOT EOF(f) DO
    BEGIN
      WHILE NOT EOLN(f) DO
        BEGIN
          Read(f, content);
          Write(content);
        END;
      ReadLn(f);
      WriteLn();
    END;
  Close(f);
END.