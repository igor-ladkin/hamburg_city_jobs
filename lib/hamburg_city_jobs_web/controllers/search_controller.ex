defmodule HamburgCityJobsWeb.SearchController do
  use HamburgCityJobsWeb, :controller
  alias HamburgCityJobs.JobBoard

  def index(conn, _params) do
    branches = JobBoard.fetch_branches()
    render conn, "index.json", branches: branches
  end
end
