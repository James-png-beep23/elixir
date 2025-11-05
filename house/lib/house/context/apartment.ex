defmodule House.Context.Apartment do
  use Ecto.Schema
  import Ecto.Changeset



  schema "apartment" do
    field :name, :string
    field :location, :string
    field :type, :string
    field :number_floors, :integer
    field :price, :decimal
    has_many :levels, Context.Level

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(apartment, attrs) do
    apartment
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
