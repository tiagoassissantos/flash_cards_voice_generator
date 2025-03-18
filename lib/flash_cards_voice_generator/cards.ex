defmodule FlashCardsVoiceGenerator.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias FlashCardsVoiceGenerator.Repo
  alias FlashCardsVoiceGenerator.Cards.Card
  alias TTS.Runner
  alias Integrations.AnkiClient

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    audio_filename = "audio_#{UUID.uuid4()}.wav"
    audio_dir = "priv/static/audio"
    audio_path = Path.join([audio_dir, audio_filename])
    File.mkdir_p!(audio_dir)

    attrs = Map.put(attrs, "audio_file_path", audio_path)

    changeset = %Card{}
      |> Card.changeset(attrs)

    Repo.transaction(fn repo ->
      case repo.insert(changeset) do
        {:ok, card} ->
          case Runner.run(card.text, audio_path) do
            :ok ->
              case AnkiClient.create_card(card.text, audio_path) do
                {:ok, _message} -> {:ok, card}
                {:error, reason} ->
                  repo.rollback({:error, "TTS Failed: #{reason}"})
                  File.rm(audio_path)
              end
            {:error, reason} ->
              repo.rollback({:error, "TTS Failed: #{reason}"})
          end
        {:error, changeset} ->
          {:error, changeset}
      end
    end)
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    if Map.has_key?(attrs, :text) do
      audio_filename = "audio_#{UUID.uuid4()}.wav"
      audio_dir = "priv/static/audio"
      audio_path = Path.join([audio_dir, audio_filename])
      File.mkdir_p!(audio_dir)

      attrs = Map.put(attrs, :audio_file_path, audio_path)

      changeset = card
        |> Card.changeset(attrs)

      Repo.transaction(fn repo ->
        case repo.update(changeset) do
          {:ok, updated_card} ->
            case Runner.run(updated_card.text, audio_path) do
              :ok ->
                case AnkiClient.create_card(card.text, audio_path) do
                  {:ok, _message} -> {:ok, updated_card}
                  {:error, reason} -> repo.rollback({:error, "TTS Failed: #{reason}"})
                end
                #if card.audio_file_path && File.exists?(card.audio_file_path) do
                #  File.rm(card.audio_file_path)
                #end
              {:error, reason} ->
                repo.rollback({:error, "TTS Failed: #{reason}"})
            end
          {:error, changeset} ->
            {:error, changeset}
        end
      end)

    else
      card
      |> Card.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.transaction(fn repo ->
      case repo.delete(card) do
        {:ok, deleted_card} ->
          if deleted_card.audio_file_path && File.exists?(deleted_card.audio_file_path) do
            File.rm(deleted_card.audio_file_path)
          end
          {:ok, deleted_card}
        {:error, changeset} ->
           repo.rollback({:error, "Card deletion Failed: #{inspect(changeset)}"})
      end
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end
end
