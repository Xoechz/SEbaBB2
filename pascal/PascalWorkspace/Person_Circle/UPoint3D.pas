UNIT UPoint3D;

INTERFACE
  USES
    UPoint2D;
    
  TYPE
    Point3D = OBJECT(Point2D) // abgeleitete von Point2D
        PROCEDURE Init(x, y, z: INTEGER); // ersetzt gleichnamige Funktion aus Basisklasse
        FUNCTION GetZ: INTEGER;
        PROCEDURE Print;
      PRIVATE
        z: INTEGER; // new additional component
    END;

IMPLEMENTATION

  PROCEDURE Point3D.Init(x, y, z: INTEGER);
  BEGIN
    INHERITED Init(x, y); // ALWAYS call base Init at first - no exception!
    SELF.z := z;
  END;

  FUNCTION Point3D.GetZ: INTEGER;
  BEGIN
    GetZ := SELF.z;
  END;

  PROCEDURE Point3D.Print;
  BEGIN
    WriteLn('(', Point2D.GetX, ' ', Point2D.GetY, ' ', SELF.z, ')');

  END;


BEGIN
END.