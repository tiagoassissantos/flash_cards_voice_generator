defmodule FlashCardsVoiceGenerator.CardSets do
  @moduledoc """
  The CardSets context.
  """

  import Ecto.Query, warn: false
  alias FlashCardsVoiceGenerator.Repo

  alias FlashCardsVoiceGenerator.CardSets.CardSet

  @doc """
  Returns the list of card_sets.

  ## Examples

      iex> list_card_sets()
      [%CardSet{}, ...]

  """
  def list_card_sets do
    Repo.all(CardSet)
  end

  @doc """
  Gets a single card_set.

  Raises `Ecto.NoResultsError` if the Card set does not exist.

  ## Examples

      iex> get_card_set!(123)
      %CardSet{}

      iex> get_card_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card_set!(id), do: Repo.get!(CardSet, id)

  @doc """
  Creates a card_set.

  ## Examples

      iex> create_card_set(%{field: value})
      {:ok, %CardSet{}}

      iex> create_card_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card_set(attrs \\ %{}) do
    %CardSet{}
    |> CardSet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card_set.

  ## Examples

      iex> update_card_set(card_set, %{field: new_value})
      {:ok, %CardSet{}}

      iex> update_card_set(card_set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card_set(%CardSet{} = card_set, attrs) do
    card_set
    |> CardSet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card_set.

  ## Examples

      iex> delete_card_set(card_set)
      {:ok, %CardSet{}}

      iex> delete_card_set(card_set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card_set(%CardSet{} = card_set) do
    Repo.delete(card_set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card_set changes.

  ## Examples

      iex> change_card_set(card_set)
      %Ecto.Changeset{data: %CardSet{}}

  """
  def change_card_set(%CardSet{} = card_set, attrs \\ %{}) do
    CardSet.changeset(card_set, attrs)
  end
end
