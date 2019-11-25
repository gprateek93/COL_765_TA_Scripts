%consult("file.pl").

split([],[],[]).
split([X],[X],[]).
split([X1,X2|T],[X1|T1], [X2|T2]):-split(T,T1,T2).

merge([(P,Q,R)],[],[(P,Q,R)]).
merge([],[(P,Q,R)],[(P,Q,R)]).
merge([(X,Y,Z)|A],[(P,Q,R)|B],[(X,Y,Z)|L]):-Z=<R,merge(A,[(P,Q,R)|B],L).
merge([(X,Y,Z)|A],[(P,Q,R)|B],[(P,Q,R)|L]):-Z>R,merge([(X,Y,Z)|A],B,L).

mergesort([],[]).
mergesort([X],[X]).
mergesort([X,Y|T],L):-split([X,Y|T],L1,L2),mergesort(L1,S1),mergesort(L2,S2),merge(S1,S2,L).


evaluate_list([(_,_,_)]).
evaluate_list([(A,B,C),(P,Q,R)|T]):-(((P is A-2, Q is B);
                                             (P is A+2, Q is B);
                                             (P is A-1, Q is B+1);
                                             (P is A+1, Q is B+1);
                                             (P is A-1, Q is B-1);
                                             (P is A+1, Q is B-1))
                                             ->(R is C+1
                                             ->evaluate_list([(P,Q,R)|T]))).


checkLinks([(P,Q,R,S|T1)],[(A,B,_),(C,D,_)|T2]):-((P==A,Q==B,R==C,S==D)
                                                ->checkLinks(T1,[(C,D,_)|T2])
                                                ;checkLinks([(P,Q,R,S)|T1],[(C,D,_)|T2])).

checkPrefilled([(A,B,C)|T1],[(P,Q,R)|T2]):-(C>=R
                                            ->(C==R
                                               ->(A == P, B == Q
                                                  ->checkPrefilled(T1,T2)
                                                 );
                                               checkPrefilled([(A,B,C)|T1],T2)
                                               )
                                            ).


evaluate(Result,Prefilled,Links):-mergesort(Result,[H|List1]),H == (0,0,-10),mergesort(Prefilled,List2),checkLinks(Links,List1),checkPrefilled(List2,List1),evaluate_list(List1).