// =====================================================
// Neo4j OpenFlights Graph - Analysis Queries
// =====================================================


// -----------------------------------------------------
// 1) Count all airport nodes
// How many airports are in the final graph?
// -----------------------------------------------------
MATCH (a:Airport)
RETURN count(a) AS total_airports;


// -----------------------------------------------------
// 2) Count all route relationships
// How many route connections were imported?
// -----------------------------------------------------
MATCH ()-[r:ROUTE_TO]->()
RETURN count(r) AS total_routes;


// -----------------------------------------------------
// 3) Top 10 airport hubs by total degree
// Which airports are the most connected overall?
// Degree here means incoming + outgoing routes.
// -----------------------------------------------------
MATCH (a:Airport)
OPTIONAL MATCH (a)-[r:ROUTE_TO]-()
RETURN a.name AS airport,
       a.iata AS iata,
       a.country AS country,
       count(r) AS degree
ORDER BY degree DESC
LIMIT 10;


// -----------------------------------------------------
// 4) Top 10 airports by outgoing routes
// Which airports send flights to the most destinations?
// -----------------------------------------------------
MATCH (a:Airport)-[r:ROUTE_TO]->()
RETURN a.name AS airport,
       a.iata AS iata,
       a.country AS country,
       count(r) AS outgoing_routes
ORDER BY outgoing_routes DESC
LIMIT 10;


// -----------------------------------------------------
// 5) Top 10 airports by incoming routes
// Which airports receive the most incoming routes?
// -----------------------------------------------------
MATCH ()-[r:ROUTE_TO]->(a:Airport)
RETURN a.name AS airport,
       a.iata AS iata,
       a.country AS country,
       count(r) AS incoming_routes
ORDER BY incoming_routes DESC
LIMIT 10;


// -----------------------------------------------------
// 6) Distinct direct destinations from one airport
// Which airports can be reached directly from a specific airport?
// We use "CMN" and we can change to any airport code we want.
// -----------------------------------------------------
MATCH (a:Airport {iata: "CMN"})-[:ROUTE_TO]->(b:Airport)
RETURN DISTINCT b.name AS destination,
       b.iata AS iata,
       b.country AS country
ORDER BY country, destination;


// -----------------------------------------------------
// 7) Number of distinct direct destinations from one airport
// How many unique airports can be reached directly from a chosen airport?
// -----------------------------------------------------
MATCH (:Airport {iata: "CMN"})-[:ROUTE_TO]->(b:Airport)
RETURN count(DISTINCT b) AS direct_destinations;


// -----------------------------------------------------
// 8) Domestic vs international routes
// How many routes stay inside the same country and how many cross country borders?
// -----------------------------------------------------
MATCH (a:Airport)-[r:ROUTE_TO]->(b:Airport)
RETURN
  sum(CASE WHEN a.country = b.country THEN 1 ELSE 0 END) AS domestic_routes,
  sum(CASE WHEN a.country <> b.country THEN 1 ELSE 0 END) AS international_routes;


// -----------------------------------------------------
// 9) Countries with the most airports in the graph
// Which countries have the largest number of airports represented in this network?
// -----------------------------------------------------
MATCH (a:Airport)
RETURN a.country AS country,
       count(a) AS airport_count
ORDER BY airport_count DESC
LIMIT 10;


// -----------------------------------------------------
// 10) Countries with the most outgoing route records
// Which countries generate the most outgoing route connections in the graph?
// -----------------------------------------------------
MATCH (a:Airport)-[r:ROUTE_TO]->()
RETURN a.country AS country,
       count(r) AS outgoing_routes
ORDER BY outgoing_routes DESC
LIMIT 10;


// -----------------------------------------------------
// 11) Most connected airport pairs
// Which airport pairs have the most ROUTE_TO relationships between them?
// Useful because one pair may be operated by several airlines.
// -----------------------------------------------------
MATCH (src:Airport)-[r:ROUTE_TO]->(dst:Airport)
WITH src, dst, count(r) AS route_count
WHERE route_count > 1
RETURN src.name AS source,
       src.iata AS source_iata,
       dst.name AS destination,
       dst.iata AS destination_iata,
       route_count
ORDER BY route_count DESC
LIMIT 20;



// -----------------------------------------------------
// 12) Shortest path between two airports
// What is the shortest route path between two airports in number of hops?
// -----------------------------------------------------
MATCH p = shortestPath(
  (:Airport {iata: "CMN"})-[:ROUTE_TO*..6]-(:Airport {iata: "JFK"})
)
RETURN p;


// -----------------------------------------------------
// 13) Check for isolated airports
// Are there any airports in the graph with no routes at all?

// -----------------------------------------------------
MATCH (a:Airport)
WHERE NOT (a)-[:ROUTE_TO]-()
RETURN count(a) AS isolated_airports;

// -----------------------------------------------------
// 14) Airports with the most distinct destination countries
// Which airports connect to the widest range of countries?
// This is a stronger international connectivity measure than simple route count
// -----------------------------------------------------
MATCH (a:Airport)-[:ROUTE_TO]->(b:Airport)
WHERE a.country <> b.country
RETURN a.name AS airport,
       a.iata AS iata,
       a.country AS country,
       count(DISTINCT b.country) AS destination_countries
ORDER BY destination_countries DESC
LIMIT 10;