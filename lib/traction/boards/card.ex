defmodule Traction.Boards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cards" do
    field :title, :string
    field :description, :string
    field :position, :integer
    field :list_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :position])
    |> validate_required([:title, :description, :position])
  end
end
