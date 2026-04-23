% result_certainty( Proposicao, Certeza )
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, and).
:- op(300, xfy, or).

% Caso 1: O sintoma é um facto direto com uma certeza associada (facto inserido pelo utilizador)
result_certainty(P, Cert) :-
    fact(P:Cert).

% Caso 2: Conjunção (AND) - A certeza é o mínimo entre as duas condições
result_certainty(Cond1 and Cond2, Cert) :-
    result_certainty(Cond1, Cert1),
    result_certainty(Cond2, Cert2),
    Cert is min(Cert1, Cert2).

% Caso 3: Disjunção (OR) - A certeza é o máximo entre as duas condições
result_certainty(Cond1 or Cond2, Cert) :-
    result_certainty(Cond1, Cert1),
    result_certainty(Cond2, Cert2),
    Cert is max(Cert1, Cert2).

% Caso 4: Regra (IF-THEN) - A certeza da conclusão é (Certeza da Regra * Certeza da Condição)
result_certainty(P, Cert) :-
    if Cond then P:C1,
    result_certainty(Cond, C2),
    Cert is C1 * C2.

% get_certainties(ListaDoencas, ListaResultados)
% Transforma [d1, d2] em [(d1, p1), (d2, p2)]

get_certainties([], []).

get_certainties([D|R], L) :-
    get_certainties(R, R2),
    (
        % Encontra todas as certezas possíveis para D e escolhe a maior (max)
        % O uso do aggregate ou setof evita que o backtracking duplique diagnósticos
        findall(P, result_certainty(D, P), ListaCertezas),
        ListaCertezas \= [] ->
            max_list(ListaCertezas, MaxP),
            % Converter para percentagem (0-100)
            Percentagem is MaxP * 100,
            L = [(D, Percentagem)|R2]
        ;
            % Se não conseguir calcular certeza, ignora esta doença
            L = R2
    ).