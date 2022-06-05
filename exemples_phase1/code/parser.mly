%{ 
  open Ast
%}

%token EOF INPUT_SYMBOLS STACK_SYMBOLS STATES INITIAL_STATE INITIAL_STACK TRANSTIONS LPAREN RPAREN SEMICOLON COMMA COLON

%token <char> LETTRE

%start input
%type <Ast.automate> input

%% 
input: 
  a = automate; EOF {a}
automate: 
  d = declarations; t= transitions { d, t }
declarations: 
  i = inputsymbols; stack = stacksymbols; sta = states; inistate =  initialstate; inistack = initialstack {i, stack, sta, inistate, inistack}
inputsymbols: 
  INPUT_SYMBOLS; COLON; s = suitelettrenonvide {s} 
stacksymbols:
  STACK_SYMBOLS; COLON; s = suitelettrenonvide {s}
states:
  STATES; COLON; s = suitelettrenonvide {s}
initialstate:
  INITIAL_STATE; COLON; l = LETTRE { l }
initialstack:
  INITIAL_STACK; COLON; l = LETTRE { l }
suitelettrenonvide:
    l = LETTRE; COMMA; s = suitelettrenonvide {l::s} | l = LETTRE {[l]}
transitions:
  TRANSTIONS; COLON; t = translist {t}
translist: 
  t = transition; t2= translist {t::t2}
  | {[]}
transition:
  LPAREN; l1 = LETTRE; COMMA; lv = lettreouvide; COMMA ; l2 = LETTRE; COMMA; l3 = LETTRE; COMMA; s = stack ; RPAREN {l1,lv,l2,l3,s}
lettreouvide:
  l = LETTRE {Some(l)} | {None}
stack:
  s = nonemptystack {s} | {[]}
nonemptystack: 
  l = LETTRE; SEMICOLON; non =  nonemptystack {l::non} | l = LETTRE {[l]}