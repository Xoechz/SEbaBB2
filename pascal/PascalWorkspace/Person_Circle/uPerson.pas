unit uPerson;

interface

Type
    Person = Object
            constructor Foo;
            procedure Init(name : string);
            procedure Destroy;
            function GetName : string;
            function HasAccessTo(room : string) : boolean; virtual;
        private
            name : string;
    end;

implementation

constructor Person.Foo;
begin
    //!WTF AM I DOING xD
end;

procedure Person.Init(name : string);
begin
    self.name := name;
end;

procedure Person.Destroy;
begin
    
end;

function Person.GetName : string;
begin
    GetName := self.name;
end;

function Person.HasAccessTo(room : string) : boolean;
begin
    HasAccessTo := room = 'Aula';
end;

begin
end.