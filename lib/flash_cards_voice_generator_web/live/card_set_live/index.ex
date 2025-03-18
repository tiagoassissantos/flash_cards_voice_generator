defmodule FlashCardsVoiceGeneratorWeb.CardSetLive.Index do
  use FlashCardsVoiceGeneratorWeb, :live_view

  alias FlashCardsVoiceGenerator.CardSets
  alias FlashCardsVoiceGenerator.CardSets.CardSet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :card_sets, CardSets.list_card_sets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Card set")
    |> assign(:card_set, CardSets.get_card_set!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Card set")
    |> assign(:card_set, %CardSet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Card sets")
    |> assign(:card_set, nil)
  end

  @impl true
  def handle_info({FlashCardsVoiceGeneratorWeb.CardSetLive.FormComponent, {:saved, card_set}}, socket) do
    {:noreply, stream_insert(socket, :card_sets, card_set)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    card_set = CardSets.get_card_set!(id)
    {:ok, _} = CardSets.delete_card_set(card_set)

    {:noreply, stream_delete(socket, :card_sets, card_set)}
  end
end
