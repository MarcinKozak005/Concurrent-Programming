% hello world program
-module(lab4).
%-export([start/0]).
%-export([pole/1,objetosc/1]).

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

generujOnes(0) -> [];
generujOnes(N) -> [1] ++ generujOnes(N-1).

generujX(_,0) -> [];
generujX(X,N) -> [X] ++ generujX(X,N-1).

%----------------TEMPERATURY
% c - celciusz
% k - kelwin
% f - farenheit
% r - rankine

temperature({S,X},S) -> {S,X};
temperature({c,X},S) -> case S of
			k -> {k,X+273.15};
			f -> {f,(9.0/5.0)* X+32.0};
			r -> {r,(9.0/5.0)* (X+273.15)}
		end;
temperature({f,X},S) -> case S of
			k -> {k,(X+459.67)*5.0/9.0};
			c -> {c,(5.0/9.0)*(X-32.0)};
			r -> {r,X+459.67}
		end;
temperature({k,X},S) -> case S of
			c -> {c,X-273.15};
			f -> {f,(9.0/5.0)*X-459.67};
			r -> {r,X*9.0/5.0}
		end;
temperature({r,X},S) -> case S of
			k -> {k,X*5.0/9.0};
			f -> {f,X-459.67};
			c -> {c,(5.0/9.0)*X-273.15}
		end.

%----------------SORTOWANIE

%merge([],[]) -> [];
merge([],A) -> A;
merge(A,[]) -> A;
merge([Ha|Ta],[Hb|Tb]) ->
	if
		Ha<Hb -> [Ha]++merge(Ta,[Hb|Tb]);
		true -> [Hb]++merge([Ha|Ta],Tb)
	end.


mergeSort([]) -> [];
mergeSort([A]) -> [A];
mergeSort(List) ->
	{Left,Right} = lists:split(trunc(length(List)/2),List),
	merge(mergeSort(Left),mergeSort(Right)).
		

bubbleSort([]) -> [];
bubbleSort([A]) -> [A];
bubbleSort(List) ->
    LastSorted = helperBubbleSort(List),
    bubbleSort(lists:sublist(LastSorted,length(LastSorted)-1)) ++ [lists:last(LastSorted)].
        
helperBubbleSort([]) -> [];
helperBubbleSort([X]) -> [X];
helperBubbleSort([A,B|T]) ->
    if
        A > B -> [B|helperBubbleSort([A|T])];
        true -> [A|helperBubbleSort([B|T])]
    end.





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
    io:fwrite("Generowana N..1: ~w\n",[generujListe(8)]),
    io:fwrite("Lista pol: ~w\n",[polaFigur([{kolo,2},{kula,12},{kwadrat,5,5},{stozek,12,5}])]),
    io:fwrite("Lista BubbleSorted: ~w",[bubbleSort([1,2,34,123,20,11])]).
