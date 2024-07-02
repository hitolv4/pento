defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(score: 0, message: "Make a guess")
     |> assign(time: time())
     |> assign(number: set_number())
     |> assign(session_id: session["live_socket_id"])
     |> assign(current_user: user)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    if guess != to_string(socket.assigns.number) do
      message = "Your guess: #{guess}. Wrong. Guess again. "
      score = socket.assigns.score - 1

      {
        :noreply,
        socket
        |> assign(
          message: message,
          score: score
        )
        |> assign(time: time())
      }
    else
      message = "You did it"
      score = socket.assigns.score + 1

      {
        :noreply,
        socket
        |> assign(
          message: message,
          score: score
        )
        |> assign(time: time())
        |> put_flash(:info, "You did it")
        |> push_navigate(to: "/guess")
      }
    end
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %> numero <%= @number %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
    text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def set_number() do
    Enum.random(1..10)
  end
end
