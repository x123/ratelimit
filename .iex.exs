#registry = Registry.start_link(
#  keys: :unique,
#  name: Application.get_env(:ratelimit, :tokenbucket_registry)
#)
{result, test_pid } = RateLimit.TokenBucket.start_link(:test, 10 / 60, 10)
IO.puts("RateLimit.TokenBucket.get(:test)")

IO.inspect(RateLimit.TokenBucket.get(:test))

