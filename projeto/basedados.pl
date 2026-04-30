:- set_prolog_flag(encoding, utf8).
doencas([gastroenterite,infecao_urinaria,enxaqueca,gripe_a,tuberculose,hipertensao,diabetes,ataque_cardiaco,pneumonia,rinite,lombalgia,sinusite,hepatite,malaria,laringite,otite,conjuntivite,varicela,amigdalite]).

% Tratamentos baseados nas doenças listadas
tratamento(gastroenterite, 'Foco total na reidratação (soro caseiro) e dieta leve (arroz, canja, banana).').
tratamento(infecao_urinaria, 'Contacte um médico para prescrição de antibióticos; aumente a ingestão de água.').
tratamento(enxaqueca, 'Repouse num local escuro e silencioso e evite gatilhos de dor.').
tratamento(gripe_a, 'Contacte o médico ou a Saúde 24 para avaliar o uso de antivirais nas primeiras 48h.').
tratamento(tuberculose, 'Contacte um médico para tratamento rigoroso com antibióticos e acompanhamento constante.').
tratamento(hipertensao, 'Consulte o seu médico para ajuste de medicação diária e redução do sal.').
tratamento(diabetes, 'Contacte o médico para controlo da glicémia e ajuste de insulina ou hipoglicemiantes.').
tratamento(ataque_cardiaco, 'EMERGÊNCIA: Ligue imediatamente para o 112; não tente deslocar-se por meios próprios.').
tratamento(pneumonia, 'Contacte um médico para iniciar antibióticos e fisioterapia respiratória.').
tratamento(rinite, 'Evite contacto com pó ou pólen e use soro fisiológico ou anti-histamínicos.').
tratamento(lombalgia, 'Repouse em posição confortável e use compressas quentes na zona lombar.').
tratamento(sinusite, 'Faça lavagens nasais frequentes com soro fisiológico e reforce a hidratação.').
tratamento(hepatite, 'Requer acompanhamento médico para monitorizar o fígado e dieta sem gorduras.').
tratamento(malaria, 'Requer tratamento hospitalar imediato; dirija-se à urgência.').
tratamento(laringite, 'Poupe a voz, hidrate-se com líquidos mornos e evite ambientes secos.').
tratamento(otite, 'Contacte um médico para prescrição de gotas ou antibióticos; mantenha o ouvido seco.').
tratamento(conjuntivite, 'Lave os olhos com soro, use toalhas individuais e evite tocar nos olhos.').
tratamento(varicela, 'Use loções para a comichão e evite o contacto com grávidas ou bebés.').
tratamento(amigdalite, 'Faça gargarejos com água salgada e mantenha uma boa hidratação.').

% Processamento de Tratamentos
get_tratamentos([], []).

get_tratamentos([(D, P, E)|R], L) :- 
    get_tratamentos(R, R2),
    (
        (tratamento(D, T) -> 
            L = [(D, P, E, T)|R2]
        ; 
            L = [(D, P, E, 'Tratamento não especificado. Consulte um especialista.')|R2]
        )
    ).

% Apresentação de Resultados
apresentar_resultados([]).

apresentar_resultados([(D, P, E, T)|R]) :-
    format('~n--- DIAGNOSTICO: ~w ---~n', [D]),
    format('Certeza: ~w%~n', [P]),
    format('Explicacao: ~w~n', [E]),
    format('Recomendacao/Tratamento: ~w~n', [T]),
    nl,
    apresentar_resultados(R).