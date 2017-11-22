defmodule HamburgCityJobs.Repo.Migrations.CreateBranches do
  use Ecto.Migration

  def change do
    create table(:branches) do
      add :address, :string
      add :location, :geometry
      add :company_id, references(:companies, on_delete: :delete_all)

      timestamps()
    end

    create index(:branches, [:company_id])
  end
end
