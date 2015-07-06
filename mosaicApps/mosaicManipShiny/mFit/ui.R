# labels=list("Constant", "x", "x^2", "x^3", "log(x)", "exp(kx)", 
#             "pnorm1(mu1, sd)", "pnorm2(mu2, sd)",
#             "pnorm3(mu3, sd)","pnorm4(mu4, sd)","pnorm5(mu5, sd)",
#             "sin(2Pi*x/P)", "cos(2Pi*x/P)")
# controls = list(a1 = checkbox(TRUE, as.character(labels[1])))#const
# 
# for (s in 2:length(instructor)){
#   if( instructor[s] ) controls[[paste("a",s,sep="")]] = checkbox(FALSE, as.character(labels[s]))
# }
# if(instructor[6]) #exp
#   controls$k=slider(-2,2, step = .05, initial=0.1)
# if(instructor[12]|instructor[13]){ #sin, cos
#   controls$P=slider(.1,10, step = .01, initial = 5) 
#   controls$n=slider(1,20, step = 1, initial = 1)} 
# for(b in 1:5){ #pnorms
#   if(instructor[b+6])        
#     controls[[paste("mu",b,sep="")]] = slider(min(xvals),max(xvals), step =.1, initial = min(xvals)+b*diff(range(xvals))/6)
# }
# if(any(instructor[7:11])) controls$sd = slider(0.1, diff(range(xvals))/2, step = .1, initial = diff(range(xvals))/4)
# 
# 
# 
# manipulate(myPlot(k=k, n=n, P=P, mu1=mu1,mu2=mu2,mu3=mu3,mu4=mu4,mu5=mu5, 
#                   sd=sd, a1=a1, a2=a2, a3=a3, a4=a4, a5=a5, a6=a6, a7=a7, a8=a8, 
#                   a9=a9,a10=a10,a11=a11,a12=a12,a13=a13),
#            controls
# )

library(shiny)


shinyUI(fluidPage(
  titlePanel("Visualizing a Density Plot"),
  
  p(" Interactive applet for term selection and nonlinear parameters for fitting.
  Displays data and a menu of modeling functions.  Finds a linear combination
   of the selected modeling functions, with the user setting nonlinear
   parameters manually."),
  
  sidebarLayout(position = "right",
                sidebarPanel(
                  selectInput("data", "Please selet a dataset", choices = list("Galton", "KidsFeet")),
                  textInput("expr", "Please enter the expression for model"),
                  actionButton("reset", "Reset mu and sd"),
                  checkboxGroupInput("checkbox", label = "Please select the function that you want to fit with", choices = choices),
                  actionButton("plot", label = "Make a plot"),
                  sliderInput("k", label = h5("k"),
                              min = -2, max = 2, step = .05, value = 0.1),
                  
                  sliderInput("P", label = h5("P"),
                              min = .1, max = 10, step = .01, value = 5),
                  
                  sliderInput("n", label = h5("n"),
                              min = 1, max = 20, step = 1, value = 1), 
                  
                  lapply(1:5, function(i) {
                    sliderInput(paste0('mu', i), paste0('mu', i),
                                min = 7.9, max = 9.8, step =.1, value = 8)
                  }),
                  
                  sliderInput("sd", label = h5("sd"),
                              min = 0.1, max = 3, step = .1, value = 0.5)
                ),
                
                mainPanel (
                  plotOutput("graph")
                )
                
                )
                
              
  )
  
)
