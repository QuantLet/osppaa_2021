[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="1100" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **osppaa_2021_model_tables_eMCaV** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet: osppaa_2021_model_tables_eMCaV

Published in: 'On Stablecoin Price Processes and Arbitrage (Pernice, 2021)'

Description: "The Quantlet is primarily focused on loading previously saved models and preparing robust standard errors for those models to then produce a table of results. Initially, it loads models saved in previous steps. It then calculates the robust standard errors for each of these models using the 'sandwich' package. Finally, it uses the 'stargazer' package to create a table that includes the estimated coefficients from the models along with the robust standard errors. This table is saved in a .tex format for later use. "

Keywords: Robust Standard Errors, Stargazer, Latex, cryptocurrency, prices

Author: Ingolf Pernice

See also: other Quantlets in this project

Submitted: 02.09.2023

Datafile: ./1way_1fe_mT_mMCaV.Rdta, 1way_1fe_sT_mMCaV.Rdta, 1way_1fe_wT_mMCaV.Rdta (to be generated with the respective Quantlets 1fe_... and rbst1fe_...)


```

![Picture1](result_eMCaV.png)

### R Code
```r

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")


######################################################################
## Load models
######################################################################
load(paste0(SETTINGS$modelling$resultspath, "1way_rbst_1fe_sT_hMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_rbst_1fe_wT_hMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_rbst_1fe_sT_lMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_rbst_1fe_wT_lMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Write tables                                              #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

library(sandwich)

cov_m1way_sT_hMCaV <- vcovSCC(m1way_sT_hMCaV)
robust_se_sT_hMCaV <- sqrt(diag(cov_m1way_sT_hMCaV))

cov_m1way_wT_hMCaV <- vcovSCC(m1way_wT_hMCaV)
robust_se_wT_hMCaV <- sqrt(diag(cov_m1way_wT_hMCaV))

cov_m1way_sT_lMCaV <- vcovSCC(m1way_sT_lMCaV)
robust_se_sT_lMCaV <- sqrt(diag(cov_m1way_sT_lMCaV))

cov_m1way_wT_lMCaV <- vcovSCC(m1way_wT_lMCaV)
robust_se_wT_lMCaV <- sqrt(diag(cov_m1way_wT_lMCaV))


stargazer(m1way_wT_hMCaV
         ,m1way_sT_hMCaV
         ,m1way_wT_lMCaV
         ,m1way_sT_lMCaV
         ,se=list(robust_se_wT_hMCaV,
                  robust_se_sT_hMCaV,
                  robust_se_wT_lMCaV,
                  robust_se_sT_lMCaV)
         ,out              = paste0(SETTINGS$modelling$resultspath,"result_eMCaV.tex")
         ,dep.var.labels   = "$\\Delta P_{t+1}$"
         ,covariate.labels = rename_vars(names(m1way_sT_lMCaV[[1]]))
                                        #,column.labels = c("10m100m10SD","0.1m1m10SD","1m10m15SD","1m10m5SD")
         ,align = TRUE
         ,single.row = TRUE
         ,float = FALSE
         ,float.env = "sidewaystable"
         ,no.space = TRUE)



```

automatically created on 2023-09-24