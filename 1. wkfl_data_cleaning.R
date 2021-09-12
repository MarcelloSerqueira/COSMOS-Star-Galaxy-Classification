#!/usr/bin/env Rscript
#
# versao 2.1 de 2016/03/12
# Campisano



# Options to have a better error understanding
options(echo=TRUE)
options(show.error.messages=TRUE)
options(verbose=TRUE)



# Get arguments
args <- commandArgs(trailingOnly = TRUE)
print("Command arguments:")
print(args)

#!/usr/bin/env Rscript
#
# versao 2.1 de 2016/03/12
# Campisano

#---- Deixar trecho abaixo comentado no Sagitarii
sagitariiWorkFolder <- "/home/marcello/teste"

# to use with hadoop:
sagitariiWorkFolder <- "."
libraryFolder <- sagitariiWorkFolder
setwd(libraryFolder)

# ----------- SAGITARII REQUIREMENTS -------------------------------------------
inputFileFolder <- paste( sagitariiWorkFolder, "inbox", sep = "/")
outputFileFolder <- paste( sagitariiWorkFolder, "outbox", sep = "/")
paramFile <- paste( sagitariiWorkFolder, "sagi_input.txt", sep = "/")
outputFile <- paste( sagitariiWorkFolder, "sagi_output.txt", sep = "/")
outpuClassifica <- paste( outputFileFolder, "classifica.csv", sep = "/")
# ------------------------------------------------------------------------------

# needs packages
repos = "http://cran.r-project.org"
lib = paste(Sys.getenv("SPARK_HOME"), "R_LIBS", sep="/")
dir.create(lib, showWarnings=TRUE, recursive=TRUE, mode="0755")
.libPaths(c(lib, .libPaths()))
print(.libPaths())

#dep = "leaps"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "glmnet"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "nnet"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "kernlab"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "class"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "randomForest"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "e1071"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "ROCR"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "forecast"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
#dep = "gplots"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);

# ----------- START ------------------------------------------------------------

tab <- read.table( paramFile, header = TRUE, sep = ",")
print(paramFile)
data <- tab$data[1]


dataFile <- paste( inputFileFolder, data, sep = "/")
print(dataFile)
cosmos <- local(get(load(dataFile)))

#Data Cleaning

cosmos.filtro <-cosmos[cosmos$I >= 14 & cosmos$I <=26, ]
cosmos.filtro2 <-cosmos.filtro[cosmos.filtro$U<99 & cosmos.filtro$U>-99, ]
cosmos.filtro3 <-cosmos.filtro2[cosmos.filtro2$G<99 & cosmos.filtro2$G>-99, ]
cosmos.filtro4 <-cosmos.filtro3[cosmos.filtro3$R<99 & cosmos.filtro3$R>-99, ]
cosmos.filtro5 <-cosmos.filtro4[cosmos.filtro4$Z<99 & cosmos.filtro4$Z>-99, ]
cosmos.filtro6 <-cosmos.filtro5[cosmos.filtro5$DU<99 & cosmos.filtro5$DU>-99, ]
cosmos.filtro7 <-cosmos.filtro6[cosmos.filtro6$DG<99 & cosmos.filtro6$DG>-99, ]
cosmos.filtro8 <-cosmos.filtro7[cosmos.filtro7$DR<99 & cosmos.filtro7$DR>-99, ]
cosmos.filtro9 <-cosmos.filtro8[cosmos.filtro8$DZ<99 & cosmos.filtro8$DZ>-99, ]
cosmos.filtro10 <-cosmos.filtro9[cosmos.filtro9$DI<99 & cosmos.filtro9$DI>-99, ]
cosmos.filtro11 <-cosmos.filtro10[cosmos.filtro10$alvo<2, ]
cosmos_cleaning <- cosmos.filtro11
saida <- paste( outputFileFolder, "cosmos_cleaning.rdata", sep = "/")
save(cosmos_cleaning, file=saida)