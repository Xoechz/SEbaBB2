program Test;

uses
    uCircle;

var
    c : Circle;

begin
    c.Init(3, 4, 1.5);

    //WriteLn(c.GetX);
    //WriteLn(c.GetY);
    c.Print;
    //c.Print;

    c.Destroy;
end.