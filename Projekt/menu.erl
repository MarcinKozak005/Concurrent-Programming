%  menu.erl
-module(menu).
-compile([export_all]).

% woda, kawa, mleko, herbata, kakao
getIngredients(Num) -> 
    element(Num,{
    {150,20,0,0,0},
    {250,40,0,0,0},
    {120,20,30,0,0},
    {210,20,40,0,0}
    }). %generalnie trzeba dopisac reszte mozliwych produktow

printMenu() ->
    %print({clear}),
    print({gotoxy, 1, 1}),
    io:format("****MENU****
mala czarna kawa - 1.
duza czarna kawa - 2.
mala biala kawa  - 3.
duza biala kawa  - 4.
latte            - 5.
capuchino        - 6.
espresso         - 7.
herbata          - 8.
kakao            - 9.

Wybierz numer napoju: ").

monitor() ->
    receive
        {Id, init} ->
            print({clear}),
            timer:sleep(20),
            Id!{monitorOk},
            monitor();
        {Id, start} -> 
            printMenu(),
            Kawa = io:get_chars("", 1),
            Id!{Kawa},
            monitor();
        {Komunikat, komunikat} ->
            io:format("\e[~p;~pHKomunikat: ~p~n", [13, 0, Komunikat]),
            monitor();
        {koniec} ->
            io:format("M koniec ~n")
    end.

jednostkaCentralna(MonitorId, MagazynId)->
    %io:format("jendostka centralna ~n"),
    receive
        {init} ->
            MonitorId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId);
        {monitorOk} ->
            MagazynId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId);
        {magazynOk} ->
            %io:format("JC start ~n"),
            MonitorId!{self(), start},
            jednostkaCentralna(MonitorId, MagazynId);
        {gotowe} ->
            MonitorId!{self(), start},
            jednostkaCentralna(MonitorId, MagazynId);
        {"k"} -> 
            exit(self(), "Bo tak");
        {"r"} ->
            MagazynId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId);
        {"s"} ->
            MagazynId!{self(), stan},
            jednostkaCentralna(MonitorId, MagazynId);
        {Napoj} ->
            MonitorId!{"Prosze czekac, napoj w trakcie produkcji", komunikat},
            MagazynId!{self(), napoj, Napoj},
            jednostkaCentralna(MonitorId, MagazynId);
        {Blad, komunikat} ->
            MonitorId!{Blad, komunikat},
            jednostkaCentralna(MonitorId, MagazynId)
    end.

magazyn(Stan) ->
    Woda = element(1, Stan),
    Kawa = element(2, Stan),
    Mleko = element(3, Stan),
    Herbata = element(4, Stan),
    Kakao = element(5, Stan),
    receive
        {Id, init} ->
            timer:sleep(20),
            Stan1 = {20, 1000, 2000, 50, 500},
            Id!{magazynOk},
            magazyn(Stan1);
        {Id, stan} ->
            Id!{[Stan], komunikat},
            Id!{gotowe},
            magazyn({Woda, Kawa, Mleko, Herbata, Kakao});
        {Id, napoj, NumerNapoju} ->
            if Woda < 150 ->
                Id!{"brak wody", komunikat},
                Id!{gotowe},
                magazyn({Woda, Kawa, Mleko, Herbata, Kakao});    
            true ->
                {NumAsInt,_} =string:to_integer(NumerNapoju),
                Skladniki = getIngredients(NumAsInt),
                UsedWoda = element(1,Skladniki),
                UsedKawa = element(2,Skladniki),
                UsedMleko = element(3,Skladniki),
                UsedHerbata = element(4,Skladniki),
                UsedKakao = element(5,Skladniki),

                Woda1 = Woda - UsedWoda,                
                Kawa1 = Woda - UsedKawa,
                Mleko1 = Woda - UsedMleko,
                Herbata1 = Woda - UsedHerbata,
                Kakao1 = Woda - UsedKakao,
                
                timer:sleep(2000),
                Id!{"Kawa zrobiona, dziekujemy i zapraszamy ponownie!", komunikat},
                Id!{gotowe},
                magazyn({Woda1, Kawa1, Mleko1, Herbata1, Kakao1})
            end
    end.

start() ->
    MonitorId = spawn(?MODULE, monitor, []),
    MagazynId = spawn(?MODULE, magazyn, [{2000, 1000, 2000, 50, 500}]),
    JCid = spawn(?MODULE, jednostkaCentralna, [MonitorId, MagazynId]),
    JCid!{init}.

print({gotoxy,X,Y}) ->
   io:format("\e[~p;~pH",[Y,X]);
print({printxy,X,Y,Msg}) ->
   io:format("\e[~p;~pH~p",[Y,X,Msg]);   
print({clear}) ->
   io:format("\e[2J",[]);
print({tlo}) ->
  print({printxy,2,4,1.2343}),  
  io:format("a",[])  .
   
printxy({X,Y,Msg}) ->
   io:format("\e[~p;~pH~p~n",[Y,X,Msg]). 
