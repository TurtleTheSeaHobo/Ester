defmodule Ester do
  @moduledoc """
  Documentation for `Ester`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ester.hello()
      :world

  """
  def hello do
    :world
  end

  def grex_test do
    infile = 
      File.read!("examples/ester_lisp/lisp.grex")
      |> String.to_charlist()

    case :grex_lexer.string(infile) do
      {:ok, tokens, _} ->
        case :grex_parser.parse(tokens) do
          {:ok, tree} -> 
            tree
          perr -> 
            perr
        end
      lerr ->
        lerr
    end
  end

  def grex2_test do
    infile = 
      File.read!("examples/ester_lisp/lisp.grex2")
      |> String.to_charlist()

    case :grex2_lexer.string(infile) do
      {:ok, tokens, _} ->
        case :grex2_parser.parse(tokens) do
          {:ok, tree} -> 
            tree
          perr -> 
            perr
        end
      lerr ->
        lerr
    end
  end

end
