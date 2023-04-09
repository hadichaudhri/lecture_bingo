defmodule LectureBingo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LectureBingoWeb.Telemetry,
      # Start the Ecto repository
      LectureBingo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LectureBingo.PubSub},
      # Start Finch
      {Finch, name: LectureBingo.Finch},
      # Start the Endpoint (http/https)
      LectureBingoWeb.Endpoint
      # Start a worker by calling: LectureBingo.Worker.start_link(arg)
      # {LectureBingo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LectureBingo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LectureBingoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
