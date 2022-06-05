%{ 
  open Ast
%}

%token EOF COLON COMMA INPUT_SYMBOLS STACK_SYMBOLS STATES INITIAL_STATE INITIAL_STACK PROGRAM CASE OF BEGIN END STATE NEXT TOP PUSH POP CHANGE REJECT
%token <char> LETTRE

%start input
%type <Ast.automate> input
%% 
input: 
  a = automate; EOF {a}
automate: 
  d = declarations; p = program { d, p }
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
program: 
  PROGRAM; COLON; expr = expression { expr }  
expression:
  | CASE; STATE; OF; case = casestate { CaseState case }
  | CASE; NEXT; OF; case = casenext { CaseNext case }
  | CASE; TOP; OF; case = casetop { CaseTop case }
  | instr = instruction { instr }
instruction:
  | BEGIN; expr = expression; END { expr }
  | PUSH; l = LETTRE { Push l }
  | POP { Pop }
  | REJECT { Reject }
  | CHANGE; l = LETTRE { Change l }
casetop:
  | l = LETTRE; COLON; instr = instruction; case = casetop { (l,instr) :: case } | {[]}
casenext:
  | l = LETTRE; COLON; instr = instruction; case = casenext { (l,instr) :: case } | {[]}
casestate:
  | l = LETTRE; COLON; instr = instruction; case = casestate { (l,instr) :: case } | {[]}