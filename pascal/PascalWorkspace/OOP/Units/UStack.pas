Unit UStack;

INTERFACE

const
  Size = 10;

type
  Stack = Object
    PROCEDURE InitStack;
    PROCEDURE DisposeStack;
    PROCEDURE Push(val: integer; var ok: boolean);
    PROCEDURE Pop(var val: integer; var ok: boolean);
    FUNCTION IsEmpty: boolean;

    PRIVATE
    data: array[1..Size] of integer;
    top: 0..Size;
  end;

IMPLEMENTATION

PROCEDURE Stack.InitStack;
begin
  top := 0;
end;

PROCEDURE Stack.DisposeStack;
begin
end;

PROCEDURE Stack.Push(val: integer; var ok: boolean);
begin
  if top = size then
    ok := false
  else
  begin
    ok := true;
    top := top + 1;
    data[top] := val;
  end;
end;

PROCEDURE Stack.Pop(var val: integer; var ok: boolean);
begin
  if top = 0 then
    ok := false
  else
  begin
    ok := true;
    val := data[top];
    top := top - 1;
  end;
end;

FUNCTION Stack.IsEmpty: boolean;
begin
  IsEmpty := top = 0;
end;

end.