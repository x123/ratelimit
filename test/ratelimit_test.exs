defmodule RatelimitTest do
  use ExUnit.Case
  doctest Ratelimit

  test "greets the world" do
    assert Ratelimit.hello() == :world
  end
end
