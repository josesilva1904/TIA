:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(500, xfy, and).
:- op(800, xfx, <=).
:- dynamic(fact/1).
:- [basedados, forwardchain, baseconhecimento].

menu :-
    retractall(fact(_)), nl,
    write('Bem Vindo ao programa de ajuda médico!'), nl,
    write('Iremos colocar-lhe algumas questões relativas aos seus sintomas.'), nl, 
    write('Menu:'), nl,
    write('** 1- Iniciar'), nl,
    write('** 2- Sair'), nl,
    read(B),
    escolha(B).

escolha(1) :- perguntas, resultado.
escolha(2) :- write('Até à próxima!'), halt.
escolha(_) :- write('Introduza uma opcao valida!'), nl, menu.

% --- Bloco de Perguntas Atualizado ---

perguntas :-
    % Sintomas Respiratórios e Gerais
    ask(tosse, 'Tem tosse?', 0.9),
    ask(febre, 'Tem febre?', 0.7),
    ask(dificuldade_respirar, 'Sente dificuldade em respirar?', 1),
    ask(fadiga, 'Sente fadiga ou cansaço?', 0.7),
    ask(dores_musculares, 'Sente dores musculares?', 0.5),
    ask(dor_cabeca, 'Dói-lhe a cabeça?', 0.9),
    ask(dor_garganta, 'Dói-lhe a garganta?', 0.8),
    ask(congestao_nasal, 'Tem o nariz entupido ou congestão?', 0.9),
    ask(calafrios, 'Tem calafrios?', 0.6),
    
    % Sintomas Digestivos
    ask(nauseas, 'Sente náuseas?', 0.8),
    ask(vomitos, 'Tem tido vómitos?', 0.9),
    ask(diarreia, 'Tem diarreia?', 0.9),
    ask(perda_apetite, 'Perdeu o apetite?', 0.9),
    ask(colicas, 'Sente cólicas abdominais?', 0.7),
    
    % Sintomas Específicos (Diana e Zé)
    ask(dor_peito, 'Sente dor no peito?', 1),
    ask(sangue_tossir, 'Tosse com sangue?', 1),
    ask(perda_peso, 'Teve perda de peso recente?', 0.8),
    ask(suar_excessivamente, 'Tem suores excessivos?', 0.7),
    ask(visao_turva, 'Tem a visão turva ou baça?', 0.8),
    ask(zumbido_ouvido, 'Sente zumbidos nos ouvidos?', 0.6),
    ask(sede_excessiva, 'Sente sede excessiva?', 0.8),
    ask(vontade_urinar, 'Sente vontade frequente de urinar?', 0.8),
    ask(fome_excessiva, 'Sente fome excessiva?', 0.7),
    ask(formigueiro, 'Sente formigueiro nos membros?', 0.6),
    ask(desmaio, 'Já sofreu algum desmaio?', 1),
    ask(confusao_mental, 'Sente confusão mental?', 0.9),
    ask(cianose, 'Nota lábios ou unhas azuladas (cianose)?', 1),
    
    % Sintomas Urinários e Sentidos (Vitória e outros)
    ask(dor_urinar, 'Sente dor ao urinar?', 1),
    ask(urina_turva, 'A urina parece turva?', 0.7),
    ask(sangue_urina, 'Notou sangue na urina?', 1),
    ask(perda_paladar, 'Perdeu o paladar?', 0.8),
    ask(perda_olfato, 'Perdeu o olfato?', 0.8),
    ask(sensibilidade_luz, 'Tem sensibilidade à luz?', 0.8),
    ask(sensibilidade_som, 'Tem sensibilidade ao som?', 0.7),
    ask(aura_visual, 'Vê manchas ou luzes antes da dor (aura)?', 0.8),
    ask(dor_ouvidos, 'Dói-lhe o ouvido?', 0.8),
    ask(secrecao_ouvido, 'Tem corrimento/secreção no ouvido?', 0.8),
    ask(diminuicao_audicao, 'Sente que ouve pior?', 0.8),
    ask(comichao_olhos, 'Tem comichão nos olhos?', 0.7),
    ask(comichao_pele, 'Tem comichão na pele?', 0.6),
    ask(amigdalas_inchadas, 'Tem as amígdalas inchadas?', 0.8),
    ask(mau_halito, 'Nota mau hálito?', 0.5),
    ask(rouquidao, 'Está rouco?', 0.7),
    ask(perda_voz, 'Perdeu a voz?', 0.8),
    ask(irritacao_garganta, 'Sente a garganta irritada?', 0.6).

% Predicado auxiliar para evitar repetição de código
ask(Sintoma, Texto, Confianca) :-
    nl, write(Texto), nl,
    write('1- Sim.'), nl,
    write('2- Não.'), nl,
    write('A sua opcao e: '), read(Op),
    (Op == 1 -> assert(fact(Sintoma:Confianca)) ; true).

% --- Resultado (Mantém a tua lógica original) ---
resultado :- 
    doencas(L1),
    get_certainties(L1, L2),
    get_proofs(L2, L3),
    result,
    get_tratamentos(L3, L4),
    (
        (L4 = [], write('Não foi possível identificar a doença com certeza. Consulte um médico.'));
        (apresentar_resultados(L4))
    ),
    retractall(fact(_)).