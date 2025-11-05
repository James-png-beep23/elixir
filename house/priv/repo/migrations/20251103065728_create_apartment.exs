defmodule House.Repo.Migrations.CreateApartment do
  use Ecto.Migration

  def change do
    create table(:apartment) do
      add :name, :string
      add :location, :string
      add :type, :string
      add :number_floors, :integer
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
