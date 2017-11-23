# CityJobs

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Get started after pulling the project
* Get a postgis DB running (not in scope here, sorry) 
* `mix ecto.migrate` to create databases

## Getting OSM data into your postGIS DB
We can import data from the OpenStreetMap project into out database via [osmosis](https://wiki.openstreetmap.org/wiki/Osmosis)(install it e.g. from `brew)
This guide assumes that you already have a user and a database created. For using it with OSM and PostGIS you need to [set it up](https://wiki.openstreetmap.org/wiki/Osmosis/PostGIS_Setup#Create_and_Initialise_Database) accordingly.
```
psql -d <DB> 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'
psql -d <DB> -f osmosis_dir/script/pgsnapshot_schema_0.6.sql
```

First download the requires dataset from e.g. [Geofabrik](http://download.geofabrik.de/europe/germany/hamburg.html) - 
in this project we used the dataset for [Hamburg](http://download.geofabrik.de/europe/germany/hamburg-latest.osm.pbf).

You can then import the `pbf` file into your database:
`osmosis --read-pbf ../path/to/hamburg-latest.osm.pbf --log-progress --write-pgsql host="localhost" user="postgres" password="mypassword" database=mydb`

When the import is successful this statement extracts the company data and the public transport stops we are looking for to a `csv` we then use for further processing:
```postgresql
COPY (SELECT tags->'name' AS Name, tags->'operator' AS Operator, tags->'addr:city' AS City, tags->'addr:postcode' AS Postcode,
tags->'addr:street' AS Street ,tags->'addr:housenumber' AS Housenumber,
tags->'amenity' AS Amenity, tags->'office' AS Office, tags->'shop' AS Shop, geom AS geom
 FROM nodes 
 WHERE tags->'amenity'='restaurant' OR tags->'amenity'='cafe'
  OR tags->'amenity'='bar' OR tags->'amenity'='fast_food' 
  OR tags->'amenity'='pharmacy' OR tags->'amenity'='doctors' OR tags->'amenity'='hospital' OR tags->'amenity'='bank' 
  OR tags->'office' in ('travel_agency','moving_company','religion','guide','tax_advisor','healer','publisher','ngo','psychologist','foundation','notary','yes','webdesign','advertising_agency','employment_agency','company','shipping_company','government','newspaper','facility_management','bank','architect','educational_institution','lawyer','insurance','social_facility','Digital_Agency','political_party','Entertainment','printing_press','research','marketing','travel_agent','accountant','therapist','design','physician','nursing_service','advertising agency','association','film_production','advertising','logistics','forestry','event_management','estate_agent','coworking','telecommunication','club','engineer','advice_centre','it','administrative')
  OR tags->'shop' in ('newsagent','greengrocer','hearing_aids','travel_agency','umbrella','shoe_repair;keyservice','chocolate','Schiffszimmerergenossenschaft','camera','cooking,_books,_gallery,_events','winter garden','suitcase','seafood','optician','shoes','printing_ink','mall','fishing','gift','HafenCityStudios','other','electrics','photo','betting','chandler','fabrics;sewing_machines','carpet','Divers','pastry','tea','doityourself','toys','bakery','bakery;kiosk;cafe','atelier','service','grave_stone','stamps','glaziery','baby_carriage','japan_goods','asia','sewing','lingerie','tiles','pipe','yes','sauna','discount','car','car_repair','music','pet','department_store','pet_food','boutique','Internet','safe','computer','Fahrradreisen','bookmaker','alteration_service','chemist','video_games','fishmonger','unattended','weapons','fashion','butcher','mobile_phone','hairdressing_supplies','paint','ticket','kiosk','hats','paramedical','diverses','erotic','trophy','design,_presents','locks','tyres','heating_oil','curtain','video','interior_decoration','orthopedy','hairdresser','free','solarium','food','hifi','sports','Markisen','comic','medical_supply','bicycle','shoe_repair','bed','clothes','interior design','ice_cream','stationery','appliance','papers','general','motorcycle','books','frame','rental','tattoo','hardware','collector','sanitary','window_blinds','motorcycle_repair','caravan','nutritional_supplements','espresso_machines','massage','nutrition_supplements','gambling','rope','charity','physiotherapist','window_blind','travel_agent','copyshop','car_trailer','news_agent','salon','hat','art','confectionery','textiles','sport_food','wine','wholesale','design','laundry','perfumery','storage_rental','tailor','lottery','model','organic','floor','beekeeper','photo_studio','art_supplies','garden_centre','Türkische_Lebensmittel','deli','cosmetics','soap','musical_instrument','funeral_directors','locksmith','florist','garden_centre','Türkische_Lebensmittel','deli','cosmetics','soap','musical_instrument','funeral_directors','locksmith','florist','dry_cleaning','sulky','garden_furniture','supermarket','accessoires','kitchen','dry_shop','underwear','headshop','ship_chandler','cheese','antiques','telephone','coffee','croque','scuba_diving','furnace','alcohol','houseware','jewelry','beauty','craft','tobacco','outdoor','bag','e-cigarette','kiosk;ticket','leather','estate_agent','fish','tile','pawnbroker','sports_nutrition','nuts_raisins','electronics','print','furniture','convenience','vacant','farm','gambling_hall','website','second_hand','winery','no','fabric','drinks_cash_and_carry','beverages','bathroom_furnishing','car_parts','trade','wool','lamps','fixme','cleaning_machines','baby_goods','watches','mobile_working_platform','lighting','variety_store','SUBVERT STORE skateshop','vacuum_cleaner','office')
) TO '/absolute/path/required/city_jobs/data/business.csv' DELIMITER ';' CSV HEADER;


COPY (SELECT tags->'name' AS Name, tags->'operator' AS Operator, tags->'network' AS Network, tags->'wheelchair' AS Wheelchair, geom AS geom
 FROM nodes 
 WHERE tags->'public_transport'='stop_position' AND tags->'name' <> ''
) TO '/absolute/path/required/city_jobs/data/public_transport.csv' DELIMITER ';' CSV HEADER;
   
   
SELECT o.* FROM offices o WHERE ST_DWithin(
ST_GeomFromText('POINT(10.0389112, 53.5413232)',2398)
, st_transform(o.geom, 2398), 500);

```
