PROGRAM Scale;

USES 
ULineBuffer;

PROCEDURE ScaleFile(VAR inFile, outFile: TEXT; scaleX, scaleY: INTEGER);
VAR 
  lb: LineBuffer;
  s: STRING;
  countModScale, i: INTEGER;
BEGIN (* ScaleFile *)
  countModScale := 0;
  InitLineBuffer(lb);

  WHILE NOT EOF(inFile) DO
    BEGIN (* WHILE *)
      WHILE NOT EOLN(inFile) DO
        BEGIN (* WHILE *)
          Read(inFile, s);
          AppendToLineBuffer(lb, s);
        END;

      IF (scaleY > 0) THEN
        BEGIN (* IF *)
          FOR i := 1 TO scaleY DO
            BEGIN (* FOR *)
              WriteLineBuffer(outFile, lb, scaleX);
            END; (* FOR *)
        END (* IF *)
      ELSE
        IF (countModScale MOD scaleY = 0) THEN
          BEGIN (* ELSE IF *)
            WriteLineBuffer(outFile, lb, scaleX);
          END; (* ELSE IF *)

      ClearLineBuffer(lb);
      ReadLn(inFile);
      countModScale := (countModScale + 1) MOD scaleY;
    END; (* WHILE *)

  DisposeLineBuffer(lb);
END; (* ScaleFile *)

PROCEDURE ShowHelp;
BEGIN (* ShowHelp *)
  WriteLn('Usage: Scale [OPTION] inFile outFile');
  WriteLn('   inFile: input file.');
  WriteLn('   outFile: output file.');
  WriteLn('   -x sx: scale in the x direction. Default 1. Allowed values: -9 to -2, 2 to 9.');
  WriteLn('   -y sy: scale in the y direction. Default 1. Allowed values: -9 to -2, 2 to 9.');
  WriteLn('   --help: display this help and exit.');
END; (* ShowHelp *)

PROCEDURE GetParameters(VAR scaleX, scaleY: INTEGER; VAR inFileName, outFileName: STRING);
VAR 
  xSet, ySet, inFileSet, outFileSet: Boolean;
  i, errorCode: INTEGER;
BEGIN (* GetParameters *)
  scaleX := 1;
  scaleY := 1;
  xSet := FALSE;
  ySet := FALSE;
  inFileSet := FALSE;
  outFileSet := FALSE;
  i := 1;

  IF (ParamCount < 2) OR (ParamStr(1) = '--help') THEN
    BEGIN (* IF *)
      ShowHelp();
      HALT(1);
    END; (* IF *)

  WHILE (i <= ParamCount) DO
    BEGIN (* WHILE *)
      IF ((NOT xSet) AND ((i + 1) < ParamCount) AND (ParamStr(i) = '-x')) THEN
        BEGIN (* IF *)
          Val(ParamStr(i + 1), scaleX, errorCode);

          IF ((errorCode <> 0) OR (scaleX < -9) OR (scaleX > 9) OR (scaleX = 0)) THEN
            BEGIN (* IF *)
              WriteLn(StdErr, 'Invalid scale value for x direction.');
              ShowHelp();
              HALT(1);
            END; (* IF *)

          xSet := TRUE;
          i := i + 2;
        END (* IF *)
      ELSE
        IF ((NOT ySet) AND ((i +1) < ParamCount) AND (ParamStr(i) = '-y')) THEN
          BEGIN (* ELSE IF *)
            Val(ParamStr(i + 1), scaleY, errorCode);

            IF ((errorCode <> 0) OR (scaleY < -9) OR (scaleY > 9) OR (scaleY = 0)) THEN
              BEGIN (* IF *)
                WriteLn(StdErr, 'Invalid scale value for y direction.');
                ShowHelp();
                HALT(1);
              END; (* IF *)

            ySet := TRUE;
            i := i + 2;
          END (* ELSE IF *)
      ELSE
        IF ((NOT inFileSet) AND (ParamStr(i) <> '-x') AND (ParamStr(i) <> '-y')) THEN
          BEGIN (* ELSE IF *)
            inFileName := ParamStr(i);
            inFileSet := TRUE;
            i := i + 1;
          END (* ELSE IF *)
      ELSE
        IF ((NOT outFileSet) AND (ParamStr(i) <> '-x') AND (ParamStr(i) <> '-y')) THEN
          BEGIN (* ELSE IF *)
            outFileName := ParamStr(i);
            outFileSet := TRUE;
            i := i + 1;
          END (* ELSE IF *)
      ELSE
        BEGIN (* ELSE *)
          ShowHelp();
          HALT(1);
        END; (* ELSE *)
    END;

  IF ((NOT inFileSet) OR (NOT outFileSet)) THEN
    BEGIN (* IF *)
      ShowHelp();
      HALT(1);
    END; (* IF *)
END; (* GetParameters *)

VAR 
  inFile, outFile: TEXT;
  errorCode: WORD;
  scaleX, scaleY: INTEGER;
  inFileName, outFileName: STRING;
BEGIN (* Scale *)
  GetParameters(scaleX, scaleY, inFileName, outFileName);

  Assign(inFile, inFileName);
  {$I-}
  Reset(inFile);
  {$I+}
  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN (* IF *)
      writeln(StdErr, 'Error while opening input file.');
      writeln(StdErr, 'Error code: ', errorCode);
      HALT(1);
    END; (* IF *)

  Assign(outFile, outFileName);
  {$I-}
  Rewrite(outFile);
  {$I+}
  errorCode := IOResult;

  IF (errorCode <> 0) THEN
    BEGIN (* IF *)
      writeln(StdErr, 'Error while opening output file.');
      writeln(StdErr, 'Error code: ', errorCode);
      HALT(1);
    END; (* IF *)

  ScaleFile(inFile, outFile, scaleX, scaleY);

  WriteLn('File scaled successfully.');

  Close(inFile);
  Close(outFile);
END. (* Scale *)