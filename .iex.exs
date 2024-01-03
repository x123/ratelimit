registry = Registry.start_link(
  keys: :unique,
  name: Application.get_env(:ratelimit, :tokenbucket_registry)
)
