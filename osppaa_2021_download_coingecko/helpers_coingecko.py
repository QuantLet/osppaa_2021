
# >>>>> General things >>>>> -------------------------------------
# General modules
from pycoingecko import CoinGeckoAPI
cg = CoinGeckoAPI()

# Own modules
import time
import yaml
import importlib
import itertools as itr
import pandas as pd
from tqdm import tqdm
from datetime import datetime
import os
from dateutil.relativedelta import *
from functools import reduce

# Import Config
with open("./04_impl/SETTINGS.yml", 'r') as stream:
    try:
        SETTINGS = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

# Import general helpers
spec    = importlib.util.spec_from_file_location("noname", "./04_impl/helpers/gen_helpers.py")
helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(helpers)


def get_coins_markets_paginated(full_request = 1000,
                                answers_per_page = 250):
    if 0 != (full_request % answers_per_page):
        raise Exception("Input 'full_request' not divisible by 'answers_per_page'. ")

    pages = int(full_request/answers_per_page)
    coininfo = list()
    for page in tqdm(range(pages)):
        coininfo_sub = cg.get_coins_markets(vs_currency = "USD",
                                        per_page = 250,
                                        page = page)
        coininfo += coininfo_sub
        
        time.sleep(3)  

    return coininfo

def get_sifted_coin_ids(thresh  = SETTINGS["cg_data_gen"]["mkt_cap_thresh"],
                        req_nbr = SETTINGS["cg_data_gen"]["full_request_number"],
                        answ_p_page = SETTINGS["cg_data_gen"]["answers_per_page"]):
    info_raw  = get_coins_markets_paginated(full_request = req_nbr,
                                           answers_per_page = answ_p_page)
    fullnames = [info_raw[i]["name"] for i in range(len(info_raw))]
    ids       = [info_raw[i]["id"] for i in range(len(info_raw))]
    
    ids_unique = list(set(ids))
    
    return ids_unique

def roundTime(dt=None, roundTo=60):
   """Round a datetime object to any time lapse in seconds
   dt : datetime.datetime object, default now.
   roundTo : Closest number of seconds to round to, default 1 minute.
   Author: Thierry Husson 2012 - Use it as you want but don't blame me.
   """
   if dt == None : dt = datetime.datetime.now()
   seconds = (dt.replace(tzinfo=None) - dt.min).seconds
   rounding = (seconds+roundTo/2) // roundTo * roundTo
   return dt + datetime.timedelta(0,rounding-seconds,-dt.microsecond)


