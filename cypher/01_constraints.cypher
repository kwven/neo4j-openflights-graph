CREATE CONSTRAINT airport_id_unique IF NOT EXISTS
FOR (a:Airport)
REQUIRE a.airport_id IS UNIQUE;