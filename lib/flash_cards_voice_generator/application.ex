defmodule FlashCardsVoiceGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlashCardsVoiceGeneratorWeb.Telemetry,
      FlashCardsVoiceGenerator.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:flash_cards_voice_generator, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:flash_cards_voice_generator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FlashCardsVoiceGenerator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FlashCardsVoiceGenerator.Finch},
      # Start a worker by calling: FlashCardsVoiceGenerator.Worker.start_link(arg)
      # {FlashCardsVoiceGenerator.Worker, arg},
      # Start to serve requests, typically the last entry
      FlashCardsVoiceGeneratorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlashCardsVoiceGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlashCardsVoiceGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
