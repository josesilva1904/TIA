% api_agente.pl
:- set_prolog_flag(encoding, utf8).
:- consult('basedados.pl').
:- consult('baseconhecimento.pl').
:- consult('forwardchain.pl').

% Limpa o estado e inicia um novo diagnóstico
iniciar_diagnostico_api(ListaSintomas, Resultados) :-
    retractall(fact(_)),
    retractall(diagnostico(_,_,_)),
    registar_sintomas_api(ListaSintomas),
    (result ; true), % Executa o motor forward chaining
    findall(D-P-T, (diagnostico(D, P, _), tratamento(D, T)), Resultados).

% Assert de sintomas vindos do Python (assumimos confiança 1.0 para simplificar no agente)
registar_sintomas_api([]).
registar_sintomas_api([Sintoma|Resto]) :-
    assert(fact(Sintoma:1.0)),
    registar_sintomas_api(Resto).