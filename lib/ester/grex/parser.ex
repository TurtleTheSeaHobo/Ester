defmodule Ester.Grex.Parser do
  require :grex_parser

  def parse(tokens) do
    :grex_parser.parse(tokens)
  end

  def parse!(tokens) do
    {:ok, tree} = parse(tokens)

    tree
  end
end
