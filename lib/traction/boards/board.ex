defmodule Traction.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boards" do
    field :title, :string
    field :description, :string

    has_many :lists, Traction.Boards.List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
