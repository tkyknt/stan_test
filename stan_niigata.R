#パッケージ読み込み
library(inline) 
library(Rcpp)

require(rstan)

#作業フォルダの指定
setwd("C:/workspace/stan")

#データの読み込み
data <- read.csv("28boar_1.2.3.csv")
n_year <- nrow(data)
fa <- data$fa
capth <- data$capth
captp <- data$captp
captj <- data$captj
captw <- data$captw
j_person <- data$jperson
w_person <- data$wperson
capt <- data$capt
init_n <- data$init_n

data

#stan用にデータを整理
list.data <- list(
  NY = n_year ,
  ryo = capth ,
  kyo = captp ,
  wcpue = captw ,
  jcpue = captj ,
  jperson = j_person ,
  wperson = w_person ,
  CAPT = capt ,
  FA = fa
)
list.data

set.seed(1)

boar_model0.0.1 <- stan(
  file='niigata0.0.1.stan',
  data=list.data,
  iter=1500,
  warmup=500,
  thin=1,
  chains=3
)
