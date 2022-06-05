exception UnboundVariable of char
exception NotDeterministe of string
exception MalForme of string
exception ErrorExecution of string

type initialstate = char
type initialstack = char
type suitelettresnonvide = char list
type inputsymbols = char list
type stacksymbols = char list
type initialsymbols = char list
type states = char list
type lettreouvide = char option
type nonemptystack = char list
type stack = char list option
type transition = char * char option * char * char * char list
type translist = transition list
type transitions = translist
type declarations = inputsymbols * stacksymbols * states * initialstate * initialstack
type automate = declarations * transitions
type word = char list
type execution = char * stack * char list

let extract_x x =
  match x with
  | Some x -> x
  | None -> failwith "extract_x: expected Some"

let rec last = function
  | x::[] -> x
  | _::xs -> last xs
  | []    -> failwith "no element"

let drop l n =
  let rec aux acc count = function
    | [] -> acc
    | head :: tail -> if count = 0
        then aux acc (n-1) tail
        else aux (head :: acc) (count-1) tail in
  List.rev (aux [] (n-1) l)