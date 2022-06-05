open Parser
open Lexer
open Ast

let () = 
  let _ =
    if Array.length Sys.argv < 3 then
      (Printf.printf "Usage: mainlex <file> <word>\n";
       exit 0) in

  (* Parse file to an automate *)
  let file = open_in (Sys.argv.(1)) in
  let words = (Sys.argv.(2)) in 
  let explode s = List.init (String.length s) (String.get s) in 
  let lb = Lexing.from_channel file in 
  try
    let ast = Parser.input Lexer.main lb 
    in Printf.printf "Parsing return an automate\n";
    Printf.printf "Parse:\n%s\n" (Ast.as_string ast);
    Ast.check_automate ast;
    if Execute.execute_automate ast (explode words) == [] then 
      Printf.printf "Fin de l'exécution";
  with Parsing.Parse_error ->
    Printf.printf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lb)
