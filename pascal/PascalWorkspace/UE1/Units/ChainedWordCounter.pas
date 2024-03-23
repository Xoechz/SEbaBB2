
UNIT ChainedWordCounter;

INTERFACE

PROCEDURE StartChainedWordCounter(filePath: STRING; printHumanReadable: BOOLEAN);

IMPLEMENTATION

USES Crt, Timer, WordReader, UStringHash;

CONST 
  HASH_TABLE_SIZE = 1000000;

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    word: WordString;
    count: Longword;
    next: NodePtr;
  END;
  Hash = 0..HASH_TABLE_SIZE-1;
  HashTable = ARRAY [Hash] OF NodePtr;

PROCEDURE InitHashTable(VAR ht: HashTable);
VAR 
  i: Hash;
BEGIN (*InitHashTable*)
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN (*FOR*)
      ht[i] := NIL;
    END; (*FOR*)
END; (*InitHashTable*)

PROCEDURE DisposeHashTable(ht: HashTable);
VAR 
  i: Hash;
  next: NodePtr;
BEGIN (*DisposeHashTable*)
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN (*FOR*)
      WHILE ht[i] <> NIL DO
        BEGIN (*WHILE*)
          next := ht[i]^.next;
          dispose(ht[i]);
          ht[i] := next;
        END; (*WHILE*)
    END; (*FOR*)
END; (*DisposeHashTable*)

PROCEDURE AddWord(VAR ht: HashTable; word: WordString; VAR ok: BOOLEAN);
VAR 
  h: Hash;
  curr, prev: NodePtr;
BEGIN (*AddWord*)
  ok := FALSE;
  h := GetHashCode(word, HASH_TABLE_SIZE);
  prev := NIL;
  curr := ht[h];

  WHILE (curr<>NIL) AND (curr^.word <> word) DO
    BEGIN (*WHILE*)
      prev := curr;
      curr := curr^.next;
    END; (*WHILE*)

  IF (curr = NIL) THEN
    BEGIN (*IF*)
      new(curr);

      IF (curr <> NIL) THEN
        BEGIN (*IF*)
          curr^.word := word;
          curr^.count := 1;
          curr^.next := NIL;

          IF (prev = NIL) THEN
            BEGIN (*IF*)
              ht[h] := curr;
            END (*IF*)
          ELSE
            BEGIN (*ELSE*)
              prev^.next := curr;
            END; (*ELSE*)

          ok := TRUE;
        END; (*IF*)
    END (*IF*)
  ELSE
    BEGIN (*ELSE*)
      curr^.count := curr^.count + 1;
      ok := TRUE;
    END; (*ELSE*)
END; (*AddWord*)

PROCEDURE RemoveUniqueWords(VAR ht: HashTable);
VAR 
  i: Hash;
  curr, prev: NodePtr;
BEGIN (*RemoveUniqueWords*)
  FOR i := low(hash) TO high(hash) DO
    BEGIN (*FOR*)
      curr := ht[i];
      prev := NIL;

      WHILE (curr <> NIL) DO
        BEGIN (*WHILE*)
          IF (curr^.count = 1) THEN
            BEGIN (*IF*)
              IF (prev <> NIL) THEN
                BEGIN (*IF*)
                  prev^.next := curr^.next;
                  dispose(curr);
                  curr := prev^.next;
                END (*IF*)
              ELSE
                BEGIN (*ELSE*)
                  ht[i] := curr^.next;
                  dispose(curr);
                  curr := ht[i];
                END; (*ELSE*)
            END; (*IF*)
        END; (*WHILE*)
    END; (*FOR*)
END; (*RemoveUniqueWords*)

PROCEDURE GetAggregate(ht: HashTable; VAR moreThanOneCount, maxCount : Longword; VAR maxWord : WordString);
VAR 
  i: Hash;
  curr: NodePtr;
BEGIN (*GetAggregate*)
  moreThanOneCount := 0;
  maxCount := 0;
  maxWord := '';

  FOR i := low(hash) TO high(hash) DO
    BEGIN (*FOR*)
      curr := ht[i];

      WHILE (curr <> NIL) DO
        BEGIN (*WHILE*)
          moreThanOneCount := moreThanOneCount +1;

          IF (curr^.count > maxCount) THEN
            BEGIN (*IF*)
              maxCount := curr^.count;
              maxWord := curr^.word;
            END; (*IF*)

          curr := curr^.next;
        END; (*WHILE*)
    END; (*FOR*)
END; (*GetAggregate*)

PROCEDURE PrintResult(printHumanReadable: BOOLEAN;
                      totalCount, moreThanOneCount, maxCount: Longword;
                      maxWord: WordString;
                      ElapsedTime: STRING);
BEGIN (*PrintResult*)
  IF (printHumanReadable)THEN
    BEGIN (*IF*)
      WriteLn('Number of words: ', totalCount);
      WriteLn('Number of words with more than one count: ', moreThanOneCount);
      WriteLn('Word with the most counts: "', maxWord, '" ', maxCount, ' times');
      WriteLn('Elapsed time: ', ElapsedTime);
      WriteLn();
    END (*IF*)
  ELSE
    BEGIN (*ELSE*)
      WriteLn(totalCount, ';', moreThanOneCount, ';', maxCount, ';', maxWord, ';', ElapsedTime);
    END; (*ELSE*)
END; (*PrintResult*)

PROCEDURE StartChainedWordCounter(filePath: STRING; printHumanReadable: BOOLEAN);
VAR 
  ht: HashTable;
  ok: BOOLEAN;
  totalCount, moreThanOneCount, maxCount: Longword;
  maxWord, w: WordString;
BEGIN (*StartChainedWordCounter*)
  IF (printHumanReadable) THEN
    BEGIN (*IF*)
      writeln('Path: ', filePath);
    END (*IF*)
  ELSE
    BEGIN (*ELSE*)
      write(filePath, ';')
    END; (*ELSE*)

  InitHashTable(ht);
  OpenFile(filePath, toLower);
  totalCount := 0;

  StartTimer();
  ReadWord(w);

  WHILE (w <> '') DO
    BEGIN (*WHILE*)
      totalCount := totalCount + 1;
      AddWord(ht, w, ok);

      IF (NOT ok) THEN
        BEGIN (*IF*)
          WriteLn('There was an issue adding word "', w, '" to the hash table.');
        END; (*IF*)

      ReadWord(w);
    END; (*WHILE*)

  GetAggregate(ht, moreThanOneCount, maxCount, maxWord);
  StopTimer();
  CloseFile();

  PrintResult(printHumanReadable, totalCount, moreThanOneCount, maxCount, maxWord, ElapsedTime);

  DisposeHashTable(ht);
END; (*StartChainedWordCounter*)

BEGIN
END.