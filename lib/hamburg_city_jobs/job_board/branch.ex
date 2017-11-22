defmodule HamburgCityJobs.JobBoard.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias HamburgCityJobs.JobBoard.{Branch, BranchVacancy, Company, Vacancy}


  schema "branches" do
    field :address, :string
    field :location, Geo.Point

    belongs_to :company, Company
    many_to_many :vacancies, Vacancy, join_through: BranchVacancy

    timestamps()
  end

  @doc false
  def changeset(%Branch{} = branch, attrs) do
    branch
    |> cast(attrs, [:address, :location])
    |> validate_required([:address])
    |> assoc_constraint(:company)
  end

  @doc """
  Preloads vacancies.
  """
  def with_vacancies do
    Branch |> preload(:vacancies)
  end
end
