UNIT MLLi;

INTERFACE

USES
MLObj, MLColl;

TYPE 

  MLObjectNodePtr = ^MLObjectNode;
  MLObjectNode = Record
    obj: MLObject;
    next: MLObjectNodePtr;
  END;

  MLListIterator = ^MLListIteratorObj; 

  MLList = ^MLListObj;
  MLListObj = OBJECT(MLCollectionObj)

    CONSTRUCTOR Init;

    DESTRUCTOR Done; VIRTUAL;

    FUNCTION Size: INTEGER; VIRTUAL;

    PROCEDURE Add(o: MLObject); VIRTUAL;

    FUNCTION Remove(o: MLObject): MLObject; VIRTUAL;

    FUNCTION Contains(o: MLObject): BOOLEAN; VIRTUAL;

    PROCEDURE Clear; VIRTUAL;

    FUNCTION NewIterator: MLIterator; VIRTUAL;

   PROCEDURE Prepend(o: MLObject); VIRTUAL;

    PRIVATE 

head: MLObjectNodePtr;
curSize: INTEGER;

  END;

  MLListIteratorObj = OBJECT(MLIteratorObj)

    CONSTRUCTOR Init(list: MLList);

    DESTRUCTOR Done; VIRTUAL;

    FUNCTION Next: MLObject; VIRTUAL;

    FUNCTION GetList: MLList; VIRTUAL;

    PRIVATE 

    cur: MLObjectNodePtr;

    l: MLList;

  END;


FUNCTION NewMLList: MLList;

IMPLEMENTATION

USES
MetaInfo;

FUNCTION NewMLList: MLList;
VAR 
  l: MLList;
BEGIN
  New(l, Init);
  NewMLList := l;
END;

CONSTRUCTOR MLListObj.Init;
BEGIN
  INHERITED Init();
  Register('MLList', 'MLCollection');
  curSize := 0;
  head := NIL;
END; 

DESTRUCTOR MLListObj.Done;
BEGIN
Clear();
  INHERITED Done();
END;

FUNCTION MLListObj.Size: INTEGER;
BEGIN
  Size := curSize;
END;

PROCEDURE MLListObj.Add(o: MLObject);
var 
  temp, prev: MLObjectNodePtr;
BEGIN
  curSize := curSize + 1;
  temp := head;
  prev := NIL;

  while temp <> NIL do
  BEGIN
    prev := temp;
    temp := temp^.next;
  END;

  New(temp);
  temp^.obj := o;
  temp^.next := NIL;

  if prev = NIL then
  BEGIN
    head := temp
  end
  else
  BEGIN
    prev^.next := temp;
END;
END;

FUNCTION MLListObj.Remove(o: MLObject): MLObject;
var
  temp, prev: MLObjectNodePtr;
  found: BOOLEAN;
BEGIN
  temp := head;
  prev := NIL;
  found := FALSE;

  while ((temp <> NIL) and (not found)) do
  BEGIN
    if temp^.obj^.IsEqualTo(o) then
    BEGIN
      found := TRUE;
    end
    else
    BEGIN
      prev := temp;
      temp := temp^.next;
    END;
  END;

  if found then
  BEGIN
    curSize := curSize - 1;

    if prev = NIL then
    BEGIN
      head := temp^.next;
    end
    else
    BEGIN
      prev^.next := temp^.next;
    end;
    
    Remove := temp^.obj;
    Dispose(temp);
  end
  else
  BEGIN
    Remove := NIL;
  end;
END;

FUNCTION MLListObj.Contains(o: MLObject): BOOLEAN;
var
  temp: MLObjectNodePtr;
  found: BOOLEAN;
BEGIN
  temp := head;
  found := FALSE;

  while ((temp <> NIL) and (not found)) do
  BEGIN
    if temp^.obj^.IsEqualTo(o) then
    BEGIN
      found := TRUE;
    end
    else
    BEGIN
      temp := temp^.next;
    END;
  END;

 Contains := found;
END;


PROCEDURE MLListObj.Clear;
VAR 
  temp: MLObjectNodePtr;
BEGIN
while head <> NIL do
    BEGIN
      temp := head^.next;
      Dispose(head);
      head := temp;
    END;

  curSize := 0;
END;

FUNCTION MLListObj.NewIterator: MLIterator;
VAR 
  it: MLListIterator;
BEGIN
  New(it, Init(@SELF));
  NewIterator := it;
END;

PROCEDURE MLListObj.Prepend(o: MLObject);
var 
  temp: MLObjectNodePtr;
BEGIN
  curSize := curSize + 1;
  New(temp);
  temp^.obj := o;
  temp^.next := head;
  head := temp;
END;

CONSTRUCTOR MLListIteratorObj.Init(list: MLList);
BEGIN
  INHERITED Init();
  Register('MLListIterator', 'MLIterator');
  l := list;
  cur := l^.head;
END;

DESTRUCTOR MLListIteratorObj.Done;
BEGIN
  INHERITED Done;
END;

FUNCTION MLListIteratorObj.Next: MLObject;
VAR 
  o: MLObject;
BEGIN
  IF cur <> NIL THEN
  BEGIN
    o := cur^.obj;
    cur := cur^.next;
    Next := o;
  END
  ELSE
  BEGIN
    Next := NIL;
  END;
END;

FUNCTION MLListIteratorObj.GetList: MLList;
BEGIN
  GetList := l;
END;

END.