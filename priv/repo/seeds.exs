 NimbleCSV.define(CSV, separator: ";")

defmodule HamburgCityJobs.CSV.Parser do
  alias HamburgCityJobs.JobBoard.Company
  alias HamburgCityJobs.Repo

  def create_seeds_from_file(path) do
    path
    |> File.read!
    |> CSV.parse_string
    |> Enum.map(&build_attributes/1)
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.group_by(&(&1[:name]))
    |> Enum.map(&prepare_company/1)
    |> Enum.each(&create_company/1)
  end

  defp build_attributes(attrs) do
    [name,  _operator,  city,  postcode,  street,  housenumber,  _amenity,  _office,  _shop, geom] = attrs
    address_string = "#{city} #{postcode} #{street} #{housenumber}" |> String.trim() |> String.replace(~r/\s+/, " ")

    if String.length(name) == 0 || String.length(address_string) == 0 do
      %{}
    else
      %{
        name: String.capitalize(name),
        branches: %{
          address: address_string,
          location: Geo.WKB.decode(geom)
        }
      }
    end
  end

  defp prepare_company({company_name, attrs}) do
    branches =
      Enum.reduce(
        attrs,
        [],
        fn(c, acc) -> [Map.take(c.branches, [:address, :location]) | acc] end)

    %{
      name: company_name,
      branches: branches
    }
  end

  defp create_company(attrs) do
    %Company{}
    |> Company.with_branches_changeset(attrs)
    |> Repo.insert!
  end
end

IO.inspect HamburgCityJobs.CSV.Parser.create_seeds_from_file("priv/repo/seed_data.csv")
