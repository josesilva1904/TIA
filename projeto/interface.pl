:- set_prolog_flag(encoding, utf8).

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).
:- dynamic(fact/1).

% Só precisamos de carregar 3 ficheiros agora!
:- [basedados, baseconhecimento, forwardchain].

% --- Menu Principal ---
menu :-
    retractall(fact(_)), 
    retractall(diagnostico(_,_,_)), % Limpa os diagnosticos antigos
    nl, write('Bem Vindo ao programa de ajuda medico!'), nl,
    write('Iremos colocar-lhe algumas questoes relativas aos seus sintomas.'), nl, 
    write('Menu:'), nl,
    write('** 1- Iniciar Diagnostico (Motor Forward Chaining)'), nl,
    write('** 2- Sair'), nl,
    write('> '), read(B),
    escolha(B).

escolha(1) :- 
    perguntas, 
    nl, write('--- A PROCESSAR DIAGNOSTICO ---'), nl,
    result, % Chama o Forward Chaining
    apresentar_resultados,
    nova_avaliacao.

escolha(2) :- nl, write('Ate a proxima! As melhoras.'), nl, halt.
escolha(_) :- nl, write('Erro: Introduza 1 ou 2.'), nl, menu.

% --- Bloco de Perguntas (Com Intensidade) ---
perguntas :-
    mostrar_menu_sintomas,
    ler_opcoes_sintomas.

mostrar_menu_sintomas :-
    nl, write('================ LISTA DE SINTOMAS ================'), nl,
    write(' 1. Tosse                  12. Dor ao urinar'), nl,
    write(' 2. Febre                  13. Urina turva / Sangue'), nl,
    write(' 3. Dificuldade Respirar   14. Sensibilidade Luz/Som'), nl,
    write(' 4. Fadiga / Cansaco       15. Zumbido / Dor Ouvidos'), nl,
    write(' 5. Dores musculares       16. Comichao nos olhos/pele'), nl,
    write(' 6. Dor de cabeca          17. Dor no peito'), nl,
    write(' 7. Dor de garganta        18. Suar excessivamente'), nl,
    write(' 8. Congestao nasal        19. Sede / Fome excessiva'), nl,
    write(' 9. Nauseas / Vomitos      20. Confusao mental / Desmaio'), nl,
    write('10. Diarreia               21. Perda de paladar / olfato'), nl,
    write('11. Colicas abdominais     22. Calafrios'), nl,
    write('==================================================='), nl.

ler_opcoes_sintomas :-
    nl, write('Sintomas (Ex: [1, 6]. Nao esquecer o ponto final!): '), nl,
    write('> '), read(ListaOpcoes),
    ( is_list(ListaOpcoes) -> processar_opcoes(ListaOpcoes)
    ; nl, write('Erro: Formato invalido. Use [ ] e termine com .'), nl, ler_opcoes_sintomas ).

% --- Dicionario de Sintomas e Intensidades ---
sintoma_map(1, tosse, 0.9).             sintoma_map(12, dor_urinar, 1.0).
sintoma_map(2, febre, 0.7).             sintoma_map(13, urina_turva, 0.7).
sintoma_map(3, dificuldade_respirar, 1.0). sintoma_map(14, sensibilidade_luz, 0.8).
sintoma_map(4, fadiga, 0.7).            sintoma_map(15, zumbido_ouvido, 0.6).
sintoma_map(5, dores_musculares, 0.5).  sintoma_map(15, dor_ouvidos, 0.8).
sintoma_map(6, dor_cabeca, 0.9).        sintoma_map(16, comichao_olhos, 0.7).
sintoma_map(7, dor_garganta, 0.8).      sintoma_map(17, dor_peito, 1.0).
sintoma_map(8, congestao_nasal, 0.9).   sintoma_map(18, suar_excessivamente, 0.7).
sintoma_map(9, nauseas, 0.8).           sintoma_map(19, sede_excessiva, 0.8).
sintoma_map(9, vomitos, 0.9).           sintoma_map(20, confusao_mental, 0.9).
sintoma_map(10, diarreia, 0.9).         sintoma_map(21, perda_paladar, 0.8).
sintoma_map(11, colicas, 0.7).          sintoma_map(22, calafrios, 0.6).

