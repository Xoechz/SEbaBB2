UNIT UPoint2D;

INTERFACE
  TYPE
    Point2D = object
        PROCEDURE Init(x, y: INTEGER);
        PROCEDURE Destroy;
        FUNCTION GetX: INTEGER;
        FUNCTION GetY: INTEGER;
        PROCEDURE Print;
      PRIVATE
        x,y: INTEGER;
    END;  

    

IMPLEMENTATION

  PROCEDURE Point2D.Init(x,y: INTEGER);
  BEGIN
    SELF.x := x;
    SELF.y := y;
  END;

  PROCEDURE Point2D.Destroy;
  BEGIN
    // NOTHING
  END;

  FUNCTION Point2D.GetX: INTEGER;
  BEGIN
    GetX := SELF.x;
  END;

  FUNCTION Point2D.GetY: INTEGER;
  BEGIN
    GetY := SELF.y;
  END;

  PROCEDURE Point2D.Print;
  BEGIN
    WriteLn('(', SELF.x, ' ', SELF.y, ')');
  END;



BEGIN

END.