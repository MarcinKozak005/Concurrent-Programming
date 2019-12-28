% hello world program
-module(helloworld).
-export([start/0]).


-kto_jest_najlepszy(ja).


-import(math,[pi/0]).


%funkcje

%----------------------------------------------------
%add(a1,a2) -> a1+a2.
add(A1,A2) -> A1+A2.

%----------------------------------------------------
head([H|_]) -> {glowa,H}.

%----------------------------------------------------
sum([]) -> 0;
sum([H|T]) -> H + sum(T).

%----------------------------------------------------
tsum(L) -> tsum(L, 0). %tsum/1

tsum([H|T], S) -> tsum(T, S+H); %tsum/2 
tsum([],S) -> S.
% klauzule funkcji rozdzielana s�? �?rednikiem
% po ostatniej jst kropka

%----------------------------------------------------
obwod_kola(Promien) -> 
        Dwa_pi = 2 * pi(),  % wyraşenie pomocnicze
        Dwa_pi * Promien.   % ostatni element przed '.' lib ';' 
                            % to wynik funkcji

%---------------------------------------------------------------------
srednia(A,B) ->
  (A+B)/2.

silnia(0) -> 1;
silnia(N) ->
  N*silnia(N-1).

fibonacci(1) -> 1;
fibonacci(2) -> 1;
fibonacci(N) -> fibonacci(N-1)+fibonacci(N-2).

%---------------------------------------------------------------------


start() ->
    io:fwrite("~w\n",[srednia(23,12)]),
    io:fwrite("~w\n",[silnia(5)]),
    io:fwrite("~w\n",[fibonacci(12)]).
    
    