defmodule FlashCardsVoiceGenerator.Repo.Migrations.AddAudioFilePathToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :audio_file_path, :string
    end
  end
end
