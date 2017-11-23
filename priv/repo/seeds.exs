 NimbleCSV.define(CSV, separator: ";")
 alias HamburgCityJobs.JobBoard.{Company, PublicTransport}
 alias HamburgCityJobs.Repo
defmodule HamburgCityJobs.CSV.Parser do

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

defmodule HamburgCityJobs.CSV.PublicTranportParser do

   def create_seeds_from_file(path) do
     path
     |> File.read!
     |> CSV.parse_string
     |> Enum.map(&build_attributes/1)
     |> Enum.reject(&Enum.empty?/1)
     |> Enum.each(&create_public_transport/1)
   end

   defp build_attributes(attrs) do
     [name, operator, network, wheelchair, geom] = attrs

     if String.length(name) == 0 do
       %{}
     else
       %{
         name: String.capitalize(name),
         operator: String.capitalize(operator),
         network: String.capitalize(network),
         wheelchair: wheelchair,
         location: Geo.WKB.decode(geom)
       }
     end
   end

   defp create_public_transport(attrs) do
     %PublicTransport{}
     |> PublicTransport.changeset(attrs)
     |> Repo.insert!
   end

 end

IO.inspect HamburgCityJobs.CSV.Parser.create_seeds_from_file("priv/repo/seed_data.csv")
IO.inspect HamburgCityJobs.CSV.PublicTranportParser.create_seeds_from_file("priv/repo/public_transport_seed_data.csv")

