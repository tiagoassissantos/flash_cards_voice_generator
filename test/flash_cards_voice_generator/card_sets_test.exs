defmodule FlashCardsVoiceGenerator.CardSetsTest do
  use FlashCardsVoiceGenerator.DataCase

  alias FlashCardsVoiceGenerator.CardSets

  describe "card_sets" do
    alias FlashCardsVoiceGenerator.CardSets.CardSet

    import FlashCardsVoiceGenerator.CardSetsFixtures

    @invalid_attrs %{name: nil}

    test "list_card_sets/0 returns all card_sets" do
      card_set = card_set_fixture()
      assert CardSets.list_card_sets() == [card_set]
    end

    test "get_card_set!/1 returns the card_set with given id" do
      card_set = card_set_fixture()
      assert CardSets.get_card_set!(card_set.id) == card_set
    end

    test "create_card_set/1 with valid data creates a card_set" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %CardSet{} = card_set} = CardSets.create_card_set(valid_attrs)
      assert card_set.name == "some name"
    end

    test "create_card_set/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CardSets.create_card_set(@invalid_attrs)
    end

    test "update_card_set/2 with valid data updates the card_set" do
      card_set = card_set_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %CardSet{} = card_set} = CardSets.update_card_set(card_set, update_attrs)
      assert card_set.name == "some updated name"
    end

    test "update_card_set/2 with invalid data returns error changeset" do
      card_set = card_set_fixture()
      assert {:error, %Ecto.Changeset{}} = CardSets.update_card_set(card_set, @invalid_attrs)
      assert card_set == CardSets.get_card_set!(card_set.id)
    end

    test "delete_card_set/1 deletes the card_set" do
      card_set = card_set_fixture()
      assert {:ok, %CardSet{}} = CardSets.delete_card_set(card_set)
      assert_raise Ecto.NoResultsError, fn -> CardSets.get_card_set!(card_set.id) end
    end

    test "change_card_set/1 returns a card_set changeset" do
      card_set = card_set_fixture()
      assert %Ecto.Changeset{} = CardSets.change_card_set(card_set)
    end
  end
end
