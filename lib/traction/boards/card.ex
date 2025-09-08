defmodule Traction.Boards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cards" do
    field :title, :string
    field :description, :string
    field :position, :integer

    belongs_to :list, Traction.Boards.List

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :position, :list_id])
    |> validate_required([:title, :description, :position, :list_id])
  end
end
