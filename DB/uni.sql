-- Copilot ist ziemlich gut darin, SQL-Code zu generieren.
-- Promt
-- It should be possible to record students. A student's matriculation number, name and current semester should be recorded.
-- Students attend lectures that can build on each other, i.e. one lecture may require attendance of another lecture. Lectures are identified by a lecture number, a title and the number of semester hours per week. 
-- Lectures are held by professors. A professor is identified by his or her personnel number, name, rank and office. Professors hold examinations - i.e. students are assessed by professors. 
-- In addition, a professor conducts research and may be supported by assistants. These are identified by their personnel number, name and subject area


CREATE DATABASE University;
USE University;

CREATE TABLE Students (
    matriculation_number INT PRIMARY KEY,
    name VARCHAR(100),
    current_semester INT
);

CREATE TABLE Professors (
    personnel_number INT PRIMARY KEY,
    name VARCHAR(100),
    rank VARCHAR(50),
    office VARCHAR(50)
);

CREATE TABLE Assistants (
    personnel_number INT PRIMARY KEY,
    name VARCHAR(100),
    subject_area VARCHAR(100)
);

CREATE TABLE Lectures (
    lecture_number INT PRIMARY KEY,
    title VARCHAR(100),
    semester_hours INT,
    professor_number INT,
    FOREIGN KEY (professor_number) REFERENCES Professors(personnel_number)
);

CREATE TABLE LecturePrerequisites (
    lecture_number INT,
    prerequisite_lecture_number INT,
    PRIMARY KEY (lecture_number, prerequisite_lecture_number),
    FOREIGN KEY (lecture_number) REFERENCES Lectures(lecture_number),
    FOREIGN KEY (prerequisite_lecture_number) REFERENCES Lectures(lecture_number)
);

CREATE TABLE StudentLectures (
    student_number INT,
    lecture_number INT,
    PRIMARY KEY (student_number, lecture_number),
    FOREIGN KEY (student_number) REFERENCES Students(matriculation_number),
    FOREIGN KEY (lecture_number) REFERENCES Lectures(lecture_number)
);

CREATE TABLE ProfessorAssistants (
    professor_number INT,
    assistant_number INT,
    PRIMARY KEY (professor_number, assistant_number),
    FOREIGN KEY (professor_number) REFERENCES Professors(personnel_number),
    FOREIGN KEY (assistant_number) REFERENCES Assistants(personnel_number)
);

CREATE TABLE Grades (
    professor_number INT,
    student_number INT,
    lecture_number INT,
    grade VARCHAR(2),
    PRIMARY KEY (professor_number, student_number, lecture_number),
    FOREIGN KEY (professor_number) REFERENCES Professors(personnel_number),
    FOREIGN KEY (student_number) REFERENCES Students(matriculation_number),
    FOREIGN KEY (lecture_number) REFERENCES Lectures(lecture_number)
);