%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                               COL 765: Assignment-5 Evaluation Script                               %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%                               Author- Prateek Gupta                                                 %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This following code is for merge sort

split([],[],[]).
split([X],[X],[]).
split([X1,X2|T],[X1|T1], [X2|T2]):-split(T,T1,T2).

merge([],[],[]).
merge(L,[],L).
merge([],L,L).
merge([(X,Y,Z)|A],[(P,Q,R)|B],[(X,Y,Z)|L]):-Z=<R,merge(A,[(P,Q,R)|B],L).
merge([(X,Y,Z)|A],[(P,Q,R)|B],[(P,Q,R)|L]):-Z>R,merge([(X,Y,Z)|A],B,L).

mergesort([],[]).
mergesort([X],[X]).
mergesort([X,Y|T],L):-split([X,Y|T],L1,L2),mergesort(L1,S1),mergesort(L2,S2),merge(S1,S2,L).

%Code for evaluating the list by recursively calling the evaluate_list function on the 
%sorted list and checking if the adjacent elements of the list are neighbours in the rikudo grid.


evaluate_list([(_,_,_)]).
evaluate_list([(AA,BB,C),(PP,QQ,R)|T]):-A is AA, B is BB, P is PP, Q is QQ,(((P is A-2, Q is B);
                                             (P is A+2, Q is B);
                                             (P is A-1, Q is B+1);
                                             (P is A+1, Q is B+1);
                                             (P is A-1, Q is B-1);
                                             (P is A+1, Q is B-1))
                                             ->(R is C+1
                                             ->evaluate_list([(P,Q,R)|T]))).

%This code chunks checks the preservation of the links and prefilled entries in the rikudo grid.

checkLinks([],_,_).
checkLinks([(P,Q,R,S)|T1],[(A,B,_),(C,D,_)|T2],L):-((P==A,Q==B,R==C,S==D);(P == C , Q == D, R == A, S == B)
                                                ->checkLinks(T1,L,L)
                                                ;checkLinks([(P,Q,R,S)|T1],[(C,D,_)|T2],L)).


checkPrefilled([],_).
checkPrefilled([(A,B,C)|T1],[(P,Q,R)|T2]):-(C>=R
                                            ->(C==R
                                               ->(A == P, B == Q
                                                  ->checkPrefilled(T1,T2)
                                                 );
                                               checkPrefilled([(A,B,C)|T1],T2)
                                               )
                                            ).


%Calling function to evaluate a  particular result.
evaluate(Result,Prefilled,Links):-mergesort(Result,[H|List1]),write("Sorted Result"),nl,H == (0,0,-10),mergesort(Prefilled,List2),write("Sorted Prefilled"),nl,checkLinks(Links,List1,List1),write("Checked links"),nl,checkPrefilled(List2,List1),write("Checked prefilled"),nl,evaluate_list(List1),write("Evaluated"),nl.

%Running the test cases.
run_tests([]).
run_tests([(N,Size,Prefilled,Links)|T]):- (rikudo(Size,Prefilled,Links,Result),write(Result),nl,evaluate(Result,Prefilled,Links)
                                           ->write("TC: "),write(N),nl,run_tests(T)
                                           ;write("TC: Fail "),write(N),nl,run_tests(T)).
%The following code is written for reading testcases from the file and running the testcases on given file.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

main(Filename) :-
    consult(Filename),
    open('testcases.txt', read, Str),
    write(Filename),nl,
    read_file(Str,Lines),
    run_tests(Lines),
    write(Filename),write(" Evaluated"),nl,
    close(Str).
    %catch(call_with_time_limit(2400,(run_tests(Lines),
                                    %write(Filename),write(" Evaluated"),nl,
                                    %close(Str))),time_limit_exceeded,writeln('overslept!')).
    
