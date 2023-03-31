from nyct_gtfs import NYCTFeed
import pyrebase
import concurrent.futures
from dotenv import load_dotenv
import os, re, time
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
            train_id = re.sub(r'[^\w\s]','', train.nyc_train_id).replace(" ", "")
            headsign = train.headsign_text
            status = train.location_status # STOPPED_AT, IN_TRANSIT_TO, INCOMING_AT
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


def async_update():
    for key in DataStreamer.feeds:
        gtfs_feed(key)


def threaded_update():
    with concurrent.futures.ThreadPoolExecutor() as exe:
        for key in DataStreamer.feeds:
            _ = exe.submit(gtfs_feed, key)



class DataStreamer: 
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
    db = None
    
    @classmethod 
    def db_connect(cls):
        firebase = pyrebase.initialize_app(cls.config)
        cls.db = firebase.database()
    
    @classmethod
    def db_reset(cls):
        cls.db.remove()

    @classmethod
    def publish(cls, cnt = None, method_ = "async"):
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
                    print(len(cls.stream))
                except Exception:
                    print(f"{n} failed")
        else:
            # cloud run
            threaded_update()
            try:
                cls.db.set(cls.stream)
                print(f"number of updated: {len(cls.stream)}")
            except Exception:
                print("failed to push...")



def main():
    DataStreamer.db_connect()

    while True:
        DataStreamer.publish()
        time.sleep(1)


if __name__ == '__main__':
    main()
    # gtfs_feed("ACEHFS")
    print("script terminated....")



