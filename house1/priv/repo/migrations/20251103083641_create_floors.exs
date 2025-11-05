defmodule House1.Repo.Migrations.CreateFloors do
  use Ecto.Migration

  def change do
    create table(:floors) do
      add :name, :string
      add :number_units, :integer
      add :apartment_id, references(:apartments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:floors, [:apartment_id])
  end
end
