:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).

% Caso 1: O sintoma é um facto direto com uma certeza associada
result_certainty(P, Cert) :-
    fact(P:Cert).

% Caso 2: Conjunção (AND) - Ambas as partes têm de existir
result_certainty(Cond1 and Cond2, Cert) :-
    result_certainty(Cond1, Cert1),
    result_certainty(Cond2, Cert2),
    Cert is min(Cert1, Cert2).

% Caso 3: Disjunção (OR) - Tenta procurar Cond1 e Cond2 de forma independente
result_certainty(Cond1 or Cond2, Cert) :-
    (result_certainty(Cond1, C1) -> true ; C1 = 0),
    (result_certainty(Cond2, C2) -> true ; C2 = 0),
    Cert is max(C1, C2),
    Cert > 0. % Só avança se pelo menos um sintoma tiver certeza maior que 0

% Caso 4: Regra (IF-THEN)
result_certainty(P, Cert) :-
    if Cond then P:C1,
    result_certainty(Cond, C2),
    Cert is C1 * C2.

% Transforma [d1, d2] em [(d1, p1), (d2, p2)]
get_certainties([], []).

get_certainties([D|R], L) :-
    get_certainties(R, R2),
    (
        findall(P, result_certainty(D, P), ListaCertezas),
        ListaCertezas \= [] ->
            max_list(ListaCertezas, MaxP),
            Percentagem is MaxP * 100,
            L = [(D, Percentagem)|R2]
        ;
            L = R2
    ).