#作業???ィレクトリ設???
setwd("C:/workspace")

## ---WinBUGS に???ータを引き渡すR のパッケージの読みこみ
library(R2WinBUGS)

## ---WinBUGS スクリプト???付表2 のファイル名）
filename <- "28_boar_n_model0.9.txt"

## ---WinBUGS プログラ???のフォルダ??????
bugs.directory <- "C:/Program Files/WinBUGS14"

## --- 事後??????を抽出するパラメータの??????
parameter <- c("r","log.r","n","log.n0","k","log.k","prp","pkp","pjp","pwp","lpkp1")


##???ータ読み込み
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

##WinBUGS用の???ータの編???
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

##初期値の設???
init_max.n <- rep(NA,n_year)
init_mu.ryo <- rep(NA,n_year)
init_mu.kyo <- rep(NA,n_year)
init_mu.wcpue <- rep(NA,n_year)
init_mu.jcpue <- rep(NA,n_year)
init_lpkp <- rep(NA,n_year)

init_max.n <- init_n +capt

for(i in 2:n_year){
  init_mu.ryo[i] <- capth[i]
  init_mu.kyo[i] <- captp[i]
  init_mu.wcpue[i] <- captw[i]
  init_mu.jcpue[i] <- captj[i]
  init_lpkp[i] <- 0
}

init_n[1] <- NA
init_max.n[1] <- NA
init_lpkp[1] <- NA

#初期値の編???
list.inits <- function(){list(
  mu.ryo = init_mu.ryo ,
  mu.kyo = init_mu.kyo ,
  mu.wcpue = init_mu.wcpue ,
  mu.jcpue = init_mu.jcpue ,
  lpkp = init_lpkp,
  max.n = init_max.n ,
  log.r = 0.322 ,
  log.n0 = 6.907 ,
  log.k = 4.605 ,
  lpkp1 = 0 ,
  lprp = 0 ,
  lpjp = 0 ,
  lpwp = 0 ,
  tau.ryo = 1 ,
  tau.kyo = 1 ,
  tau.jcpue = 1 ,
  tau.wcpue = 1 ,
  tau.ran.pkp = 1
)}



#500000-10000-1000
time <- system.time(
  post.bugs <- bugs(list.data, list.inits, parameter, model.file = filename,
                    n.chains = 3, n.iter=500000, n.burnin = 10000, n.thin = 100, debug = TRUE,bugs.seed = round(runif(1, -10^6, 10^6)),
                    bugs.directory = bugs.directory))

#1000000-500000-1000
time <- system.time(
  post.bugs <- bugs(list.data, list.inits, parameter, model.file = filename,
                    n.chains = 3, n.iter=10000000, n.burnin = 5000000, n.thin = 1000, debug = TRUE,bugs.seed = round(runif(1, -10^6, 10^6)),
                    bugs.directory = bugs.directory))




#
FileNameHead <- strtrim(filename,width=nchar(filename)-4)
PresentTime <- format(Sys.time(),"%Y%m%d_%H%M%S")
CodaFolderName <- paste("Coda_",FileNameHead,"_",PresentTime,sep = "")
dir.create(CodaFolderName)
TempFolder <- tempdir()
List<-list.files(TempFolder)
FileN <- length(List)
f<-CodaFileName<-NA
for (i in 1:FileN){
  CodaFileName <- List[i]
  f <- paste(TempFolder,"\\",CodaFileName,sep="")
  file.copy(f,CodaFolderName)
}


post.mcmc<-as.mcmc(post.bugs$sims.matrix)
write.csv(summary(post.mcmc)[[2]],"result.csv")
file.copy("result.csv",CodaFolderName)
file.remove("result.csv")

m1 <- mcmc.list(
  as.mcmc(post.bugs$sims.array[,1,]),
  as.mcmc(post.bugs$sims.array[,2,]),
  as.mcmc(post.bugs$sims.array[,3,]))

gelman.diag(m1,multivariate=FALSE)
gelman.diag(m1)
geweke.diag(m1)

help(gelman.diag)



plot(m1)


