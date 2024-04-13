PROGRAM TestWildCards;

USES 
SimpleWildCardMatcher, RecursiveWildCardMatcher;

PROCEDURE TestSimpleMatches(p, s: STRING);
BEGIN (*TestSimpleMatches*)
  WriteLn(p, ' ', s, ' ', SimpleMatches(p, s));
END; (*TestSimpleMatches*)

PROCEDURE TestRecursiveMatches(p, s: STRING);
BEGIN (*TestRecursiveMatches*)
  WriteLn(p, ' ', s, ' ', RecursiveMatches(p, s));
END; (*TestRecursiveMatches*)

BEGIN (*TestWildCards*)
  WriteLn('Simple Wildcard Matcher:');
  TestSimpleMatches('ABC$', 'ABC$');
  TestSimpleMatches('ABC$', 'AB$');
  TestSimpleMatches('ABC$', 'ABCD$');
  TestSimpleMatches('A?C$', 'AXC$');
  TestSimpleMatches('A?C$', 'AXXC$');
  TestSimpleMatches('A?C$', 'AC$');
  TestSimpleMatches('A?C?E$', 'ABCDE$');
  TestSimpleMatches('A?C?$', 'ABCD$');
  TestSimpleMatches('ABC', 'ABC');
  TestSimpleMatches('', '');
  TestSimpleMatches('ABC', '');
  TestSimpleMatches('', 'ABC');
  TestSimpleMatches('$', '$');
  TestSimpleMatches('', '$');
  TestSimpleMatches('$', '');

  WriteLn('Recursive Wildcard Matcher:');
  TestRecursiveMatches('ABC$', 'ABC$');
  TestRecursiveMatches('ABC$', 'AB$');
  TestRecursiveMatches('ABC$', 'ABCD$');
  TestRecursiveMatches('A?C$', 'AXC$');
  TestRecursiveMatches('*$', '');
  TestRecursiveMatches('*$', '$');
  TestRecursiveMatches('*$', 'ABC$');
  TestRecursiveMatches('*$', '*$');
  TestRecursiveMatches('*$', '*');
  TestRecursiveMatches('A*C$', 'AC$');
  TestRecursiveMatches('A*C$', 'AXC$');
  TestRecursiveMatches('A*C$', 'AXYZC$');
  TestRecursiveMatches('A*C$', 'A$');
  TestRecursiveMatches('A**C$', 'AC$');
  TestRecursiveMatches('A**C$', 'AXC$');
  TestRecursiveMatches('A**C$', 'AXYZC$');
  TestRecursiveMatches('A**C$', 'A$');
END. (*TestWildCards*)