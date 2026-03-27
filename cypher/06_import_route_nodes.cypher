LOAD CSV WITH HEADERS FROM 'file:///routes_airline_graph.csv' AS row
MATCH (src:Airport {airport_id: toInteger(row.source_airport_id)})
MATCH (dst:Airport {airport_id: toInteger(row.destination_airport_id)})
MATCH (al:Airline {airline_id: toInteger(row.airline_id)})
MERGE (r:Route {route_id: toInteger(row.route_id)})
SET r.airline_code = row.airline_code,
    r.airline_id = toInteger(row.airline_id),
    r.source_airport = row.source_airport,
    r.source_airport_id = toInteger(row.source_airport_id),
    r.destination_airport = row.destination_airport,
    r.destination_airport_id = toInteger(row.destination_airport_id),
    r.codeshare = row.codeshare,
    r.stops = toInteger(row.stops),
    r.equipment = row.equipment
MERGE (al)-[:OPERATES]->(r)
MERGE (r)-[:FROM]->(src)
MERGE (r)-[:TO]->(dst);