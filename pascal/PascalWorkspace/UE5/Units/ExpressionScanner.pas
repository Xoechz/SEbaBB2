
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

FUNCTION GetCurrentNumber: STRING;

IMPLEMENTATION

CONST 
  Tab = CHR(9);
  LF = CHR(10);
  CR = CHR(13);
  Space = ' ';

VAR 
  currentSymbol: Symbol;
  currentLine, currentCol, symbolLine, symbolCol: INTEGER;
  currentNumber: STRING;
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
    '0'..'9':
              BEGIN (* number *)
                currentSymbol := numberSym;
                currentNumber := '';

                WHILE currentChar IN ['0' .. '9'] DO
                  BEGIN (* WHILE *)
                    currentNumber := currentNumber + currentChar;
                    ReadNextChar();
                  END; (* WHILE *)
              END; (* number *)
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

FUNCTION GetCurrentNumber: STRING;
BEGIN (* GetCurrentNumber *)
  GetCurrentNumber := currentNumber;
END; (* GetCurrentNumber *)

END.