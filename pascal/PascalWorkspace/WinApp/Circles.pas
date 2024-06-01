PROGRAM Circles;

uses 
  windows,
  WinApp;

type
  PosPtr = ^Position;
  Position = record
    x, y, sx, sy: integer;
    next: PosPtr;
  end;

var
  positions: PosPtr;

PROCEDURE DrawCircles(dc: HDC; p: PosPtr);
var
  pen, oldPen: HPen;
  brush, oldBrush: HBrush;
begin
  if(p <> nil) then
  begin
    DrawCircles(dc, p^.next);
    pen := CreatePen(PS_SOLID, 1, RGB(Random(255), Random(255), Random(255)));
    oldPen := selectObject(dc, pen);
    brush := CreateSolidBrush(RGB(Random(255), Random(255), Random(255)));
    oldBrush := selectObject(dc, brush);
    Ellipse(dc, p^.x - p^.sx div 2, p^.y - p^.sy div 2, p^.x + p^.sx div 2, p^.y + p^.sy div 2);
    selectObject(dc, oldBrush);
    DeleteObject(brush); 
    selectObject(dc, oldPen);
    DeleteObject(pen);
  end;
end;

PROCEDURE Paint(wnd: HWnd; dc: HDC);
begin
  DrawCircles(dc, positions);
end;

PROCEDURE MouseDown(wnd: HWnd; x, y: INTEGER);
var 
  p: PosPtr;
  sx, sy, vx, vy: integer;
begin
  sx := Random(190) + 10;
  sy := Random(190) + 10;
  vx := Random(20) - 10;
  vy := Random(20) - 10;
  WHILE (sx >= 10) and (sy >= 10) DO
  begin
    New(p);
    p^.x := x;
    p^.y := y;
    p^.sx := sx;
    p^.sy := sy;
    p^.next := positions;
    positions := p;
    x := x + vx;
    y := y + vy;
    sx := sx - 1 - sx div 20;
    sy := sy - 1 - sy div 20;
  end;
  InvalidateRect(wnd, nil, true);
end;

var
  p: PosPtr;
begin
  Randomize;
  positions := nil;
  OnPaint := Paint;
  OnMouseDown := MouseDown;
  Run;
  
  WHILE positions <> nil DO
  begin
    p := positions^.next;
    Dispose(positions);
    positions := p;
  end;
end.