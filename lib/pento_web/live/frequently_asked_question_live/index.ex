defmodule PentoWeb.FrequentlyAskedQuestionLive.Index do
  use PentoWeb, :live_view

  alias Pento.FAQ
  alias Pento.FAQ.FrequentlyAskedQuestion

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :frequently_asked_question_collection, FAQ.list_frequently_asked_question())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :answer, %{"id" => id}) do
    socket
    |> assign(:page_title, "Answer question")
    |> assign(:frequently_asked_question, FAQ.get_frequently_asked_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New question")
    |> assign(:frequently_asked_question, %FrequentlyAskedQuestion{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Frequently asked question")
    |> assign(:frequently_asked_question, nil)
  end

  @impl true
  def handle_info(
        {PentoWeb.FrequentlyAskedQuestionLive.FormComponent, {:saved, frequently_asked_question}},
        socket
      ) do
    {:noreply,
     stream_insert(socket, :frequently_asked_question_collection, frequently_asked_question)}
  end

  @impl true

  def handle_event("vote", %{"id" => id}, socket) do
    frequently_asked_question = FAQ.get_frequently_asked_question!(id)

    if frequently_asked_question.answer == nil do
      {:noreply,
       socket
       |> put_flash(:error, "question must have answer to vote")
       |> push_navigate(to: ~p"/frequently_asked_question")}
    else
      if frequently_asked_question.vote == nil do
        vote = 0
        FAQ.update_vote(frequently_asked_question, %{"vote" => vote + 1})

        {:noreply,
         socket
         |> put_flash(:info, "voted")
         |> push_navigate(to: ~p"/frequently_asked_question")}
      else
        FAQ.update_vote(frequently_asked_question, %{"vote" => frequently_asked_question.vote + 1})

        {:noreply,
         socket
         |> put_flash(:info, "voted")
         |> push_navigate(to: ~p"/frequently_asked_question")}
      end
    end
  end
end
