# Ester

Elixir-based programming language processing framework.

Ester provides tools for creating grammers and parsers for programming 
languages. It doesn't matter what you're starting from or what you're 
trying to output: if you can formally describe it, it will work.

Ester primarily abstracts away the need to work with `:leex` and `:yecc`
directly, providing a much more powerful and Elixir-like approach to
generating lexer/parser systems. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ester` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ester, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ester](https://hexdocs.pm/ester).

