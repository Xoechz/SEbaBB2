PROGRAM PatternMatching;

FUNCTION BruteForceLR1L(text, pattern: STRING): byte;
VAR 
  i, j: word;
BEGIN
  i := 1;
  j := 1;
  WHILE (i <= length(text)) AND (j <= length(pattern)) DO
    BEGIN
      IF text[i] = pattern[j] THEN
        BEGIN
          i := i + 1;
          j := j + 1;
        END
      ELSE
        BEGIN
          i := i - j + 2;
          j := 1;
        END;
    END;
  IF (j > length(pattern)) THEN
    BEGIN
      BruteForceLR1L := i - length(pattern);
    END
  ELSE
    BEGIN
      BruteForceLR1L := 0;
    END;
END;

FUNCTION BoyerMoore(text, pattern: STRING): byte;
VAR 
  skip : ARRAY[char] OF byte;

PROCEDURE InitSkip;
VAR 
  i: byte;
  ch: char;
BEGIN
  FOR ch:=low(char) TO high(char) DO
    BEGIN
      skip[ch] := length(pattern);
    END;

  FOR i:=1 TO length(pattern) DO
    BEGIN
      skip[pattern[i]] := length(pattern) - i ;
    END;
END;

VAR 
  i, j: word;
BEGIN
  InitSkip;
  i := length(pattern);
  j := length(pattern);
  WHILE (i <= length(text)) AND (j >= 1) DO
    BEGIN
      IF text[i] = pattern[j] THEN
        BEGIN
          i := i - 1;
          j := j - 1;
        END
      ELSE
        BEGIN
          IF (skip[text[i]]) < (length(pattern) - j + 1) THEN
            BEGIN
              i := i - j + length(pattern) + 1;
            END
          ELSE
            BEGIN
              i := i + skip[text[i]];
            END;

          j := Length(pattern);
        END;
    END;
  IF (j < 1) THEN
    BEGIN
      BoyerMoore := i + 1;
    END
  ELSE
    BEGIN
      BoyerMoore := 0;
    END;
END;

FUNCTION BruteForceRL1L(text, pattern: STRING): byte;
VAR 
  i, j: word;
BEGIN
  i := length(pattern);
  j := length(pattern);
  WHILE (i <= length(text)) AND (j >= 1) DO
    BEGIN
      IF text[i] = pattern[j] THEN
        BEGIN
          i := i - 1;
          j := j - 1;
        END
      ELSE
        BEGIN
          i := i - j + length(pattern) + 1;
          j := Length(pattern);
        END;
    END;
  IF (j < 1) THEN
    BEGIN
      BruteForceRL1L := i + 1;
    END
  ELSE
    BEGIN
      BruteForceRL1L := 0;
    END;
END;

FUNCTION KnutMorrisPratt(s, p:STRING): BYTE;
VAR 
  next: ARRAY[BYTE] OF BYTE;

PROCEDURE InitNext;
VAR 
  i, j: WORD;
BEGIN
  next[1] := 0;
  i := 1;
  j := 0;
  WHILE i <= Length(p) DO
    BEGIN
      IF (j = 0) OR (s[i] = p[j])THEN
        BEGIN
          i := i + 1;
          j := j + 1;
          next[i] := j;
        END
      ELSE
        BEGIN
          j := next[j] ;
        END;
    END;
END;

VAR 
  i, j: WORD;
BEGIN
  InitNext;
  i := 1;
  j := 1;
  WHILE (i <= Length(s)) AND (j <= Length(p)) DO
    BEGIN
      IF (j = 0) OR (s[i] = p[j])THEN
        BEGIN
          i := i + 1;
          j := j + 1;
        END
      ELSE
        BEGIN
          j := next[j] ;
        END;
    END;
  IF j > Length(p) THEN
    BEGIN
      KnutMorrisPratt := i - Length(p);
    END
  ELSE
    BEGIN
      KnutMorrisPratt := 0;
    END;
END;


FUNCTION KnutMorrisPrattOptimised(s, p:STRING): BYTE;
VAR 
  next: ARRAY[BYTE] OF BYTE;

PROCEDURE InitNext;
VAR 
  i, j: WORD;
BEGIN
  next[1] := 0;
  i := 1;
  j := 0;
  WHILE i <= Length(p) DO
    BEGIN
      IF (j = 0) OR (s[i] = p[j])THEN
        BEGIN
          i := i + 1;
          j := j + 1;
          IF p[i] <> p [j] THEN
            BEGIN
              next[i] := j;
            END
          ELSE
            BEGIN
              next[i] := next[j];
            END;
        END
      ELSE
        BEGIN
          j := next[j] ;
        END;
    END;
END;

VAR 
  i, j: WORD;
