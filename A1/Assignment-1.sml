use "assignment.sml";(*Use the assignment file of the student*)

(*Take input from the files*)
val infile_karat = "Test_Cases_karat.txt" ;
val infile_fact = "Test_Cases_fact.txt"

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

val list_karat = readlist(infile_karat);
val list_fact = readlist(infile_fact)

(*function to remove \n from the end of the string as our function extracts words as "abc\n"*)
fun remCharR (c, s) =
    let fun rem [] = []
          | rem (c'::cs) =
              if c = c'
              then rem cs
              else c'::rem cs
    in implode (rem (explode s)) end

(*final functions*)
fun process_karat(y::z::xs:string list) = toString(karatsuba(fromString(remCharR(#"\n",y)),fromString(remCharR(#"\n",z))))::process_karat(xs)
    |process_karat [] = [];

fun process_fact(y::xs:string list) = toString(factorial(fromString(remCharR(#"\n",y))))
    |process_fact [] = [];
