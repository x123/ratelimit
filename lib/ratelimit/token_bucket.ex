defmodule RateLimit.TokenBucket do
  use Agent

  def start_link(rate, max_tokens, name) do
    Agent.start_link(fn -> initialize(rate, max_tokens) end, name: via_tuple(name))
  end

  defp via_tuple(name) do
    {:via, Registry, {Application.get_env(:ratelimit, :tokenbucket_registry), name}}
  end

  defp initialize(rate, max_tokens) do
    %{
      rate: rate,
      started: DateTime.utc_now(),
      elapsed: 0,
      tokens: 0,
      max_tokens: max_tokens,
      last_updated: DateTime.utc_now()
    }
  end

  def value(name) do
    RateLimit.TokenBucket.update(name)
    Agent.get(via_tuple(name), & &1)
  end

  def can_use?(name, num_tokens) do
    state = value(name)

    cond do
      num_tokens <= Map.get(state, :tokens) -> true
      true -> false
    end
  end

  def use(name, num_tokens) do
    if can_use?(name, num_tokens) do
      Agent.update(
        via_tuple(name),
        fn state -> Map.update(state, :tokens, 0, fn existing -> existing - num_tokens end) end
      )
      {:ok, "used #{num_tokens}"}
    else
      {:error, "not enough tokens, wait"}
    end
  end

  def stop(name) do
    result = Agent.stop(via_tuple(name))
    result
  end

  def loop_display(name) do
    RateLimit.TokenBucket.update(name)
    IO.write("\r#{inspect(RateLimit.TokenBucket.value(name), pretty: true)}")
    Process.sleep(100)
    via_tuple(name).loop_display()
  end

  def update(name) do
    Agent.update(via_tuple(name), fn state ->
      elapsed = Time.diff(DateTime.utc_now(), Map.get(state, :started))
      state = Map.update(state, :elapsed, elapsed, fn _existing -> elapsed end)

      rate = Map.get(state, :rate)
      max_tokens = Map.get(state, :max_tokens)

      since_last_updated =
        Time.diff(
          DateTime.utc_now(),
          Map.get(state, :last_updated),
          :microsecond
        )

      state =
        Map.update(
          state,
          :tokens,
          min(
            Map.get(state, :tokens) + since_last_updated * rate / 1_000_000,
            max_tokens
          ),
          fn existing ->
            min(
              existing + since_last_updated * rate / 1_000_000,
              max_tokens
            )
          end
        )

      Map.update(state, :last_updated, DateTime.utc_now(), fn _existing -> DateTime.utc_now() end)
    end)
  end

	# TODO: make an add_tokens(name, num_tokens)
end
