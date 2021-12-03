defmodule EsterTest do
  use ExUnit.Case
  doctest Ester

  test "greets the world" do
    assert Ester.hello() == :world
  end
end
