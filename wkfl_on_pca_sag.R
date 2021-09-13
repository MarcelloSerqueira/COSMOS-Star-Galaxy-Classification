#!/usr/bin/env Rscript
#
#

#---- Deixar trecho abaixo comentado no Sagitarii
#sagitariiWorkFolder <- "/Users/eogasawara/Dropbox/Eduardo/R/Star-Galaxy"

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



# keep this options to have a better error understanding
options(echo=TRUE)
options(show.error.messages=TRUE)
options(verbose=TRUE)



# needs packages
repos = "http://cran.r-project.org"
lib = paste(Sys.getenv("HADOOP_HOME"), "R_LIBS", sep="/")
.libPaths(c(lib, .libPaths()))
print(.libPaths())

dep = "leaps"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "glmnet"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "nnet"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "kernlab"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "class"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "randomForest"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "e1071"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "ROCR"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "forecast"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);
dep = "gplots"; if (!require(dep, character.only = TRUE, quietly = TRUE)) { install.packages(dep, repos=repos, lib=lib); library(dep, character.only = TRUE); }; rm(dep);



# ----------- START ------------------------------------------------------------

tab <- read.table( paramFile, header = TRUE, sep = ",")
metodo <- tab$metodo[1]
tamanho <- tab$tamanho[1]
par_r <- tab$par_r[1]
par_i <- tab$par_i[1]
arquivoTreino <- tab$treino[1]
arquivoTeste <- tab$teste[1]

trainFile <- paste( inputFileFolder, arquivoTreino, sep = "/")
load(trainFile)
testFile <- paste( inputFileFolder, arquivoTeste, sep = "/")
load(testFile)

source("classifica.R")

x.train <- remove_outliers(x.train)

x.train.raw <- x.train
x.train <- normalize_minmax(x.train.raw)
x.test <- normalize_minmax(x.train.raw,x.test)

if (FALSE) { # uso de lasso
    print("lasso")
    set.seed(1)
    x.list <- lasso(x.train, x.train$alvo~.)
    x.train <-x.list[[1]]
    x.train.columns <- x.list[[2]]
    x.test.alvo <- x.test$alvo
    x.test <- x.test[,x.train.columns]
    x.test$alvo <- x.test.alvo
}

if (FALSE) { # uso de pca
    print("pca")
    set.seed(1)
    x.train.raw <- x.train

    if (arquivoTreino=="round1_training_set_r.rdata")
    {
        k=0.6
    } else if (arquivoTreino=="round2_training_set_r.rdata")
    {
        k=0.69
    } else if (arquivoTreino=="round3_training_set_r.rdata")
    {
        k=0.69
    }

    x.list <- pca(x.train.raw, varacum=k)
    x.train <-x.list[[1]]
    x.train.transf <- x.list[[2]]

    x.list <- pca(x.train.raw, test=x.test, transf = x.train.transf, varacum=k)
    x.test <- x.list[[1]]

    x.train.pca.raw <- x.train
    x.train <- normalize_minmax(x.train.pca.raw)
    x.test <- normalize_minmax(x.train.pca.raw,x.test)
}

tab$resultado <- "classifica.csv"
tab$resultadov <- 0

set.seed(1)

if (metodo=="rn")
{
    x.rn2 <- rn2(x.train, x.test, tamanho, par_r, par_i)
    aa <- croc(x.rn2[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.rn2, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="rbfdot")
{
    x.svm4 <- svm4(x.train, x.test, x.train$alvo~., "rbfdot", tamanho, par_r)
    aa <- croc(x.svm4[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.svm4, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="polydot")
{
    x.svm4 <- svm4(x.train, x.test, x.train$alvo~., "polydot", tamanho, par_r)
    aa <- croc(x.svm4[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.svm4, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="tanhdot")
{
    x.svm4 <- svm4(x.train, x.test, x.train$alvo~., "tanhdot", tamanho, par_r)
    aa <- croc(x.svm4[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.svm4, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="knn")
{
    x.knn <- knear(x.train, x.test, tamanho)
    aa <- croc(x.knn[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.knn, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="rf")
{
    x.rf <- rf(x.train, x.test, tamanho)
    aa <- croc(x.rf[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.rf, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else if (metodo=="nb")
{
    x.nb <- nb(x.train, x.test)
    aa <- croc(x.nb[,2], x.test$alvo)
    aa <- unlist(slot(aa, "y.values"))
    tab$resultadov[1] <- aa
    write.table(x.nb, file=outpuClassifica, append=TRUE, row.names=FALSE, quote=FALSE)
} else
{
    print("UNKNOWN METHOD")
}
write.table(tab, file=outputFile, append=TRUE, row.names=FALSE, quote=FALSE)



# ----------- END --------------------------------------------------------------

# keep this to ensure file write and flush, useful for hadoop runs
flush.console()
Sys.sleep(3)
