import matplotlib.pyplot as plt
import pickle
import yaml

# Import Config
with open("./settings/SETTINGS.yml", 'r') as stream:
    try:
        SETTINGS = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)


def list_to_dictonary(names, datalist):
    # Create a dictionary from zip object
    list_zip   = zip(names, datalist)
    list_dict  = dict(list_zip)    
    return(list_dict)

# credits to https://stackoverflow.com/questions/19201290/how-to-save-a-dictionary-to-a-file/32216025
def save_obj(path,
             obj,
             name,
             typ = "pkl"):
    savepath = path + name + '.' + typ
    if typ == "pkl":
        with open(savepath, 'wb') as f:
            pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)
    elif typ == "csv":
        with open(savepath, 'wb') as f:
            obj.to_csv(path_or_buf = savepath,
                       sep = ",",
                       index=True)
def load_obj(name,
             path,
             typ = "pkl"):
    loadpath = path + name + '.' + typ
    if typ == "pkl":
        with open(loadpath, 'rb') as f:
            return pickle.load(f)
    elif typ == "csv":
        obj = to_csv(path_or_buf = loadpath,
                     sep = ",",
                     index=True)
        return obj
    
def round_pd_series(x, freq="1d"):
    return(x.round(freq=freq))

def testplot(col,
             coindata,
             settings = SETTINGS):
    var  = coindata[col]
    time = coindata["time"]
    prices = coindata[settings["dataloading"]["price_var"]]

    # Create some mock data
    
    fig, ax1 = plt.subplots()
    
    color = 'tab:red'
    ax1.set_xlabel('Time')
    ax1.set_ylabel('Price', color=color)
    ax1.plot(time, prices, color=color)
    ax1.tick_params(axis='y', labelcolor=color)
    
    ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
    
    color = 'tab:blue'
    ax2.set_ylabel(col, color=color)  # we already handled the x-label with ax1
    ax2.plot(time, var, color=color)
    ax2.tick_params(axis='y', labelcolor=color)
    
    fig.tight_layout()  # otherwise the right y-label is slightly clipped
    plt.ion()
    plt.show()
    
# def save_obj(obj, name ):
#     with open(name + '.pkl', 'wb') as f:
#         pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)
#     print("|---| Saved object into : |---|" + name )

# def load_obj(name ):
#     with open(name + '.pkl', 'rb') as f:
#         return pickle.load(f)
#     print("|---| Loaded object from : |---|" + name )


def whereami():
    whereiam = os.path.abspath(os.curdir)
    return whereiam

