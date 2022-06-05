exception MalForme of string
exception Interruption of string

type initialstate = char 
type initialstack = char
type suitelettresnonvide = char list
type inputsymbols = char list 
type stacksymbols = char list
type initialsymbols = char list
type states = char list
type lettreouvide = char option
type nonemptystack = char list
type stack = char list
type declarations = inputsymbols * stacksymbols * states * initialstate * initialstack

type expr =
  | CaseState of (char * expr) list
  | CaseNext of (char * expr) list
  | CaseTop of (char * expr) list
  | Push of char
  | Change of char
  | Reject
  | Pop

type program = expr
type word = char list
type execution = char * stack * char list
type automate = declarations * program

let chr_lst_str (l : char list) : string = match l with
  | [] -> "Empty"
  | _ -> List.fold_left (fun x y -> x ^ " " ^ String.make 1 y) "" l


let declarations_str (d: declarations) : string = match d with
    (inputsymbols, stacksymbols, states, initialstate, initialstack) ->
    "INPUT_SYMBOLS = " ^ chr_lst_str inputsymbols ^ "\n" ^
    "STACK_SYMBOLS = " ^ chr_lst_str stacksymbols ^ "\n" ^
    "STATES = " ^ chr_lst_str states ^ "\n" ^
    "INITIAL_STATE = " ^ String.make 1 initialstate ^ "\n" ^
    "INITIAL_STACK = " ^ String.make 1 initialstack ^ "\n"

let as_string (t : automate) : string = match t with 
  | (declarations, program) -> 
    "Declarations : " ^ declarations_str declarations ^ "\n"

let rec check_symbols_list (list_element) (list): bool = match list_element with
  | [] -> true 
  | x :: tl -> 
    if List.mem x list == false then
      false 
    else
      check_symbols_list tl list
  
let print_action(state: char)(stack: char list)(words: char list) : string =
  "State : " ^ String.make 1 state ^ "\n" ^
  "Stack : " ^ chr_lst_str stack ^ "\n" ^
  "Words : " ^ chr_lst_str words ^ "\n"

let rec execute_automate dec oldprog prog state stack words = 
  let (inputsymbols, stacksymbols, states, initialstate, initialstack) = dec in match stack, words with 
  | [], [] -> print_endline "Accepted"
  | ( _ , _ ) -> match prog with 
    | Reject -> 
      raise(Interruption "Reject")
    | Push x -> 
      Printf.printf "Push to %s\n\n" (String.make 1 x);
      Printf.printf "Parse: %s\n" (print_action state stack words);
      execute_automate dec oldprog oldprog state (x :: stack) words
    | Change x ->
      Printf.printf "Change to %s\n\n" (String.make 1 x);
      Printf.printf "Parse: %s\n" (print_action state stack words);
      if List.mem x states then
        execute_automate dec oldprog oldprog x stack words
      else
        raise (MalForme "Change of non state")
    | Pop ->  
      print_endline "Action: Pop\n";
      if stack = [] then
        raise (Interruption "Pop on empty stack")
      else
        Printf.printf "Parse: %s\n" (print_action state stack words);
        execute_automate dec oldprog oldprog state (List.tl stack) words
    | CaseState (list) ->  
      if list == [] then
        raise (MalForme "Empty CaseState")
      else
        print_endline "Action: Case State\n";
        Printf.printf "Parse: %s\n" (print_action state stack words);
        let (x, y) = List.find (fun (x, y) -> x = state) list in
        (* Si il y a un cas on execute le programme correspondant *)
        Printf.printf "State : %s\n" (String.make 1 x);
        execute_automate dec oldprog y x stack words
    | CaseNext (list) -> 
       if list == [] then
        raise (MalForme "Empty CaseState")
      else
        if words == [] then 
          raise (Interruption "End of input")
        else 
          print_endline "Action Case Next\n";
          Printf.printf "Parse: %s\n" (print_action state stack words);
          let (x, y) = List.find (fun (x, y) -> x = List.hd words) list in
          execute_automate dec oldprog y state stack (List.tl words)
    | CaseTop (list) -> 
        if list == [] then
          raise (MalForme "Empty CaseTop")
        else
          if stack == [] then 
            raise (Interruption "End of input")
          else 
            print_endline "Action Case Top\n";
            Printf.printf "Parse: %s\n" (print_action state stack words);
            let (x, y) = List.find (fun (x, y) -> x = List.hd stack) list in
            execute_automate dec oldprog y state stack words

  let check_automate (t: automate)(words: char list): unit = match t with 
  | (declarations, program) -> match declarations with 
    | (inputsymbols, stacksymbols, states, initialstate, initialstack) -> 
      if (List.mem initialstate states) == false || (List.mem initialstack stacksymbols) == false ||  check_symbols_list words inputsymbols == false then 
        raise(MalForme "L'automate est mal formé")
      else 
        Printf.printf "Parse:\n%s\n" (as_string t);
        execute_automate declarations program program initialstate [initialstack] words;
        print_endline "OK"