def get_mkt_data(coinlist,
                 ts_start = SETTINGS["cg_data_gen"]["timestamp_from"],
                 ts_end   = SETTINGS["cg_data_gen"]["timestamp_to"]): 
        # prepare loop
    dta_succ_ids = list()
    dta_gathered = list()

    # split timeperiod into sub-periods
    startdate = datetime.fromtimestamp(SETTINGS["cg_data_gen"]["timestamp_from"])
    enddate = datetime.fromtimestamp(SETTINGS["cg_data_gen"]["timestamp_to"])
    subperiods = [round((startdate + relativedelta(months=i)).timestamp())
                     for i in range(round((enddate-startdate).days/30))]

    for id in tqdm(coinlist):
        prices = pd.DataFrame()
        market_caps = pd.DataFrame()
        total_volumes = pd.DataFrame()
        for subp in range(len(subperiods)-1): 
            # Economize on rate limit
            time.sleep(1)
            # Prep start- and end-timestamp
            raw_packed  = None
            from_sub_ts = subperiods[subp] 
            to_sub_ts   = subperiods[subp+1]-1
            while raw_packed is None:
                try:
                    raw_packed = cg.get_coin_market_chart_range_by_id(id = id,
                                                                      from_timestamp = from_sub_ts,
                                                                      to_timestamp   = to_sub_ts,
                                                                      vs_currency    = ['usd'])
                except:
                    pass        
            if (len(raw_packed["prices"]) > 0
                or len(raw_packed["total_volumes"])
                or len(raw_packed["market_caps"])):
                prices_sub        = pd.DataFrame(list(zip(*raw_packed["prices"]))).T
                prices_sub[0] = pd.to_datetime(prices_sub[0],unit="ms").dt.floor("H")
                total_volumes_sub = pd.DataFrame(list(zip(*raw_packed["total_volumes"]))).T
                total_volumes_sub[0] = pd.to_datetime(total_volumes_sub[0],unit="ms").dt.floor("H")
                market_caps_sub   = pd.DataFrame(list(zip(*raw_packed["market_caps"]))).T
                market_caps_sub[0] = pd.to_datetime(market_caps_sub[0],unit="ms").dt.floor("H")
                prices = prices.append(prices_sub, ignore_index = True)
                total_volumes = total_volumes.append(total_volumes_sub, ignore_index = True)
                market_caps = market_caps.append(market_caps_sub, ignore_index = True)
                dta_list = [prices, total_volumes, market_caps]
                dta = reduce(lambda left,right: pd.merge(left,right,on=0, how="outer"), dta_list) # "0" is alway timestamp-column
                dta.columns = ["time","prices","total_volumes","market_caps"]
                # Build list of dataframes from indiv. download
                dta_gathered.append(dta)
                dta_succ_ids.append(id)

 
    # Make dict from list
    dta_gathered = helpers.list_to_dictonary(names    = dta_succ_ids,
                                             datalist = dta_gathered)
    return dta_gathered
# # function merges the timeseries dataframes with a time vector covering the complete time period specified in SETTINGS
# def fill_out_time(d,
#                   coinnames,
#                   startdate = SETTINGS["cg_data_gen"]["timestamp_from"],
#                   enddate = SETTINGS["cg_data_gen"]["timestamp_to"]):
#     for nme in coinnames:
#         d[nme]["time"] = [custom_unixts_to_date(ts) for ts in d[nme]["time"]]
        
#         time_complete = pd.date_range(custom_unixts_to_date(startdate,
#                                                             in_milli_sec = False),
#                                       custom_unixts_to_date(enddate,
#                                                             in_milli_sec = False),
#                                       freq='D').strftime(date_format = "%Y-%m-%d:%HH-mm")
        
#         time_complete = pd.DataFrame({"time": time_complete})
        
#     for nme in coinnames:
#         merged   = pd.merge(left  = time_complete,
#                             right = d[nme],
#                             how   = "left",
#                             on    = "time")
#         merged.columns = ["time","prices","total_volumes","market_caps"]
#         d[nme] = merged

#     return d

# sub-function transforming a timestamp as returned by the CoinGeckoAPI to a string date 
def custom_unixts_to_date(ts,
                          in_milli_sec = True):
    
    if in_milli_sec:
        ts_clean = int(ts/1000)
    else:
        ts_clean = int(ts)

    d = datetime.fromtimestamp(ts_clean).strftime(format = "%Y-%m-%d")
    return d


def save_as_csv(config, d):
    
    startdate_raw = config["cg_data_gen"]["timestamp_from"]
    enddate_raw   = config["cg_data_gen"]["timestamp_to"]
    
    startdate = custom_unixts_to_date(startdate_raw,
                                      in_milli_sec = False)
    enddate   = custom_unixts_to_date(enddate_raw,
                                      in_milli_sec = False)
    
    
    if not os.path.exists(config["cg_data_gen"]["path_to_save"]):
        os.makedirs(config["cg_data_gen"]["path_to_save"])
        
        
    for nme in d.keys():                         
        d[nme].to_csv(path_or_buf = (config["cg_data_gen"]["path_to_save"]
                                     + nme
                                     + "_"
                                     + startdate
                                     + "_"
                                     + enddate
                                     + ".csv"),
                      index       = False)



