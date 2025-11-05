defmodule House3.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      House3Web.Telemetry,
      House3.Repo,
      {DNSCluster, query: Application.get_env(:house3, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: House3.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: House3.Finch},
      # Start a worker by calling: House3.Worker.start_link(arg)
      # {House3.Worker, arg},
      # Start to serve re,quests, typically the last entry
      House3Web.Endpoint,
      House3.Server
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: House3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    House3Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
