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
	real<lower=0> n[NY];
	real<lower=0, upper=1> prp;
	real<lower=0, upper=1> pkp[NY];
	real lprp;
	real lpkp1;
	real lpjp;
	real lpwp;
  real<lower=0> mu_ryo[NY];
	real<lower=0> mu_kyo[NY];
	real<lower=0> mu_jcpue[NY];
	real<lower=0> mu_wcpue[NY];
	real<lower=0> log_n0;
  real<lower=0> r;
  real log_r;
  real<lower=0> k;
  real log_k;
	real<lower=0, upper=100> tau_ryo;
	real<lower=0, upper=100> tau_kyo;
	real<lower=0, upper=100> tau_jcpue;
	real<lower=0, upper=100> tau_wcpue;
	real<lower=0, upper=100> tau_ran_pkp;
}
model {
  vector[NY] max_n;
  vector[NY] mu_n;
  real n0;
  real B;
	vector[NY] lpkp;
  vector[NY] lmu_ryo;
  vector[NY] lmu_kyo;
  vector[NY] lmu_jcpue;
  vector[NY] lmu_wcpue;

  log(n[1]) ~ normal(6.907 , 3.3);
  log_k ~ normal(4.605 , 1);
  log_r ~ normal(0.322 , 0.03);
  lpkp[1] ~ normal(0,1000);
  lprp ~ normal(0,1000);
  lpjp ~ normal(0,1000);
  lpwp ~ normal(0,1000);
  
  B = (exp(log_r)-1) / (exp(log_k)*FA[10]);

  for(i in 2:NY){
    mu_n[i] = exp(log_r) * n[i-1]/(1 + B*n[i-1]);
    max_n[i] ~ poisson(mu_n[i]);
    n[i] = max_n[i] - CAPT[i];
    
    lmu_ryo[i] ~ normal(log(inv_logit(lprp) * n[i]) ,tau_ryo);
    ryo[i] ~ poisson(exp(lmu_ryo[i]));
    
    lpkp[i] ~ normal(lpkp[i-1],tau_ran_pkp);
    lmu_kyo[i] ~ normal(log(inv_logit(lpkp[i]) * n[i]),tau_kyo);
    kyo[i] ~ poisson(exp(lmu_kyo[i]));

    lmu_jcpue[i] ~ normal(log(exp(lpjp) * n[i] * jperson[i] / FA[i]),tau_jcpue);    
    jcpue[i] ~ poisson(exp(lmu_jcpue[i]));

    lmu_wcpue[i] ~ normal(log(exp(lpwp) * n[i] * wperson[i] / FA[i]),tau_wcpue);
    wcpue[i] ~ poisson(exp(lmu_wcpue[i]));
  }
}
