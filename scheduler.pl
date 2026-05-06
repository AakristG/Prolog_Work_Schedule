plan(plan(Morning, Evening, Night)) :-
    findall(E,            employee(E),            Employees),
    findall(ws(W,Min,Max), workstation(W,Min,Max), AllWS),

    % Split employees across the three shifts (constraint 6).
    assign_shifts(Employees, MorningEmps, EveningEmps, NightEmps),

    build_shift(morning, MorningEmps, AllWS, Morning),
    build_shift(evening, EveningEmps, AllWS, Evening),
    build_shift(night,   NightEmps,   AllWS, Night).


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


build_shift(Shift, Employees, AllWS, Schedule) :-
    % keep only non-idle workstations.
    include(ws_active(Shift), AllWS, ActiveWS),

    % empty assignment map.
    maplist(ws_to_pair, ActiveWS, EmptyAssign),

    % assign all employees
    fill_assignment(Employees, ActiveWS, EmptyAssign, FullAssign),

    % verify headcounts.
    check_counts(FullAssign, ActiveWS),

    % build the schedule term.
    pairs_to_schedule(FullAssign, Schedule).

ws_active(Shift, ws(W,_,_)) :-
    \+ workstation_idle(W, Shift).

ws_to_pair(ws(W,_,_), W-[]).


fill_assignment([], _ActiveWS, Assign, Assign).

fill_assignment([E|Rest], ActiveWS, Assign0, Assign) :-

    % Pick a workstation for this employee
    member(ws(W,_,_), ActiveWS),

    % Constraint 5: skip workstations the employee must avoid.
    \+ avoid_workstation(E, W),

    % Record the choice.
    add_to_bucket(W, E, Assign0, Assign1),

    % Continue with the remaining employees.
    fill_assignment(Rest, ActiveWS, Assign1, Assign).

add_to_bucket(W, E, [W-Es | T], [W-[E|Es] | T]) :- !.
add_to_bucket(W, E, [H     | T], [H        | T1]) :-
    add_to_bucket(W, E, T, T1).

check_counts([], _).
check_counts([W-Es | RestA], ActiveWS) :-
    member(ws(W, Min, Max), ActiveWS),
    length(Es, Count),
    Count >= Min,
    Count =< Max,
    check_counts(RestA, ActiveWS).

pairs_to_schedule([], []).
pairs_to_schedule([_-[] | Rest], Sched) :-
    !,
    pairs_to_schedule(Rest, Sched).
pairs_to_schedule([W-Es | Rest], [workstation(W, Es) | Sched]) :-
    pairs_to_schedule(Rest, Sched).