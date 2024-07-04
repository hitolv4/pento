defmodule PentoWeb.FrequentlyAskedQuestionLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.FAQ

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Use this form to manage question records in your database.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="frequently_asked_question-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input :if={@action == :new} field={@form[:question]} type="text" label="Question" />
        <.input :if={@action == :answer} field={@form[:answer]} type="text" label="Answer" />
        <:actions>
          <.button :if={@action == :new} phx-disable-with="Saving...">Save question</.button>
          <.button :if={@action == :answer} phx-disable-with="Saving...">Save Answer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{frequently_asked_question: frequently_asked_question} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(FAQ.change_frequently_asked_question(frequently_asked_question))
     end)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"frequently_asked_question" => frequently_asked_question_params},
        socket
      ) do
    if socket.assigns.action == :new do
      changeset =
        FAQ.change_question(
          socket.assigns.frequently_asked_question,
          frequently_asked_question_params
        )

      {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    else
      changeset =
        FAQ.change_question(
          socket.assigns.frequently_asked_question,
          frequently_asked_question_params
        )

      {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    end
  end

  def handle_event(
        "save",
        %{"frequently_asked_question" => frequently_asked_question_params},
        socket
      ) do
    save_frequently_asked_question(
      socket,
      socket.assigns.action,
      frequently_asked_question_params
    )
  end

  defp save_frequently_asked_question(socket, :answer, frequently_asked_question_params) do
    case FAQ.update_answer(
           socket.assigns.frequently_asked_question,
           frequently_asked_question_params
         ) do
      {:ok, frequently_asked_question} ->
        notify_parent({:saved, frequently_asked_question})

        {:noreply,
         socket
         |> put_flash(:info, "asked  successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_frequently_asked_question(socket, :new, frequently_asked_question_params) do
    case FAQ.create_frequently_asked_question(frequently_asked_question_params) do
      {:ok, frequently_asked_question} ->
        notify_parent({:saved, frequently_asked_question})

        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
