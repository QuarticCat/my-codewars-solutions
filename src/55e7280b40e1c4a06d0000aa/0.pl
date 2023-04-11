subsequence([], _).
subsequence([X|T1], [X|T2]) :- subsequence(T1, T2).
subsequence([X|T1], [_|T2]) :- subsequence([X|T1], T2).

possible_sum(T, K, Ls, Res) :-
    length(ResList, K),
    subsequence(ResList, Ls),
    sum_list(ResList, Res),
    Res =< T.
possible_sum(_, _, _, Res) :-
    Res is -1.

best_sum(T, K, Ls, Res) :-
    aggregate(max(R), possible_sum(T, K, Ls, R), Res).
