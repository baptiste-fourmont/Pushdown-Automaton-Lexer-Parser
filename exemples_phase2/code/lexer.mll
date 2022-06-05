{
  open Parser
  exception SyntaxError of string
}


(* 1: On parse les lettres et int *)
let lettre = ['0'-'9' 'a'-'z' 'A'-'Z']

(* 2: On parse les lignes ou les blanc *)
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

rule main = parse
  | white    { main lexbuf }
  | newline  { main lexbuf }
  | "input symbols" {INPUT_SYMBOLS}
  | "stack symbols" {STACK_SYMBOLS}
  | "initial stack symbol" {INITIAL_STACK}
  | "states" {STATES}
  | "initial state" {INITIAL_STATE}
  | "program" {PROGRAM}
  | "case" {CASE}
  | "state" {STATE}
  | "next" {NEXT}
  | "pop" {POP}
  | "push" {PUSH}
  | "change" {CHANGE}
  | "reject" {REJECT}
  | "top" {TOP}
  | "of" {OF}
  | "begin" {BEGIN}
  | "end" {END}
  | ':'			{ COLON }
  | ',' {COMMA}
  | lettre as c {LETTRE(c)}
  | _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof         { EOF }