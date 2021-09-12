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
train <- tab$train[1]
test <- tab$test[1]
norm <- tab$norm[1]

dataTrain <- paste( inputFileFolder, train, sep = "/")
print(dataTrain)
dataTest <- paste( inputFileFolder, test, sep="/")
print(dataTest)

cosmos_train <- local(get(load(dataTrain)))
cosmos_test <- local(get(load(dataTest)))

source("Preprocessamento.R")
pre_load_libraries()

if(norm == "minmax"){
	cosmos_train_minmax <- normalize.minmax(cosmos_train)
	cosmos_train_minmax_par <- cosmos_train_minmax[[2]]
	cosmos_train_minmax <- cosmos_train_minmax[[1]] #train
	cosmos_test_minmax <- normalize.minmax(cosmos_test, cosmos_train_minmax_par)[[1]] #test

	str_train <- as.character(strsplit(as.character(train), ".rdata"))
	str_test <- as.character(strsplit(as.character(test), ".rdata"))

	str2_train <- paste(str_train, "_minmax.rdata", sep="")
	str2_test <- paste(str_test, "_minmax.rdata", sep="")
	
	saida <- paste( outputFileFolder, str2_train, sep = "/")
	save(cosmos_train_minmax, file=saida)

	saida2 <- paste( outputFileFolder, str2_test, sep = "/")
	save(cosmos_test_minmax, file=saida2)
}

if(norm == "zscore"){
	cosmos_train_zscore <- normalize.zscore(cosmos_train)
	cosmos_train_zscore_par <- cosmos_train_zscore[[2]]
	cosmos_train_zscore <- cosmos_train_zscore[[1]] #train
	cosmos_test_zscore <- normalize.zscore(cosmos_test, cosmos_train_zscore_par)[[1]] #test

	str_train <- as.character(strsplit(as.character(train), ".rdata"))
	str_test <- as.character(strsplit(as.character(test), ".rdata"))

	str2_train <- paste(str_train, "_zscore.rdata", sep="")
	str2_test <- paste(str_test, "_zscore.rdata", sep="")
	
	saida <- paste( outputFileFolder, str2_train, sep = "/")
	save(cosmos_train_zscore, file=saida)

	saida2 <- paste( outputFileFolder, str2_test, sep = "/")
	save(cosmos_test_zscore, file=saida2)
}