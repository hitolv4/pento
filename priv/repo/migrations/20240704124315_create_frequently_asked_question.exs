defmodule Pento.Repo.Migrations.CreateFrequentlyAskedQuestion do
  use Ecto.Migration

  def change do
    create table(:frequently_asked_question) do
      add :question, :string
      add :answer, :string
      add :vote, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
