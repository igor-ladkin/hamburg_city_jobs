defmodule HamburgCityJobsWeb.SearchController do
  use HamburgCityJobsWeb, :controller
  alias HamburgCityJobs.JobBoard

  def index(conn, %{"companyName" => company_name, "radius" => radius, "targetPosition" => target_position}) do
    branches = JobBoard.fetch_branches(%{
      company_name: company_name,
      location: target_position,
      radius: radius,
    })
    
    render conn, "index.json", branches: branches
  end
end
