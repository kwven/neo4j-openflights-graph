LOAD CSV WITH HEADERS FROM 'file:///routes_graph.csv' AS row
MATCH (src:Airport {airport_id: toInteger(row.source_airport_id)})
MATCH (dst:Airport {airport_id: toInteger(row.destination_airport_id)})
MERGE (src)-[r:ROUTE_TO {
    airline_code: row.airline_code,
    source_airport_id: toInteger(row.source_airport_id),
    destination_airport_id: toInteger(row.destination_airport_id)
}]->(dst)
SET r.airline_id = CASE WHEN row.airline_id IS NOT NULL AND row.airline_id <> '' THEN toInteger(toFloat(row.airline_id)) ELSE NULL END,
    r.source_airport = row.source_airport,
    r.destination_airport = row.destination_airport,
    r.codeshare = row.codeshare,
    r.stops = toInteger(row.stops),
    r.equipment = row.equipment;