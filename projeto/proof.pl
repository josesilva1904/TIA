:- op(800, fx, if).
:- op(700, xfx, then).
:- op(500, xfy, or).
:- op(400, xfy, and).
:- op(800, xfx, <=).

result_proof(P, P) :-
    fact(P:_).

result_proof(P, P <= CondProof) :-
    if Cond then P:_,
    result_proof(Cond, CondProof).

result_proof(P1 and P2, Proof1 and Proof2) :-
    result_proof(P1, Proof1),
    result_proof(P2, Proof2).

result_proof(P1 or P2, Proof) :-
    result_proof(P1, Proof);
    result_proof(P2, Proof).

get_proofs([], []).

get_proofs([(D, P)|R], L) :-
    get_proofs(R, R2),
    (
        result_proof(D, E) -> 
            L = [(D, P, E)|R2]
        ; 
            L = [(D, P, 'Sintomas confirmados pelo utilizador')|R2]
    ).