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
VAR h: Hash;
BEGIN
  h := GetHashCode(name);
  ContainsPerson := ht[h] <> NIL;
END;

PROCEDURE AddPerson(VAR ht: HashTable; name: STRING; VAR ok: BOOLEAN);
VAR h: Hash;
  p: ^Person;
BEGIN
  ok := true;
  h := GetHashCode(name);
  IF (ht[h] <> NIL) THEN
    BEGIN
      ok := false;
    END
  ELSE
    BEGIN
      new(p);
      IF (p = NIL) THEN
        BEGIN
          ok := false;
        END;
    END;
  IF ok THEN
    BEGIN
      p^.name := name;
      ht[h] := p;
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
  PerformContains(ht, 'Zeppelin');

  PerformAdd(ht, 'Anton');
  PerformAdd(ht, 'Berta');
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

  PrintHashTable(ht);
  PerformContains(ht, 'Zeppelin');

  DisposeHashTable(ht);
END.