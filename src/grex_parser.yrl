Terminals 	defgrammar defrule deftoken do in endeth identifier regex literal 
		'*' '+' '?' '|' '{' '}' '(' ')' '->' nl ex_block.
Nonterminals 	grex_file grammar rule token declaration grammar_body declaration_body 
		expression500 expression400 expression300 expression200 expression100 
		expression suffix_op infix_op.
Rootsymbol 	grex_file.

grex_file -> grammar					: ['$1'].
grex_file -> nl						: [].
grex_file -> grammar grex_file				: ['$1'|'$2'].
grex_file -> nl grex_file				: '$2'.

grammar -> 
  defgrammar identifier do nl grammar_body endeth 	: {grammar, {'$2', '$5'}}.

rule -> 
  defrule identifier expression				: {rule, {'$2', '$3', []}}.
rule ->  
  defrule identifier expression ex_block		: {rule, {'$2', '$3', '$4'}}.

token -> 
  deftoken identifier expression 			: {token, {'$2', '$3', []}}.
token ->  
  deftoken identifier expression ex_block		: {token, {'$2', '$3', '$4'}}.

declaration -> rule					: '$1'.
declaration -> token					: '$1'.

grammar_body -> declaration				: ['$1'].
grammar_body -> nl					: [].
grammar_body -> declaration grammar_body		: ['$1'|'$2'].
grammar_body -> nl grammar_body				: '$2'.

expression500 -> in identifier				: {in, '$2'}.

expression400 -> expression500				: '$1'.
expression400 -> identifier				: '$1'.
expression400 -> regex					: '$1'.
expression400 -> literal				: '$1'.

expression300 -> expression400				: '$1'.
expression300 -> expression300 suffix_op		: {'$2', '$1'}.
expression300 -> expression300 infix_op expression300	: {'$2', {'$1', '$3'}}.

expression200 -> expression300 expression200		: ['$1'|'$2'].
expression200 -> expression300				: ['$1'].

expression100 -> expression200				: '$1'.
expression100 -> '(' expression200 ')'			: '$2'.

expression -> expression100				: '$1'.

suffix_op -> '*'					: '*'.
suffix_op -> '+'					: '+'.
suffix_op -> '?'					: '?'.
infix_op -> '|'						: '|'.
infix_op -> '->'					: '->'.
infix_op -> in						: in.

Erlang code.

%extract_value({_Token, _Line, Value}) -> Value.
