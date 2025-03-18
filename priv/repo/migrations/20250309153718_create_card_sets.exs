defmodule FlashCardsVoiceGenerator.Repo.Migrations.CreateCardSets do
  use Ecto.Migration

  def change do
    create table(:card_sets) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
