%  menu.erl

%obsluga blenowd poprawiona
-module(menu).
-compile([export_all]).

%---STALE -> aby uniknac HardCoded Variables
progressBarLength() ->  10.
numberOfProducts() ->    9.
progressBarLine() ->    13.
komunikatLine() ->      14.
errorLine() ->          15.
wodaLine()->            17.
kawaLine()->            19.
stanProduktowLine() ->  21.
finishLine() ->         24.
%---STALE END


% Składniki poszczegolnych napojow
% woda, kawa, mleko, herbata, kakao
getIngredients(Num) -> 
    element(Num,{
    { 150, 10, 0  , 0, 0 },
    { 300, 25, 0  , 0, 0 },
    { 100, 10, 80 , 0, 0 },
    { 170, 25, 150, 0, 0 },
    { 60 , 20, 200, 0, 0 },
    { 70 , 25, 100, 0, 0 },
    { 50 , 40, 0  , 0, 0 },
    { 250, 0 , 0  , 1, 0 },
    { 0  , 0 , 250, 0, 15}
    }). %progressBarLine

% Poczatkowy stan automatu
% woda, kawa, mleko, herbata, kakao
getInitialMachineResources() -> {2000, 1000, 2000, 50, 500}.

% funkcja odpowiadajaca za wyswietlanie paska postepu produkcji napoju
printProgressBar(0,_,_,_) -> io:format(" ");
printProgressBar(N,Czas,Line,Znak) ->
    print({gotoxy,progressBarLength()-N,Line}),
    io:format(Znak),
    print({gotoxy,0,finishLine()}),
    timer:sleep(Czas),
    printProgressBar(N-1,Czas,Line,Znak).

%wypisz menu
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


%-----------------------------------------

%proces obslugi monitora
monitor() ->
    receive
        {Id, init} ->
            print({clear}),
            timer:sleep(20),
            Id!{monitorOk},
            monitor();
        {Id, start} -> 
            print({clear}),
            printMenu(),
            Kawa = io:get_chars("", 1),
            Id!{Kawa},
            monitor();
        %{Tresc komunikatu, komunikat, linia w ktorej ma sie pojawic Tresc komunikatu}
        {Komunikat, komunikat,LineNumber} ->
            io:format("\e[~p;~pHKomunikat: ~p~n", [LineNumber, 0, Komunikat]),
            print({gotoxy,0,finishLine()}),
            monitor();
		{partOfProgress,Line,Znak} ->
			io:format("\e[~p;~pH~p", [Line, 0, Znak]),
            print({gotoxy,0,finishLine()}),
            monitor();
        {printBrogressBarMonitor,Line} ->
            printProgressBar(10,500,Line,"o"),
            monitor();
        {koniec} ->
            io:format("M koniec ~n")
    end.

%Glowna jednostka odpowiedzialna za obsluge
jednostkaCentralna(MonitorId, MagazynId, BaristaId)->
    %io:format("jendostka centralna ~n"),
    receive
        {init} ->
            MonitorId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
        {monitorOk} ->
            MagazynId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
        {magazynOk} ->
            %io:format("JC start ~n"),
            MonitorId!{self(), start},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);

        {magazynMaZasoby,NumerNapoju} ->
            BaristaId!{self(),pracuj,NumerNapoju},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);

        {gotowe} ->
            MonitorId!{"Wykonano prace", komunikat,15},
            timer:sleep(3000),
            MonitorId!{self(), start},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
		{partOfProgress,Line,Znak} ->
			MonitorId!{partOfProgress,Line},
            jednostkaCentralna(MonitorId,MagazynId, BaristaId);
        {printProgressBarCentralna,Line} ->
            MonitorId!{printBrogressBarMonitor,Line},
            jednostkaCentralna(MonitorId,MagazynId, BaristaId);
        {"k"} -> 
            exit(self(), "Bo tak");
        {"r"} ->
            MagazynId!{self(), init},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
        {"s"} ->
            MagazynId!{self(), stan},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
        {Napoj} ->
            MonitorId!{"Prosze czekac, przetwarzanie polecenia", komunikat,komunikatLine()},

            {NumAsInt,_} = string:to_integer(Napoj),

            case NumAsInt of
                error -> MonitorId!{"Wprowadzono niepoprawna wartosc", komunikat,errorLine()},
                    timer:sleep(3000),
					MonitorId!{self(), start},
            		jednostkaCentralna(MonitorId, MagazynId, BaristaId);
                _ -> null
            end,

            print({gotoxy,0,finishLine()}),
            MagazynId!{self(), napoj, NumAsInt},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId);
        {Blad, komunikat, LineNumber} ->
            MonitorId!{Blad, komunikat,LineNumber},
            jednostkaCentralna(MonitorId, MagazynId, BaristaId)
    end.

