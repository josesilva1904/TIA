:- consult('baseconhecimento.pl').
:- dynamic fact/1.

diagnostico :-
    retractall(fact(_)), 
    write('--- Sistema de Diagnostico Especialista ---'), nl,
    write('Introduza os sintomas (ex: febre. ). Escreva "fim." para terminar.'), nl,
    ler_sintomas,
    nl, write('A processar diagnostico...'), nl,
    result,
    write('Analise concluida.'), nl.

ler_sintomas :-
    write('> '), read(Sintoma),
    (Sintoma == fim -> 
        true 
    ; 
        (atom(Sintoma) -> assert(fact(Sintoma)) ; write('Erro: Use letras minusculas e ponto .')),
        ler_sintomas
    ).

result :-
    new_derived_fact(P), 
    !, 
    assert(fact(P)),
    format('*** Diagnostico Detetado: ~w ***~n', [P]),
    result.
result :- true.

new_derived_fact(Concl) :-
    if Cond then Concl,
    \+ fact(Concl),
    composed_fact(Cond).

% Avaliação de Condições com Cuts (!) para evitar loops
composed_fact((Cond)) :- !, composed_fact(Cond).
composed_fact(A and B) :- !, composed_fact(A), composed_fact(B).
composed_fact(A or B) :- (composed_fact(A) ; composed_fact(B)), !.
composed_fact(Sintoma) :- fact(Sintoma).