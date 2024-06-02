PROGRAM Circle;

VAR
  r, pi, A, U: INTEGER;
BEGIN
  READ(r);
  READ(pi);
  A := r * r * pi;
  U := r * 2 * pi;
  WRITE(A);
  WRITE(U);
END.