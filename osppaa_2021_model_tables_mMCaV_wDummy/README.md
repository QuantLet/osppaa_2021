[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="1100" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **osppaa_2021_model_tables_mMCaV_wDummy** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet: osppaa_2021_model_tables_mMCaV_wDummy

Published in: 'On Stablecoin Price Processes and Arbitrage (Pernice, 2021)'

Description: "The Quantlet is primarily focused on loading previously saved models and preparing robust standard errors for those models to then produce a table of results. Initially, it loads models saved in previous steps. It then calculates the robust standard errors for each of these models using the 'sandwich' package. Finally, it uses the 'stargazer' package to create a table that includes the estimated coefficients from the models along with the robust standard errors. This table is saved in a .tex format for later use. "

Keywords: Robust Standard Errors, Stargazer, Latex, cryptocurrency, prices

Author: Ingolf Pernice

See also: other Quantlets in this project

Submitted: 02.09.2023

Datafile: 1way_1fe_sT_mMCaV_wDummy.Rdta, 1way_1fe_wT_mMCaV_wDummy.Rdta (to be generated with the respective Quantlets 1fe_... and rbst1fe_...)


```

![Picture1](result_mMCaV_wDummy.png)

### R Code
```r

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")


######################################################################
## Load models
######################################################################
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_sT_mMCaV_wDummy.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_wT_mMCaV_wDummy.Rdta"))


## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Write tables                                              #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

library(sandwich)

cov_m1way_sT_mMCaV_wDummy <- vcovSCC(m1way_sT_mMCaV_wDummy)
robust_se_sT_mMCaV_wDummy <- sqrt(diag(cov_m1way_sT_mMCaV_wDummy))

cov_m1way_wT_mMCaV_wDummy <- vcovSCC(m1way_wT_mMCaV_wDummy)
robust_se_wT_mMCaV_wDummy <- sqrt(diag(cov_m1way_wT_mMCaV_wDummy))



stargazer(m1way_wT_mMCaV_wDummy
          ,m1way_sT_mMCaV_wDummy
          ,se=list(robust_se_wT_mMCaV_wDummy
                   ,robust_se_sT_mMCaV_wDummy
          )
          ,out      = paste0(SETTINGS$modelling$resultspath,"result_mMCaV_wDummy.tex")
          ,dep.var.labels= "$\\Delta P_{t+1}$"
          ,covariate.labels = rename_vars(names(m1way_wT_mMCaV_wDummy[[1]]))
          ,align = TRUE
          ,single.row = TRUE
          ,float = FALSE
          ,no.space=TRUE)


```

automatically created on 2023-09-24