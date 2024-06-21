PROGRAM TestStack;

USES
UCardinalStack;

TYPE 
  test = FUNCTION : BOOLEAN;

FUNCTION InitialStack_IsEmpty: BOOLEAN;
VAR 
  s: CardinalStack;
BEGIN (* InitialStack_IsEmpty *)
  s.Init();
  InitialStack_IsEmpty := s.IsEmpty();
  s.Done();
END; (* InitialStack_IsEmpty *)

FUNCTION PushOne_IsNotEmpty: BOOLEAN;
VAR 
  s: CardinalStack;
  pushOk: BOOLEAN;
BEGIN (* PushOne_IsNotEmpty *)
  s.Init();
  s.Push(1, pushOk);
  PushOne_IsNotEmpty := NOT s.IsEmpty()
                        AND pushOk;
  s.Done();
END; (* PushOne_IsNotEmpty *)

FUNCTION PushOnePopOne_IsEmpty: BOOLEAN;
VAR 
  s: CardinalStack;
  pushOk, popOk: BOOLEAN;
  value: INTEGER;
BEGIN (* PushOnePopOne_IsEmpty *)
  s.Init();
  s.Push(1, pushOk);
  s.Pop(value, popOk);
  PushOnePopOne_IsEmpty := s.IsEmpty()
                           AND pushOk
                           AND popOk
                           AND (value = 1);
  s.Done();
END; (* PushOnePopOne_IsEmpty *)

FUNCTION PushNegative_DoesNotPush: BOOLEAN;
VAR 
  s: CardinalStack;
  pushOk: BOOLEAN;
BEGIN (* PushNegative_DoesNotPush *)
  s.Init();
  s.Push(-1, pushOk);
  PushNegative_DoesNotPush := s.IsEmpty()
                              AND NOT pushOk;
  s.Done();
END; (* PushNegative_DoesNotPush *)

PROCEDURE RunTest(name: STRING; t: test);
BEGIN (* RunTest *)
  IF (t()) THEN
    BEGIN (* IF *)
      WriteLn('PASSED - ', name);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      WriteLn('FAILED - ', name);
      Halt(1);
    END; (* ELSE *)
END; (* RunTest *)

BEGIN (* TestStack *)
  WriteLn('CardinalStack:');
  RunTest('InitialStack_IsEmpty', InitialStack_IsEmpty);
  RunTest('PushOne_IsNotEmpty', PushOne_IsNotEmpty);
  RunTest('PushOnePopOne_IsEmpty', PushOnePopOne_IsEmpty);
  RunTest('PushNegative_DoesNotPush', PushNegative_DoesNotPush);
  WriteLn('All tests passed');
END. (* TestStack *)