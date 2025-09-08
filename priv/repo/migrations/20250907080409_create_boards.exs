defmodule Traction.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
