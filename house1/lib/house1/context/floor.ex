defmodule House1.Context.Floor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "floors" do
    field :name, :string
    field :number_units, :integer
    belongs_to :apartment, House1.Context.Apartment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(floor, attrs) do
    floor
    |> cast(attrs, [:name, :number_units, :apartment_id])
    |> validate_required([:name, :number_units, :apartment_id])
  end
end
