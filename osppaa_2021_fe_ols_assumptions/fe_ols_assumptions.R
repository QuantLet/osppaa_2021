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

######################################################################
## No Omitted variable bias & Measurement error
## - No tests available. Using two-way fixed effects for robustness check
######################################################################

######################################################################
## No unit roots to evade spurious regressions
## - Autocorrelations
######################################################################
pdta <- pdata.frame(as.data.frame(dta[["norm"]]),index = c("coin","date"))

library(plm)

variables <- c("prices"
              ,"V_trend_prices_st_3"
              ,"V_fv"
              ,"csupply"
              ,"vola_btc")

pvals <- NULL
stats <- NULL
dfs <- NULL
for(i in variables)
{
    f <- paste(i,"1", sep=" ~ ")
    packed <- purtest(
       ,object = formula(f)
       ,data = pdta
       ,index = c("firm", "year")
       ,pmax = 4
       ,test = "madwu")

    pval <- round(packed$statistic$p.value, digits = 2)
    stat <- round(packed$statistic$statistic, digits = 2)
    df   <- round(packed$statistic$parameter, , digits = 2)
    pvals <- c(pvals, pval)
    stats <- c(stats, stat)
    dfs   <- c(dfs,df)
}

df <- data.frame("var"  = variables,
                 "stat" = stats,
                 "df"   = dfs,
                 "pval" = pvals)


## latex table
                                        # Prepare naming
rownames(df) <- rename_vars(as.character(df$var))
colnames(df) <- c("willgoaway", "${\\chi}^2$", "$df$", "$p$")
df <- df %>% select(-willgoaway) %>% t()
                                        # Prepare alignement
subtable_latex        <- xtable(df,
                                align = "lrrrrr")
                                        # Print table
print(subtable_latex
    , file=paste0(SETTINGS$modelling$resultspath,"unitroot.tex")
    , sanitize.text.function = function(x) x
    , include.rownames=TRUE
    , include.colnames=TRUE,
    , floating = FALSE
    , booktabs = TRUE
    , hline.after = c(-1, 0, nrow(df))
    , format.args = list(width = 1.5)
      )

