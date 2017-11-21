defmodule HamburgCityJobs.Repo.Migrations.CreateVacancies do
  use Ecto.Migration

  def change do
    create table(:vacancies) do
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
