defmodule HamburgCityJobs.Factory do
  use ExMachina.Ecto, repo: HamburgCityJobs.Repo
  alias HamburgCityJobs.JobBoard.{Branch, Company, Vacancy}

  def company_factory do
    %Company{
      name: Faker.Company.name()
    }
  end

  def branch_factory do
    %Branch{
      address: Faker.Address.street_address(),
      company: build(:company)
    }
  end

  def vacancy_factory do
    %Vacancy{
      title: Faker.Company.buzzword(),
      description: Faker.Company.bullshit()
    }
  end
end
