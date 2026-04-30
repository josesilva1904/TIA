:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).

:- consult('baseconhecimento.pl').
:- dynamic fact/1.

diagnostico :-
    retractall(fact(_)), 
    write('--- Sistema de Diagnostico Especialista ---'), nl,
    write('Introduza os sintomas (ex: febre:1.0 . ). Escreva "fim." para terminar.'), nl,
    ler_sintomas,
    nl, write('A processar diagnostico...'), nl,
    result,
    write('Analise concluida.'), nl.

ler_sintomas :-
    write('> '), read(Sintoma),
    (Sintoma == fim -> 
        true 
    ; 
        (Sintoma = S:C -> assert(fact(S:C)) ; (atom(Sintoma) -> assert(fact(Sintoma:1.0)) ; write('Erro de formato.'))),
        ler_sintomas
    ).

result :-
    new_derived_fact(P), 
    !, 
    format('*** Diagnostico Derivado (Forward Chaining): ~w ***~n', [P]),
    result.
result :- true.

new_derived_fact(Concl) :-
    if Cond then Concl:_,
    \+ fact(Concl:_),
    composed_fact(Cond),
    assert(fact(Concl:1.0)).

composed_fact(Sintoma) :- fact(Sintoma:_).
composed_fact(A and B) :- !, composed_fact(A), composed_fact(B).
composed_fact(A or B) :- (composed_fact(A) ; composed_fact(B)), !.