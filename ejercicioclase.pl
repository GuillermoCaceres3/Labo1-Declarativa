list_length([],0).

list_length([_|Tail],N) :-
    list_length(Tail,TailLength),
    N is TailLength + 1.

list_concat([],L,L).

list_concat([X1|L1],L2,[X1|L3]) :-
    list_concat(L1,L2,L3).

list_delete(X,[X],[]).

list_delete(X,[X|L1],L1).

list_delete(X,[Y|L2],[Y|L1]) :-
    list_delete(X,L2,L1).

insert_head(X,L,[X|L]).

insert_tail(X,L,R) :-
    append(L,[X],R).


list_insert(X,L,R) :-
    list_delete(X,R,L).


combination(0,_,[]).

combination(K,[X|Xs],[X|Ys]) :-
    K > 0,
    K1 is K - 1,
    combination(K1,Xs,Ys).

combination(K,[_|Xs],Ys) :-
    K > 0,
    combination(K,Xs,Ys).

list_order_asc([X,Y|Tail]) :-
    X =< Y,
    list_order_asc([Y|Tail]).

list_order_asc([_]).


list_order_desc([X,Y|Tail]) :-
    X >= Y,
    list_order_desc([Y|Tail]).

list_order_desc([_]).


mergesort([],[]).

mergesort([A],[A]).

mergesort([A,B|R],S) :-
    split([A,B|R],L1,L2),
    mergesort(L1,S1),
    mergesort(L2,S2),
    merge(S1,S2,S).


split([],[],[]).

split([A],[A],[]).

split([A,B|R],[A|Ra],[B|Rb]) :-
    split(R,Ra,Rb).


merge(A,[],A).

merge([],B,B).

merge([A|Ra],[B|Rb],[A|M]) :-
    A =< B,
    merge(Ra,[B|Rb],M).

merge([A|Ra],[B|Rb],[B|M]) :-
    A > B,
    merge([A|Ra],Rb,M).