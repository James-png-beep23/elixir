defmodule House3.Context.Floor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "floors" do
    field :name, :string
    belongs_to :apartment, House3.Context.Apartment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(floor, attrs) do
    floor
    |> cast(attrs, [:name, :apartment_id])
    |> validate_required([:name, :apartment_id])
  end
end
