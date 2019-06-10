defmodule BankingTest do
  use ExUnit.Case
  doctest Banking

  test "greets the world" do
    assert Banking.hello() == :world
  end
end
