defmodule FlashCardsVoiceGeneratorWeb.CardSetLive.FormComponent do
  use FlashCardsVoiceGeneratorWeb, :live_component

  alias FlashCardsVoiceGenerator.CardSets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage card_set records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="card_set-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Card set</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{card_set: card_set} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(CardSets.change_card_set(card_set))
     end)}
  end

  @impl true
  def handle_event("validate", %{"card_set" => card_set_params}, socket) do
    changeset = CardSets.change_card_set(socket.assigns.card_set, card_set_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"card_set" => card_set_params}, socket) do
    save_card_set(socket, socket.assigns.action, card_set_params)
  end

  defp save_card_set(socket, :edit, card_set_params) do
    case CardSets.update_card_set(socket.assigns.card_set, card_set_params) do
      {:ok, card_set} ->
        notify_parent({:saved, card_set})

        {:noreply,
         socket
         |> put_flash(:info, "Card set updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_card_set(socket, :new, card_set_params) do
    case CardSets.create_card_set(card_set_params) do
      {:ok, card_set} ->
        notify_parent({:saved, card_set})

        {:noreply,
         socket
         |> put_flash(:info, "Card set created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
