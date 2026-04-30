% ==========================================
% FICHEIRO: forwardchain.pl
% ==========================================

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).

:- dynamic(fact/1).
:- dynamic(diagnostico/3). % NOVO: Guarda Doenca, Certeza e Condicao exata!

% Motor Forward Chaining (Loop Principal)
result :-
    new_derived_fact(_), 
    !, 
    result.
result :- true.

% A evolução do código do professor
new_derived_fact(Concl) :-
    if Cond then Concl:ProbRegra,
    \+ diagnostico(Concl, _, _),           % Garante que nao repete a doenca
    avaliar_certeza(Cond, ProbSintomas),
    ProbSintomas > 0.0,
    CertezaFinal is ProbRegra * ProbSintomas,
    assert(diagnostico(Concl, CertezaFinal, Cond)). % Guarda a regra EXATA que disparou

% --- MOTOR MATEMÁTICO ---
avaliar_certeza(A and B, P) :- 
    !, avaliar_certeza(A, PA), avaliar_certeza(B, PB), P is min(PA, PB).
avaliar_certeza(A or B, P) :- 
    !, avaliar_certeza(A, PA), avaliar_certeza(B, PB), P is max(PA, PB).
avaliar_certeza(Sintoma, P) :- 
    atom(Sintoma), ( fact(Sintoma:P) -> true ; P = 0.0 ).