% hello world program
-module(helloworld).
-export([start/0]).
-export([pole/1,objetosc/1]).

-import(math,[sqrt/1,pi/0]).
-import(lists,[]).

-compile(export_all).


%----------------LISTY
len([]) -> 0;
len([_|T]) -> 1+len(T).

amax([H]) -> H;
amax([H|T])->
        case H > amax(T) of
            true -> H;
            false -> amax(T)
        end.

amin([H]) -> H;
amin([H|T])->
        case H < amin(T) of
            true -> H;
            false -> amin(T)
        end.

kMinMax(T) -> {amin(T),amax(T)}.
lMinMax(T) -> [amin(T),amax(T)].

generujListe(1) -> [1];
generujListe(N) -> [N]++generujListe(N-1).


%----------------FIGURY 
pole({kwadrat,X,Y}) ->  X*Y;
pole({kolo,X}) -> 3.14*X*X;
%heron
pole({trojkat,A,B,C}) -> sqrt((A+B+C)*(B+C-A)*(A+B-C)*(C+A-B)/16);
%
pole({trapez,A,B,H}) -> (A+B)*H/2;
pole({kula,R}) -> 4*pi()*R*R;
pole({szescian,X}) -> 6*X*X;
pole({stozek,R,H}) -> pi()*R*R + (pi()*R*sqrt(R*R+H*H)).

objetosc({kula,R}) -> 4*pi()*R*R*R/3;
objetosc({szescian,X}) -> X*X*X;
objetosc({stozek,R,H}) -> pi()*R*R*H/3.

%----------------LISTY & FIGURY
polaFigur([H]) -> [pole(H)];
polaFigur([H|T]) -> [pole(H)|polaFigur(T)].

start() ->
    io:fwrite("Pole trojkata: ~w\n",[pole({trojkat,3,4,5})]),
    io:fwrite("Lista ~w\n",[[1,2,34,123,20,11]]),
    io:fwrite("Len listy ~w : ~w\n",[[1,2,34,123,20,11],len([1,2,34,123,20,11])]),
    io:fwrite("Max i min listy (lista): ~w\n",[lMinMax([1,2,34,123,20,11])]),
    io:fwrite("Max i min listy (krotka): ~w\n",[kMinMax([1,2,34,123,20,11])]),
    io:fwrite("Generowana N..1: ~w",[generujListe(8)]),
    io:fwrite("Lista pol: ~w",[polaFigur([{kolo,2},{kula,12},{kwadrat,5,5},{stozek,12,5}])]).
    
    