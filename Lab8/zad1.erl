-module(zad1).
-compile([export_all]).


produkuj(_,_,0) -> ok;
produkuj(Prod,Posr,Num) ->
  Prod!{produkuj,Posr},
  produkuj(Prod,Posr,Num-1).

producent() ->
	{A,B,C} = now(),
	random:seed(A,B,C),
	receive
    {produkuj,Next} -> 
      Rand = random:uniform(100),
      io:format("(~p) Wysylam [~p]~n",[Rand,self()]),
	  	Next!{odbierzWyslij,Rand},
		  producent()
  end.

posrednik(Next) ->
	receive
		{odbierzWyslij,N} -> Next!{odbierz,N},
		  io:format("(~p) Posrednicze [~p]~n",[N,self()]),
			posrednik(Next)
	end.


odbiorca() ->
  receive
    {odbierz,N} -> io:format("(~p) Odebralem [~p]~n",[N,self()]),
		  odbiorca()
  end.


fmain(A) ->

	PidOdbiorca = spawn(?MODULE,odbiorca,[]),
	PidPosrednik = spawn(?MODULE,posrednik,[PidOdbiorca]),
  PidProducent = spawn(?MODULE,producent,[]),

  produkuj(PidProducent,PidPosrednik,A),

  io:format("Koniec~n").

