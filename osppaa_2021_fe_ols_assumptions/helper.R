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


rename_vars <- function(vec){
  translation <- NULL
  for(i in 1:length(vec)){
    i_rep <- switch(vec[i],
                    date = "$Date$",
                    coin = "$Project$",
                    V_volatility_sr= "$V_{t}$",
                    V_volatility_sr_p2= "$V^{2}_{t}$",
                    V_volatility_sr_p3= "$V^{3}_{t}$",
                    V_trend_prices_st_3 = "$T_{t}$",
                    V_trend_prices_st_3_p2= "$T^{2}_{t}$",
                    V_trend_prices_st_3_p3= "$T^{3}_{t}$",
                    V_trend_prices_st_7 = "$T_{7d}_{t}$",
                    V_trend_prices_st_7_p2= "$T_{7d}^{2}_{t}$",
                    V_trend_prices_st_7_p3= "$T_{7d}^{3}_{t}$",
                    total_volumes= "$\\mathtt{Volume}_{t}$",
                    V_fv = "$D_{t}$",
                    V_fv_p2 = "$D^{2}_{t}$",
                    V_fv_p3= "$D^{3}_{t}$",
                    V_fv_dummy = "$Z_{D>0}_{t}$",
                    V_trend_dummy = "$Z_{T>0}_{t}$",
                    prices = "$P_{t}$",
                    cmi10 = "$I_{t}$",
                    `diff(cmi10), 0)` = "$\\Delta \\mathtt{Cmi10} $",
                    gas = "$G_{t}$",
                    `diff(gas)` = "$\\Delta G_{t}$",
                    V_volatility_st_3 = "$V_{t}$",
                    V_volatility_st_3_p2 = "$V^{2}_{t}$",
                    V_volatility_st_3_p3 = "$V^{3}_{t}$",
                    V_fvalue_lma_365 = "$Unset$",
                    is_stablecoin = "$DStabelcoin$",
                    V_trend_total_volumes_st_3 = "Unset",
                    V_trend_total_volumes_st_3_p2 = "Unset$",
                    V_trend_total_volumes_st_3_p3 = "Unset",
                    V_volatility_st_7 = "$\\Delta V_{t}$",
                    V_volatility_st_7_p2 = "$\\Delta V^{2}_{t}$",
                    V_volatility_st_7_p3 = "$\\Delta V^{3}_{t}$",
                    market_caps= "$M_{t}$",
                    csupply= "$S_{t}$",
                    vola_btc = "$V^{BTC}_{t}$",
                    vola_eth = "$V^{ETH}_{t}$",
                    vola_xrp = "$V^{XRP}_{t}$",
                    `diff(total_volumes)` = "$\\Delta V_{t}$",
                    `diff(market_caps)` = "$\\Delta M_{t}$",
                    `diff(csupply)` = "$\\Delta S_{t}$",
                    `diff(vola_btc)` = "$\\Delta V^{\\mathtt{BTC}}_{t}$",
                    `diff(vola_eth)` = "$\\Delta V^{\\mathtt{ETH}}_{t}$",
                    `diff(vola_xrp)` = "$\\Delta V^{\\mathtt{XRP}}_{t}$",
                    `V_fv:V_fv_dummy` = "$D \\cdot Z^{D>0}_{t}$",
                    `V_fv:V_trend_dummy` = "$D \\cdot Z^{T>0}_{t}$",
                    `V_fv:market_caps` = "$Dt \\cdot S_{t}$",
                    `V_fv:total_volumes` = "$D \\cdot V_{t}$",
                    `V_trend_prices_st_3:V_fv_dummy` ="$T \\cdot Z^{D>0}_{t}$",
                    `V_trend_prices_st_3:total_volumes` = "$T \\cdot V$",
                    `V_trend_prices_st_3:V_trend_dummy` = "$T \\cdot Z^{T>0}_{t}$",
                    V_hour_dummy = "$Z^{\\mathtt{hour}}_{t}$",
                    V_day_dummy = "$Z^{\\mathtt{day}}_{t}$",
                    V_month_dummy = "$Z^{\\mathtt{month}}_{t}$",
                    "NotIdentified")
    translation <- c(translation, i_rep)
  }
  return(translation)
}


