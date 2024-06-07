
UNIT MpScanner;

INTERFACE

TYPE 
  Symbol = (
            noSym,
            beginSym, endSym, integerSym, readSym, writeSym, varSym, programSym,
            plusSym, minusSym, multSym, divSym,
            leftParSym, rightParSym,
            commaSym, semicolonSym, colonSym, assignSym, periodSym,
            numberSym, identSym,
            ifSym, elseSym, thenSym, whileSym, doSym
           );

PROCEDURE InitScanner(VAR inputFile: Text);

PROCEDURE ReadNextSymbol;

FUNCTION GetCurrentSymbol: Symbol;

PROCEDURE GetCurrentSymbolPosition(VAR line, col: INTEGER);

FUNCTION GetCurrentNumberValue: integer;

FUNCTION GetCurrentNumberString: STRING;

FUNCTION GetCurrentIdentName: STRING;

IMPLEMENTATION

CONST 
  Tab = CHR(9);
  LF = CHR(10);
  CR = CHR(13);
  Space = ' ';

VAR 
  currentSymbol: Symbol;
  currentLine, currentCol, symbolLine, symbolCol, currentNumberValue: INTEGER;
  CurrentIdentName: STRING;
  currentChar: CHAR;
  inFile: Text;

PROCEDURE ReadNextChar;
BEGIN (* ReadNextChar *)
  Read(inFile, currentChar);

  IF (currentChar = LF) THEN
    BEGIN (* IF *)
      currentLine := currentLine + 1;
      currentCol := 0;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      currentCol := currentCol + 1;
    END; (* ELSE *)
END; (* ReadNextChar *)

PROCEDURE InitScanner(VAR inputFile: Text);
BEGIN (* InitScanner *)
  inFile := inputFile;
  currentLine := 1;
  currentCol := 0;
  ReadNextChar();
  ReadNextSymbol();
END; (* InitScanner *)

FUNCTION GetKeyword(s: STRING): Symbol;
BEGIN (* GetKeyword *)
  IF s = 'begin' THEN
    GetKeyword := beginSym
  ELSE IF s = 'end' THEN
         GetKeyword := endSym
  ELSE IF s = 'integer' THEN
         GetKeyword := integerSym
  ELSE IF s = 'read' THEN
         GetKeyword := readSym
  ELSE IF s = 'write' THEN
         GetKeyword := writeSym
  ELSE IF s = 'var' THEN
         GetKeyword := varSym
  ELSE IF s = 'program' THEN
         GetKeyword := programSym
  ELSE IF s = 'if' THEN
         GetKeyword := ifSym
  ELSE IF s = 'then' THEN
         GetKeyword := thenSym
  ELSE IF s = 'while' THEN
         GetKeyword := whileSym
  ELSE IF s = 'do' THEN
         GetKeyword := doSym
  ELSE IF s = 'else' THEN
         GetKeyword := elseSym
  ELSE
    GetKeyword := identSym;
END; (* GetKeyword *)

PROCEDURE ReadNextSymbol;
BEGIN (* ReadNextSymbol *)
  WHILE (currentChar = Space) OR (currentChar = LF) OR (currentChar = CR) OR (currentChar = Tab) DO
    BEGIN (* WHILE *)
      ReadNextChar();
    END; (* WHILE *)

  symbolLine := currentLine;
  symbolCol := currentCol;

  CASE currentChar OF 
    '+':
         BEGIN (* + *)
           currentSymbol := plusSym;
           ReadNextChar();
         END; (* + *)
    '-':
         BEGIN (* - *)
           currentSymbol := minusSym;
           ReadNextChar();
         END; (* - *)
    '*':
         BEGIN (* * *)
           currentSymbol := multSym;
           ReadNextChar();
         END; (* * *)
    '/':
         BEGIN (* / *)
           currentSymbol := divSym;
           ReadNextChar();
         END; (* / *)
    '(':
         BEGIN (* ( *)
           currentSymbol := leftParSym;
           ReadNextChar();
         END; (* ( *)
    ')':
         BEGIN (* ) *)
           currentSymbol := rightParSym;
           ReadNextChar();
         END; (* ) *)
    ',':
         BEGIN (* , *)
           currentSymbol := commaSym;
           ReadNextChar();
         END; (* , *)
    ':':
         BEGIN (* : *)
           ReadNextChar();
           IF currentChar = '=' THEN
             BEGIN (* IF *)
               currentSymbol := assignSym;
               ReadNextChar();
             END (* IF *)
           ELSE
             BEGIN (* ELSE *)
               currentSymbol := colonSym;
             END; (* ELSE *)
         END; (* : *)
    ';':
         BEGIN (* ; *)
           currentSymbol := semicolonSym;
           ReadNextChar();
         END; (* ; *)
    '.':
         BEGIN (* . *)
           currentSymbol := periodSym;
           ReadNextChar();
         END; (* . *)
    '0'..'9':
              BEGIN (* 0..9 *)
                currentSymbol := numberSym;
                currentNumberValue := 0;

                WHILE currentChar IN ['0' .. '9'] DO
                  BEGIN (* WHILE *)
                    currentNumberValue := currentNumberValue * 10 + Ord(currentChar) - Ord('0');
                    ReadNextChar();
                  END; (* WHILE *)
              END; (* 0..9 *)
    'a'..'z', 'A'..'Z', '_':
                             BEGIN (* a..z, A..Z, _ *)
                               CurrentIdentName := '';

                               WHILE currentChar IN ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_'] DO
                                 BEGIN (* WHILE *)
                                   CurrentIdentName := CurrentIdentName + LowerCase(currentChar);
                                   ReadNextChar();
                                 END; (* WHILE *)

                               currentSymbol := GetKeyword(CurrentIdentName);
                             END; (* a..z, A..Z, _ *)
    ELSE
      BEGIN (* ELSE *)
        currentSymbol := noSym;
      END; (* ELSE *)
  END; (* CASE *)
END; (* ReadNextSymbol *)

FUNCTION GetCurrentSymbol: Symbol;
BEGIN (* GetCurrentSymbol *)
  GetCurrentSymbol := currentSymbol;
END; (* GetCurrentSymbol *)

PROCEDURE GetCurrentSymbolPosition(VAR line, col: INTEGER);
BEGIN (* GetCurrentSymbolPosition *)
  line := symbolLine;
  col := symbolCol;
END; (* GetCurrentSymbolPosition *)

FUNCTION GetCurrentNumberValue: integer;
BEGIN (* GetCurrentNumberValue *)
  IF (currentSymbol <> numberSym) THEN
    BEGIN (* IF *)
      WriteLn('Error: Current symbol is not a number');
      Halt(1);
    END; (* IF *)

  GetCurrentNumberValue := currentNumberValue;
END; (* GetCurrentNumberValue *)

FUNCTION GetCurrentNumberString: STRING;
VAR 
  result: STRING;
BEGIN (* GetCurrentNumberString *)
  IF (currentSymbol <> numberSym) THEN
    BEGIN (* IF *)
      WriteLn('Error: Current symbol is not a number');
      Halt(1);
    END; (* IF *)

  Str(currentNumberValue, result);
  GetCurrentNumberString := result;
END; (* GetCurrentNumberString *)

FUNCTION GetCurrentIdentName: STRING;
BEGIN (* GetCurrentIdentName *)
  IF currentSymbol <> identSym THEN
    BEGIN (* IF *)
      WriteLn('Error: Current symbol is not an identifier');
      Halt(1);
    END; (* IF *)

  GetCurrentIdentName := CurrentIdentName;
END; (* GetCurrentIdentName *)

END.