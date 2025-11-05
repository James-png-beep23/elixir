defmodule House3.Repo.Migrations.CreateApartments do
  use Ecto.Migration

  def change do
    create table(:apartments) do
      add :name, :string
      add :number_floors, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
