defmodule House.Context.Level do
  use Ecto.Schema
  import Ecto.Changeset

  schema "levels" do
    field :name, :string
    field :number_units, :integer
    belongs_to :apartment, Context.Apartment
    has_many :units, Context.Unit


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(level, attrs) do
    level
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
