defmodule HamburgCityJobsWeb.SearchView do
  use HamburgCityJobsWeb, :view

  def render("index.json", _args) do
    %{data: "some branches"}
  end
end
