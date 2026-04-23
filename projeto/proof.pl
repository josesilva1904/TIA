% Definição de operadores para o parser reconhecer a estrutura
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, and).
:- op(300, xfy, or).
:- op(800, xfx, <=).


% Caso base: O sintoma é um facto conhecido (introduzido pelo utilizador)
result_proof(P, P) :-
    fact(P:_).

% Caso recursivo: A conclusão P é derivada de uma regra 'if Cond then P:Certeza'
result_proof(P, P <= CondProof) :-
    if Cond then P:_,
    result_proof(Cond, CondProof).

% Conjunção (and): Ambas as partes precisam de uma prova
result_proof(P1 and P2, Proof1 and Proof2) :-
    result_proof(P1, Proof1),
    result_proof(P2, Proof2).

% Disjunção (or): Apenas uma das partes precisa de ser provada
result_proof(P1 or P2, Proof) :-
    result_proof(P1, Proof);
    result_proof(P2, Proof).

% get_proofs(ListaInput, ListaOutput)
% Transforma [(Doenca, Percentagem)] em [(Doenca, Percentagem, Explicação)]

get_proofs([], []).

get_proofs([(D, P)|R], L) :-
    get_proofs(R, R2), % Processar o resto da lista primeiro
    (
        % Tenta gerar a prova para a doença D
        result_proof(D, E) -> 
            L = [(D, P, E)|R2]
        ; 
            % Se falhar em gerar prova (caso raro se o forward chain a detetou), 
            % mantém uma mensagem genérica ou ignora
            L = [(D, P, 'Sintomas confirmados pelo utilizador')|R2]
    ).