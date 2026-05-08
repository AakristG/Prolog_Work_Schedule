plan(plan(Morning, Evening, Night)) :-
    findall(E, employee(E), Employees),
    findall(ws(W,Min,Max), workstation(W,Min,Max), AllWorkSchedules),

    % Split employees across the three shifts (constraint 6).
    assign_shifts(Employees, MorningEmployees, EveningEmployees, NightEmployees),

    build_shift(morning, MorningEmployees, AllWorkSchedules, Morning),
    build_shift(evening, EveningEmployees, AllWorkSchedules, Evening),
    build_shift(night, NightEmployees, AllWorkSchedules, Night).

assign_shifts([], [], [], []).

assign_shifts([E|Rest], [E|Morning], Evening, Night) :-
    \+ avoid_shift(E, morning),
    assign_shifts(Rest, Morning, Evening, Night).

assign_shifts([E|Rest], Morning, [E|Evening], Night) :-
    \+ avoid_shift(E, evening),
    assign_shifts(Rest, Morning, Evening, Night).

assign_shifts([E|Rest], Morning, Evening, [E|Night]) :-
    \+ avoid_shift(E, night),
    assign_shifts(Rest, Morning, Evening, Night).


build_shift(Shift, Employees, AllWorkSchedules, Schedule) :-
    % keep only non-idle workstations.
    include(ws_active(Shift), AllWorkSchedules, ActiveWorkSchedules),

    % empty assignment map
    maplist(ws_to_pair, ActiveWorkSchedules, EmptyAssign),

    % assign all employees
    fill_assignment(Employees, ActiveWorkSchedules, EmptyAssign, FullAssign),

    % verify headcounts.
    check_counts(FullAssign, ActiveWorkSchedules),

    % build the schedule term.
    pairs_to_schedule(FullAssign, Schedule).

ws_active(Shift, ws(W,_,_)) :-
    \+ workstation_idle(W, Shift).

ws_to_pair(ws(W,_,_), W-[]).


fill_assignment([], _ActiveWorkSchedules, Assign, Assign).

fill_assignment([E|Rest], ActiveWorkSchedules, Assign0, Assign) :-

    % Pick a workstation for this employee
    member(ws(W,_,_), ActiveWorkSchedules),

    % Constraint 5: skip workstations the employee must avoid.
    \+ avoid_workstation(E, W),

    % Record the choice.
    add_to_bucket(W, E, Assign0, Assign1),

    % Continue with the remaining employees.
    fill_assignment(Rest, ActiveWorkSchedules, Assign1, Assign).

add_to_bucket(W, E, [W-Es | T], [W-[E|Es] | T]) :- !.
add_to_bucket(W, E, [H     | T], [H        | T1]) :-
    add_to_bucket(W, E, T, T1).

check_counts([], _).
check_counts([W-Es | RestA], ActiveWorkSchedules) :-
    member(ws(W, Min, Max), ActiveWorkSchedules),
    length(Es, Count),
    Count >= Min,
    Count =< Max,
    check_counts(RestA, ActiveWorkSchedules).

pairs_to_schedule([], []).
pairs_to_schedule([_-[] | Rest], Schedules) :-
    !,
    pairs_to_schedule(Rest, Schedules).
pairs_to_schedule([W-Es | Rest], [workstation(W, Es) | Schedules]) :-
    pairs_to_schedule(Rest, Schedules).