% Scheduling and Timetable Management System in Prolog

% Facts: Define rooms, teachers, subjects, and time slots
room(r101, 30).
room(r102, 50).
room(r103, 40).
room(r104, 60).
teacher(t1, [math, physics]).
teacher(t2, [english, history]).
teacher(t3, [chemistry, biology]).
teacher(t4, [geography, economics]).
time_slot(ts1).
time_slot(ts2).
time_slot(ts3).
time_slot(ts4).
time_slot(ts5).

% Facts: Schedule assignments
scheduled(class1, math, t1, r101, ts1).
scheduled(class2, english, t2, r102, ts2).
scheduled(class3, biology, t3, r103, ts3).
scheduled(class4, history, t2, r104, ts4).

% Rules: Check constraints
available_teacher(T, Subj, Slot) :-
    teacher(T, Subjects),
    member(Subj, Subjects),
    \+ (scheduled(_, _, T, _, Slot)).

available_room(Room, Slot) :-
    room(Room, _),
    \+ (scheduled(_, _, _, Room, Slot)).

no_conflict(T, Room, Slot) :-
    available_teacher(T, _, Slot),
    available_room(Room, Slot).

% Rules: Assignments
assign_class(Class, Subj, T, Room, Slot) :-
    available_teacher(T, Subj, Slot),
    available_room(Room, Slot),
    assertz(scheduled(Class, Subj, T, Room, Slot)).

% Remove class
remove_class(Class) :-
    retract(scheduled(Class, _, _, _, _)).

% Modify class
modify_class(Class, NewSubj, NewTeacher, NewRoom, NewSlot) :-
    remove_class(Class),
    assign_class(Class, NewSubj, NewTeacher, NewRoom, NewSlot).

% Queries for User Interaction
query_schedule :-
    write('Enter teacher name: '), read(Teacher),
    findall([C, S, R, T], scheduled(C, S, Teacher, R, T), Schedules),
    write('Schedule: '), write(Schedules), nl.

query_free_slot :-
    write('Enter room: '), read(Room),
    findall(S, available_room(Room, S), Slots),
    write('Free slots: '), write(Slots), nl.

query_teacher_availability :-
    write('Enter teacher name: '), read(Teacher),
    write('Enter subject: '), read(Subject),
    findall(S, available_teacher(Teacher, Subject, S), Slots),
    write('Available slots: '), write(Slots), nl.

query_room_capacity :-
    write('Enter room: '), read(Room),
    room(Room, Capacity),
    write('Capacity: '), write(Capacity), nl.

query_class_info :-
    write('Enter class name: '), read(Class),
    scheduled(Class, Subj, Teacher, Room, Slot),
    write('Class '), write(Class), write(' for '), write(Subj),
    write(' is scheduled with '), write(Teacher),
    write(' in room '), write(Room),
    write(' during '), write(Slot), nl.

% Traceable Reasoning
explain_schedule(Class) :-
    scheduled(Class, Subj, T, Room, Slot),
    write('Class '), write(Class), write(' for '), write(Subj),
    write(' is scheduled with '), write(T),
    write(' in room '), write(Room),
    write(' during '), write(Slot), nl.

% Additional Rules: Find overlapping schedules
overlap(Class1, Class2) :-
    scheduled(Class1, _, T1, R1, Slot),
    scheduled(Class2, _, T2, R2, Slot),
    (T1 == T2; R1 == R2),
    Class1 \= Class2,
    write('Conflict between '), write(Class1), write(' and '), write(Class2), nl.

query_overlaps :-
    findall([C1, C2], overlap(C1, C2), Conflicts),
    write('Conflicts: '), write(Conflicts), nl.
