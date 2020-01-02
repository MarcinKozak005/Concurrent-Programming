-module(zad1).
-compile([export_all]).

send(_,0) -> 0;
send(Next,N) when N>0 ->
	{A,B,C} = now(),
	random:seed(A,B,C),
	Next!{odbierzWyslij,random:uniform(100)},
	send(Next,N-1).



producent() ->
	{A,B,C} = now(),
	random:seed(A,B,C),
	receive
    {produkuj,Next} -> 
											Next!{odbierzWyslij,random:uniform(100)},
											producent()
  end.

posrednik(Next) ->
	receive
		{odbierzWyslij,N} -> Next!{odbierz,N},
												io:format("Posrednicze ~p~n",[N]),
												posrednik(Next)
	end.


odbiorca() ->
  receive
    {odbierz,N} -> io:format("Odebralem(~p)~n",[N]),
										odbiorca()
  end.

loop() ->
	receive
		{a} -> io:format("a~n"), loop();
		{b} -> io:format("b~n"), loop();
		{c} -> io:format("c~n"), loop()
	end.


fmain() ->
	PidOdbiorca = spawn(?MODULE,odbiorca,[]),
	PidPosrednik = spawn(?MODULE,posrednik,[PidOdbiorca]),
  PidProducent = spawn(?MODULE,producent,[]),

  PidProducent!{produkuj,PidPosrednik},
  PidProducent!{produkuj,PidPosrednik},
  %PidProducent!{produkuj,11},

	%Loop = spawn(?MODULE,loop,[]),
	%Loop!{a},
	%Loop!{c},
	%Loop!{a},

  io:format("Koniec~n").

