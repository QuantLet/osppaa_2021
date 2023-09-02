# >>>>> General things >>>>> -------------------------------------
import sys

# Add path for own modules
sys.path.append('./')

# -----------------------------------------------------------
# >>>>> General things >>>>> -------------------------------------
# -----------------------------------------------------------
# General modules
import yaml
import importlib
import sys
#import matplotlib.pyplot as plt
import pandas as pd
import hashlib
from datetime import datetime
import os as os

# Change CWD
#os.chdir("/Users/ingolfpernice/Documents/osppaa_2022")
os.chdir("./osppaa_2022")

# Add path for own modules
sys.path.append('./')

# Own modules
from paper2021_stablecoin_data   import data

# Import Config
with open("./SETTINGS.yml", 'r') as stream:
    try:
        SETTINGS = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

# Import Config
with open("./SETTINGS_TESTING.yml", 'r') as stream:
    try:
        SETTINGS_TESTING = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

# Import general helpers
spec    = importlib.util.spec_from_file_location("noname", "./gen_helpers.py")
helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(helpers)


# -----------------------------------------------------------
# >>>>> Get data >>>>> -------------------------------------
# -----------------------------------------------------------
test = False

if test:
    d = data(config_obj = SETTINGS_TESTING)
    testdate = datetime.today().strftime('%Y%m%d%H%M')
else:
    d = data(config_obj = SETTINGS)

# -----------------------------------------------------------
# Basic Variables
# -----------------------------------------------------------
d.drop_dta_with_few_obs(thresh = 90)
d.drop_dta_with_low_volume(thresh = 25000)
d.drop_dta_with_low_mcap(thresh = 1000000)
d.add_returns()
d.add_stablecoin_identifier()
d.add_volatility_squaredreturns()
d.clean_date()
d.add_supply()
d.mergeCMI10()
# -----------------------------------------------------------
# Volatility 
# -----------------------------------------------------------
d.add_volatility_windowSD(wlength    = 12,
                          sd_minobs  = 12)
d.add_volatility_windowSD(wlength    = 6,
                          sd_minobs  = 6)
d.add_volatility_windowSD(wlength    = 3,
                          sd_minobs  = 3)

# -----------------------------------------------------------
# Trend (Prices)
# -----------------------------------------------------------
d.add_trend_shortterm(trendtype  = "simple",
                      wlength    = 3,
                      var        = "prices",
                      scalingvar = 0.25,
                      minobs     = 3)
d.add_trend_shortterm(trendtype  = "simple",
                      wlength    = 6,
                      var        = "prices",
                      scalingvar = 0.25,
                      minobs     = 6)

# -----------------------------------------------------------
# Timedummy
# -----------------------------------------------------------
d.add_timedummy()


# -----------------------------------------------------------
# Fair Value Variables
# -----------------------------------------------------------
d.add_fvalue_coll()
d.add_fvalue_anchored(minobs    = 2,
                      anchortyp = "lma",
                      wlength   = 365)
d.reduce_to_single_fv_choice(choice_tradcoins = "V_fvalue_lma_365",
                             choice_stabcoins = "from_config")


# -----------------------------------------------------------
# Cleaning
# -----------------------------------------------------------
d.remove_nan_lines(thresh       = "from_config",
                   ignorecols   = [
                       "V_fact_fval_coll","V_fvalue_lma_365"#,"vola_cmi10"
                   ])
d.drop_dta_with_many_nas(thresh = "from_config")

# -----------------------------------------------------------
# Testing
# -----------------------------------------------------------
if test:
    path_testfile = SETTINGS["dataloading"]["path_to_save"]
    name_testfile = '{}_inputdata_raw_test'.format(testdate) 
    ending_testfile = "csv"
    fullpath_testfile = '{}{}.{}'.format(path_testfile,
                                         name_testfile,
                                         ending_testfile)
    helpers.save_obj(obj =  panelmodels(
        config_obj = SETTINGS,
        dta = d.coindata).paneldata,
                     path = path_testfile,
                     name = name_testfile,
                     typ  = ending_testfile)
    testfile = open(fullpath_testfile,
                    "rb")
    content = testfile.read()
    h = hashlib.md5(content)
    output = h.hexdigest()
    os.rename(fullpath_testfile,'{}{}_raw_{}.{}'.format(path_testfile,
                                                    testdate,
                                                    output,
                                                    ending_testfile))
    print("Saved csv of test data non-normalized.")
else:
    helpers.save_obj(obj = d,
                     path = SETTINGS["dataloading"]["path_to_save"],
                     name = "inputdata_raw_hourly",
                     typ  = "pkl")
    print("Saved non-normalized data as pkl.")

