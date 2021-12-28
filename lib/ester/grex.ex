defmodule Ester.Grex do
  require File
  require Macro
  alias Ester.Grex.Lexer
  alias Ester.Grex.Parser
  alias Ester.Grex.Compiler

  def file(path) do
    outs = path
    |> File.read!()
    |> Lexer.lex!()
    |> Parser.parse!()
    |> Compiler.compile!()

    for {name, xrl_src, yrl_src} <- outs do
      snake_name = Macro.underscore(name)
      xrl_path = "src/#{snake_name}_lexer.xrl"
      yrl_path = "src/#{snake_name}_parser.yrl"

      File.write!(xrl_path, xrl_src)
      File.write!(yrl_path, yrl_src)

      {xrl_path, yrl_path}
    end
  end
end
