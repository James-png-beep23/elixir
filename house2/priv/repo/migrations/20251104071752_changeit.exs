defmodule House2.Repo.Migrations.Changeit do
  use Ecto.Migration

  def change do
    alter table(:floor) do
      add :apartment_id, references(:apartments, on_delete: :delete_all)
    end

  end
end
