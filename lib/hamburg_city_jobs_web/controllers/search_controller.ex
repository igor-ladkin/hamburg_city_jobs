defmodule HamburgCityJobsWeb.SearchController do
  use HamburgCityJobsWeb, :controller

  def index(conn, _params) do
    # fetch branches
    render conn, "index.json"# branches: branches
  end
end
