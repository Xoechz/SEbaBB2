PROGRAM TestMChains;

USES 
MChain;

PROCEDURE TestMFor(s: STRING);
BEGIN (*TestMFor*)
  WriteLn(s, ' ', MFor(s));
END; (*TestMFor*)

PROCEDURE TestMaxMStringLen(s: STRING; i :INTEGER);
BEGIN (*TestMaxMStringLen*)
  WriteLn(s, ' ', i, ' ', MaxMStringLen(s, i));
END; (*TestMaxMStringLen*)

BEGIN (*TestMChains*)
  WriteLn('MFor:');
  TestMFor('a');
  TestMFor('aa');
  TestMFor('aaa');
  TestMFor('ab');
  TestMFor('abc');
  TestMFor('ababababababa');
  TestMFor('');
  TestMFor('aabababababababac');
  TestMFor('aA');
  TestMFor('a1+#');

  WriteLn();
  WriteLn('MaxMStringLen:');
  TestMaxMStringLen('a', 1);
  TestMaxMStringLen('a', 2);
  TestMaxMStringLen('a', 0);
  TestMaxMStringLen('', 1);
  TestMaxMStringLen('', 0);
  TestMaxMStringLen('ababababa', 2);
  TestMaxMStringLen('ababaababa', 1);
  TestMaxMStringLen('abcabaabcaba', 2);
  TestMaxMStringLen('abcabaabcaba', 3);
  TestMaxMStringLen('abcabaabcaba', 3);
  TestMaxMStringLen('ababacac', 2);
  TestMaxMStringLen('babacaca', 2);
  TestMaxMStringLen('+-+-+*+*', 2);
  TestMaxMStringLen('-+-+*+*+', 2);
END. (*TestMChains*)