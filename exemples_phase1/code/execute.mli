open Utility;;

val check_stack : char list -> char -> char list -> bool 
val list_choice : char -> char -> char list -> transition list -> transition list
val order_list_choice : transition list -> transition list * transition list
val check_words : 'a list -> 'a list -> bool 
val update_stack : stack -> char -> char list -> stack 
val update_word : char list -> char option -> char list 
val get_first_choice : translist -> char -> stack -> transitions 
val execute_automate : automate -> char list -> 'a list