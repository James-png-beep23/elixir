defmodule House2.Repo.Migrations.CreateFloor do
  use Ecto.Migration

  def change do
    create table(:floor) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
