import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :flash_cards_voice_generator, FlashCardsVoiceGenerator.Repo,
  database: Path.expand("../flash_cards_voice_generator_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flash_cards_voice_generator, FlashCardsVoiceGeneratorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rn+xegN8FtCL0zXk9uxgzecpTte0k5rRSnsOxrBhfqgc7rzwMu0vJyzS9O06RIRs",
  server: false

# In test we don't send emails
config :flash_cards_voice_generator, FlashCardsVoiceGenerator.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
