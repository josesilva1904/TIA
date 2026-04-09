doencas([covid19,gastroenterite,infecao_urinaria,enxaqueca,gripe_a,tuberculose,hipertensao,diabetes,ataque_cardiaco,pneumonia,rinite,lombalgia,sinusite,hepatite,malaria,laringite,otite,conjuntivite,varicela,amigdalite]).

% Tratamentos baseados nas doenças listadas
tratamento(covid19, 'Repouse, hidrate-se e monitore a oxigenação. Use antitérmicos se necessário e isole-se.').
tratamento(gastroenterite, 'Foco total na reidratação (soro caseiro) e dieta leve (arroz, canja, banana).').
tratamento(infecao_urinaria, 'Consulte um médico para prescrição de antibióticos e aumente a ingestão de água.').
tratamento(enxaqueca, 'Repouse num local escuro e silencioso. Tome a medicação prescrita e evite gatilhos.').
tratamento(gripe_a, 'Repouse, hidrate-se e use antivirais se receitados pelo médico nas primeiras 48h.').
tratamento(tuberculose, 'Tratamento rigoroso com antibióticos por longo período e acompanhamento médico constante.').
tratamento(hipertensao, 'Reduza o sal, pratique exercício e tome a medicação diária conforme orientação médica.').
tratamento(diabetes, 'Controlo da glicémia, dieta equilibrada com pouco açúcar e uso de insulina ou hipoglicemiantes.').
tratamento(ataque_cardiaco, 'EMERGÊNCIA: Ligue imediatamente para o 112 ou dirija-se ao hospital mais próximo.').
tratamento(pneumonia, 'Uso de antibióticos ou antivirais conforme o tipo, repouso e fisioterapia respiratória se necessário.').
tratamento(rinite, 'Evite contacto com alergénios (pó, pólen), use anti-histamínicos ou sprays nasais.').
tratamento(lombalgia, 'Repouse em posição confortável, use compressas quentes e considere fisioterapia ou analgésicos.').
tratamento(sinusite, 'Lavagem nasal com soro fisiológico, hidratação e, se bacteriana, uso de antibióticos.').
tratamento(hepatite, 'Repouse, dieta pobre em gorduras, evite álcool e tenha acompanhamento médico para monitorizar o fígado.').
tratamento(malaria, 'Tratamento hospitalar com medicamentos antimaláricos específicos.').
tratamento(laringite, 'Poupe a voz, hidrate-se com líquidos mornos e evite ambientes com fumo ou ar seco.').
tratamento(otite, 'Uso de gotas otológicas ou antibióticos sob prescrição e manter o ouvido seco.').
tratamento(conjuntivite, 'Lave os olhos com soro, use colírios específicos e evite partilhar toalhas ou tocar nos olhos.').
tratamento(varicela, 'Cuidado com a higiene das borbulhas, use loções para a comichão e evite o contacto com grávidas.').
tratamento(amigdalite, 'Gargarejos com água salgada, hidratação e antibióticos se a origem for bacteriana.').


% Processamento de Tratamentos

% se nao houver sintomas, nao ha tratamentos
get_tratamentos([], []).

% Processa o primeiro diagnóstico e continua para o resto da lista.
get_tratamentos([(D, P, E)|R], L) :- 
    get_tratamentos(R, R2), % processar o resto da lista primeiro
    (
        (tratamento(D, T) -> 
            % se encontrar o tratamento, adicionar ao tuplo (D, P, E, T)
            L = [(D, P, E, T)|R2]
        ; 
            % se não encontrar tratamento, mantém apenas os dados originais ou marca como 'Consulte um médico'
            L = [(D, P, E, 'Tratamento não especificado. Consulte um especialista.')|R2]
        )
    ).

% Apresentação de Resultados

% nao imprime nada
apresentar_resultados([]).

% mostra os detalhes de cada doença encontrada
apresentar_resultados([(D, P, E, T)|R]) :-
    format('~n--- DIAGNÓSTICO: ~w ---~n', [D]),
    format('Certeza: ~w%~n', [P]),
    format('Explicação: ~w~n', [E]),
    format('Recomendação/Tratamento: ~w~n', [T]),
    nl,
    apresentar_resultados(R).