defmodule Mix.Tasks.Compile.Grex do
  use Mix.Task.Compiler
  require Ester.Grex

  def run(_args) do
    :ok
  end

  def clean() do
    :ok
  end
end
