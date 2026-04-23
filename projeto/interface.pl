:- set_prolog_flag(encoding, utf8). % Garante que os acentos funcionam bem no terminal

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).
:- op(800, xfx, <=).
:- dynamic(fact/1).

% Carrega todos os modulos na ordem correta
:- [basedados, forwardchain, baseconhecimento, proof, certainty].

menu :-
    retractall(fact(_)), nl,
    write('Bem Vindo ao programa de ajuda medico!'), nl,
    write('Iremos colocar-lhe algumas questoes relativas aos seus sintomas.'), nl, 
    write('Menu:'), nl,
    write('** 1- Iniciar Diagnostico'), nl,
    write('** 2- Sair'), nl,
    read(B),
    escolha(B).

escolha(1) :- perguntas, resultado.
escolha(2) :- write('Ate a proxima!'), halt.
escolha(_) :- write('Introduza uma opcao valida!'), nl, menu.

% --- Bloco de Perguntas (Seleção Múltipla) ---
perguntas :-
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
    write('==================================================='), nl,
    nl,
    write('Introduza os numeros dos sintomas que sente, separados por virgula e dentro de parentesis retos.'), nl,
    write('Exemplo: [1, 2, 6]. (Nao esquecer o ponto final no fim!)'), nl,
    write('> '),
    read(ListaOpcoes),
    (is_list(ListaOpcoes) ->
        processar_opcoes(ListaOpcoes)
    ;
        nl, write('Erro: Formato invalido. Certifique-se que usa [ ] e termina com ponto.'), nl,
        perguntas % Volta a pedir se o utilizador se enganar na escrita
    ).

% --- Dicionario de Mapeamento (ID -> Sintoma : Confianca) ---
sintoma_map(1, tosse, 0.9).
sintoma_map(2, febre, 0.7).
sintoma_map(3, dificuldade_respirar, 1.0).
sintoma_map(4, fadiga, 0.7).
sintoma_map(5, dores_musculares, 0.5).
sintoma_map(6, dor_cabeca, 0.9).
sintoma_map(7, dor_garganta, 0.8).
sintoma_map(8, congestao_nasal, 0.9).

sintoma_map(9, nauseas, 0.8).
sintoma_map(9, vomitos, 0.9).
sintoma_map(10, diarreia, 0.9).
sintoma_map(11, colicas, 0.7).

sintoma_map(12, dor_urinar, 1.0).
sintoma_map(12, vontade_urinar, 0.8).
sintoma_map(13, urina_turva, 0.7).
sintoma_map(13, sangue_urina, 1.0).

sintoma_map(14, sensibilidade_luz, 0.8).
sintoma_map(14, sensibilidade_som, 0.7).
sintoma_map(15, zumbido_ouvido, 0.6).
sintoma_map(15, dor_ouvidos, 0.8).

sintoma_map(16, comichao_olhos, 0.7).
sintoma_map(16, comichao_pele, 0.6).

sintoma_map(17, dor_peito, 1.0).
sintoma_map(18, suar_excessivamente, 0.7).
sintoma_map(19, sede_excessiva, 0.8).
sintoma_map(19, fome_excessiva, 0.7).

sintoma_map(20, confusao_mental, 0.9).
sintoma_map(20, desmaio, 1.0).
sintoma_map(21, perda_paladar, 0.8).
sintoma_map(21, perda_olfato, 0.8).
sintoma_map(22, calafrios, 0.6).

% --- Processador da Lista ---
processar_opcoes([]).
processar_opcoes([Id|Resto]) :-
    findall((Sintoma, Conf), sintoma_map(Id, Sintoma, Conf), SintomasEncontrados),
    (SintomasEncontrados \= [] ->
        registar_sintomas(SintomasEncontrados)
    ;
        format('~nAviso: A opcao ~w nao existe e foi ignorada.', [Id])
    ),
    processar_opcoes(Resto).

registar_sintomas([]).
registar_sintomas([(Sintoma, Conf)|Resto]) :-
    assert(fact(Sintoma:Conf)),
    registar_sintomas(Resto).

% --- Resultado ---
resultado :- 
    doencas(L1),
    get_certainties(L1, L2),
    get_proofs(L2, L3),
    get_tratamentos(L3, L4),
    (
        (L4 = [] -> 
            nl, write('Nao foi possivel identificar a doenca com base nos sintomas indicados. Consulte um medico.'), nl
        ) ; (
            apresentar_resultados(L4)
        )
    ),
    retractall(fact(_)).