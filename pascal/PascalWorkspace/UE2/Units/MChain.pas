
UNIT MChain;

INTERFACE

FUNCTION MFor(s:STRING): INTEGER;
FUNCTION MaxMStringLen(s: STRING; m: INTEGER): INTEGER;

IMPLEMENTATION

TYPE 
  CountArray = ARRAY[CHAR] OF BYTE;

PROCEDURE InitCountArray(VAR ca: CountArray; VAR count: INTEGER);
VAR 
  i: CHAR;
BEGIN (*InitCountArray*)
  count := 0;
  FOR i := Low(CHAR) TO High(CHAR) DO
    BEGIN (*FOR*)
      ca[i] := 0;
    END; (*FOR*)
END; (*InitCountArray*)

PROCEDURE CountArrayAdd(VAR ca: CountArray; c: CHAR; VAR count: INTEGER);
BEGIN (*CountArrayAdd*)
  IF (ca[c] = 0) THEN
    BEGIN (*IF*)
      count := count + 1;
    END; (*IF*)
  ca[c] := ca[c] + 1;
END; (*CountArrayAdd*)

PROCEDURE CountArrayRemove(VAR ca: CountArray; c: CHAR; VAR ok: BOOLEAN; VAR count: INTEGER);
BEGIN (*CountArrayRemove*)
  ok := FALSE;
  IF (ca[c] <> 0) THEN
    BEGIN (*IF*)
      IF (ca[c] = 1) THEN
        BEGIN (*IF*)
          count := count - 1;
        END; (*IF*)
      ca[c] := ca[c] - 1;
      ok := TRUE;
    END; (*IF*)
END; (*CountArrayRemove*)

FUNCTION MFor(s: STRING): INTEGER;
VAR 
  i: INTEGER;
  ca: CountArray;
  count: INTEGER;
BEGIN (*MFor*)
  InitCountArray(ca, count);
  FOR i:=1 TO Length(s) DO
    BEGIN (*FOR*)
      CountArrayAdd(ca, s[i], count);
    END; (*FOR*)
  MFor := count;
END; (*MFor*)

FUNCTION MaxMStringLen(s: STRING; m: INTEGER): INTEGER;
VAR 
  i, j, count, maxLength: INTEGER;
  ca: CountArray;
  ok: BOOLEAN;
BEGIN (*MaxMStringLen*)
  InitCountArray(ca, count);
  i := 1;
  j := 1;
  maxLength := 0;
  ok := TRUE;
  WHILE ((ok) AND (j <= Length(s))) DO
    BEGIN (*WHILE*)
      IF (count <= m) THEN
        BEGIN (*IF*)
          CountArrayAdd(ca, s[j], count);
          j := j + 1;
          IF ((count <= m) AND (j - i > maxLength)) THEN
            BEGIN (*IF*)
              maxLength := j - i;
            END; (*IF*)
        END (*IF*)
      ELSE
        BEGIN (*ELSE*)
          CountArrayRemove(ca, s[i], ok, count);
          i := i + 1;
        END; (*ELSE*)
    END; (*WHILE*)

  IF (ok) THEN
    BEGIN (*IF*)
      MaxMStringLen := maxLength;
    END (*IF*)
  ELSE
    BEGIN (*ELSE*)
      WriteLn('An error occured in MaxMStringLen');
      MaxMStringLen := 0
    END; (*ELSE*)
END; (*MaxMStringLen*)

END.