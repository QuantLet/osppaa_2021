# >>>>> General things >>>>> -------------------------------------
# Add path for own modules
import sys

# General modules
import yfinance as yf  
import importlib.util
import yaml
import time

# Change CWD
os.chdir("/Users/ingolfpernice/Documents/csaamoe_2021/osppaa_2022/osppaa_2022_download_yfinance/")
#os.chdir("./osppaa_2022/osppaa_2022_download_yfinance")

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
    
# Set user input for yfinance download
path = SETTINGS["yfinance"]["path"]
name = SETTINGS["yfinance"]["obj_name"]
tickers = ["EURUSD=X",
           "NZDUSD=X",
           "GBPUSD=X",
           "CNYUSD=X",
           "GC=F",
           "CMI10.SW",
           "BTC-USD",
           "ETH-USD",
           "XRP-USD",
           "GAS-ETH"]


# Download data
data = []
for ticker in tickers:
    time.sleep(2)
    sub_data = yf.download(tickers = ticker,
                           interval = "60m",
                           start = '2019-01-01',
                           end = '2020-12-11')
    sub_data.reset_index(inplace=True) #index to column
    sub_data = sub_data.rename(columns={'Datetime': 'time', 'Close': 'cp'}) # for consistencey with blockwatch naming 
    sub_data["time"] = sub_data["time"].dt.strftime('%Y-%m-%d %H:00')
    sub_data = sub_data[["time","cp"]] # extract needed columns
    sub_data = sub_data.fillna(method='ffill') #forward fill weekends
    data.append(sub_data)

# Reformat data
data = helpers.list_to_dictonary(names    = tickers,
                                 datalist = data)
# Save data
helpers.save_obj(path = path,
                 name = name,
                 obj  = data)




