% hello world program
-module(erlang1).
-compile([export_all]).
-vsn(1.0).

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

%----------------------------------------------------
obwod_kola(Promien) -> 
        Dwa_pi = 2 * pi(),  % wyraĹźenie pomocnicze
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

    
    
