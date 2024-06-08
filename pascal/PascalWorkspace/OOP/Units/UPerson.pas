
UNIT UPerson;

INTERFACE

TYPE 
  Person = OBJECT
    PROCEDURE Init(name: STRING);
    procedure Done;
        FUNCTION GetName(): STRING;

    PRIVATE 
      name: STRING;
  END;

IMPLEMENTATION

PROCEDURE Person.Init(name: STRING);
BEGIN
  SELF.name := name;
END;

PROCEDURE Person.Done;
BEGIN
END;

FUNCTION Person.GetName(): STRING;
BEGIN
  GetName := SELF.name;
END;

END.