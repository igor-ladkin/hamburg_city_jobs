defmodule HamburgCityJobsWeb.SearchController do
  use HamburgCityJobsWeb, :controller
  alias HamburgCityJobs.JobBoard

  def index(conn, %{"companyName" => company_name, "radius" => radius, "targetPosition" => target_position, "distancePT" => distance_public_transport}) do
    branches = JobBoard.fetch_branches(%{
      company_name: company_name,
      location: target_position,
      radius: radius,
      distance_public_transport: distance_public_transport,
    })
    
    render conn, "index.json", branches: branches
  end
end
