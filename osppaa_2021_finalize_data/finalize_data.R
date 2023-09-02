source("yml_SETTINGS_loading.R")
source("helper.R")

########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$mid_vol
    ,bound_mcap <- SETTINGS$modelling$mid_mcap
    ,trunc      <- SETTINGS$modelling$mid_trunc
)
save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"mT_mMCaV.Rdta"))


########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$mid_vol
    ,bound_mcap <- SETTINGS$modelling$mid_mcap
    ,trunc      <- SETTINGS$modelling$weak_trunc
)

save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"wT_mMCaV.Rdta"))


########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$mid_vol
    ,bound_mcap <- SETTINGS$modelling$mid_mcap
    ,trunc      <- SETTINGS$modelling$strong_trunc
)

save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"sT_mMCaV.Rdta"))

########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$high_vol
    ,bound_mcap <- SETTINGS$modelling$high_mcap
    ,trunc      <- SETTINGS$modelling$weak_trunc
)

save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"wT_hMCaV.Rdta"))

########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$high_vol
    ,bound_mcap <- SETTINGS$modelling$high_mcap
    ,trunc      <- SETTINGS$modelling$strong_trunc
)
save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"sT_hMCaV.Rdta"))


########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$low_vol
    ,bound_mcap <- SETTINGS$modelling$low_mcap
    ,trunc      <- SETTINGS$modelling$weak_trunc
)

save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"wT_lMCaV.Rdta"))

########################################################################################## 

dta <- get_data(
    dropcoins  <- c("bitcoin")
    ,readfile   <- "../osppaa_data/inputdata_raw_hourly.csv"
    ,bound_vol  <- SETTINGS$modelling$low_vol
    ,bound_mcap <- SETTINGS$modelling$low_mcap
    ,trunc      <- SETTINGS$modelling$strong_trunc
)
save(dta, file = paste0(SETTINGS$modelling$finaldatapath,"sT_lMCaV.Rdta"))

