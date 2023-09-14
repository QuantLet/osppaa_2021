## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")
load(paste0(SETTINGS$modelling$finaldatapath,"wT_lMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> FE - Estimation 1 FE                                   #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

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
m1way_wT_lMCaV <- plm(formula = f_norm,
          data    = as.data.frame(dta),
          model   = 'within',
          effect = 'individual',
          index = c('coin'))


#summary(m1way_r2,
#        vcov = function(x) vcovSCC(x))

save(m1way_wT_lMCaV, file = paste0(SETTINGS$modelling$resultspath, "1way_rbst_1fe_wT_lMCaV.Rdta"))
