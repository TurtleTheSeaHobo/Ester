Definitions.

KEYWORD		= defgrammar|defrule|deftoken|in|do|end
IDENTIFIER	= [A-z]*
LITERAL		= "[^"]*"
REGEX		= \/[^\/]*\/[A-z]*
WHITESPACE	= [\s\t\r]+
NEWLINE		= \n
COMMENT		= #.*
EX_BLOCK	= do[^:]([^do]|[^d]o|d([^o])|\n)*end|,\s*do:.*\n 
% if something breaks, it was probably caused by this line ^^^

Rules.

{EX_BLOCK}	: {token, {ex_block, TokenLine, TokenChars}}.
defgrammar	: {token, {defgrammar, TokenLine}}.
defrule		: {token, {defrule, TokenLine}}.
deftoken	: {token, {deftoken, TokenLine}}.
in		: {token, {in, TokenLine}}.
do		: {token, {do, TokenLine}}.
end		: {token, {endeth, TokenLine}}. % `end` is reserved by erlang
{IDENTIFIER}	: {token, {identifier, TokenLine, TokenChars}}.
{REGEX}		: {token, {regex, TokenLine, TokenChars}}.
{LITERAL}	: {token, {literal, TokenLine, TokenChars}}.
\*		: {token, {'*', TokenLine}}.
\+		: {token, {'+', TokenLine}}.
\?		: {token, {'?', TokenLine}}.
\|		: {token, {'|', TokenLine}}.
\{		: {token, {'{', TokenLine}}.
\}		: {token, {'}', TokenLine}}.
\(		: {token, {'(', TokenLine}}.
\)		: {token, {')', TokenLine}}.
\|>		: {token, {'|>', TokenLine}}.
->		: {token, {'->', TokenLine}}.
{NEWLINE}	: {token, {nl, TokenLine}}.
{WHITESPACE}	: skip_token.
{COMMENT}	: skip_token.

Erlang code.

