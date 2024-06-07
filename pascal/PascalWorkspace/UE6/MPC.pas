PROGRAM MPC;

USES
MpParser, CodeDef;

PROCEDURE ShowHelp;
BEGIN (* ShowHelp *)
  WriteLn('Usage: MPC inputFile [outputFile]');
  WriteLn('   inputFile: the file to be compiled.');
  WriteLn('   outputFile: the file where the compiled code will be stored. Default inputFile + ''c''.');
  WriteLn('   --help: display this help and exit.');
END; (* ShowHelp *)

PROCEDURE ProcessParameters(VAR inputFile: TEXT; VAR outputFile: FILE);
VAR 
  inputFileName, outputFileName: string;
BEGIN (* ProcessParameters *)
  IF (ParamCount < 1) OR (ParamCount > 2) OR (ParamStr(1) = '--help') THEN
    BEGIN (* IF *)
      ShowHelp();
      HALT(1);
    END; (* IF *)

  inputFileName := ParamStr(1);

  IF (ParamCount = 1) THEN
    BEGIN (* IF *)
      outputFileName := inputFileName + 'c';
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      outputFileName := ParamStr(2);
    END; (* ELSE *)

  Assign(inputFile, inputFileName);
  {$I-}
  Reset(inputFile);
  {$I+}
  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN (* IF *)
      WriteLn('Error opening file ', inputFileName, '. Error code: ', errorCode);
      HALT(1);
    END; (* IF *)

  Assign(outputFile, outputFileName);
  {$I-}
  Rewrite(outputFile);
  {$I+}
  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN (* IF *)
      WriteLn('Error opening file ', outputFileName, '. Error code: ', errorCode);
      Close(inputFile);
      HALT(1);
    END; (* IF *)
END; (* ProcessParameters *)

VAR 
  ok: boolean;
  errorCol, errorLine: integer;
  errMessage: string;
  inputFile: TEXT;
  outputFile: FILE;
BEGIN (* MPC *)
  ProcessParameters(inputFile, outputFile);

  Parse(inputFile, ok, errorLine, errorCol, errMessage, outputFile);
  Close(inputFile);
  Close(outputFile);

  IF (ok) THEN
    BEGIN (* IF *)
      WriteLn('Compilation completed.')
    END (* IF *)
  ELSE
    IF (errMessage <> '') THEN
      BEGIN (* ELSE IF *)
        WriteLn('Semantic Error: ', errMessage, ' at line ', errorLine, ' column ', errorCol);
      END (* ELSE IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('Syntax error at line ', errorLine, ' column ', errorCol);
    END; (* ELSE *)
END. (* MPC *)