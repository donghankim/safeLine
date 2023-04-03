from nyct_gtfs import NYCTFeed
import pyrebase
import concurrent.futures
from dotenv import load_dotenv
from datetime import datetime
import os, re, logging
import sys
import pdb

if sys.platform == "darwin":
    load_dotenv('../../.env')
elif sys.platform == "linux":
    load_dotenv('.env')
else:
    sys.exit("unrecognized platfrom...")


MTA_KEY = os.environ.get('MTA_API_KEY')
all_feeds = {
        "ACE": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-ace", api_key = MTA_KEY),
        "BDFM": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-bdfm", api_key = MTA_KEY),
        "G": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-g", api_key = MTA_KEY),
        "JZ": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-jz", api_key = MTA_KEY),
        "NQRW": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-nqrw", api_key = MTA_KEY),
        "L": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-l", api_key = MTA_KEY),
        "1234567": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs", api_key = MTA_KEY),
        "SIR": NYCTFeed("https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-si", api_key = MTA_KEY)
}

logging.basicConfig(
    level = logging.INFO,
    filename = "mta_stream.log",
    filemode = 'a',
    format = "%(asctime)s: [%(levelname)s] %(message)s",
    datefmt = "%Y-%m-%d %H:%M:%S")


class DataStreamer:

    db = None
    stream = {}
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

    @classmethod 
    def connect(cls):
        firebase = pyrebase.initialize_app(cls.config)
        cls.db = firebase.database()
        logging.info("connected to firebase...")

    
    @classmethod
    def reset(cls):
        cls.connect()
        cls.db.remove()
        logging.info("database reset successfully...")


    @classmethod
    def publish(cls, cnt = None, method_ = "thread"):
        if cnt:
            for n in range(cnt):
                if method_ == "async":
                    async_update()
                elif method_ == "thread":
                    threaded_update()
                elif method_ == "multiprocess":
                    pass
                
                try:
                    cls.db.update(cls.stream)
                except Exception:
                    pass
        
        # cloud stream
        else:
            threaded_update()
            try:
                cls.db.update(cls.stream)
                logging.info(f"pushed {len(cls.stream)}")
            except Exception:
                logging.error("failed to publish...")


def async_update():
    for key in DataStreamer.feeds:
        gtfs_feed(key)


def threaded_update():
    with concurrent.futures.ThreadPoolExecutor() as exe:
        for key in DataStreamer.feeds:
            _ = exe.submit(gtfs_feed, key)

def gtfs_feed(feed_key):
    feed = all_feeds[feed_key]
    feed.refresh()
    trains = feed.trips
    
    for train in trains:
        line = train.route_id
        if line in stream_lines:
            train_id = re.sub(r'[^\w\s]','', train.nyc_train_id).replace(" ", "")
            status = train.location_status # STOPPED_AT, IN_TRANSIT_TO, INCOMING_AT
            headsign = train.headsign_text
            heading_st = train.location
            direction = train.direction
            delay = train.has_delay_alert
            if delay == None:
                delay = False
            
            train_data = [line, train_id, headsign, heading_st, direction, status]
            if all(train_data):
                data = {
                    "line": line,
                    "headsign": headsign,
                    "next_st": heading_st[:3],
                    "direction": direction,
                    "status": status,
                    "isDelay": delay
                }

                DataStreamer.stream[train_id] = data


def main():
    DataStreamer.connect()
    while True:
        try:
            DataStreamer.publish()
        except KeyboardInterrupt:
            logging.info("forced interruption...")
            break


test_line = ["1"]
stream_lines = ["A", "C", "E", 
                "B", "D", "F",
                "M", "G", "J",
                "Z", "N", "Q",
                "R", "W", "L",
                "1", "2", "3",
                "4", "5", "6",
                "7", "SIR"]

if __name__ == '__main__':
    if sys.argv[-1] == "--test":
        stream_lines = test_line
    elif sys.argv[-1] == "--reset":
        DataStreamer.reset()
        sys.exit("reset complete")
    main()
   
