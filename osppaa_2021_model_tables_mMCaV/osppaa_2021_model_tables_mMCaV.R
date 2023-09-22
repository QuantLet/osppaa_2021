## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")


######################################################################
## Load models
######################################################################
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_sT_mMCaV.Rdta"))
load(paste0(SETTINGS$modelling$resultspath, "1way_1fe_wT_mMCaV.Rdta"))


## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Write tables                                              #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

library(sandwich)

cov_m1way_sT_mMCaV <- vcovSCC(m1way_sT_mMCaV)
robust_se_sT_mMCaV <- sqrt(diag(cov_m1way_sT_mMCaV))

cov_m1way_wT_mMCaV <- vcovSCC(m1way_wT_mMCaV)
robust_se_wT_mMCaV <- sqrt(diag(cov_m1way_wT_mMCaV))


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
