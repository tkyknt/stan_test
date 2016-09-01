#�p�b�P�[�W�ǂݍ���
library(inline) 
library(Rcpp)

require(rstan)

#��ƃt�H���_�̎w��
setwd("C:/workspace/stan")

#�f�[�^�̓ǂݍ���
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

#stan�p�Ƀf�[�^�𐮗�
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

