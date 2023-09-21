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

