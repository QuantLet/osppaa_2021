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


