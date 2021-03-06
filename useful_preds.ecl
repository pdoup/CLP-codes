:-lib(ic).
:-lib(ic_edge_finder).
:-lib(branch_and_bound).

%%% Some useful predicates with lists and more - 11.6.21 

%% Rotate Left 
%% rleft/3
%% [1,2,3,4] -> 2 --> [3,4,1,2]

rleft(N,L,Res):-
	length(L, NL),
	mod(N,NL,NN),
	append(L1,L2,L),
	length(L1,NN),
	append(L2,L1,Res), !.

%% Test member
%% mem/2

mem(X,[X|_]):-!.
mem(X,[_|T]):- mem(X,T).

%% Find Sublist
%% sublist/3

sublist(SList, List):-
	append(_L1,SList,List),!.

sublist(SList, List):-
	append(SList,_L1,List),!.

sublist(SList, [_|List]):-
	sublist(SList,List).

%% List of items are ALL members
%% i.e. [1,2,4] members of [1,2,3,4,5,6]

sublist_mem(El, List):-
	findall(X, (member(X,El),member(X,List)), El).

%% Delete All X from List
%% delete_all/3

delete_all(Y, L1, L):-
	findall(X, (member(X, L1), X \== Y), L).


%% Delete All X from List (Alt.)
%% delete_all_2/3

delete_all_2(_,[],[]).
delete_all_2(X,[H|T],[H|L]) :-
	X\==H,!,
	delete_all_2(X,T,L).
	
delete_all_2(X,[_|T],L) :-
	delete_all_2(X,T,L).

%% Delete One 
delete_one(X, [X|T], T):-!.
delete_one(X, [H|T], [H|Res]):-
	delete_one(X,T,Res).

%% Range of numbers in [Low,High] one-by-one w/ backtracking 
int_in_range(Low,High,Low).
int_in_range(Low,High,Res):-
	NewLow is Low + 1,
	NewLow =< High,
	int_in_range(NewLow,High,Res).


%% Fibonacci sequence
fib(1,1).
fib(2,1).
fib(N,X):-
	N>2,
	NN is N-1,
	fib(NN, X1),
	NNN is N-2,
	fib(NNN,X2),
	X is X1+X2.


%% Replace element X of a List with element Y
%% Backtrack to replace all instances one-by-one
%% E.g ?- replace(1,a,[1,2,1,1,3],R).
%%
%%        R = [a, 2, 1, 1, 3] ;
%%        R = [1, 2, a, 1, 3] ;
%%        R = [1, 2, 1, a, 3] ;
       
replace(X,Y,[X|R],[Y|R]).
replace(X,Y,[H1|R1],[H1|R2]):-
	replace(X,Y,R1,R2).

%% Replace all X with Y in a list, return new list.
replace_all(_,_,[],[]).
replace_all(X,Y,[X|R1],[Y|R2]):-
	!,
	replace_all(X,Y,R1,R2).

replace_all(X,Y,[H1|R1],[H1|R2]):-
	replace_all(X,Y,R1,R2).

%% count odd numbers in a list
count_odd([],0).
count_odd([H|T], Res) :-
	1 is H mod 2,!,
	count_odd(T,Rest),
	Res is Rest+1.

count_odd([_|T], Res) :-
	count_odd(T,Res).

%% check if a list is symmetric e.g. [1,2,3,1,2,3]
symmetric(L):-
	append(L1,L1,L).

%% check if L1 is at the end of L2
end_sublist(L1,L2):-
	append(L,L1,L2).

%% Check if L1 is present 2 times in L2
twice_sublist(L1,L2):-
	append(X,Y,L2),
	sublist(L1,X),
	sublist(L1,Y).

%% Get the last element of list L
last_element(L,X):-
	append(_,L1,L),
	length(L1,1),
	[X] = L1. 

%% Find 1 missing letter from misspelled word
word([p,r,o,l,o,g]).
word([m,a,t,h,s]).

missing_letter(L,X,W):-
	word(W),
	append(L1,L2,L),
	append(L1,[X|L2],W).

%% Reverse list using append/3
reverse_alt([],[]).
reverse_alt([H|L1],L2):-
	reverse_alt(L1,R),
	append(R, [H], L2).
	
%% Reverse list
reverse2(List, Rev) :-
    reverse2(List, Rev, []).

reverse2([], L, L).
reverse2([H|T], L, SoFar) :-
    reverse2(T, L, [H|SoFar]).

%% Check if X is present only once in the List
unique_el(X,L):-
	member(X,L),
	delete(X,L,LL),
	not(member(X,LL)).


%% Concatenate 2 Lists
concat([],L,L).
concat([H|L1],L2,[H|L]):-
	concat(L1,L2,L).

%% Difference of 2 Lists
%% diff/3

diff(L1,L2,Diff):-
	findall(X, (member(X,L1),not(member(X,L2))), Diff).


%% diff_2/3
diff_2([],_,[]).
diff_2([H|L1],L2,[H|L]):-
	not(member(H,L2)),!,
	diff_2(L1,L2,L).

diff_2([_|L1],L2,L):-
	diff_2(L1,L2,L).


%% Intersection of 2 Lists
%% intersect/3
intersect(L1,L2,L):-
	findall(X, (member(X,L1),member(X,L2)), L).

%% intersect_2/3
intersect_2([],_,[]).
intersect_2([G1|L1],L2,[G1|L]):-
	member(G1,L2),!,
	intersect_2(L1,L2,L).

