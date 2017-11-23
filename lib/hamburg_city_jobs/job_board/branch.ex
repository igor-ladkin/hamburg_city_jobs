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
    case String.length(company_name) == 0 do
      true ->
        from b in query,
           preload: :company
      _ ->
        from b in query,
          join: c in assoc(b, :company),
          where: ilike(c.name, ^"%#{company_name}%"),
          preload: [company: c]
    end
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

  @doc """
  Filters branches to be within the passed distance from a public transport stop
  """
  def within_public_transport(query, distance_public_transport) do
    case Float.parse(distance_public_transport) do
      :error -> query
      {distance_public_transport, _} ->
        from b in query,
             where: fragment("exists(SELECT 1 FROM public_transports AS p WHERE ST_DWithin(p.location::geography, ?::geography, ?))", b.location, ^distance_public_transport)
    end
  end
end


