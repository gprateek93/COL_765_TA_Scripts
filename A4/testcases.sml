use "structureLAMBDAFLX.sml";

open LambdaFlx;

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

(* Test case 1,2                            1+1 *)
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
(* (((\x [\y [(x y)]] \y(f y)) a) b) ==> ((f b) a) *)
val t3 = APP (xyappxy, appfy)
val t4 = APP (t3, a)
val t5 = APP (t4, b)
val res4 = (case (betanf t5) of
                APP (APP (VAR "f", VAR "b"), VAR "a") => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res4]

(* Test case 5								1 *)
(* (\x [\y [(x ITE(y, T, F))]] \y[(S y)])  is well typed*)
val t6 = LAMBDA (x, LAMBDA (y, APP (x, ITE (y, T, F))))
val t7 = LAMBDA (y, (S y))
val t8 = APP (t6, t7)
val res5 = (case (isWellTyped t8) of
                true => 1
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
val res7 = (case (betanf t10) of
                LAMBDA (VAR "x", LAMBDA (VAR "y", (P (VAR "y")))) => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res7]

(* Test case 8								1 *)
(* (\x [\y [ITE (x, Py, Sy)]]  T) ==> \y [Py] *)
val t11 = APP (t9, T)
val res8 = (case (betanf t11) of
                LAMBDA (VAR "y", (P (VAR "y"))) => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res8]

(* Test case 9								1 *)
(* ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> Z *)
val t12 = APP (t11, (S Z))
val res9 = (case (betanf t12) of
                Z => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res9]

(* Test case 10								1 *)
(* GTZ ((\x [\y [ITE (x, Py, Sy)]]  T) SSZ) ==> T *)
val t13 = APP (t11, (fromInt 2))
val t14 = GTZ (t13)
val res10 = (case (betanf t14) of
                T => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res10]

(* Test case 11								1 *)
(* GTZ ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> F *)
val t15 = GTZ (t12)
val res11 = (case (betanf t15) of
                F => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res11]

(* Test case 12								1 *)
(* IZ ((\x [\y [ITE (x, Py, Sy)]]  T) SSZ) ==> F *)
val t16 = IZ (t13)
val res12 = (case (betanf t16) of
                F => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res12]

(* Test case 13 							1 *)
(* IZ ((\x [\y [ITE (x, Py, Sy)]]  T) SZ) ==> T *)
val t16 = IZ (t12)
val res13 = (case (betanf t16) of
                T => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res13]

(* Test case 14								1 *)
(* (\x [IZ(x)]  (\y [Sy]  Z)) ==> F *)
val t17 = APP (LAMBDA (x, (IZ x)),  APP (LAMBDA (y, (S y)), Z))
val res14 = (case (betanf t17) of
                F => 1
                | _ => 0)
                handle _ => 0
val results = results @ [res14]


