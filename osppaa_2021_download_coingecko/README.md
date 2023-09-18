[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="1100" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **osppaa_2021_download_coingecko** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet: osppaa_2021_download_coingecko

Published in: 'On Stablecoin Price Processes and Arbitrage (Pernice, 2021)'

Description: 'The provided Quantlet imports necessary modules, loads configuration settings, and uses helper functions to download cryptocurrency market data from the CoinGecko API. The downloaded data is then saved in both binary (pickle) and CSV formats. It saves the data to the folder of the Quantlet osppaa 2021 data preparation.'

Keywords:  'Python, CoinGecko API, cryptocurrency, market data, data download, data manipulation, pycoingecko'

Author: Ingolf Pernice

See also: other Quantlets in this project

Submitted: 02.09.2023

Datafile: None


```

### PYTHON Code
```python

# >>>>> General things >>>>> -------------------------------------

# General modules
from pycoingecko import CoinGeckoAPI
cg = CoinGeckoAPI()

# Own modules
from datetime import datetime
import time
import yaml
import importlib
import itertools as itr
import pandas as pd
from tqdm import tqdm

# Change CWD
os.chdir("/Users/ingolfpernice/Documents/csaamoe_2021/osppaa_2022/osppaa_2022_download_coingecko/")
#os.chdir("./osppaa_2022/osppaa_2022_download_coingecko")

# Import Config
with open("./SETTINGS.yml", 'r') as stream:
    try:
        SETTINGS = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

# Import general helpers
spec    = importlib.util.spec_from_file_location("noname", "./gen_helpers.py")
helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(helpers)

spec    = importlib.util.spec_from_file_location("noname", "./helpers_coingecko.py")
coingecko_helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(coingecko_helpers)

# >>>>> Download data >>>>> -------------------------------------

# Download ids and sift them by mkt cap
ids = SETTINGS["cg_data_gen"]["stablecoin_ids"].split(", ")
ids.append("bitcoin")
# Download mkt data
dta = cryptocompare_helpers.get_mkt_data(
    ts_start = SETTINGS["cg_data_gen"]["timestamp_from"],
    ts_end   = SETTINGS["cg_data_gen"]["timestamp_to"],
    coinlist = ids
)


# Save dict
helpers.save_obj(obj = dta,
                 path = SETTINGS["cg_data_gen"]["path_to_save"],
                 name = SETTINGS["cg_data_gen"]["filename"])

# Save data as csvs for standardization of different datasources
cryptocompare_helpers.save_as_csv(config = SETTINGS,
                                  d      = dta)

```

automatically created on 2023-09-18