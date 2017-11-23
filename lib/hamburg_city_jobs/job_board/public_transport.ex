defmodule HamburgCityJobs.JobBoard.PublicTransport do
  use Ecto.Schema
  import Ecto.Changeset
  import Geo.PostGIS

  alias HamburgCityJobs.JobBoard.PublicTransport


  schema "public_transports" do
    field :name, :string
    field :network, :string
    field :operator, :string
    field :wheelchair, :string, default: "no"
    field :location, Geo.Point

    timestamps()
  end

  @doc false
  def changeset(%PublicTransport{} = public_transport, attrs) do
    public_transport
    |> cast(attrs, [:name, :operator, :network, :wheelchair, :location])
    |> validate_required([:name, :location])
  end
end
