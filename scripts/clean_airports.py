import pandas as pd

cols = [
    "airport_id","name","city","country","iata","icao","latitude","longitude",
    "altitude","timezone","dst","tz_database_timezone","type","source"
]

df = pd.read_csv(
    "data/raw/airports.dat",
    header=None,
    names=cols,
    na_values=["\\N"]
)

# keep only airport rows
df = df[df["type"] == "airport"].copy()

# trim text columns
text_cols = ["name","city","country","iata","icao","dst","tz_database_timezone","type","source"]
for col in text_cols:
    df[col] = df[col].astype("string").str.strip()

# convert numeric columns
df["airport_id"] = pd.to_numeric(df["airport_id"], errors="coerce")
df["latitude"] = pd.to_numeric(df["latitude"], errors="coerce")
df["longitude"] = pd.to_numeric(df["longitude"], errors="coerce")
df["altitude"] = pd.to_numeric(df["altitude"], errors="coerce")
df["timezone"] = pd.to_numeric(df["timezone"], errors="coerce")

# drop only critical broken rows
df = df.dropna(subset=["airport_id", "name", "country", "latitude", "longitude"])

# remove duplicate airport_id 
df = df.drop_duplicates(subset=["airport_id"])

df.to_csv("data/clean/airports_clean.csv", index=False)
# some commande to see if our data is cleaned perefectly just to test if all good 
print(df.shape)
print(df.isna().sum())
print(df[df["iata"].isna()].head(10))
print(df[df["city"].isna()].head(10))
print(df[df["airport_id"].duplicated()])