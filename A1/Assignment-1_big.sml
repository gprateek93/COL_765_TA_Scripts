use "assignment.sml"; (*Use the assignment file of the student*)

(*Take input from the files*)
(* val infile_karat = "Test_Cases_karat.txt" ; *)
val infile_fact = "BIg_Test_Cases.txt";
val outfile_fact = "output_big_test_cases.txt";
(* val outfile_karat = "output_karat.txt"; *)

(*Reads the text input from the file*)
fun readlist (infile : string) = let
  val ins = TextIO.openIn infile
  fun loop ins =
   case TextIO.inputLine ins of
      SOME line => line :: loop ins
    | NONE      => []
in
  loop ins before TextIO.closeIn ins
end ;

(* val list_karat = readlist(infile_karat); *)
val list_fact = readlist(infile_fact);
(* val list_output_karat = readlist(outfile_karat); *)
val list_output_fact = readlist(outfile_fact);

(*function to remove \n from the end of the string as our function extracts words as "abc\n"*)
fun remCharR (c, s) =
    let fun rem [] = []
          | rem (c'::cs) =
              if c = c'
              then rem cs
              else c'::rem cs
    in implode (rem (explode s)) end

(*final functions*)

fun process_karat(y::z::xs:string list) = toString(karatsuba (fromString(remCharR(#"\n",y))) (fromString(remCharR(#"\n",z))))::process_karat(xs)
    |process_karat [] = [];

fun process_fact(y::xs:string list) = factorial(remCharR(#"\n",y))::process_fact(xs)
    |process_fact [] = [];

fun remove([]) = []
    |remove(x::xs:string list) = remCharR(#"\n",x) :: remove(xs);
(*Evaluate*)

(* val ans_karat = process_karat(list_karat); *)
val ans_fact = process_fact(list_fact);

fun equalUtil(x:string, y:string, n:int, c:string) = if x=y then print(c^Int.toString(n)^" ")
                                            else print("false ");
fun equal(x::[]:string list,y::ys :string list,n:int,c:string) = equalUtil(x,y,n,c)
    | equal(x::xs:string list,y::ys :string list,n:int,c:string) = (equalUtil(x,y,n,c);equal(xs,ys,n+1,c));

val list_output_fact = remove(list_output_fact);
(* val list_output_karat = remove(list_output_karat); *)
(* val eval_karat = equal(ans_karat,list_output_karat,1,"K"); *)
val eval_fact = equal(ans_fact,list_output_fact,1,"F");

(*Evaluate exceptions*)
(* 
val fact_exception = "-67";
factorial(fact_exception)
  handle Invalid_Input_exception(a) => ("true");

val karat_exception1 = ["-56784","9876543210"];
val karat_exception2 = ["75745","64733d847"];
val karat_exception3 = ["7856874395786782742353427538437587622735-6566","5466773"];
 
fun karat_exception(x::y::xs: string list) = toString (karatsuba (fromString(x)) (fromString(y))); 
     
karat_exception(karat_exception1)
  handle Invalid_Input_exception(a) => ("KE1");
karat_exception(karat_exception2)
  handle Invalid_Input_exception(a) => ("KE2");
karat_exception(karat_exception3)
  handle Invalid_Input_exception(a) => ("KE3"); 
 *)

OS.Process.exit(OS.Process.success);