defmodule FlashCardsVoiceGenerator.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FlashCardsVoiceGenerator.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    card_set = FlashCardsVoiceGenerator.CardSetsFixtures.card_set_fixture()

    {:ok, card} =
      attrs
      |> Enum.into(%{
        text: "some text",
        card_set_id: card_set.id
      })
      |> FlashCardsVoiceGenerator.Cards.create_card()

    card
  end
end
