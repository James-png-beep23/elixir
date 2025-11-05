defmodule House2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      House2Web.Telemetry,
      House2.Repo,
      {DNSCluster, query: Application.get_env(:house2, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: House2.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: House2.Finch},
      # {Registry, keys: :unique, name: House2.Registry},
      # Start a worker by calling: House2.Worker.start_link(arg)
      # {House2.Worker, arg},
      # Start to serve requests, typically the last entry
      House2Web.Endpoint,
      House2.Server
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: House2.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    House2Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
