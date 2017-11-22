defmodule HamburgCityJobs.JobBoardTest do
  use HamburgCityJobs.DataCase
  import HamburgCityJobs.Factory

  alias HamburgCityJobs.JobBoard

  describe "companies" do
    alias HamburgCityJobs.JobBoard.Company

    test "list_companies/0 returns all companies" do
      company = insert(:company)
      assert JobBoard.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = insert(:company)
      assert JobBoard.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      company_attrs = params_for(:company)
      assert {:ok, %Company{} = company} = JobBoard.create_company(company_attrs)
      assert company.name == company_attrs.name
    end

    test "create_company/1 does not allow to create the company with the same name but different case" do
      company_attrs = params_for(:company, name: "CityJobs")
      duplicated_attrs = params_for(:company, name: "CITYJOBS")

      assert {:ok, _} = JobBoard.create_company(company_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = JobBoard.create_company(duplicated_attrs)

      name_errors = format_errors(changeset).name
      assert Enum.find(name_errors, fn errors -> errors == "has already been taken" end)
    end

    test "create_company/1 with invalid data returns error changeset" do
      company_attrs = params_for(:company, name: nil)
      assert {:error, %Ecto.Changeset{}} = JobBoard.create_company(company_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = insert(:company)
      update_params = %{name: Faker.Company.name()}

      assert {:ok, company} = JobBoard.update_company(company, update_params)
      assert %Company{} = company
      assert company.name == update_params.name
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = insert(:company)
      update_params = %{name: nil}

      assert {:error, %Ecto.Changeset{}} = JobBoard.update_company(company, update_params)
      assert company == JobBoard.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = insert(:company)
      assert {:ok, %Company{}} = JobBoard.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> JobBoard.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = build(:company)
      assert %Ecto.Changeset{} = JobBoard.change_company(company)
    end
  end

  describe "branches" do
    alias HamburgCityJobs.JobBoard.Branch

    setup do
      company = insert(:company)
      {:ok, company: company}
    end

    test "list_company_banches/1 return all branches for the company", %{company: company} do
      [branch_1, branch_2] = insert_pair(:branch, %{company: company})
      fetched_branches = JobBoard.list_company_branches(company)

      assert length(fetched_branches) == 2
      assert Enum.find(fetched_branches, &(&1.id == branch_1.id))
      assert Enum.find(fetched_branches, &(&1.id == branch_2.id))
    end

    test "list_company_branches/1 does not include branches from the other companies", %{company: company} do
      foreign_branch = insert(:branch)
      refute Enum.find(JobBoard.list_company_branches(company), &(&1.id == foreign_branch.id))
    end

    test "create_company_branch/2 with valid data creates a company's branch", %{company: company} do
      branch_attrs = params_for(:branch, %{company: nil})

      assert {:ok, %Branch{} = branch} = JobBoard.create_company_branch(company, branch_attrs)
      assert branch.address == branch_attrs.address
      assert branch.company_id == company.id
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = insert(:branch)
      fetched_branch = JobBoard.get_branch!(branch.id)

      assert fetched_branch.id == branch.id
      assert fetched_branch.address == branch.address
      assert fetched_branch.company_id == branch.company_id
    end

    test "get_branch!/1 raises an error if the correct branch was not found" do
      assert_raise Ecto.NoResultsError, ~r/expected at least one result/, fn -> JobBoard.get_branch!(42) end
    end

  describe "vacancies" do
    alias HamburgCityJobs.JobBoard.Vacancy

    test "create_vacancy/1 with a valid data creates a vacancy" do
      vacancy_attrs = params_for(:vacancy)

      assert {:ok, %Vacancy{} = vacancy} = JobBoard.create_vacancy(vacancy_attrs)
      assert vacancy.title  == vacancy_attrs.title
      assert vacancy.description == vacancy_attrs.description
    end

    test "create_vacancy/1 with invalid data returns error changeset" do
      vacancy_attrs = params_for(:vacancy, title: nil)
      assert {:error, %Ecto.Changeset{}} = JobBoard.create_vacancy(vacancy_attrs)
    end
  end

  # HELPERS

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
