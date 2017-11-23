defmodule HamburgCityJobsWeb.SearchView do
  use HamburgCityJobsWeb, :view

  def render("index.json", %{branches: branches}) do
    %{data: render_many(branches, HamburgCityJobsWeb.SearchView, "branch.json", as: :branch)}
  end

  def render("branch.json", %{branch: branch}) do
    %{
      company: branch.company.name,
      address: branch.address,
      location: serialize_location(branch.location),
    }
  end

  defp serialize_location(location) do
    {lng, lat} = location.coordinates
    %{lng: lng, lat: lat}
  end
end
