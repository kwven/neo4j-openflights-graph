import pandas as pd

airports = pd.read_csv("data/clean/airports_clean.csv")
routes = pd.read_csv("data/clean/routes_graph.csv")

used_airports = set(routes["source_airport_id"]).union(set(routes["destination_airport_id"]))

airports_graph = airports[airports["airport_id"].isin(used_airports)].copy()

airports_graph.to_csv("data/clean/airports_graph.csv", index=False)

print("airports_clean:", airports.shape)
print("airports_graph:", airports_graph.shape)