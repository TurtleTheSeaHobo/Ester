defmodule Ester.Grex.Lexer do
  require :grex_lexer
  require String

  def lex(text) when is_binary(text) do
    text
    |> String.to_charlist()
    |> :grex_lexer.string()
  end

  def lex!(text) when is_binary(text) do
    {:ok, tokens, _num_lines} = lex(text)
    
    tokens
  end
end
