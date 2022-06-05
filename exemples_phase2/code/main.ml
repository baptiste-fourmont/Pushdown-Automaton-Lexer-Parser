open Parser
open Lexer
open Ast

let () = 
  let _ =
    if Array.length Sys.argv < 3 then
      (Printf.printf "Usage: mainlex <file>\n";
       exit 0) in

  (* Parse file to an automate *)
  let words = (Sys.argv.(2)) in 
  let explode s = List.init (String.length s) (String.get s) in 
  let file = open_in (Sys.argv.(1)) in
  let lb = Lexing.from_channel file in 
  try
    let ast = Parser.input Lexer.main lb 
    in Printf.printf "Parsing return an automate\n";
    Ast.check_automate ast (explode words)
  with Parsing.Parse_error ->
    Printf.printf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lb)
