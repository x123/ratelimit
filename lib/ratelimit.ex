defmodule RateLimit do
  use GenServer

  @vsn "0"

  @me __MODULE__

  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  def get_limiters() do
    GenServer.call(@me, :get_limiters)
  end

  def add(name, rate, max_tokens) do
    GenServer.call(@me, {:add, {name, rate, max_tokens}})
  end

  def count() do
    GenServer.call(@me, :count)
  end

  def save_results() do
    GenServer.call(@me, :save_results)
  end

  # Server
  def init(:no_args) do
    {:ok, %{}}
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:add, {name, rate, max_tokens}}, _from, limiters) do
    {:ok, pid} = RateLimit.TokenBucket.start_link(name, rate, max_tokens)
    new_limiters = Map.update(limiters, name, pid, fn existing -> pid end)
    {:reply, limiters, new_limiters}
  end

  def handle_call(:count, _from, limiters) do
    {:reply, length(Map.keys(limiters)), limiters}
  end

  def handle_call(:get_limiters, _from, limiters) do
    {:reply, limiters, limiters}
  end
end
