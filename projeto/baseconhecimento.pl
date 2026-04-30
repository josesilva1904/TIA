:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).
:- dynamic(fact/1).

% Mafalda
if (nauseas and vomitos and diarreia) and (febre or dores_musculares or dor_cabeca or perda_apetite or colicas) then gastroenterite:0.8.
if (dor_urinar and vontade_urinar) and (urina_turva or sangue_urina) then infecao_urinaria:0.9.
if (dor_cabeca) and (sensibilidade_luz or sensibilidade_som or aura_visual or nauseas) then enxaqueca:0.8.
if (tosse and febre and calafrios) and (fadiga or dores_musculares or dor_cabeca or dor_garganta or congestao_nasal or dor_peito) then gripe_a:0.8.

% Diana
if (tosse and (sangue_tossir or perda_peso)) and (febre or fadiga or perda_apetite or dor_peito or suar_excessivamente) then tuberculose:0.9.
if (dor_cabeca and (visao_turva or zumbido_ouvido)) and (dificuldade_respirar or nauseas or vomitos or dor_peito) then hipertensao:0.8.
if (sede_excessiva and vontade_urinar) and (fadiga or perda_peso or visao_turva or fome_excessiva or formigueiro) then diabetes:0.8.
if (dor_peito and dificuldade_respirar) and (fadiga or dores_musculares or nauseas or vomitos or suar_excessivamente or desmaio) then ataque_cardiaco:0.9.
if (tosse and febre and dificuldade_respirar) and (fadiga or nauseas or vomitos or dor_peito or confusao_mental or cianose) then pneumonia:0.8.

% Zé
if (congestao_nasal) and (tosse or fadiga or perda_paladar or perda_olfato) then rinite:0.7.
if (dores_musculares and formigueiro) then lombalgia:0.6.
if (dor_cabeca and tosse) and (febre or fadiga or dores_musculares) then sinusite:0.7.
if (perda_apetite and (nauseas or vomitos)) and (febre or fadiga or dores_musculares) then hepatite:0.8.
if (febre and calafrios) and (dor_garganta or dores_musculares or fadiga) then malaria:0.6.

% Vitória
if (febre and dor_cabeca) and (nauseas or vomitos or calafrios or zumbido_ouvido or dor_ouvidos or secrecao_ouvido or diminuicao_audicao) then laringite:0.7.
if (visao_turva) and (sensibilidade_luz or comichao_olhos) then otite:0.9.
if (febre and fadiga) and (dores_musculares or dor_cabeca or perda_apetite or calafrios or comichao_pele) then conjuntivite:0.8.
if (tosse and febre and dificuldade_respirar) and (fadiga or dor_cabeca or perda_paladar or dor_garganta or perda_apetite or calafrios or dor_ouvidos or amigdalas_inchadas or mau_halito) then varicela:0.9.
if (tosse and febre and dificuldade_respirar) and (fadiga or dor_garganta or rouquidao or perda_voz or irritacao_garganta) then amigdalite:0.8.


% ========================================================
% PARTE B: REGRAS EXTRAIDAS (DECISION TREE SEM PRUNING)
% ========================================================

% --- RAMO PRINCIPAL: TEM DOR DE GARGANTA ---
if (dor_garganta and dificuldade_respirar and dor_cabeca) then varicela:0.85.
if (dor_garganta and dificuldade_respirar) then amigdalite:0.85.
if (dor_garganta) then gripe_a:0.85. % Nota: O Prolog vai priorizar as regras mais longas primeiro.

% --- RAMO PRINCIPAL: NÃO TEM DOR DE GARGANTA, TEM FEBRE ---
if (febre and fadiga and tosse and dificuldade_respirar) then pneumonia:0.85.
if (febre and fadiga and tosse and dores_musculares) then sinusite:0.85.
if (febre and fadiga and tosse) then tuberculose:0.85.
if (febre and fadiga and dor_cabeca) then conjuntivite:0.85.
if (febre and fadiga) then hepatite:0.85.
if (febre and dores_musculares) then gastroenterite:0.85.
if (febre) then laringite:0.85.

% --- RAMO PRINCIPAL: NÃO TEM DOR DE GARGANTA, NÃO TEM FEBRE, TEM FADIGA ---
if (fadiga and tosse) then rinite:0.85.
if (fadiga and dificuldade_respirar) then ataque_cardiaco:0.85.
if (fadiga) then diabetes:0.85.

% --- RAMO PRINCIPAL: NÃO TEM DOR DE GARGANTA, NÃO FEBRE, NÃO FADIGA ---
if (dor_cabeca and dificuldade_respirar) then hipertensao:0.85.
if (dor_cabeca) then enxaqueca:0.85.
if (dores_musculares) then lombalgia:0.85.
if (dor_urinar) then infecao_urinaria:0.85.

% O caso final (quando é "Não" a tudo na árvore, recai na Otite no teu dataset sintético)
% No Prolog exigimos pelo menos um sintoma chave para não disparar do nada.
if (sensibilidade_luz or zumbido_ouvido) then otite:0.80.