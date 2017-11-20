defmodule HamburgCityJobs.Factory do
  use ExMachina.Ecto, repo: HamburgCityJobs.Repo
  alias HamburgCityJobs.JobBoard.{Branch, Company}

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
end
