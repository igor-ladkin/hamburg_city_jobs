defmodule HamburgCityJobs.JobBoard.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  import Geo.PostGIS
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

  @doc """
  Fetches branches with company name similar to passed param.
  """
  def with_company_like(query, company_name) do
    from b in query,
      join: c in assoc(b, :company),
      where: ilike(c.name, ^"%#{company_name}%"),
      preload: [company: c]
  end

  @doc """
  Fetches branches within the passed radius from the current target location
  """
  def within_distance(query, %{"lng" => lng, "lat" => lat}, radius) do
    case Float.parse(radius) do
      :error -> query
      {radius, _} ->
        location = %Geo.Point{srid: 4326, coordinates: {lng, lat}}

        from b in query,
          where: st_dwithin(fragment("?::geography", b.location), fragment("?::geography", ^location), ^radius)
    end
  end
end
