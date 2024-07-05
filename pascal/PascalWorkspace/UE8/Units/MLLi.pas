
UNIT MLLi;

INTERFACE

USES
MLObj, MLColl;

TYPE 

  MLObjectNodePtr = ^MLObjectNode;
  MLObjectNode = RECORD
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
BEGIN (* NewMLList *)
  New(l, Init);
  NewMLList := l;
END; (* NewMLList *)

CONSTRUCTOR MLListObj.Init;
BEGIN (* MLListObj *)
  INHERITED Init();
  Register('MLList', 'MLCollection');
  curSize := 0;
  head := NIL;
END; (* MLListObj *)

DESTRUCTOR MLListObj.Done;
BEGIN (* MLListObj *)
  Clear();
  INHERITED Done();
END; (* MLListObj *)

FUNCTION MLListObj.Size: INTEGER;
BEGIN (* MLListObj.Size *)
  Size := curSize;
END; (* MLListObj.Size *)

PROCEDURE MLListObj.Add(o: MLObject);
VAR 
  temp, prev: MLObjectNodePtr;
BEGIN (* MLListObj.Add *)
  curSize := curSize + 1;
  temp := head;
  prev := NIL;

  WHILE temp <> NIL DO
    BEGIN (* WHILE *)
      prev := temp;
      temp := temp^.next;
    END; (* WHILE *)

  New(temp);
  temp^.obj := o;
  temp^.next := NIL;

  IF prev = NIL THEN
    BEGIN (* IF *)
      head := temp
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      prev^.next := temp;
    END; (* ELSE *)
END; (* MLListObj.Add *)

FUNCTION MLListObj.Remove(o: MLObject): MLObject;
VAR 
  temp, prev: MLObjectNodePtr;
  found: BOOLEAN;
BEGIN (* MLListObj.Remove *)
  temp := head;
  prev := NIL;
  found := FALSE;

  WHILE ((temp <> NIL) AND (NOT found)) DO
    BEGIN (* WHILE *)
      IF temp^.obj^.IsEqualTo(o) THEN
        BEGIN (* IF *)
          found := TRUE;
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          prev := temp;
          temp := temp^.next;
        END; (* ELSE *)
    END; (* WHILE *)

  IF found THEN
    BEGIN (* IF *)
      curSize := curSize - 1;

      IF prev = NIL THEN
        BEGIN (* IF *)
          head := temp^.next;
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          prev^.next := temp^.next;
        END; (* ELSE *)

      Remove := temp^.obj;
      Dispose(temp);
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      Remove := NIL;
    END; (* ELSE *)
END; (* MLListObj.Remove *)

FUNCTION MLListObj.Contains(o: MLObject): BOOLEAN;
VAR 
  temp: MLObjectNodePtr;
  found: BOOLEAN;
BEGIN (* MLListObj.Contains *)
  temp := head;
  found := FALSE;

  WHILE ((temp <> NIL) AND (NOT found)) DO
    BEGIN (* WHILE *)
      IF temp^.obj^.IsEqualTo(o) THEN
        BEGIN (* IF *)
          found := TRUE;
        END (* IF *)
      ELSE
        BEGIN (* ELSE *)
          temp := temp^.next;
        END; (* ELSE *)
    END; (* WHILE *)

  Contains := found;
END; (* MLListObj.Contains *)


PROCEDURE MLListObj.Clear;
VAR 
  temp: MLObjectNodePtr;
BEGIN (* MLListObj.Clear *)
  WHILE head <> NIL DO
    BEGIN (* WHILE *)
      temp := head^.next;
      Dispose(head);
      head := temp;
    END; (* WHILE *)

  curSize := 0;
END; (* MLListObj.Clear *)

FUNCTION MLListObj.NewIterator: MLIterator;
VAR 
  it: MLListIterator;
BEGIN (* MLListObj.NewIterator *)
  New(it, Init(@SELF));
  NewIterator := it;
END; (* MLListObj.NewIterator *)

PROCEDURE MLListObj.Prepend(o: MLObject);
VAR 
  temp: MLObjectNodePtr;
BEGIN (* MLListObj.Prepend *)
  curSize := curSize + 1;
  New(temp);
  temp^.obj := o;
  temp^.next := head;
  head := temp;
END; (* MLListObj.Prepend *)

CONSTRUCTOR MLListIteratorObj.Init(list: MLList);
BEGIN (* MLListIteratorObj *)
  INHERITED Init();
  Register('MLListIterator', 'MLIterator');
  l := list;
  cur := l^.head;
END; (* MLListIteratorObj *)

DESTRUCTOR MLListIteratorObj.Done;
BEGIN (* MLListIteratorObj *)
  INHERITED Done;
END; (* MLListIteratorObj *)

FUNCTION MLListIteratorObj.Next: MLObject;
VAR 
  o: MLObject;
BEGIN (* MLListIteratorObj *)
  IF cur <> NIL THEN
    BEGIN (* IF *)
      o := cur^.obj;
      cur := cur^.next;
      Next := o;
    END (* IF *)
  ELSE
    BEGIN (* ELSE *)
      Next := NIL;
    END; (* ELSE *)
END; (* MLListIteratorObj.Next *)

FUNCTION MLListIteratorObj.GetList: MLList;
BEGIN (* MLListIteratorObj.GetList *)
  GetList := l;
END; (* MLListIteratorObj.GetList *)

END.