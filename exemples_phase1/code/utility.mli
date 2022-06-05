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
type declarations =
    inputsymbols * stacksymbols * states * initialstate * initialstack
type automate = declarations * transitions
type word = char list
type execution = char * stack * char list

val extract_x : 'a option -> 'a
val last : 'a list -> 'a
val drop : 'a list -> int -> 'a list

(*

val lookup : (char * 'a) list -> char -> 'a = <fun>
val chr_lst_str : char list -> string = <fun>
val chr_opt_str : char option -> string = <fun>
val compare_option : 'a option -> 'a option -> bool = <fun>
val extract_x : 'a option -> 'a = <fun>
val last : 'a list -> 'a = <fun>
val drop : 'a list -> int -> 'a list = <fun>
val trans_str : transition -> string = <fun>
val declarations_str : declarations -> string = <fun>
val transitions_str : transition list -> string = <fun>
val as_string : automate -> string = <fun>
val found_epsi : ('a * 'b option * 'c * 'd * 'e) list -> ('a * 'c) option =<fun>
val found_other :
  char -> char -> (char * 'a option * char * 'b * 'c) list -> unit = <fun>
val check_epsilon :
  transitions -> (char * 'a option * char * 'b * 'c) list -> unit = <fun>
val mem_assoc :
  char ->
  char option -> char -> (char * char option * char * 'a * 'b) list -> bool =
  <fun>
val check_transition : transition -> transitions -> bool = <fun>
val check_symbols_list : 'a list -> 'a list -> bool = <fun>
val check_symbol :
  transitions -> inputsymbols -> stacksymbols -> states -> bool = <fun>
val check_automate : automate -> unit = <fun> *)

