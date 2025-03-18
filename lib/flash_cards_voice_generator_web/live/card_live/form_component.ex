defmodule FlashCardsVoiceGeneratorWeb.CardLive.FormComponent do
  use FlashCardsVoiceGeneratorWeb, :live_component

  alias FlashCardsVoiceGenerator.Cards
  alias FlashCardsVoiceGenerator.CardSets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage card records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="card-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:text]} type="text" label="Text" />

        <.input
          field={@form[:card_set_id]}
          type="select"
          label="Card Set"
          prompt="Select a card set"
          options={Enum.map(@card_sets, &{&1.name, &1.id})}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Card</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{card: card} = assigns, socket) do
    card_sets = CardSets.list_card_sets() # Fetch the card sets

    card =
      if is_nil(card.card_set_id) and card_sets != [] do
        %{card | card_set_id: hd(card_sets).id}
      else
        card
      end

      changeset = Cards.change_card(card)

      {:ok,
       socket
       |> assign(assigns)
       |> assign(:card_sets, card_sets)
       |> assign_new(:form, fn ->
         to_form(changeset)
       end)}
  end

  @impl true
  def handle_event("validate", %{"card" => card_params}, socket) do
    changeset = Cards.change_card(socket.assigns.card, card_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"card" => card_params}, socket) do
    save_card(socket, socket.assigns.action, card_params)
  end

  defp save_card(socket, :edit, card_params) do
    case Cards.update_card(socket.assigns.card, card_params) do
      {:ok, card} ->
        notify_parent({:saved, card})

        {:noreply,
         socket
         |> put_flash(:info, "Card updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_card(socket, :new, card_params) do
    case Cards.create_card(card_params) do
      {:ok, card} ->
        notify_parent({:saved, card})

        {:noreply,
         socket
         |> put_flash(:info, "Card created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
