CREATE CONSTRAINT airline_id_unique IF NOT EXISTS
FOR (a:Airline)
REQUIRE a.airline_id IS UNIQUE;

CREATE CONSTRAINT route_id_unique IF NOT EXISTS
FOR (r:Route)
REQUIRE r.route_id IS UNIQUE;
