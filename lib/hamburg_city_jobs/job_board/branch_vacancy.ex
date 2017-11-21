defmodule HamburgCityJobs.JobBoard.BranchVacancy do
  use Ecto.Schema
  import Ecto.Changeset
  alias HamburgCityJobs.JobBoard.{Branch, BranchVacancy, Vacancy}


  schema "branches_vacancies" do
    belongs_to :branch, Branch
    belongs_to :vacancy, Vacancy

    timestamps()
  end

  @doc false
  def changeset(%BranchVacancy{} = branch_vacancy, attrs) do
    branch_vacancy
    |> cast(attrs, [])
    |> validate_required([])
    |> assoc_constraint(:branch)
    |> assoc_constraint(:vacancy)
  end
end
