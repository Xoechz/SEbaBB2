
UNIT OpenAddressedWordCounter;

INTERFACE

PROCEDURE StartOpenAddressedWordCounter(filePath: STRING; printHumanReadable: BOOLEAN);

IMPLEMENTATION

USES Crt, Timer, WordReader, UStringHash;

CONST 
  HASH_TABLE_SIZE = 1000000;

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    word: WordString;
    count: Longword;
    deleted: BOOLEAN;
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
BEGIN (*DisposeHashTable*)
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN (*FOR*)
      IF ht[i] <> NIL THEN
        BEGIN (*IF*)
          dispose(ht[i]);
          ht[i] := NIL;
        END; (*IF*)
    END; (*FOR*)
END; (*DisposeHashTable*)

PROCEDURE AddWord(VAR ht: HashTable; word: WordString; VAR ok: BOOLEAN);
VAR 
  h: Hash;
  steps: Longword;
BEGIN (*AddWord*)
  ok := true;
  h := GetHashCode(word, HASH_TABLE_SIZE);
  steps := 0;

  WHILE (steps < HASH_TABLE_SIZE) AND (ht[h]<>NIL) AND (ht[h]^.word <> word) AND (NOT ht[h]^.deleted) DO
    BEGIN (*WHILE*)
      h := (h + 1) MOD HASH_TABLE_SIZE;
      steps := steps + 1;
    END; (*WHILE*)

  IF (steps >= HASH_TABLE_SIZE) THEN
    BEGIN (*IF*)
      ok := FALSE;
    END (*IF*)
  ELSE
    IF (ht[h] = NIL) THEN
      BEGIN (*ELSE IF*)
        new(ht[h]);

        IF (ht[h] <> NIL) THEN
          BEGIN (*IF*)
            ht[h]^.word := word;
            ht[h]^.count := 1;
            ht[h]^.deleted := FALSE;
          END (*IF*)
        ELSE
          BEGIN (*ELSE*)
            ok := FALSE;
          END; (*ELSE*)
      END (*ELSE IF*)
  ELSE
    BEGIN (*ELSE*)
      IF (ht[h]^.deleted) THEN
        BEGIN (*IF*)
          ht[h]^.count :=  1;
          ht[h]^.word := word;
          ht[h]^.deleted := FALSE;
        END (*IF*)
      ELSE
        BEGIN (*ELSE*)
          ht[h]^.count := ht[h]^.count + 1;
        END; (*ELSE*)
    END; (*ELSE*)
END; (*AddWord*)

PROCEDURE RemoveUniqueWords(VAR ht: HashTable);
VAR 
  i: Hash;
BEGIN (*RemoveUniqueWords*)
  FOR i := low(hash) TO high(hash) DO
    BEGIN (*FOR*)
      IF ((ht[i]<> NIL) AND (NOT ht[i]^.deleted) AND (ht[i]^.count = 1)) THEN
        BEGIN (*IF*)
          ht[i]^.deleted := TRUE;
        END; (*IF*)
    END; (*FOR*)
END; (*RemoveUniqueWords*)

PROCEDURE GetAggregate(ht: HashTable; VAR moreThanOneCount, maxCount : Longword; VAR maxWord : WordString);
VAR 
  i: Hash;
BEGIN (*GetAggregate*)
  moreThanOneCount := 0;
  maxCount := 0;
  maxWord := '';

  FOR i := low(hash) TO high(hash) DO
    BEGIN (*FOR*)
      IF ((ht[i]<> NIL) AND (NOT ht[i]^.deleted)) THEN
        BEGIN (*IF*)
          moreThanOneCount := moreThanOneCount +1;

          IF (ht[i]^.count > maxCount) THEN
            BEGIN (*IF*)
              maxCount := ht[i]^.count;
              maxWord := ht[i]^.word;
            END; (*IF*)
        END; (*IF*)
    END; (*FOR*)
END; (*GetAggregate*)

PROCEDURE PrintResult(printHumanReadable: BOOLEAN;
                      totalCount, moreThanOneCount, maxCount: Longword;
                      maxWord: WordString;
                      ElapsedTime: STRING);
BEGIN (*PrintResult*)
  IF (printHumanReadable) THEN
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

PROCEDURE StartOpenAddressedWordCounter(filePath: STRING; printHumanReadable: BOOLEAN);
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