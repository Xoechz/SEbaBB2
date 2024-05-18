PROGRAM PrintSymbols;

USES
MpiScanner;

VAR 
  f: text;
  errorCode: Byte;
BEGIN
  IF ParamCount <> 1 THEN
    BEGIN
      WriteLn('Usage: PrintSymbols <input file>');
      Halt(1);
    END;

  Assign(f, ParamStr(1));
  {$I-}
  Reset(f);
  {$I+}
  errorCode := IOResult;
  IF errorCode <> 0 THEN
    BEGIN
      WriteLn('Error opening file: ', ParamStr(1), ' (error code: ', errorCode, ')');
      Halt(1);
    END;

  InitScanner(f);
  WHILE GetCurrentSymbol<> noSym DO
    BEGIN
      Write(GetCurrentSymbol);
      IF (GetCurrentSymbol = numberSym) THEN
        BEGIN
          Write(' = ',GetCurrentNumberValue,'');
        END
      ELSE IF (GetCurrentSymbol = identSym) THEN
             BEGIN
               write(' = ',GetCurrentIdentName,'');
             END;
      writeln();
      ReadNextSymbol();
    END;
END.