
# This function takes a list of package names (as strings) and checks if they are installed on your system. 
# If any of the packages in the list are not installed, it installs them. 
# If all packages are already installed, it loads them into your R session. 
# This is helpful for ensuring that all necessary packages are available before running the rest of the script.
# 
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

#  format_settings function converts several properties of the SETTINGS object 
# from comma-separated strings to lists of separate strings, making the SETTINGS 
# object easier to work with in the rest of the script.
# 
format_settings <- function(settings_obj = SETTINGS){
  settings_obj$bw_data_gen$pairs <- unlist(str_split(settings_obj$bw_data_gen$pairs, ","))
  settings_obj$bw_data_gen$bw_databases <- unlist(str_split(settings_obj$bw_data_gen$bw_databases, ","))
  settings_obj$descriptives$exog_pure <- unlist(str_split(settings_obj$descriptives$exog_pure, ","))
  settings_obj$descriptives$exog_sq <- unlist(str_split(settings_obj$descriptives$exog_sq, ","))
  settings_obj$descriptives$exog_qube <- unlist(str_split(settings_obj$descriptives$exog_qube, ","))
  return(settings_obj)
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

