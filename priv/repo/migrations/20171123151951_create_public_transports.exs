defmodule HamburgCityJobs.Repo.Migrations.CreatePublicTransports do
  use Ecto.Migration

  def change do
    create table(:public_transports) do
      add :name, :string
      add :operator, :string
      add :network, :string
      add :wheelchair, :string
      add :location, :geometry

      timestamps()
    end

  end
end
