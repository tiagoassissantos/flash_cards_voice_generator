defmodule FlashCardsVoiceGenerator.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :text, :string
      add :card_set_id, references(:card_sets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:cards, [:card_set_id])
  end
end
