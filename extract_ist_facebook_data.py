# Takes IST's Facebook scrapes (dumps from elastic)
# Pulls out the 'norm' field for a simple table
# Writes to pickle

import ujson as json
import pandas as pd
import os


def extract_facebook_elastic_json(fname):
    jsns = [json.loads(x) for x in open(
        os.path.join('data', 'facebook', fname), 'r')]
    df = pd.DataFrame.from_records(x['_source']['norm'] for x in jsns)
    df.timestamp = pd.to_datetime(df.timestamp)
    df.to_pickle(fname + '.pkl')

extract_facebook_elastic_json('yemen_facebook')
extract_facebook_elastic_json('yemen_facebook_5.22.2016')