barista(CzajnikId,MlynekId) ->
    receive
        {Id,pracuj,NumerNapoju} ->
			Skladniki = getIngredients(NumerNapoju),
			UsedWoda = element(1,Skladniki),
    		UsedKawa = element(2,Skladniki),
    		UsedMleko = element(3,Skladniki),

            CzajnikId!{self(),gotujWode,UsedWoda},
            MlynekId!{self(),mielKawe,UsedKawa},
            

       	{woda,zagotowana} ->
        	receive
                {kawa,zmielona} -> Id!{gotowe},    barista(CzajnikId,MlynekId)
            end;
        {kawa,zmielona} ->
            receive
                {woda,zagotowana} -> Id!{gotowe}, barista(CzajnikId,MlynekId)
            end
		{Linia,Znak} ->
			
            
    end.

czajnik() ->
    receive
        {Id,gotujWode,Woda} ->
			Parts = round(Woda/50),
            printProgressBar(10,Parts*100,wodaLine(),"w"),
            %timer:sleep(3000),
            Id!{woda,zagotowana},
            czajnik()
    end.

mlynek() ->
    receive
        {Id,mielKawe,Kawa} ->
			Parts = round(Kawa/5),
            printProgressBar(10,Parts*100,kawaLine(),"k"),
            %timer:sleep(3000),
            Id!{kawa,zmielona},
            mlynek()            
    end.

%obsluga magazynu
magazyn(Stan) ->
    Woda = element(1, Stan),
    Kawa = element(2, Stan),
    Mleko = element(3, Stan),
    Herbata = element(4, Stan),
    Kakao = element(5, Stan),
    receive
        {Id, init} ->
            timer:sleep(20),
            Stan1 = getInitialMachineResources(),
            Id!{magazynOk},
            magazyn(Stan1);
        {Id, stan} ->
            Id!{[Stan], komunikat,komunikatLine()},
            Id!{gotowe},
            magazyn({Woda, Kawa, Mleko, Herbata, Kakao});
        {Id, napoj, NumerNapoju} ->

               

                Skladniki = getIngredients(NumerNapoju),
                UsedWoda = element(1,Skladniki),
                UsedKawa = element(2,Skladniki),
                UsedMleko = element(3,Skladniki),
                UsedHerbata = element(4,Skladniki),
                UsedKakao = element(5,Skladniki),
                
                WodaLeft = Woda-UsedWoda,
                KawaLeft = Kawa-UsedKawa,
                MlekoLeft = Mleko-UsedMleko,
                HerbataLeft = Herbata-UsedHerbata,
                KakaoLeft = Kakao-UsedKakao,

                case WodaLeft<0 of
                    false -> null;
                    true -> Id!{"brak wody", komunikat,errorLine()},timer:sleep(3000),
                        Id!{gotowe},
                        magazyn({Woda, Kawa, Mleko, Herbata, Kakao})
                end,

                case KawaLeft<0 of
                    false -> null;
                    true -> Id!{"brak kawusi", komunikat,errorLine()},timer:sleep(3000),
                        Id!{gotowe},
                        magazyn({Woda, Kawa, Mleko, Herbata, Kakao})
                end,

                case MlekoLeft<0 of
                    false -> null;
                    true -> Id!{"brak mleczka", komunikat,errorLine()},timer:sleep(3000),
                        Id!{gotowe},
                        magazyn({Woda, Kawa, Mleko, Herbata, Kakao})
                end,

                case HerbataLeft<0 of
                    false -> null;
                    true -> Id!{"brak hierbaty", komunikat,errorLine()},timer:sleep(3000),
                        Id!{gotowe},
                        magazyn({Woda, Kawa, Mleko, Herbata, Kakao})
                end,

                case KakaoLeft<0 of
                    false -> null;
                    true -> Id!{"brak kakalka", komunikat,errorLine()},timer:sleep(3000),
                        Id!{gotowe},
                        magazyn({Woda, Kawa, Mleko, Herbata, Kakao})
                end,

                %Id!{printProgressBarCentralna},
                %Id!{"Kawa zrobiona, dziekujemy i zapraszamy ponownie!", komunikat,komunikatLine()},
                Id!{{WodaLeft, KawaLeft, MlekoLeft, HerbataLeft, KakaoLeft},komunikat,stanProduktowLine()},
                timer:sleep(100),
                Id!{magazynMaZasoby,NumerNapoju},
                magazyn({WodaLeft, KawaLeft, MlekoLeft, HerbataLeft, KakaoLeft})
    end.

%---Funkcja glowna---
start() ->
    MlynekId = spawn(?MODULE,mlynek,[]),
    CzajnikId = spawn(?MODULE,czajnik,[]),
    BaristaId = spawn(?MODULE,barista,[CzajnikId,MlynekId]),
    MonitorId = spawn(?MODULE, monitor, []),
    MagazynId = spawn(?MODULE, magazyn, [getInitialMachineResources()]),
    JCid = spawn(?MODULE, jednostkaCentralna, [MonitorId, MagazynId, BaristaId]),
    JCid!{init}.

%---Pozostale funkcje---
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
