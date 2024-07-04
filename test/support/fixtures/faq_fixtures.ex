defmodule Pento.FAQFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.FAQ` context.
  """

  @doc """
  Generate a frequently_asked_question.
  """
  def frequently_asked_question_fixture(attrs \\ %{}) do
    {:ok, frequently_asked_question} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        question: "some question",
        vote: 42
      })
      |> Pento.FAQ.create_frequently_asked_question()

    frequently_asked_question
  end
end
