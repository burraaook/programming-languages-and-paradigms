:- dynamic(student/3).
:- dynamic(course/6).
:- dynamic(room/4).
:- dynamic(instructor/3).
:- style_check(-singleton).

% instructor(ID, Courses, Preferences)
instructor(inst01, [cse222, cse496], [projector]).
instructor(inst02, [cse102, cse341], [projector, handicapped]).
instructor(inst03, [cse101, cse321], [smartboard]).
instructor(inst04, [cse201, cse421], [smartboard, handicapped]).
instructor(inst05, [cse331, cse447], []).
instructor(inst06, [cse311, cse441], [smartboard]).
instructor(inst07, [cse201], [projector]).
instructor(inst08, [cse421], [smartboard]).
instructor(inst09, [cse331], []).
instructor(inst10, [cse447], []).
instructor(inst11, [cse311], [smartboard]).
instructor(inst12, [cse441], [projector]).
instructor(inst13, [cse111], [smartboard]).
instructor(inst14, [cse211], []).
instructor(inst15, [cse361], [projector]).


% room(ID, Capacity, Hours, Equipments)
room(z23, 130, [8, 9, 10, 11, 12, 13, 14, 15, 16, 17], [projector, smartboard, handicapped]).
room(z10, 110, [8, 9, 10, 11, 12, 13, 14, 15, 16, 17], [projector]).
room(z11, 120, [9, 10, 11, 12, 15, 16], [smartboard]).
room(z06, 100, [9, 10, 11, 12, 13, 14, 15, 16, 17], []).
room(z07, 80, [11, 12, 13, 14, 15], [projector, handicapped]).

% course(ID, Instructor, Capacity, Hours, Room, Special_Requirements)
course(cse222, inst01, 70, [8, 9], z23, [projector, smartboard]).
course(cse496, inst02, 50, [9, 10], z10, []).
course(cse102, inst03, 60, [10, 11], z23, [smartboard]).
course(cse341, inst04, 50, [12, 13], z06, []).
course(cse101, inst05, 60, [11, 12], z23, [projector]). % conflict with cse102
course(cse321, inst06, 50, [15, 16, 17], z23, [smartboard]).
course(cse201, inst07, 60, [11, 12], z10, [projector]).
course(cse421, inst08, 50, [8, 9, 10], z11, [smartboard]).
course(cse331, inst09, 60, [9, 10, 11], z06, []).
course(cse447, inst10, 50, [14, 15], z07, []).
course(cse311, inst11, 60, [13, 14], z23, [smartboard]).
course(cse441, inst12, 50, [16, 17], z10, [projector]).
course(cse111, inst13, 60, [11, 12], z11, [smartboard]).
course(cse211, inst14, 50, [12, 13, 14], z06, []). % conflict with cse341 for hours 12 and 13
course(cse361, inst15, 60, [11, 12, 13], z07, [projector]).

% Occupancy of a room at a given time(Room, Course, Hours)
occupancy(z23, cse222, [8, 9]).
occupancy(z23, cse102, [10, 11]).
occupancy(z23, cse321, [15, 16, 17]).
occupancy(z23, cse311, [13, 14]).
occupancy(z10, cse496, [9, 10]).
occupancy(z10, cse201, [11, 12]).
occupancy(z10, cse441, [16, 17]).
occupancy(z11, cse421, [8, 9, 10]).
occupancy(z11, cse111, [11, 12]).
occupancy(z06, cse341, [12, 13]).
occupancy(z06, cse331, [9, 10, 11]).
occupancy(z07, cse447, [14, 15]).
occupancy(z07, cse311, [11, 12, 13]).



% student(ID, Courses, Handicap)
student(001, [cse222, cse496, cse102, cse341], no).
student(002, [cse101, cse102], yes).
student(003, [cse102, cse331, cse421], no).
student(004, [cse421, cse447, cse441], no).
student(005, [cse101, cse321, cse201], no).
student(006, [cse321, cse421, cse331], no).
student(007, [cse101, cse321, cse201, cse496, cse111], no).
student(008, [cse321, cse421, cse331, cse447, cse211], no).
student(009, [cse101, cse321, cse201, cse496, cse111, cse211], no).
student(010, [cse321, cse421, cse331, cse447, cse211, cse311], no).
student(011, [cse101, cse321, cse201], no).
student(012, [cse201, cse421, cse102], yes).
student(013, [cse101, cse321, cse201, cse496, cse111], no).
student(014, [cse321, cse421, cse331, cse447, cse211], no).
student(015, [cse101, cse321, cse201, cse496, cse111, cse211], no).
student(016, [cse321, cse421, cse331, cse447, cse211, cse311], no).
student(017, [cse101, cse321, cse201], no).
student(018, [cse321, cse421, cse331], no).
student(019, [cse101, cse321, cse201, cse496, cse111], no).
student(020, [cse447, cse211], no).


% add a student to the database, check for id uniqueness
add_student(ID, Courses, Handicap) :-
                                    % check if the student has already been added
                                    \+ student(ID, _, _),
                                    assertz(student(ID, Courses, Handicap)).

% add a course to the database, check for id uniqueness, and check if the instructor exists
add_course(ID, Instructor, Capacity, Hours, Room, Special_Requirements) :- 
                                    % check if the course has already been added
                                    \+ course(ID, _, _, _, _, _),
                                    instructor(Instructor, _, _),
                                    assertz(course(ID, Instructor, Capacity, Hours, Room, Special_Requirements)).

% add an instructor to the database, check for id uniqueness
add_room(ID, Capacity, Hours, Equipments) :- 
                                    % check if the room has already been added
                                    \+ room(ID, _, _, _),
                                    assertz(room(ID, Capacity, Hours, Equipments)).

% check scheduling conflict
conflict(Course1, Course2) :- 
                            course(Course1, _, _, Hours1, _, _),
                            course(Course2, _, _, Hours2, _, _),

                            % check if hours have a common element
                            intersection(Hours1, Hours2, CommonHours),
                            CommonHours \= [].
                            
% check which rooms are available for a given course
available_rooms(Course, Room) :- 
                    course(Course, Instructor, CourseCap, Hours, _, Needs),
                    instructor(Instructor, _, Preferences),
                    room(Room, RoomCap, RoomHours, Equipments),
                    
                    % check capacity
                    CourseCap =< RoomCap,
                   
                    % check hours, course's our must be a subset of room's hours
                    subset(Hours, RoomHours),
                    
                    % check if the room has the required equipments
                    subset(Needs, Equipments),

                    % check if instructor preferences are satisfied, it must be a subset of room's equipments
                    subset(Preferences, Equipments).

check_handicap(Handicap, Equipments) :- Handicap = no.

check_handicap(Handicap, Equipments) :- 
                                    Handicap = yes,
                                    member(handicapped, Equipments).


% check if a student can enroll in a course
enroll(Student, Course) :-
                                student(Student, _, Handicap),
                                course(Course, _, _, _, Room, _),
                                room(Room, _, _, Equipments),
                                % check if the students handicap is satisfied by the room
                                check_handicap(Handicap, Equipments).
