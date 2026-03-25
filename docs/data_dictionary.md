##  airports file columns explanation

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