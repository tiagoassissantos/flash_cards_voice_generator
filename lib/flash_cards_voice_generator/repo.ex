defmodule FlashCardsVoiceGenerator.Repo do
  use Ecto.Repo,
    otp_app: :flash_cards_voice_generator,
    adapter: Ecto.Adapters.SQLite3
end
