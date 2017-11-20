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
      company_attrs = params_for(:company, %{name: "CityJobs"})
      duplicated_attrs = params_for(:company, %{name: "CITYJOBS"})

      assert {:ok, _} = JobBoard.create_company(company_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = JobBoard.create_company(duplicated_attrs)

      name_errors = format_errors(changeset).name
      assert Enum.find(name_errors, fn errors -> errors == "has already been taken" end)
    end

    test "create_company/1 with invalid data returns error changeset" do
      company_attrs = params_for(:company, %{name: nil})
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

    defp format_errors(changeset) do
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
    end
  end
end
