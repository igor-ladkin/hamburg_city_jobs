defmodule HamburgCityJobsWeb.PublicTransportView do
  @moduledoc false

  use HamburgCityJobsWeb, :view

  def render("index.json", %{public_transports: public_transports}) do
    %{data: render_many(public_transports, HamburgCityJobsWeb.PublicTransportView, "public_transport.json", as: :public_transport)}
  end

  def render("public_transport.json", %{public_transport: public_transport}) do
    %{
      id: public_transport.id,
      name: public_transport.name,
      location: serialize_location(public_transport.location),
    }
  end

  defp serialize_location(location) do
    {lng, lat} = location.coordinates
    %{lng: lng, lat: lat}
  end

end
