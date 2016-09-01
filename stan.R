install.packages('inline')
install.packages('Rcpp')

# Rtoolsを入れる
# https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows
# 確認
Sys.getenv('PATH')
system('g++ -v')

library(inline) 
library(Rcpp)

install.packages("rstan", dependencies = TRUE)

require(rstan)
Nile
NileData <- list(Nile = as.numeric(Nile), n=length(Nile))
NileData

localLevelModel_1 <- "
  data {
    int n;
    vector[n] Nile;
  }
  parameters {
    real mu;                # 確定的レベル（データの平均値）
    real<lower=0> sigmaV;   # 観測誤差の大きさ
  }
  model {
    for(i in 1:n) {
      Nile[i] ~ normal(mu, sqrt(sigmaV));
    }
  }
"


# 乱数の種
set.seed(1)

# 確定的モデル
NileModel_1 <- stan(
  model_code = localLevelModel_1,
  data=NileData,
  iter=1500,
  warmup=500,
  thin=1,
  chains=3
)

NileModel_1
traceplot(NileModel_1)
