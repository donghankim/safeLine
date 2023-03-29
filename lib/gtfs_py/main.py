from dotenv import load_dotenv
import os
from nyct_gtfs import NYCTFeed
import pdb


def main():
    load_dotenv('../../.env')
    MTA_KEY = os.environ.get('MTA_API_KEY')

    feed = NYCTFeed("1", api_key=MTA_KEY)
    pdb.set_trace()
    


if __name__ == '__main__':
    main()
