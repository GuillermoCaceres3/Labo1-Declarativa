% Derivada de una constante
d(Var, Func, 0) :-
    atomic(Var), number(Func).

% Derivada de una variable con respecto a si misma
d(Var, Func, 1) :-
    Var == Func.

% Derivada de una variable por una constante
d(Var, N*Var, N) :-
    atomic(Var), number(N).

% Derivada de una variable elevada a la N
d(Var, Var^N, N*Var^Nm1) :-
    number(N), is(Nm1, N - 1).

% Derivada de una variable elevada a la N por una constante
d(Var, K*Var^N, C*Var^Nm1) :-
    atomic(Var), number(K), number(N), is(C, K*N), is(Nm1, N-1).

% Derivada de un logaritmo natural
d(Var, log(Var), 1/Var) :-
    atomic(Var).

% Integral de una constante
s(Var, K, K*Var) :-
    number(K), atomic(Var).

% Integral de una variable con respecto a si misma
s(Var, Var, 1/2*Var^2) :-
    atomic(Var).

%% Integral de una constante por una variable elevada a la N
s(Var, K*Var^N, K/M*Var^M) :-
    atomic(Var), number(K), number(N), is(M, N+1).


% =====================================================================
%  SUMA Y RESTA DE EXPRESIONES ALGEBRAICAS (términos semejantes)
%
%  Cada término se representa como m(Coef, Exp)  ->  Coef * Var^Exp
%     x^2    -> m(1, 2)        5*x^2 -> m(5, 2)
%     4*x    -> m(4, 1)        7     -> m(7, 0)
%
%  Pasos: 1) descomponer la expresión en una lista de términos
%         2) agrupar los términos semejantes (mismo exponente)
%         3) quitar los términos con coeficiente 0
%         4) ordenar por exponente (mayor a menor)
%         5) reconstruir la expresión simplificada
% =====================================================================

% Suma:  A + B   ej. sumar(x, x^2 + 5*x^2, R)  ->  R = 6*x^2
sumar(Var, A + B, R) :-
    atomic(Var),
    terminos(Var, A, TA),
    terminos(Var, B, TB),
    unir(TA, TB, T),
    simplificar(Var, T, R).

% Resta: A - B   ej. restar(x, 7*x^3 - 3*x^3, R)  ->  R = 4*x^3
restar(Var, A - B, R) :-
    atomic(Var),
    terminos(Var, A, TA),
    terminos(Var, B, TB),
    negar(TB, NB),
    unir(TA, NB, T),
    simplificar(Var, T, R).

simplificar(Var, Terminos, R) :-
    agrupar(Terminos, Agrupados),
    quitar_ceros(Agrupados, SinCeros),
    ordenar(SinCeros, Ordenados),
    construir(Var, Ordenados, R).

% ---------------------------------------------------------------------
%  1) Descomponer una expresión en lista de términos m(Coef, Exp)
%     (también acepta sumas/restas dentro de cada lado: x + 2*x + x^2)
% ---------------------------------------------------------------------
terminos(Var, A + B, T) :- !,
    terminos(Var, A, TA),
    terminos(Var, B, TB),
    unir(TA, TB, T).
terminos(Var, A - B, T) :- !,
    terminos(Var, A, TA),
    terminos(Var, B, TB),
    negar(TB, NB),
    unir(TA, NB, T).
terminos(Var, -A, T) :- !,
    terminos(Var, A, TA),
    negar(TA, T).
terminos(Var, E, [M]) :-
    monomio(Var, E, M).

% Un solo término (monomio)
monomio(_, K, m(K, 0)) :-                           % 7
    number(K), !.
monomio(Var, E, m(1, 1)) :-                         % x
    E == Var, !.
monomio(Var, Var^N, m(1, N)) :-                     % x^N
    number(N), !.
monomio(Var, K*Var, m(K, 1)) :-                     % K*x
    number(K), !.
monomio(Var, K*Var^N, m(K, N)) :-                   % K*x^N
    number(K), number(N), !.
monomio(Var, Var*K, m(K, 1)) :-                     % x*K
    number(K), !.
monomio(Var, Var^N*K, m(K, N)) :-                   % x^N*K
    number(K), number(N), !.

% ---------------------------------------------------------------------
%  Utilidades de listas
% ---------------------------------------------------------------------
unir([], L, L).
unir([X|Xs], L, [X|R]) :-
    unir(Xs, L, R).

negar([], []).
negar([m(C, E)|T], [m(NC, E)|R]) :-
    NC is -C,
    negar(T, R).

% ---------------------------------------------------------------------
%  2) Agrupar términos semejantes: suma los coeficientes de igual Exp
% ---------------------------------------------------------------------
agrupar([], []).
agrupar([m(C, E)|T], [m(S, E)|R]) :-
    acumular(E, T, C, S, Resto),
    agrupar(Resto, R).

% acumular(Exp, Lista, Acum, Suma, Resto)
acumular(_, [], S, S, []).
acumular(E, [m(C, E2)|T], Acc, S, Resto) :-
    E =:= E2, !,
    Acc1 is Acc + C,
    acumular(E, T, Acc1, S, Resto).
acumular(E, [M|T], Acc, S, [M|Resto]) :-
    acumular(E, T, Acc, S, Resto).

% ---------------------------------------------------------------------
%  3) Quitar términos con coeficiente cero (x - x = 0)
% ---------------------------------------------------------------------
quitar_ceros([], []).
quitar_ceros([m(C, _)|T], R) :-
    C =:= 0, !,
    quitar_ceros(T, R).
quitar_ceros([M|T], [M|R]) :-
    quitar_ceros(T, R).

% ---------------------------------------------------------------------
%  4) Ordenar por exponente de mayor a menor (inserción)
% ---------------------------------------------------------------------
ordenar([], []).
ordenar([M|T], R) :-
    ordenar(T, RT),
    insertar(M, RT, R).

insertar(M, [], [M]).
insertar(m(C, E), [m(C2, E2)|T], [m(C, E), m(C2, E2)|T]) :-
    E >= E2, !.
insertar(M, [X|T], [X|R]) :-
    insertar(M, T, R).

% ---------------------------------------------------------------------
%  5) Reconstruir la expresión:  [m(6,2)] -> 6*x^2
% ---------------------------------------------------------------------
construir(_, [], 0).
construir(Var, [m(C, E)|T], R) :-
    primer_termino(Var, C, E, Inicial),
    encadenar(Var, T, Inicial, R).

% El primer término conserva su signo
primer_termino(Var, C, E, -X) :-
    C < 0, !,
    AC is -C,
    termino(Var, AC, E, X).
primer_termino(Var, C, E, X) :-
    termino(Var, C, E, X).

% Los demás se agregan con + o - según el signo del coeficiente
encadenar(_, [], Acc, Acc).
encadenar(Var, [m(C, E)|T], Acc, R) :-
    C < 0, !,
    AC is -C,
    termino(Var, AC, E, X),
    encadenar(Var, T, Acc - X, R).
encadenar(Var, [m(C, E)|T], Acc, R) :-
    termino(Var, C, E, X),
    encadenar(Var, T, Acc + X, R).

% termino(Var, Coef, Exp, Expresion) con Coef positivo
termino(_, C, E, C) :-          E =:= 0, !.     % 7
termino(Var, C, E, Var) :-      C =:= 1, E =:= 1, !.   % x
termino(Var, C, E, C*Var) :-    E =:= 1, !.     % 4*x
termino(Var, C, E, Var^E) :-    C =:= 1, !.     % x^2
termino(Var, C, E, C*Var^E).                    % 6*x^2
