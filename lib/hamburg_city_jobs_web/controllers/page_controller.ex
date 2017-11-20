defmodule HamburgCityJobsWeb.PageController do
  use HamburgCityJobsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
