defmodule HamburgCityJobs.JobBoard.Vacancy do
  use Ecto.Schema
  import Ecto.Changeset
  alias HamburgCityJobs.JobBoard.{Branch, BranchVacancy, Vacancy}


  schema "vacancies" do
    field :description, :string
    field :title, :string

    many_to_many :branches, Branch, join_through: BranchVacancy

    timestamps()
  end

  @doc false
  def changeset(%Vacancy{} = vacancy, attrs) do
    vacancy
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
