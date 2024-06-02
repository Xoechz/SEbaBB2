
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
BEGIN
  Read(inFile, currentChar);

  IF (currentChar = LF) THEN
    BEGIN
      currentLine := currentLine + 1;
      currentCol := 0;
    END
  ELSE
    BEGIN
      currentCol := currentCol + 1;
    END;
END;

PROCEDURE InitScanner(VAR inputFile: Text);
BEGIN
  inFile := inputFile;
  currentLine := 1;
  currentCol := 0;
  ReadNextChar();
  ReadNextSymbol();
END;

FUNCTION GetKeyword(s: STRING): Symbol;
BEGIN
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
END;

PROCEDURE ReadNextSymbol;
BEGIN
  WHILE (currentChar = Space) OR (currentChar = LF) OR (currentChar = CR) OR (currentChar = Tab) DO
    BEGIN
      ReadNextChar();
    END;

  symbolLine := currentLine;
  symbolCol := currentCol;

  CASE currentChar OF 
    '+':
         BEGIN
           currentSymbol := plusSym;
           ReadNextChar();
         END;
    '-':
         BEGIN
           currentSymbol := minusSym;
           ReadNextChar();
         END;
    '*':
         BEGIN
           currentSymbol := multSym;
           ReadNextChar();
         END;
    '/':
         BEGIN
           currentSymbol := divSym;
           ReadNextChar();
         END;
    '(':
         BEGIN
           currentSymbol := leftParSym;
           ReadNextChar();
         END;
    ')':
         BEGIN
           currentSymbol := rightParSym;
           ReadNextChar();
         END;
    ',':
         BEGIN
           currentSymbol := commaSym;
           ReadNextChar();
         END;
    ':':
         BEGIN
           ReadNextChar();
           IF currentChar = '=' THEN
             BEGIN
               currentSymbol := assignSym;
               ReadNextChar();
             END
           ELSE
             BEGIN
               currentSymbol := colonSym;
             END;
         END;
    ';':
         BEGIN
           currentSymbol := semicolonSym;
           ReadNextChar();
         END;
    '.':
         BEGIN
           currentSymbol := periodSym;
           ReadNextChar();
         END;
    '0'..'9':
              BEGIN
                currentSymbol := numberSym;
                currentNumberValue := 0;
                WHILE currentChar IN ['0' .. '9'] DO
                  BEGIN
                    currentNumberValue := currentNumberValue * 10 + Ord(currentChar) - Ord('0');
                    ReadNextChar();
                  END;
              END;
    'a'..'z', 'A'..'Z', '_':
                             BEGIN
                               CurrentIdentName := '';
                               WHILE currentChar IN ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_'] DO
                                 BEGIN
                                   CurrentIdentName := CurrentIdentName + LowerCase(currentChar);
                                   ReadNextChar();
                                 END;
                               currentSymbol := GetKeyword(CurrentIdentName);
                             END;
    ELSE
      BEGIN
        currentSymbol := noSym;
      END;
  END;
END;

FUNCTION GetCurrentSymbol: Symbol;
BEGIN
  GetCurrentSymbol := currentSymbol;
END;

PROCEDURE GetCurrentSymbolPosition(VAR line, col: INTEGER);
BEGIN
  line := symbolLine;
  col := symbolCol;
END;

FUNCTION GetCurrentNumberValue: integer;
BEGIN
  IF currentSymbol <> numberSym THEN
    BEGIN
      WriteLn('Error: Current symbol is not a number');
      Halt(1);
    END;
  GetCurrentNumberValue := currentNumberValue;
END;

FUNCTION GetCurrentNumberString: STRING;
VAR 
  result: STRING;
BEGIN
  IF currentSymbol <> numberSym THEN
    BEGIN
      WriteLn('Error: Current symbol is not a number');
      Halt(1);
    END;
  Str(currentNumberValue, result);
  GetCurrentNumberString := result;
END;

FUNCTION GetCurrentIdentName: STRING;
BEGIN
  IF currentSymbol <> identSym THEN
    BEGIN
      WriteLn('Error: Current symbol is not an identifier');
      Halt(1);
    END;
  GetCurrentIdentName := CurrentIdentName;
END;

END.