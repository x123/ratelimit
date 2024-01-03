import Config

config :logger, :default_handler, level: :info

config :ratelimit,
  registry_name: :ratelimit_registry
