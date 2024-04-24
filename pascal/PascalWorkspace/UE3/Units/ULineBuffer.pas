
UNIT ULineBuffer;

INTERFACE

TYPE 
  LineBufferPrt = ^LineBufferNode;
  LineBufferNode = RECORD
    buffer : STRING;
    next : LineBufferPrt;
  END;
  LineBuffer = ^LineBufferNode;

PROCEDURE InitLineBuffer(VAR lb: LineBuffer);
PROCEDURE DisposeLineBuffer(VAR lb: LineBuffer);
PROCEDURE ClearLineBuffer(VAR lb: LineBuffer);
PROCEDURE AppendToLineBuffer(VAR lb: LineBuffer; line: STRING);
PROCEDURE WriteLineBuffer(VAR outFile: TEXT; VAR lb: LineBuffer; scale: INTEGER);

IMPLEMENTATION

PROCEDURE InitLineBuffer(VAR lb: LineBuffer);
BEGIN (* InitLineBuffer *)
  new(lb);
  lb^.buffer := '';
  lb^.next := NIL;
END; (* InitLineBuffer *)

PROCEDURE DisposeLineBuffer(VAR lb: LineBuffer);
VAR 
  next: LineBufferPrt;
BEGIN (* DisposeLineBuffer *)
  WHILE (lb <> NIL) DO
    BEGIN (* WHILE *)
      next := lb^.next;
      DISPOSE(lb);
      lb := next;
    END; (* WHILE *)
END; (* DisposeLineBuffer *)

PROCEDURE ClearLineBuffer(VAR lb: LineBuffer);
VAR 
  temp, next: LineBufferPrt;
BEGIN (* ClearLineBuffer *)
  temp := lb^.next;

  WHILE (temp <> NIL) DO
    BEGIN (* WHILE *)
      next := temp^.next;
      DISPOSE(temp);
      temp := next;
    END; (* WHILE *)

  lb^.buffer := '';
  lb^.next := NIL;
END; (* ClearLineBuffer *)

PROCEDURE AppendToLineBuffer(VAR lb: LineBuffer; line: STRING);
VAR 
  prev, newNode: LineBufferPrt;
BEGIN (* AppendToLineBuffer *)
  prev := lb;

  WHILE (prev^.next <> NIL) DO
    BEGIN (* WHILE *)
      prev := prev^.next;
    END; (* WHILE *)

  IF (prev^.buffer = '') THEN
    BEGIN (* IF *)
      prev^.buffer := line;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      new(newNode);
      newNode^.next := NIL;
      newNode^.buffer := line;
      prev^.next := newNode;
    END; (* ELSE *)
END;

PROCEDURE WriteScaledLine(VAR outFile: TEXT; line: STRING; scale: INTEGER; VAR countModScale: INTEGER);
VAR 
  i, j: INTEGER;
BEGIN (* WriteScaledLine *)
  FOR i := 1 TO Length(line) DO
    BEGIN (* FOR *)
      IF (scale > 0) THEN
        BEGIN (* IF *)
          FOR j := 1 TO scale DO
            BEGIN (* FOR *)
              write(outFile, line[i]);
            END; (* FOR *)
        END (* IF *)
      ELSE
        IF ((countModScale MOD scale) = 0) THEN
          BEGIN (* ELSE IF *)
            write(outFile, line[i]);
          END; (* ELSE IF *)

      countModScale := (countModScale + 1) MOD scale;
    END; (* FOR *)
END; (* WriteScaledLine *)

PROCEDURE WriteLineBuffer(VAR outFile: TEXT; VAR lb: LineBuffer; scale: INTEGER);
VAR 
  temp: LineBufferPrt;
  countModScale: INTEGER;
BEGIN (* WriteLineBuffer *)
  temp := lb;
  countModScale := 0;

  WHILE (temp <> NIL) DO
    BEGIN (* WHILE *)
      IF (scale = 1) THEN
        BEGIN (* IF *)
          write(outFile, temp^.buffer);
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          WriteScaledLine(outFile, temp^.buffer, scale, countModScale)
        END; (* ELSE *)

      temp := temp^.next;
    END; (* WHILE *)

  writeln(outFile);
END; (* WriteLineBuffer *)

END.