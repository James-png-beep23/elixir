defmodule House1.Context.Apartment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apartments" do
    field :name, :string
     field :location, :string
      field :number_floors, :integer
      field :type, :string
      field :price, :integer
      has_many :floors, House1.Context.Floor

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(apartment, attrs) do
    apartment
    |> cast(attrs, [:name, :location, :number_floors, :type, :price])
    |> validate_required([:name, :location, :type])
    |> validate_conditional_fields()
  end

 defp validate_conditional_fields(changeset) do
  case get_field(changeset, :type) do
    "rental" ->
      validate_required(changeset, [:number_floors])

    _ ->
      validate_required(changeset, [:price, :number_floors])
  end
end
end
