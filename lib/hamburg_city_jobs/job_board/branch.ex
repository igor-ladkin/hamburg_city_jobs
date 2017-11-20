defmodule HamburgCityJobs.JobBoard.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  alias HamburgCityJobs.JobBoard.{Branch, Company}


  schema "branches" do
    field :address, :string
    field :location, Geo.Geometry

    belongs_to :company, Company

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