intersect_2([_|L1],L2,L):-	
	intersect_2(L1,L2,L).
	
%% Union of 2 Lists
%% union_1/3

union_1(L1,L2,L):-
	setof(X,(member(X,L1);member(X,L2)),L).


%% union_2/3 (Alt.)
union_2([],L,L).
union_2([H|L1],L2,L):-
	member(H,L2),!,
	union_2(L1,L2,L).
	
union_2([H|L1],L2,[H|L]):-
	union_2(L1,L2,L).


%% Function result that takes 2 args.
%% func/3

root(X,N):- N is X^(1/2).
square(X,N):- N is X*X.

func(F, X1, Res):-
	C =.. [F,X1,Res],
	C.

%% Map each item in List to a function w/ 1 input
map(_,[],[]).
map(Op, [H|List], [R|L]):-
	C =.. [Op, H, R],
	C,
	map(Op,List,L).
	
%% Reduce List to a single number by applying Operator Op to its items
reduce(_,[X],X).	
reduce(Op,[X,Y|List],Res):-
	member(Op,[max,min,plus,times]),
	C =.. [Op,X,Y,Z],
	C,
	reduce(Op, [Z|List], Res).

%% Arithmetic sequence of numbers - checks missing in between and adds them
%% E.g [1,2,5,7] --> [1,2,3,4,5,6,7]

series([],[]).
series([H1,H2|T], [H1|L]):-
	Diff is H2 - H1, 
	Diff > 1,
	!,
	More is H1 + 1,
	series([More,H2|T],L).

series([H|T],[H|L]):-
	series(T,L).

%% Find path in graphs from node S(Start) --> F(Finish)
%% example goto/3 (from,to,cost)
goto(a,b,4).
goto(a,c,2).
goto(c,a,5).
goto(b,d,7).
goto(d,c,10).
goto(d,e,1).

dfs(From,To,Cost,Route):-
	dfs(From,To,[From],Cost,Route).

dfs(From, To, [From|Visited], Cost, [From,To]):-
	goto(From,To,Cost),
	not(member(To, Visited)).

dfs(From,To,Visited,Cost,[From|Route]):-
	goto(From, Temp, TCost),
	not(member(Temp,Visited)),
	dfs(Temp, To, [Temp|Visited], ACost, Route),
	Cost is TCost + ACost.

%% CLP Constraints - Scheduling

%% N Trucks cross bridge w/ 20 tn. max load - goal -> minimize time to go across.

car(alpha, 10, 4).
car(beta, 13,5).
car(gamma, 8, 3).
car(delta, 5, 4).
car(ephilon, 7, 1).
car(zita, 9, 3).
car(eta, 11, 6).

cross_bridge(Trucks, Starts, MinTime):-
	findall(T, car(T,_,_), Trucks),
	
	length(Trucks, N),
	length(Starts, N),
	
	Starts #:: 0..inf,
	
	apply_const_trucks(Trucks,Speeds,Starts,Weights,Ends),
	
	cumulative(Starts,Speeds,Weights,20),
	
	ic_global:maxlist(Ends,MinTime),
	
	bb_min(labeling(Starts),MinTime,bb_options{strategy:restart}).
	
apply_const_trucks([],[],[],[],[]).
apply_const_trucks([T|Trucks],[Speed|Speeds],[S|Starts],[W|Weights],[E|Ends]):-
	car(T,W,Speed),
	S + Speed #= E,
	apply_const_trucks(Trucks, Speeds, Starts, Weights, Ends).


%% 100 licences, 6 profs., lectures from 9-21, minimize end time

class(clp,3,40,3).
class(procedural,3,60,2).
class(analysis,4,50,2).
class(computer_sys,4,40,3).
class(algebra,3,40,4).
class(hpc,3,10,1).

lectures(Lectures, Starts, Makespan):-
	findall(Lect, class(Lect,_,_,_), Lectures),
	
	length(Lectures, N),
	length(Starts, N),
	
	Starts #:: 9..21,
	
	apply_const(Starts,Durations,Licences,Teachers,Ends,Lectures),
	
	cumulative(Starts,Durations,Teachers,6),
	cumulative(Starts,Durations,Licences,100),
	
	ic_global:maxlist(Ends,Makespan),
	
	bb_min(labeling(Starts),Makespan,bb_options{strategy:restart}).
	
	
apply_const([],[],[],[],[],[]).
apply_const([S|Starts],[Dur|Durs],[Lic|Lics],[Tch|Tchs],[End|Ends],[Lect|Lectures]):-
	class(Lect, Dur, Lic, Tch),
	S + Dur #= End,
	End #=< 21,
	apply_const(Starts,Durs,Lics,Tchs,Ends,Lectures).
	

%% IC Sets
nums([2, 4, 5, 11, 14, 17, 18, 21, 55, 67, 89, 98]).

split_nums(N, S):-
	nums(X),
	
	length(X,NN),
	intsets(S,N,1,NN),
	
	Array =.. [a|X],
	
	split_nums_const(S,Array,Card),
	Card #= NN,
	
	all_disjoint(S),
	
	labelingSets(S).
	
labelingSets([]).
labelingSets([S|Rest]):-
	insetdomain(S,increasing,_,_),
	labelingSets(Rest).
	

split_nums_const([],_,0).	
split_nums_const([S|RestS],Array,Cards):-
	#(S, C), C#>=2,
	weight(S,Array,SumW),
	SumW #> 20,
	split_nums_const(RestS,Array,RCards),
	Cards #= C + RCards.
