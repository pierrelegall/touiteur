defmodule Touiteur.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TouiteurWeb.Telemetry,
      # Start the Ecto repository
      Touiteur.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Touiteur.PubSub},
      # Start Finch
      {Finch, name: Touiteur.Finch},
      # Start the Endpoint (http/https)
      TouiteurWeb.Endpoint,
      # Language detection
      Touiteur.Services.MessageSupposedLanguageSetter
      # Start a worker by calling: Touiteur.Worker.start_link(arg)
      # {Touiteur.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Touiteur.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TouiteurWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
