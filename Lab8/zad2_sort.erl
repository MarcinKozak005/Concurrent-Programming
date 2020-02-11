%  sort1.erl
-module(sort1).
-compile([export_all]).


%-----------------------------SORTOWANIA


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

%---------------------------------------
% IT DOES NOT WORK PROPERLY!
mergeSortW(Parent,[]) -> Parent!{self(),[]};
mergeSortW(Parent,[A]) -> Parent!{self(),[A]};
mergeSortW(Parent,List) ->
	{Left,Right} = lists:split(trunc(length(List)/2),List),
	A1 = spawn(?MODULE,mergeSortW,[self(),Left]),
	A2 = spawn(?MODULE,mergeSortW,[self(),Right]),
	receive
		{A1,Tab1} ->
			receive
				{A2,Tab2} -> Parent!{self(),merge(Tab1,Tab2)}
			end;
		{A2,Tab1} ->
			receive
				{A1,Tab2} -> Parent!{self(),merge(Tab1,Tab2)}
			end
	end.



%-----------------------------SORTOWANIA



get_mstimestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).

sorts(L) -> 
  mergeSort(L).

sortw(L) -> 
  mergeSortW(self(),L).



gensort() ->
 L=[random:uniform(5000)+100 || _ <- lists:seq(1, 23000)],	
 Lw=L,
 %io:format("Tablica: ~p",[L]),
 io:format("~nLiczba elementow = ~p ~n~n",[length(L)]),
 
 io:format("Sortuje sekwencyjnie~n"),	
 TS1=get_mstimestamp(),
 sorts(L),
 DS=get_mstimestamp()-TS1,
 %io:format("~p~n",[sorts(L)]),	
 io:format("Czas sortowania ~p [ms]~n~n",[DS]),
 io:format("Sortuje wspolbieznie~n"),	
 TS2=get_mstimestamp(),
 sortw(Lw),
 DS2=get_mstimestamp()-TS2,
 %io:format("~p~n",[sortw(Lw)]),
 io:format("Czas sortowania ~p [ms]~n",[DS2]).
 
 
