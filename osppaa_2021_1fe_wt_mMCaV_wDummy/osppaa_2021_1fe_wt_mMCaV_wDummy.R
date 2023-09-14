## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")
load(paste0(SETTINGS$modelling$finaldatapath,"wT_mMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> FE - Estimation 1 FE                                   #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
library(Matrix)
library(plm)
                                        # Regression formula
f_norm <- "lead(diff(prices)) ~
V_fv + V_fv_p2 + V_fv_p3 +
V_trend_prices_st_3  + V_trend_prices_st_3_p2 + V_trend_prices_st_3_p3 +
diff(csupply)+
diff(vola_btc)+
V_fv:V_fv_dummy + 
V_fv:V_trend_dummy +
V_trend_prices_st_3:V_fv_dummy +
V_trend_prices_st_3:V_trend_dummy +
V_hour_dummy+
V_day_dummy+
V_month_dummy"

                                        # Select data
dta <- dta[["norm"]] %>% arrange(coin,date)
                                        # Model estimation
m1way_wT_mMCaV_wDummy <- plm(formula = f_norm,
          data    = as.data.frame(dta),
          model   = 'within',
          effect = 'individual',
          index = c('coin'))

save(m1way_wT_mMCaV_wDummy, file = paste0(SETTINGS$modelling$resultspath, "1way_1fe_wT_mMCaV_wDummy.Rdta"))
