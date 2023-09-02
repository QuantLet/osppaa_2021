get_data <- function(dropcoins,
                     readfile,
                     bound_vol,
                     bound_mcap,
                     trunc){
  
  ## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
  # >> PREP: Load data and packages                                    #
  ## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
  
  raw <- as_tibble(read.csv("../osppaa_data/inputdata_raw_hourly.csv"))
  raw <- raw %>% filter(!coin %in% dropcoins)%>% droplevels()
  raw <- restrictSet(dta  = raw,
                     bound_vol   = bound_vol,
                     bound_mcap  = bound_mcap)
  
  ## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
  ## >> STEP 2: Adjust and fix data                                     #
  ## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
  
  ## Cosmetic fixes:
  
  ## >> Forward fill of NAs in hourly speculative trading data
  raw <- raw %>% fill(everything()) %>% fill(everything(), .direction = 'up')
  
  ## >> Order data ascendingly
  raw <- raw %>% arrange(coin,time)
  
  ## >> PLM needs different header
  colnames(raw)[2] <- "date"
  
  ## >> Add FV Dummy
  raw$V_fv_dummy <- as.numeric(raw$V_fv > 0)
  raw$V_trend_dummy <- as.numeric(raw$V_trend_prices_st_3 > 0)
  raw$V_hour_dummy <- as.numeric(format(anytime(raw$date), "%H"))
  raw$V_day_dummy <- as.numeric(as.factor(weekdays(anytime(raw$date))))
  raw$V_month_dummy <- as.numeric(format(anytime(raw$date), "%m"))
  
  ## >> Cut Tethers start
  raw <- raw %>% filter(
    # negated condition 
    !(coin == "tether" &
        anydate(date) < anydate("2017-06-01"))
  ) %>%
    ungroup()
  
  ## >> Truncate Outliers:
  noutl <- truncateOutliersPanel(raw, truncvar = trunc)
  
  
  ## >> Normalize
  norm <- normalizePanel(noutl) 
  
  
  
  
  out <- list()
  out[["raw"]] <- raw 
  out[["noutl"]] <- noutl
  out[["norm"]] <- norm
  
  return(out)
  
}


load_or_install_pkgs <- function(list_of_packages){
  
  new_packages <- list_of_packages[!(list_of_packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)){
    install.packages(new_packages)
  } else {
    lapply(list_of_packages, require, character.only = TRUE)       
    # (Thanking: https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them)
  }
  print("That's done! I hope...")
}

format_settings <- function(settings_obj = SETTINGS){
  settings_obj$bw_data_gen$pairs <- unlist(str_split(settings_obj$bw_data_gen$pairs, ","))
  settings_obj$bw_data_gen$bw_databases <- unlist(str_split(settings_obj$bw_data_gen$bw_databases, ","))
  settings_obj$descriptives$exog_pure <- unlist(str_split(settings_obj$descriptives$exog_pure, ","))
  settings_obj$descriptives$exog_sq <- unlist(str_split(settings_obj$descriptives$exog_sq, ","))
  settings_obj$descriptives$exog_qube <- unlist(str_split(settings_obj$descriptives$exog_qube, ","))
  return(settings_obj)
}

restrictSet <- function(dta, bound_vol, bound_mcap, bound_n = 24*31){    
  dta <-
    dta %>%
    # prepping
    mutate(monthgroup = format(as.Date(as.character(time), format="%Y-%m-%d %H:%M:%S"),"%Y-%m")) %>% 
    group_by(monthgroup,coin) %>%
    # filtering groups
    filter(all(total_volumes > bound_vol)) %>%
    filter(all(market_caps > bound_mcap)) %>%
    # switch groups
    group_by(coin) %>%
    #filter groups with too few observations
    filter(n() >= bound_n) %>%     
    # ungrouping and cleaning temp cols
    ungroup() %>%
    select(-monthgroup) %>%
    droplevels()
  
  return(dta)  
}


truncateOutliersPanel <- function(dta, truncvar){
  out <-
    dta %>%
    # Split by coins
    group_by(coin) %>%
    # Mutate all but some columns
    mutate_at(
      colnames(dta)[! colnames(dta) %in% c("date","coin", "V_datedummy")],
      # Padded log diff to fill NAs
      function(x){outreplace(x,var = truncvar)}
    ) %>%
    ungroup()
  
  return(out)
}




outreplace <- function(x, var){
  bound_up  <- mean(x)+var*sd(x)
  bound_low <- mean(x)-var*sd(x)
  
  x[x < bound_low] <- bound_low
  x[x > bound_up] <- bound_up
  return(x)
}

normalizePanel <- function(dta){
  out <- dta %>%
    # Split by coins
    group_by(coin) %>%
    # Mutate all but some columns
    mutate_at(
      colnames(dta)[! colnames(dta) %in% c("date","coin", "V_datedummy")],
      # Padded log diff to fill NAs
      function(x){normrange(x)}
    ) %>%
    ungroup()
  
  return(out)
}


normrange <- function(x){(x-min(x))/(max(x)-min(x))}
#normrange <- function(x){scale(x)}

cutOutTS <- function(csel, ttype, dta = raw, tcol = "time"){
  
  dsel <- dta %>% filter(coin == csel) %>% select(c(tcol,ttype))
  
  return(dsel)
} 

