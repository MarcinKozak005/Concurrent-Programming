%% -*- coding: utf-8 -*-
-module(lab1).
% nazwa modu�?u

-compile([export_all]).
% opcje kompilatora, w tym wypadku eksport wszystkich funkcji
% przydatne przy testowaniu
%
%-export([add/2, head/1, sum/1] ).
% lista funkcji jakie b�?d�? widoczne dla innych modu�?ów

-vsn(1.0).
% wersja

-kto_jest_najlepszy(ja).
%dowolny atom moş�? by�? wykorzystany jako 'atrybut' modu�?u
%po kompilacji uruchom lab1:module_info().
%inne narz�?dzia mog�? korzysta�? z tych informacji


-import(math,[pi/0]).
% lista modu�?ów ,które s�? potrzebne.
% nie jest to konieczne


%funkcje

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add(a1,a2) -> a1+a2.
add(A1,A2) -> A1+A2.
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
head([H|_]) -> {glowa,H}.
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum([]) -> 0;
sum([H|T]) -> H + sum(T).
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsum(L) -> tsum(L, 0). %tsum/1

tsum([H|T], S) -> tsum(T, S+H); %tsum/2 
tsum([],S) -> S.
% klauzule funkcji rozdzielana s�? �?rednikiem
% po ostatniej jst kropka
%################################

% moje
srednia(A,B) -> (A+B)/2.

silnia(0) -> 1;
silnia(1) -> 1;
silnia(A) -> silnia(A-1)*A.

% moje end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obwod_kola(Promien) -> 
        Dwa_pi = 2 * pi(),  % wyraşenie pomocnicze
        Dwa_pi * Promien.   % ostatni element przed '.' lib ';' 
                            % to wynik funkcji
%################################