# See https://s3.amazonaws.com/oeda/docs/phoenix_codebook.pdf
# for coding descriptions

phoenix_cols = ['event_id',
                'date',
                'year', 'month', 'day',
                'source_actor_full',
                'source_actor_entity',
                'source_actor_role',
                'source_actor_attribute',
                'target_actor_full',
                'target_actor_entity',
                'target_actor_role',
                'target_actor_attribute',
                'event_code',
                'event_root_code',
                'penta_class',
                'goldstein_score',
                'issues',
                'lat',
                'lon',
                'location_name',
                'state_name',
                'country_code',
                'sentence_id',
                'urls',
                'news_sources']

used_cols = [x for x in phoenix_cols if x not in ['year', 'month', 'day']]


def read_phoenix_data(fnames):
    """
    :param str | list[str] fnames: filename or list of filenames to read
    """
    import pandas as pd

    if isinstance(fnames, str):
        fnames = [fnames]

    df = pd.concat([pd.read_table(fname,
                                  header=None,
                                  names=phoenix_cols,
                                  usecols=used_cols,
                                  na_values=' ',
                                  parse_dates=['date'])
                    for fname in fnames])
    return df
