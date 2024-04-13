
UNIT RecursiveWildCardMatcher;

INTERFACE
FUNCTION RecursiveMatches(pattern, text: STRING): BOOLEAN;

IMPLEMENTATION
FUNCTION RecursiveMatches(pattern, text: STRING): BOOLEAN;
VAR 
  gotResult: BOOLEAN;
BEGIN (* RecursiveMatches *)
  gotResult := FALSE;

  IF ((Length(pattern) = 0) OR (Length(text) = 0) OR (pattern[Length(pattern)] <> '$') OR (text[Length(text)] <> '$')) THEN
    BEGIN (*IF*)
      (* Invalid pattern or text *)
      RecursiveMatches := FALSE;
      gotResult := TRUE;
    END; (*IF*)

  IF ((Length(pattern) = 1) AND (Length(text) = 1) AND (pattern[1] = '$') AND (text[1] = '$')) THEN
    BEGIN (*IF*)
      RecursiveMatches := TRUE;
      gotResult := TRUE;
    END; (*IF*)

  IF (NOT gotResult) THEN
    BEGIN (*IF*)
      IF ((pattern[1] = '?') OR (text[1] = pattern[1])) THEN
        BEGIN (*IF*)
          RecursiveMatches := RecursiveMatches(Copy(pattern, 2, Length(pattern) - 1), Copy(text, 2, Length(text) - 1));
        END (*IF*)
      ELSE
        IF (pattern[1] = '*') THEN
          BEGIN (*IF*)
            RecursiveMatches := RecursiveMatches(Copy(pattern, 2, Length(pattern) - 1), Copy(text, 2, Length(text) - 1))
                                OR RecursiveMatches(pattern, Copy(text, 2, Length(text) - 1))
                                OR RecursiveMatches(Copy(pattern, 2, Length(pattern) - 1), text);
          END (*IF*)
      ELSE
        BEGIN (*ELSE*)
          RecursiveMatches := FALSE;
        END; (*ELSE*)
    END; (*IF*)
END; (* RecursiveMatches *)

END.