:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(500, xfy, and).
:- op(800, xfx, <=).
:- dynamic(fact/1).

% Mafalda
if tosse and febre and dificuldade_respirar and fadiga and dores_musculares and dor_cabeca   and dor_garganta and congestao_nasal and nauseas and vomitos and diarreia and dor_peito then covid_19:0.9.
if febre and dores_musculares and dor_cabeca and nauseas and vomitos and diarreia and perda_apetite and colicas then gastroenterite:0.9.
if dor_urinar and urina_turva and sangue_urina and vontade_urinar then infecao_urinaria:0.9.
if dor_cabeca and nauseas and vomitos and sensibilidade_luz and sensibilidade_som and aura_visual then enxaqueca:0.9.
if tosse and febre and fadiga and dores_musculares and dor_cabeca and dor_garganta and congestao_nasal and calafrios and dor_peito then gripe_a:0.9.

% Diana
if tosse and febre and fadiga and perda_apetite and sangue_tossir and dor_peito and suar_excessivamente and perda_peso then tuberculose:0.9.
if dificuldade_respirar and dor_cabeca and nauseas and vomitos and dor_peito and visao_turva and zumbido_ouvido then hipertensão:0.9.
if fadiga and perda_peso and vontade_urinar and visao_turva and sede_excessiva and fome_excessiva and formigueiro then diabetes:0.9.
if dificuldade_respirar and fadiga and dores_musculares and nauseas and vomitos and dor_peito and suar_excessivamente and desmaio then ataque_cardiaco:0.9.
if tosse and febre and dificuldade_respirar and fadiga and nauseas and vomitos and dor_peito and confusao_mental and cianose then pneumonia:0.9.

% Zé
if tosse and fadiga and perda_paladar and perda_olfato and congestao_nasal then rinite:0.9.
if dores_musculares and formigueiro then lombalgia:0.9.
if tosse and febre and fadiga and dores_musculares and dor_cabeca then sinusite:0.9.
if febre and fadiga and dores_musculares and nauseas and vomitos and perda_apetite then hepatite:0.9.

% Vitória
if febre and dor_cabeca and nauseas and vomitos and calafrios and zumbido_ouvido and dor_ouvidos and secrecao_ouvido and diminuicao_audicao then laringite:0.9.
if visao_turva and sensibilidade_luz and comichao_olhos then otite:0.9.
if febre and fadiga and dores_musculares and dor_cabeca and perda_apetite and calafrios and comichao_pele then conjuntivite:0.9.
if tosse and febre and dificuldade_respirar and fadiga and dor_cabeca and perda_paladar and dor_garganta and perda_apetite and calafrios and dor_ouvidos and amigdalas_inchadas and mau_halito then varicela:0.9.
if tosse and febre and dificuldade_respirar and fadiga and dor_garganta and rouquidao and perda_voz and irritacao_garganta then amigdalite:0.9.