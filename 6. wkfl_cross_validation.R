cv <- function(folds, metodo, tamanho = NULL, par_r = NULL, par_i =NULL) {
  val_temp = NULL
  
  for (i in 1:5)
  {
    cosmos_temp = NULL
    cosmos_acc = NULL
    cosmos_strat = NULL
    for (j in 1:10)
    {
      if (j==i)
      {
        next
      }
      cosmos_strat = folds[[j]]
      cosmos_acc = rbind(cosmos_temp, cosmos_strat)
      cosmos_temp = cosmos_acc
    }
    cosmos_part = folds_stratified[[i]]
    x.rn2 <- metodo(cosmos_acc, cosmos_part, tamanho, par_r=NULL, par_i=NULL)
    aa <- croc(x.rn2[,2], cosmos_part$alvo)
    aa <- unlist(slot(aa, "y.values"))
    val_acum = c(aa, val_temp)
    val_temp = val_acum
    
  }
  med <- mean(val_acum)
  vrc <- var(val_acum)
  aa <- med - vrc
  return(aa)  
}