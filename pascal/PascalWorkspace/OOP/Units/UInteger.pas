
UNIT UInteger;

INTERFACE

TYPE IntegerObj = OBJECT
  PRIVATE 
    value: INTEGER;
  PUBLIC 
    PROCEDURE Init(v: INTEGER);
    PROCEDURE Done;
    FUNCTION GetValue: INTEGER;
    PROCEDURE SetValue(v: INTEGER);
END;

IMPLEMENTATION

PROCEDURE IntegerObj.Init(v: INTEGER);
BEGIN
  value := v;
END;

PROCEDURE IntegerObj.Done;
BEGIN
END;

FUNCTION IntegerObj.GetValue: INTEGER;
BEGIN
  GetValue := value;
END;

PROCEDURE IntegerObj.SetValue(v: INTEGER);
BEGIN
  value := v;
END;

END.