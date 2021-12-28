defmodule Ester.Grex.Compiler do
  require Enum
  require List
  require Tuple
  require Regex
  require String
  require Code

  def compile(tree_cl) do
    tree = cls_to_bins(tree_cl)

    sources = for grammar <- tree do
      build_grammar(grammar)
    end

    {:ok, sources}
  end

  def compile!(tree) do
    {:ok, sources} = compile(tree)

    sources
  end

  defp cls_to_bins({atom, ln, cl}) when is_atom(atom) and is_number(ln) and is_list(cl) do
    {atom, ln, to_string(cl)}
  end

  defp cls_to_bins(list) when is_list(list) do
    for elem <- list do
      cls_to_bins(elem)
    end
  end

  defp cls_to_bins(tuple) when is_tuple(tuple) do
    for elem <- Tuple.to_list(tuple) do
      cls_to_bins(elem)
    end |> List.to_tuple()
  end

  defp cls_to_bins(other) do
    other
  end

  defp build_grammar({:grammar, {{:identifier, _, name}, declarations}}) do
    %{token: tokens, rule: rules} = declarations
                                    |> Enum.group_by(fn {t, _} -> t end)

    #{name, build_leex(name, tokens), build_yecc(name, rules)}
    {name, build_leex(name, tokens), ""}
  end

  defp build_leex(name, tokens) do
    {def_lns, rule_lns, fun_srcs} = tokens
                                    |> Enum.map(&build_token/1)
                                    |> unzipn()

    defs = Enum.join(def_lns, "\n")
    rules = Enum.join(rule_lns, "\n")
    erl_code = build_erlang_code(name, fun_srcs)
    
    "Definitions.\n#{defs}\nRules.\n#{rules}\nErlang code.\n#{erl_code}"
  end

  # helper function to allow unzipping lists of n-tuples
  defp unzipn(list) do
    list
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> List.to_tuple()
  end

  defp build_token({:token, {{:identifier, _, name}, pattern, []}}) do
    regex_src = condense_pattern(pattern)
    def_name = String.upcase(name)

    def_ln = "#{def_name} = #{regex_src}"
    rule_ln = "{#{def_name}} : {token, {#{name}, TokenLine, TokenChars}}."

    {def_ln, rule_ln, ""} # no code entry
  end

  defp build_token({:token, {{:identifier, _, name}, pattern, {:ex_block, _, code}}}) do
    regex_src = condense_pattern(pattern)
    def_name = String.upcase(name)

    def_ln = "#{def_name} = #{regex_src}"
    rule_ln = "{#{def_name}} : {token, {#{name}, TokenLine, #{name}(TokenChars)}}."

    body_code = preprocess_code(code)
    fun_code = build_function_code(name, body_code)

    {def_ln, rule_ln, fun_code}
  end

  defp condense_pattern([]) do
    ""
  end

  defp condense_pattern([{:regex, _, pattern} | tail]) do
    middle = String.slice(pattern, 1..-2) 
    
    middle <> condense_pattern(tail)
  end

  defp condense_pattern([{:literal, _, pattern} | tail]) do
    middle = String.slice(pattern, 1..-2)

    Regex.escape(middle) <> condense_pattern(tail)
  end

  defp preprocess_code(code) do
    code
    |> String.replace(~r/@\d+/, "grex_capture_") # replace capture alias
    |> String.replace(~r/@/, "grex_capture")
    |> String.replace(~r/^,\s*do:\s*|^do\s*\n/, "") # strip do/end block
    |> String.replace(~r/\n\s*end$/, "")
  end

  defp build_function_code(name, args \\ ["grex_capture"],  body_code) do
    "def #{name}(#{Enum.join(args, ", ")}) do\n#{body_code}\nend"
  end

  defp build_erlang_code(name, fun_srcs) do
    mod_name = "#{name}.Code"
    mod_code = build_module_code(mod_name, fun_srcs)

    # -- Translating Elixir source code into Erlang source code --
    # everything from this point on is a potential security catastrophe and
    # should never EVER be done on any project exposed to the internet.
    [{_, beam_code}] = Code.compile_string(mod_code)      # - Compile Elixir to BEAM module
    {:ok, {_, [abstract_code: {_, abstract_code}]}} =     # - Decompile BEAM module into
      :beam_lib.chunks(beam_code, [:abstract_code])       #   Erlang Abstract Format
    erl_code = abstract_code
               |> :erl_syntax.form_list()                 # - Recreate AST from EAF
               |> :erl_prettypr.format()                  # - Format AST as source code text
               |> to_string()                             # - Charlist to binary
               |> extract_function_part()                 # - Isolate functions defs part

    erl_code
  end

  defp build_module_code(mod_name, fun_srcs) do
    mod_body = Enum.join(fun_srcs, "\n")

    "defmodule #{mod_name} do\n#{mod_body}\nend"
  end

  defp extract_function_part(erl_code) do
    [_preamble, funs] = Regex.split(~r/'__info__'\(deprecated\).*\n/, erl_code)

    String.trim(funs)
  end
end
