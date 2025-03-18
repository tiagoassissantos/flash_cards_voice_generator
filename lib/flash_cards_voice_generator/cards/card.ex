defmodule FlashCardsVoiceGenerator.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :text, :string
    field :audio_file_path, :string
    belongs_to :card_set, FlashCardsVoiceGenerator.CardSets.CardSet

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:text, :audio_file_path, :card_set_id])
    |> validate_required([:text, :card_set_id])
    |> foreign_key_constraint(:card_set_id)
  end
end
