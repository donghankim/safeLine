from google.transit import gtfs_realtime_pb2
from google.protobuf.json_format import MessageToDict
from google.protobuf.json_format import MessageToJson
from dotenv import load_dotenv
import os, json
import requests, sys, pdb

"""
# Make a request to the MTA API to get the VehiclePositions feed
response = requests.get('http://datamine.mta.info/mta_esi.php?key=<YOUR_API_KEY>&feed_id=1')

# Parse the response using the nyct_gtfs_realtime_pb2 module
nyct_feed = nyct_pb2.FeedMessage()
nyct_feed.ParseFromString(response.content)

# Extract the current location of the train from the VehiclePositions feed
for entity in nyct_feed.entity:
    if entity.HasField('vehicle'):
        vehicle_position = entity.vehicle.position
        print(f"Train {entity.vehicle.trip.trip_id} is currently at latitude {vehicle_position.latitude} and longitude {vehicle_position.longitude}")
"""

if sys.platform == "darwin":
    load_dotenv('../../.env')
elif sys.platform == "linux":
    load_dotenv('.env')
else:
    sys.exit("unrecognized platfrom...")

MTA_KEY = os.environ.get('MTA_API_KEY')

headers = {'x-api-key': MTA_KEY}
response = requests.get("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-ace", headers = headers)
nyct_feed = gtfs_realtime_pb2.FeedMessage()
nyct_feed.ParseFromString(response.content)

for entity in nyct_feed.entity:
    if entity.HasField('vehicle'):
        try:
            print(entity.vehicles.trip.)
        pdb.set_trace()

 
