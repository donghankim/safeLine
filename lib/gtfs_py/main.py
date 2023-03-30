from nyct_gtfs import NYCTFeed
import pyrebase
import concurrent.futures
from collections import defaultdict
from dotenv import load_dotenv
import os, time
import pdb



load_dotenv('../../.env')
MTA_KEY = os.environ.get('MTA_API_KEY')
all_feeds = {
        "ACEHFS": NYCTFeed("A", api_key = MTA_KEY),
        "BDFM": NYCTFeed("B", api_key = MTA_KEY),
        "G": NYCTFeed("G", api_key = MTA_KEY),
        "JZ": NYCTFeed("J", api_key = MTA_KEY),
        "NQRW": NYCTFeed("N", api_key = MTA_KEY),
        "L": NYCTFeed("L", api_key = MTA_KEY),
        "1234567S": NYCTFeed("1", api_key = MTA_KEY),
        "SIR": NYCTFeed("SIR", api_key = MTA_KEY)
    }
stream_lines = ["A", "C", "E", 
                "B", "D", "F",
                "M", "G", "J",
                "Z", "N", "Q",
                "R", "W", "L",
                "1", "2", "3",
                "4", "5", "6",
                "7", "SIR"]

def gtfs_feed(feed_key):
    feed = all_feeds[feed_key]
    feed.refresh()
    trains = feed.trips
    
    for train in trains:
        line = train.route_id
        if line in stream_lines:
            train_id = train.nyc_train_id.replace(" ", "").replace("/", "_")
            status = train.location_status # STOPPED_AT, IN_TRANSIT_TO, INCOMING_AT
            heading_st = train.location
            direction = train.direction
            train_data = [line, train_id, heading_st, direction, status]

            if all(train_data):
                data = {
                    "id": train_id,
                    "heading_st": heading_st,
                    "direction": direction,
                    "status": status
                }
                DataStreamer.stream[line].append(data)


def async_update():
    for key in DataStreamer.feeds:
        gtfs_feed(key)


def threaded_update():
    with concurrent.futures.ThreadPoolExecutor() as exe:
        for key in DataStreamer.feeds:
            _ = exe.submit(gtfs_feed, key)



class DataStreamer: 
    stream = defaultdict(list)
    feeds = list(all_feeds.keys())
    config = {
        "apiKey": "AIzaSyBBOANJTRKfexijLU3ePB16bdG89P8hq-4",
        "authDomain": "safeline-775d3.firebaseapp.com",
        "databaseURL": "https://safeline-775d3-default-rtdb.firebaseio.com/mta_stream",
        "projectId": "safeline-775d3",
        "storageBucket": "safeline-775d3.appspot.com",
        "messagingSenderId": "493243078840",
        "appId": "1:493243078840:web:d39c9ac5479d57f601fc4d",
        "measurementId": "G-HBHQKCF19N"
    }
    db = None
    
    @classmethod 
    def init_db(cls):
        firebase = pyrebase.initialize_app(cls.config)
        cls.db = firebase.database()
    
    @classmethod
    def reset_db(cls):
        cls.db.remove()

    @classmethod
    def publish(cls, cnt, method_):
        for n in range(cnt):
            if method_ == "async":
                async_update()
            elif method_ == "thread":
                threaded_update()
            elif method_ == "multiprocess":
                pass
        
            for line, value in cls.stream.items():
                line_data = {data['id']: data for data in value}
                try:
                    cls.db.child(line).update(line_data)
                except Exception:
                    print(f"{n}: failed {line}")



def main():
    DataStreamer.init_db()
    DataStreamer.publish(10, method_ = "thread")
    

if __name__ == '__main__':
    main()
