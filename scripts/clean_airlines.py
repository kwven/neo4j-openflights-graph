import pandas as pd

cols = [
    "airline_id",
    "name",
    "alias",
    "iata",
    "icao",
    "callsign",
    "country",
    "active"
]

airlines = pd.read_csv(
    "data/raw/airlines.dat",
    header=None,
    names=cols,
    na_values=["\\N"]
)

routes = pd.read_csv("data/clean/routes_graph.csv")

# keep only airline_id shown in routes_graph
used_airline_ids = pd.to_numeric(routes["airline_id"], errors="coerce").dropna().astype(int).unique()

# cleaning text columns
text_cols = ["name", "alias", "iata", "icao", "callsign", "country", "active"]
for col in text_cols:
    airlines[col] = airlines[col].astype("string").str.strip()

# convert numeric columns
airlines["airline_id"] = pd.to_numeric(airlines["airline_id"], errors="coerce")

# delete invalid rows
airlines = airlines.dropna(subset=["airline_id", "name"])
airlines["airline_id"] = airlines["airline_id"].astype(int)

# keep only used airline_id in routes
airlines = airlines[airlines["airline_id"].isin(used_airline_ids)].copy()

# remove duplicate rows
airlines = airlines.drop_duplicates(subset=["airline_id"])

airlines.to_csv("data/clean/airlines_clean.csv", index=False)

print(airlines.shape)
print(airlines.isna().sum())