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
  | "states" {STATES}
  | "initial state" {INITIAL_STATE}
  | "initial stack" {INITIAL_STACK}
  | "transitions" {TRANSTIONS}
  | '('		{ LPAREN }
  | ')'		{ RPAREN }
  | ','			{ COMMA }
  | ';'			{ SEMICOLON }
  | ':' {COLON}
  | lettre as c {LETTRE (c)}
  | _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof         { EOF }