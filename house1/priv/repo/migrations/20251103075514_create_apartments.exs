defmodule House1.Repo.Migrations.CreateApartments do
  use Ecto.Migration

  def change do
    create table(:apartments) do
      add :name, :string
      add :location, :string
      add :number_floors, :integer
      add :type, :string
      add :price, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

