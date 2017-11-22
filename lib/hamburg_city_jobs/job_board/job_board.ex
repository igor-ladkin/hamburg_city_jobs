defmodule HamburgCityJobs.JobBoard do
  @moduledoc """
  The JobBoard context.
  """

  import Ecto.Query, warn: false
  alias HamburgCityJobs.Repo

  alias HamburgCityJobs.JobBoard.{Branch, Company, Vacancy}

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Returns the list of branches for particular company.
  """
  def list_company_branches(%Company{} = company) do
    Ecto.assoc(company, :branches) |> Repo.all
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not esist.
  """
  def get_branch!(id, query \\ Branch), do: Repo.get!(query, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new branch for particular company.
  """
  def create_company_branch(%Company{} = company, attrs \\ %{}) do
    Ecto.build_assoc(company, :branches)
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Associate passed vacancies with a particular branch.
  """
  def add_vacancies_to_branch(%Branch{id: id}, vacancies \\ []) do
    vacancies = List.wrap(vacancies)

    get_branch!(id, Branch.with_vacancies)
    |> Branch.changeset(%{})
    |> Ecto.Changeset.put_assoc(:vacancies, vacancies, on_replace: :update)
    |> Repo.update()
  end

  @doc """
  Creates new vacancy
  """
  def create_vacancy(attrs \\ %{}) do
    %Vacancy{}
    |> Vacancy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end
end
