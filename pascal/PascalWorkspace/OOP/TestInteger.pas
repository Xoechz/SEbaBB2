PROGRAM TestInteger;

USES
UInteger;

VAR 
  i: IntegerObj;

BEGIN
  i.Init(5);
  writeln(i.GetValue());
  i.Done
END.