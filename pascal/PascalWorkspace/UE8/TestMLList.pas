PROGRAM TestMLList;

USES
MLLi, MLInt, MLColl, MLObj;

VAR 
  l: MLList;
  i1, i2, i3:   MLInteger;
  it:  MLIterator;
  o:   MLObject;
  sum: INTEGER;
BEGIN
  l := NewMLList();
  new (i1, Init(2));
  new (i2, Init(3));
  new (i3, Init(1));

  l^.Add(i1);
  l^.Add(i2);
  l^.Prepend(i3);

  it := l^.NewIterator();

  o := it^.Next;
  sum := 0;

  WHILE o <> NIL DO
    BEGIN
      WriteLn(MLInteger(o)^.val);
      if o^.IsA('MLInteger') then
      BEGIN
      sum := sum + MLInteger(o)^.val;
      end;
      o := it^.Next;
    END;

  l^.DisposeElements();
  Dispose(l, Done);
END.