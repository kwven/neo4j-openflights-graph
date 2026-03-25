##  Data Dictionary — airports_graph.csv

# airport_id
Unique OpenFlights identifier for the airport.
This is the primary key in our cleaned airport file because IATA and ICAO can be missing.

# name
Name of the airport.

It may or may not include the city name.

# city
Main city served by the airport.
It can be spelled differently from the airport name.

# country
Country or territory where the airport is located.

# iata
Three-letter IATA airport code, such as CMN, JFK, or LHR.
This field can be missing.

# icao
Four-letter ICAO airport code, such as GMMN, KJFK, or EGLL.
This field can also be missing.

# latitude
Geographic latitude in decimal degrees.
Positive values are north, negative values are south.

# longitude
Geographic longitude in decimal degrees.
Positive values are east, negative values are west.

# altitude
Airport altitude in feet above sea level.

# timezone
Offset from UTC in hours.
Decimal values are possible, for example 5.5.

# dst
Daylight saving time code.
OpenFlights uses codes like:

E = Europe
A = US/Canada
S = South America
O = Australia
Z = New Zealand
N = None
U = Unknown

# tz_database_timezone
Timezone name in Olson/tz database format, for example Africa/Casablanca or Europe/London.

# type
Type of location.
Possible values include airport, station, port, and unknown.
For our cleaned airport file, we keep only rows where type = "airport".

# source
Source of the airport record.
Examples include OurAirports, Legacy, and User.
For the higher-quality airport-only file, OpenFlights says the source is restricted to OurAirports.



## Data Dictionary — routes_graph.csv

- **airline_code**: 2-letter or alphanumeric airline code from OpenFlights.
- **airline_id**: OpenFlights airline identifier, when available.
- **source_airport**: IATA/ICAO-style source airport code from the route file.
- **source_airport_id**: OpenFlights ID of the source airport.
- **destination_airport**: IATA/ICAO-style destination airport code from the route file.
- **destination_airport_id**: OpenFlights ID of the destination airport.
- **codeshare**: `Y` if the route is marked as codeshare, otherwise null.
- **stops**: Number of stops on the route.
- **equipment**: Aircraft equipment codes used on the route.

### Cleaning notes
- Converted `\N` to null.
- Removed rows with missing source or destination airport IDs.
- Removed rows whose airports were not found in the cleaned airport table.
- Removed self-loop routes where source and destination were the same airport.
- Created `routes_graph.csv` as the graph-ready subset for direct routes.