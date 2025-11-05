defmodule House.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string
      add :level_id, references(:levels, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:units, :level_id )
  end
end
