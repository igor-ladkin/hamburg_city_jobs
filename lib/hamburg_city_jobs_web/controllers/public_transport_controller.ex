defmodule HamburgCityJobsWeb.PublicTransportController do
  @moduledoc false
  use HamburgCityJobsWeb, :controller
  alias HamburgCityJobs.JobBoard

  def index(conn, _params) do
    public_transports = JobBoard.list_public_transports()

    render conn, "index.json", public_transports: public_transports
  end


end
