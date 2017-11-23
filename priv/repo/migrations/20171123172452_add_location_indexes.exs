defmodule HamburgCityJobs.Repo.Migrations.AddLocationIndexes do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX branch_location_index ON branches USING GIST(location);"
    execute "CREATE INDEX public_transport_location_index ON public_transports USING GIST(location);"

  end

  def down do
    execute "DROP INDEX IF EXISTS public_transport_location_index;"
    execute "DROP INDEX IF EXISTS branch_location_index;"
  end

end
