# first.val = ncol(data)*3+20 # heuristic to get enough degrees of freedom
#step.size = round( max(1,nrow(data)/200)) # heuristic to get a nice number of steps
#first.val = first.val - ((first.val + ncol(data)) %% step.size)
# controls=list(n=slider(first.val, 5*nrow(data), step=step.size, initial=nrow(data), label="n points to sample"))


# for(a in 1:length(xvars.data)){
#   controls[[paste("A", a, sep="")]]=checkbox(FALSE, label=xvars.data[a])
# }    label based on Datasets


# controls$seed = slider(100,500,step=1, initial=sample(100:500,1), label="Random seed")
# controls$signif = slider(.5,.99,step=.01, initial=0.95, label="Significance level")
# controls$use.orig = checkbox(initial=FALSE,label="Use Original Data")

datasets <- list( Galton = Galton, Heightweight = Heightweight,
                  SwimRecords = SwimRecords, TenMileRace = TenMileRace)


library(shiny)

shinyUI(fluidPage(
  titlePanel("mBias "),
  
  p("XXX"),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  
                  
                  sliderInput("n", label = h4("npoints to sample"),
                              min =  ncol(data)*3+20, max = nrow(data), step = round( max(1,nrow(data)/200)), value = nrow(data)),
                  
                  br(),
                  
                  checkboxGroupInput("nvars", label = h4("Number of Euler steps to take"),
                              choices = names(datasets)),
                  
                  br(),
                  
                  sliderInput("seed", label = h4("Random Seed"),
                              min = 100, max = 500 , step = 1, value = sample(100:500,1)),
                  br(),
                  
                  sliderInput("signif", label = h4("Significance level"),
                              min = 0.5, max = .95 , step = .01, value = 0.5),
                  br(),
                  
                  checkboxInput("use.orig", label = h4("Use Original Data"), value = FALSE),
                  
                  br() 
                  
                ),
                
                
                mainPanel(
                  br(),
                  plotOutput("graph")
                )
  )
  
))



# 
# manipulate(myFun(n=n, seed=seed, signif=signif, use.orig=use.orig, checks=c(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
#                                                                             A15, A16, A17, A18, A19, A20)),
#            controls)