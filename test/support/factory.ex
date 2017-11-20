defmodule HamburgCityJobs.Factory do
  use ExMachina.Ecto, repo: HamburgCityJobs.Repo
  alias HamburgCityJobs.JobBoard.Company

  def company_factory do
    %Company{
      name: Faker.Company.name()
    }
  end
end