BEGIN
  InitNext;
  i := 1;
  j := 1;
  WHILE (i <= Length(s)) AND (j <= Length(p)) DO
    BEGIN
      IF (j = 0) OR (s[i] = p[j])THEN
        BEGIN
          i := i + 1;
          j := j + 1;
        END
      ELSE
        BEGIN
          j := next[j] ;
        END;
    END;
  IF j > Length(p) THEN
    BEGIN
      KnutMorrisPrattOptimised := i - Length(p);
    END
  ELSE
    BEGIN
      KnutMorrisPrattOptimised := 0;
    END;
END;

FUNCTION RabinKarp(s,p: STRING): byte;
CONST 
  d = 256;
  q = 8355967;
VAR 
  i, j: word;
  position: byte;
  hashPattern, hashSearch, dExp: longint;
BEGIN
  hashPattern := 0;
  hashSearch := 0;
  FOR i:=1 TO length(p) DO
    BEGIN
      hashPattern := (d * hashPattern + ord(p[i])) MOD q;
      hashSearch := (d * hashSearch + ord(s[i])) MOD q;
    END;

  dExp := 1;
  IF (length(p) > 1) THEN
    BEGIN
      FOR i:=1 TO length(p) - 1 DO
        BEGIN
          dExp := (d * dExp) MOD q;
        END;
    END;

  i := 1;
  j := 1;
  position := 0;
  WHILE (position = 0) AND (i <= length(s) - length(p) + 1) DO
    BEGIN
      IF hashPattern = hashSearch THEN
        BEGIN
          j := 1;
          WHILE (j <= length(p)) AND (s[i + j - 1] = p[j]) DO
            BEGIN
              j := j + 1;
            END;
          IF j > length(p) THEN
            BEGIN
              position := i;
            END;
        END;

      IF (position = 0) THEN
        BEGIN
          hashSearch := (hashSearch + q * d - Ord(s[i])*dExp) MOD q;
          hashSearch := (hashSearch * d) MOD q;
          hashSearch := (hashSearch + Ord(s[i + length(p)])) MOD q;
        END;

      i := i + 1;
    END;

  RabinKarp := position;
END;


TYPE 
  Algorithm = FUNCTION (text, pattern: STRING): byte;


PROCEDURE TestAlgorithm(name: STRING; algo: Algorithm);
VAR 
  test27Text, test27Pattern: STRING;
BEGIN
  WriteLn('Testing ', name);
  WriteLn('Test 1: ', algo('', ''));
  WriteLn('Test 2: ', algo('', 'a'));
  WriteLn('Test 3: ', algo('a', ''));
  WriteLn('Test 4: ', algo('a', 'a'));
  WriteLn('Test 5: ', algo('a', 'b'));
  WriteLn('Test 6: ', algo('ab', 'a'));
  WriteLn('Test 7: ', algo('ab', 'b'));
  WriteLn('Test 8: ', algo('ab', 'c'));
  WriteLn('Test 9: ', algo('ab', 'ab'));
  WriteLn('Test 10: ', algo('ab', 'ba'));
  WriteLn('Test 11: ', algo('ab', 'abc'));
  WriteLn('Test 12: ', algo('abc', 'ab'));
  WriteLn('Test 13: ', algo('abc', 'bc'));
  WriteLn('Test 14: ', algo('abc', 'ac'));
  WriteLn('Test 15: ', algo('abc', 'abc'));
  WriteLn('Test 16: ', algo('abc', 'abcd'));
  WriteLn('Test 17: ', algo('abracadabra', 'cada'));
  WriteLn('Test 18: ', algo('abracadabra', 'abracadabra'));
  WriteLn('Test 19: ', algo('abracadabra', 'abracadabraa'));
  WriteLn('Test 20: ', algo('abracadabra', 'abracadabrac'));
  WriteLn('Test 21: ', algo('abababababc', 'ababc'));
  WriteLn('Test 22: ', algo('abababababc', 'abababc'));
  WriteLn('Test 23: ', algo('abababababc', 'ababababc'));
  WriteLn('Test 24: ', algo('ababababbabc', 'ababc'));
  WriteLn('Test 25: ', algo('ababababbabc', 'abababc'));
  WriteLn('Test 26: ', algo('ababababbabc', 'ababababc'));
  test27Text := 'ababababababababababababababababababababababababababababababababababababababababababababababababababababababcabababababababababab';
  test27Pattern := 'ababababababababababababababababababababababababcab';
  WriteLn('Test 27: ', algo( test27Text, test27Pattern ));
  WriteLn();
END;

BEGIN
  TestAlgorithm('BruteForceLR1L', BruteForceLR1L);
  TestAlgorithm('BruteForceRL1L', BruteForceRL1L);
  TestAlgorithm('KnutMorrisPratt', KnutMorrisPratt);
  TestAlgorithm('KnutMorrisPrattOptimised', KnutMorrisPrattOptimised);
  TestAlgorithm('BoyerMoore', BoyerMoore);
  TestAlgorithm('RabinKarp', RabinKarp);
END.