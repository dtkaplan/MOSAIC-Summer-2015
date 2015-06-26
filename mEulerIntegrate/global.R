logistic = function(x,t=0){.2*x*(1-x)}
exponential = function(x,t=0){ -.8*x }
gompertz = function(x,t=0){exp(-t/3)*.2*x}
cooling = function(x,t=0){-.1*(x-.7)}
cows = function(v,t=0){H=10; r=1/3; K=25; beta=0.1; V0=3; r*v*(1-v/K) - H*beta*v^2/(V0^2+v^2)}
pills = function(x,t=0){dose=1; dur=0.5; interval=5; -0.2*x + dose*(((t+1)%%interval)<dur)} 









