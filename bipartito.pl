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


%Busca el un camino en un grafo G desde un nodo A hasta un nodo B
%Su resultado queda en Path
camino(G,A,B,Path) :-atravesar(G,A,B,[A],Q),reverse(Q,Path).
atravesar(G,A,B,P,[B|P]) :- conectado(A,B,G).
atravesar(G,A,B,Visitado,Camino) :-conectado(A,C,G), C \== B,
    \+member(C,Visitado), atravesar(G,C,B,[C|Visitado],Camino).  
%Verifica que el nodo X y Y esten conectados, siendo miembros de
%la lista de las aristas
conectado(X,Y,G) :- member([X,Y],G);member([Y,X],G).
%Ejemplo de prueba:
%camino([[a,b],[a,e],[c,b],[c,d],[e,d],[d,f],[e,b]],a,e,C)

%Saca el maximo entre dos numeros X y Y
maximo(X,Y,X):- X >= Y.
maximo(X,Y,Y):- X < Y.
%Ejemplo de prueba:
%maximo(9,13,C)

%Saca el minimo entre dos numeros X y Y
minimo(X,Y,X):- X =< Y.
minimo(X,Y,Y):- X>Y.
%Ejemplo de prueba:
%minimo(9,3,C)

%Saca la cantidad de aristas que hay entre un nodo A y un nodo B
%en un grafo G
largo(G,A,B,L) :- camino(G,A,B,P), length(P,T), L is T-1.
%Ejemplo de prueba:
%largo([[a,b],[a,e],[c,b],[c,d],[e,d],[d,f],[e,b]],a,e,L)

%Dada una lista de aristas G, devuelve una lista con los nodos
eliminaRep(G,L) :- flatten(G,P), sort(P,L).
%Ejemplo de prueba:
%eliminaRep([[a,b],[a,e],[c,b],[c,d],[e,d],[d,f],[e,b]],L)

