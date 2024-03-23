PROGRAM PrintParams;

VAR 
  i: Integer;
BEGIN
  writeln('Program name: ', ParamStr(0));
  writeln('Number of parameters: ', ParamCount);
  IF (ParamCount > 0) THEN
    BEGIN
      IF (ParamStr(1) = '-R') THEN
        BEGIN
          FOR  i := 0 TO ParamCount-2 DO
            BEGIN
              writeln('Param ', ParamCount-i, ': ', ParamStr(ParamCount-i));
            END;
        END
      ELSE
        BEGIN
          FOR  i := 1 TO ParamCount DO
            BEGIN
              writeln('Param ', i, ': ', ParamStr(i));
            END;
        END;
    END
  ELSE
    BEGIN
      writeln('No parameters');
      Halt(1);
    END;

END.