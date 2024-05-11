
UNIT ExpressionScanner;

INTERFACE

TYPE 
  Symbol = (
            noSym,
            plusSym, minusSym, multSym, divSym,
            leftParSym, rightParSym,
            numberSym
           );

PROCEDURE InitScanner(VAR inputFile: Text);

PROCEDURE ReadNextSymbol;

FUNCTION GetCurrentSymbol: Symbol;

PROCEDURE GetCurrentSymbolPosition(VAR line, col: INTEGER);

FUNCTION GetCurrentNumberValue: integer;

IMPLEMENTATION

CONST 
  Tab = CHR(9);
  LF = CHR(10);
  CR = CHR(13);
  Space = ' ';

VAR 
  currentSymbol: Symbol;
  currentLine, currentCol, symbolLine, symbolCol, currentNumberValue: INTEGER;
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
  GetCurrentNumberValue := currentNumberValue;
END;

END.