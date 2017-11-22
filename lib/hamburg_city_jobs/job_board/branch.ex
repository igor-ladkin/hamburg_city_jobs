defmodule HamburgCityJobs.JobBoard.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  alias HamburgCityJobs.JobBoard.{Branch, BranchVacancy, Company, Vacancy}


  schema "branches" do
    field :address, :string
    field :location, Geo.Geometry

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
end
