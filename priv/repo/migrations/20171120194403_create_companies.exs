defmodule HamburgCityJobs.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string

      timestamps()
    end

    create index(:companies, ["lower(name)"], unique: true)
  end
end
