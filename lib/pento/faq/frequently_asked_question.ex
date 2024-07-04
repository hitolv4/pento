defmodule Pento.FAQ.FrequentlyAskedQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frequently_asked_question" do
    field :question, :string
    field :answer, :string
    field :vote, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(frequently_asked_question, attrs) do
    frequently_asked_question
    |> cast(attrs, [:question, :answer, :vote])
    |> validate_required([:question, :answer, :vote])
  end

  def changeset_question(frequently_asked_question, attrs) do
    frequently_asked_question
    |> cast(attrs, [:question])
    |> validate_required([:question])
  end

  def changeset_answer(frequently_asked_question, attrs) do
    frequently_asked_question
    |> cast(attrs, [:answer])
    |> validate_required([:answer])
  end

  def changeset_vote(frequently_asked_question, attrs) do
    frequently_asked_question
    |> cast(attrs, [:vote])
    |> validate_required([:vote])
  end
end
