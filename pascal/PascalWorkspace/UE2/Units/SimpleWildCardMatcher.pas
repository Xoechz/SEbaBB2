
UNIT SimpleWildCardMatcher;

INTERFACE
FUNCTION SimpleMatches(pattern, text: STRING): BOOLEAN;

IMPLEMENTATION
FUNCTION SimpleMatches(pattern, text: STRING): BOOLEAN;
VAR 
  i: INTEGER;
  result: BOOLEAN;
BEGIN (* SimpleMatches *)
  i := 1;
  result := TRUE;

  IF ((Length(pattern) = 0) OR (Length(text) = 0) OR (pattern[Length(pattern)] <> '$') OR (text[Length(text)] <> '$')) THEN
    BEGIN (*IF*)
      (* Invalid pattern or text *)
      result := FALSE;
    END; (*IF*)

  IF ((result) AND (Length(pattern) = Length(text))) THEN
    BEGIN (*IF*)
      WHILE ((result) AND (i <= Length(pattern))) DO
        BEGIN (*WHILE*)
          IF ((pattern[i] <> text[i]) AND (pattern[i] <> '?')) THEN
            BEGIN (*IF*)
              result := FALSE;
            END; (*IF*)
          i := i + 1;
        END; (*WHILE*)
    END (*IF*)
  ELSE
    BEGIN (*ELSE*)
      result := FALSE;
    END; (*ELSE*)

  SimpleMatches := result;
END; (* SimpleMatches *)

END.