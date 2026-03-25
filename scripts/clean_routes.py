import pandas as pd

route_cols = [
    "airline_code",
    "airline_id",
    "source_airport",
    "source_airport_id",
    "destination_airport",
    "destination_airport_id",
    "codeshare",
    "stops",
    "equipment"
]

airports = pd.read_csv("data/clean/airports_clean.csv")
valid_airport_ids = set(pd.to_numeric(airports["airport_id"], errors="coerce").dropna().astype(int))

routes = pd.read_csv(
    "data/raw/routes.dat",
    header=None,
    names=route_cols,
    na_values=["\\N"]
)

# trim text columns
text_cols = ["airline_code", "source_airport", "destination_airport", "codeshare", "equipment"]
for col in text_cols:
    routes[col] = routes[col].astype("string").str.strip()

# convert numeric columns
routes["airline_id"] = pd.to_numeric(routes["airline_id"], errors="coerce")
routes["source_airport_id"] = pd.to_numeric(routes["source_airport_id"], errors="coerce")
routes["destination_airport_id"] = pd.to_numeric(routes["destination_airport_id"], errors="coerce")
routes["stops"] = pd.to_numeric(routes["stops"], errors="coerce")

# drop critical nulls
routes = routes.dropna(subset=["source_airport_id", "destination_airport_id", "stops"])

# cast IDs after null drop
routes["source_airport_id"] = routes["source_airport_id"].astype(int)
routes["destination_airport_id"] = routes["destination_airport_id"].astype(int)

# keep only routes whose endpoints exist in airports_clean
routes = routes[
    routes["source_airport_id"].isin(valid_airport_ids) &
    routes["destination_airport_id"].isin(valid_airport_ids)
].copy()

# remove self-loops
routes = routes[routes["source_airport_id"] != routes["destination_airport_id"]]

# normalize codeshare
routes["codeshare"] = routes["codeshare"].replace({"Y": "Y"})
routes.loc[~routes["codeshare"].eq("Y"), "codeshare"] = pd.NA

# remove exact duplicate rows
routes = routes.drop_duplicates()

routes.to_csv("data/clean/routes_clean.csv", index=False)

# this is just for our first graph to mkae it work only with direct flight 
routes_direct = routes[routes["stops"] == 0].copy()
#save our graph dataset
routes_direct.to_csv("data/clean/routes_graph.csv", index=False)

# some commande to see if our data is cleaned perefectly just to test if all good 
print(routes.shape)
print(routes_direct.shape)
print(routes.isna().sum())
print(routes[routes["airline_id"].isna()].head(10))
print(routes[routes["equipment"].isna()].head(10))
print(routes[routes["source_airport_id"] == routes["destination_airport_id"]].head())