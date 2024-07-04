defmodule PentoWeb.FrequentlyAskedQuestionLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.FAQFixtures

  @create_attrs %{question: "some question", answer: "some answer", vote: 42}
  @update_attrs %{question: "some updated question", answer: "some updated answer", vote: 43}
  @invalid_attrs %{question: nil, answer: nil, vote: nil}

  defp create_frequently_asked_question(_) do
    frequently_asked_question = frequently_asked_question_fixture()
    %{frequently_asked_question: frequently_asked_question}
  end

  describe "Index" do
    setup [:create_frequently_asked_question]

    test "lists all frequently_asked_question", %{conn: conn, frequently_asked_question: frequently_asked_question} do
      {:ok, _index_live, html} = live(conn, ~p"/frequently_asked_question")

      assert html =~ "Listing Frequently asked question"
      assert html =~ frequently_asked_question.question
    end

    test "saves new frequently_asked_question", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/frequently_asked_question")

      assert index_live |> element("a", "New Frequently asked question") |> render_click() =~
               "New Frequently asked question"

      assert_patch(index_live, ~p"/frequently_asked_question/new")

      assert index_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/frequently_asked_question")

      html = render(index_live)
      assert html =~ "Frequently asked question created successfully"
      assert html =~ "some question"
    end

    test "updates frequently_asked_question in listing", %{conn: conn, frequently_asked_question: frequently_asked_question} do
      {:ok, index_live, _html} = live(conn, ~p"/frequently_asked_question")

      assert index_live |> element("#frequently_asked_question-#{frequently_asked_question.id} a", "Edit") |> render_click() =~
               "Edit Frequently asked question"

      assert_patch(index_live, ~p"/frequently_asked_question/#{frequently_asked_question}/edit")

      assert index_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/frequently_asked_question")

      html = render(index_live)
      assert html =~ "Frequently asked question updated successfully"
      assert html =~ "some updated question"
    end

    test "deletes frequently_asked_question in listing", %{conn: conn, frequently_asked_question: frequently_asked_question} do
      {:ok, index_live, _html} = live(conn, ~p"/frequently_asked_question")

      assert index_live |> element("#frequently_asked_question-#{frequently_asked_question.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#frequently_asked_question-#{frequently_asked_question.id}")
    end
  end

  describe "Show" do
    setup [:create_frequently_asked_question]

    test "displays frequently_asked_question", %{conn: conn, frequently_asked_question: frequently_asked_question} do
      {:ok, _show_live, html} = live(conn, ~p"/frequently_asked_question/#{frequently_asked_question}")

      assert html =~ "Show Frequently asked question"
      assert html =~ frequently_asked_question.question
    end

    test "updates frequently_asked_question within modal", %{conn: conn, frequently_asked_question: frequently_asked_question} do
      {:ok, show_live, _html} = live(conn, ~p"/frequently_asked_question/#{frequently_asked_question}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Frequently asked question"

      assert_patch(show_live, ~p"/frequently_asked_question/#{frequently_asked_question}/show/edit")

      assert show_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#frequently_asked_question-form", frequently_asked_question: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/frequently_asked_question/#{frequently_asked_question}")

      html = render(show_live)
      assert html =~ "Frequently asked question updated successfully"
      assert html =~ "some updated question"
    end
  end
end
