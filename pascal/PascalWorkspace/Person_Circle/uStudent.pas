unit uStudent;

interface

uses uPerson;

Type
    Student = Object(Person)
            procedure Init(name, code : string);
            function GetCode : string;
            function HasAccessTo(room : string) : boolean; virtual;
        private
            code : string;
    end;

implementation

procedure Student.Init(name, code : string);
begin
    inherited Init(name);
    self.code := code;
end;

function Student.GetCode : string;
begin
    GetCode := self.code;
end;

function Student.HasAccessTo(room : string) : boolean;
begin
    HasAccessTo :=
        inherited HasAccessTo(room) or
        (Length(room) > 0) and (room[1] = 'L');
end;

begin
end.