pede_intensidade(dor_cabeca, 'Nivel da dor de cabeca?').
pede_intensidade(dor_garganta, 'Intensidade da dor de garganta?').
pede_intensidade(dores_musculares, 'Intensidade das dores musculares?').
pede_intensidade(dor_peito, 'Intensidade da dor no peito?').
pede_intensidade(dor_urinar, 'Intensidade da dor ao urinar?').
pede_intensidade(dor_ouvidos, 'Nivel da dor de ouvidos?').
pede_intensidade(colicas, 'Intensidade das colicas abdominais?').

processar_opcoes([]).
processar_opcoes([Id|Resto]) :-
    findall((Sintoma, Conf), sintoma_map(Id, Sintoma, Conf), Lista),
    (Lista \= [] -> registar_sintomas(Lista) ; format('Aviso: Opcao ~w ignorada.', [Id])),
    processar_opcoes(Resto).

registar_sintomas([]).
registar_sintomas([(Sintoma, DefConf)|Resto]) :-
    ( pede_intensidade(Sintoma, PTexto) ->
        nl, format('~w (1 a 10): ', [PTexto]), ler_intensidade(Valor),
        ConfCalc is Valor / 10.0, assert(fact(Sintoma:ConfCalc))
    ; assert(fact(Sintoma:DefConf)) ),
    registar_sintomas(Resto).

ler_intensidade(Valor) :-
    read(Entrada),
    ( number(Entrada), Entrada >= 1, Entrada =< 10 -> Valor = Entrada
    ; write('Erro: Introduza um numero entre 1 e 10. '), ler_intensidade(Valor) ).

% --- Apresentador de Resultados ---
apresentar_resultados :-
    % Agora vai buscar os diagnosticos com a regra exata que foi guardada
    findall((D, P, Cond), diagnostico(D, P, Cond), DoencasEncontradas),
    ( DoencasEncontradas == [] ->
        nl, write('Nao foi possivel identificar a doenca. Consulte um medico.'), nl
    ;
        mostrar_lista(DoencasEncontradas)
    ).

mostrar_lista([]).
mostrar_lista([(Doenca, Prob, Cond)|Resto]) :-
    Percentagem is round(Prob * 100),
    nl, write('================== DIAGNOSTICO =================='), nl,
    format('Doenca: ~w (Certeza: ~w%)~n', [Doenca, Percentagem]),
    
    % Imprime os Criterios exatos que dispararam a doenca
    write('Criterios da Doenca -> '), traduzir_cond(Cond), nl,
    
    write('Sintomas do paciente -> '), imprimir_sintomas_paciente, nl,
    
    % Imprime os Tratamentos
    ( tratamento(Doenca, Tratamento) ->
        format('Tratamento: ~w~n', [Tratamento])
    ; write('Tratamento: Repouso e consultar um medico.') ),
    write('================================================='), nl,
    mostrar_lista(Resto).

% Tradutor visual de AND e OR para linguagem humana
traduzir_cond(A and B) :- traduzir_cond(A), write(' e '), traduzir_cond(B).
traduzir_cond(A or B) :- traduzir_cond(A), write(' ou '), traduzir_cond(B).
traduzir_cond(Sintoma) :- atom(Sintoma), write(Sintoma).

% Formatador da lista de sintomas do paciente
imprimir_sintomas_paciente :-
    findall(S, fact(S:_), Sintomas),
    imprimir_lista_s(Sintomas).

imprimir_lista_s([]).
imprimir_lista_s([H]) :- write(H).
imprimir_lista_s([H|T]) :- T \= [], write(H), write(', '), imprimir_lista_s(T).

nova_avaliacao :-
    nl, write('--- Deseja fazer nova avaliacao? ---'), nl,
    write('1- Sim | 2- Nao'), nl, write('> '), read(Opcao),
    ( Opcao == 1 -> menu ; halt ).