%% -*- coding: utf-8 -*-
-module(lab1).
% nazwa modu≈?u

-compile([export_all]).
% opcje kompilatora, w tym wypadku eksport wszystkich funkcji
% przydatne przy testowaniu
%
%-export([add/2, head/1, sum/1] ).
% lista funkcji jakie bƒ?dƒ? widoczne dla innych modu≈?√≥w

-vsn(1.0).
% wersja

-kto_jest_najlepszy(ja).
%dowolny atom mo≈üƒ? byƒ? wykorzystany jako 'atrybut' modu≈?u
%po kompilacji uruchom lab1:module_info().
%inne narzƒ?dzia mogƒ? korzystaƒ? z tych informacji


-import(math,[pi/0]).
% lista modu≈?√≥w ,kt√≥re sƒ? potrzebne.
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
% klauzule funkcji rozdzielana sƒ? ≈?rednikiem
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
        Dwa_pi = 2 * pi(),  % wyra≈üenie pomocnicze
        Dwa_pi * Promien.   % ostatni element przed '.' lib ';' 
                            % to wynik funkcji
%################################