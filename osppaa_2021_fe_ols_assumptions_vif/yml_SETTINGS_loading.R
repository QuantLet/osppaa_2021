##### Evironment #####
source("helper.R")

##### Load packages ####
list_of_packages <- c("yaml", "mctest", "tidyverse", "stringr", "GGally", "anytime", "xts", "plm", "stargazer", "xtable", "Matrix", "plm", "ggplot2", "scales", "tikzDevice")
load_or_install_pkgs(list_of_packages)

###### Load helper funcs #####

##### User Input
SETTINGS <- yaml.load_file("./SETTINGS.yml")
SETTINGS <- format_settings(SETTINGS)


