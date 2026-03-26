:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(500, xfy, and).
:- op(800, xfx, <=).
:-dynamic(fact/1).

if espirros and corrimento_nasal and tosse and dor_garganta and dor_cabeca then infeccao_viral_respiratoria:0.9.
if infeccao_viral_respiratoria and febre and mal_estar and diarreia then covid:0.9.
if infeccao_viral_respiratoria and obstrucao_nasal and mal_estar then constipacao:0.8.
if constipacao and calafrios and dor_muscular and fadiga and perda_apetite and febre then gripe:0.7. 
if gripe and dor_respiracao and falta_ar then pneumonia:0.7.
if febre and dor_garganta and dor_cabeca and mal_estar then amigdalite:0.8.
if obstrucao_nasal and dor_cabeca and tosse then sinusite:0.8.
if espirros and dor_garganta and mal_estar and tosse then resfriado_comum:0.8.
if febre and dor_cabeca and dor_muscular and fadiga and perda_apetite then febre_tifoide:0.7.
if febre and tosse and falta_ar then asma:0.8.
if febre and dor_garganta and dor_cabeca and dor_respiracao then faringite:0.7.
if febre and calafrios and dor_muscular and fadiga and falta_ar then tuberculose:0.6.
if tosse and dor_respiracao and falta_ar then bronquite:0.8.
if febre and dor_garganta and dor_cabeca and dor_muscular then dengue:0.7.
if febre and calafrios and dor_garganta and dor_muscular and fadiga then malaria:0.6.
if febre and tosse and falta_ar and dor_garganta then pneumonia_viral:0.7.
if febre and dor_garganta and dor_cabeca and falta_ar then covid_mucoso:0.8.