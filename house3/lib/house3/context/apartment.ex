defmodule House3.Context.Apartment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apartments" do
    field :name, :string
    field :number_floors, :integer
    has_many :floors, House3.Context.Floor

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(apartment, attrs) do
    apartment
    |> cast(attrs, [:name, :number_floors])
    |> validate_required([:name, :number_floors])
  end
end
