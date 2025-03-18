defmodule FlashCardsVoiceGenerator.CardSets.CardSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "card_sets" do
    field :name, :string
    has_many :cards, FlashCardsVoiceGenerator.Cards.Card

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card_set, attrs) do
    card_set
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
