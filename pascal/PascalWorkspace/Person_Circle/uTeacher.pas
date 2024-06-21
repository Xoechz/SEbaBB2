unit uTeacher;

interface

uses uPerson;

Type
    Teacher = Object(Person)
            function HasAccessTo(room : string) : boolean;
        private
        end;

implementation

function Teacher.HasAccessTo(room : string) : boolean;
begin
    HasAccessTo := True;
end;

begin
end.