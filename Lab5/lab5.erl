-module(helloworld).
-compile([export_all]).


empty() -> {node, 'nil'}.

insert(Val, {node, 'nil'}) ->
    {node, {Val, {node, 'nil'}, {node, 'nil'}}};
    
insert(NewVal, {node, {Val, Smaller, Larger}}) when NewVal < Val ->
    {node, {Val, insert(NewVal, Smaller), Larger}};
    
insert(NewVal, {node, {Val, Smaller, Larger}}) when NewVal > Val ->
    {node, {Val, Smaller, insert(NewVal, Larger)}};
%Brak powtorzen elementu
insert(Val, {node, {_, Smaller, Larger}}) ->
    {node, {Val, Smaller, Larger}}.

lookup(_, {node, 'nil'}) ->
    undefined;
lookup(Val, {node, {Val, _, _}}) ->
    {ok, Val};
lookup(X,{node, {Val, Smaller, _}}) when X < Val ->
    lookup(X, Smaller);
lookup(X, {node, { _, _, Larger}}) ->
    lookup(X, Larger).

%------------------------------------

treeFromList([]) -> empty();
treeFromList(List) ->
    Last = lists:last(List),
    Tree = treeFromList(lists:sublist(List,length(List)-1)),
    insert(Last,Tree).


generateRandomTree(Low,Max,N) ->
    {A1,A2,A3} = now(), 
    random:seed(A1, A2, A3),
    W = [random:uniform(Max-Low)+Low || _ <- lists:seq(1,N)],
    %io:fwrite("Lista: ~w\n",[W]),
    treeFromList(W).
    
treeToListLVR({node,'nil'}) -> [];
treeToListLVR({node,{Val,Smaller,Larger}}) -> treeToListLVR(Smaller)++[Val]++treeToListLVR(Larger).

treeToListVLR({node,'nil'}) -> [];
treeToListVLR({node,{Val,Smaller,Larger}}) -> [Val]++treeToListVLR(Smaller)++treeToListVLR(Larger).

treeToListVRL({node,'nil'}) -> [];
treeToListVRL({node,{Val,Smaller,Larger}}) -> [Val]++treeToListVRL(Larger)++treeToListVRL(Smaller).

searchTree(X,{node,'nil'}) -> {no,X};
searchTree(X,{node,{X,_,_}}) -> {ok,X};
searchTree(X,{node,{V,L,_}}) when X<V -> searchTree(X,L);
searchTree(X,{node,{_,_,R}}) -> searchTree(X,R).


start() ->
    random:seed(1,2,3),
    B = generateRandomTree(3,10,5),
    io:fwrite("Hello, world!\n"),
    io:fwrite("~w\n",[B]),
    io:fwrite("~w\n",[treeToListLVR(B)]),
    io:fwrite("~w\n",[treeToListVLR(B)]),
    io:fwrite("~w\n",[treeToListVRL(B)]),
    io:fwrite("~w",[searchTree(5,B)]).
    
    