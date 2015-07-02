library(mosaicData)

datasets <- list("Galton" = Galton, "Kidsfeet" = KidsFeet)

choices <- list("Constant" = 1, "x" = 2, "x^2" = 3, "x^3" = 4, "log(x)" = 5, "exp(kx)" = 6, 
                "pnorm1(mu1, sd)" = 7, "pnorm2(mu2, sd)" = 8,
                "pnorm3(mu3, sd)" = 9,"pnorm4(mu4, sd)" = 10,"pnorm5(mu5, sd)" = 11,
                "sin(2Pi*x/P)" = 12, "cos(2Pi*x/P)" = 13)


f = list()
f[[1]] = function(x,...) rep.int(1, length(x))
f[[2]] = function(x,...) x
f[[3]] = function(x,...) x^2
f[[4]] = function(x,...) x^3
f[[5]] = function(x,...) log(abs(x)+.000001)

f[[6]] = function(x, k, ...) exp(k*x)
f[[7]] = function(x, mu, sd, ...) pnorm(q = x, mean = mu1, sd = sd)
f[[8]] = function(x, mu, sd, ...) pnorm(q = x, mean = mu2, sd = sd)
f[[9]] = function(x, mu, sd, ...) pnorm(q = x, mean = mu3, sd = sd)
f[[10]] = function(x, mu, sd, ...) pnorm(q = x, mean = mu4, sd = sd)
f[[11]] = function(x, mu, sd, ...) pnorm(q = x, mean = mu5, sd = sd)

# The sines and cosines MUST go at the end since they are duplicated with a slider
f[[12]] = function(x, P, n, ...){
  res = matrix(0,nrow=length(x),ncol=n)
  for(j in 1:n) {res[,j] = sin(2*j*pi*x/P)}
  return(res)
}
f[[13]] = function(x, P, n, ...){
  res = matrix(0,nrow=length(x),ncol=n)
  for(j in 1:n) {res[,j] = cos(2*j*pi*x/P)}
  return(res)
}
# 
# mu1=0; mu2=0;mu3=0; mu4=0; mu5=0;
# a1=FALSE; a2=FALSE; a3=FALSE; a4 = FALSE; a5 = FALSE; a6 = FALSE; a7 = FALSE; a8 = FALSE; 
# a9 = FALSE; a10 = FALSE; a11 = FALSE; a12=FALSE; a13 = FALSE; a14 = FALSE;
# funchoice = c(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, 
#               a11, a12, a13)




