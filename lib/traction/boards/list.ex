defmodule Traction.Boards.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do
    field :title, :string
    field :position, :integer

    belongs_to :board, Traction.Boards.Board

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :position, :board_id])
    |> validate_required([:title, :position, :board_id])
  end
end
