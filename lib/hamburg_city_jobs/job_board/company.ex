defmodule HamburgCityJobs.JobBoard.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias HamburgCityJobs.JobBoard.Company


  schema "companies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Company{} = company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "companies_lower_name_index")
  end
end
