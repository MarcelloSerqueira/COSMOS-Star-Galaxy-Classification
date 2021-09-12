#!/usr/bin/env Rscript
#
# versao 2.0 de 25/07/2016
# Marcello


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

source("Preprocessamento.R")
pre_load_libraries()


cosmos_out <- outliers.boxplot(cosmos, "alvo")
str <- as.character(strsplit(as.character(data), ".rdata"))
str2 <- paste(str, "_out", sep="")
assign(str2, cosmos_out)
saveString <- paste(str2, ".rdata", sep="")

saida <- paste( outputFileFolder, saveString, sep = "/")
save(list = str2, file=saida)