defmodule RateLimitTest do
  use ExUnit.Case
  doctest RateLimit

  test "can RateLimit.add" do
    assert {:ok, _pid} = RateLimit.add("test", 10 / 60, 100)
  end

  test "add duplicate RateLimit" do
    RateLimit.add("test", 10, 10)
    assert {:error, {:already_started, _pid}} = RateLimit.add("test", 10, 10)
  end
end
