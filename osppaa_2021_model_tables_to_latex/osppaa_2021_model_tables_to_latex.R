## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")


######################################################################
## Load models
######################################################################
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_sT_mMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_mT_mMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_wT_mMCaV.Rdta"))

## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Write tables                                              #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

library(sandwich)

cov_m1way_sT_mMCaV <- vcovSCC(m1way_sT_mMCaV)
robust_se_sT_mMCaV <- sqrt(diag(cov_m1way_sT_mMCaV))

cov_m1way_mT_mMCaV <- vcovSCC(m1way_mT_mMCaV)
robust_se_mT_mMCaV <- sqrt(diag(cov_m1way_mT_mMCaV))

cov_m1way_wT_mMCaV <- vcovSCC(m1way_wT_mMCaV)
robust_se_wT_mMCaV <- sqrt(diag(cov_m1way_wT_mMCaV))

cov_m1way_sT_mMCaV_wDummy <- vcovSCC(m1way_sT_mMCaV_wDummy)
robust_se_sT_mMCaV_wDummy <- sqrt(diag(cov_m1way_sT_mMCaV_wDummy))

cov_m1way_mT_mMCaV_wDummy <- vcovSCC(m1way_sT_mMCaV_wDummy)
robust_se_mT_mMCaV_wDummy <- sqrt(diag(cov_m1way_sT_mMCaV_wDummy))

cov_m1way_wT_mMCaV_wDummy <- vcovSCC(m1way_wT_mMCaV_wDummy)
robust_se_wT_mMCaV_wDummy <- sqrt(diag(cov_m1way_wT_mMCaV_wDummy))

cov_m2way_sT_mMCaV <- vcovSCC(m2way_sT_mMCaV)
robust_se_sT_mMCaV <- sqrt(diag(cov_m2way_sT_mMCaV))

cov_m2way_wT_mMCaV <- vcovSCC(m2way_wT_mMCaV)
robust_se_wT_mMCaV <- sqrt(diag(cov_m1way_wT_mMCaV))

cov_m1way_sT_hMCaV <- vcovSCC(m1way_sT_hMCaV)
robust_se_sT_hMCaV <- sqrt(diag(cov_m1way_sT_hMCaV))

cov_m1way_wT_hMCaV <- vcovSCC(m1way_wT_hMCaV)
robust_se_wT_hMCaV <- sqrt(diag(cov_m1way_wT_hMCaV))

cov_m1way_sT_lMCaV <- vcovSCC(m1way_sT_lMCaV)
robust_se_sT_lMCaV <- sqrt(diag(cov_m1way_sT_lMCaV))

cov_m1way_wT_lMCaV <- vcovSCC(m1way_wT_lMCaV)
robust_se_wT_lMCaV <- sqrt(diag(cov_m1way_wT_lMCaV))


stargazer(m1way_wT_mMCaV
         ,m1way_sT_mMCaV
         ,se=list(robust_se_wT_mMCaV
                  ,robust_se_sT_mMCaV
                   )
         ,out      = paste0(SETTINGS$modelling$resultspath,"result_mMCaV.tex")
         ,dep.var.labels= "$\\Delta P_{t+1}$"
         ,covariate.labels = rename_vars(names(m1way_sT_mMCaV[[1]]))
         ,align = TRUE
         ,single.row = TRUE
         ,float = FALSE
         ,no.space = TRUE)

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


stargazer(m1way_sT_mMCaV
         ,m1way_mT_mMCaV
         ,m1way_wT_mMCaV
         ,se=list(robust_se_sT_mMCaV,
                  robust_se_mT_mMCaV,
                  robust_se_wT_mMCaV)
         ,out              = paste0(SETTINGS$modelling$resultspath,"result_xT_mMCaV.tex")
         ,dep.var.labels   = "$\\Delta P_{t+1}$"
         ,covariate.labels = rename_vars(names(m1way_wT_mMCaV[[1]]))
                                        #,column.labels = c("10m100m10SD","0.1m1m10SD","1m10m15SD","1m10m5SD")
         ,align = TRUE
         ,single.row = TRUE
         ,float = FALSE
         ,float.env = "sidewaystable"
         ,no.space = TRUE)

