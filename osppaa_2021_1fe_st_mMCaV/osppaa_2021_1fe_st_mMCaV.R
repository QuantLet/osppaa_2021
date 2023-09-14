
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")
load(paste0(SETTINGS$modelling$finaldatapath,"sT_mMCaV.Rdta"))


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
diff(vola_btc)"

                                        # Select data
dta <- dta[["norm"]] %>% arrange(coin,date)
                                        # Model estimation
m1way_sT_mMCaV <- plm(formula = f_norm,
          data    = as.data.frame(dta),
          model   = 'within',
          effect = 'individual',
          index = c('coin'))

save(m1way_sT_mMCaV, file = paste0(SETTINGS$modelling$resultspath, "1way_1fe_sT_mMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> FE - Residual Diagnostics 1 FE                                  #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
resid_m1way_sT_mMCaV <- residuals(m1way_sT_mMCaV)

######################################################################
## No serial correlation
######################################################################
pbgtest(m1way_sT_mMCaV, order = 1)


######################################################################
## No cross-sectional correlation
######################################################################
pcdtest(m1way_sT_mMCaV, test = c("cd"))
pcdtest(m1way_sT_mMCaV, test = c("lm"))

######################################################################
## Norm Dist
######################################################################
qqnorm(resid_m1way_sT_mMCaV)
qqline(resid_m1way_sT_mMCaV)
hist(resid_m1way_sT_mMCaV,  breaks = 70)
psych::describe(resid_m1way_sT_mMCaV)

######################################################################
## No hetheroscedasticity
######################################################################
library(lmtest)
bptest(m1way_sT_mMCaV)

######################################################################
## ACFs
######################################################################
for(c in levels(dta$coin)){
    resid_subselect <- resid_m1way_sT_mMCaV[dta$coin == c]
    acf(resid_subselect[!is.na(resid_subselect)], lag.max = 100)
    Sys.sleep(1)
}
