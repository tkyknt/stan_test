install.packages('inline')
install.packages('Rcpp')

# Rtools������
# https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows
# �m�F
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
    real mu;                # �m��I���x���i�f�[�^�̕��ϒl�j
    real<lower=0> sigmaV;   # �ϑ��덷�̑傫��
  }
  model {
    for(i in 1:n) {
      Nile[i] ~ normal(mu, sqrt(sigmaV));
    }
  }
"


# �����̎�
set.seed(1)

# �m��I���f��
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