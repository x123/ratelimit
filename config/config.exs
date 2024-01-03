import Config

config :logger, :default_handler, level: :info

config :ratelimit,
  tokenbucket_registry: :tokenbucket_registry
