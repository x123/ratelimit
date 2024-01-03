defmodule RateLimit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Sequencesup.Worker.start_link(arg)
      {Registry, [keys: :unique, name: Application.get_env(:ratelimit, :tokenbucket_registry)]},

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Sequencesup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
