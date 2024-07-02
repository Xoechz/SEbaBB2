PROGRAM Numbers;

USES
MLVect, MLInt, MLColl, MLObj;

VAR 
  v: MLVector;
  i:   MLInteger;
  it:  MLIterator;
  o:   MLObject;
  sum: INTEGER;
BEGIN
  new (v, Init);
  new (i, Init(2));

  v^.Add(i);

  it := v^.NewIterator();

  o := it^.Next;
  sum := 0;

  WHILE o <> NIL DO
    BEGIN
      WriteLn(MLInteger(o)^.GetValue);
      o := it^.Next;
      //if o^.IsA('MLInteger') then
      sum := sum + MLInteger(o)^.val;
    END;

  v^.DisposeElements();
  Dispose(v, Done);
END.