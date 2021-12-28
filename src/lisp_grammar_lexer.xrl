Definitions.
COMMENT = ;.*
WHITESPACE = [\s\t\r\n]+
OPEN_PAREN = \(
CLOSE_PAREN = \)
ATOM = [^\(\)\s\t\r\n]+
STRING = "[^"]*"
Rules.
{COMMENT} : {token, {comment, TokenLine, comment(TokenChars)}}.
{WHITESPACE} : {token, {whitespace, TokenLine, whitespace(TokenChars)}}.
{OPEN_PAREN} : {token, {open_paren, TokenLine, TokenChars}}.
{CLOSE_PAREN} : {token, {close_paren, TokenLine, TokenChars}}.
{ATOM} : {token, {atom, TokenLine, TokenChars}}.
{STRING} : {token, {string, TokenLine, TokenChars}}.
Erlang code.
comment(_grex_capture@1) -> _grex_capture@1.

whitespace(_grex_capture@1) -> _grex_capture@1.