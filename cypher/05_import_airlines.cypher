LOAD CSV WITH HEADERS FROM 'file:///airlines_clean.csv' AS row
MERGE (a:Airline {airline_id: toInteger(row.airline_id)})
SET a.name = row.name,
    a.alias = row.alias,
    a.iata = row.iata,
    a.icao = row.icao,
    a.callsign = row.callsign,
    a.country = row.country,
    a.active = row.active;