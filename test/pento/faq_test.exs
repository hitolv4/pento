defmodule Pento.FAQTest do
  use Pento.DataCase

  alias Pento.FAQ

  describe "frequently_asked_question" do
    alias Pento.FAQ.FrequentlyAskedQuestion

    import Pento.FAQFixtures

    @invalid_attrs %{question: nil, answer: nil, vote: nil}

    test "list_frequently_asked_question/0 returns all frequently_asked_question" do
      frequently_asked_question = frequently_asked_question_fixture()
      assert FAQ.list_frequently_asked_question() == [frequently_asked_question]
    end

    test "get_frequently_asked_question!/1 returns the frequently_asked_question with given id" do
      frequently_asked_question = frequently_asked_question_fixture()
      assert FAQ.get_frequently_asked_question!(frequently_asked_question.id) == frequently_asked_question
    end

    test "create_frequently_asked_question/1 with valid data creates a frequently_asked_question" do
      valid_attrs = %{question: "some question", answer: "some answer", vote: 42}

      assert {:ok, %FrequentlyAskedQuestion{} = frequently_asked_question} = FAQ.create_frequently_asked_question(valid_attrs)
      assert frequently_asked_question.question == "some question"
      assert frequently_asked_question.answer == "some answer"
      assert frequently_asked_question.vote == 42
    end

    test "create_frequently_asked_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FAQ.create_frequently_asked_question(@invalid_attrs)
    end

    test "update_frequently_asked_question/2 with valid data updates the frequently_asked_question" do
      frequently_asked_question = frequently_asked_question_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer", vote: 43}

      assert {:ok, %FrequentlyAskedQuestion{} = frequently_asked_question} = FAQ.update_frequently_asked_question(frequently_asked_question, update_attrs)
      assert frequently_asked_question.question == "some updated question"
      assert frequently_asked_question.answer == "some updated answer"
      assert frequently_asked_question.vote == 43
    end

    test "update_frequently_asked_question/2 with invalid data returns error changeset" do
      frequently_asked_question = frequently_asked_question_fixture()
      assert {:error, %Ecto.Changeset{}} = FAQ.update_frequently_asked_question(frequently_asked_question, @invalid_attrs)
      assert frequently_asked_question == FAQ.get_frequently_asked_question!(frequently_asked_question.id)
    end

    test "delete_frequently_asked_question/1 deletes the frequently_asked_question" do
      frequently_asked_question = frequently_asked_question_fixture()
      assert {:ok, %FrequentlyAskedQuestion{}} = FAQ.delete_frequently_asked_question(frequently_asked_question)
      assert_raise Ecto.NoResultsError, fn -> FAQ.get_frequently_asked_question!(frequently_asked_question.id) end
    end

    test "change_frequently_asked_question/1 returns a frequently_asked_question changeset" do
      frequently_asked_question = frequently_asked_question_fixture()
      assert %Ecto.Changeset{} = FAQ.change_frequently_asked_question(frequently_asked_question)
    end
  end
end
