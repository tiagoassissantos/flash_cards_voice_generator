defmodule FlashCardsVoiceGenerator.CardSetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FlashCardsVoiceGenerator.CardSets` context.
  """

  @doc """
  Generate a card_set.
  """
  def card_set_fixture(attrs \\ %{}) do
    {:ok, card_set} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> FlashCardsVoiceGenerator.CardSets.create_card_set()

    card_set
  end
end
