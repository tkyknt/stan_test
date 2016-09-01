data {
	int<lower=0> NY;
	int ryo[NY];
	int kyo[NY];
	int wcpue[NY];
  int jcpue[NY];
	int jperson[NY];
	int wperson[NY];
	int CAPT[NY];
	int FA[NY];
}
parameters {
	int<lower=0> n[NY];
	real<lower=0, upper=1> prp;
	real<lower=0, upper=1> pkp[NY];
	real lprp;
	real lpkp1;
  real<lower=0> mu.ryo[NY];
	real<lower=0> mu.kyo[NY];
	real<lower=0> mu.jcpue[NY];
	real<lower=0> mu.wcpue[NY];
	real<lower=0> log.n0;
  real<lower=0> r;
  real log.r;
  real<lower=0> k;
  real log.k;
	real<lower=0, upper=100> tau.ryo;
	real<lower=0, upper=100> tau.kyo;
	real<lower=0, upper=100> tau.jcpue;
	real<lower=0, upper=100> tau.wcpue;
	real<lower=0, upper=100> tau.ran.pkp;
}
model {
  int<lower=0> max.n[NY];
  real<lower=0> mu.n;
  real<lower=0> n0;
  real<lower=0> B;
	real lpkp[NY];
  real lmu.ryo[NY];
  real lmu.kyo[NY];
  real lmu.jcpue[NY];
  real lmu.wcpue[NY];

  log.n0 ~ normal(6.907 , 3.3);
  log.k ~ normal(4.605 , 1);
  log.r ~ normal(0.322 , 0.03);
  lpkp[1] ~ normal(0,1000);
  lprp ~ normal(0,1000);
  lpjp ~ normal(0,1000);
  lpwp ~ normal(0,1000);
  
  n[1] <- trunc(exp(log.n0);
  B <- (exp(log.r)-1) / (exp(log.k)*FA[10]);

  for(i in 2:NY){
    mu.n[i] <- exp(log.r) * n[i-1]/(1 + B*n[i-1]);
    max.n[i] ~ poisson(mu.n[i]);
    n[i] <- max.n[i] - CAPT[i];
    
    lmu.ryo[i] ~ normal(log(inv_logit(lprp) * n[i]) ,tau.ryo);
    ryo[i] ~ poisson(exp(lmu.ryo[i]));
    
    lpkp[i] ~ normal(lpkp[i-1],tau.ran.pkp);
    lmu.kyo[i] ~ normal(log(inv_logit(lpkp[i]) * n[i]),tau.kyo);
    kyo[i] ~ poisson(exp(lmu.kyo[i]));

    lmu.jcpue[i] ~ normal(log(exp(lpjp) * n[i] * jperson[i] / FA[i]),tau.jcpue);    
    jcpue[i] ~ poisson(exp(lmu.jcpue[i]));

    lmu.wcpue[i] ~ normal(log(exp(lpwp) * n[i] * wperson[i] / FA[i]),tau.wcpue);
    wcpue[i] ~ poisson(exp(lmu.wcpue[i]));
  }
}