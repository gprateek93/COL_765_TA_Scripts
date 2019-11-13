use "signatureFLX.sml";
use "structureFLX.sml";

open Flx;

(* Sample terms *)
val t1 = VAR "abc";
val t2 = Z;
val t3 = F;
val t4 = ITE (t3,t1,t2);

val t5 = fromInt 4;
val t6 = fromInt ~3;

val t7 = P (S Z);
val t8 = S (P Z);

val results_sample = [];
(* Test cases for fromInt and toInt *)
val resultint = (case (toInt t5) of 			(* .5 *)
                        4 => (1)
                        | _ => (0))
                        handle _ => (0);
val results_sample = results_sample @ [resultint];

val resultint = (case (toInt t6) of 			(* .5 *)
                        ~3 => (1)
                        | _ => (0))
                        handle _ => (0);
val results_sample = results_sample @ [resultint];

val resultInt = (case (toInt t4) of 			(* .5 *)
                        _ => (0))
                        handle Not_int => (1)
                        handle _ => (0);
val results_sample = results_sample @ [resultint];

val resultInt =  (case (toInt (S (S (Z)))) of 	(* .5 *)
                        2 => (1)
                        | _ => (0))
                        handle _ => (0);
val results_sample = results_sample @ [resultint];

(* Test cases for fromString *)
val resultstring = (case (fromString "a") of 	(* .5 *)
                        (VAR "a") => (1)
                        | _ => (0))
                        handle Not_wellformed => (0);
val results_sample = results_sample @ [resultstring];

val resultstring = (case (fromString "abcd efgh") of 	(* .5 *)
                        _ => (0))
                        handle Not_wellformed  => (1);
val results_sample = results_sample @ [resultstring];

val resultstring = (case (fromString "(ITE <F,abc,Z>)") of 	(* .5 *)
                        ITE (F, VAR("abc"), Z) => (1)
                        | _ => (0))
                        handle Not_wellformed => (0);
val results_sample = results_sample @ [resultstring];

val resultstring = (case (fromString "(S (S Z))") of 	(* .5 *)
                        S (S (Z)) => (1)
                        | _ => (0))
                        handle Not_wellformed => (0);
val results_sample = results_sample @ [resultstring];

(* Test cases for toString *)
(* Make sure to properly parenthesize the constructor applications and use 
angular brackets for ITE in your output string *)
(* Do not print VAR for variable names in the output string *)
val resultstring = (case (toString t1) of 				(* .5 *)
                        "abc" => (1)
                        | _ => (0));
val results_sample = results_sample @ [resultstring];

val resultstring = (case (toString t2) of 				(* .5 *)
                        "Z" => (1)
                        | _ => (0));
val results_sample = results_sample @ [resultstring];

val resultstring = (case (toString t4) of 				(* .5 *)
                        "(ITE <F,abc,Z>)" => (1)
                        | _ => (0));
val results_sample = results_sample @ [resultstring];

(* Test cases for normalize *)							(* .5 *)
val resultnorm = (case (normalize t7) of 
                Z => (1)
                | _ => (0));
val results_sample = results_sample @ [resultnorm];



(* Private Testcases *)
val results = [];
val resultnorm = (case (normalize (GTZ t8)) of 	(* 1 *)
                F => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (normalize (GTZ t7)) of 	(* 1 *)
                F => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (normalize (GTZ (fromInt ~5))) of 	(* 1 *)
                F => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (normalize (GTZ (fromInt 5))) of 	(* 1 *)
                T => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (toInt t8) of 				(* 1 *)
                _ => (0))
				handle Not_nf => (1)
				handle _ => (0);
val results = results @ [resultnorm];

val resultnorm = (case (toInt (t7)) of 				(* 1 *)
                 _ => (0))
				handle Not_nf => (1)
				handle _ => (0);
val results = results @ [resultnorm];

val resultnorm = (case (normalize (IZ (t8))) of 				(* 1 *)
                T => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (normalize (IZ (t7))) of 				(* 1 *)
                T => (1)
                | _ => (0));
val results = results @ [resultnorm];

val temp1 = (fromInt ~1);
val temp2 = (S t1);
val t9 = (ITE (GTZ (P (S (P Z))), (S temp1), (P temp2)));
val resultstring = (case (fromString "(ITE <(IZ (S Z)),(S (P Z)),(P (S Z))>)") of 	(* 1 *)
				ITE (IZ (S Z), (S (P Z)), (P (S Z))) => (1)
                | _ => (0))
				handle Not_wellformed => (0);
val results = results @ [resultstring];

val resultnorm = (case (normalize t9) of  (* 3 *)
                VAR "abc" => (1)
                | P (S (VAR "abc")) => (1)
                | _ => (0));
val results = results @ [resultnorm];

val resultnorm = (case (normalize (ITE (t1, T, T))) of  (* 2 *)
                (ITE (t1, T, T)) => (1)
                | T => (1) 
                | _ => (0));
val results = results @ [resultnorm];

(* Printing the computed testcase results *)
fun printList xs = print(String.concatWith ", " (map Int.toString xs));
fun prettyPrintList tag l = (
	print tag;
	print ": [";
	printList l;
	print "]\t");

prettyPrintList "sample" results_sample;
prettyPrintList "result" results;

OS.Process.exit(OS.Process.success);