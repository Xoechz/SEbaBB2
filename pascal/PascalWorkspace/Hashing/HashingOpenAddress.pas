PROGRAM Hashing;

CONST 
  tableSize = 10;

TYPE 
  Person = RECORD
    name: STRING;
  END;
  Hash = 0..tableSize-1;
  HashTable = array[Hash] OF ^Person;

FUNCTION GetHashCode(name:STRING): Hash;
BEGIN
  GetHashCode := Ord(Upcase(name[1])) MOD tableSize;
END;

PROCEDURE InitHashTable(VAR ht: HashTable);
VAR i: Hash;
BEGIN
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN
      ht[i] := NIL;
    END;
END;

PROCEDURE DisposeHashTable(ht: HashTable);
VAR i: Hash;
BEGIN
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN
      IF ht[i] <> NIL THEN
        BEGIN
          dispose(ht[i]);
        END;
    END;
END;

PROCEDURE PrintHashTable(ht: HashTable);
VAR i: Hash;
BEGIN
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN
      write(i:3, ': ');
      IF ht[i] <> NIL THEN
        BEGIN
          writeln(ht[i]^.name);
        END
      ELSE
        BEGIN
          writeln('NIL');
        END;
    END;
END;

FUNCTION ContainsPerson(ht: HashTable; name: STRING): BOOLEAN;
VAR 
  h, originalHash: Hash;
  circular: BOOLEAN;
BEGIN
  h := GetHashCode(name);
  originalHash := h;
  circular := false;

  WHILE ((NOT circular) AND (ht[h] <> NIL) AND (ht[h]^.name <> name)) DO
    BEGIN
      h := (h + 1) MOD tableSize;
      IF (h = originalHash) THEN
        BEGIN
          circular := true;
        END;
    END;

  ContainsPerson := (ht[h] <> NIL) AND (ht[h]^.name = name);
END;

PROCEDURE AddPerson(VAR ht: HashTable; name: STRING; VAR ok: BOOLEAN);
VAR 
  h, originalHash: Hash;
  p: ^Person;
  circular: BOOLEAN;
BEGIN
  ok := false;
  circular := false;
  h := GetHashCode(name);
  originalHash := h;

  WHILE ((NOT circular) AND (ht[h] <> NIL)) DO
    BEGIN
      h := (h + 1) MOD tableSize;
      IF (h = originalHash) THEN
        BEGIN
          circular := true;
        END;
    END;

  IF (ht[h] = NIL) THEN
    BEGIN
      new(p);
      IF (p <> NIL) THEN
        BEGIN
          ok := true;
          p^.name := name;
          ht[h] := p;
        END;
    END;
END;

PROCEDURE PerformAdd(VAR ht : HashTable; name : STRING);
VAR ok : BOOLEAN;
BEGIN
  AddPerson(ht, name, ok);
  IF (ok) THEN
    BEGIN
      WriteLn('User: "',name,'" added');
    END
  ELSE
    BEGIN
      WriteLn('Error while adding user: "',name,'"');
    END;
END;

PROCEDURE PerformContains(VAR ht : HashTable; name : STRING);
BEGIN
  writeln('Contains "',name,'": ',ContainsPerson(ht,name));
END;

VAR 
  ht: HashTable;
BEGIN
  InitHashTable(ht);

  PrintHashTable(ht);
  writeln;

  PerformContains(ht, 'Zeppelin');
  writeln;

  PerformAdd(ht, 'Anton');
  PerformAdd(ht, 'Andreas');
  PerformAdd(ht, 'Berta');
  PerformAdd(ht, 'Albert');
  PerformAdd(ht, 'Berta2');
  PerformAdd(ht, 'Cäsar');
  PerformAdd(ht, 'Dora');
  PerformAdd(ht, 'Emil');
  PerformAdd(ht, 'Friedrich');
  PerformAdd(ht, 'Gustav');
  PerformAdd(ht, 'Heinrich');
  PerformAdd(ht, 'Ida');
  PerformAdd(ht, 'Julius');
  PerformAdd(ht, 'Konrad');
  PerformAdd(ht, 'Ludwig');
  PerformAdd(ht, 'Martha');
  PerformAdd(ht, 'Nordpol');
  PerformAdd(ht, 'Otto');
  PerformAdd(ht, 'Paula');
  PerformAdd(ht, 'Quelle');
  PerformAdd(ht, 'Richard');
  PerformAdd(ht, 'Siegfried');
  PerformAdd(ht, 'Theodor');
  PerformAdd(ht, 'Ulrich');
  PerformAdd(ht, 'Viktor');
  PerformAdd(ht, 'Wilhelm');
  PerformAdd(ht, 'Xaver');
  PerformAdd(ht, 'Ypsilon');
  PerformAdd(ht, 'Zeppelin');
  writeln;

  PrintHashTable(ht);
  writeln;

  PerformContains(ht, 'Zeppelin');
  PerformContains(ht, 'Elias');
  PerformContains(ht, 'Albert');
  PerformContains(ht, 'Heinrich');

  DisposeHashTable(ht);
END.