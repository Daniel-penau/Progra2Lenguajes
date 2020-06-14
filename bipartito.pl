maximoSubgrafoBipartito(N,A,R):- soluciones(N,A,L), maxLar(L,Num), listLargo(L,Num,R). 

%Funcion que devuelve una solucion de aristas
conjuntos([],_A,[]):-!.
conjuntos([N],A,S):- aristas(N,A,L),conjuntos([],A,Ls),append(Ls,L,S),!.
conjuntos([N|Ns],A,S):-vecinosConN(N,A,V),aristas(N,A,L),removeL(Ns,V,N2),remove(N,A,As),
    conjuntos(N2,As,Ls),append(Ls,L,S),!.

%Funcion que devuelve una lista con los vecinos de un nodo mediante las aristas                    
vecinosConN(_N,[],[]):-!.
vecinosConN(N,[[N,B]|A],[B|RV]):-vecinosConN(N,A,RV),!.
vecinosConN(N,[[B,N]|A],[B|RV]):-vecinosConN(N,A,RV),!.
vecinosConN(N,[_C|A],RV):-vecinosConN(N,A,RV),!.

%Funcion que guarda las aristas de la solucion
aristas(_N,[],[]).
aristas(N,[[N,B]|A],L):-aristas(N,A,RV),append(RV,[[N,B]],L),!.
aristas(N,[[B,N]|A],L):-aristas(N,A,RV),append(RV,[[B,N]],L),!.
aristas(N,[_C|A],RV):-aristas(N,A,RV),!.

%Funcion que elimina las aristas que contengan X nodo
remove(_,[],[]).
remove(N, [[_X,N]|L], Xs):- remove(N,L,Xs),!.
remove(N, [[N,_X]|L], Xs):- remove(N,L,Xs),!.   
remove(N, [X|Xs], [X|Zs]):-remove(N, Xs,Zs).

%Funcion que elimina los elementos de una lista, de otra lista
removeL([], _, []).
removeL([H|T], L2, R):- member(H, L2), !, removeL(T, L2, R). 
removeL([H|T], L2, [H|R]):- removeL(T, L2, R).

%Crea la lista de soluciones posibles
soluciones(G,A,L):- findall(X,permutar(G,X),Ls), solucion(Ls,A,S),sDup(S,Ps),removeD(Ps,Rs),
    append(L,[],Rs),!.
%Funcion aux de soluciones
solucion([],_A,[]).
solucion([H|T],A,S):- conjuntos(H,A,L),solucion(T,A,Ls),append(Ls,[L],S),!.

%Funcion para permutar
permutar([],[]).
permutar(L,[C|Cola]):- miembro(C,L), quitar(C,L, LMC), permutar(LMC,Cola).
miembro(E,[E|_H]).
miembro(E,[_H|T]):- miembro(E,T).
quitar(E,[E|T],T):-!.
quitar(E,[H|T],[H|TQ]):- quitar(E,T,TQ).
quitar(_E,[],[]).

%Funcion para eliminar duplicados
removeD([],[]).
removeD([H | T], List):- member(H, T),removeD( T, List),!.
removeD([H | T], [H|T1]):- \+ member(H, T), removeD( T, T1),!.

%Ordena duplicados
sDup([],[]).
sDup([H|T],L):- sort(H,Hs),sDup(T,Ls),append(Ls,[Hs],L).

%Funcion que devuelve el max largo de los elementos de una lista
maxLar([],R,R):-!.
maxLar([H|T],M,R):-tam(H,X),X > M,maxLar(T,X,R).
maxLar([H|T],M,R):-tam(H,X),X =< M,maxLar(T,M,R).
maxLar([H|T],R):-tam(H,X),maxLar(T,X,R),!.

%Funcion que devuelve el tamanio de una lista
tam(L,R):-tam(L,0,R).
tam([],R,R).
tam([_|T],N,R):-N1 is N+1 ,tam(T,N1,R).

%Funcion para crear lista con el maximo largo de las soluciones
listLargo([],_Num,[]).
listLargo([H|T],Num,S):- tam(H,X),X >= Num, listLargo(T,Num,Ss),append(Ss,[H],S),!.
listLargo([H|T],Num,S):- tam(H,X),X =< Num, listLargo(T,Num,S),!. 

%----------------------------------------------------------------------------------------------------------------------------

diametro(G,A,X) :- iniciar(G,A,L), maxLar(L,T), listLargo(L,T,X).

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

%Dado un grafo, un nodo A y un nodo B, obtiene una lista L con
%todos los largos de las aristas
tamanos(G,A,B,L) :- findall(X,largo(G,A,B,X),L).
%Ejemplo de prueba:
%

miniList(G,A,B,M):- tamanos(G,A,B,R), min_list(R,M).
%Ejemplo de prueba:
%miniList([[a,b],[b,e],[e,g],[g,c],[c,a],[c,d],[d,f],[f,h]],a,h,M) = 4
%miniList([[a,b],[a,e],[c,b],[c,d],[e,d],[d,f],[e,b]],a,e,M) = 1

indexOf([E|_], E, 0).
indexOf([_|T], E, I):-indexOf(T, E, I1),
  I is I1+1.  % and increment the resulting index

pos(G,A,B,P) :- miniList(G,A,B,P1), tamanos(G,A,B,L), 
    indexOf(L, P1, P).

getItemOnPos(G,[A,B],Path):- pos(G,A,B,E), findall(X,camino(G,A,B,X),L), 
    nth0(E, L, Path).

%[a,b,c,d]

iniciar(GO,A,R):- findall(X,combino(GO,2,X), L), reverse(GO,GR),
    findall(Y,combino(GR,2,Y), L1), append(L,L1,LC),
            iniciarAux(A,LC,R).

%[H|T] es el combino
iniciarAux(_G,[],_R).
iniciarAux(G,[H|T],R):- findall(X,getItemOnPos(G,H,X),R1), iniciarAux(G,T,RS), 
			append(RS,R1,R),!.

combino(_G, 0, []).
combino([H|T], N, [H|L]):- N>0, N1 is N-1, combino(T, N1, L).
combino([_H|T], N, L):- N>0, combino(T,N,L).   
    
    
    
    
    
    
    
