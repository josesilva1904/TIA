:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(500, xfy, and).
:- op(800, xfx, <=).
:- dynamic(fact/1).

% Mafalda
if (tosse and febre and dificuldade_respirar) and (fadiga or dores_musculares or dor_cabeca or dor_garganta or congestao_nasal or nauseas or diarreia or dor_peito) then covid_19:0.9.
if (nauseas and vomitos and diarreia) and (febre or dores_musculares or dor_cabeca or perda_apetite or colicas) then gastroenterite:0.9.
if (dor_urinar and vontade_urinar) and (urina_turva or sangue_urina) then infecao_urinaria:0.9.
if (dor_cabeca) and (sensibilidade_luz or sensibilidade_som or aura_visual or nauseas) then enxaqueca:0.9.
if (tosse and febre and calafrios) and (fadiga or dores_musculares or dor_cabeca or dor_garganta or congestao_nasal or dor_peito) then gripe_a:0.9.

% Diana
if (tosse and (sangue_tossir or perda_peso)) and (febre or fadiga or perda_apetite or dor_peito or suar_excessivamente) then tuberculose:0.9.
if (dor_cabeca and (visao_turva or zumbido_ouvido)) and (dificuldade_respirar or nauseas or vomitos or dor_peito) then hipertensão:0.9.
if (sede_excessiva and vontade_urinar) and (fadiga or perda_peso or visao_turva or fome_excessiva or formigueiro) then diabetes:0.9.
if (dor_peito and dificuldade_respirar) and (fadiga or dores_musculares or nauseas or vomitos or suar_excessivamente or desmaio) then ataque_cardiaco:0.9.
if (tosse and febre and dificuldade_respirar) and (fadiga or nauseas or vomitos or dor_peito or confusao_mental or cianose) then pneumonia:0.9.

% Zé
if (congestao_nasal) and (tosse or fadiga or perda_paladar or perda_olfato) then rinite:0.9.
if (dores_musculares and formigueiro) then lombalgia:0.9.
if (dor_cabeca and tosse) and (febre or fadiga or dores_musculares) then sinusite:0.9.
if (perda_apetite and (nauseas or vomitos)) and (febre or fadiga or dores_musculares) then hepatite:0.9.
if (febre and calafrios) and (dor_garganta or dores_musculares or fadiga) then malaria:0.6.

% Vitória
if febre and dor_cabeca and nauseas and vomitos and calafrios and zumbido_ouvido and dor_ouvidos and secrecao_ouvido and diminuicao_audicao then laringite:0.9.
if visao_turva and sensibilidade_luz and comichao_olhos then otite:0.9.
if febre and fadiga and dores_musculares and dor_cabeca and perda_apetite and calafrios and comichao_pele then conjuntivite:0.9.
if tosse and febre and dificuldade_respirar and fadiga and dor_cabeca and perda_paladar and dor_garganta and perda_apetite and calafrios and dor_ouvidos and amigdalas_inchadas and mau_halito then varicela:0.9.
if tosse and febre and dificuldade_respirar and fadiga and dor_garganta and rouquidao and perda_voz and irritacao_garganta then amigdalite:0.9.