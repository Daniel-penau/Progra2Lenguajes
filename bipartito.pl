%maximoSubgrafoBipartito([a,b,c,d],[[a,b],[a,c],[b,c],[b,d],[c,d]],X).
%conjuntos(N,A,L)

conjuntos([],_A,[],[],[]):-!.
conjuntos([N],A,R,B,S):- aristas(N,A,L),conjuntos([],A,Rs,B,Ls), append(Rs,[N],R),append(Ls,L,S),!.
conjuntos([N|Ns],A,R,B,S):-vecinosConN(N,A,V),aristas(N,A,L),removeL(Ns,V,N2),remove(N,A,As),
    conjuntos(N2,As,Rs,Bs,Ls),append(Bs,V,B), append(Rs,[N],R),append(Ls,L,S),!.


%Funcion que devuelve una lista con los vecinos de un nodo mediante las aristas
% Nodo, Aristas, Lista con los vecinos                     
vecinosConN(_N,[],[]):-!.
vecinosConN(N,[[N,B]|A],[B|RV]):-vecinosConN(N,A,RV),!.
vecinosConN(N,[[B,N]|A],[B|RV]):-vecinosConN(N,A,RV),!.
vecinosConN(N,[_C|A],RV):-vecinosConN(N,A,RV),!.

%Funcion que guarda las aristas de la solucion
%Nodo, Aristas, Lista con las aristas
aristas(_N,[],[]).
aristas(N,[[N,B]|A],L):-aristas(N,A,RV),append(RV,[[N,B]],L),!.
aristas(N,[[B,N]|A],L):-aristas(N,A,RV),append(RV,[[B,N]],L),!.
aristas(N,[_C|A],RV):-aristas(N,A,RV),!.

%Funcion que elimina las aristas que contengan X nodo
%Nodo, Aristas, Nueva lista
remove(_,[],[]).
remove(N, [[_X,N]|L], Xs):- remove(N,L,Xs),!.
remove(N, [[N,_X]|L], Xs):- remove(N,L,Xs),!.   
remove(N, [X|Xs], [X|Zs]):-remove(N, Xs,Zs).
%Funcion que elimina los elementos de una lista, de otra lista
%Lista, lista de elementos a eliminar, nueva lista
removeL([], _, []).
removeL([H|T], L2, R):- member(H, L2), !, removeL(T, L2, R). 
removeL([H|T], L2, [H|R]):- removeL(T, L2, R).

