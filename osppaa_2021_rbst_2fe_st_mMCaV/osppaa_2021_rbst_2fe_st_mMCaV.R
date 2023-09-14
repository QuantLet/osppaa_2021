## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")
load(paste0(SETTINGS$modelling$finaldatapath,"sT_mMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> FE - Estimation 1 FE                                   #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

                                        # Regression formula
f_norm <- "lead(diff(prices)) ~
V_fv + V_fv_p2 + V_fv_p3 +
V_trend_prices_st_3  + V_trend_prices_st_3_p2 + V_trend_prices_st_3_p3 +
V_hour_dummy+
V_day_dummy+
V_month_dummy+
diff(csupply) +
diff(vola_btc)"

                                        # Select data
dta <- dta[["norm"]] %>% arrange(coin,date)

                                        # Model estimation
m2way_sT_mMCaV <- plm(formula = f_norm,
          data    = as.data.frame(dta),
          model   = 'within',
          effect = 'twoway',
          index = c("coin", "date"))

save(m2way_sT_mMCaV, file = paste0(SETTINGS$modelling$resultspath, "m2way_sT_mMCaV.Rdta"))
