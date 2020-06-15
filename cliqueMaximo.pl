vecinosN(_N,[],[]):-!.
vecinosN(N,[H|T],L):- \+ member(N,H), vecinosN(N,T,L).
vecinosN(N,[H|T],L):-member(N,H), delete(H,N,G), append(G,X,L), vecinosN(N,T,X).

vecinos([],_A,[]):-!.
vecinos([H|T],A,L):- Y = A,vecinosN(H,Y,G),  append([H],[G],R), append([R],X,L), vecinos(T,A,X).

aristaA([_H|T],L):- aristaA_aux(T,X), L = X.       
aristaA_aux([H|_T],L):-L = H.

aristaN([H|_T],L):- L = H.      

buscarN(N,[H|[]],L):-member(N,H), L= H.
buscarN(N,[H|T],L):- \+member(N,H), buscarN(N,T,L).



caminoClique(G,A,B,P) :-findall(Q,atravesar(G,A,B,[A],Q),L),reverse(L,P).

atravesar(G,A,B,P,[B|P]) :- conectado(A,B,G).
atravesar(G,A,B,Visitado,Camino) :-conectado(A,C,G),C \== B,\+member(C,Visitado),atravesar(G,C,B,[C|Visitado],Camino).  

conectado(X,Y,G) :- member([X,Y],G);member([Y,X],G).

clique([],_N,_R):-!.
clique([H|T],N,R):-caminoClique(N,H,H,P),cliqueN(P,N,X),append([],X,R),clique(T,N,R).

cliqueN([],_N,_R):-!.
cliqueN([H|T],N,R):-length(H,O),verificarClique(H,O,N,V),V == true,append([],H,R),cliqueN(T,N,R).
cliqueN([_H|T],N,R):- cliqueN(T,N,R).

verificarClique([],_L,_N,_V):-!.
verificarClique([H|T],L,N,V):-vecinosN(H,N,X),length(X,O),O >= L-2, 
    verificarClique(T,L,N,V).

eliminarUlt(T,[]):-length(T,L),L == 1,!.
eliminarUlt([H|T],R):-append([H],P,R),eliminarUlt(T,P).

maximoSubgrafoBipartito(N,A,L):-findall(X,sol(N,A,X),S),maxLar(S,T),listLargo(S,T,Ls),removeD(Ls,L).

sol([],[],[]).
sol(N,A,X):-conjuntos(N,C),aristas(C,A,X).

conjuntos([],[]).
conjuntos([H|T],L):-con(S),conjuntos(T,Ls),append(Ls,[[H,S]],L).

con(N):- N is 0.
con(N):- N is 1.

aristas(_S,[],[]):-!.
aristas(S,[[N1,N2]|T],L):- colision(S,[N1,N2],N),N is 5, aristas(S,T,L),!.
aristas(S,[[N1,N2]|T],L):- colision(S,[N1,N2],N),N is 2, aristas(S,T,Ls),append(Ls,[[N1,N2]],L),!.