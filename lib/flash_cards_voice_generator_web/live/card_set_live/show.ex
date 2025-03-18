defmodule FlashCardsVoiceGeneratorWeb.CardSetLive.Show do
  use FlashCardsVoiceGeneratorWeb, :live_view

  alias FlashCardsVoiceGenerator.CardSets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:card_set, CardSets.get_card_set!(id))}
  end

  defp page_title(:show), do: "Show Card set"
  defp page_title(:edit), do: "Edit Card set"
end
