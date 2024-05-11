PROGRAM Hashing;

CONST 
  tableSize = 10;


TYPE 
  PersonPtr = ^Person;
  Person = RECORD
    name: STRING;
    next: PersonPtr;
  END;
  Hash = 0..tableSize-1;
  HashTable = array[Hash] OF PersonPtr;

FUNCTION GetHashCode(name:STRING): Hash;
BEGIN
  GetHashCode := Ord(Upcase(name[1])) MOD tableSize;
END;

PROCEDURE PrintPersons(p: PersonPtr);
BEGIN
  WHILE p <> NIL DO
    BEGIN
      IF (p^.next = NIL) THEN
        BEGIN
          writeln(p^.name);
        END
      ELSE
        BEGIN
          write(p^.name, ', ');
        END;
      p := p^.next;
    END;
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
VAR 
  i: Hash;
  next: PersonPtr;
BEGIN
  FOR i := low(Hash) TO High(Hash) DO
    BEGIN
      WHILE ht[i] <> NIL DO
        BEGIN
          next := ht[i]^.next;
          dispose(ht[i]);
          ht[i] := next;
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
          PrintPersons(ht[i]);
        END
      ELSE
        BEGIN
          writeln('NIL');
        END;
    END;
END;

FUNCTION ContainsPerson(ht: HashTable; name: STRING): BOOLEAN;
VAR 
  h: Hash;
  p: PersonPtr;
BEGIN
  h := GetHashCode(name);
  p := ht[h];

  WHILE (p <> NIL) AND (p^.name <> name) DO
    BEGIN
      p := p^.next;
    END;

  ContainsPerson := p <> NIL;
END;

PROCEDURE AddPerson(VAR ht: HashTable; name: STRING; VAR ok: BOOLEAN);
VAR h: Hash;
  p: PersonPtr;
BEGIN
  h := GetHashCode(name);

  new(p);
  ok := p<>NIL;

  IF ok THEN
    BEGIN
      p^.name := name;
      p^.next := ht[h];
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
  writeln;

  PerformContains(ht, 'Zeppelin');
  writeln;

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
  writeln;

  PrintHashTable(ht);
  writeln;

  PerformContains(ht, 'Zeppelin');
  PerformContains(ht, 'Elias');

  DisposeHashTable(ht);
END.