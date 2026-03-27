import pandas as pd

routes = pd.read_csv("data/clean/routes_graph.csv")
airlines = pd.read_csv("data/clean/airlines_clean.csv")

valid_airline_ids = set(pd.to_numeric(airlines["airline_id"], errors="coerce").dropna().astype(int))

routes["airline_id"] = pd.to_numeric(routes["airline_id"], errors="coerce")

# keep only routes with airline_id in airlines_clean
routes = routes.dropna(subset=["airline_id"]).copy()
routes["airline_id"] = routes["airline_id"].astype(int)
routes = routes[routes["airline_id"].isin(valid_airline_ids)].copy()

# create unique route_id column
routes = routes.reset_index(drop=True)
routes["route_id"] = routes.index + 1

# move route_id to the beginning
cols = ["route_id"] + [c for c in routes.columns if c != "route_id"]
routes = routes[cols]

routes.to_csv("data/clean/routes_airline_graph.csv", index=False)

print(routes.shape)
print(routes.isna().sum())