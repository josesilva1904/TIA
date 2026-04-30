:- set_prolog_flag(encoding, utf8). % Garante que os acentos funcionam bem no terminal

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).
:- dynamic(fact/1).

% Carrega APENAS os ficheiros necessários para o Forward Chaining!
% (podes manter os ficheiros certainty.pl e proof.pl na pasta, mas o programa já não olha para eles)
:- [basedados, forwardchain, baseconhecimento].

% --- Menu Principal ---
menu :-
    retractall(fact(_)), nl,
    write('Bem Vindo ao programa de ajuda medico!'), nl,
    write('Iremos colocar-lhe algumas questoes relativas aos seus sintomas.'), nl, 
    write('Menu:'), nl,
    write('** 1- Iniciar Diagnostico (Motor: Forward Chaining)'), nl,
    write('** 2- Sair'), nl,
    write('> '), read(B),
    escolha(B).

escolha(1) :- 
    perguntas, 
    nl, write('--- A PROCESSAR DIAGNOSTICO (FORWARD CHAINING) ---'), nl,
    result, % Chama diretamente o loop de inferência do ficheiro forwardchain.pl
    verificar_se_encontrou_algo,
    nova_avaliacao.

escolha(2) :- 
    nl, write('Ate a proxima! As melhoras.'), nl, halt.

escolha(_) :- 
    nl, write('Erro: Introduza uma opcao valida (1 ou 2)! Nao se esqueca do ponto final.'), nl, 
    menu.

% --- Bloco de Perguntas ---
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
    nl, write('Introduza os numeros dos sintomas que sente, separados por virgula e dentro de parentesis retos.'), nl,
    write('Exemplo: [1, 6, 17]. (Nao esquecer o ponto final no fim!)'), nl,
    write('> '),
    read(ListaOpcoes),
    ( is_list(ListaOpcoes) ->
        processar_opcoes(ListaOpcoes)
    ;
        nl, write('>>> ERRO: Formato invalido! Tem de usar os parentesis retos [ ] e terminar com ponto. <<<'), nl,
        ler_opcoes_sintomas
    ).

% --- Dicionario de Mapeamento (Apenas os nomes dos sintomas) ---
sintoma_map(1, tosse).
sintoma_map(2, febre).
sintoma_map(3, dificuldade_respirar).
sintoma_map(4, fadiga).
sintoma_map(5, dores_musculares).
sintoma_map(6, dor_cabeca).
sintoma_map(7, dor_garganta).
sintoma_map(8, congestao_nasal).
sintoma_map(9, nauseas).
sintoma_map(9, vomitos).
sintoma_map(10, diarreia).
sintoma_map(11, colicas).
sintoma_map(12, dor_urinar).
sintoma_map(12, vontade_urinar).
sintoma_map(13, urina_turva).
sintoma_map(13, sangue_urina).
sintoma_map(14, sensibilidade_luz).
sintoma_map(14, sensibilidade_som).
sintoma_map(15, zumbido_ouvido).
sintoma_map(15, dor_ouvidos).
sintoma_map(16, comichao_olhos).
sintoma_map(16, comichao_pele).
sintoma_map(17, dor_peito).
sintoma_map(18, suar_excessivamente).
sintoma_map(19, sede_excessiva).
sintoma_map(19, fome_excessiva).
sintoma_map(20, confusao_mental).
sintoma_map(20, desmaio).
sintoma_map(21, perda_paladar).
sintoma_map(21, perda_olfato).
sintoma_map(22, calafrios).

% --- Processador da Lista ---
processar_opcoes([]).
processar_opcoes([Id|Resto]) :-
    findall(Sintoma, sintoma_map(Id, Sintoma), SintomasEncontrados),
    (SintomasEncontrados \= [] ->
        registar_sintomas(SintomasEncontrados)
    ;
        format('~nAviso: A opcao ~w nao existe e foi ignorada.', [Id])
    ),
    processar_opcoes(Resto).

% Regista os sintomas com o valor 1.0 (para ser compativel com o formato Concl:_)
registar_sintomas([]).
registar_sintomas([Sintoma|Resto]) :-
    assert(fact(Sintoma:1.0)),
    registar_sintomas(Resto).

% --- Verificador (Caso o Forward Chain não encontre nada) ---
verificar_se_encontrou_algo :-
    doencas(ListaDoencas),
    findall(D, (member(D, ListaDoencas), fact(D:_)), DoencasApanhadas),
    ( DoencasApanhadas == [] ->
        write('Nao foi possivel derivar um diagnostico conclusivo com as regras atuais.'), nl
    ;
        true % O predicado 'result' do teu forwardchain.pl já tratou de imprimir as doenças encontradas.
    ).

% --- Nova Avaliacao ---
nova_avaliacao :-
    nl, write('--- Deseja fazer uma nova avaliacao? ---'), nl,
    write('1- Sim'), nl,
    write('2- Nao'), nl,
    write('> '), read(Opcao),
    ( Opcao == 1 -> 
        menu 
    ; Opcao == 2 -> 
        nl, write('Obrigado por usar o sistema medico. As melhoras!'), nl, halt
    ; 
        write('Erro: Opcao invalida. Introduza 1 ou 2.'), nl, 
        nova_avaliacao
    ).