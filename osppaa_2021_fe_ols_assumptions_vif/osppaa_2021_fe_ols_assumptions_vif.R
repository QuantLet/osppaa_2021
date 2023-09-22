## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> PREP: Load data and packages                                    #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
source("yml_SETTINGS_loading.R")
load(paste0(SETTINGS$modelling$finaldatapath,"mT_mMCaV.Rdta"))


## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #
# >> FE - Assumptions                                        #
## >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> >> #

######################################################################
## No Multicollinearity
## - VIF + argue that not that problematic due to panel data
######################################################################

vif_raw <- getVIF(dta = dta[["norm"]],
                  exog = c(SETTINGS$descriptives$exog_pure
                          ,SETTINGS$descriptives$exog_sq
                          ,SETTINGS$descriptives$exog_qube),
              endog = SETTINGS$descriptives$endog)

vif <- round(vif_raw, digits = 2)

## latex table
                                        # Prepare naming
colnames(vif) <- rename_vars(colnames(vif))
rownames(vif) <- rename_coins(rownames(vif))
                                        # Prepare alignement
subtable_latex        <- xtable(vif,
                                align = "lcccccccc")
                                        # Print table
print(subtable_latex
    , file=paste0(SETTINGS$modelling$resultspath,"vif.tex")
    , sanitize.text.function = function(x) x
    , include.rownames=TRUE
    , include.colnames=TRUE,
    , floating = FALSE
    , booktabs = TRUE
    , hline.after = c(-1, 0, nrow(vif))
    , format.args = list(width = 1.5)
      )
