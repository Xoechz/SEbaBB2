unit uCircle;

interface

uses UPoint2D;

Type
    Circle = Object
            procedure Init(x, y : integer; radius : real);
            procedure Destroy;
            function GetRadius : real;
            procedure Print;
        private 
            center : Point2D;
            radius : real;
    end;

implementation

procedure Circle.Init(x, y : integer; radius : real);
begin
    self.center.Init(x,y);
    self.radius := radius;
end;

procedure Circle.Destroy;
begin
    self.center.Destroy;
end;

function Circle.GetRadius : real;
begin
    GetRadius := self.radius;
end;

procedure Circle.Print;
begin
    //WriteLn('Circle ');
    //self.center.Print;
    //WriteLn(' r = ', self.radius);
    WriteLn('Circle at (', self.center.GetX, ', ', self.center.GetY, ') r = ', self.radius:2:2);
end;

begin

end.