use "signatureFLX.sml";
use "signatureLAMBDAFLX.sml";
use "structureLAMBDAFLX.sml";

open LambdaFlx;

local fun findstr ([] , str, i) = ~1
        | findstr (x::xs, str, i) = 
            if x = str then i
            else findstr (xs, str, i+1)
in fun search (ls, str) = findstr (ls, str, 0)
end

fun checkvar (s1, s2, lkeys, lvals) = 
	let val i = search (lkeys, s1)
	in
		if i = ~1 then 
			(true, s1::lkeys, s2::lvals)
		else (s2=List.nth(lvals, i), lkeys, lvals) 
	end

local fun isequal T T lkeys lvals = (true, lkeys, lvals)
		| isequal F F lkeys lvals = (true, lkeys, lvals)
		| isequal Z Z lkeys lvals = (true, lkeys, lvals)
		| isequal (P t1) (P t2) lkeys lvals = (isequal t1 t2 lkeys lvals)
		| isequal (S t1) (S t2) lkeys lvals = (isequal t1 t2 lkeys lvals)
		| isequal (IZ t1) (IZ t2) lkeys lvals = (isequal t1 t2 lkeys lvals)
		| isequal (GTZ t1) (GTZ t2) lkeys lvals = (isequal t1 t2 lkeys lvals)
		| isequal (ITE (t1, t11, t10)) (ITE (t2, t21, t20)) lkeys lvals = 
				let val ans1 = (isequal t1 t2 lkeys lvals)
					val ans2 = (isequal t11 t21 (#2 ans1) (#3 ans1))
					val ans3 = (isequal t10 t20 (#2 ans2) (#3 ans2))
				in
					((#1 ans1) andalso (#1 ans2) andalso (#1 ans3), (#2 ans3), (#3 ans3))
				end
		| isequal (LAMBDA (t11, t12)) (LAMBDA (t21, t22)) lkeys lvals = 
				let val ans1 = (isequal t11 t21 lkeys lvals)
					val ans2 = (isequal t12 t22 (#2 ans1) (#3 ans1))
				in
					((#1 ans1) andalso (#1 ans2), (#2 ans2), (#3 ans2))
				end
		| isequal (APP (t11, t12)) (APP (t21, t22)) lkeys lvals = 
				let val ans1 = (isequal t11 t21 lkeys lvals)
					val ans2 = (isequal t12 t22 (#2 ans1) (#3 ans1))
				in
					((#1 ans1) andalso (#1 ans2), (#2 ans2), (#3 ans2))
				end
		| isequal (VAR s1) (VAR s2) lkeys lvals = checkvar (s1, s2, lkeys, lvals)		
		| isequal t1 t2 lkeys lvals = (
				(print (toString t1));
				(print (toString t2));
				(false, lkeys, lvals))
in fun iseq t1 t2 = (#1 (isequal t1 t2 [] []))
end


(* Terms *)
val x = VAR "x"
val y = VAR "y"
val z = VAR "z"
val a = VAR "a"
val b = VAR "b"
val f = VAR "f"
val appxx = APP (x, x)
val appxy = APP (x, y)
val appzz = APP (z, z)
val appfy = APP (f, y)

val results = []

(* Test case 1,2                   0.5+0.5 = 1 *)
(* \ x [(x x)] is not well typed *)
val xappxx = LAMBDA (x, appxx)
val res1 = (case (isWellTyped xappxx) of 
                false => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res1]

val res2 = (case (betanf xappxx) of
                _ => 0)
                handle Not_welltyped => 1
                 | _ => 0
val results = results @ [res2]

(* Test case 3                              1 *)
(* ((\ x [\ y [(x y)]] a) a) is not well typed *)
val yappxy = LAMBDA (y, appxy)
val xyappxy = LAMBDA (x, yappxy)
val t1 = APP (xyappxy, a)
val t2 = APP (t1, a)
val res3 = (case (betanf t2) of
                _ => 0)
                handle Not_welltyped => 1
                 | _ => 0
val results = results @ [res3]

(* Test case 4                              1 *)
(* (((\x [\y [(x y)]] \y(f y)) a) b) ==> ((f a) b) *)
val t3 = APP (xyappxy, LAMBDA (y, appfy))
val t4 = APP (t3, a)
val t5 = APP (t4, b)
val res4 = (case (iseq (betanf t5) (APP (APP (VAR "f", VAR "a"), VAR "b"))) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res4]

(* Test case 5								1 *)
(* (\x [\y [(x ITE(y, T, F))]] \y[(S y)])  is well typed*)
val t6 = LAMBDA (x, LAMBDA (y, APP (x, ITE (y, T, F))))
val t7 = LAMBDA (y, (S y))
val t8 = APP (t6, t7)
val res5 = (case (isWellTyped t8) of
                false => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res5]

(* Test case 6								1 *)
(* \x [\y [ITE (x, Py, Sy)]] is well typed *)
val t9 = LAMBDA (x, LAMBDA (y, ITE (x, (P y), (S y))))
val res6 = (case (isWellTyped t9) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res6]

(* Test case 7								1 *)
(* \x [\y [ITE (x, Py, Py)]] ==> \x [\y [Py]] *)
val t10 = LAMBDA (x, LAMBDA (y, ITE (x, (P y), (P y))))
val res7 = (case (iseq (betanf t10) (LAMBDA (VAR "x", LAMBDA (VAR "y", (P (VAR "y")))))) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res7]

(* Test case 8								1 *)
(* (\x [\y [ITE (x, Py, Sy)]]  T) ==> \y [Py] *)
val t11 = APP (t9, T)
val res8 = (case (iseq (betanf t11) (LAMBDA (VAR "y", (P (VAR "y"))))) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res8]

(* Test case 9								1 *)
(* ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> Z *)
val t12 = APP (t11, (S Z))
val res9 = (case (iseq (betanf t12) Z) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res9]

(* Test case 10								1 *)
(* GTZ ((\x [\y [ITE (x, Py, Sy)]]  T) SSZ) ==> T *)
val t13 = APP (t11, (fromInt 2))
val t14 = GTZ (t13)
val res10 = (case (iseq (betanf t14) T) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res10]

(* Test case 11								1 *)
(* GTZ ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> F *)
val t15 = GTZ (t12)
val res11 = (case (iseq (betanf t15) F) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res11]

(* Test case 12								1 *)
(* IZ ((\x [\y [ITE (x, Py, Sy)]]  T) SSZ) ==> F *)
val t16 = IZ (t13)
val res12 = (case (iseq (betanf t16) F) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res12]

(* Test case 13 							1 *)
(* IZ ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> T *)
val t17 = IZ (t12)
val res13 = (case (iseq (betanf t17) T) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res13]

(* Test case 14								1 *)
(* (\x [IZ(x)]  (\y [Sy]  Z)) ==> F *)
val t18 = APP (LAMBDA (x, (IZ x)),  APP (LAMBDA (y, (S y)), Z))
val res14 = (case (iseq (betanf t18) F) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res14]

(* Test case 15                             1 *)
(* \ Px [Z] is not well formed *)
val t19 = LAMBDA ((P x), Z)
val res15 = (case (betanf t19) of
                _ => 0)
                handle Not_wellformed => 1
                    | _ => 0
val results = results @ [res15]

(* Test case 16                             1 *)
(* (Sx  ITE(F, x, F)) is not well typed *)
val t20 = APP((S x), ITE(F, x, F))
val res16 = (case (betanf t20) of
                _ => 0)
                handle Not_welltyped => 1
                    | Not_int => 1
                    | _ => 0
val results = results @ [res16]

(* Test case 17                             1 *)
(* (\x [\y [x]]  \y [Sy]) ==> \y [\z [Sz]] *)
val t21 = APP (LAMBDA(x, LAMBDA(y, x)), LAMBDA(y, (S y)))
val res17 = (case (iseq (betanf t21) (LAMBDA (y, LAMBDA (z, (S z))))) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res17]

(* Test case 18                             1 *)
(* PSPSSPZ ==> Z *)
val t22 = P(S(P(S(S(P(y))))))
val res18 = (case (iseq (betanf t22) y) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res18]

(* Test case 19                             1 *)
val t23 = LAMBDA (y, t22)
val res19 = (case (iseq (betanf t23) (LAMBDA(y, y))) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res19]

(* Test case 20                             1 *)
(* (\z \x \y [(x y)]  \y[Z]) *)
val t24 = APP((LAMBDA(z, xyappxy)), LAMBDA(y, Z))
val res20 = (case (iseq (betanf t24) xyappxy) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res20]

(* Test case 21                             1 *)
(* (\x [\y [ITE(y, SZ, PZ)]]  \y[GTZ y]) is well typed *)
val t25 = APP( (LAMBDA (x, LAMBDA (y, ITE (y, (S Z), (P Z))))), (LAMBDA (y, GTZ(y))))
val res21 = (case (isWellTyped t25) of
                true => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res21]



fun printList xs = print(String.concatWith ", " (map Int.toString xs));
fun prettyPrintList tag l = (
	print tag;
	print ": [";
	printList l;
	print "]\t");

prettyPrintList "result" results;

OS.Process.exit(OS.Process.success);
