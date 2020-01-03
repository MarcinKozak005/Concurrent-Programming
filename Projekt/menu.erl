%  menu.erl
-module(menu).
-compile([export_all]).

printMenu() ->
    %print({clear}),
    print({gotoxy, 1, 1}),
    io:format("****MENU****
mała czarna kawa - 1.
duza czarna kawa - 2.
mała biała kawa  - 3.
duza biała kawa  - 4.
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
            timer:sleep(2000),
            Id!{monitorOk},
            monitor();
        {Id, start} -> 
            printMenu(),
            Kawa = io:get_chars("", 1),
            Id!{Kawa},
            monitor();
        {Komunikat, komunikat} ->
            io:format("\e[~p;~pH Komunikat: ~p~n", [12, 1, Komunikat]),
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
            timer:sleep(2000),
            Stan1 = {2000, 1000, 2000, 50, 500},
            Id!{magazynOk},
            magazyn(Stan1);
        {Id, stan} ->
            Id!{[Stan], komunikat},
            Id!{gotowe},
            magazyn({Woda, Kawa, Mleko, Herbata, Kakao});
        {Id, napoj, "1"} ->
            if Woda < 150 ->
                Id!{"brak wody", komunikat},
                Id!{gotowe},
                magazyn({Woda, Kawa, Mleko, Herbata, Kakao});
            true ->
                if Kawa < 10 ->
                    Id!{"brak kawy", komunikat},
                    Id!{gotowe},
                    magazyn({Woda, Kawa, Mleko, Herbata, Kakao});
                true -> 
                    Woda1 = Woda - 150,
                    Kawa1 = Kawa - 10,
                    timer:sleep(2000),
                    Id!{"Kazwa zrobiona", komunikat},
                    Id!{gotowe},
                    magazyn({Woda1, Kawa1, Mleko, Herbata, Kakao})
                end
            end
    end.

start() ->
    MonitorId = spawn(menu, monitor, []),
    MagazynId = spawn(menu, magazyn, [{2000, 1000, 2000, 50, 500}]),
    JCid = spawn(menu, jednostkaCentralna, [MonitorId, MagazynId]),
    JCid! { init}.

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
main()->
  print({clear}),
  print({printxy,1,20, "Ada"}),
  print({printxy,10,20, 2012}),
  
  print({tlo}),
  print({gotoxy,1,25}).  