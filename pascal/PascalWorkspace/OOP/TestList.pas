PROGRAM TestList;

USES
UList, heaptrc;

VAR 
  l: List;
  i: integer;
  ok: boolean;
BEGIN
  l.Init;
  l.Append(1, ok);
  WriteLn('ok = ', ok);
  l.Append(2, ok);
  WriteLn('ok = ', ok);
  l.Prepend(3, ok);
  WriteLn('ok = ', ok);
  l.Print();
  WHILE (ok) DO
    BEGIN
      l.RemoveFirst(i, ok);
      WriteLn('i = ', i, ' ok = ', ok, ' isEmpty = ', l.IsEmpty);
      l.Print();
    END;

  l.Done;
END.