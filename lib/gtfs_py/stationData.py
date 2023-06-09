import numpy as np
import pandas as pd
import json
import pdb


ASSET_PATH="../../asset/processed/"


# old
def process_station_data():
    df = pd.read_csv('mta_stations.csv')
    relevant_cols = ['GTFS Stop ID', 'Stop Name', 'GTFS Latitude', 'GTFS Longitude', 'Daytime Routes']
    all_stations = df[relevant_cols]
    all_stations = all_stations.rename(columns = {'GTFS Stop ID': 'id', 'Stop Name':'name', 'GTFS Latitude':'lat', 'GTFS Longitude':'lon', 'Daytime Routes':'lines'})

    lines = {}
    dict_ = all_stations.to_dict('records')
    for row in dict_:
        arr = row['lines'].split(" ")
        for nl in arr:
            if nl in lines.keys():
                lines[nl].append(row['id'])
            else:
                lines[nl] = []
    

    # store subway line data
    lines_json = json.dumps(lines)
    with open(f"{ASSET_PATH}lines_processed.json", "w") as fp:
        fp.write(lines_json)
    
    # store station data
    all_stations.to_csv(f"{ASSET_PATH}stations_processed.csv", index = False)


# new
def clean_new():
    df = pd.read_csv('raw_stations.csv')
    relevant_cols = ['stop_id', 'stop_name', 'stop_lat', 'stop_lon']
    all_stations = df[relevant_cols]
    all_stations = all_stations.rename(columns = {'stop_id': 'id', 'stop_name':'name', 'stop_lat':'lat', 'stop_lon':'lon'})
    all_stations.to_csv(f"{ASSET_PATH}stations_processed.csv", index = False)


clean_new()
# process_station_data()
print("files processed and saved...")


