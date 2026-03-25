LOAD CSV WITH HEADERS FROM 'file:///airports_graph.csv' AS row
MERGE (a:Airport {airport_id: toInteger(row.airport_id)})
SET a.name = row.name,
    a.city = row.city,
    a.country = row.country,
    a.iata = row.iata,
    a.icao = row.icao,
    a.latitude = toFloat(row.latitude),
    a.longitude = toFloat(row.longitude),
    a.altitude = CASE WHEN row.altitude IS NOT NULL AND row.altitude <> '' THEN toInteger(row.altitude) ELSE NULL END,
    a.timezone = CASE WHEN row.timezone IS NOT NULL AND row.timezone <> '' THEN toFloat(row.timezone) ELSE NULL END,
    a.dst = row.dst,
    a.tz_database_timezone = row.tz_database_timezone,
    a.type = row.type,
    a.source = row.source;