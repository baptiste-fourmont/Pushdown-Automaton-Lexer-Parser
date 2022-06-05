open Utility

let check_stack (stack: char list) (depile: char) (empile: char list) = last stack == depile

let list_choice (letter: char)(etat_ini: char)(stack: char list)(transitions: transitions) : transition list = 
  let rec found accu = function 
    | [] -> accu
    | (debut, etiquette, depile, final, empile) :: l -> 
        if debut == etat_ini && check_stack stack depile empile && etiquette == None then
          let a : transition = (debut, etiquette, depile, final, empile) in 
          found (accu @ [a]) l
        else if debut == etat_ini && check_stack stack depile empile && extract_x etiquette == letter then 
          let a : transition = (debut, etiquette, depile, final, empile) in 
          found (accu @ [a]) l
        else found accu l
    in found [] transitions

let order_list_choice (tr: transition list) : transition list * transition list = 
  let rec found epsi_list autre = function 
    | [] -> (epsi_list, autre)
    | (debut, etiquette, depile, final, empile) :: l -> 
        let a : transition = (debut, etiquette, depile, final, empile) in 
        if etiquette == None then
          found (epsi_list @ [a]) autre l
        else
          found epsi_list (autre @ [a]) l
    in found [] [] tr


(* EXECUTIONS *)


let rec check_words (list_element) (list): bool = match list_element with
  | [] -> true 
  | x :: tl -> 
    if List.mem x list == false then
      false 
    else
      check_words tl list


(* On enlève le mot à dépiler et on empile la liste de mot*)
let update_stack (stack: stack)(depile: char)(empile: char list) : stack =
  if stack != None then 
    let get_list = extract_x stack in
    if List.length get_list > 0 then
      if empile != [] then 
        Some((drop get_list (List.length get_list)) @ empile)
      else 
        Some((drop get_list (List.length get_list)))
    else raise(ErrorExecution("La pile est vide sans que l'entrée soit épuisée"))
  else raise(ErrorExecution "Cannot remove while the stack is empty")

(* On enlève la lettre qu'on à lu dans la transitions *)
let update_word(words: char list)(etiquette: char option) : char list = 
  if etiquette == None || List.hd words == (extract_x etiquette) then 
    List.tl words
  else
    raise(ErrorExecution("Cannot remove this letter in the word"))

(* check if depile = epsilon*)
let rec get_first_choice (transitions: translist) (inistate_: char)(stack: stack) : transitions = match transitions with 
  | [] -> []
  | (debut, etiquette, depile, final, empile) :: tl -> 
    if etiquette == None && empile == [] && inistate_ == debut && List.length (extract_x stack) == 1 && List.hd (extract_x stack) == depile then
      [(debut,etiquette, depile, final, empile)]
    else 
      get_first_choice tl inistate_ stack

let rec execute_automate(automate: automate)(words: char list) = 
  let transitions = snd automate in 
  let declarations = fst automate in 
  let (inputsymbols, _, _, initialstate, initialstack) = declarations in 
  let (first_exec:execution) = (initialstate,Some[initialstack],words) in 
  
  let () = Printf.printf "STATE: %c, " initialstate in 
  let () = Printf.printf "STACK %c, " initialstack in 
  let () = Printf.printf "WORDS: " in 
  let () = List.iter (Printf.printf "%c ") words in 
  let () =  Printf.printf "\n" in  

  let check = check_words words inputsymbols in 
  if check == false then raise(ErrorExecution("Le mot contient une lettre qui n'est pas dans les inputsymbols"))
  else 
  let rec execution_transition (transitions: transitions) (exec: execution)(words: char list) = match words with
    | [] -> 
      let (inistate_,stack_,words_) = exec in 
        let get_first_choice = get_first_choice transitions inistate_ stack_ in 
        if get_first_choice != [] || List.length (extract_x stack_) == 0 then 
          let () =  Printf.printf "Le mot est accepté par l'automate\n" in
          []
        else 
          let () =  Printf.printf "Le mot n'est pas accepté par l'automate\n" in
          raise(ErrorExecution("L'entrée est épuisée sans que la pile soit vide"))
    | letter :: tl -> 
      let (inistate_,stack_,words_) = exec in
      let get_choices = list_choice letter inistate_ (extract_x stack_) transitions in 
      if get_choices == [] then raise(ErrorExecution("Il n'y a aucune transition qui s'applique")) else 
      let ordered_choices = order_list_choice get_choices in match ordered_choices with
      | ([], l) | (l, _) ->
        (* let get_transi = List.hd l in *) 
        let get_first = get_first_choice transitions inistate_ stack_ in 
        if get_first != [] then 
          let (debut, etiquette, depile, final, empile) = List.hd get_first in  
          let new_stack = update_stack stack_ depile empile in 
          let new_words = update_word words etiquette in 
          let new_exec = (final, new_stack, new_words) in
          if List.length (extract_x new_stack) == 0 then 
            raise(ErrorExecution("La pile est vide sans que l'entrée soit épuisée")) 
          else 
          let () = Printf.printf "STATE: %c, " final in 
          let () = Printf.printf "STACK: " in 
          let () = List.iter (Printf.printf "%c ") (extract_x new_stack) in 
          let () = Printf.printf "WORDS: " in 
          let () = List.iter (Printf.printf "%c ") new_words in 
          let () =  Printf.printf "\n" in  
          execution_transition transitions new_exec tl  
        else
        let get_transi = List.hd l in 
        let (debut, etiquette, depile, final, empile) = get_transi in  
          let new_stack = update_stack stack_ depile empile in 
          let new_words = update_word words etiquette in 
          let new_exec = (final, new_stack, new_words) in
          let () = Printf.printf "STATE: %c, " final in 
          let () = Printf.printf "STACK: " in 
          let () = List.iter (Printf.printf "%c ") (extract_x new_stack) in 
          let () = Printf.printf "WORDS: " in 
          let () = List.iter (Printf.printf "%c ") new_words in 
          let () =  Printf.printf "\n" in  
          execution_transition transitions new_exec tl  
  in execution_transition transitions first_exec words