rename_coins <- function(vec){
  translation <- NULL
  for(i in 1:length(vec)){
    i_rep <- switch(vec[i],
                    nubits = "Nubits" ,
                    bitusd     = "Bit-USD" ,
                    tether     = "Tether" ,
                    `tether-gold` = "Tether Gold" ,
                    `perth-mint-gold-token` = "Perth Mint Gold" ,
                    `gold-bcr`  = "Gold BCR" ,
                    `usd-bancor`     = "Bancor-USD" ,
                    sdusd      = "SD-USD" ,
                    `stasis-eurs` = "Stasis EURS" ,
                    `gemini-dollar`   = "Gemini Dollar" ,
                    dai        = "Maker Dai" ,
                    trustusd   = "Trust-USD" ,
                    `aave-tusd`  = "Aave-TUSD" ,
                    digitalusd = "Digital-USD" ,
                    neutrino   = "Neutrino" ,
                    musd       = "MUSD" ,
                    stableusd  = "Stable-USD" ,
                    `true-usd`   = "True-USD" ,
                    `etoro-euro` = "Etoro-Euro" ,
                    `equilibrium-eosdt` = "Equilibrium EOSDT" ,
                    `digix-gold` = "Digix Gold" ,
                    `pax-gold`   = "Pax Gold" ,
                    `binance-usd` = "Binance USD" ,
                    usdx       = "USDX" ,
                    nusd       = "NUSD" ,
                    usdk       = "USDK" ,
                    `usd-coin`   = "USD-Coin" ,
                    husd       = "HUSD" ,
                    usdq       = "USDQ" ,
                    `paxos-standard` = "Paxos Standard" ,
                    `binance-gbp` = "Binance-GPB" ,
                    bitCNY     = "BitCNY" ,
                    `etoro-new-zealand-dollar` = "Etoro NZUSD",
                    "NotIdentified")
    translation <- c(translation, i_rep)
  }
  return(translation)
}

#' Function getting a dataframe with VIF based on mctest package
#' 
#' 
#' @param dta ... data for which VIF are to be calculated
#'
#' @return ... dataframe with VIFS. 
#'
getVIF <- function(dta,
                   SETTINGS = SETTINGS,
                   exog,
                   endog){
  
  ids <- unique(dta$coin)
  vifs <- NULL
  for(id in ids)
  {
    
    ##                                 # NEXT if Bancor
    ## if(id %in% c("bancor", "tether-gold","usdx")){
    ##     next
    ## }
    # Select data for VIF calculation
    dat_exog   <- dta %>% filter(coin == id) %>% select(exog) %>% as.data.frame# %>% slice(1:(n() - 2000))
    dat_endog  <- dta %>% filter(coin == id) %>% select(endog) %>% as.data.frame# %>% slice(1:(n() - 2000))
    
    # Get linear model for mctest package (which gets VIFs)
    model        <- NULL
    f <- as.formula(paste(endog,
                          " ~ ",
                          paste(exog, collapse = " + ")))
    model <- lm(f, data = cbind(dat_endog,dat_exog))
    
    # NEXT if error in modelling 
    if(is.null(model)){
      next
    }
    # Format mctest results
    vif_packed <- imcdiag(model)
    vif_num <- unname(vif_packed$idiags[,1])
    vif_var <-  names(vif_packed$idiags[,1])
    
    # Bind results together for different coins
    vif <- data.frame(vif_num)
    rownames(vif) <- vif_var
    colnames(vif) <- id
    vifs <- rbind(vifs,t(vif))
    
  }
  
  vifs <- vifs[,order(colnames(vifs))]
  
  return(vifs)
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

