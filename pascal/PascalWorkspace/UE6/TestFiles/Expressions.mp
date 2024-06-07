PROGRAM ExressionTest;

var
  a, b: INTEGER;
BEGIN
  Read(a);
  Read(b);
  Write( 0 + (17 + 4) * 1 );
  Write((50 / 2 * ((25 - 14) * (1 + 14) 
    + 14 * (1 - 25 + 14))) 
    + (20 + 2 * 22 - 23));
  Write((50 / 2 * ((25 - 14) * (1 + 14) 
    + 14 * (a - 25 + 14))) 
    + (20 + b * 22 - 23));
END.