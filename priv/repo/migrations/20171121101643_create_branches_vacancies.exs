defmodule HamburgCityJobs.Repo.Migrations.CreateBranchesVacancies do
  use Ecto.Migration

  def change do
    create table(:branches_vacancies) do
      add :branch_id, references(:branches, on_delete: :delete_all)
      add :vacancy_id, references(:vacancies, on_delete: :delete_all)

      timestamps()
    end

    create index(:branches_vacancies, [:branch_id])
    create index(:branches_vacancies, [:vacancy_id])
  end
end
