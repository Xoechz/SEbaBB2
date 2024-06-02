PROGRAM MPC;

USES
MpParser, CodeInt, CodeDef;

PROCEDURE ShowHelp;
BEGIN (* ShowHelp *)
  WriteLn('Usage: MPC [OPTION] inFile');
  WriteLn('   inFile: input file.');
  WriteLn('   -c compile only. Does not execute the compiled file. Cannot be used with -e.');
  WriteLn('   -e execute only. Needs a compiled file as input. Cannot be used with -c.');
  WriteLn('   --help: display this help and exit.');
END; (* ShowHelp *)

PROCEDURE GetParameters(VAR execute, compile: BOOLEAN; VAR inFileName: STRING);
BEGIN (* GetParameters *)
  IF (ParamCount < 1) OR (ParamCount > 2) OR (ParamStr(1) = '--help') THEN
    BEGIN (* IF *)
      ShowHelp();
      HALT(1);
    END; (* IF *)

  IF (ParamCount = 1) THEN
    BEGIN
      execute := TRUE;
      compile := TRUE;
      inFileName := ParamStr(1);
    END
  ELSE
    IF (ParamStr(1) = '-c') THEN
      BEGIN
        IF (ParamStr(2) = '-e') THEN
          BEGIN
            WriteLn('Error: -c and -e cannot be used together.');
            HALT(1);
          END;

        execute := FALSE;
        compile := TRUE;
        inFileName := ParamStr(2);
      END
  ELSE
    IF (ParamStr(1) = '-e') THEN
      BEGIN
        IF (ParamStr(2) = '-c') THEN
          BEGIN
            WriteLn('Error: -e and -c cannot be used together.');
            HALT(1);
          END;

        execute := TRUE;
        compile := FALSE;
        inFileName := ParamStr(2);
      END
  ELSE
    BEGIN
      ShowHelp();
      HALT(1);
    END;
END; (* GetParameters *)

VAR 
  ok, execute, compile: boolean;
  errorCol, errorLine: integer;
  errMessage, outFileName, inFileName: string;
  code: CodeArray;
BEGIN
  GetParameters(execute, compile, inFileName);

  outFileName := inFileName + 'c';

  IF (compile) THEN
    BEGIN
      Parse(inFileName, ok, errorLine, errorCol, errMessage, code);

      IF ok THEN
        BEGIN
          StoreCode(outFileName, code);
          WriteLn('Compilation completed.')
        END
      ELSE
        IF (errMessage <> '') THEN
          BEGIN
            WriteLn('Error: ', errMessage, ' at line ', errorLine, ' column ', errorCol);
            execute := FALSE;
          END
      ELSE
        BEGIN
          WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
          execute := FALSE;
        END;
    END;

  IF (execute) THEN
    BEGIN
      IF (NOT compile) THEN
        BEGIN
          LoadCode(inFileName, code, ok);
        END;

      IF (ok) THEN
        BEGIN
          InterpretCode(code);
        END
      ELSE
        BEGIN
          WriteLn('Error loading compiled file.');
          HALT(1);
        END;
    END;
END.