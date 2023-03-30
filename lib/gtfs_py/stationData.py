import numpy as np
import pandas as pd
import json
import pdb


ASSET_PATH="../../asset/processed/"

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



process_station_data()
print("files processed and saved...")


