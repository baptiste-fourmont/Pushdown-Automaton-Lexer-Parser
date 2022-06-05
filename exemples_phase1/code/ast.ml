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
type transition  = char * char option * char * char * char list
type translist = transition list
type transitions = translist
type declarations = inputsymbols * stacksymbols * states * initialstate * initialstack
type automate = declarations * transitions

type word = char list
type execution = char * stack * char list

(* UTILITY FUNCTIONS *)

let lookup g x = 
  try List.assoc x g with Not_found -> raise @@ UnboundVariable x

let chr_lst_str (l : char list) : string = match l with
  | [] -> "Empty"
  | _ -> List.fold_left (fun x y -> x ^ " " ^ String.make 1 y) "" l

let chr_opt_str (c : char option) : string = match c with
  | Some(v) -> String.make 1 v
  | None -> "None"

let compare_option ch ch2 = match ch, ch2 with 
  | None, Some(_) | Some(_), None -> false
  | None, None -> true 
  | Some(x), Some(y) -> x == y

(* PRINT FUNCTIONS *)
let trans_str (t : transition) : string = match t with
  (l1,lv,l2,l3,s) -> String.make 1 l1 ^ ", " ^ chr_opt_str lv ^ ", " ^ String.make 1 l2 ^ ", " ^ String.make 1 l3 ^ ", " ^ chr_lst_str s

let declarations_str (d: declarations) : string = match d with
    (inputsymbols, stacksymbols, states, initialstate, initialstack) ->
    "INPUT_SYMBOLS = " ^ chr_lst_str inputsymbols ^ "\n" ^
    "STACK_SUMBOLS = " ^ chr_lst_str stacksymbols ^ "\n" ^
    "STATES = " ^ chr_lst_str states ^ "\n" ^
    "INITIAL_STATE = " ^ String.make 1 initialstate ^ "\n" ^
    "INITIAL_STACK = " ^ String.make 1 initialstack ^ "\n"

let transitions_str (t: transition list) : string = List.fold_left (fun x y -> x ^ trans_str y ^ "\n") "" t

let as_string (t : automate) : string = match t with 
  | (declarations, transitions) -> 
    "Declarations : " ^ declarations_str declarations ^ "\n" ^ 
    "Transitions :\n" ^ transitions_str transitions


(* DETERMINISTE *)

(* quand tu as dans le même états, avec le même symbole en haut de la pile epsilon avec un autre *) 
let rec found_epsi = function 
  | [] -> None 
  | (deb, etiquette, consomme, _, _ ) :: l -> 
    if compare_option None etiquette then 
      Some(deb, consomme)
    else found_epsi l

 let rec found_other (deb: char) (con: char) = function 
    | [] -> ()
    | (debut, etiquette, consomme, _, _ ) :: l -> 
      if debut == deb && consomme == con && compare_option None etiquette == false then
        raise(NotDeterministe "L'automate n'est pas déterminisite il possède + transitions dont une espi avec le même symbole de stack")
      else found_other deb con l

(* 
  (2,a,A,_,)
(2,,A,_,) ca permet d'éviter ca
*)
let check_epsilon (list: transitions) = 
  let check = found_epsi list in 
    let x = Utility.extract_x check in
    let deb = fst x in 
    let con = snd x in 
    let a = found_other deb con in 
    a  

let rec mem_assoc (deb: char) (eti: char option) (con: char) = function 
  | [] -> false 
  | (debut, etiquette, consome, _, _ ) :: l -> debut == deb && consome == con && compare_option eti etiquette || mem_assoc deb etiquette consome l

let check_transition(t: transition)(tr: transitions): bool =
  let (deb, eti, con, _, _) = t in 
  mem_assoc deb eti con tr


let rec check_symbols_list (list_element) (list): bool = match list_element with
  | [] -> true 
  | x :: tl -> 
    if List.mem x list == false then
      false 
    else
      check_symbols_list tl list

let check_symbol (trs: transitions)(inputsymbols: inputsymbols) (stacksymbols: stacksymbols) (states: states) = 
  let rec loop = function 
  | [] -> true 
  | x :: tl -> match x with 
    | (debut: char), (etiquette: char option) , (depile: char), (etat_final: char), (empile: char list) -> 
      if List.mem debut states == false || List.mem etat_final states == false then 
        raise(NotDeterministe "L'automate a un état qui n'appartient pas au states")
      else if etiquette != None && List.mem (Utility.extract_x etiquette) inputsymbols == false then 
        raise(NotDeterministe "L'automate a une etiquette qui n'appartient pas au inputsymbols")
      else if (List.mem depile stacksymbols) == false || check_symbols_list empile stacksymbols == false then
        raise(NotDeterministe "L'automate a un symbole qui n'appartient pas au stacksymbols")
      else 
        loop tl
    in loop trs

let check_automate (t: automate) : unit = match t with 
  | (declarations, transitions) -> match declarations with 
    | (inputsymbols, stacksymbols, states, initialstate, initialstack) -> 
      if (List.mem initialstate states) == false || (List.mem initialstack stacksymbols) == false || check_symbol transitions inputsymbols stacksymbols states == false then 
        raise(MalForme "L'automate est mal formé")
      else 
        check_epsilon transitions transitions;
        let rec loop(seen, rest) = match rest with 
        | [] -> print_endline "L'automate est déterministe" 
        | h::t -> 
          let (deb, eti, con, _, _) = h in 
          let seen' = 
            if mem_assoc deb eti con t then 
              raise(NotDeterministe "L'automate n'est pas déterministe")
            else 
               [] @ seen 
            in let rest' = t in loop(seen', rest')
        in loop([],transitions)

